cvx_begin
    variables DIHc;
    minimize( norm([DIHc-logDIHmale; DIHc-logDIHfemale; DIHc-logDIHnosex]) )
cvx_end
DIHc = exp(DIHc)-1

target_DIH = DIHc*ones(length(target_memberids),1);