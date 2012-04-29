function target_DIH = computeTargetDIH_agesex(target,ages,genders,logDIH)
% find optimal # of days for age and sex bins
constants;
num_bins = length(BUCKET_RANGES.AGE) + length(BUCKET_RANGES.SEX);
offset = length(BUCKET_RANGES.AGE);
rows_i = [1:71435 1:71435];
cols_i = [ages' (offset+genders)'];
val = 1;
nrows = length(ages);
ncols = num_bins;
A = sparse(rows_i, cols_i, val, nrows, ncols);

cvx_begin
    variables c(num_bins);
    minimize(norm(A*c - logDIH))
cvx_end

c_age = c(1:length(BUCKET_RANGES.AGE))
c_sex = c(length(BUCKET_RANGES.AGE)+1:length(BUCKET_RANGES.AGE)+length(BUCKET_RANGES.SEX))
target_DIH = c_age(target.ages) + c_sex(target.genders);
target_DIH = exp(target_DIH)-1;
end

%TODO
% crossvalidation
% add in all fields to the array
% ensemble or ridge regression
