%function target_DIH = computeTargetDIH_allbuckets(target,members,members23,ages,genders23,DIH23)
% find optimal # of days for age bins
constants;
% get the ages just for members with DIH data.
ages23 = extractMemberTraits( members, members23, ages );

num_bins = length(BUCKET_RANGES.AGE) + length(BUCKET_RANGES.SEX);
A = zeros(length(ages23),num_bins);
offset = length(BUCKET_RANGES.AGE);
for i=1:length(ages23)
    A(i,ages23(i)) = 1; %TODO is there a better way to do this for loop?
    A(i,offset+genders23(i)) = 1;
end
A=sparse(A);

cvx_begin
    variables c(num_bins);
    minimize(norm(A*c - DIH23))
cvx_end
c
c_age = c(1:length(BUCKET_RANGES.AGE));
c_sex = c(length(BUCKET_RANGES.AGE)+1:length(BUCKET_RANGES.AGE)+length(BUCKET_RANGES.SEX));
target_DIH = c_age(target.ages) + c_sex(target.genders);
