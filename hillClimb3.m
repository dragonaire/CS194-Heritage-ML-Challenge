function c = hillClimb3(A,c,logDIH)
constants;
STEP = 0.000025;
OVERFIT = 0.0;%0.65;
%indices = [1:111,126:152];
indices = 1:length(c);
v = A*c;
old = norm(max(abs(postProcess(v)-logDIH),OVERFIT));
for iter=1:100
    change = 0;
    for i=indices
        v1 = v + STEP*A(:,i);
        new1 = norm(max(abs(postProcess(v1)-logDIH),OVERFIT));
        v2 = v - STEP*A(:,i);
        new2 = norm(max(abs(postProcess(v2)-logDIH),OVERFIT));
        if new1 < old && new1 < new2
            change=old-new1;
            c(i) = c(i) + STEP;
            v=v1;
            old=new1;
        elseif new2 < old && new2 < new1
            change=old-new1;
            c(i) = c(i) - STEP;
            v=v2;
            old=new2;
        end 
    end
    if change <= 0
        break
    end
    vtrain = sqrt(mean((postProcess(A*c)-logDIH).^2));
    %disp(sprintf('%d: index %d, train: %f',iter,i,vtrain));
end
end

