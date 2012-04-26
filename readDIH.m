function [members23,logDIH,DIH23,genders23,ages23] = readDIH(members,genders,ages)
constants;
fid = fopen('DaysInHospital_Y2.csv','rt');
C = textscan(fid,'%f %f %f','Delimiter',',','CollectOutput',1);
fclose(fid);
[DIH2_memberids, DIH2_memberids_i] = sort(C{1}(:,1));
claimsTrunc2 = C{1}(DIH2_memberids_i,2);
DIH2 = C{1}(DIH2_memberids_i,3);
fid = fopen('DaysInHospital_Y3.csv','rt');
C = textscan(fid,'%f %f %f','Delimiter',',','CollectOutput',1);
fclose(fid);
[DIH3_memberids, DIH3_memberids_i] = sort(C{1}(:,1));
claimsTrunc3 = C{1}(DIH3_memberids_i,2);
DIH3 = C{1}(DIH3_memberids_i,3);

% fill in missing 
DIH_genders2 = extractMemberTraits( members, DIH2_memberids, genders );
DIH_genders3 = extractMemberTraits( members, DIH3_memberids, genders );

% dont double count patients who were in both year 2 and year 3
[ genders23, members23 ] = ...
    combineYears( DIH2_memberids, DIH3_memberids, DIH_genders2, DIH_genders3, true );
[ DIH23, members23 ] = combineYears( DIH2_memberids, DIH3_memberids, DIH2, DIH3, true );

ages23 = extractMemberTraits( members, members23, ages);

DIHmale = DIH23(genders23==MALE);
DIHfemale = DIH23(genders23==FEMALE);
DIHnosex = DIH23(genders23==NOSEX);

logDIH.male = log(DIHmale+1);
logDIH.female = log(DIHfemale+1);
logDIH.nosex = log(DIHnosex+1);
logDIH.comb23 = log(DIH23+1);
logDIH.members23 = members23;

end
