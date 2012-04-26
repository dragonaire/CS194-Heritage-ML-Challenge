function target_DIH = computeTargetDIH_sexonly(target,logDIH)
constants;
%find optimal # of days for male, female, nosex
cvx_begin
    variables DIHm DIHf DIHns;
    minimize( norm([DIHm-logDIH.male; DIHf-logDIH.female; DIHns-logDIH.nosex]) )
cvx_end
DIHm = exp(DIHm)-1
DIHf = exp(DIHf)-1
DIHns = exp(DIHns)-1

target_DIH = 0.2.*ones(NUM_TARGETS,1);
target_DIH(find(target.genders==MALE)) = DIHm;
target_DIH(find(target.genders==FEMALE)) = DIHf;
target_DIH(find(target.genders==NOSEX)) = DIHns;
end
