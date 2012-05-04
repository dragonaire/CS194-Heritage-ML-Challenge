function target_DIH = computeTargetDIH_agesexdruglab_sqrt(ages,genders,logDIH,...
    ages_test,genders_test,drugs_train,drugs_test,lab_train,lab_test)
% Leaderboard Error: .479
% find optimal # of days for all trait bins
%
% sparse A: (# members) x (# trait bins)
%
constants;

offsets = [...
    length(BUCKET_RANGES.AGE),...
    length(BUCKET_RANGES.SEX),...
    length(BUCKET_RANGES.DRUG_1YR),...
    length(BUCKET_RANGES.LAB_1YR),...
    ];
offsets = cumsum(offsets);
n = offsets(end);
offsets = [0; offsets(1:end)'];

rows_i = [1:length(ages) 1:length(ages)];
cols_i = [ages' (offsets(2)+genders)'];
val = 1;
nrows = length(ages);
ncols = offsets(3);
A = [full(sparse(rows_i, cols_i, val, nrows, ncols)), ...
    sqrt(drugs_train), sqrt(lab_train)];
A=sparse(A);
cvx_begin quiet
    variables c(n);
    minimize(norm(A*c - logDIH))
cvx_end
if ~strcmp(cvx_status,'Solved')
    'computeTargetDIH_agesexdruglab_sqrt failed'
    keyboard
end
disp(sprintf('computeTargetDIH_agesexdruglab_sqrt TRAINING ERROR: %f',sqrt((cvx_optval^2)/NUM_TARGETS)))

c_age = c(offsets(1)+1:offsets(2))
c_sex = c(offsets(2)+1:offsets(3))
c_drugs = c(offsets(3)+1:offsets(4))
c_lab = c(offsets(4)+1:offsets(5))
target_DIH = c_age(ages_test) + c_sex(genders_test) + drugs_test*c_drugs + ...
    lab_test*c_lab;
target_DIH = exp(target_DIH)-1;
end