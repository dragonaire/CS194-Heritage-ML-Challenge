constants;
tic
allDIH = []; NUM_OUTPUTS = 0;
yr4_rmse = [];

try
    load('cache/makePredictions_10.mat');
catch
    target.DIH = computeTargetDIH_sexonly(target,logDIH.genders.yr3);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0];

    target.DIH = computeTargetDIH_ageonly(target,bins.yr3);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0];

    target.DIH = computeTargetDIH_agesex(target,ages.yr3,genders.yr3,logDIH.yr3);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.478139];

    target.DIH = computeTargetDIH_agesexdrug(target,ages.yr3,genders.yr3,...
        logDIH.yr3,drugs.features3_1yr,drugs.features4_1yr);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0];

    target.DIH = computeTargetDIH_agesexdruglab(ages.yr3,genders.yr3,logDIH.yr3,...
        target.ages,target.genders,drugs.features3_1yr,drugs.features4_1yr,...
        lab.features3_1yr,lab.features4_1yr);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0];

    target.DIH = computeTargetDIH_agesexdruglab_sqrt(ages.yr3,genders.yr3,logDIH.yr3,...
        target.ages,target.genders,drugs.features3_1yr,drugs.features4_1yr,...
        lab.features3_1yr,lab.features4_1yr);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0];

    target.DIH = computeTargetDIH_agesexcombo_druglab(ages.yr3,genders.yr3,logDIH.yr3,...
        target.ages,target.genders,drugs.features3_1yr,drugs.features4_1yr,...
        lab.features3_1yr,lab.features4_1yr);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.475212];

    target.DIH = computeTargetDIH_agesexcombo_druglabcondproc(ages.yr3,genders.yr3,logDIH.yr3,...
        target.ages,target.genders,drugs.features3_1yr,drugs.features4_1yr,...
        lab.features3_1yr,lab.features4_1yr,claims.f3.condGroup,claims.f4.condGroup,...
        claims.f3.procedure,claims.f4.procedure);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.468767];

    target.DIH = computeTargetDIH_agesexcombo_druglabcondproc_loscharlson(...
        ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
        drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
        claims.f3.condGroup,claims.f4.condGroup,claims.f3.procedure,claims.f4.procedure,...
        claims.f3.LoS,claims.f4.LoS,claims.f3.charlson,claims.f4.charlson);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.465748];

    target.DIH = computeTargetDIH_many1(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
        drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
        claims.f3.condGroup,claims.f4.condGroup,claims.f3.procedure,claims.f4.procedure,...
        claims.f3.LoS,claims.f4.LoS,claims.f3.charlson,claims.f4.charlson,...
        claims.f3.specialty,claims.f4.specialty,claims.f3.place,claims.f4.place);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.465563];
    
    save('cache/makePredictions_10.mat','allDIH','NUM_OUTPUTS','yr4_rmse');
end

target.DIH = computeTargetDIH_many3(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
    drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
    claims.f3.condGroup,claims.f4.condGroup,claims.f3.procedure,claims.f4.procedure,...
    claims.f3.LoS,claims.f4.LoS,claims.f3.charlson,claims.f4.charlson,...
    claims.f3.specialty,claims.f4.specialty,claims.f3.place,claims.f4.place,...
    claims.f3.DSFS,claims.f4.DSFS);
allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
yr4_rmse = [yr4_rmse; 0.468814]; %TODO change this

target.DIH = computeTargetDIH_catvec1_agesex(target,ages.yr3,genders.yr3,logDIH.yr3,...
    target.ages,target.genders);
allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
yr4_rmse = [yr4_rmse; 0.477704];

target.DIH = computeTargetDIH_catvec1_many1(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
    drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
    claims.f3.condGroup,claims.f4.condGroup,claims.f3.procedure,claims.f4.procedure,...
    claims.f3.LoS,claims.f4.LoS,...
    claims.f3.specialty,claims.f4.specialty,claims.f3.place,claims.f4.place,MANY1_NUMPC);
allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
yr4_rmse = [yr4_rmse; 0.466355];

target.DIH = computeTargetDIH_catvec1_many2(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
    drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
    claims.f3.condGroup,claims.f4.condGroup,claims.f3.procedure,claims.f4.procedure,...
    claims.f3.specialty,claims.f4.specialty,claims.f3.place,claims.f4.place,MANY2_NUMPC);
allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
yr4_rmse = [yr4_rmse; 0.465685];

good = 9:14;
%get median DIH for each member of our good predictors
target.DIH = median(allDIH(:,good),2);
allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
toc

%get median DIH for each member
target.DIH = median(allDIH,2);
allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
toc

%ridge regression.
indices = find(yr4_rmse > 0);
[target.DIH,weights] = ridgeRegression(allDIH(:,indices), LEADERBOARD_VAR,...
    LEADERBOARD_OPT_CONST, yr4_rmse(indices));
weights'
allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);

if(max(max(allDIH)) > 15)
    disp('XXXXXXXXXXXXXXXXXXXXXXXXXXXXX ERROR IN MAKE PREDS');
end