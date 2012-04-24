function [ drugcount_members, drug_years, drug_duration, drug_count ] = readDrugCounts()
fid = fopen('DrugCount.csv','rt');
C = textscan(fid,'%f %s %s %s','Delimiter',',','CollectOutput',1);
fclose(fid);
[drugcount_members, drugcount_members_i] = sort(C{1});
stringDrugYear = C{2}(drugcount_members_i,1);
drug_years = strcmp(stringDrugYear, 'Y1') + 2*strcmp(stringDrugYear, 'Y2') + ...
    3*strcmp(stringDrugYear, 'Y3');
%TODO this might mean something other than drug duration? what is DSFS
stringDrugDuration = C{2}(drugcount_members_i,2);
drug_duration = parseMonthCounts(stringDrugDuration);
drug_count = str2double(C{2}(drugcount_members_i,3));
drug_count(find(isnan(drug_count))) = 10; % for replacing 10+ with 10
end
