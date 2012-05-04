function lab = readLabCounts(target,members)
try
    load('lab.mat');
    return;
catch
    'Lab counts were not cached! This could take a few seconds.'
end
constants;
fid = fopen('LabCount.csv','rt');
C = textscan(fid,'%f %s %s %s','Delimiter',',','CollectOutput',1);
fclose(fid);
[lab.members, lab.members_i] = sort(C{1});
stringLabYear = C{2}(lab.members_i,1);
lab.year = strcmp(stringLabYear, 'Y1') + 2*strcmp(stringLabYear, 'Y2') + ...
    3*strcmp(stringLabYear, 'Y3');
stringLabDSFS = C{2}(lab.members_i,2);
lab.DSFS = parseMonthCounts(stringLabDSFS);
lab.count = str2double(C{2}(lab.members_i,3));
lab.count(isnan(lab.count)) = MAX_LAB_COUNT; % for replacing 10+ with 10

% Compute lab features from a combination of the year and count. 
% Use 2 past years and 7 counts.
% ex: for year3 we use years 1 and 2
lab.features3_2yrs = MAX_LAB_COUNT*(lab.year-1)+lab.count;
lab.features3_2yrs(lab.features3_2yrs>2*MAX_LAB_COUNT) = 0;
lab.features3_2yrs = formFeaturesMatrix(lab.features3_2yrs, ...
    2*MAX_LAB_COUNT, members.yr3, lab.members);
% year 4 features:
lab.features4_2yrs = MAX_LAB_COUNT*(lab.year-2)+lab.count;
lab.features4_2yrs(lab.features4_2yrs<=0) = 0;
lab.features4_2yrs = formFeaturesMatrix(lab.features4_2yrs, ...
    2*MAX_LAB_COUNT, target.memberids, lab.members);
% just use past year
lab.features2_1yr = MAX_LAB_COUNT*(lab.year-1)+lab.count;
lab.features2_1yr(lab.features2_1yr>MAX_LAB_COUNT) = 0;
lab.features2_1yr = formFeaturesMatrix(lab.features2_1yr, ...
    MAX_LAB_COUNT, members.yr2, lab.members);
lab.features3_1yr = MAX_LAB_COUNT*(lab.year-2)+lab.count;
lab.features3_1yr(lab.features3_1yr>MAX_LAB_COUNT) = 0;
lab.features3_1yr(lab.features3_1yr<=0) = 0;
lab.features3_1yr = formFeaturesMatrix(lab.features3_1yr, ...
    MAX_LAB_COUNT, members.yr3, lab.members);
lab.features4_1yr = MAX_LAB_COUNT*(lab.year-3)+lab.count;
lab.features4_1yr(lab.features4_1yr<=0) = 0;
lab.features4_1yr = formFeaturesMatrix(lab.features4_1yr, ...
    MAX_LAB_COUNT, target.memberids, lab.members);
save('lab.mat','lab');
end
