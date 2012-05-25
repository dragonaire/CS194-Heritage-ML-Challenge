function [target_DIH c vars] = computeTargetDIH_condplacecombo(ages,genders,logDIH,...
    ages_test,genders_test,condplace_train,condplace_test)
constants;
ZSCORE = false; %TODO must use same means and vars for both A and M
num_pc = 105;  % cutoff for number of components to use (max 133)
PCA = false;

% map the data to a new space
[condplace_train,condplace_test] = condplaceMap(condplace_train, condplace_test);
offsets = [...
    SIZE.AGE*SIZE.SEX,...
    size(condplace_train,2),...
    ];
offsets = cumsum(offsets);
offsets = [0; offsets(1:end)'];

agesex = ages + SIZE.AGE*(genders-1);
m = length(agesex);
n = offsets(end);
rows_i = 1:m;
cols_i = agesex;
val = 1;

A = [sparse(rows_i, cols_i, val, m, offsets(2)), condplace_train];
A_pca = sparse(A);
m_test = length(ages_test);
agesex_test = ages_test + 10*(genders_test-1);
M = [sparse(1:m_test,agesex_test,1,m_test,offsets(2)), condplace_test];
M_pca = sparse(M);
if PCA
    A = full(A);
    if ZSCORE
        [pc,scores,vars] = princomp(zscore(A));
    end
    [pc,scores,vars] = princomp(A);
    A_means = ones(m,1)*mean(A);
    A_pca = scores(:,1:num_pc)*pc(:,1:num_pc)' + A_means;
    
    M = full(M);
    if ZSCORE
        [pc,scores,vars] = princomp(zscore(M));
    end
    [pc,scores,vars] = princomp(M);
    M_means = ones(size(M,1),1)*mean(M);
    M_pca = scores(:,1:num_pc)*pc(:,1:num_pc)' + M_means;
end

disp('starting cvx');
%A=sparse(A);
cvx_clear;
cvx_begin quiet
    variables c(n);
    minimize(norm(A_pca*c - logDIH))
    subject to
cvx_end
if ~strcmp(cvx_status,'Solved') && ~strcmp(cvx_status,'Inaccurate/Solved')
    'computeTargetDIH_condplacecombo failed'
    keyboard
end
err = sqrt(mean((logDIH-postProcess(A_pca*c)).^2));
fprintf('computeTargetDIH_condplacecombo TRAINING ERROR: %f\n',err);

c = hillClimb3(A_pca,c,logDIH);
err = sqrt(mean((logDIH-postProcess(A_pca*c)).^2));
fprintf('computeTargetDIH_condplacecombo HILLCLIMB TRAINING ERROR: %f\n',err);
target_DIH = M_pca*c;
target_DIH = exp(target_DIH)-1;
end
%TODO these functions make the arrays unsparse. Subtract the min value to
%make them sparse again
function [train_,test_] = condplaceMap(train,test)
THRESH = 500;
I_big = find(sum(train) >= THRESH);
I_small = find(sum(train) < THRESH);
train_ = [train(:,I_big), sum(train(:,I_small),2)];
test_ = [test(:,I_big), sum(test(:,I_small),2)];
c=1.0;
train_ = train_.^c;
test_ = test_.^c;
end