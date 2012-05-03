function target_DIH = computeTargetDIH_agesexdrug(target,ages,genders,logDIH,drugs)
% find optimal # of days for all trait bins
%
% sparse A: (# members) x (# trait bins)
%
constants;

offsets = [...
    length(BUCKET_RANGES.AGE),...
    length(BUCKET_RANGES.SEX),...
    length(BUCKET_RANGES.DRUG_1YR),...
    ];
%TODO make sure these range from 1-length
M = [genders.yr3, ages.yr3, drugs.features3_1yr];
offsets = cumsum(offsets);
n = offsets(end);
offsets = [0; offsets(1:end)'];
m = length(ages.yr3);
%A = zeros(m,n);

rows_i = [1:length(ages.yr3) 1:length(ages.yr3)];
cols_i = [ages.yr3' (offsets(2)+genders.yr3)'];
val = 1;
nrows = length(ages.yr3);
ncols = offsets(end-1);
A = [full(sparse(rows_i, cols_i, val, nrows, ncols)), drugs.features3_1yr];
A=sparse(A);
cvx_begin
    variables c(n);
    minimize(norm(A*c - logDIH.yr3))
cvx_end

c_age = c(offsets(1)+1:offsets(2))
c_sex = c(offsets(2)+1:offsets(3))
c_drugs = c(offsets(3)+1:offsets(4))
target_DIH = c_age(target.ages) + c_sex(target.genders) + drugs.features4_1yr*c_drugs;
target_DIH = exp(target_DIH)-1;
end