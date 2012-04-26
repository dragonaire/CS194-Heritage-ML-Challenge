clear;
tic
[members,genders,ages] = readMembers();
[members,logDIH,DIH,genders,ages,claimsTrunc] = readDIH(members,genders,ages);
bins = extractBins(DIH,genders,ages);
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
allDIH = zeros(NUM_TARGETS, 6);

target.DIH = computeTargetDIH_sexonly(target,logDIH);
allDIH(:,1) = target.DIH;
writeTarget('Target_1.csv',target);

target.DIH = computeTargetDIH_ageonly(target,bins);
allDIH(:,2) = target.DIH;
writeTarget('Target_2.csv',target);

%target.DIH = computeTargetDIH_DIHonly(target,logDIH);
allDIH(:,3) = target.DIH;
writeTarget('Target_3.csv',target);

target.DIH = computeTargetDIH_agesex23(target,ages,genders,logDIH);
allDIH(:,4) = target.DIH;
writeTarget('Target_4.csv',target);

%target.DIH = computeTargetDIH_agesex3(target,members,ages,genders3,DIH3);
allDIH(:,5) = target.DIH;
writeTarget('Target_5.csv',target);

%get median DIH for each member
target.DIH = median(allDIH,2);
writeTarget('Target_6.csv',target);
toc
'DONE!'
