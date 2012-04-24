function target_DIH = computeTargetDIH_constant(logDIH)
cvx_begin
    variables DIHc;
    minimize( norm([DIHc-logDIH.male; DIHc-logDIH.female; DIHc-logDIH.nosex]) )
cvx_end
DIHc = exp(DIHc)-1

target_DIH = DIHc*ones(length(target_memberids),1);
end