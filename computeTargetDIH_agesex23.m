function target_DIH = computeTargetDIH_agesex23(target,ages,genders,logDIH)
% find optimal # of days for age bins
constants;

num_bins = length(BUCKET_RANGES.AGE) + length(BUCKET_RANGES.SEX);
A = zeros(length(ages.comb23),num_bins);
offset = length(BUCKET_RANGES.AGE);
for i=1:length(ages.comb23)
    A(i,ages.comb23(i)) = 1; %TODO is there a better way to do this for loop?
    A(i,offset+genders.comb23(i)) = 1;
end
A=sparse(A);

cvx_begin
    variables c(num_bins);
    minimize(norm(A*c - logDIH.comb23))
cvx_end
c
c_age = c(1:length(BUCKET_RANGES.AGE));
c_sex = c(length(BUCKET_RANGES.AGE)+1:length(BUCKET_RANGES.AGE)+length(BUCKET_RANGES.SEX));
target_DIH = c_age(target.ages) + c_sex(target.genders);
end