function target_DIH = computeTargetDIH_agesex(target,ages,genders,logDIH)
% find optimal # of days for age bins
constants;

num_bins = length(BUCKET_RANGES.AGE) + length(BUCKET_RANGES.SEX);
A = zeros(length(ages),num_bins);
offset = length(BUCKET_RANGES.AGE);
for i=1:length(ages)
    A(i,ages(i)) = 1; %TODO is there a better way to do this for loop?
    A(i,offset+genders(i)) = 1;
end
A=sparse(A);

cvx_begin
    variables c(num_bins);
    minimize(norm(A*c - logDIH))
cvx_end
c
c_age = c(1:length(BUCKET_RANGES.AGE));
c_sex = c(length(BUCKET_RANGES.AGE)+1:length(BUCKET_RANGES.AGE)+length(BUCKET_RANGES.SEX));
target_DIH = c_age(target.ages) + c_sex(target.genders);
end