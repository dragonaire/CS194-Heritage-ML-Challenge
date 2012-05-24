function [t] = trace2(A,B)
t = 0;
for i=1:size(A,1)
    t = t + A(i,:)*B(:,i);
end
end

