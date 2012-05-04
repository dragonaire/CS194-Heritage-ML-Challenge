function target_DIH = computeTargetDIH_DIHonly(target, logDIH, members, bothyears)
% find optimal # of days give prev DIH (Y2, Y3)
constants;
if (bothyears) 
    total = length(logDIH.comb23);  
    logDIH23 = logDIH.comb23;
    cvx_begin quiet
        variables logDIH_opt(total, 1);
        minimize(norm(logDIH_opt - logDIH23));
    cvx_end
else
    total = length(logDIH.yr3);  
    cvx_begin quiet
        variables logDIH_opt(total, 1);
        minimize(norm(logDIH_opt - logDIH.yr3));
    cvx_end
end
if ~strcmp(cvx_status,'Solved')
    'computeTargetDIH_DIHonly failed'
    keyboard
end
disp(sprintf('TEST ERROR: %f',sqrt((cvx_optval^2)/NUM_TARGETS)))

DIH_opt = exp(logDIH_opt) - 1;

[target_members, matched_memberids_i, all_memberids_i] = intersect(target.memberids, members.comb23);
target_DIH = 0.2.*ones(NUM_TARGETS,1);
target_DIH(matched_memberids_i) = DIH_opt(all_memberids_i);
