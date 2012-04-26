function target_DIH = computeTargetDIH_agesex3(target,members,ages,genders3,DIH3)
% find optimal # of days for age bins
constants;
% get the ages just for members with DIH data.
ages3 = extractMemberTraits( members.all, members.yr3, ages );

num_bins = length(BUCKET_RANGES.AGE) + length(BUCKET_RANGES.SEX);
A = zeros(length(ages3),num_bins);
offset = length(BUCKET_RANGES.AGE);
for i=1:length(ages3)
    A(i,ages3(i)) = 1; %TODO is there a better way to do this for loop?
    A(i,offset+genders3(i)) = 1;
end
A=sparse(A);

cvx_begin
    variables c(num_bins);
    minimize(norm(A*c - DIH3))
cvx_end
c
c_age = c(1:length(BUCKET_RANGES.AGE));
c_sex = c(length(BUCKET_RANGES.AGE)+1:length(BUCKET_RANGES.AGE)+length(BUCKET_RANGES.SEX));
target_DIH = c_age(target.ages) + c_sex(target.genders);
end