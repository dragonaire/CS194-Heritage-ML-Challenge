function x = makeUnique(p,maxsize)
p(isnan(p)) = 0;
u = unique(p);
n = size(u);
if n ~= maxsize
    disp('Problem in makeUnique');
    keyboard
end
x = zeros(size(p));
for i=1:n
    if mod(i,1000) == 0
        fprintf('makeUnique: %d\n',i);
    end
    x(p==u(i)) = i;
end
end