function [f,g,vtrain] = hillClimbCatVec(A,B,f,g,logDIH,DIM,maxIndex)
constants;
m = length(logDIH);
STEP = 0.000025;
if nargin >= 7
  indices = 1:maxIndex;
else
  indices = 1:prod(size(f));
end
vtrain = inf;
x = reshape((A*g)',DIM*m,1).*reshape((A*f)',DIM*m,1);
v = B*x;
old = norm(postProcess(v)-logDIH);
for iter=1:100
    change = 0;
    for i=indices
        f(i) = f(i) + STEP;
        x1 = reshape((A*g)',DIM*m,1).*reshape((A*f)',DIM*m,1);
        v1 = B*x1;
        new1 = norm(postProcess(v1)-logDIH);
        f(i) = f(i) - 2*STEP;
        x2 = reshape((A*g)',DIM*m,1).*reshape((A*f)',DIM*m,1);
        v2 = B*x2;
        new2 = norm(postProcess(v2)-logDIH);
        if new1 < old && new1 < new2
            change=old-new1;
            f(i) = f(i) + 2*STEP;
            v=v1;
            old=new1;
        elseif new2 < old && new2 < new1
            change=old-new1;
            %f(i) = f(i); %no change
            v=v2;
            old=new2;
        end 
    end
    if change <= 0
        break
    end
    vtrain = sqrt(mean((postProcess(v)-logDIH).^2));
    temp=f; f=g; g=temp;
    %disp(sprintf('hillclimb: %d: index %d, train: %f',iter,i,vtrain));
end
end
