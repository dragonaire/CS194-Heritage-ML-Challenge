function [target_DIH params] = computeTargetDIH_catvec1_many1(ages,genders,logDIH,...
    ages_test,genders_test,drugs_train,drugs_test,lab_train,lab_test,cond_train,cond_test,...
    proc_train,proc_test,los_train,los_test,...
    spec_train,spec_test,place_train,place_test)
constants;
offsets = [...
    SIZE.AGE*SIZE.SEX,...
    SIZE.DRUG_1YR,...
    SIZE.LAB_1YR,...
    SIZE.COND_GROUP,...
    SIZE.PROCEDURE,...
    SIZE.LoS,...
    SIZE.SPECIALTY,...
    SIZE.PLACE,...
    ];
offsets = cumsum(offsets);
offsets = [0; offsets(1:end)'];
DIM = 4;

agesex = ages + 10*(genders-1);
nrows = length(agesex);
ncols = offsets(2);
m = length(ages);
m_test = length(ages_test);
n = offsets(end);
rows_i = 1:length(agesex);
cols_i = agesex;
val = 1;

% map the data to a new space
drugs_train = drugMap(drugs_train);
drugs_test = drugMap(drugs_test);
lab_train = labMap(lab_train);
lab_test = labMap(lab_test);
cond_train = condMap(cond_train);
cond_test = condMap(cond_test);
proc_train = procMap(proc_train);
proc_test = procMap(proc_test);
los_train = losMap(los_train);
los_test = losMap(los_test);
spec_train = specMap(spec_train);
spec_test = specMap(spec_test);
place_train = placeMap(place_train);
place_test = placeMap(place_test);

A = [full(sparse(rows_i, cols_i, val, nrows, ncols)), ...
    drugs_train, lab_train, cond_train, proc_train, los_train,...
    spec_train, place_train];
A=sparse(A);
clear rows_i cols_i ages genders agesex drugs_train lab_train cond_train proc_train...
    los_train spec_train place_train
agesex_test = ages_test + 10*(genders_test-1);
agesex_test = sparse(1:length(ages_test), agesex_test, 1, length(ages_test), SIZE.AGE*SIZE.SEX);
M = sparse([agesex_test,drugs_test,lab_test,cond_test,proc_test,los_test,...
    spec_test,place_test]);
clear ages_test genders_test agesex_test drugs_test lab_test cond_test proc_test...
    los_test spec_test place_test
try
    load(sprintf('cache/computeTargetDIH_catvec1_DIM%d_m%d.mat',DIM,m));
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
    save(sprintf('cache/computeTargetDIH_catvec1_DIM%d_m%d.mat',DIM,m),'B','B_test');
end
NITERS = 10;
f = rand(n,DIM)-0.5; g = rand(n,DIM)-0.5;
disp('Starting cvx');
prev_opt = inf; cur_opt = inf; cur_g = g; cur_f = f;
for i=1:NITERS
    disp(sprintf('ITER %d',i));
    try
        load(sprintf('cache/computeTargetDIH_catvec1_many1_DIM%d_m%d_i%d.mat',DIM,m,i));
    catch
        try
            cvx_clear
            cvx_begin
                variables f(n,DIM) x(DIM*m);
                minimize( norm(B*x - logDIH) )
                subject to
                    x == reshape((A*g)',DIM*m,1).*reshape((A*f)',DIM*m,1);
            cvx_end
            if ~strcmp(cvx_status,'Solved') && ~strcmp(cvx_status,'Inaccurate/Solved')
                'computeTargetDIH_catvec1_many1 failed'
                keyboard
            end
            cur_opt = cvx_optval; cur_g = g; cur_f = f; 
            g = f; % this makes it so it keeps switching sides
            disp(sprintf('ITER %d: computeTargetDIH_catvec1_many1 TRAINING ERROR: %f',i,sqrt((cvx_optval^2)/m)))
            if prev_opt < cvx_optval + 0.01
                break
            end
            prev_opt = cvx_optval;
            save(sprintf('cache/computeTargetDIH_catvec1_many1_DIM%d_m%d_i%d.mat',DIM,m,i),...
                'prev_opt','cur_opt','cur_g','cur_f','g');
        catch
            disp('TERMINATED! PROBABLY RAN OUT OF MEMORY');
            break
        end
    end
end
disp(sprintf('computeTargetDIH_catvec1_many1 TRAINING ERROR: %f',sqrt((cvx_optval^2)/m)))

x = reshape((M*g)',DIM*m_test,1).*reshape((M*f)',DIM*m_test,1);
target_DIH = B_test*x;
target_DIH = exp(target_DIH)-1;
params = [f,g];
end
%TODO these functions make the arrays unsparse. Subtract the min value to
%make them sparse again
function x = condMap(x)
c=1.75;
x = sparse(log(x+c)-log(c));
end
function x = procMap(x)
c=1.1;
x = sparse(log(x+c)-log(c));
end
function x = drugMap(x)
x = sparse(log(x+0.5)-log(0.5));
%x = log(sqrt(x)+6);
%x = sqrt(x);
end
function x = labMap(x)
x = sparse(x.^1.1);
end
function x = losMap(x)
x = sparse(x.^0.78);
%x = sparse(x.^3.5);
%x = sqrt(x);
%x(:,27) = min(1,x(:,27));
end
function x = specMap(x)
%x = sqrt(x);
x = sparse(x.^0.79);
end
function x = placeMap(x)
%x = sqrt(x);
x = sparse(log(x+0.4)-log(0.4));
end
