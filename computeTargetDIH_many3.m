function [target_DIH c] = computeTargetDIH_many3(ages,genders,logDIH,...
    ages_test,genders_test,drugs_train,drugs_test,lab_train,lab_test,cond_train,cond_test,...
    proc_train,proc_test,los_train,los_test,charlson_train,charlson_test,...
    spec_train,spec_test,place_train,place_test,dsfs_train,dsfs_test)
constants;
ZSCORE = true;
KERNEL = false;
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
        SIZE.CHARLSON,...
        SIZE.SPECIALTY,...
        SIZE.PLACE,...
        SIZE.DSFS,...
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
    charlson_train = charlsonMap(charlson_train);
    charlson_test = charlsonMap(charlson_test);
    spec_train = specMap(spec_train);
    spec_test = specMap(spec_test);
    place_train = placeMap(place_train);
    place_test = placeMap(place_test);
    dsfs_train = dsfsMap(dsfs_train);
    dsfs_test = dsfsMap(dsfs_test);

    A = [full(sparse(rows_i, cols_i, val, nrows, ncols)), ...%ones(m,1), ...
        drugs_train, lab_train, cond_train, proc_train, los_train, charlson_train,...
        spec_train, place_train, dsfs_train];
    if KERNEL
        A = sparse(A);
        A = kernel(A,1);
        n=n*n;
    end
    A = full(A);
    if ZSCORE
        [pc,scores,latent] = princomp(zscore(A));
    else
        [pc,scores,latent] = princomp(A);
    end
    A = zeros(size(A));
    for i=1:n
        A = A + scores(:,i)*pc(:,i)';
    end
    disp('starting cvx');
    %A=sparse(A);
    LosMatrix = -diag(ones(SIZE.LoS-3,1),1)+eye(SIZE.LoS-2);
    Charlson = -diag(ones(SIZE.CHARLSON-1,1),1)+eye(SIZE.CHARLSON);
    cvx_begin quiet
        variables c(n);
        minimize(norm(A*c - logDIH))
        subject to
            %c(31:end) >= 0;
            %c(offsets(3:end)) == 0;
            %c(112:125) == 0; % for not using los
            % LoS is of increasing badness. except for last 2 columns which had missing data
            %LosMatrix*c(112:123) <= 0;
            Charlson*c(126:130) <= 0; % charlson index is of increasing badness
            %c(126:130) == 0; % for not using charlson index
            c(153:165) == 0; % for not using DSFS
    cvx_end
    if ~strcmp(cvx_status,'Solved') && ~strcmp(cvx_status,'Inaccurate/Solved')
        'computeTargetDIH_many3 failed'
        keyboard
    end
    disp(sprintf('computeTargetDIH_many3 TRAINING ERROR: %f',sqrt((cvx_optval^2)/m)))

    c_agesex = c(offsets(1)+1:offsets(2));
    c_drugs = c(offsets(2)+1:offsets(3));
    c_lab = c(offsets(3)+1:offsets(4));
    c_cond = c(offsets(4)+1:offsets(5));
    c_proc = c(offsets(5)+1:offsets(6));
    c_los = c(offsets(6)+1:offsets(7));
    c_charlson = c(offsets(7)+1:offsets(8));
    c_spec = c(offsets(8)+1:offsets(9));
    c_place = c(offsets(9)+1:offsets(10));

    agesex_test = ages_test + 10*(genders_test-1);
    agesex_test = sparse(1:length(ages_test), agesex_test, 1, length(ages_test), SIZE.AGE*SIZE.SEX);
    M = sparse([agesex_test,drugs_test,lab_test,cond_test,proc_test,los_test,charlson_test,...
        spec_test,place_test,dsfs_test]);
    %save('many1.mat','A','c','M');
    if ZSCORE
        M = zscore(M);
    end
end
%keyboard
c = hillClimb3(A,c,logDIH,152);
target_DIH = M*c;
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
function x = charlsonMap(x)
x = sparse(x.^0.9);
%x = sqrt(x);
%x = log(x+1);
end
function x = specMap(x)
%x = sqrt(x);
x = sparse(x.^0.79);
end
function x = placeMap(x)
%x = sqrt(x);
x = sparse(log(x+0.4)-log(0.4));
end
function x = dsfsMap(x)
end
