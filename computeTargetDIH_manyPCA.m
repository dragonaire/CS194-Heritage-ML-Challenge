function [target_DIH,c] = computeTargetDIH_manyPCA(num_pc, ages,genders,logDIH,...
    ages_test,genders_test,drugs_train,drugs_test,lab_train,lab_test,cond_train,cond_test,...
    proc_train,proc_test,los_train,los_test,charlson_train,charlson_test,...
    spec_train,spec_test,place_train,place_test)

% using PCA, w/o charlson

%{
num_pca = 147;  % cutoff for number of components to use
[target_DIH,c] = computeTargetDIH_manyPCA(num_pca,ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
    drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
    claims.f3.condGroup,claims.f4.condGroup,claims.f3.procedure,claims.f4.procedure,...
    claims.f3.LoS,claims.f4.LoS,claims.f3.charlson,claims.f4.charlson,...
    claims.f3.specialty,claims.f4.specialty,claims.f3.place,claims.f4.place);
target.DIH = target_DIH;
writeTarget(sprintf('Target_pca%d.csv', num_pca),target);
%}
    
constants;
try
    load('alkjsdfdsal');
    %load('many1.mat');
catch
    offsets = [...
        SIZE.AGE*SIZE.SEX,...
        SIZE.DRUG_1YR,...
        SIZE.LAB_1YR,...
        SIZE.COND_GROUP,...
        SIZE.PROCEDURE,...
        SIZE.LoS,...
        SIZE.CHARLSON,...
        SIZE.SPECIALTY,...
        SIZE.PLACE,...
        ];
    offsets = cumsum(offsets);
    offsets = [0; offsets(1:end)'];

    agesex = ages + 10*(genders-1);
    nrows = length(agesex);
    ncols = offsets(2);
    %n = offsets(end);
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
    %charlson_train = charlsonMap(charlson_train);
    %charlson_test = charlsonMap(charlson_test);
    spec_train = specMap(spec_train);
    spec_test = specMap(spec_test);
    place_train = placeMap(place_train);
    place_test = placeMap(place_test);
  
    A = [full(sparse(rows_i, cols_i, val, nrows, ncols)), ...
        drugs_train, lab_train, cond_train, proc_train, los_train, ...
        spec_train, place_train];
    A = full(A);
    A_means = ones(size(A,1),1)*mean(A);
    [pc, scores] = princomp(A);
    A_pca = scores(:,1:num_pc)*pc(:,1:num_pc)' + A_means;
    %A_pca = scores*pc' + A_means;   
    
    %LosMatrix = -diag(ones(SIZE.LoS-3,1),1)+eye(SIZE.LoS-2);
    %Charlson = -diag(ones(SIZE.CHARLSON-1,1),1)+eye(SIZE.CHARLSON);
    fprintf('Optimizing with cvx...\n');
    cvx_begin quiet
        variables c(num_pc);
        minimize(norm(A_pca*c - logDIH))
        %subject to
            %c(31:end) >= 0;
            %c(offsets(3:end)) == 0;
            %c(112:125) == 0; % for not using los
            % LoS is of increasing badness. except for last 2 columns which had missing data
            %LosMatrix*c(112:123) <= 0;
            %Charlson*c(126:130) <= 0; % charlson index is of increasing badness
            %c(126:130) == 0; % for not using charlson index
    cvx_end
    if ~strcmp(cvx_status,'Solved') && ~strcmp(cvx_status,'Inaccurate/Solved')
        'computeTargetDIH_manyPCA failed'
        keyboard
    end
    fprintf('computeTargetDIH_manyPCA TRAINING ERROR: %f\n',sqrt((cvx_optval^2)/NUM_TARGETS));

    agesex_test = ages_test + 10*(genders_test-1);
    agesex_test = sparse(1:length(ages_test), agesex_test, 1, length(ages_test), SIZE.AGE*SIZE.SEX);
    M = sparse([agesex_test,drugs_test,lab_test,cond_test,proc_test,los_test,...
        spec_test,place_test]);
    M = full(M);
    M_means = ones(size(M,1),1)*mean(M);
    [pc, scores] = princomp(M);
    M_pca = scores(:,1:num_pc)*pc(:,1:num_pc)' + M_means;
    %M_pca = scores*pc' + M_means;  
    %save('manyPCA.mat','A','A_pca','c','M','M_pca');
 
end
%keyboard
c = hillClimb3(A_pca,c,logDIH);
target_DIH = M_pca*c;  % TODO map back from PCA to logDIH space
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
x = sparse(log(x+0.5)-log(0.5));
%x = log(sqrt(x)+6);
%x = sqrt(x);
end
function x = labMap(x)
x = sparse(x.^1.1);
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
function c = hillClimb(A,c,logDIH)
constants;
STEP = 0.000025;
OVERFIT = 0.65;
indices = 1:19; 
v = A*c;
old = norm(max(max(v,MIN_PREDICTION)-logDIH,OVERFIT));
for iter=1:13
    change = false;
    for i=indices
        %TODO should be 
        % norm(max(abs(max(A*c,MIN_PREDICTION)-logDIH),OVERFIT));
        % for some reason the abs is detrimental
        v1 = v + STEP*A(:,i);
        new1 = norm(max(max(v1,MIN_PREDICTION)-logDIH,OVERFIT));
        v2 = v - STEP*A(:,i);
        new2 = norm(max(max(v2,MIN_PREDICTION)-logDIH,OVERFIT));
        if new1 < old && new1 < new2
            change=true;
            c(i) = c(i) + STEP;
            v=v1;
            old=new1;
        elseif new2 < old && new2 < new1
            change=true;
            c(i) = c(i) - STEP;
            v=v2;
            old=new2;
        end 
    end
    if ~change
        break
    end
    vtrain = sqrt(mean((max(A*c,MIN_PREDICTION)-logDIH).^2));
    %disp(sprintf('%d: index %d, train: %f',iter,i,vtrain));
end
end
function c = hillClimb2(A,c,logDIH)
constants;
STEP = 0.0005;
GRAD = 1;
OVERFIT = 0;%0.65;
%indices = [1:111,126:152];
indices = 1:152;
disp(sprintf('0: train: %f',sqrt(mean((max(A*c,MIN_PREDICTION)-logDIH).^2))));
v = A*c;
for iter=1:100
    old = norm(max(abs(max(v,MIN_PREDICTION)-logDIH),OVERFIT));
    step = zeros(size(c));
    for i=indices
        %TODO should be 
        % norm(max(abs(max(A*c,MIN_PREDICTION)-logDIH),OVERFIT));
        % for some reason the abs is detrimental
        new1 = norm(max(abs(max(v + STEP*A(:,i),MIN_PREDICTION)-logDIH),OVERFIT));
        new2 = norm(max(abs(max(v - STEP*A(:,i),MIN_PREDICTION)-logDIH),OVERFIT));
        if new1 < old && new1 < new2
            step(i) = old-new1;
        elseif new2 < old && new2 < new1
            step(i) = -(old-new2);
        end 
    end
    if step==0
        break;
    end
    step = step/norm(step);
    c = c + STEP*step;
    v = A*c;
    %c(i) = c(i) + step(i);
    %v = v + step(i)*A(:,i);
    %old = val(i);
    %old_vtrain = vtrain;
    vtrain = sqrt(mean((max(A*c,MIN_PREDICTION)-logDIH).^2));
    %disp(sprintf('%d: index %d, train: %f, steplen: %f',iter,i,vtrain,STEP));
end
end
function c = hillClimb3(A,c,logDIH)
constants;
STEP = 0.000025;
OVERFIT = 0.0;%0.65;
%indices = [1:111,126:152];
indices = 1:19;
v = A*c;
old = norm(max(abs(max(v,MIN_PREDICTION)-logDIH),OVERFIT));
for iter=1:100
    change = 0;
    for i=indices
        v1 = v + STEP*A(:,i);
        new1 = norm(max(abs(max(v1,MIN_PREDICTION)-logDIH),OVERFIT));
        v2 = v - STEP*A(:,i);
        new2 = norm(max(abs(max(v2,MIN_PREDICTION)-logDIH),OVERFIT));
        if new1 < old && new1 < new2
            change=old-new1;
            c(i) = c(i) + STEP;
            v=v1;
            old=new1;
        elseif new2 < old && new2 < new1
            change=old-new1;
            c(i) = c(i) - STEP;
            v=v2;
            old=new2;
        end 
    end
    if change <= 0
        break
    end
    vtrain = sqrt(mean((max(A*c,MIN_PREDICTION)-logDIH).^2));
    %disp(sprintf('%d: index %d, train: %f',iter,i,vtrain,));
end
end