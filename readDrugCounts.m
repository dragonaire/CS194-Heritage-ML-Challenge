function drugs = readDrugCounts(target,members)
try
    load('drugs.mat');
    return;
catch
    'Drugs were not cached! This could take a few seconds.'
end
constants;
fid = fopen('DrugCount.csv','rt');
C = textscan(fid,'%f %s %s %s','Delimiter',',','CollectOutput',1);
fclose(fid);
[drugs.members, drugs.members_i] = sort(C{1});
stringDrugYear = C{2}(drugs.members_i,1);
drugs.year = strcmp(stringDrugYear, 'Y1') + 2*strcmp(stringDrugYear, 'Y2') + ...
    3*strcmp(stringDrugYear, 'Y3');
stringDrugDSFS = C{2}(drugs.members_i,2);
drugs.DSFS = parseMonthCounts(stringDrugDSFS);
drugs.count = str2double(C{2}(drugs.members_i,3));
drugs.count(isnan(drugs.count)) = MAX_DRUG_COUNT; % for replacing 7+ with 7

% Compute drug features from a combination of the year and count. 
% Use 2 past years and 7 counts.
% ex: for year3 we use years 1 and 2
drugs.features3_2yrs = MAX_DRUG_COUNT*(drugs.year-1)+drugs.count;
drugs.features3_2yrs(drugs.features3_2yrs>2*MAX_DRUG_COUNT) = 0;
drugs.features3_2yrs = formFeaturesMatrix(drugs.features3_2yrs, ...
    2*MAX_DRUG_COUNT, members.yr3, drugs.members);
% year 4 features:
drugs.features4_2yrs = MAX_DRUG_COUNT*(drugs.year-2)+drugs.count;
drugs.features4_2yrs(drugs.features4_2yrs<=0) = 0;
drugs.features4_2yrs = formFeaturesMatrix(drugs.features4_2yrs, ...
    2*MAX_DRUG_COUNT, target.memberids, drugs.members);
% just use past year
drugs.features2_1yr = MAX_DRUG_COUNT*(drugs.year-1)+drugs.count;
drugs.features2_1yr(drugs.features2_1yr>MAX_DRUG_COUNT) = 0;
drugs.features2_1yr = formFeaturesMatrix(drugs.features2_1yr, ...
    MAX_DRUG_COUNT, members.yr2, drugs.members);
drugs.features3_1yr = MAX_DRUG_COUNT*(drugs.year-2)+drugs.count;
drugs.features3_1yr(drugs.features3_1yr>MAX_DRUG_COUNT) = 0;
drugs.features3_1yr(drugs.features3_1yr<=0) = 0;
drugs.features3_1yr = formFeaturesMatrix(drugs.features3_1yr, ...
    MAX_DRUG_COUNT, members.yr3, drugs.members);
drugs.features4_1yr = MAX_DRUG_COUNT*(drugs.year-3)+drugs.count;
drugs.features4_1yr(drugs.features4_1yr<=0) = 0;
drugs.features4_1yr = formFeaturesMatrix(drugs.features4_1yr, ...
    MAX_DRUG_COUNT, target.memberids, drugs.members);

% add some extra Drug features
days = [1;2;3;4;5;6;10]; % 10 is just an estimate of the average for 7+
disp('extra drug features year 2');
drugs.extrafeatures2 = getExtraFeatures(drugs.features2_1yr,days,0);
disp('extra drug features year 3');
drugs.extrafeatures3 = getExtraFeatures(drugs.features3_1yr,days,0);
disp('extra drug features year 4');
drugs.extrafeatures4 = getExtraFeatures(drugs.features4_1yr,days,0);
% remove the empty column for number of missing entries
drugs.extrafeatures2 = drugs.extrafeatures2(:,[1,2,3,4,6,7]);
drugs.extrafeatures3 = drugs.extrafeatures3(:,[1,2,3,4,6,7]);
drugs.extrafeatures4 = drugs.extrafeatures4(:,[1,2,3,4,6,7]);
save('drugs.mat','drugs');
end