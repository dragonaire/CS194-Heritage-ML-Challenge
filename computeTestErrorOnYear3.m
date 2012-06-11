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
    load('cache/computeTestErrorYr3_33.mat');
catch
    try
        load('cache/computeTestErrorYr3_31.mat');
    catch
        yr3_pred = computeTargetDIH_sexonly(fake_target,logDIH.genders.yr2);
        ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
        yr3_pred = postProcessReal(yr3_pred);
        err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
        disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
        all_yr3_pred = [all_yr3_pred, yr3_pred];

        yr3_pred = computeTargetDIH_ageonly(fake_target,bins.yr2);
        ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
        yr3_pred = postProcessReal(yr3_pred);
        err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
        disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
        all_yr3_pred = [all_yr3_pred, yr3_pred];

        yr3_pred = computeTargetDIH_agesex(fake_target,ages.yr2,genders.yr2,logDIH.yr2);
        ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
        yr3_pred = postProcessReal(yr3_pred);
        err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
        disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
        all_yr3_pred = [all_yr3_pred, yr3_pred];

        yr3_pred = computeTargetDIH_agesexdrug(fake_target,ages.yr2,genders.yr2,...
            logDIH.yr2,drugs.features2_1yr,drugs.features3_1yr);
        ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
        yr3_pred = postProcessReal(yr3_pred);
        err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
        disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
        all_yr3_pred = [all_yr3_pred, yr3_pred];

        yr3_pred = computeTargetDIH_agesexdruglab(ages.yr2,genders.yr2,logDIH.yr2,...
            fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
            lab.features2_1yr,lab.features3_1yr);
        ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
        yr3_pred = postProcessReal(yr3_pred);
        err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
        disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
        all_yr3_pred = [all_yr3_pred, yr3_pred];

        yr3_pred = computeTargetDIH_agesexdruglab_sqrt(ages.yr2,genders.yr2,logDIH.yr2,...
            fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
            lab.features2_1yr,lab.features3_1yr);
        ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
        yr3_pred = postProcessReal(yr3_pred);
        err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
        disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
        all_yr3_pred = [all_yr3_pred, yr3_pred];

        yr3_pred = computeTargetDIH_agesexcombo_druglab(ages.yr2,genders.yr2,logDIH.yr2,...
            fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
            lab.features2_1yr,lab.features3_1yr);
        ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
        yr3_pred = postProcessReal(yr3_pred);
        err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
        disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
        all_yr3_pred = [all_yr3_pred, yr3_pred];

        yr3_pred = computeTargetDIH_agesexcombo_druglabcondproc(ages.yr2,genders.yr2,logDIH.yr2,...
            fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
            lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
            f2.procedure,f3.procedure);
        ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
        yr3_pred = postProcessReal(yr3_pred);
        err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
        disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
        all_yr3_pred = [all_yr3_pred, yr3_pred];

        yr3_pred = computeTargetDIH_agesexcombo_druglabcondproc_loscharlson(ages.yr2,genders.yr2,logDIH.yr2,...
            fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
            lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
            f2.procedure,f3.procedure,f2.LoS,f3.LoS,...
            f2.charlson,f3.charlson);
        ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
        yr3_pred = postProcessReal(yr3_pred);
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
        yr3_pred = postProcessReal(yr3_pred);
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
        yr3_pred = postProcessReal(yr3_pred);
        err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
        disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
        all_yr3_pred = [all_yr3_pred, yr3_pred];

        [yr3_pred] = computeTargetDIH_catvec1_agesex(fake_target,ages.yr2,genders.yr2,logDIH.yr2,...
            fake_target.ages,fake_target.genders);
        ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
        yr3_pred = postProcessReal(yr3_pred);
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
        yr3_pred = postProcessReal(yr3_pred);
        err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
        disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
        all_yr3_pred = [all_yr3_pred, yr3_pred];

        [yr3_pred c] = computeTargetDIH_catvec1_many2(ages.yr2,genders.yr2,logDIH.yr2,...
            fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
            lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
            f2.procedure,f3.procedure,f2.specialty,f3.specialty,...
            f2.place,f3.place,MANY2_NUMPC);
        ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
        yr3_pred = postProcessReal(yr3_pred);
        err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
        disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
        all_yr3_pred = [all_yr3_pred, yr3_pred];

        [yr3_pred c] = computeTargetDIH_n1(ages.yr2,genders.yr2,logDIH.yr2,...
            fake_target.ages,fake_target.genders,drugs.extrafeatures2,drugs.extrafeatures3,...
            lab.extrafeatures2,lab.extrafeatures3,f2.nproviders,f3.nproviders,...
            f2.nvendors,f3.nvendors,f2.npcps,f3.npcps,f2.extraLoS,f3.extraLoS,f2.n,f3.n);
        ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
        yr3_pred = postProcessReal(yr3_pred);
        err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
        disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
        all_yr3_pred = [all_yr3_pred, yr3_pred];

        %16
        [yr3_pred c] = computeTargetDIH_many4(ages.yr2,genders.yr2,logDIH.yr2,...
            fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
            lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
            f2.procedure,f3.procedure,f2.specialty,f3.specialty,f2.place,f3.place);
        ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
        yr3_pred = postProcessReal(yr3_pred);
        err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
        disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
        all_yr3_pred = [all_yr3_pred, yr3_pred];

        %17
        [yr3_pred c] = computeTargetDIH_catvec1_many3(ages.yr2,genders.yr2,logDIH.yr2,...
            fake_target.ages,fake_target.genders,drugs.extrafeatures2,drugs.extrafeatures3,...
            lab.extrafeatures2,lab.extrafeatures3,f2.nproviders,f3.nproviders,...
            f2.nvendors,f3.nvendors,f2.npcps,f3.npcps,f2.extraLoS,f3.extraLoS,f2.n,f3.n);
        ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
        yr3_pred = postProcessReal(yr3_pred);
        all_yr3_pred = [all_yr3_pred, yr3_pred];
        err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
        disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));

        %18
        [yr3_pred c] = computeTargetDIH_many5(ages.yr2,genders.yr2,logDIH.yr2,...
            fake_target.ages,fake_target.genders,f2.specPlace,f3.specPlace);
        ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
        yr3_pred = postProcessReal(yr3_pred);
        all_yr3_pred = [all_yr3_pred, yr3_pred];
        err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
        disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));

        %19
        [yr3_pred c] = computeTargetDIH_condspeccombo(ages.yr2,genders.yr2,logDIH.yr2,...
            fake_target.ages,fake_target.genders,f2.condSpec,f3.condSpec);
        ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
        yr3_pred = postProcessReal(yr3_pred);
        all_yr3_pred = [all_yr3_pred, yr3_pred];
        err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
        disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));

        %20
        [yr3_pred c] = computeTargetDIH_condplacecombo(ages.yr2,genders.yr2,logDIH.yr2,...
            fake_target.ages,fake_target.genders,f2.condPlace,f3.condPlace);
        ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
        yr3_pred = postProcessReal(yr3_pred);
        all_yr3_pred = [all_yr3_pred, yr3_pred];
        err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
        disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));

        %21
        yr3_pred = median(all_yr3_pred(:,9:14),2);
        ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
        yr3_pred = postProcessReal(yr3_pred);
        all_yr3_pred = [all_yr3_pred, yr3_pred];
        err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
        disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));

        %22
        yr3_pred = median(all_yr3_pred(:,9:20),2);
        ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
        yr3_pred = postProcessReal(yr3_pred);
        all_yr3_pred = [all_yr3_pred, yr3_pred];
        err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
        disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));

        %23
        yr3_pred = median(all_yr3_pred,2);
        ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
        yr3_pred = postProcessReal(yr3_pred);
        all_yr3_pred = [all_yr3_pred, yr3_pred];
        err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
        disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));

        %24
        yr3_pred = exp(mean(log(ppp_yr3_pred(:,9:22)+1),2))-1;
        ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
        yr3_pred = postProcessReal(yr3_pred);
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
        yr3_pred = postProcessReal(yr3_pred);
        all_yr3_pred = [all_yr3_pred, yr3_pred];
        err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
        disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
        
        %26 A stand-in for GBM3
        yr3_pred = zeros(71435,1);
        ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
        yr3_pred = postProcessReal(yr3_pred);
        all_yr3_pred = [all_yr3_pred, yr3_pred];
        err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
        disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
        
        %27
        [yr3_pred c] = computeTargetDIH_many6(ages.yr2,genders.yr2,logDIH.yr2,...
            fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
            lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
            f2.procedure,f3.procedure,f2.specialty,f3.specialty,...
            f2.place,f3.place,drugs.extrafeatures2,drugs.extrafeatures3,...
            lab.extrafeatures2,lab.extrafeatures3,f2.nproviders,f3.nproviders,...
            f2.nvendors,f3.nvendors,f2.npcps,f3.npcps,f2.extraLoS,f3.extraLoS,f2.n,f3.n,...
            f2.nspec,f3.nspec,f2.nplace,f3.nplace,f2.nproc,f3.nproc,f2.ncond,f3.ncond,...
            f2.extraDSFS,f3.extraDSFS,f2.extraCharlson,f3.extraCharlson,...
            f2.extraPcpProvVend,f3.extraPcpProvVend);
        ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
        yr3_pred = postProcessReal(yr3_pred);
        all_yr3_pred = [all_yr3_pred, yr3_pred];
        err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
        disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
        
        %28
        yr3_pred = median(all_yr3_pred(:,[1,3,9,10,11,12,13,14,16,17,19,21,25,26,27]),2);
        ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
        yr3_pred = postProcessReal(yr3_pred);
        all_yr3_pred = [all_yr3_pred, yr3_pred];
        err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
        disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));

        %29
        [yr3_pred] = computeTargetDIH_svm1(ages.yr2,genders.yr2,logDIH.yr2,...
            fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
            lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
            f2.procedure,f3.procedure,f2.specialty,f3.specialty,...
            f2.place,f3.place,drugs.extrafeatures2,drugs.extrafeatures3,...
            lab.extrafeatures2,lab.extrafeatures3,f2.nproviders,f3.nproviders,...
            f2.nvendors,f3.nvendors,f2.npcps,f3.npcps,f2.extraLoS,f3.extraLoS,f2.n,f3.n,...
            f2.nspec,f3.nspec,f2.nplace,f3.nplace,f2.nproc,f3.nproc,f2.ncond,f3.ncond,...
            f2.extraDSFS,f3.extraDSFS,f2.extraCharlson,f3.extraCharlson,...
            f2.extraPcpProvVend,f3.extraPcpProvVend);    
        ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
        yr3_pred = postProcessReal(yr3_pred);
        all_yr3_pred = [all_yr3_pred, yr3_pred];
        err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
        disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));

        %30
        % choose the median + offset in the index
        tmp_yr3_pred = [all_yr3_pred,zeros(size(all_yr3_pred,1),5),15*ones(size(all_yr3_pred,1),5)];
        [ good ] = choosePredictors(@chooseMedian, tmp_yr3_pred, 1:size(tmp_yr3_pred,2),logDIH.yr3);
        yr3_pred = median(tmp_yr3_pred(:,good),2);
        ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
        yr3_pred = postProcessReal(yr3_pred);
        all_yr3_pred = [all_yr3_pred, yr3_pred];
        clear tmp_yr3_pred;
        err = sqrt(mean((logDIH.yr3-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
        disp(sprintf('BEST MEDIAN PREDICTOR TEST ERROR %f',err));

        %31
        [yr3_pred] = computeTargetDIH_svm3(ages.yr2,genders.yr2,logDIH.yr2,...
            fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
            lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
            f2.procedure,f3.procedure,f2.specialty,f3.specialty,...
            f2.place,f3.place,drugs.extrafeatures2,drugs.extrafeatures3,...
            lab.extrafeatures2,lab.extrafeatures3,f2.nproviders,f3.nproviders,...
            f2.nvendors,f3.nvendors,f2.npcps,f3.npcps,f2.extraLoS,f3.extraLoS,f2.n,f3.n,...
            f2.nspec,f3.nspec,f2.nplace,f3.nplace,f2.nproc,f3.nproc,f2.ncond,f3.ncond,...
            f2.extraDSFS,f3.extraDSFS,f2.extraCharlson,f3.extraCharlson,...
            f2.extraPcpProvVend,f3.extraPcpProvVend);
        ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
        yr3_pred = postProcessReal(yr3_pred);
        all_yr3_pred = [all_yr3_pred, yr3_pred];
        err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
        disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));

        save('cache/computeTestErrorYr3_31.mat','all_yr3_pred','ppp_yr3_pred','yr3_rmse');
    end

    %32
    [yr3_pred] = computeTargetDIH_mars2(ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
        lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
        f2.procedure,f3.procedure,f2.specialty,f3.specialty,...
        f2.place,f3.place,drugs.extrafeatures2,drugs.extrafeatures3,...
        lab.extrafeatures2,lab.extrafeatures3,f2.nproviders,f3.nproviders,...
        f2.nvendors,f3.nvendors,f2.npcps,f3.npcps,f2.extraLoS,f3.extraLoS,f2.n,f3.n,...
        f2.nspec,f3.nspec,f2.nplace,f3.nplace,f2.nproc,f3.nproc,f2.ncond,f3.ncond,...
        f2.extraDSFS,f3.extraDSFS,f2.extraCharlson,f3.extraCharlson,...
        f2.extraPcpProvVend,f3.extraPcpProvVend);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcessReal(yr3_pred);
    all_yr3_pred = [all_yr3_pred, yr3_pred];
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));

    %33
    [yr3_pred] = computeTargetDIH_factor1(ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
        lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
        f2.procedure,f3.procedure,f2.specialty,f3.specialty,...
        f2.place,f3.place,drugs.extrafeatures2,drugs.extrafeatures3,...
        lab.extrafeatures2,lab.extrafeatures3,f2.nproviders,f3.nproviders,...
        f2.nvendors,f3.nvendors,f2.npcps,f3.npcps,f2.extraLoS,f3.extraLoS,f2.n,f3.n,...
        f2.nspec,f3.nspec,f2.nplace,f3.nplace,f2.nproc,f3.nproc,f2.ncond,f3.ncond,...
        f2.extraDSFS,f3.extraDSFS,f2.extraCharlson,f3.extraCharlson,...
        f2.extraPcpProvVend,f3.extraPcpProvVend);
    ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
    yr3_pred = postProcessReal(yr3_pred);
    all_yr3_pred = [all_yr3_pred, yr3_pred];
    err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
    disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));

    save('cache/computeTestErrorYr3_33.mat','all_yr3_pred','ppp_yr3_pred','yr3_rmse');
