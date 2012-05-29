function [target_DIH] = computeTargetDIH_svm3(ages,genders,logDIH,...
    ages_test,genders_test,drugs_train,drugs_test,lab_train,lab_test,cond_train,cond_test,...
    proc_train,proc_test,...
    spec_train,spec_test,place_train,place_test,...
    ndrugs_train,ndrugs_test,nlab_train,nlab_test,nprov_train,nprov_test,...
    nvend_train,nvend_test,npcp_train,npcp_test,extralos_train,extralos_test,...
    nclaims_train,nclaims_test,nspec_train,nspec_test,nplace_train,nplace_test,...
    nproc_train,nproc_test,ncond_train,ncond_test,extradsfs_train,extradsfs_test,...
    exchar_train,exchar_test,extraprob_train,extraprob_test)
NGROUPS = 25;
m = length(ages);
constants;
ZSCORE = false; %TODO must use same means and vars for both A and M
PCA = false;
num_pc = 156;  % cutoff for number of components to use (max 195)

offsets = [...
    SIZE.AGE*SIZE.SEX,...%1,...% a constant
    SIZE.DRUG_1YR,...
    SIZE.LAB_1YR,...
    SIZE.COND_GROUP,...
    SIZE.PROCEDURE,...
    SIZE.SPECIALTY,...
    SIZE.PLACE,...
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
drugs_train = drugMap(drugs_train);
drugs_test = drugMap(drugs_test);
lab_train = labMap(lab_train);
lab_test = labMap(lab_test);
cond_train = condMap(cond_train);
cond_test = condMap(cond_test);
proc_train = procMap(proc_train);
proc_test = procMap(proc_test);
spec_train = specMap(spec_train);
spec_test = specMap(spec_test);
place_train = placeMap(place_train);
place_test = placeMap(place_test);
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

A = [full(sparse(rows_i, cols_i, val, nrows, ncols)), ...%ones(m,1), ...
    drugs_train, lab_train, cond_train, proc_train,...
    spec_train, place_train, ndrugs_train, nlab_train, nprov_train, nvend_train,...
    npcp_train,extralos_train,nclaims_train,nspec_train,nplace_train,...
    nproc_train,ncond_train,extradsfs_train,exchar_train,extraprob_train];
A = full(A);
agesex_test = ages_test + 10*(genders_test-1);
agesex_test = sparse(1:length(ages_test), agesex_test, 1, length(ages_test), SIZE.AGE*SIZE.SEX);
M = sparse([agesex_test,drugs_test,lab_test,cond_test,proc_test,...
    spec_test,place_test,ndrugs_test,nlab_test,nprov_test,nvend_test,...
    npcp_test,extralos_test,nclaims_test,nspec_test,nplace_test,nproc_test,ncond_test,...
    extradsfs_test,exchar_test,extraprob_test]);
M = full(M);
rand('seed',123);
randn('seed',123);
r = randperm(m);
A = A(r,:);
logDIH=logDIH(r);
m = size(A,1);
m_test = size(M,1);

target_DIH = zeros(m_test,1);
groups=[5:5:25];
for i=1:length(groups)
  g = groups(i);
  for j=1:length(offsets)-1
    try
      filename = sprintf('cache/computeTargetDIH_svm2_m%d_group%d_offset%d.mat', m, g, j);
      load(filename);
    catch
        fprintf('Problem in svm3 loading svm2 group %d\n', g);
        keyboard
    end
  end
  P = [p, p.^1.5, p.^2.0, p.^0.5, log(p+0.05)];
  P_test = [p_test, p_test.^1.5, p_test.^2.0, p_test.^0.5, log(p_test+0.05)];
  n = size(P,2);
  cvx_clear;
  cvx_begin quiet
      variables c(n);
      minimize(norm(P*c-logDIH))
  cvx_end
  if ~strcmp(cvx_status,'Solved') && ~strcmp(cvx_status,'Inaccurate/Solved')
      'computeTargetDIH_svm3 failed'
      keyboard
  end
  optval = norm(postProcess(P*c)-logDIH);
  fprintf('computeTargetDIH_svm3 TRAINING ERROR: %f\n',sqrt((optval^2)/m));
  c = hillClimb3(P,c,logDIH);
  optval = norm(postProcess(P*c)-logDIH);
  fprintf('computeTargetDIH_svm3 HILLCLIMB TRAINING ERROR: %f\n',sqrt((optval^2)/m));
  target_DIH = target_DIH + P_test*c;
end

%m_test = size(p_test,1);
%P = [p5, p10, p15, p20, p25];
%P_test = [p_test5, p_test10, p_test15, p_test20, p_test25];
%P = [p, p.^1.5, p.^2.0, p.^0.5, log(p+0.05)];
%P_test = [p_test, p_test.^1.5, p_test.^2.0, p_test.^0.5, log(p_test+0.05)];
%{
P = [ones(m,1), p.^0.1, p.^0.3, p.^0.5, p.^0.8, p,  ...
  log(p+1), exp(0.1*p), log(p+0.3)];
P_test = [ones(m_test,1), p_test.^0.1, p_test.^0.3, p_test.^0.5, p_test.^0.8,...
  p_test,  ...
  log(p_test+1), exp(0.1*p_test), log(p_test+0.3)];
%}
%P=p;
%P_test = p_test;
%P = kernel(p,2);
%P_test = kernel(p_test,3);

% combine svm1 and svm2
load(sprintf('cache/computeTargetDIH_svm1_m%d_cols182_groups25.mat', m));
P = [ones(m,1), p.^0.1, p.^0.3, p.^0.5, p.^0.8, p,  ...
  log(p+1), exp(0.1*p), log(p+0.3)];
P_test = [ones(m_test,1), p_test.^0.1, p_test.^0.3, p_test.^0.5, p_test.^0.8,...
  p_test,  ...
  log(p_test+1), exp(0.1*p_test), log(p_test+0.3)];
n = size(P,2);

disp('starting cvx');
cvx_clear;
cvx_begin quiet
    variables c(n);
    minimize(norm(P*c-logDIH))
cvx_end
if ~strcmp(cvx_status,'Solved') && ~strcmp(cvx_status,'Inaccurate/Solved')
    'computeTargetDIH_svm3 failed'
    keyboard
end
optval = norm(postProcess(P*c)-logDIH);
fprintf('computeTargetDIH_svm3 TRAINING ERROR: %f\n',sqrt((optval^2)/m));

c = hillClimb3(P,c,logDIH);
optval = norm(postProcess(P*c)-logDIH);
fprintf('computeTargetDIH_svm3 HILLCLIMB TRAINING ERROR: %f\n',sqrt((optval^2)/m));
target_DIH = target_DIH + P_test*c;
target_DIH = target_DIH / (length(groups)+1);
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
