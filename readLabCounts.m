function [ labcount_members, lab_years, lab_duration, lab_count ] = readLabCounts()
fid = fopen('LabCount.csv','rt');
C = textscan(fid,'%f %s %s %s','Delimiter',',','CollectOutput',1);
fclose(fid);
[labcount_members, labcount_members_i] = sort(C{1});
stringLabYear = C{2}(labcount_members_i,1);
lab_years = strcmp(stringLabYear, 'Y1') + 2*strcmp(stringLabYear, 'Y2') + ...
    3*strcmp(stringLabYear, 'Y3');
%TODO this might mean something other than lab duration? what is DSFS
stringLabDuration = C{2}(labcount_members_i,2);
lab_duration = parseMonthCounts(stringLabDuration);
lab_count = str2double(C{2}(labcount_members_i,3));
lab_count(isnan(lab_count)) = 10; % for replacing 10+ with 10
end
