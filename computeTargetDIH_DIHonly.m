function target_DIH = computeTargetDIH_DIHonly(target, logDIH)
% find optimal # of days give prev DIH (Y2, Y3)
constants;
total = length(logDIH.comb23);  
logDIH23 = logDIH.comb23;
cvx_begin
    variables logDIH_opt(total, 1);
    minimize(norm(logDIH_opt - logDIH23));
cvx_end

DIH_opt = exp(logDIH_opt) - 1;

[target_members, matched_memberids_i, all_memberids_i] = intersect(target.memberids, logDIH.members23);
target_DIH = 0.2.*ones(NUM_TARGETS,1);
target_DIH(matched_memberids_i) = DIH_opt(all_memberids_i);
