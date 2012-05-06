function [target_DIH c] = computeTargetDIH_many1(ages,genders,logDIH,...
    ages_test,genders_test,drugs_train,drugs_test,lab_train,lab_test,cond_train,cond_test,...
    proc_train,proc_test,los_train,los_test,charlson_train,charlson_test,...
    spec_train,spec_test,place_train,place_test, test)

constants;
try
    load('many1.mat');
catch
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
    Charlson = -diag(ones(4,1),1)+eye(5);
    cvx_begin quiet
        variables c(n);
        minimize(norm(A*c - logDIH))
        subject to
            %c(31:end) >= 0;
            %c(offsets(3:end)) == 0;
            c(112:138) == 0; % for not using los
            Charlson*c(139:143) <= 0; % charlson index is of increasing badness
            %c(144:165) >= 0; Should this be a requirement?
            %c(139:143) == 0; % for not using charlson index
            %c(144:156) == 0; % for not using specialty
            %c(157:165) == 0; % for not using place
            %c(111) == 0;
            %c(156) == 0;
            %c(160:164) == 0; %TODO randomly setting some to 0, because of overfitting
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
    c_charlson = c(offsets(7)+1:offsets(8))
    c_spec = c(offsets(8)+1:offsets(9));
    c_place = c(offsets(9)+1:offsets(10));

    agesex_test = ages_test + 10*(genders_test-1);
    agesex_test = sparse(1:length(ages_test), agesex_test, 1, length(ages_test), SIZE.AGE*SIZE.SEX);
    M = sparse([agesex_test,drugs_test,lab_test,cond_test,proc_test,los_test,charlson_test,...
        spec_test,place_test]);
    save('many1.mat','A','c','M');
end
%keyboard
c = hillClimb(A,c,logDIH,test,M);
target_DIH = M*c;
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
x = x.^1.1;
%x = sqrt(x);
%x = log(x+1);
end
function x = specMap(x)
%x = sqrt(x);
x = x.^0.79;
end
function x = placeMap(x)
%x = sqrt(x);
x = log(x+0.4);
end
function c = hillClimb(A,c,logDIH,test,M)
constants;
STEP = 0.000025;
OVERFIT = 0.65;
indices = [1:111,144:165];
v = A*c;
old = norm(max(max(v,MIN_PREDICTION)-logDIH,OVERFIT));
for iter=1:13
    change = false;
    for i=indices
        %TODO should be 
        % norm(max(abs(max(A*c,MIN_PREDICTION)-logDIH),OVERFIT));
        % for some reason the abs is detrimental
        v1 = v + STEP*A(:,i);
        new1 = norm(max(max(v1,MIN_PREDICTION)-logDIH,OVERFIT));
        v2 = v - STEP*A(:,i);
        new2 = norm(max(max(v2,MIN_PREDICTION)-logDIH,OVERFIT));
        if new1 < old && new1 < new2
            change=true;
            c(i) = c(i) + STEP;
            v=v1;
            old=new1;
        elseif new2 < old && new2 < new1
            change=true;
            c(i) = c(i) - STEP;
            v=v2;
            old=new2;
        end 
    end
    if ~change
        break
    end
    disp(sprintf('%d: train: %f, test: %f',iter,sqrt(mean((max(A*c,MIN_PREDICTION)-logDIH).^2)),...
        sqrt(mean((max(M*c,MIN_PREDICTION)-test).^2))));
end
end
function c = hillClimb2(A,c,logDIH,test,M)
constants;
STEP = 0.0001;
OVERFIT = 0.65;
indices = [1:111,144:165];
disp(sprintf('0: train: %f, test: %f',sqrt(mean((max(A*c,MIN_PREDICTION)-logDIH).^2)),...
    sqrt(mean((max(M*c,MIN_PREDICTION)-test).^2))));
v = A*c;
old = norm(max(max(v,MIN_PREDICTION)-logDIH,OVERFIT));
for iter=1:100
    step = zeros(size(c));
    val = old*ones(size(c));
    for i=indices
        %TODO should be 
        % norm(max(abs(max(A*c,MIN_PREDICTION)-logDIH),OVERFIT));
        % for some reason the abs is detrimental
        new1 = norm(max(max(v + STEP*A(:,i),MIN_PREDICTION)-logDIH,OVERFIT));
        new2 = norm(max(max(v - STEP*A(:,i),MIN_PREDICTION)-logDIH,OVERFIT));
        if new1 < old && new1 < new2
            step(i) = STEP;
            val(i) = new1;
        elseif new2 < old && new2 < new1
            step(i) = -STEP;
            val(i) = new2;
        end 
    end
    [m,i]=min(val);
    if step(i)==0
        break
    end
    c(i) = c(i) + step(i);
    v = v + step(i)*A(:,i);
    old = val(i);
    disp(sprintf('%d: index %d, train: %f, test: %f',iter,i,...
        sqrt(mean((max(A*c,MIN_PREDICTION)-logDIH).^2)),sqrt(mean((max(M*c,MIN_PREDICTION)-test).^2))));
end
end