function [target_DIH] = computeTargetDIH_svm1(ages,genders,logDIH,...
    ages_test,genders_test,drugs_train,drugs_test,lab_train,lab_test,cond_train,cond_test,...
    proc_train,proc_test,...
    spec_train,spec_test,place_train,place_test,dsfs_train,dsfs_test,...
    ndrugs_train,ndrugs_test,nlab_train,nlab_test,nprov_train,nprov_test,...
    nvend_train,nvend_test,npcp_train,npcp_test,extralos_train,extralos_test,...
    nclaims_train,nclaims_test,nspec_train,nspec_test,nplace_train,nplace_test,...
    nproc_train,nproc_test,ncond_train,ncond_test,extradsfs_train,extradsfs_test,...
    exchar_train,exchar_test,extraprob_train,extraprob_test)
NGROUPS = 15;
NCOLS = 195;
try
  m = length(ages);
  load(sprintf('cache/computeTargetDIH_svm1_m%d_cols%d_groups%d.mat', m,NCOLS,NGROUPS));
catch
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
      SIZE.DSFS,...
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
  dsfs_train = dsfsMap(dsfs_train);
  dsfs_test = dsfsMap(dsfs_test);
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
      spec_train, place_train, dsfs_train,ndrugs_train, nlab_train, nprov_train, nvend_train,...
      npcp_train,extralos_train,nclaims_train,nspec_train,nplace_train,...
      nproc_train,ncond_train,extradsfs_train,exchar_train,extraprob_train];
  A = full(A);
  agesex_test = ages_test + 10*(genders_test-1);
  agesex_test = sparse(1:length(ages_test), agesex_test, 1, length(ages_test), SIZE.AGE*SIZE.SEX);
  M = sparse([agesex_test,drugs_test,lab_test,cond_test,proc_test,...
      spec_test,place_test,dsfs_test,ndrugs_test,nlab_test,nprov_test,nvend_test,...
      npcp_test,extralos_test,nclaims_test,nspec_test,nplace_test,nproc_test,ncond_test,...
      extradsfs_test,exchar_test,extraprob_test]);
  M = full(M);
  randn('seed',123);
  r = randperm(m);
  A = A(r,NCOLS);
  M = M(:,NCOLS);
  logDIH=logDIH(r);
  [m, n] = size(A);
  [m_test, n] = size(M);

  disp('training and testing svm');
  options = statset('Display','iter','MaxIter',10000000);
  options = statset('Display','off','MaxIter',10000000);
  %s = svmtrain(A,logical(logDIH),'options',options,'kktviolationlevel',0.01);
  p = zeros(m,1);
  p_test = zeros(m_test,1);
  for i=1:NGROUPS
    fprintf('ITER %d\n', i);
    first = round((m*(i-1))/NGROUPS)+1;
    last = round((m*i)/NGROUPS);
    B = A(first:last,:);
    logB = logDIH(first:last);
    s = svmtrain(B,logical(logB),'options',options);
    p = p + svmclassify(s,A);
    p_test = p_test + svmclassify(s,M);
  end

  logDIHhosp = logDIH(p==1);
  logDIHnot = logDIH(p==0);
  disp('starting cvx');
  cvx_clear;
  cvx_begin quiet
      variables b c;
      minimize(norm(logDIH-b-c*p))
      subject to
        c >= 0;
  cvx_end
  if ~strcmp(cvx_status,'Solved') && ~strcmp(cvx_status,'Inaccurate/Solved')
      'computeTargetDIH_svm1 failed'
      keyboard
  end
  fprintf('b: %f, c: %f\n', b, c);
  optval = norm(logDIH-b-c*p);
  %fprintf('computeTargetDIH_svm1 TRAINING ERROR: %f\n',sqrt((cvx_optval^2)/m));
  fprintf('computeTargetDIH_svm1 TRAINING ERROR: %f\n',sqrt((optval^2)/m));

  target_DIH = b+c*p_test;
  target_DIH = exp(target_DIH)-1;
  save(sprintf('cache/computeTargetDIH_svm1_m%d_cols%d_groups%d.mat',m,NCOLS,NGROUPS), 'target_DIH');
end
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
