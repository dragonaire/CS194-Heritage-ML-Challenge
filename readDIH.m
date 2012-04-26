function [members,logDIH,DIH,genders,ages,claimsTrunc] = readDIH(members,genders,ages)
constants;
fid = fopen('DaysInHospital_Y2.csv','rt');
C = textscan(fid,'%f %f %f','Delimiter',',','CollectOutput',1);
fclose(fid);
[members.yr2, DIH2_memberids_i] = sort(C{1}(:,1));
claimsTrunc.yr2 = C{1}(DIH2_memberids_i,2);
DIH.yr2 = C{1}(DIH2_memberids_i,3);
fid = fopen('DaysInHospital_Y3.csv','rt');
C = textscan(fid,'%f %f %f','Delimiter',',','CollectOutput',1);
fclose(fid);
[members.yr3, DIH3_memberids_i] = sort(C{1}(:,1));
claimsTrunc.yr3 = C{1}(DIH3_memberids_i,2);
DIH.yr3 = C{1}(DIH3_memberids_i,3);

% fill in missing 
genders.yr2 = extractMemberTraits( members.all, members.yr2, genders.all );
genders.yr3 = extractMemberTraits( members.all, members.yr3, genders.all );

% dont double count patients who were in both year 2 and year 3
[ genders.comb23, members.comb23 ] = ...
    combineYears( members.yr2, members.yr3, genders.yr2, genders.yr3, true );
[ DIH.comb23, members.comb23 ] = combineYears( members.yr2, members.yr3, DIH.yr2, DIH.yr3, true );

ages.yr2 = extractMemberTraits( members.all, members.yr2, ages.all);
ages.yr3 = extractMemberTraits( members.all, members.yr3, ages.all);
ages.comb23 = extractMemberTraits( members.all, members.comb23, ages.all);

DIHmale = DIH.comb23(genders.comb23==MALE);
DIHfemale = DIH.comb23(genders.comb23==FEMALE);
DIHnosex = DIH.comb23(genders.comb23==NOSEX);

logDIH.male = log(DIHmale+1);
logDIH.female = log(DIHfemale+1);
logDIH.nosex = log(DIHnosex+1);
logDIH.comb23 = log(DIH23+1);
logDIH.members23 = members23;
logDIH.yr2 = log(DIH.yr2+1);
logDIH.yr3 = log(DIH.yr3+1);

end