end

%42
[yr3_pred] = computeTargetDIH_ens1(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
    lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
    f2.procedure,f3.procedure,f2.specialty,f3.specialty,...
    f2.place,f3.place,drugs.extrafeatures2,drugs.extrafeatures3,...
    lab.extrafeatures2,lab.extrafeatures3,f2.nproviders,f3.nproviders,...
    f2.nvendors,f3.nvendors,f2.npcps,f3.npcps,f2.extraLoS,f3.extraLoS,f2.n,f3.n,...
    f2.nspec,f3.nspec,f2.nplace,f3.nplace,f2.nproc,f3.nproc,f2.ncond,f3.ncond,...
    f2.extraDSFS,f3.extraDSFS,f2.extraCharlson,f3.extraCharlson,...
    f2.extraPcpProvVend,f3.extraPcpProvVend,1000,2e-5);
ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
yr3_pred = postProcessReal(yr3_pred);
all_yr3_pred = [all_yr3_pred, yr3_pred];
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));

%median
yr3_pred = median(all_yr3_pred(:,:),2);
err = sqrt(mean((logDIH.yr3-log(yr3_pred+1)).^2));
disp(sprintf('MEDIAN PREDICTOR TEST ERROR %f',err));

%testing mean RR
have = [1:size(all_yr3_pred,2)]';
yr3_opt_const = mean(logDIH.yr3);
yr3_var = mean((logDIH.yr3 - yr3_opt_const).^2);
[yr3_pred,yr3_weights] = meanRidgeRegression(all_yr3_pred, ...
    yr3_var, yr3_opt_const, yr3_rmse, 1.0, have);
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2));
disp(sprintf('MEAN RIDGE REGRESSION TEST ERROR %f',err));

% do ridge regression
%have = find(yr4_rmse>0);
[ indices ] = choosePredictors(@ridgeRegression, all_yr3_pred, have, yr3_var,...
    yr3_opt_const, yr3_rmse, 1.0)
[yr3_pred,with_overfit,yr3_weights] = ridgeRegression(all_yr3_pred, indices, ...
    {yr3_var, yr3_opt_const, yr3_rmse, 1.0});
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2));
disp(sprintf('RIDGE REGRESSION TEST ERROR %f',err));
yr3_weights'
toc

if(max(max(all_yr3_pred)) > 15)
    disp('XXXXXXXXXXXXXXXXXXXXXXXXXXXXX ERROR IN TESTING YEAR 3 PREDS');
end
clear f2 f3;
