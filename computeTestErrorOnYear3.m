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
    load('cache/computeTestErrorYr3_25.mat');
catch
    yr3_pred = computeTargetDIH_sexonly(fake_target,logDIH.genders.yr2);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
    all_yr3_pred = [all_yr3_pred, yr3_pred];

    yr3_pred = computeTargetDIH_ageonly(fake_target,bins.yr2);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
    all_yr3_pred = [all_yr3_pred, yr3_pred];

    yr3_pred = computeTargetDIH_agesex(fake_target,ages.yr2,genders.yr2,logDIH.yr2);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
    all_yr3_pred = [all_yr3_pred, yr3_pred];

    yr3_pred = computeTargetDIH_agesexdrug(fake_target,ages.yr2,genders.yr2,...
        logDIH.yr2,drugs.features2_1yr,drugs.features3_1yr);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
    all_yr3_pred = [all_yr3_pred, yr3_pred];

    yr3_pred = computeTargetDIH_agesexdruglab(ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
        lab.features2_1yr,lab.features3_1yr);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
    all_yr3_pred = [all_yr3_pred, yr3_pred];

    yr3_pred = computeTargetDIH_agesexdruglab_sqrt(ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
        lab.features2_1yr,lab.features3_1yr);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
    all_yr3_pred = [all_yr3_pred, yr3_pred];

    yr3_pred = computeTargetDIH_agesexcombo_druglab(ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
        lab.features2_1yr,lab.features3_1yr);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
    all_yr3_pred = [all_yr3_pred, yr3_pred];

    yr3_pred = computeTargetDIH_agesexcombo_druglabcondproc(ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
        lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
        f2.procedure,f3.procedure);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
    all_yr3_pred = [all_yr3_pred, yr3_pred];

    yr3_pred = computeTargetDIH_agesexcombo_druglabcondproc_loscharlson(ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
        lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
        f2.procedure,f3.procedure,f2.LoS,f3.LoS,...
        f2.charlson,f3.charlson);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
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
    disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
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
    disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
    all_yr3_pred = [all_yr3_pred, yr3_pred];

    [yr3_pred] = computeTargetDIH_catvec1_agesex(fake_target,ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
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
    disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
    all_yr3_pred = [all_yr3_pred, yr3_pred];

    [yr3_pred c] = computeTargetDIH_catvec1_many2(ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
        lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
        f2.procedure,f3.procedure,f2.specialty,f3.specialty,...
        f2.place,f3.place,MANY2_NUMPC);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
    all_yr3_pred = [all_yr3_pred, yr3_pred];

    [yr3_pred c] = computeTargetDIH_n1(ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders,drugs.extrafeatures2,drugs.extrafeatures3,...
        lab.extrafeatures2,lab.extrafeatures3,f2.nproviders,f3.nproviders,...
        f2.nvendors,f3.nvendors,f2.npcps,f3.npcps,f2.extraLoS,f3.extraLoS,f2.n,f3.n);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
    all_yr3_pred = [all_yr3_pred, yr3_pred];

    %16
    [yr3_pred c] = computeTargetDIH_many4(ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
        lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
        f2.procedure,f3.procedure,f2.specialty,f3.specialty,f2.place,f3.place);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
    all_yr3_pred = [all_yr3_pred, yr3_pred];

    %17
    [yr3_pred c] = computeTargetDIH_catvec1_many3(ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders,drugs.extrafeatures2,drugs.extrafeatures3,...
        lab.extrafeatures2,lab.extrafeatures3,f2.nproviders,f3.nproviders,...
        f2.nvendors,f3.nvendors,f2.npcps,f3.npcps,f2.extraLoS,f3.extraLoS,f2.n,f3.n);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    all_yr3_pred = [all_yr3_pred, yr3_pred];
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));

    %18
    [yr3_pred c] = computeTargetDIH_many5(ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders,f2.specPlace,f3.specPlace);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    all_yr3_pred = [all_yr3_pred, yr3_pred];
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));

    %19
    [yr3_pred c] = computeTargetDIH_condspeccombo(ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders,f2.condSpec,f3.condSpec);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    all_yr3_pred = [all_yr3_pred, yr3_pred];
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));

    %20
    [yr3_pred c] = computeTargetDIH_condplacecombo(ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders,f2.condPlace,f3.condPlace);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    all_yr3_pred = [all_yr3_pred, yr3_pred];
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));

    %21
    yr3_pred = median(all_yr3_pred(:,9:14),2);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    all_yr3_pred = [all_yr3_pred, yr3_pred];
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));

    %22
    yr3_pred = median(all_yr3_pred(:,9:20),2);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    all_yr3_pred = [all_yr3_pred, yr3_pred];
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));

    %23
    yr3_pred = median(all_yr3_pred,2);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    all_yr3_pred = [all_yr3_pred, yr3_pred];
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));

    %24
    yr3_pred = exp(mean(log(ppp_yr3_pred(:,9:22)+1),2))-1;
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    all_yr3_pred = [all_yr3_pred, yr3_pred];
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
    
    %25
    [yr3_pred c] = computeTargetDIH_n2(ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders,drugs.extrafeatures2,drugs.extrafeatures3,...
        lab.extrafeatures2,lab.extrafeatures3,f2.nproviders,f3.nproviders,...
        f2.nvendors,f3.nvendors,f2.npcps,f3.npcps,f2.extraLoS,f3.extraLoS,f2.n,f3.n,...
        f2.nspec,f3.nspec,f2.nplace,f3.nplace,f2.nproc,f3.nproc,f2.ncond,f3.ncond,...
        f2.extraDSFS,f3.extraDSFS,f2.extraCharlson,f3.extraCharlson,...
        f2.extraPcpProvVend,f3.extraPcpProvVend);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcess(yr3_pred);
    all_yr3_pred = [all_yr3_pred, yr3_pred];
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));

    save('cache/computeTestErrorYr3_25.mat','all_yr3_pred','ppp_yr3_pred','yr3_rmse');
end

%get median DIH for each member
good = 9:22;
yr3_pred = median(all_yr3_pred(:,good),2);
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2));
disp(sprintf('SMALL MEDIAN PREDICTOR TEST ERROR %f',err));

% do ridge regression
yr3_opt_const = mean(logDIH.yr3);
yr3_var = mean((logDIH.yr3 - yr3_opt_const).^2);
have = find(yr4_rmse>0);
have = [1:25]';
[ indices ] = chooseRidgePredictors(all_yr3_pred, yr3_var,...
    yr3_opt_const, yr3_rmse, 1.0,have)
[yr3_pred,yr3_weights] = ridgeRegression(all_yr3_pred(:,indices), yr3_var,...
    yr3_opt_const, yr3_rmse(indices), 1.0);
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2));
disp(sprintf('RIDGE REGRESSION TEST ERROR %f',err));
yr3_weights'
toc

if(max(max(all_yr3_pred)) > 15)
    disp('XXXXXXXXXXXXXXXXXXXXXXXXXXXXX ERROR IN TESTING YEAR 3 PREDS');
end
clear f2 f3;