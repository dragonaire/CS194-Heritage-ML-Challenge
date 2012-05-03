function lab = readLabCounts()
fid = fopen('LabCount.csv','rt');
C = textscan(fid,'%f %s %s %s','Delimiter',',','CollectOutput',1);
fclose(fid);
[lab.members, lab.members_i] = sort(C{1});
stringLabYear = C{2}(lab.members_i,1);
lab.years = strcmp(stringLabYear, 'Y1') + 2*strcmp(stringLabYear, 'Y2') + ...
    3*strcmp(stringLabYear, 'Y3');
stringLabDSFS = C{2}(lab.members_i,2);
lab.DSFS = parseMonthCounts(stringLabDSFS);
lab.count = str2double(C{2}(lab.members_i,3));
lab.count(isnan(lab.count)) = 10; % for replacing 10+ with 10
end
