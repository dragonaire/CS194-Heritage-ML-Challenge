constants;
tic
allDIH = []; NUM_OUTPUTS = 0;
yr4_rmse = [];
try
    load('f2.mat');
catch
    f2 = claims.f2;
    save('f2.mat','f2');
end
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
    load('cache/makePredictions_38.mat');
catch
try
    load('cache/makePredictions_33.mat');
catch
    try
        load('cache/makePredictions_31.mat');
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
        yr4_rmse = [yr4_rmse; 0.478115];
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
        yr4_rmse = [yr4_rmse; 0.479321];

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
        yr4_rmse = [yr4_rmse; 0.480092];

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
        yr4_rmse = [yr4_rmse; 0.465639];

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
            drugs.extrafeatures3,drugs.extrafeatures4,lab.extrafeatures3,lab.extrafeatures4,...
            f3.nproviders,f4.nproviders,f3.nvendors,f4.nvendors,f3.npcps,f4.npcps,f3.extraLoS,f4.extraLoS,...
            f3.n,f4.n,f3.nspec,f4.nspec,f3.nplace,f4.nplace,f3.nproc,f4.nproc,f3.ncond,f4.ncond,...
            f3.extraDSFS,f4.extraDSFS,f3.extraCharlson,f4.extraCharlson,...
            f3.extraPcpProvVend,f4.extraPcpProvVend);
        allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
        writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
        yr4_rmse = [yr4_rmse; 0.465448];%TODO is this wrong?

        %28
        median(allDIH(:,[1,3,9,10,11,12,13,14,16,17,19,21,25,26,27]),2);
        allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
        writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
        yr4_rmse = [yr4_rmse; 0.465448];

        %29
        [target.DIH] = computeTargetDIH_svm1(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
            drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
            f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
            f3.specialty,f4.specialty,f3.place,f4.place,...
            drugs.extrafeatures3,drugs.extrafeatures4,lab.extrafeatures3,lab.extrafeatures4,...
            f3.nproviders,f4.nproviders,f3.nvendors,f4.nvendors,f3.npcps,f4.npcps,f3.extraLoS,f4.extraLoS,...
            f3.n,f4.n,f3.nspec,f4.nspec,f3.nplace,f4.nplace,f3.nproc,f4.nproc,f3.ncond,f4.ncond,...
            f3.extraDSFS,f4.extraDSFS,f3.extraCharlson,f4.extraCharlson,...
            f3.extraPcpProvVend,f4.extraPcpProvVend);
        allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
        writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
        yr4_rmse = [yr4_rmse; 0.471183];
        
        %30
        % choose the median + offset in the index
        tmp_allDIH = [allDIH,zeros(size(allDIH,1),5),15*ones(size(allDIH,1),5)];
        target.DIH = median(tmp_allDIH(:,[1,9,10,13,14,16,17,19,21,26:31]),2);
        clear tmp_allDIH;
        allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
        writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
        yr4_rmse = [yr4_rmse; 0.465258];

        %31
        [target.DIH] = computeTargetDIH_svm3(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
            drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
            f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
            f3.specialty,f4.specialty,f3.place,f4.place,...
            drugs.extrafeatures3,drugs.extrafeatures4,lab.extrafeatures3,lab.extrafeatures4,...
            f3.nproviders,f4.nproviders,f3.nvendors,f4.nvendors,f3.npcps,f4.npcps,f3.extraLoS,f4.extraLoS,...
            f3.n,f4.n,f3.nspec,f4.nspec,f3.nplace,f4.nplace,f3.nproc,f4.nproc,f3.ncond,f4.ncond,...
            f3.extraDSFS,f4.extraDSFS,f3.extraCharlson,f4.extraCharlson,...
            f3.extraPcpProvVend,f4.extraPcpProvVend);
        allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
        writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
        yr4_rmse = [yr4_rmse; 0.469188];

        save('cache/makePredictions_31.mat','allDIH','NUM_OUTPUTS','yr4_rmse');
    end

    %32
    [target.DIH] = computeTargetDIH_mars2(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
        drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
        f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
        f3.specialty,f4.specialty,f3.place,f4.place,...
        drugs.extrafeatures3,drugs.extrafeatures4,lab.extrafeatures3,lab.extrafeatures4,...
        f3.nproviders,f4.nproviders,f3.nvendors,f4.nvendors,f3.npcps,f4.npcps,f3.extraLoS,f4.extraLoS,...
        f3.n,f4.n,f3.nspec,f4.nspec,f3.nplace,f4.nplace,f3.nproc,f4.nproc,f3.ncond,f4.ncond,...
        f3.extraDSFS,f4.extraDSFS,f3.extraCharlson,f4.extraCharlson,...
        f3.extraPcpProvVend,f4.extraPcpProvVend);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    %yr4_rmse = [yr4_rmse; 0.465210]; % for 60 splines
    %yr4_rmse = [yr4_rmse; 0.464453]; % for 100 splines
    yr4_rmse = [yr4_rmse; 0.464412]; % for 120 splines

    %33
    [target.DIH] = computeTargetDIH_factor1(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
        drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
        f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
        f3.specialty,f4.specialty,f3.place,f4.place,...
        drugs.extrafeatures3,drugs.extrafeatures4,lab.extrafeatures3,lab.extrafeatures4,...
        f3.nproviders,f4.nproviders,f3.nvendors,f4.nvendors,f3.npcps,f4.npcps,f3.extraLoS,f4.extraLoS,...
        f3.n,f4.n,f3.nspec,f4.nspec,f3.nplace,f4.nplace,f3.nproc,f4.nproc,f3.ncond,f4.ncond,...
        f3.extraDSFS,f4.extraDSFS,f3.extraCharlson,f4.extraCharlson,...
        f3.extraPcpProvVend,f4.extraPcpProvVend);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.464552];

    save('cache/makePredictions_33.mat','allDIH','NUM_OUTPUTS','yr4_rmse');
