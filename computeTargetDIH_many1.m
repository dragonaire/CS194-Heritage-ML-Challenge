function [target_DIH c] = computeTargetDIH_many1(ages,genders,logDIH,...
    ages_test,genders_test,drugs_train,drugs_test,lab_train,lab_test,cond_train,cond_test,...
    proc_train,proc_test,los_train,los_test,charlson_train,charlson_test,...
    spec_train,spec_test,place_train,place_test)
constants;

offsets = [...
    SIZE.AGE*SIZE.SEX,...
    SIZE.DRUG_1YR,...
    SIZE.LAB_1YR,...
    SIZE.COND_GROUP,...
    SIZE.PROCEDURE,...
    SIZE.LoS,...
    SIZE.CHARLSON,...
    SIZE.SPECIALTY,...
    SIZE.PLACE,...
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
los_train = losMap(los_train);
los_test = losMap(los_test);
charlson_train = charlsonMap(charlson_train);
charlson_test = charlsonMap(charlson_test);
spec_train = specMap(spec_train);
spec_test = specMap(spec_test);
place_train = placeMap(place_train);
place_test = placeMap(place_test);

A = [full(sparse(rows_i, cols_i, val, nrows, ncols)), ...
    drugs_train, lab_train, cond_train, proc_train, los_train, charlson_train,...
    spec_train, place_train];
A=sparse(A);
cvx_begin quiet
    variables c(n);
    minimize(norm(A*c - logDIH))
    subject to
        %c(31:end) >= 0;
        %c(offsets(3:end)) == 0;
        c(112:138) == 0; % for not using los
        c(139:143) == 0; % for not using charlson index
        %c(144:156) == 0; % for not using specialty
        %c(157:165) == 0; % for not using place
        c(160:165) == 0; %TODO randomly setting some to 0, because of overfitting
cvx_end
if ~strcmp(cvx_status,'Solved') && ~strcmp(cvx_status,'Inaccurate/Solved')
    'computeTargetDIH_many1 failed'
    keyboard
end
disp(sprintf('computeTargetDIH_many1 TRAINING ERROR: %f',sqrt((cvx_optval^2)/NUM_TARGETS)))

c_agesex = c(offsets(1)+1:offsets(2));
c_drugs = c(offsets(2)+1:offsets(3));
c_lab = c(offsets(3)+1:offsets(4));
c_cond = c(offsets(4)+1:offsets(5));
c_proc = c(offsets(5)+1:offsets(6));
c_los = c(offsets(6)+1:offsets(7));
c_charlson = c(offsets(7)+1:offsets(8));
c_spec = c(offsets(8)+1:offsets(9));
c_place = c(offsets(9)+1:offsets(10));
target_agesex = ages_test + 10*(genders_test-1);
target_DIH = c_agesex(target_agesex) + drugs_test*c_drugs + ...
    lab_test*c_lab + cond_test*c_cond + proc_test*c_proc + ...
    los_test*c_los + charlson_test*c_charlson + spec_test*c_spec + place_test*c_place;
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
x = x.^1.1;
end
function x = losMap(x)
x = x.^3.5;
%x = sqrt(x);
%x(:,27) = min(1,x(:,27));
end
function x = charlsonMap(x)
%x = log(x+1);
end
function x = specMap(x)
%nothing
end
function x = placeMap(x)
%nothing
end