function [target_DIH c] = computeTargetDIH_many2(ages,genders,logDIH,...
    ages_test,genders_test,drugs_train,drugs_test,lab_train,lab_test,cond_train,cond_test,...
    proc_train,proc_test,los_train,los_test,charlson_train,charlson_test,...
    spec_train,spec_test,place_train,place_test,cache_file)
constants;
try
    load('alkjsdfdsal');
    %load('many1.mat');
catch
    try
        load(sprintf(cache_file,1));
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
        m = length(ages_test);
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
        LosMatrix = -diag(ones(SIZE.LoS-3,1),1)+eye(SIZE.LoS-2);
        Charlson = -diag(ones(SIZE.CHARLSON-1,1),1)+eye(SIZE.CHARLSON);
        save(sprintf(cache_file,1),'A','offsets','m','n','LosMatrix','Charlson',...
            'drugs_train','drugs_test','lab_train','lab_test','cond_train','cond_test',...
            'proc_train','proc_test','los_train','los_test','charlson_train','charlson_test',...
            'spec_train','spec_test','place_train','place_test');
    end
    try
        %load('wtf');
        load(sprintf(cache_file,2));
    catch
        minpred = MIN_PREDICTION_L;
        %minpred = 0;
        logDIH2 = logDIH.^2;
        logDIH2x = 2*logDIH;
        cvx_begin
            variables c(n);
            %minimize(sum(pow_pos(max(A*c - logDIH,MIN_PREDICTION),2)))
            %minimize(sum(pow_pos(max(A*c,minpred) - logDIH,2)) + sum(pow_pos(logDIH-max(A*c,minpred),2)))
            %minimize(sum((max(A*c,minpred) - logDIH).^2) )
            %minimize(sum(max(A*c,minpred).^2 - 2*logDIH*max(A*c,minpred)) )
            %minimize( sum(square_pos(A*c) - 2*logDIH*square_pos(A*c) + logDIH.^2) )
            minimize( sum(square_pos(max(A*c,minpred)) - logDIH2x.*square_pos(max(A*c,minpred)) + logDIH2) )
            subject to
                %c(31:end) >= 0;
                %c(offsets(3:end)) == 0;
                %c(112:125) == 0; % for not using los
                % LoS is of increasing badness. except for last 2 columns which had missing data
                %LosMatrix*c(112:123) <= 0;
                Charlson*c(126:130) <= 0; % charlson index is of increasing badness
                c(126:130) == 0; % for not using charlson index
        cvx_end
        save(sprintf(cache_file,2),'cvx_optval','cvx_status','c');
    end
    if ~strcmp(cvx_status,'Solved') && ~strcmp(cvx_status,'Inaccurate/Solved')
        'computeTargetDIH_many2 failed'
        keyboard
    end
    disp(sprintf('computeTargetDIH_many2 TRAINING ERROR: %f',sqrt(cvx_optval/m)))

    c_agesex = c(offsets(1)+1:offsets(2));
    c_drugs = c(offsets(2)+1:offsets(3));
    c_lab = c(offsets(3)+1:offsets(4));
    c_cond = c(offsets(4)+1:offsets(5));
    c_proc = c(offsets(5)+1:offsets(6));
    c_los = c(offsets(6)+1:offsets(7));
    c_charlson = c(offsets(7)+1:offsets(8));
    c_spec = c(offsets(8)+1:offsets(9));
    c_place = c(offsets(9)+1:offsets(10));

    agesex_test = ages_test + 10*(genders_test-1);
    agesex_test = sparse(1:length(ages_test), agesex_test, 1, length(ages_test), SIZE.AGE*SIZE.SEX);
    M = sparse([agesex_test,drugs_test,lab_test,cond_test,proc_test,los_test,charlson_test,...
        spec_test,place_test]);
    %save('many1.mat','A','c','M');
end
%keyboard
%c = hillClimb3(A,c,logDIH);
target_DIH = M*c;
target_DIH = exp(target_DIH)-1;
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
function x = charlsonMap(x)
x = sparse(x.^0.9);
%x = sqrt(x);
%x = log(x+1);
end
function x = specMap(x)
%x = sqrt(x);
x = sparse(x.^0.79);
end
function x = placeMap(x)
%x = sqrt(x);
x = sparse(log(x+0.4)-log(0.4));
end
function c = hillClimb(A,c,logDIH)
constants;
STEP = 0.000025;
OVERFIT = 0.65;
indices = [1:111,126:152];
v = A*c;
old = norm(max(postProcess(v)-logDIH,OVERFIT));
for iter=1:13
    change = false;
    for i=indices
        %TODO should be 
        % norm(max(abs(max(A*c,MIN_PREDICTION)-logDIH),OVERFIT));
        % for some reason the abs is detrimental
        v1 = v + STEP*A(:,i);
        new1 = norm(max(postProcess(v1)-logDIH,OVERFIT));
        v2 = v - STEP*A(:,i);
        new2 = norm(max(postProcess(v2)-logDIH,OVERFIT));
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
    vtrain = sqrt(mean((postProcess(A*c)-logDIH).^2));
    %disp(sprintf('%d: index %d, train: %f',iter,i,vtrain));
end
end
function c = hillClimb2(A,c,logDIH)
constants;
STEP = 0.0005;
GRAD = 1;
OVERFIT = 0;%0.65;
%indices = [1:111,126:152];
indices = 1:152;
disp(sprintf('0: train: %f',sqrt(mean((postProcess(A*c)-logDIH).^2))));
v = A*c;
for iter=1:100
    old = norm(max(abs(postProcess(v)-logDIH),OVERFIT));
    step = zeros(size(c));
    for i=indices
        new1 = norm(max(abs(postProcess(v + STEP*A(:,i))-logDIH),OVERFIT));
        new2 = norm(max(abs(postProcess(v - STEP*A(:,i))-logDIH),OVERFIT));
        if new1 < old && new1 < new2
            step(i) = old-new1;
        elseif new2 < old && new2 < new1
            step(i) = -(old-new2);
        end 
    end
    if step==0
        break;
    end
    step = step/norm(step);
    c = c + STEP*step;
    v = A*c;
    %c(i) = c(i) + step(i);
    %v = v + step(i)*A(:,i);
    %old = val(i);
    %old_vtrain = vtrain;
    vtrain = sqrt(mean((postProcess(A*c)-logDIH).^2));
    %disp(sprintf('%d: index %d, train: %f, steplen: %f',iter,i,vtrain,STEP));
end
end
function c = hillClimb3(A,c,logDIH)
constants;
STEP = 0.000025;
OVERFIT = 0.0;%0.65;
%indices = [1:111,126:152];
indices = 1:152;
v = A*c;
old = norm(max(abs(postProcess(v)-logDIH),OVERFIT));
for iter=1:100
    change = 0;
    for i=indices
        v1 = v + STEP*A(:,i);
        new1 = norm(max(abs(postProcess(v1)-logDIH),OVERFIT));
        v2 = v - STEP*A(:,i);
        new2 = norm(max(abs(postProcess(v2)-logDIH),OVERFIT));
        if new1 < old && new1 < new2
            change=old-new1;
            c(i) = c(i) + STEP;
            v=v1;
            old=new1;
        elseif new2 < old && new2 < new1
            change=old-new1;
            c(i) = c(i) - STEP;
            v=v2;
            old=new2;
        end 
    end
    if change <= 0
        break
    end
    vtrain = sqrt(mean((postProcess(A*c)-logDIH).^2));
    %disp(sprintf('%d: index %d, train: %f',iter,i,vtrain));
end
end