end

    %34
    [target.DIH] = computeTargetDIH_factor2(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
        drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
        f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
        f3.specialty,f4.specialty,f3.place,f4.place,...
        drugs.extrafeatures3,drugs.extrafeatures4,lab.extrafeatures3,lab.extrafeatures4,...
        f3.nproviders,f4.nproviders,f3.nvendors,f4.nvendors,f3.npcps,f4.npcps,f3.extraLoS,f4.extraLoS,...
        f3.n,f4.n,f3.nspec,f4.nspec,f3.nplace,f4.nplace,f3.nproc,f4.nproc,f3.ncond,f4.ncond,...
        f3.extraDSFS,f4.extraDSFS,f3.extraCharlson,f4.extraCharlson,...
        f3.extraPcpProvVend,f4.extraPcpProvVend);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.464504];

    %35
    % trained on year 2
    target.DIH = computeTargetDIH_many1(ages.yr2,genders.yr2,logDIH.yr2,target.ages,target.genders,...
        drugs.features2_1yr,drugs.features4_1yr,lab.features2_1yr,lab.features4_1yr,...
        f2.condGroup,f4.condGroup,f2.procedure,f4.procedure,...
        f2.LoS,f4.LoS,f2.charlson,f4.charlson,...
        f2.specialty,f4.specialty,f2.place,f4.place);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.466579];

    %36
    % trained on year 2
    target.DIH = computeTargetDIH_catvec1_many2(ages.yr2,genders.yr2,logDIH.yr2,target.ages,target.genders,...
        drugs.features2_1yr,drugs.features4_1yr,lab.features2_1yr,lab.features4_1yr,...
        f2.condGroup,f4.condGroup,f2.procedure,f4.procedure,...
        f2.specialty,f4.specialty,f2.place,f4.place,MANY2_NUMPC);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.466642];

    %37
    % trained on year 2
    [target.DIH] = computeTargetDIH_svm1(ages.yr2,genders.yr2,logDIH.yr2,target.ages,target.genders,...
        drugs.features2_1yr,drugs.features4_1yr,lab.features2_1yr,lab.features4_1yr,...
        f2.condGroup,f4.condGroup,f2.procedure,f4.procedure,...
        f2.specialty,f4.specialty,f2.place,f4.place,...
        drugs.extrafeatures2,drugs.extrafeatures4,lab.extrafeatures2,lab.extrafeatures4,...
        f2.nproviders,f4.nproviders,f2.nvendors,f4.nvendors,f2.npcps,f4.npcps,f2.extraLoS,f4.extraLoS,...
        f2.n,f4.n,f2.nspec,f4.nspec,f2.nplace,f4.nplace,f2.nproc,f4.nproc,f2.ncond,f4.ncond,...
        f2.extraDSFS,f4.extraDSFS,f2.extraCharlson,f4.extraCharlson,...
        f2.extraPcpProvVend,f4.extraPcpProvVend);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.471590];

    %38
    % trained on year 2
    [target.DIH] = computeTargetDIH_mars2(ages.yr2,genders.yr2,logDIH.yr2,target.ages,target.genders,...
        drugs.features2_1yr,drugs.features4_1yr,lab.features2_1yr,lab.features4_1yr,...
        f2.condGroup,f4.condGroup,f2.procedure,f4.procedure,...
        f2.specialty,f4.specialty,f2.place,f4.place,...
        drugs.extrafeatures2,drugs.extrafeatures4,lab.extrafeatures2,lab.extrafeatures4,...
        f2.nproviders,f4.nproviders,f2.nvendors,f4.nvendors,f2.npcps,f4.npcps,f2.extraLoS,f4.extraLoS,...
        f2.n,f4.n,f2.nspec,f4.nspec,f2.nplace,f4.nplace,f2.nproc,f4.nproc,f2.ncond,f4.ncond,...
        f2.extraDSFS,f4.extraDSFS,f2.extraCharlson,f4.extraCharlson,...
        f2.extraPcpProvVend,f4.extraPcpProvVend);
    allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
    yr4_rmse = [yr4_rmse; 0.465700];

    save('cache/makePredictions_38.mat','allDIH','NUM_OUTPUTS','yr4_rmse');
end


%mean RR
allDIH = postProcessReal(allDIH);
have = find(yr4_rmse>0);
%{
[target.DIH,weights] = meanRidgeRegression(allDIH, ...
    LEADERBOARD_VAR, LEADERBOARD_OPT_CONST, yr4_rmse, 0.3, have);
allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
disp('MEAN RIDGE REGRESSION TEST ERROR DONE');
%}

%ridge regression.
[ indices ] = choosePredictors(@ridgeRegression, allDIH, have, LEADERBOARD_VAR,...
    LEADERBOARD_OPT_CONST, yr4_rmse, 0.3);
indices'
[target.DIH,with_overfit,weights] = ridgeRegression(allDIH,indices,...
    {LEADERBOARD_VAR,LEADERBOARD_OPT_CONST, yr4_rmse, 0.3});
weights'
allDIH = [allDIH, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
writeTarget(sprintf('Target_%d.csv',NUM_OUTPUTS),target);
fprintf('RIDGE REGRESSION PREDICTED ERROR %f\n',with_overfit);

if(max(max(allDIH)) > 15)
    max(allDIH)
    min(allDIH)
    disp('XXXXXXXXXXXXXXXXXXXXXXXXXXXXX ERROR IN MAKE PREDS');
end

clear f2 f3;
