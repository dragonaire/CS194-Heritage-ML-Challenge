function target_DIH = computeTargetDIH_ageonly(target,bins)
constants;
% find optimal # of days for age bins
num_bins = length(BUCKET_RANGES.AGE);
cvx_begin quiet
    variables dih(num_bins,1);
    minimize(norm([dih(1)-bins.age{1};...
                   dih(2)-bins.age{2};...
                   dih(3)-bins.age{3};...
                   dih(4)-bins.age{4};...
                   dih(5)-bins.age{5};...
                   dih(6)-bins.age{6};...
                   dih(7)-bins.age{7};...
                   dih(8)-bins.age{8};...
                   dih(9)-bins.age{9};...
                   dih(10)-bins.age{10}]));
cvx_end
if ~strcmp(cvx_status,'Solved')
    'computeTargetDIH_ageonly failed'
    keyboard
end
disp(sprintf('computeTargetDIH_ageonly TRAINING ERROR: %f',sqrt((cvx_optval^2)/NUM_TARGETS)))

DIHages = exp(dih) - 1;

target_DIH = 0.2.*ones(NUM_TARGETS,1);
for i = BUCKET_RANGES.AGE
    target_DIH(target.ages == i) = DIHages(i);
end
%TODO: the last age bucket is for missing age. This could be throwing things off.
% Maybe we could try just putting in the normal constant instead.

% YANG TODO:
% remove hard-coded stuff
% make computeTargetDIH_<one-field>only.m
% a generalized function
% automate through several fields 
% keeping only the target_DIH for each field
% then take median per patient 
% as well as ensemble method
% compare
end
