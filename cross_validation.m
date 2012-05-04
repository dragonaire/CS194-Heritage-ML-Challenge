function [mean_accuracy, mean_parameters] = cross_validation(model_name)
% 10-fold cross-validation
% input model_name (ex. 'agesex', 'agesexdrug') 
% outputs mean validation accuracy (Y3) and mean parameters

% TODO: test 'agesexdruglab' and other models (requires slight changes in
% their corresponding computeTargetDIH_<> functions to generalize for 
% training inputs/params

[members,genders,ages] = readMembers();
[members,logDIH,DIH,genders,ages,claimsTrunc] = readDIH(members,genders,ages);
bins = extractBins(DIH,genders,ages);
target = readTarget(members, genders, ages);

% TODO: stratify data to get representative folds across traits?
% 10-fold cross-validation, then average accuracies and parameters

k = 10;  % number of folds
members3 = length(ages.yr3);
klen = floor(members3/nfolds);  % fold size length
r = rem(members3,nfolds);  % leave out the remainder
constants;
switch model_name
    case 'sexonly'
        [target.DIH, params] = computeTargetDIH_sexonly(target,logDIH);
    case 'ageonly'
        [target.DIH, params] = computeTargetDIH_ageonly(target,bins);
    case 'DIHonly'
        [target.DIH, params] = computeTargetDIH_DIHonly(target,logDIH,members,true);
    case 'agesex'  % tested, mean accuracy = 0.4605
        nparams = length(BUCKET_RANGES.AGE) + length(BUCKET_RANGES.SEX);
        offset = length(BUCKET_RANGES.AGE);
        model_accuracies = zeros(k, 1);
        model_parameters = zeros(nparams, k);
        data = [ages.yr3 genders.yr3 logDIH.yr3];
        data = data(1:end-r,:);
        for i = 1:k
            first = (i-1)*klen + 1; last = i*klen;
            test = data(first:last,:);
            train = [data(1:first-1,:); data(last+1:end,:)]; 
            % optimize on train -> get parameters
            [target.DIH, params] = computeTargetDIH_agesex(target,train(:,1),train(:,2),train(:,3),bins);
            model_parameters(:,i) = params;
            % use params on test -> get accuracy
            logDIH_test = params(test(:,1)) + params(offset+test(:,2));
            accuracy = sqrt(1/klen)*norm(logDIH_test - logDIH.yr3(first:last));
            model_accuracies(i) = accuracy; 
        end
    case 'agesexdrug' % tested, mean accuracy = 0.4580
        drugs = readDrugCounts(target,members);
        offsets = [...
                    length(BUCKET_RANGES.AGE),...
                    length(BUCKET_RANGES.SEX),...
                    length(BUCKET_RANGES.DRUG_1YR),...
                    ];
        offsets = cumsum(offsets);
        nparams = offsets(end);
        offsets = [0; offsets(1:end)'];
        model_accuracies = zeros(k, 1);
        model_parameters = zeros(nparams, k);
        data = [ages.yr3 genders.yr3 drugs.features3_1yr logDIH.yr3];
        data = data(1:end-r,:);
        ndrug = size(drugs.features3_1yr,2);
        ntraits = size(data,2) - ndrug;
        for i = 1:k
            first = (i-1)*klen + 1; last = i*klen;
            test = data(first:last,:);
            train = [data(1:first-1,:); data(last+1:end,:)]; 
            % optimize on train -> get parameters
            [target.DIH, params] = computeTargetDIH_agesexdrug(target,train(:,1),train(:,2),train(:,end),train(:,3:end-1),zeros(70942,7));
            model_parameters(:,i) = params;
            % use params on test -> get accuracy
            logDIH_test = 0;
            for j = 1:ntraits-1
                logDIH_test = logDIH_test + params(offsets(j)+test(:,j));
            end
            logDIH_test = logDIH_test + test(:,ntraits:end-1)*params(offsets(ntraits)+1:end);
            accuracy = sqrt(1/klen)*norm(logDIH_test - logDIH.yr3(first:last));
            model_accuracies(i) = accuracy; 
        end
    case 'agesexdruglab'
        drugs = readDrugCounts(target,members);
        lab = readLabCounts(target,members);
        offsets = [...
                    length(BUCKET_RANGES.AGE),...
                    length(BUCKET_RANGES.SEX),...
                    length(BUCKET_RANGES.DRUG_1YR),...
                    length(BUCKET_RANGES.LAB_1YR),...
                    ];
        offsets = cumsum(offsets);
        nparams = offsets(end);
        offsets = [0; offsets(1:end)'];
        model_accuracies = zeros(k, 1);
        model_parameters = zeros(nparams, k);
        data = [ages.yr3 genders.yr3 drugs.features3_1yr logDIH.yr3];
        data = data(1:end-r,:);
        ntraits = size(data,2) - 1;
        for i = 1:k
            first = (i-1)*klen + 1; last = i*klen;
            test = data(first:last,:);
            train = [data(1:first-1,:); data(last+1:end,:)]; 
            % optimize on train -> get parameters
            [target.DIH, params] = computeTargetDIH_agesexdruglab(target,train(:,1),train(:,2),train(:,4),train(:,3));
            model_parameters(:,i) = params;
            % use params on test -> get accuracy
            logDIH_test = 0;
            for j = 1:num_traits-1
                logDIH_test = logDIH_test + params(offsets(j)+test(:,j));
            end
            logDIH_test = logDIH_test + test(:,ntraits)*params(offsets(ntraits)+test(:,ntraits));
            accuracy = sqrt(1/klen)*norm(logDIH_test - logDIH.yr3(first:last));
            model_accuracies(i) = accuracy; 
        end
        [target.DIH, params] = computeTargetDIH_agesexdruglab(target,ages,genders,logDIH,drugs,lab);
    otherwise
        data = logDIH.yr3;
        data = data(1:end-r,:);
        params = cell(2,1);
        params{1,1} = 1;
        params{2,1} = 0.2; 
end

mean_accuracy = mean(model_accuracies); % for model selection/comparison
mean_parameters = mean(model_parameters, 2); % for adjusted model parameters



