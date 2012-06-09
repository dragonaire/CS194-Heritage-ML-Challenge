function [target_DIH c vars] = computeTargetDIH_n1(ages,genders,logDIH,...
    ages_test,genders_test,ndrugs_train,ndrugs_test,nlab_train,nlab_test,nprov_train,nprov_test,...
    nvend_train,nvend_test,npcp_train,npcp_test,extralos_train,extralos_test,...
    nclaims_train,nclaims_test)
constants;
%ZSCORE = false; %TODO must use same means and vars for both A and M
%num_pc = 130;  % cutoff for number of components to use (max 165)

offsets = [...
    SIZE.AGE*SIZE.SEX,...
    SIZE.EXTRA-1,... % ndrug
    SIZE.EXTRA-1,... % nlab
    1,... % nprov
    1,... % nvend
    1,... %npcp
    SIZE.EXTRA,...
    SIZE.NCLAIMS,...
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
ndrugs_train = drugMap(ndrugs_train);
ndrugs_test = drugMap(ndrugs_test);
nlab_train = nlabMap(nlab_train);
nlab_test = nlabMap(nlab_test);
nprov_train = nprovMap(nprov_train);
nprov_test = nprovMap(nprov_test);
nvend_train = nvendMap(nvend_train);
nvend_test = nvendMap(nvend_test);
npcp_train = npcpMap(npcp_train);
npcp_test = npcpMap(npcp_test);
extralos_train = extralosMap(extralos_train);
extralos_test = extralosMap(extralos_test);
nclaims_train = nclaimsMap(nclaims_train);
nclaims_test = nclaimsMap(nclaims_test);

A = [full(sparse(rows_i, cols_i, val, nrows, ncols)), ...
    ndrugs_train, nlab_train, nprov_train, nvend_train,...
    npcp_train,extralos_train,nclaims_train];
A_pca=sparse(A);
[m, n] = size(A);
%{
A = full(A);
if ZSCORE
    [pc,scores,vars] = princomp(zscore(A));
end
[pc,scores,vars] = princomp(A);

A_means = ones(m,1)*mean(A);
A_pca = scores(:,1:num_pc)*pc(:,1:num_pc)' + A_means;
%A_pca = scores*pc' + A_means;   
%}
disp('starting cvx');
cvx_clear;
cvx_begin quiet
    variables c(n);
    minimize(norm(A_pca*c - logDIH))
    subject to
cvx_end
if ~strcmp(cvx_status,'Solved') && ~strcmp(cvx_status,'Inaccurate/Solved')
    'computeTargetDIH_n1 failed'
    keyboard
end
err = sqrt(mean((logDIH-postProcess(A_pca*c)).^2));
fprintf('computeTargetDIH_n1 TRAINING ERROR: %f\n',err);

agesex_test = ages_test + 10*(genders_test-1);
agesex_test = sparse(1:length(ages_test), agesex_test, 1, length(ages_test), SIZE.AGE*SIZE.SEX);
M = sparse([agesex_test,ndrugs_test,nlab_test,nprov_test,nvend_test,...
    npcp_test,extralos_test,nclaims_test]);
M_pca = sparse(M);
%{
M = full(M);
if ZSCORE
    [pc,scores,vars] = princomp(zscore(M));
end
[pc,scores,vars] = princomp(M);

M_means = ones(size(M,1),1)*mean(M);
M_pca = scores(:,1:num_pc)*pc(:,1:num_pc)' + M_means;
%}
%keyboard
c = hillClimb3(A_pca,c,logDIH);
err = sqrt(mean((logDIH-postProcess(A_pca*c)).^2));
fprintf('computeTargetDIH_n1 HILLCLIMB TRAINING ERROR: %f\n',err);
target_DIH = M_pca*c;
target_DIH = exp(target_DIH)-1;
end
%TODO these functions make the arrays unsparse. Subtract the min value to
%make them sparse again
function x = nprovMap(x)
x = x.^2.0;
end
function x = nvendMap(x)
end
function x = drugMap(x)
end
function x = nlabMap(x)
end
function x = extralosMap(x)
x = x.^0.8;
end
function x = npcpMap(x)
x = x.^0.9;
end
function x = nclaimsMap(x)
x = x.^0.82;
end
