tic
constants;
% setup fake target to stand in for year 3 testing
fake_target.memberids = members.yr3;
fake_target.claimsTrunc = claimsTrunc.yr3;
%fake_target.DIH = DIH.yr3;
fake_target.genders = genders.yr3;
fake_target.ages = ages.yr3;

all_yr3_pred = []; ppp_yr3_pred = [];
yr3_rmse = [];


load('f2.mat');
load('f3.mat');
try
    load('cache/computeTestErrorYr3_14.mat');
catch
    yr3_pred = computeTargetDIH_sexonly(fake_target,logDIH.genders.yr2);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('TEST ERROR %f',err));
    all_yr3_pred = [all_yr3_pred, yr3_pred];

    yr3_pred = computeTargetDIH_ageonly(fake_target,bins.yr2);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('TEST ERROR %f',err));
    all_yr3_pred = [all_yr3_pred, yr3_pred];

    yr3_pred = computeTargetDIH_agesex(fake_target,ages.yr2,genders.yr2,logDIH.yr2);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('TEST ERROR %f',err));
    all_yr3_pred = [all_yr3_pred, yr3_pred];

    yr3_pred = computeTargetDIH_agesexdrug(fake_target,ages.yr2,genders.yr2,...
        logDIH.yr2,drugs.features2_1yr,drugs.features3_1yr);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('TEST ERROR %f',err));
    all_yr3_pred = [all_yr3_pred, yr3_pred];

    yr3_pred = computeTargetDIH_agesexdruglab(ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
        lab.features2_1yr,lab.features3_1yr);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('TEST ERROR %f',err));
    all_yr3_pred = [all_yr3_pred, yr3_pred];

    yr3_pred = computeTargetDIH_agesexdruglab_sqrt(ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
        lab.features2_1yr,lab.features3_1yr);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('TEST ERROR %f',err));
    all_yr3_pred = [all_yr3_pred, yr3_pred];

    yr3_pred = computeTargetDIH_agesexcombo_druglab(ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
        lab.features2_1yr,lab.features3_1yr);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('TEST ERROR %f',err));
    all_yr3_pred = [all_yr3_pred, yr3_pred];

    yr3_pred = computeTargetDIH_agesexcombo_druglabcondproc(ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
        lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
        f2.procedure,f3.procedure);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('TEST ERROR %f',err));
    all_yr3_pred = [all_yr3_pred, yr3_pred];

    yr3_pred = computeTargetDIH_agesexcombo_druglabcondproc_loscharlson(ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
        lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
        f2.procedure,f3.procedure,f2.LoS,f3.LoS,...
        f2.charlson,f3.charlson);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('TEST ERROR %f',err));
    all_yr3_pred = [all_yr3_pred, yr3_pred];

    [yr3_pred c] = computeTargetDIH_many1(ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
        lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
        f2.procedure,f3.procedure,f2.LoS,f3.LoS,...
        f2.charlson,f3.charlson,f2.specialty,f3.specialty,...
        f2.place,f3.place);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('TEST ERROR %f',err));
    all_yr3_pred = [all_yr3_pred, yr3_pred];
    
    [yr3_pred c] = computeTargetDIH_many3(ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
        lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
        f2.procedure,f3.procedure,f2.LoS,f3.LoS,...
        f2.charlson,f3.charlson,f2.specialty,f3.specialty,...
        f2.place,f3.place,f2.DSFS,f3.DSFS);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('TEST ERROR %f',err));
    all_yr3_pred = [all_yr3_pred, yr3_pred];

    [yr3_pred] = computeTargetDIH_catvec1_agesex(fake_target,ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('TEST ERROR %f',err));
    all_yr3_pred = [all_yr3_pred, yr3_pred];

    [yr3_pred c] = computeTargetDIH_catvec1_many1(ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
        lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
        f2.procedure,f3.procedure,f2.LoS,f3.LoS,...
        f2.specialty,f3.specialty,...
        f2.place,f3.place,MANY1_NUMPC);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('TEST ERROR %f',err));
    all_yr3_pred = [all_yr3_pred, yr3_pred];

    [yr3_pred c] = computeTargetDIH_catvec1_many2(ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
        lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
        f2.procedure,f3.procedure,f2.specialty,f3.specialty,...
        f2.place,f3.place,MANY2_NUMPC);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('TEST ERROR %f',err));
    all_yr3_pred = [all_yr3_pred, yr3_pred];

    save('cache/computeTestErrorYr3_14.mat','all_yr3_pred','ppp_yr3_pred','yr3_rmse');
end

[yr3_pred c] = computeTargetDIH_n1(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,drugs.extrafeatures2,drugs.extrafeatures3,...
    lab.extrafeatures2,lab.extrafeatures3,f2.nproviders,f3.nproviders,...
    f2.nvendors,f3.nvendors,f2.npcps,f3.npcps,f2.extraLoS,f3.extraLoS,f2.n,f3.n);
ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
yr3_pred = postProcess(yr3_pred);
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
disp(sprintf('TEST ERROR %f',err));
all_yr3_pred = [all_yr3_pred, yr3_pred];

[yr3_pred c] = computeTargetDIH_many4(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
    lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
    f2.procedure,f3.procedure,f2.specialty,f3.specialty,f2.place,f3.place);
ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
yr3_pred = postProcess(yr3_pred);
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
disp(sprintf('TEST ERROR %f',err));
all_yr3_pred = [all_yr3_pred, yr3_pred];

[yr3_pred c] = computeTargetDIH_catvec1_many3(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,drugs.extrafeatures2,drugs.extrafeatures3,...
    lab.extrafeatures2,lab.extrafeatures3,f2.nproviders,f3.nproviders,...
    f2.nvendors,f3.nvendors,f2.npcps,f3.npcps,f2.extraLoS,f3.extraLoS,f2.n,f3.n);
ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
yr3_pred = postProcess(yr3_pred);
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
disp(sprintf('TEST ERROR %f',err));
all_yr3_pred = [all_yr3_pred, yr3_pred];

good = 10:17;
%get median DIH for each member
yr3_pred = median(all_yr3_pred(:,good),2);
disp('SMALL MEDIAN PREDICTOR');
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2));
disp(sprintf('TEST ERROR %f',err));

%get median DIH for each member
yr3_pred = median(ppp_yr3_pred(:,good),2);
yr3_pred = postProcess(yr3_pred);
disp('PRE-POST-PROCESS SMALL MEDIAN PREDICTOR');
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2));
disp(sprintf('TEST ERROR %f',err));

%get mean DIH for each member
yr3_pred = exp(mean(log(all_yr3_pred+1),2))-1;
disp('MEAN PREDICTOR');
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2));
disp(sprintf('TEST ERROR %f',err));

% do ridge regression
yr3_opt_const = mean(logDIH.yr3);
yr3_var = mean((logDIH.yr3 - yr3_opt_const).^2);
[yr3_pred,yr3_weights] = ridgeRegression(all_yr3_pred(:,:), yr3_var,...
    yr3_opt_const, yr3_rmse(:));
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2));
disp(sprintf('RIDGE REGRESSION TEST ERROR %f',err));
yr3_weights'
toc

clear f2 f3;