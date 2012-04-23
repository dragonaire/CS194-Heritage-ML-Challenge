clear;
readMembers;
readDIH;
getLogTraits;
readTarget;

%TODO clean up member numbers to be in the range 1-113000 and keep a
%mapping back to original numbers



%TODO compute training error

%computeTargetDIH_constant;
computeTargetDIH_sexonly;
writeTarget('Target_1.csv');
computeTargetDIH_ageonly;
writeTarget('Target_2.csv');