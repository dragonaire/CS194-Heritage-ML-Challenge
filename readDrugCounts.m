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
drugs.features3_1yr = MAX_DRUG_COUNT*(drugs.year-2)+drugs.count;
drugs.features3_1yr(drugs.features3_1yr>MAX_DRUG_COUNT) = 0;
drugs.features3_1yr(drugs.features3_1yr<=0) = 0;
drugs.features3_1yr = formFeaturesMatrix(drugs.features3_1yr, ...
    MAX_DRUG_COUNT, members.yr3, drugs.members);
drugs.features4_1yr = MAX_DRUG_COUNT*(drugs.year-3)+drugs.count;
drugs.features4_1yr(drugs.features4_1yr<=0) = 0;
drugs.features4_1yr = formFeaturesMatrix(drugs.features4_1yr, ...
    MAX_DRUG_COUNT, target.memberids, drugs.members);
save('drugs.mat','drugs');
end