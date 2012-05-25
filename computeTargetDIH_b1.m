function [target_DIH] = computeTargetDIH_b1(ages,genders,logDIH,...
    ages_test,genders_test,drugs_train,drugs_test,lab_train,lab_test,cond_train,cond_test,...
    proc_train,proc_test,spec_train,spec_test,place_train,place_test)
constants;
NTREES = 1000;
NFOLDS = 12;

offsets = [...
    SIZE.AGE*SIZE.SEX,...%1,...% a constant
    SIZE.DRUG_1YR,...
    SIZE.LAB_1YR,...
    SIZE.COND_GROUP,...
    SIZE.PROCEDURE,...
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
spec_train = specMap(spec_train);
spec_test = specMap(spec_test);
place_train = placeMap(place_train);
place_test = placeMap(place_test);

A = [full(sparse(rows_i, cols_i, val, nrows, ncols)), ...%ones(m,1), ...
    drugs_train, lab_train, cond_train, proc_train,...
    spec_train, place_train];
[m, n] = size(A);
A = full(A);

agesex_test = ages_test + 10*(genders_test-1);
agesex_test = sparse(1:length(ages_test), agesex_test, 1, length(ages_test), SIZE.AGE*SIZE.SEX);
M = full([agesex_test,drugs_test,lab_test,cond_test,proc_test,...
    spec_test,place_test]);
m_test = size(M,1);

disp('training ensemble');
try
  load(sprintf('cache/ens_b1_TREES%d_m%d.mat',NTREES,m));
catch
  r=randperm(m);
  logDIH = logDIH(r);
  A = A(r,:);
  train_preds = zeros(m,NFOLDS);
  test_preds = zeros(m_test,NFOLDS);
  for i=1:NFOLDS
    fprintf('Trees: %d, Fitting ensemble %d of %d\n', NTREES,i,NFOLDS);
    try
      load(sprintf('cache/ens_b1_TREES%d_m%d_iter%d.mat',NTREES,m,i));
    catch
      first = round(m*(i-1)/NFOLDS);
      last = round(m*i/NFOLDS)+1;
      B = [A(1:first,:);A(last:end,:)];
      logB = [logDIH(1:first);logDIH(last:end)];
      ens = fitensemble(B,logB,'LSBoost',NTREES,'tree');
      train_pred = predict(ens, A);
      test_pred = predict(ens, M);
      save(sprintf('cache/ens_b1_TREES%d_m%d_iter%d.mat',NTREES,m,i),...
        'train_pred','test_pred');
    end
    err = sqrt(mean((logDIH-postProcess(train_pred)).^2));
    fprintf('%d Trees. FOLD %d TRAINING ERROR: %f\n',NTREES,i,err);
    train_preds(:,i) = train_pred;
    test_preds(:,i) = test_pred;
  end
  %ens = fitensemble(A,logDIH,'LSBoost',NTREES,'tree','kfold',10);
  train_preds = mean(train_preds,2);
  err = sqrt(mean((logDIH-postProcess(train_preds)).^2));
  test_preds = mean(test_preds,2);
  %save(sprintf('cache/ens_b1_TREES%d_m%d.mat',NTREES,m),'ens');
  save(sprintf('cache/ens_b1_TREES%d_m%d.mat',NTREES,m),'train_preds', ...
    'test_preds','err');
end
fprintf('computeTargetDIH_b1 %d Trees. TRAINING ERROR: %f\n',NTREES,err);
target_DIH = test_preds;
target_DIH = exp(target_DIH)-1;
end
%TODO these functions make the arrays unsparse. Subtract the min value to
%make them sparse again
function x = condMap(x)
c=1.6;
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
function x = specMap(x)
%x = sqrt(x);
x = sparse(x.^0.79);
end
function x = placeMap(x)
%x = sqrt(x);
x = sparse(log(x+0.4)-log(0.4));
end
