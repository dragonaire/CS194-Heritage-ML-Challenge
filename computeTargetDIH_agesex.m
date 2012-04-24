% find optimal # of days for age bins

% get the ages just for members with DIH data.
ages23 = extractMemberTraits( members, members23, ages );

num_bins = length(BUCKET_RANGES.AGE) + 3;
A = zeros(NUM_TRAINING,num_bins);
offset = length(BUCKET_RANGES.AGE) + 1;
for i=1:NUM_TRAINING
    A(i,ages(i)) = 1; %TODO is there a better way to do this for loop?
    A(i,offset+genders(i)) = 1;
end
return
A=sparse(A);
return

cvx_begin
    variables c(num_bins);
    minimize(norm([logDIH(1)-logDIHagebins{1};...
                   logDIH(2)-logDIHagebins{2};...
                   logDIH(3)-logDIHagebins{3};...
                   logDIH(4)-logDIHagebins{4};...
                   logDIH(5)-logDIHagebins{5};...
                   logDIH(6)-logDIHagebins{6};...
                   logDIH(7)-logDIHagebins{7};...
                   logDIH(8)-logDIHagebins{8};...
                   logDIH(9)-logDIHagebins{9};...
                   logDIH(10)-logDIHagebins{10}]));
cvx_end

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
