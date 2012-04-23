clear;
tic
constants;
readMembers;
readDIH;
getLogTraits;
readTarget;
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
computeTargetDIH_sexonly;
target_params.DIH = target_DIH;
writeTarget('Target_1.csv',target_params);
computeTargetDIH_ageonly;
target_params.DIH = target_DIH;
writeTarget('Target_2.csv',target_params);
toc
'DONE!'