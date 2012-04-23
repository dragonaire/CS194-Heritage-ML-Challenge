clear;
readMembers;
readDIH;
readTarget;
[ labcount_members, lab_years, lab_duration, lab_count ] = readLabCounts();
[ drugcount_members, drug_years, drug_duration, drug_count ] = readDrugCounts();

%TODO clean up member numbers to be in the range 1-113000 and keep a
%mapping back to original numbers



%TODO compute training error

%computeTargetDIH_constant;
computeTargetDIH_sexonly;
writeTarget;
