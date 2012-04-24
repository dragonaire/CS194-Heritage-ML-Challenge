clear;
tic
[members,genders,ages] = readMembers();
[members23,logDIH,DIH23,genders23,ages23] = readDIH(members,genders,ages);
bins = extractBins(DIH23,genders23,ages23);
target = readTarget(members, genders, ages);
toc
%TODO organize claims by member
tic
[ claim_members,provider,vendor,pcp,year,specialty,place,payDelay,LoS,...
    DSFS,condGroup,charlson,procedure] = readClaims();
toc

%TODO clean up member numbers to be in the range 1-113000 and keep a
%mapping back to original numbers



%TODO compute training error

%computeTargetDIH_constant;
tic
target.DIH = computeTargetDIH_sexonly(target,logDIH);
writeTarget('Target_1.csv',target);
target.DIH = computeTargetDIH_ageonly(target,bins);
writeTarget('Target_2.csv',target);
toc
'DONE!'