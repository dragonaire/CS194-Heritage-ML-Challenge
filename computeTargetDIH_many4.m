function [target_DIH c vars] = computeTargetDIH_many4(ages,genders,logDIH,...
    ages_test,genders_test,drugs_train,drugs_test,lab_train,lab_test,cond_train,cond_test,...
    proc_train,proc_test,los_train,los_test,...
    spec_train,spec_test,place_train,place_test)
constants;
ZSCORE = false; %TODO must use same means and vars for both A and M
KERNEL = false;
num_pc = 141;  % cutoff for number of components to use
try
    load('alkjsdfdsal');
    %load('many1.mat');
catch
    offsets = [...
        SIZE.AGE*SIZE.SEX,...%1,...% a constant
        SIZE.DRUG_1YR,...
        SIZE.LAB_1YR,...
        SIZE.COND_GROUP,...
        SIZE.PROCEDURE,...
        SIZE.LoS,...
        SIZE.SPECIALTY,...
        SIZE.PLACE,...
        ];
    offsets = cumsum(offsets);
    offsets = [0; offsets(1:end)'];

    agesex = ages + 10*(genders-1);
    nrows = length(agesex);
    ncols = offsets(2);
    m = length(ages);
    n = offsets(end);
    rows_i = 1:length(agesex);
    cols_i = agesex;
    val = 1;

    % map the data to a new space
    drugs_train = drugMap(drugs_train);
    drugs_test = drugMap(drugs_test);
    lab_train = labMap(lab_train);
    lab_test = labMap(lab_test);
    cond_train = condMap(cond_train);
    cond_test = condMap(cond_test);
    proc_train = procMap(proc_train);
    proc_test = procMap(proc_test);
    los_train = losMap(los_train);
    los_test = losMap(los_test);
    spec_train = specMap(spec_train);
    spec_test = specMap(spec_test);
    place_train = placeMap(place_train);
    place_test = placeMap(place_test);

    A = [full(sparse(rows_i, cols_i, val, nrows, ncols)), ...%ones(m,1), ...
        drugs_train, lab_train, cond_train, proc_train, los_train,...
        spec_train, place_train];
    if KERNEL
        A = sparse(A);
        A = kernel(A,1);
        n = n*n;
    end
    A = full(A);
    if ZSCORE
        A = zscore(A);
    end
    [pc,scores,vars] = princomp(A);
    [m, n] = size(A);
    A_means = ones(m,1)*mean(A);
    A_pca = scores(:,1:num_pc)*pc(:,1:num_pc)' + A_means;
    %A_pca = scores*pc' + A_means;
    
    disp('starting cvx');
    %A=sparse(A);
    LosMatrix = -diag(ones(SIZE.LoS-3,1),1)+eye(SIZE.LoS-2);
    cvx_begin quiet
        variables c(n);
        minimize(norm(A_pca*c - logDIH))
        subject to
        %
    cvx_end
    if ~strcmp(cvx_status,'Solved') && ~strcmp(cvx_status,'Inaccurate/Solved')
        'computeTargetDIH_many4 failed'
        keyboard
    end
    optval = norm(A*c-logDIH);
    %fprintf('computeTargetDIH_many4 TRAINING ERROR: %f\n',sqrt((cvx_optval^2)/m));
    fprintf('computeTargetDIH_many4 TRAINING ERROR: %f\n',sqrt((optval^2)/m));
    
    agesex_test = ages_test + 10*(genders_test-1);
    agesex_test = sparse(1:length(ages_test), agesex_test, 1, length(ages_test), SIZE.AGE*SIZE.SEX);
    M = sparse([agesex_test,drugs_test,lab_test,cond_test,proc_test,los_test,...
        spec_test,place_test]);
    M = full(M);
    if ZSCORE
        M = zscore(M);
    end
    [pc,scores,vars] = princomp(M);
    
    M_means = ones(size(M,1),1)*mean(M);
    M_pca = scores(:,1:num_pc)*pc(:,1:num_pc)' + M_means;
end
%keyboard
c = hillClimb3(A_pca,c,logDIH);
target_DIH = M_pca*c;
target_DIH = exp(target_DIH)-1;
end
%TODO these functions make the arrays unsparse. Subtract the min value to
%make them sparse again
function x = condMap(x)
c=1.75;
x = sparse(log(x+c)-log(c));
end
function x = procMap(x)
c=1.1;
x = sparse(log(x+c)-log(c));
end
function x = drugMap(x)
c=0.5;
x = sparse(log(x+c)-log(c));
%x = log(sqrt(x)+6);
%x = sqrt(x);
end
function x = labMap(x)
%x = sparse(x.^1.1);
end
function x = losMap(x)
x = sparse(x.^0.78);
%x = sparse(x.^3.5);
%x = sqrt(x);
%x(:,27) = min(1,x(:,27));
end
function x = specMap(x)
%x = sqrt(x);
x = sparse(x.^0.79);
end
function x = placeMap(x)
%x = sqrt(x);
x = sparse(log(x+0.4)-log(0.4));
end