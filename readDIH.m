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
[ DIH_genders, members23 ] = ...
    combineYears( DIH2_memberids, DIH3_memberids, DIH_genders2, DIH_genders3, true );
[ DIH23, members23 ] = combineYears( DIH2_memberids, DIH3_memberids, DIH2, DIH3, true );

DIHmale = DIH23(DIH_genders==MALE);
DIHfemale = DIH23(DIH_genders==FEMALE);
DIHnosex = DIH23(DIH_genders==NOSEX);

logDIHmale = log(DIHmale+1);
logDIHfemale = log(DIHfemale+1);
logDIHnosex = log(DIHnosex+1);