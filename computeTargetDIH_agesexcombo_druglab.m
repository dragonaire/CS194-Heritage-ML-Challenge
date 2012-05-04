function target_DIH = computeTargetDIH_agesexcombo_druglab(ages,genders,logDIH,...
    ages_test,genders_test,drugs_train,drugs_test,lab_train,lab_test)
% find optimal # of days for all trait bins
%
% sparse A: (# members) x (# trait bins)
%
constants;

offsets = [...
    length(BUCKET_RANGES.AGE)*length(BUCKET_RANGES.SEX),...
    length(BUCKET_RANGES.DRUG_1YR),...
    length(BUCKET_RANGES.LAB_1YR),...
    ];
offsets = cumsum(offsets);
offsets = [0; offsets(1:end)'];

agesex = ages + 10*(genders-1);
nrows = length(agesex);
ncols = offsets(2);
n = offsets(end);
rows_i = 1:length(agesex);
cols_i = agesex;
val = 1;

A = [full(sparse(rows_i, cols_i, val, nrows, ncols)), ...
    drugs_train, lab_train];
A=sparse(A);
cvx_begin quiet
    variables c(n);
    minimize(norm(A*c - logDIH))
cvx_end
if ~strcmp(cvx_status,'Solved')
    'computeTargetDIH_agesexdruglab_sqrt failed'
    keyboard
end
disp(sprintf('computeTargetDIH_agesexcombo_druglab TRAINING ERROR: %f',sqrt((cvx_optval^2)/NUM_TARGETS)))

c_agesex = c(offsets(1)+1:offsets(2));
c_male = c_agesex(1:10)
c_female = c_agesex(11:20)
c_nosex = c_agesex(21:30)
c_drugs = c(offsets(2)+1:offsets(3))
c_lab = c(offsets(3)+1:offsets(4))
target_agesex = ages_test + 10*(genders_test-1);
target_DIH = c_agesex(target_agesex) + drugs_test*c_drugs + ...
    lab_test*c_lab;
target_DIH = exp(target_DIH)-1;
end