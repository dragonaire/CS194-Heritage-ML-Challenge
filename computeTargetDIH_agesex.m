function [target_DIH, params] = computeTargetDIH_agesex(target,ages,genders,logDIH)
% find optimal # of days for age and sex bins
constants;
num_bins = length(BUCKET_RANGES.AGE) + length(BUCKET_RANGES.SEX);
offset = length(BUCKET_RANGES.AGE);
rows_i = [1:length(ages) 1:length(ages)];
cols_i = [ages' (offset+genders)'];
val = 1;
nrows = length(ages);
ncols = num_bins;
A = sparse(rows_i, cols_i, val, nrows, ncols);

cvx_begin quiet
    variables c(num_bins);
    minimize(norm(A*c - logDIH))
cvx_end
if ~strcmp(cvx_status,'Solved')
    'computeTargetDIH_agesex failed'
    keyboard
end
disp(sprintf('computeTargetDIH_agesex TRAINING ERROR: %f',sqrt((cvx_optval^2)/NUM_TARGETS)))

c_age = c(1:length(BUCKET_RANGES.AGE));
c_sex = c(length(BUCKET_RANGES.AGE)+1:length(BUCKET_RANGES.AGE)+length(BUCKET_RANGES.SEX));
target_DIH = c_age(target.ages) + c_sex(target.genders);
target_DIH = exp(target_DIH)-1;

params = [c_age; c_sex];

% use the sex constant for ppl with missing ages
%{
target_sexonly_DIH = computeTargetDIH_sexonly(target,logDIH);
target_DIH(target.ages==NOAGE) = target_sexonly_DIH(target.ages==NOAGE);
% use the age constant for ppl with missing gender 
target_ageonly_DIH = computeTargetDIH_ageonly(target,bins);
target_DIH(target.genders==NOSEX) = target_ageonly_DIH(target.genders==NOSEX);
%}
end

%TODO
% crossvalidation
% add in all fields to the array
% ensemble or ridge regression
