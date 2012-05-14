function c = hillClimb(A,c,logDIH)
constants;
STEP = 0.000025;
OVERFIT = 0.65;
indices = [1:111,126:152];
v = A*c;
old = norm(max(postProcess(v)-logDIH,OVERFIT));
for iter=1:13
    change = false;
    for i=indices
        %TODO should be 
        % norm(max(abs(max(A*c,MIN_PREDICTION)-logDIH),OVERFIT));
        % for some reason the abs is detrimental
        v1 = v + STEP*A(:,i);
        new1 = norm(max(postProcess(v1)-logDIH,OVERFIT));
        v2 = v - STEP*A(:,i);
        new2 = norm(max(postProcess(v2)-logDIH,OVERFIT));
        if new1 < old && new1 < new2
            change=true;
            c(i) = c(i) + STEP;
            v=v1;
            old=new1;
        elseif new2 < old && new2 < new1
            change=true;
            c(i) = c(i) - STEP;
            v=v2;
            old=new2;
        end 
    end
    if ~change
        break
    end
    vtrain = sqrt(mean((postProcess(A*c)-logDIH).^2));
    %disp(sprintf('%d: index %d, train: %f',iter,i,vtrain));
end
end
