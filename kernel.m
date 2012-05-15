function [ y ] = kernel( x,k )
try
    load(sprintf('kernel/kernel_%d.mat',k));
catch
    [m,n] =size(x);
    n2=n*n;
    niters = ceil(m/1000);
    num_elems = 0;
    for i=1:niters
        y{i} = kernel2(x(1+(i-1)*1000:min(i*1000,m),:),k,i);
        num_elems = num_elems + nnz(y{i});
        disp(sprintf('ITER: %d, with %d elems',i,nnz(y{i})));
    end
    z = sparse([],[],[],m,n2,num_elems);
    for i=1:niters
        z = [z; double(y{i})];
    end
    z = sparse(double(z));
    save(sprintf('kernel/kernel_%d.mat',k), 'z');
end
keyboard
end
function [ y ] = kernel2(x,k,iter)
try
    load(sprintf('kernel/kernel_%d_%d.mat',k,iter));
catch
    [m,n] =size(x);
    n2=n*n;
    y = sparse(m,n2);
    for i=1:m
        if mod(i,100)==0
            disp(sprintf('iter: %d',1000*(iter-1)+i));
        end
        y(i,:) = sparse(reshape(x(i,:)'*x(i,:),1,n2));
    end
    y=sparse(y);
    save(sprintf('kernel/kernel_%d_%d.mat',k,iter), 'y');
end
end
