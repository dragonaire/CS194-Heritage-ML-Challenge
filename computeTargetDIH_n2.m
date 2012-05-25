function [target_DIH c vars] = computeTargetDIH_n2(ages,genders,logDIH,...
    ages_test,genders_test,ndrugs_train,ndrugs_test,nlab_train,nlab_test,nprov_train,nprov_test,...
    nvend_train,nvend_test,npcp_train,npcp_test,extralos_train,extralos_test,...
    nclaims_train,nclaims_test,nspec_train,nspec_test,nplace_train,nplace_test,...
    nproc_train,nproc_test,ncond_train,ncond_test,extradsfs_train,extradsfs_test,...
    exchar_train,exchar_test,extraprob_train,extraprob_test)
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
    1,... % nclaims
    1,... % nspec
    1,... % nplace
    1,... % nproc
    1,... % ncond
    SIZE.EXTRADSFS,...
    SIZE.EXTRACHARLSON,...
    SIZE.EXTRAPROB,...
    ];
offsets = cumsum(offsets);
offsets = [0; offsets(1:end)'];

agesex = ages + 10*(genders-1);
nrows = length(agesex);
ncols = offsets(2);
rows_i = 1:length(agesex);
cols_i = agesex;
val = 1;

% map the data to a new space
ndrugs_train = ndrugMap(ndrugs_train);
ndrugs_test = ndrugMap(ndrugs_test);
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
nspec_train = nspecMap(nspec_train);
nspec_test = nspecMap(nspec_test);
nplace_train = nplaceMap(nplace_train);
nplace_test = nplaceMap(nplace_test);
nproc_train = nprocMap(nproc_train);
nproc_test = nprocMap(nproc_test);
ncond_train = ncondMap(ncond_train);
ncond_test = ncondMap(ncond_test);
extradsfs_train = extradsfsMap(extradsfs_train);
extradsfs_test = extradsfsMap(extradsfs_test);
exchar_train = excharMap(exchar_train);
exchar_test = excharMap(exchar_test);
extraprob_train = extraprobMap(extraprob_train);
extraprob_test = extraprobMap(extraprob_test);

A = [full(sparse(rows_i, cols_i, val, nrows, ncols)), ...
    ndrugs_train, nlab_train, nprov_train, nvend_train,...
    npcp_train,extralos_train,nclaims_train,nspec_train,nplace_train,...
    nproc_train,ncond_train,extradsfs_train,exchar_train,extraprob_train];
A=sparse(A);

agesex_test = ages_test + 10*(genders_test-1);
agesex_test = sparse(1:length(ages_test), agesex_test, 1, length(ages_test), SIZE.AGE*SIZE.SEX);
M = sparse([agesex_test,ndrugs_test,nlab_test,nprov_test,nvend_test,...
    npcp_test,extralos_test,nclaims_test,nspec_test,nplace_test,nproc_test,ncond_test,...
    extradsfs_test,exchar_test,extraprob_test]);

[m, n] = size(A);
disp('starting cvx');
cvx_clear;
cvx_begin quiet
    variables c(n);
    minimize(norm(A*c - logDIH))
    subject to
cvx_end
if ~strcmp(cvx_status,'Solved') && ~strcmp(cvx_status,'Inaccurate/Solved')
    'computeTargetDIH_n2 failed'
    keyboard
end
err = sqrt(mean((logDIH-postProcess(A*c)).^2));
fprintf('computeTargetDIH_n2 TRAINING ERROR: %f\n',err);

c = hillClimb3(A,c,logDIH);
err = sqrt(mean((logDIH-postProcess(A*c)).^2));
fprintf('computeTargetDIH_n2 HILLCLIMB TRAINING ERROR: %f\n',err);
target_DIH = M*c;
target_DIH = exp(target_DIH)-1;
end
%TODO these functions make the arrays unsparse. Subtract the min value to
%make them sparse again
function x = nprovMap(x)
x = x.^1.6;
end
function x = nvendMap(x)
x=x.^0.9;
end
function x = ndrugMap(x)
x=x.^0.65;
end
function x = nlabMap(x)
x=x.^1.4;
end
function x = extralosMap(x)
x = x.^0.8;
end
function x = npcpMap(x)
x = x.^0.9;
end
function x = nclaimsMap(x)
x = x.^0.75;
end
function x = nspecMap(x)
x=x.^1.4;
end
function x = nplaceMap(x)
x=x.^0.8;
end
function x = nprocMap(x)
x=x.^1.5;
end
function x = ncondMap(x)
end
function [x] = extradsfsMap(x)
x=x.^1.5;
end
function [x] = excharMap(x)
end
function [x] = extraprobMap(x)
end