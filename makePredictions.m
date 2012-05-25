constants;
tic
allDIH = []; NUM_OUTPUTS = 0;
yr4_rmse = [];
try
    load('claims_all.mat');
catch
    save('claims_all.mat', 'claims');
end
try
    load('f2.mat');
catch
    f2 = claims.f2;
    save('f2.mat','f2');
end
clear f2;
try
    load('f3.mat');
catch
    f3 = claims.f3;
    save('f3.mat','f3');
end
try
    load('f4.mat');
catch
    f4 = claims.f4;
    save('f4.mat','f4');
end
clear claims;
try
    load('cache/makePredictions_27.mat');
catch
    %1
    target.DIH = computeTargetDIH_sexonly(target,logDIH.genders.yr3);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0];

    %2
    target.DIH = computeTargetDIH_ageonly(target,bins.yr3);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0];

    %3
    target.DIH = computeTargetDIH_agesex(target,ages.yr3,genders.yr3,logDIH.yr3);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.478139];
    %4
    target.DIH = computeTargetDIH_agesexdrug(target,ages.yr3,genders.yr3,...
        logDIH.yr3,drugs.features3_1yr,drugs.features4_1yr);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0];

    %5
    target.DIH = computeTargetDIH_agesexdruglab(ages.yr3,genders.yr3,logDIH.yr3,...
        target.ages,target.genders,drugs.features3_1yr,drugs.features4_1yr,...
        lab.features3_1yr,lab.features4_1yr);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0];

    %6
    target.DIH = computeTargetDIH_agesexdruglab_sqrt(ages.yr3,genders.yr3,logDIH.yr3,...
        target.ages,target.genders,drugs.features3_1yr,drugs.features4_1yr,...
        lab.features3_1yr,lab.features4_1yr);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0];

    %7
    target.DIH = computeTargetDIH_agesexcombo_druglab(ages.yr3,genders.yr3,logDIH.yr3,...
        target.ages,target.genders,drugs.features3_1yr,drugs.features4_1yr,...
        lab.features3_1yr,lab.features4_1yr);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.475212];

    %8
    target.DIH = computeTargetDIH_agesexcombo_druglabcondproc(ages.yr3,genders.yr3,logDIH.yr3,...
        target.ages,target.genders,drugs.features3_1yr,drugs.features4_1yr,...
        lab.features3_1yr,lab.features4_1yr,f3.condGroup,f4.condGroup,...
        f3.procedure,f4.procedure);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.468767];

    %9
    target.DIH = computeTargetDIH_agesexcombo_druglabcondproc_loscharlson(...
        ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
        drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
        f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
        f3.LoS,f4.LoS,f3.charlson,f4.charlson);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.465748];

    %10
    target.DIH = computeTargetDIH_many1(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
        drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
        f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
        f3.LoS,f4.LoS,f3.charlson,f4.charlson,...
        f3.specialty,f4.specialty,f3.place,f4.place);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.465563];
    
    %11
    target.DIH = computeTargetDIH_many3(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
        drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
        f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
        f3.LoS,f4.LoS,f3.charlson,f4.charlson,...
        f3.specialty,f4.specialty,f3.place,f4.place,...
        f3.DSFS,f4.DSFS);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.466453];

    %12
    target.DIH = computeTargetDIH_catvec1_agesex(target,ages.yr3,genders.yr3,logDIH.yr3,...
        target.ages,target.genders);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.477704];

    %13
    target.DIH = computeTargetDIH_catvec1_many1(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
        drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
        f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
        f3.LoS,f4.LoS,...
        f3.specialty,f4.specialty,f3.place,f4.place,MANY1_NUMPC);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.466355];

    %14
    target.DIH = computeTargetDIH_catvec1_many2(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
        drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
        f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
        f3.specialty,f4.specialty,f3.place,f4.place,MANY2_NUMPC);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.465685];

    %15
    [target.DIH c4] = computeTargetDIH_n1(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
        drugs.extrafeatures3,drugs.extrafeatures4,lab.extrafeatures3,lab.extrafeatures4,...
        f3.nproviders,f4.nproviders,...
        f3.nvendors,f4.nvendors,f3.npcps,f4.npcps,f3.extraLoS,f4.extraLoS,f3.n,f4.n);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.470729];

    %16
    [target.DIH c4] = computeTargetDIH_many4(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
        drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
        f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
        f3.specialty,f4.specialty,f3.place,f4.place);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.466098];

    %17
    target.DIH = computeTargetDIH_catvec1_many3(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
        drugs.extrafeatures3,drugs.extrafeatures4,lab.extrafeatures3,lab.extrafeatures4,...
        f3.nproviders,f4.nproviders,...
        f3.nvendors,f4.nvendors,f3.npcps,f4.npcps,f3.extraLoS,f4.extraLoS,f3.n,f4.n);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0];

    %18
    [target.DIH c4] = computeTargetDIH_many5(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
        f3.specPlace,f4.specPlace);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0];

    %19
    [target.DIH c4] = computeTargetDIH_condspeccombo(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
        f3.condSpec,f4.condSpec);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.468997];

    %20
    [target.DIH c4] = computeTargetDIH_condplacecombo(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
        f3.condPlace,f4.condPlace);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.468812];

    %21
    target.DIH = median(allDIH(:,9:14),2);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.465355];

    %22
    target.DIH = median(allDIH(:,9:20),2);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0];

    %23
    target.DIH = median(allDIH,2);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.470156];
    
    %24
    target.DIH = exp(mean(log(allDIH(:,9:22)+1),2))-1;
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0];
    
    %25
    [target.DIH c4] = computeTargetDIH_n2(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
        drugs.extrafeatures3,drugs.extrafeatures4,lab.extrafeatures3,lab.extrafeatures4,...
        f3.nproviders,f4.nproviders,f3.nvendors,f4.nvendors,f3.npcps,f4.npcps,f3.extraLoS,f4.extraLoS,...
        f3.n,f4.n,f3.nspec,f4.nspec,f3.nplace,f4.nplace,f3.nproc,f4.nproc,f3.ncond,f4.ncond,...
        f3.extraDSFS,f4.extraDSFS,f3.extraCharlson,f4.extraCharlson,...
        f3.extraPcpProvVend,f4.extraPcpProvVend);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.469522];
    
    %26
    target.DIH = readPredictions('TargetGBM3.csv');
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.462822];

    %27
    [target.DIH c4] = computeTargetDIH_many6(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
        drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
        f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
        f3.specialty,f4.specialty,f3.place,f4.place,...
        f3.DSFS,f4.DSFS,drugs.extrafeatures3,drugs.extrafeatures4,lab.extrafeatures3,lab.extrafeatures4,...
        f3.nproviders,f4.nproviders,f3.nvendors,f4.nvendors,f3.npcps,f4.npcps,f3.extraLoS,f4.extraLoS,...
        f3.n,f4.n,f3.nspec,f4.nspec,f3.nplace,f4.nplace,f3.nproc,f4.nproc,f3.ncond,f4.ncond,...
        f3.extraDSFS,f4.extraDSFS,f3.extraCharlson,f4.extraCharlson,...
        f3.extraPcpProvVend,f4.extraPcpProvVend);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0];
    
    save('cache/makePredictions_27.mat','allDIH','NUM_OUTPUTS','yr4_rmse');
end


%ridge regression.
allDIH = postProcessReal(allDIH);
have = find(yr4_rmse>0);
[ indices ] = chooseRidgePredictors(allDIH, LEADERBOARD_VAR,...
    LEADERBOARD_OPT_CONST, yr4_rmse, 0.3, have)
%indices = indices(indices>=9);
[target.DIH,weights] = ridgeRegression(allDIH(:,indices), LEADERBOARD_VAR,...
    LEADERBOARD_OPT_CONST, yr4_rmse(indices), 0.3);
weights'
allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);

if(max(max(allDIH)) > 15)
    max(allDIH)
    min(allDIH)
    disp('XXXXXXXXXXXXXXXXXXXXXXXXXXXXX ERROR IN MAKE PREDS');
end

clear f2 f3;