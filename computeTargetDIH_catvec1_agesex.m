function [target_DIH, params] = computeTargetDIH_catvec1_agesex(target,ages,genders,logDIH,...
    ages_test,genders_test)%,drugs_train,drugs_test,lab_train,lab_test,cond_train,cond_test,...
    %proc_train,proc_test,los_train,los_test,charlson_train,charlson_test,...
    %spec_train,spec_test,place_train,place_test)
rand('seed',123456);
% find optimal # of days for age and sex bins
constants;
DIM = 4;
num_bins = SIZE.AGE * SIZE.SEX;
offset = SIZE.AGE;
m = length(logDIH);
agesex = ages + 10*(genders-1);
agesex_test = ages_test + 10*(genders_test-1);
m_test = length(agesex_test);
rows_i = 1:length(agesex);
cols_i = agesex;
val = 1;
nrows = length(agesex);
ncols = num_bins;
A = sparse(rows_i, cols_i, val, nrows, ncols);
try
    load(sprintf('cache/computeTargetDIH_catvec1_agesex_DIM%d_m%d.mat',DIM,m));
catch
    B = sparse([],[],0,m,DIM*m,DIM*m);
    C=sparse(1:m,1:m,1,m,m);
    B_test = sparse([],[],0,m_test,DIM*m_test,DIM*m_test);
    C_test=sparse(1:m_test,1:m_test,1,m_test,m_test);
    for i=1:DIM
        i
        B(:,i:DIM:end) = C;
        B_test(:,i:DIM:end) = C_test;
    end
    save(sprintf('cache/computeTargetDIH_catvec1_agesex_DIM%d_m%d.mat',DIM,m),'B','B_test');
end

NITERS = 1;
g = rand(num_bins,DIM)-0.5;
disp('Starting cvx');
for i=1:NITERS
    disp(sprintf('ITER %d',i));
    cvx_begin quiet
        variables f(num_bins,DIM) x(DIM*m);
        minimize( norm(B*x - logDIH) )
        subject to
            x == reshape((A*g)',DIM*m,1).*reshape((A*f)',DIM*m,1);
    cvx_end
    cvx_begin quiet
        variables g(num_bins,DIM) x(DIM*m);
        minimize( norm(B*x - logDIH) )
        subject to
            x == reshape((A*g)',DIM*m,1).*reshape((A*f)',DIM*m,1);
    cvx_end
end
if ~strcmp(cvx_status,'Solved') && ~strcmp(cvx_status,'Inaccurate/Solved')
    'computeTargetDIH_agesex failed'
    keyboard
end
disp(sprintf('catvec1_agesex TRAINING ERROR: %f',sqrt((cvx_optval^2)/m)))

agesex_test = sparse(1:length(ages_test), agesex_test, 1, length(ages_test), SIZE.AGE*SIZE.SEX);
M = sparse([agesex_test]);%,drugs_test,lab_test,cond_test,proc_test,los_test,charlson_test,...
    %spec_test,place_test]);
x = reshape((M*g)',DIM*m_test,1).*reshape((M*f)',DIM*m_test,1);
target_DIH = B_test*x;
target_DIH = exp(target_DIH)-1;

params = [f,g];

end
