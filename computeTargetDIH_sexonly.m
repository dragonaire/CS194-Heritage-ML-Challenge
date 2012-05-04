function target_DIH = computeTargetDIH_sexonly(target,logDIH)
constants;
%find optimal # of days for male, female, nosex
cvx_begin quiet
    variables DIHm DIHf DIHns;
    minimize( norm([DIHm-logDIH.male; DIHf-logDIH.female; DIHns-logDIH.nosex]) )
cvx_end
if ~strcmp(cvx_status,'Solved')
    'computeTargetDIH_sexonly failed'
    keyboard
end
disp(sprintf('computeTargetDIH_sexonly TEST ERROR: %f',sqrt((cvx_optval^2)/NUM_TARGETS)))

DIHm = exp(DIHm)-1
DIHf = exp(DIHf)-1
DIHns = exp(DIHns)-1

target_DIH = 0.2.*ones(NUM_TARGETS,1);
target_DIH(target.genders==MALE) = DIHm;
target_DIH(target.genders==FEMALE) = DIHf;
target_DIH(target.genders==NOSEX) = DIHns;
end
