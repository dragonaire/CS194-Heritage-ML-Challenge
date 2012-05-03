function drugs = readDrugCounts(target,members)
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
drugs.count(isnan(drugs.count)) = 7; % for replacing 7+ with 7

% Compute drug features from a combination of the year and count. 
% Use 2 past years and 7 counts.
% ex: for year3 we use years 1 and 2
drugs.features3_2yrs = 7*(drugs.year-1)+drugs.count;
drugs.features3_2yrs(drugs.features3_2yrs>14) = 0;
drugs.features3_2yrs = formFeaturesMatrix(drugs.features3_2yrs, 14, members.yr3, drugs.members);
% year 4 features:
drugs.features4_2yrs = 7*(drugs.year-2)+drugs.count;
drugs.features4_2yrs(drugs.features4_2yrs<=0) = 0;
drugs.features4_2yrs = formFeaturesMatrix(drugs.features4_2yrs, 14, target.memberids, drugs.members);
% just use past year
drugs.features3_1yr = 7*(drugs.year-2)+drugs.count;
drugs.features3_1yr(drugs.features3_1yr>7) = 0;
drugs.features3_1yr(drugs.features3_1yr<=0) = 0;
drugs.features3_1yr = formFeaturesMatrix(drugs.features3_1yr, 7, members.yr3, drugs.members);
drugs.features4_1yr = 7*(drugs.year-3)+drugs.count;
drugs.features4_1yr(drugs.features4_1yr<=0) = 0;
drugs.features4_1yr = formFeaturesMatrix(drugs.features4_1yr, 7, target.memberids, drugs.members);
end
function features = formFeaturesMatrix(f, range, members, drug_members)
    features = zeros(length(members),range);
    i=1;
    for m=1:length(members)
        while drug_members(i) <= members(m)
            if drug_members(i) == members(m) && f(i) ~= 0
                features(m,f(i)) = features(m,f(i)) + 1;
            end
            i = i + 1;
            if i > length(drug_members)
                break;
            end
        end
    end
end