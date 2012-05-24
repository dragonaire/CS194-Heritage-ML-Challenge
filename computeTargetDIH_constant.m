function target_DIH = computeTargetDIH_constant(logDIH)
m = length(logDIH);
cvx_begin quiet
    variables DIHc;
    minimize( norm([DIHc-logDIH.male; DIHc-logDIH.female; DIHc-logDIH.nosex]) )
cvx_end
if ~strcmp(cvx_status,'Solved')
    'computeTargetDIH_constant failed'
    keyboard
end
disp(sprintf('computeTargetDIH_constant TRAINING ERROR: %f',sqrt((cvx_optval^2)/m)))

DIHc = exp(DIHc)-1
target_DIH = DIHc*ones(length(target_memberids),1);
end