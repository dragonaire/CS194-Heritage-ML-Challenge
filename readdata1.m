clear;
tic
[members,genders,ages] = readMembers();
[members,logDIH,DIH,genders,ages,claimsTrunc] = readDIH(members,genders,ages);
bins = extractBins(DIH,genders,ages);
target = readTarget(members, genders, ages);
toc
drugs = readDrugCounts(target,members);
toc
lab = readLabCounts(target,members);
toc
%TODO organize claims by member
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
allDIH = []; NUM_TARGETS = 0;

target.DIH = computeTargetDIH_sexonly(target,logDIH);
allDIH = [allDIH, target.DIH]; NUM_TARGETS = NUM_TARGETS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_TARGETS),target);

target.DIH = computeTargetDIH_ageonly(target,bins);
allDIH = [allDIH, target.DIH]; NUM_TARGETS = NUM_TARGETS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_TARGETS),target);

target.DIH = computeTargetDIH_DIHonly(target,logDIH,members,true);
allDIH = [allDIH, target.DIH]; NUM_TARGETS = NUM_TARGETS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_TARGETS),target);

target.DIH = computeTargetDIH_agesex(target,ages.yr3,genders.yr3,logDIH.yr3,bins);
allDIH = [allDIH, target.DIH]; NUM_TARGETS = NUM_TARGETS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_TARGETS),target);

target.DIH = computeTargetDIH_agesexdrug(target,ages.yr3,genders.yr3,...
    logDIH.yr3,drugs.features3_1yr,drugs.features4_1yr);
allDIH = [allDIH, target.DIH]; NUM_TARGETS = NUM_TARGETS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_TARGETS),target);

target.DIH = computeTargetDIH_agesexdruglab(ages.yr3,genders.yr3,logDIH.yr3,...
    target.ages,target.genders,drugs.features3_1yr,drugs.features4_1yr,...
    lab.features3_1yr,lab.features4_1yr);
allDIH = [allDIH, target.DIH]; NUM_TARGETS = NUM_TARGETS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_TARGETS),target);

target.DIH = computeTargetDIH_agesexdruglab_sqrt(ages.yr3,genders.yr3,logDIH.yr3,...
    target.ages,target.genders,drugs.features3_1yr,drugs.features4_1yr,...
    lab.features3_1yr,lab.features4_1yr);
allDIH = [allDIH, target.DIH]; NUM_TARGETS = NUM_TARGETS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_TARGETS),target);

target.DIH = computeTargetDIH_agesexcombo_druglab(ages.yr3,genders.yr3,logDIH.yr3,...
    target.ages,target.genders,drugs.features3_1yr,drugs.features4_1yr,...
    lab.features3_1yr,lab.features4_1yr);
allDIH = [allDIH, target.DIH]; NUM_TARGETS = NUM_TARGETS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_TARGETS),target);

%get median DIH for each member
target.DIH = median(allDIH,2);
allDIH = [allDIH, target.DIH]; NUM_TARGETS = NUM_TARGETS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_TARGETS),target);
toc
'DONE!'
