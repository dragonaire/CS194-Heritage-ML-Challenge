function drugs = readDrugCounts()
fid = fopen('DrugCount.csv','rt');
C = textscan(fid,'%f %s %s %s','Delimiter',',','CollectOutput',1);
fclose(fid);
[drugs.members, drugs.members_i] = sort(C{1});
stringDrugYear = C{2}(drugs.members_i,1);
drugs.years = strcmp(stringDrugYear, 'Y1') + 2*strcmp(stringDrugYear, 'Y2') + ...
    3*strcmp(stringDrugYear, 'Y3');
%TODO this might mean something other than drug duration? what is DSFS
stringDrugDuration = C{2}(drugs.members_i,2);
drugs.duration = parseMonthCounts(stringDrugDuration);
drugs.count = str2double(C{2}(drugs.members_i,3));
drugs.count(find(isnan(drugs.count))) = 7; % for replacing 7+ with 7
end
