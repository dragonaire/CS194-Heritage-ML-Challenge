constants;
tic
allDIH2 = []; NUM_OUTPUTS = 0;
yr42_rmse = [];
try
    load('f2.mat');
catch
    f2 = claims.f2;
    save('f2.mat','f2');
end
try
    load('f4.mat');
catch
    f4 = claims.f4;
    save('f4.mat','f4');
end
clear claims;
try
    load('cache/yr2MakePred_33.mat');
catch
  try
      load('cache/yr2MakePred_31.mat');
  catch
    try
        load('cache/yr2MakePred_28.mat');
    catch
      try
          load('cache/yr2MakePred_12.mat');
      catch
        %1
        target.DIH = computeTargetDIH_sexonly(target,logDIH.genders.yr2);
        allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
        writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
        yr42_rmse = [yr42_rmse; 0];

        %2
        target.DIH = computeTargetDIH_ageonly(target,bins.yr2);
        allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
        writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
        yr42_rmse = [yr42_rmse; 0];

        %3
        target.DIH = computeTargetDIH_agesex(target,ages.yr2,genders.yr2,logDIH.yr2);
        allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
        writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
        yr42_rmse = [yr42_rmse; 0];
        %4
        target.DIH = computeTargetDIH_agesexdrug(target,ages.yr2,genders.yr2,...
            logDIH.yr2,drugs.features2_1yr,drugs.features4_1yr);
        allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
        writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
        yr42_rmse = [yr42_rmse; 0];

        %5
        target.DIH = computeTargetDIH_agesexdruglab(ages.yr2,genders.yr2,logDIH.yr2,...
            target.ages,target.genders,drugs.features2_1yr,drugs.features4_1yr,...
            lab.features2_1yr,lab.features4_1yr);
        allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
        writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
        yr42_rmse = [yr42_rmse; 0];

        %6
        target.DIH = computeTargetDIH_agesexdruglab_sqrt(ages.yr2,genders.yr2,logDIH.yr2,...
            target.ages,target.genders,drugs.features2_1yr,drugs.features4_1yr,...
            lab.features2_1yr,lab.features4_1yr);
        allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
        writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
        yr42_rmse = [yr42_rmse; 0];

        %7
        target.DIH = computeTargetDIH_agesexcombo_druglab(ages.yr2,genders.yr2,logDIH.yr2,...
            target.ages,target.genders,drugs.features2_1yr,drugs.features4_1yr,...
            lab.features2_1yr,lab.features4_1yr);
        allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
        writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
        yr42_rmse = [yr42_rmse; 0];

        %8
        target.DIH = computeTargetDIH_agesexcombo_druglabcondproc(ages.yr2,genders.yr2,logDIH.yr2,...
            target.ages,target.genders,drugs.features2_1yr,drugs.features4_1yr,...
            lab.features2_1yr,lab.features4_1yr,f2.condGroup,f4.condGroup,...
            f2.procedure,f4.procedure);
        allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
        writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
        yr42_rmse = [yr42_rmse; 0];

        %9
        target.DIH = computeTargetDIH_agesexcombo_druglabcondproc_loscharlson(...
            ages.yr2,genders.yr2,logDIH.yr2,target.ages,target.genders,...
            drugs.features2_1yr,drugs.features4_1yr,lab.features2_1yr,lab.features4_1yr,...
            f2.condGroup,f4.condGroup,f2.procedure,f4.procedure,...
            f2.LoS,f4.LoS,f2.charlson,f4.charlson);
        allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
        writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
        yr42_rmse = [yr42_rmse; 0];

        %10
        target.DIH = computeTargetDIH_many1(ages.yr2,genders.yr2,logDIH.yr2,target.ages,target.genders,...
            drugs.features2_1yr,drugs.features4_1yr,lab.features2_1yr,lab.features4_1yr,...
            f2.condGroup,f4.condGroup,f2.procedure,f4.procedure,...
            f2.LoS,f4.LoS,f2.charlson,f4.charlson,...
            f2.specialty,f4.specialty,f2.place,f4.place);
        allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
        writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
        yr42_rmse = [yr42_rmse; 0.466579];
        
        %11
        target.DIH = computeTargetDIH_many3(ages.yr2,genders.yr2,logDIH.yr2,target.ages,target.genders,...
            drugs.features2_1yr,drugs.features4_1yr,lab.features2_1yr,lab.features4_1yr,...
            f2.condGroup,f4.condGroup,f2.procedure,f4.procedure,...
            f2.LoS,f4.LoS,f2.charlson,f4.charlson,...
            f2.specialty,f4.specialty,f2.place,f4.place,...
            f2.DSFS,f4.DSFS);
        allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
        writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
        yr42_rmse = [yr42_rmse; 0];

        %12
        target.DIH = computeTargetDIH_catvec1_agesex(target,ages.yr2,genders.yr2,logDIH.yr2,...
            target.ages,target.genders);
        allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
        writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
        yr42_rmse = [yr42_rmse; 0];

        save('cache/yr2MakePred_12.mat','allDIH2','NUM_OUTPUTS','yr42_rmse');
      end
      %13
      target.DIH = computeTargetDIH_catvec1_many1(ages.yr2,genders.yr2,logDIH.yr2,target.ages,target.genders,...
          drugs.features2_1yr,drugs.features4_1yr,lab.features2_1yr,lab.features4_1yr,...
          f2.condGroup,f4.condGroup,f2.procedure,f4.procedure,...
          f2.LoS,f4.LoS,...
          f2.specialty,f4.specialty,f2.place,f4.place,MANY1_NUMPC);
      allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
      writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
      yr42_rmse = [yr42_rmse; 0];

      %14
      target.DIH = computeTargetDIH_catvec1_many2(ages.yr2,genders.yr2,logDIH.yr2,target.ages,target.genders,...
          drugs.features2_1yr,drugs.features4_1yr,lab.features2_1yr,lab.features4_1yr,...
          f2.condGroup,f4.condGroup,f2.procedure,f4.procedure,...
          f2.specialty,f4.specialty,f2.place,f4.place,MANY2_NUMPC);
      allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
      writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
      yr42_rmse = [yr42_rmse; 0.466642];

      %15
      [target.DIH c4] = computeTargetDIH_n1(ages.yr2,genders.yr2,logDIH.yr2,target.ages,target.genders,...
          drugs.extrafeatures2,drugs.extrafeatures4,lab.extrafeatures2,lab.extrafeatures4,...
          f2.nproviders,f4.nproviders,...
          f2.nvendors,f4.nvendors,f2.npcps,f4.npcps,f2.extraLoS,f4.extraLoS,f2.n,f4.n);
      allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
      writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
      yr42_rmse = [yr42_rmse; 0];

      %16
      [target.DIH c4] = computeTargetDIH_many4(ages.yr2,genders.yr2,logDIH.yr2,target.ages,target.genders,...
          drugs.features2_1yr,drugs.features4_1yr,lab.features2_1yr,lab.features4_1yr,...
          f2.condGroup,f4.condGroup,f2.procedure,f4.procedure,...
          f2.specialty,f4.specialty,f2.place,f4.place);
      allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
      writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
      yr42_rmse = [yr42_rmse; 0];

      %17
      target.DIH = computeTargetDIH_catvec1_many3(ages.yr2,genders.yr2,logDIH.yr2,target.ages,target.genders,...
          drugs.extrafeatures2,drugs.extrafeatures4,lab.extrafeatures2,lab.extrafeatures4,...
          f2.nproviders,f4.nproviders,...
          f2.nvendors,f4.nvendors,f2.npcps,f4.npcps,f2.extraLoS,f4.extraLoS,f2.n,f4.n);
      allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
      writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
      yr42_rmse = [yr42_rmse; 0];

      %18
      [target.DIH c4] = computeTargetDIH_many5(ages.yr2,genders.yr2,logDIH.yr2,target.ages,target.genders,...
          f2.specPlace,f4.specPlace);
      allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
      writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
      yr42_rmse = [yr42_rmse; 0];

      %19
      [target.DIH c4] = computeTargetDIH_condspeccombo(ages.yr2,genders.yr2,logDIH.yr2,target.ages,target.genders,...
          f2.condSpec,f4.condSpec);
      allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
      writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
      yr42_rmse = [yr42_rmse; 0];

      %20
      [target.DIH c4] = computeTargetDIH_condplacecombo(ages.yr2,genders.yr2,logDIH.yr2,target.ages,target.genders,...
          f2.condPlace,f4.condPlace);
      allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
      writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
      yr42_rmse = [yr42_rmse; 0];

      %21
      target.DIH = median(allDIH2(:,9:14),2);
      allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
      writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
      yr42_rmse = [yr42_rmse; 0];

      %22
      target.DIH = median(allDIH2(:,9:20),2);
      allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
      writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
      yr42_rmse = [yr42_rmse; 0];

      %23
      target.DIH = median(allDIH2,2);
      allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
      writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
      yr42_rmse = [yr42_rmse; 0];
      
      %24
      target.DIH = exp(mean(log(allDIH2(:,9:22)+1),2))-1;
      allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
      writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
      yr42_rmse = [yr42_rmse; 0];
      
      %25
      [target.DIH c4] = computeTargetDIH_n2(ages.yr2,genders.yr2,logDIH.yr2,target.ages,target.genders,...
          drugs.extrafeatures2,drugs.extrafeatures4,lab.extrafeatures2,lab.extrafeatures4,...
          f2.nproviders,f4.nproviders,f2.nvendors,f4.nvendors,f2.npcps,f4.npcps,f2.extraLoS,f4.extraLoS,...
          f2.n,f4.n,f2.nspec,f4.nspec,f2.nplace,f4.nplace,f2.nproc,f4.nproc,f2.ncond,f4.ncond,...
          f2.extraDSFS,f4.extraDSFS,f2.extraCharlson,f4.extraCharlson,...
          f2.extraPcpProvVend,f4.extraPcpProvVend);
      allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
      writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
      yr42_rmse = [yr42_rmse; 0];
      
      %26
      %target.DIH = readPredictions('TargetGBM3.csv');
      target.DIH = zeros(70942,1);
      allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
      writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
      yr42_rmse = [yr42_rmse; 0];

      %27
      [target.DIH c4] = computeTargetDIH_many6(ages.yr2,genders.yr2,logDIH.yr2,target.ages,target.genders,...
          drugs.features2_1yr,drugs.features4_1yr,lab.features2_1yr,lab.features4_1yr,...
          f2.condGroup,f4.condGroup,f2.procedure,f4.procedure,...
          f2.specialty,f4.specialty,f2.place,f4.place,...
          drugs.extrafeatures2,drugs.extrafeatures4,lab.extrafeatures2,lab.extrafeatures4,...
          f2.nproviders,f4.nproviders,f2.nvendors,f4.nvendors,f2.npcps,f4.npcps,f2.extraLoS,f4.extraLoS,...
          f2.n,f4.n,f2.nspec,f4.nspec,f2.nplace,f4.nplace,f2.nproc,f4.nproc,f2.ncond,f4.ncond,...
          f2.extraDSFS,f4.extraDSFS,f2.extraCharlson,f4.extraCharlson,...
          f2.extraPcpProvVend,f4.extraPcpProvVend);
      allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
      writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
      yr42_rmse = [yr42_rmse; 0];

      %28
      median(allDIH2(:,[1,3,9,10,11,12,13,14,16,17,19,21,25,26,27]),2);
      allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
      writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
      yr42_rmse = [yr42_rmse; 0];

      save('cache/yr2MakePred_28.mat','allDIH2','NUM_OUTPUTS','yr42_rmse');
    end

    %29
    [target.DIH] = computeTargetDIH_svm1(ages.yr2,genders.yr2,logDIH.yr2,target.ages,target.genders,...
        drugs.features2_1yr,drugs.features4_1yr,lab.features2_1yr,lab.features4_1yr,...
        f2.condGroup,f4.condGroup,f2.procedure,f4.procedure,...
        f2.specialty,f4.specialty,f2.place,f4.place,...
        drugs.extrafeatures2,drugs.extrafeatures4,lab.extrafeatures2,lab.extrafeatures4,...
        f2.nproviders,f4.nproviders,f2.nvendors,f4.nvendors,f2.npcps,f4.npcps,f2.extraLoS,f4.extraLoS,...
        f2.n,f4.n,f2.nspec,f4.nspec,f2.nplace,f4.nplace,f2.nproc,f4.nproc,f2.ncond,f4.ncond,...
        f2.extraDSFS,f4.extraDSFS,f2.extraCharlson,f4.extraCharlson,...
        f2.extraPcpProvVend,f4.extraPcpProvVend);
    allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
    yr42_rmse = [yr42_rmse; 0.471590];
    
    %30
    % choose the median + offset in the index
    tmp_allDIH2 = [allDIH2,zeros(size(allDIH2,1),5),15*ones(size(allDIH2,1),5)];
    target.DIH = median(tmp_allDIH2(:,[1,9,10,13,14,16,17,19,21,26:31]),2);
    clear tmp_allDIH2;
    allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
    yr42_rmse = [yr42_rmse; 0];

    %31
    [target.DIH] = computeTargetDIH_svm3(ages.yr2,genders.yr2,logDIH.yr2,target.ages,target.genders,...
        drugs.features2_1yr,drugs.features4_1yr,lab.features2_1yr,lab.features4_1yr,...
        f2.condGroup,f4.condGroup,f2.procedure,f4.procedure,...
        f2.specialty,f4.specialty,f2.place,f4.place,...
        drugs.extrafeatures2,drugs.extrafeatures4,lab.extrafeatures2,lab.extrafeatures4,...
        f2.nproviders,f4.nproviders,f2.nvendors,f4.nvendors,f2.npcps,f4.npcps,f2.extraLoS,f4.extraLoS,...
        f2.n,f4.n,f2.nspec,f4.nspec,f2.nplace,f4.nplace,f2.nproc,f4.nproc,f2.ncond,f4.ncond,...
        f2.extraDSFS,f4.extraDSFS,f2.extraCharlson,f4.extraCharlson,...
        f2.extraPcpProvVend,f4.extraPcpProvVend);
    allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
    writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
    yr42_rmse = [yr42_rmse; 0];

    save('cache/yr2MakePred_31.mat','allDIH2','NUM_OUTPUTS','yr42_rmse');
  end
  %32
  [target.DIH] = computeTargetDIH_mars2(ages.yr2,genders.yr2,logDIH.yr2,target.ages,target.genders,...
      drugs.features2_1yr,drugs.features4_1yr,lab.features2_1yr,lab.features4_1yr,...
      f2.condGroup,f4.condGroup,f2.procedure,f4.procedure,...
      f2.specialty,f4.specialty,f2.place,f4.place,...
      drugs.extrafeatures2,drugs.extrafeatures4,lab.extrafeatures2,lab.extrafeatures4,...
      f2.nproviders,f4.nproviders,f2.nvendors,f4.nvendors,f2.npcps,f4.npcps,f2.extraLoS,f4.extraLoS,...
      f2.n,f4.n,f2.nspec,f4.nspec,f2.nplace,f4.nplace,f2.nproc,f4.nproc,f2.ncond,f4.ncond,...
      f2.extraDSFS,f4.extraDSFS,f2.extraCharlson,f4.extraCharlson,...
      f2.extraPcpProvVend,f4.extraPcpProvVend);
  allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
  writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
  yr42_rmse = [yr42_rmse; 0.465700];

  %33
  [target.DIH] = computeTargetDIH_factor1(ages.yr2,genders.yr2,logDIH.yr2,target.ages,target.genders,...
      drugs.features2_1yr,drugs.features4_1yr,lab.features2_1yr,lab.features4_1yr,...
      f2.condGroup,f4.condGroup,f2.procedure,f4.procedure,...
      f2.specialty,f4.specialty,f2.place,f4.place,...
      drugs.extrafeatures2,drugs.extrafeatures4,lab.extrafeatures2,lab.extrafeatures4,...
      f2.nproviders,f4.nproviders,f2.nvendors,f4.nvendors,f2.npcps,f4.npcps,f2.extraLoS,f4.extraLoS,...
      f2.n,f4.n,f2.nspec,f4.nspec,f2.nplace,f4.nplace,f2.nproc,f4.nproc,f2.ncond,f4.ncond,...
      f2.extraDSFS,f4.extraDSFS,f2.extraCharlson,f4.extraCharlson,...
      f2.extraPcpProvVend,f4.extraPcpProvVend);
  allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
  writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
  yr42_rmse = [yr42_rmse; 0];

  save('cache/yr2MakePred_33.mat','allDIH2','NUM_OUTPUTS','yr42_rmse');
end

return

%ridge regression.
[ indices ] = choosePredictors(@ridgeRegression, allDIH2, have, LEADERBOARD_VAR,...
    LEADERBOARD_OPT_CONST, yr42_rmse, 0.3);
indices'
[target.DIH,with_overfit,weights] = ridgeRegression(allDIH2,indices,...
    {LEADERBOARD_VAR,LEADERBOARD_OPT_CONST, yr42_rmse, 0.3});
weights'
allDIH2 = [allDIH2, target.DIH]; NUM_OUTPUTS = NUM_OUTPUTS + 1;
writeTarget(sprintf('Target2_%d.csv',NUM_OUTPUTS),target);
fprintf('RIDGE REGRESSION PREDICTED ERROR %f\n',with_overfit);

if(max(max(allDIH2)) > 15)
    max(allDIH2)
    min(allDIH2)
    disp('XXXXXXXXXXXXXXXXXXXXXXXXXXXXX ERROR IN MAKE PREDS');
end

clear f2 f2;
