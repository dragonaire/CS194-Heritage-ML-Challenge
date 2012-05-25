function x = makeUnique(p,maxsize,ordered)
if nargin < 3 
    ordered = false;
end
p(isnan(p)) = 0;
u = unique(p);
n = size(u);
if n ~= maxsize
    disp('Problem in makeUnique');
    keyboard
end
x = zeros(size(p));
if ~ordered
    for i=1:n
        if mod(i,10000) == 0
            fprintf('makeUnique: %d\n',i);
        end
        x(p==u(i)) = i;
    end
else
    prev = -1;
    val = 0;
    for i=1:length(p)
        if p(i) ~= prev
            prev = p(i);
            val = val+1;
        end
        x(i) = val;
    end
end
end