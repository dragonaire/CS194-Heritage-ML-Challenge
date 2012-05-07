function target_DIH = computeTargetDIH_agesexcombo_druglabcondproc(ages,genders,logDIH,...
    ages_test,genders_test,drugs_train,drugs_test,lab_train,lab_test,cond_train,cond_test,...
    proc_train,proc_test)
% find optimal # of days for all trait bins
%
% sparse A: (# members) x (# trait bins)
%
constants;

offsets = [...
    SIZE.AGE*SIZE.SEX,...
    SIZE.DRUG_1YR,...
    SIZE.LAB_1YR,...
    SIZE.COND_GROUP,...
    SIZE.PROCEDURE,...
    ];
offsets = cumsum(offsets);
offsets = [0; offsets(1:end)'];

agesex = ages + 10*(genders-1);
nrows = length(agesex);
ncols = offsets(2);
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

A = [full(sparse(rows_i, cols_i, val, nrows, ncols)), ...
    drugs_train, lab_train, cond_train, proc_train];
A=sparse(A);
cvx_begin quiet
    variables c(n);
    minimize(norm(A*c - logDIH))
    subject to
        %c(end-63:end-18) == 0; % for not using condition group
        %c(end-17:end) == 0; % for not using procedure
cvx_end
if ~strcmp(cvx_status,'Solved')
    'computeTargetDIH_agesexcombo_druglabcondproc failed'
    keyboard
end
disp(sprintf('computeTargetDIH_agesexcombo_druglabcondproc TRAINING ERROR: %f',sqrt((cvx_optval^2)/NUM_TARGETS)))

c_agesex = c(offsets(1)+1:offsets(2));
c_male = c_agesex(1:10);
c_female = c_agesex(11:20);
c_nosex = c_agesex(21:30);
c_drugs = c(offsets(2)+1:offsets(3));
c_lab = c(offsets(3)+1:offsets(4));
c_cond = c(offsets(4)+1:offsets(5));
c_proc = c(offsets(5)+1:offsets(6));
target_agesex = ages_test + 10*(genders_test-1);
target_DIH = c_agesex(target_agesex) + drugs_test*c_drugs + ...
    lab_test*c_lab + cond_test*c_cond + proc_test*c_proc;
target_DIH = exp(target_DIH)-1;
end
%TODO these functions make the arrays unsparse. Subtract the min value to
%make them sparse again
function x = condMap(x)
x = log(x+3.5);
end
function x = procMap(x)
x = log(x+0.4);
end
function x = drugMap(x)
x = log(x+0.5);
%x = log(sqrt(x)+6);
%x = sqrt(x);
end
function x = labMap(x)
x = sparse(x.^1.1);
end