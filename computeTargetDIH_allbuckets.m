%function target_DIH = computeTargetDIH_agesex(target,ages,genders,logDIH)
% find optimal # of days for all trait bins
%
% sparse A: (# members) x (# trait bins)
%
constants;

offsets = [length(BUCKET_RANGES.SEX),...
    length(BUCKET_RANGES.AGE),...
    length(BUCKET_RANGES.YEAR),...
    length(BUCKET_RANGES.SPECIALTY),...
    length(BUCKET_RANGES.PLACE),...
    length(BUCKET_RANGES.PAY_DELAY),...
    length(BUCKET_RANGES.LoS),...
    length(BUCKET_RANGES.DSFS),...
    length(BUCKET_RANGES.COND_GROUP),...
    length(BUCKET_RANGES.CHARLSON),...
    length(BUCKET_RANGES.PROCEDURE)];
%TODO make sure these range from 1-length
M = [genders.yr3, ages.yr3, year, specialty, place, payDelay, LoS, DSFS, condGroup, charlson, procedure];
offsets = cumsum(offsets);
n = offsets(end);
offsets = [0; offsets(1:end-1)'];
m = length(ages);
A = zeros(m,n);
return

nrows = length(ages);
ncols = num_bins;
rows_i = 1:nrows;  % 71435 = length(ages.yr3)
cols_i = ages';
val = 1;
A = sparse(rows_i, cols_i, val, nrows, ncols);
for i = 1:m
    cols_i = (offsets(i)+genders)';
    S = sparse(rows_i, cols_i, val, nrows, ncols);
    A = A + S;
end
return

cvx_begin
    variables c(num_bins);
    minimize(norm(A*c - logDIH))
cvx_end
c_age = c(1:length(BUCKET_RANGES.AGE))
c_sex = c(length(BUCKET_RANGES.AGE)+1:length(BUCKET_RANGES.AGE)+length(BUCKET_RANGES.SEX))
%TODO
target_DIH = c_age(target.ages) + c_sex(target.genders);
%end

%TODO
% crossvalidation
% add in all fields to the array
% ensemble or ridge regression

%function [] = createSparseFeatureMatrix(M)
