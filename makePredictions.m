%computeTargetDIH_constant;
tic
allDIH = []; NUM_TARGETS = 0;
target.DIH = computeTargetDIH_sexonly(target,logDIH.genders.yr3);
allDIH = [allDIH, target.DIH]; NUM_TARGETS = NUM_TARGETS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_TARGETS),target);

target.DIH = computeTargetDIH_ageonly(target,bins.yr3);
allDIH = [allDIH, target.DIH]; NUM_TARGETS = NUM_TARGETS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_TARGETS),target);

target.DIH = computeTargetDIH_DIHonly(target,logDIH,members,true);
allDIH = [allDIH, target.DIH]; NUM_TARGETS = NUM_TARGETS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_TARGETS),target);

target.DIH = computeTargetDIH_agesex(target,ages.yr3,genders.yr3,logDIH.yr3);
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

target.DIH = computeTargetDIH_agesexcombo_druglabcondproc(ages.yr3,genders.yr3,logDIH.yr3,...
    target.ages,target.genders,drugs.features3_1yr,drugs.features4_1yr,...
    lab.features3_1yr,lab.features4_1yr,claims.f3.condGroup,claims.f4.condGroup,...
    claims.f3.procedure,claims.f4.procedure);
allDIH = [allDIH, target.DIH]; NUM_TARGETS = NUM_TARGETS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_TARGETS),target);

target.DIH = computeTargetDIH_agesexcombo_druglabcondproc_loscharlson(...
    ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
    drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
    claims.f3.condGroup,claims.f4.condGroup,claims.f3.procedure,claims.f4.procedure,...
    claims.f3.LoS,claims.f4.LoS,claims.f3.charlson,claims.f4.charlson);
allDIH = [allDIH, target.DIH]; NUM_TARGETS = NUM_TARGETS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_TARGETS),target);

target.DIH = computeTargetDIH_many1(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
    drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
    claims.f3.condGroup,claims.f4.condGroup,claims.f3.procedure,claims.f4.procedure,...
    claims.f3.LoS,claims.f4.LoS,claims.f3.charlson,claims.f4.charlson,...
    claims.f3.specialty,claims.f4.specialty,claims.f3.place,claims.f4.place);
allDIH = [allDIH, target.DIH]; NUM_TARGETS = NUM_TARGETS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_TARGETS),target);

%get median DIH for each member
target.DIH = median(allDIH,2);
allDIH = [allDIH, target.DIH]; NUM_TARGETS = NUM_TARGETS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_TARGETS),target);
toc