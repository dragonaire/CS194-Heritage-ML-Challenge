% find optimal # of days for age bins
constants;
% get the ages just for members with DIH data.
ages23 = extractMemberTraits( members, members23, ages );

num_bins = length(BUCKET_RANGES.AGE) + 3;
A = zeros(length(ages23),num_bins);
offset = length(BUCKET_RANGES.AGE) + 1;
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
return
DIHages = exp(logDIH) - 1;

for i = 1:num_bins
    target_DIH(ages == (i-1)) = DIHages(i);
end

%find optimal # of days for male, female, nosex
cvx_begin
    variables DIHm DIHf DIHns;
    minimize( norm([DIHm-logDIHmale; DIHf-logDIHfemale; DIHns-logDIHnosex]) )
cvx_end
DIHm = exp(DIHm)-1
DIHf = exp(DIHf)-1
DIHns = exp(DIHns)-1

target_DIH = zeros(NUM_TARGETS,1);
target_DIH(find(target_genders==MALE)) = DIHm;
target_DIH(find(target_genders==FEMALE)) = DIHf;
target_DIH(find(target_genders==NOSEX)) = DIHns;
