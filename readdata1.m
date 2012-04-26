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

%target.condGroup = extractMemberTraits(claim_members, target.memberids, condGroup);
%target.proc = extractMemberTraits(claim_members, target.memberids, procedure);
toc

%TODO clean up member numbers to be in the range 1-113000 and keep a
%mapping back to original numbers



%TODO compute training error

%computeTargetDIH_constant;
tic
constants;
allDIH = zeros(NUM_TARGETS, 3);

target.DIH = computeTargetDIH_sexonly(target,logDIH);
allDIH(:,1) = target.DIH;
writeTarget('Target_1.csv',target);
target.DIH = computeTargetDIH_ageonly(target,bins);
allDIH(:,2) = target.DIH;
writeTarget('Target_2.csv',target);
target.DIH = computeTargetDIH_DIHonly(target,logDIH);
allDIH(:,3) = target.DIH;
writeTarget('Target_3.csv',target);

%get median DIH for each member
target.DIH = median(allDIH,2);
writeTarget('Target_4.csv',target);
toc
'DONE!'
