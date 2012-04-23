%find optimal # of days for male, female, nosex
cvx_begin
    variables DIHm DIHf DIHns;
    minimize( norm([DIHm-logDIHmale; DIHf-logDIHfemale; DIHns-logDIHnosex]) )
cvx_end
DIHm = exp(DIHm)-1
DIHf = exp(DIHf)-1
DIHns = exp(DIHns)-1

target_DIH(find(target_genders==MALE)) = DIHm;
target_DIH(find(target_genders==FEMALE)) = DIHf;
target_DIH(find(target_genders==NOSEX)) = DIHns;