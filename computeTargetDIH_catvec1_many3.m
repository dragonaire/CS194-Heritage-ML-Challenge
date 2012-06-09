function [target_DIH params] = computeTargetDIH_catvec1_many3(ages,genders,logDIH,...
    ages_test,genders_test,ndrugs_train,ndrugs_test,nlab_train,nlab_test,nprov_train,nprov_test,...
    nvend_train,nvend_test,npcp_train,npcp_test,extralos_train,extralos_test,...
    nclaims_train,nclaims_test)
seed = 123452;
rand('seed',seed);
constants;
%ZSCORE = false; %TODO must use same means and vars for both A and M
DIM = 1;
NITERS = 40;

offsets = [...
    SIZE.AGE*SIZE.SEX,...
    SIZE.EXTRA-1,... % ndrug
    SIZE.EXTRA-1,... % nlab
    1,... % nprov
    1,... % nvend
    1,... %npcp
    SIZE.EXTRA,...
    SIZE.NCLAIMS,...
    ];
offsets = cumsum(offsets);
offsets = [0; offsets(1:end)'];

agesex = ages + 10*(genders-1);
nrows = length(agesex);
ncols = offsets(2);
m = length(ages);
n = offsets(end);
rows_i = 1:length(agesex);
cols_i = agesex;
val = 1;

% map the data to a new space
ndrugs_train = drugMap(ndrugs_train);
ndrugs_test = drugMap(ndrugs_test);
nlab_train = nlabMap(nlab_train);
nlab_test = nlabMap(nlab_test);
nprov_train = nprovMap(nprov_train);
nprov_test = nprovMap(nprov_test);
nvend_train = nvendMap(nvend_train);
nvend_test = nvendMap(nvend_test);
npcp_train = npcpMap(npcp_train);
npcp_test = npcpMap(npcp_test);
extralos_train = extralosMap(extralos_train);
extralos_test = extralosMap(extralos_test);
nclaims_train = nclaimsMap(nclaims_train);
nclaims_test = nclaimsMap(nclaims_test);

A = [full(sparse(rows_i, cols_i, val, nrows, ncols)), ...
    ndrugs_train, nlab_train, nprov_train, nvend_train,...
    npcp_train,extralos_train,nclaims_train];
A_pca=sparse(A);
[m, n] = size(A);
m_test = length(ages_test);


agesex_test = ages_test + 10*(genders_test-1);
agesex_test = sparse(1:length(ages_test), agesex_test, 1, length(ages_test), SIZE.AGE*SIZE.SEX);
M = sparse([agesex_test,ndrugs_test,nlab_test,nprov_test,nvend_test,...
    npcp_test,extralos_test,nclaims_test]);
M_pca = sparse(M);

try
    load(sprintf('cache/B_DIM%d_m%d.mat',DIM,m));
catch
    B = sparse([],[],0,m,DIM*m,DIM*m);
    C=sparse(1:m,1:m,1,m,m);
    for i=1:DIM
        B(:,i:DIM:end) = C;
    end
    save(sprintf('cache/B_DIM%d_m%d.mat',DIM,m),'B');
end
try
    load(sprintf('cache/Btest_DIM%d_m%d.mat',DIM,m_test));
catch
    B_test = sparse([],[],0,m_test,DIM*m_test,DIM*m_test);
    C_test=sparse(1:m_test,1:m_test,1,m_test,m_test);
    for i=1:DIM
        B_test(:,i:DIM:end) = C_test;
    end
    save(sprintf('cache/Btest_DIM%d_m%d.mat',DIM,m_test),'B_test');
end
f = rand(n,DIM)-0.5; g = rand(n,DIM)-0.5;
%disp('Starting cvx');
prev_opt = inf; cur_opt = inf; cur_g = g; cur_f = f;
for i=1:NITERS
    try
        load(sprintf('cache/catvec1_many3_DIM%d_m%d_i%d_seed%d.mat',DIM,m,i,seed));
    catch
        if prev_opt < cur_opt + CATVEC_TERMINATE_THRESH
            break
        end
        prev_opt = cur_opt;
        try
            cvx_clear
            cvx_begin quiet
                variables f(n,DIM) x(DIM*m);
                minimize( norm(B*x - logDIH) )
                subject to
                    x == reshape((A_pca*g)',DIM*m,1).*reshape((A_pca*f)',DIM*m,1);
            cvx_end
            if ~strcmp(cvx_status,'Solved') && ~strcmp(cvx_status,'Inaccurate/Solved')
                'computeTargetDIH_catvec1_many3 failed'
                keyboard
            end
            cur_opt = cvx_optval; cur_g = g; cur_f = f; 
            g = f; % this makes it so it keeps switching sides;
            save(sprintf('cache/catvec1_many3_DIM%d_m%d_i%d_seed%d.mat',DIM,m,i,seed),...
                'prev_opt','cur_opt','cur_g','cur_f','g');
        catch
            disp('TERMINATED! PROBABLY RAN OUT OF MEMORY');
            break
        end
    end
    %disp(sprintf('ITER %d: computeTargetDIH_catvec1_many3 TRAINING ERROR: %f',i,sqrt((cur_opt^2)/m)))
end
disp(sprintf('computeTargetDIH_catvec1_many3 TRAINING ERROR: %f',sqrt((cur_opt^2)/m)))

[cur_f,cur_g] = hillClimbCatVec(A_pca,B,cur_f,cur_g,logDIH,DIM);

x = reshape((M_pca*cur_g)',DIM*m_test,1).*reshape((M_pca*cur_f)',DIM*m_test,1);
target_DIH = B_test*x;
target_DIH = exp(target_DIH)-1;
params = [cur_f,cur_g];
end
%TODO these functions make the arrays unsparse. Subtract the min value to
%make them sparse again
function x = nprovMap(x)
x = x.^2.0;
end
function x = nvendMap(x)
end
function x = drugMap(x)
end
function x = nlabMap(x)
end
function x = extralosMap(x)
x = x.^0.8;
end
function x = npcpMap(x)
x = x.^0.9;
end
function x = nclaimsMap(x)
x = x.^0.82;
end
