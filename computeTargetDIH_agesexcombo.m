function [target_DIH,c_male,c_female] = computeTargetDIH_agesexcombo(ages,genders,logDIH,...
    ages_test,genders_test)
% find optimal # of days for all trait bins
%
% sparse A: (# members) x (# trait bins)
%
constants;

offsets = [...
    SIZE.AGE*SIZE.SEX,...
    ];
offsets = cumsum(offsets);
offsets = [0; offsets(1:end)'];

agesex = ages + 10*(genders-1);
nrows = length(agesex);
ncols = offsets(2);
m = length(logDIH);
n = offsets(end);
rows_i = 1:length(agesex);
cols_i = agesex;
val = 1;

A = [full(sparse(rows_i, cols_i, val, nrows, ncols))];
A=sparse(A);
cvx_begin quiet
    variables c(n);
    minimize(norm(A*c - logDIH))
cvx_end
if ~strcmp(cvx_status,'Solved')
    'computeTargetDIH_agesexdruglab_sqrt failed'
    keyboard
end
disp(sprintf('computeTargetDIH_agesexcombo TRAINING ERROR: %f',sqrt((cvx_optval^2)/m)))

c_agesex = c(offsets(1)+1:offsets(2));
c_male = c_agesex(1:10);
c_female = c_agesex(11:20);
c_nosex = c_agesex(21:30);
target_agesex = ages_test + 10*(genders_test-1);
target_DIH = c_agesex(target_agesex);
target_DIH = exp(target_DIH)-1;
c_male = exp(c_male)-1;
c_female = exp(c_female)-1;
c_nosex = exp(c_nosex)-1;
end