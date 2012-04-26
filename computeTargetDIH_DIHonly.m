function target_DIH = computeTargetDIH_DIHonly(target, logDIH)
% find optimal # of days give prev DIH (Y2, Y3)
constants;
total = length(logDIH.yr3);  
cvx_begin
    variables logDIH(total, 1);
    minimize(norm(logDIH - logDIH.yr3));
cvx_end

DIH = exp(logDIH) - 1;

[target_members, matched_memberids_i, all_memberids_i] = intersect(target.memberids, logDIH.members23);
target_DIH = 0.2.*ones(NUM_TARGETS,1);
target_DIH(matched_memberids_i) = DIH(all_memberids_i);
