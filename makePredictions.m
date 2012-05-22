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
    load('cache/makePredictions_14.mat');
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
        lab.features3_1yr,lab.features4_1yr,f3.condGroup,f4.condGroup,...
        f3.procedure,f4.procedure);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.468767];

    target.DIH = computeTargetDIH_agesexcombo_druglabcondproc_loscharlson(...
        ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
        drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
        f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
        f3.LoS,f4.LoS,f3.charlson,f4.charlson);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.465748];

    target.DIH = computeTargetDIH_many1(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
        drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
        f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
        f3.LoS,f4.LoS,f3.charlson,f4.charlson,...
        f3.specialty,f4.specialty,f3.place,f4.place);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.465563];
    
    target.DIH = computeTargetDIH_many3(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
        drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
        f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
        f3.LoS,f4.LoS,f3.charlson,f4.charlson,...
        f3.specialty,f4.specialty,f3.place,f4.place,...
        f3.DSFS,f4.DSFS);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.466453];

    target.DIH = computeTargetDIH_catvec1_agesex(target,ages.yr3,genders.yr3,logDIH.yr3,...
        target.ages,target.genders);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.477704];

    target.DIH = computeTargetDIH_catvec1_many1(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
        drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
        f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
        f3.LoS,f4.LoS,...
        f3.specialty,f4.specialty,f3.place,f4.place,MANY1_NUMPC);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.466355];

    target.DIH = computeTargetDIH_catvec1_many2(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
        drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
        f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
        f3.specialty,f4.specialty,f3.place,f4.place,MANY2_NUMPC);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.465685];
    
    save('cache/makePredictions_14.mat','allDIH','NUM_OUTPUTS','yr4_rmse');
end

[target.DIH c4] = computeTargetDIH_n1(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
    drugs.extrafeatures3,drugs.extrafeatures4,lab.extrafeatures3,lab.extrafeatures4,...
    f3.nproviders,f4.nproviders,...
    f3.nvendors,f4.nvendors,f3.npcps,f4.npcps,f3.extraLoS,f4.extraLoS,f3.n,f4.n);
allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
yr4_rmse = [yr4_rmse; 0.470729];

[target.DIH c4] = computeTargetDIH_many4(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
    drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
    f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
    f3.specialty,f4.specialty,f3.place,f4.place);
allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
%yr4_rmse = [yr4_rmse; 0.466098]; %dont include because it causes more
%overfitting than it's worth
yr4_rmse = [yr4_rmse; 0];

target.DIH = computeTargetDIH_catvec1_many3(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
    drugs.extrafeatures3,drugs.extrafeatures4,lab.extrafeatures3,lab.extrafeatures4,...
    f3.nproviders,f4.nproviders,...
    f3.nvendors,f4.nvendors,f3.npcps,f4.npcps,f3.extraLoS,f4.extraLoS,f3.n,f4.n);
allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
yr4_rmse = [yr4_rmse; 0];

[target.DIH c4] = computeTargetDIH_many5(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
    f3.specPlace,f4.specPlace);
allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
yr4_rmse = [yr4_rmse; 0];

good = 10:18;
%get median DIH for each member of our good predictors
target.DIH = median(allDIH(:,good),2);
allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
yr4_rmse = [yr4_rmse; 0.464582];
toc

%get median DIH for each member
target.DIH = median(allDIH,2);
allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
yr4_rmse = [yr4_rmse; 0.470156];
toc

%ridge regression.
indices = find(yr4_rmse > 0);
%indices = [6,9,11,12,13,14,18,size(all_yr3_pred,2)];
indices = [6,9,12,14,18,size(all_yr3_pred,2)];
if min(yr4_rmse(indices)) < eps
    disp('Missing a yr4_rmse');
    keyboard
    return
end
%indices = indices(indices>=9);
[target.DIH,weights] = ridgeRegression(allDIH(:,indices), LEADERBOARD_VAR,...
    LEADERBOARD_OPT_CONST, yr4_rmse(indices), 0.3);
weights'
allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);

if(max(max(allDIH)) > 15)
    disp('XXXXXXXXXXXXXXXXXXXXXXXXXXXXX ERROR IN MAKE PREDS');
end

clear f2 f3;