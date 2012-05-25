function c = hillClimb2(A,c,logDIH)
constants;
STEP = 0.0005;
GRAD = 1;
OVERFIT = 0;%0.65;
%indices = [1:111,126:152];
indices = 1:length(c);
disp(sprintf('0: train: %f',sqrt(mean((postProcess(A*c)-logDIH).^2))));
v = A*c;
for iter=1:100
    old = norm(max(abs(postProcess(v)-logDIH),OVERFIT));
    step = zeros(size(c));
    for i=indices
        new1 = norm(max(abs(postProcess(v + STEP*A(:,i))-logDIH),OVERFIT));
        new2 = norm(max(abs(postProcess(v - STEP*A(:,i))-logDIH),OVERFIT));
        if new1 < old && new1 < new2
            step(i) = old-new1;
        elseif new2 < old && new2 < new1
            step(i) = -(old-new2);
        end 
    end
    if step==0
        break;
    end
    step = step/norm(step);
    c = c + STEP*step;
    v = A*c;
    %c(i) = c(i) + step(i);
    %v = v + step(i)*A(:,i);
    %old = val(i);
    %old_vtrain = vtrain;
    vtrain = sqrt(mean((postProcess(A*c)-logDIH).^2));
    %disp(sprintf('%d: index %d, train: %f, steplen: %f',iter,i,vtrain,STEP));
end
end
