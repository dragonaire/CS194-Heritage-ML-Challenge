function [target_DIH, mean_parameters] = cross_validation(model_name)
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
klen = floor(members3/k);  % fold size length
r = rem(members3,k);  % leave out the remainder
constants;
switch model_name
    case 'sexonly'
        % [target.DIH, params] = computeTargetDIH_sexonly(target,logDIH);
    case 'ageonly'
        % [target.DIH, params] = computeTargetDIH_ageonly(target,bins);
    case 'DIHonly'
        % [target.DIH, params] = computeTargetDIH_DIHonly(target,logDIH,members,true);
    case 'agesex'  % tested, mean rms = 0.4605
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
    case 'agesexdrug' % tested, mean rms = 0.4580
        load drugs;
        offsets = [...
                    length(BUCKET_RANGES.AGE),...
                    length(BUCKET_RANGES.SEX),...
                    length(BUCKET_RANGES.DRUG_1YR),...
                    ];
        nparams = sum(offsets);
        offsets = cumsum(offsets);
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
            [target.DIH, params] = computeTargetDIH_agesexdrug(target,train(:,1),train(:,2),train(:,end),train(:,3:end-1),zeros(70942,7));
            model_parameters(:,i) = params;
            logDIH_test = 0;
            for j = 1:ntraits-1
                logDIH_test = logDIH_test + params(offsets(j)+test(:,j));
            end
            logDIH_test = logDIH_test + test(:,ntraits:end-1)*params(offsets(ntraits)+1:end);
            accuracy = sqrt(1/klen)*norm(logDIH_test - logDIH.yr3(first:last));
            model_accuracies(i) = accuracy; 
        end
    case 'agesexdruglab'  % TODO
        load drugs; load lab;
        offsets = [...
                    length(BUCKET_RANGES.AGE),...
                    length(BUCKET_RANGES.SEX),...
                    length(BUCKET_RANGES.DRUG_1YR),...
                    length(BUCKET_RANGES.LAB_1YR),...
                    ];
        nparams = sum(offsets);
        offsets = cumsum(offsets);
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
            [target.DIH, params] = computeTargetDIH_agesexdruglab(target,train(:,1),train(:,2),train(:,4),train(:,3));
            model_parameters(:,i) = params;
            logDIH_test = 0;
            for j = 1:num_traits-1
                logDIH_test = logDIH_test + params(offsets(j)+test(:,j));
            end
            logDIH_test = logDIH_test + test(:,ntraits)*params(offsets(ntraits)+test(:,ntraits));
            accuracy = sqrt(1/klen)*norm(logDIH_test - logDIH.yr3(first:last));
            model_accuracies(i) = accuracy; 
        end
    case 'many1'
        load drugs; load lab; load claims;
        offsets = [...
                    1,1,...
                    SIZE.DRUG_1YR,...
                    SIZE.LAB_1YR,...
                    SIZE.COND_GROUP,...
                    SIZE.PROCEDURE,...
                    SIZE.LoS,...
                    SIZE.CHARLSON,...
                    SIZE.SPECIALTY,...
                    SIZE.PLACE,...
                    ];
        nparams = sum(offsets) + SIZE.AGE*SIZE.SEX - 2;
        offsets = cumsum(offsets);
        ofs = [0; offsets(1:end)'];
        model_accuracies = zeros(k, 1);
        model_parameters = zeros(nparams, k);
        data_yr3 = [ages.yr3, genders.yr3, ...
                drugs.features3_1yr, lab.features3_1yr, ...
                claims.f3.condGroup, claims.f3.procedure, ...
                claims.f3.LoS, claims.f3.charlson, ...
                claims.f3.specialty, claims.f3.place, ...
                logDIH.yr3 ]; %71435x125
        %[m, n] = size(data_yr3);
        data_yr4 = [target.ages, target.genders, ...
                drugs.features4_1yr, lab.features4_1yr, ...
                claims.f4.condGroup, claims.f4.procedure, ...
                claims.f4.LoS, claims.f4.charlson, ...
                claims.f4.specialty, claims.f4.place ]; %70942x124
        %ntraits = 9;
        for i = 1:k
            first = (i-1)*klen + 1; last = i*klen;
            validate = data_yr3(first:last,:);
            train = [data_yr3(1:first-1,:); data_yr3(last+1:end,:)]; 
            [target_DIH, params] = computeTargetDIH_many1( ...
                train(:,1),train(:,2),train(:,end),...
                data_yr4(:,1),data_yr4(:,2),...
                train(:,ofs(3)+1:ofs(4)),data_yr4(:,ofs(3)+1:ofs(4)),...
                train(:,ofs(4)+1:ofs(5)),data_yr4(:,ofs(4)+1:ofs(5)),...
                train(:,ofs(5)+1:ofs(6)),data_yr4(:,ofs(5)+1:ofs(6)),...
                train(:,ofs(6)+1:ofs(7)),data_yr4(:,ofs(6)+1:ofs(7)),...
                train(:,ofs(7)+1:ofs(8)),data_yr4(:,ofs(7)+1:ofs(8)),...
                train(:,ofs(8)+1:ofs(9)),data_yr4(:,ofs(8)+1:ofs(9)),...
                train(:,ofs(9)+1:ofs(10)),data_yr4(:,ofs(9)+1:ofs(10)),...
                train(:,ofs(10)+1:ofs(11)),data_yr4(:,ofs(10)+1:ofs(11)) );
             model_parameters(:,i) = params;
        end
    otherwise
        data = logDIH.yr3;
        data = data(1:end-r,:);
        params = cell(2,1);
        params{1,1} = 1;
        params{2,1} = 0.2; 
end

% for model selection/comparison
mean_accuracy = mean(model_accuracies); 

% for adjusted model parameters
mean_parameters = mean(model_parameters, 2); 

% save('xval_many1.mat','target_DIH','M','mean_parameters','model_parameters','data_yr3','data_yr4','ofs');
% load xval_many1;
% xval_target_DIH = M*mean_parameters;
% xval_target_DIH = exp(xval_target_DIH)-1;
% target.DIH = xval_target_DIH;
% writeTarget(sprintf('Target_%d.csv',12),target);
end
