% find optimal # of days for age bins
num_bins = 10;
cvx_begin
    variables logDIH(num_bins,1);
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
    target_DIH(target_ages == (i-1)) = DIHages(i);
end

% YANG TO DO:
% remove hard-coded stuff
% make computeTargetDIH_<one-field>only.m
% a generalized function
% automate through several fields 
% keeping only the target_DIH for each field
% then take median per patient 
% as well as ensemble method
% compare
