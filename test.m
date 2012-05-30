load('f2.mat');
load('f3.mat');
load('f4.mat');
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
yr3_pred = postProcess(yr3_pred);
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2));
disp(sprintf('TEST ERROR %f',err));
[target.DIH] = computeTargetDIH_mars2(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
    drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
    f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
    f3.specialty,f4.specialty,f3.place,f4.place,...
    drugs.extrafeatures3,drugs.extrafeatures4,lab.extrafeatures3,lab.extrafeatures4,...
    f3.nproviders,f4.nproviders,f3.nvendors,f4.nvendors,f3.npcps,f4.npcps,f3.extraLoS,f4.extraLoS,...
    f3.n,f4.n,f3.nspec,f4.nspec,f3.nplace,f4.nplace,f3.nproc,f4.nproc,f3.ncond,f4.ncond,...
    f3.extraDSFS,f4.extraDSFS,f3.extraCharlson,f4.extraCharlson,...
    f3.extraPcpProvVend,f4.extraPcpProvVend);
return
load('f2.mat');
load('f3.mat');
load('f4.mat');
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
yr3_pred = postProcess(yr3_pred);
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2));
disp(sprintf('TEST ERROR %f',err));
[target.DIH] = computeTargetDIH_svm3(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
    drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
    f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
    f3.specialty,f4.specialty,f3.place,f4.place,...
    drugs.extrafeatures3,drugs.extrafeatures4,lab.extrafeatures3,lab.extrafeatures4,...
    f3.nproviders,f4.nproviders,f3.nvendors,f4.nvendors,f3.npcps,f4.npcps,f3.extraLoS,f4.extraLoS,...
    f3.n,f4.n,f3.nspec,f4.nspec,f3.nplace,f4.nplace,f3.nproc,f4.nproc,f3.ncond,f4.ncond,...
    f3.extraDSFS,f4.extraDSFS,f3.extraCharlson,f4.extraCharlson,...
    f3.extraPcpProvVend,f4.extraPcpProvVend);
return


toc
tic
[target.DIH] = computeTargetDIH_b1(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
    drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
    f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
    f3.specialty,f4.specialty,f3.place,f4.place);
toc
return

ens = fitensemble(ages.yr2,logDIH.yr2,'LSBoost',10,'tree')
yr3_pred = predict(ens, ages.yr3);
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2));
disp(sprintf('TEST ERROR %f',err));


load('f2.mat');
load('f3.mat');
load('f4.mat');
[yr3_pred c] = computeTargetDIH_many6(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
    lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
    f2.procedure,f3.procedure,f2.specialty,f3.specialty,...
    f2.place,f3.place,f2.DSFS,f3.DSFS,drugs.extrafeatures2,drugs.extrafeatures3,...
    lab.extrafeatures2,lab.extrafeatures3,f2.nproviders,f3.nproviders,...
    f2.nvendors,f3.nvendors,f2.npcps,f3.npcps,f2.extraLoS,f3.extraLoS,f2.n,f3.n,...
    f2.nspec,f3.nspec,f2.nplace,f3.nplace,f2.nproc,f3.nproc,f2.ncond,f3.ncond,...
    f2.extraDSFS,f3.extraDSFS,f2.extraCharlson,f3.extraCharlson,...
    f2.extraPcpProvVend,f3.extraPcpProvVend);
yr3_pred = postProcess(yr3_pred);
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2));
disp(sprintf('TEST ERROR %f',err));

[target.DIH c4] = computeTargetDIH_many6(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
    drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
    f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
    f3.specialty,f4.specialty,f3.place,f4.place,...
    f3.DSFS,f4.DSFS,drugs.extrafeatures3,drugs.extrafeatures4,lab.extrafeatures3,lab.extrafeatures4,...
    f3.nproviders,f4.nproviders,f3.nvendors,f4.nvendors,f3.npcps,f4.npcps,f3.extraLoS,f4.extraLoS,...
    f3.n,f4.n,f3.nspec,f4.nspec,f3.nplace,f4.nplace,f3.nproc,f4.nproc,f3.ncond,f4.ncond,...
    f3.extraDSFS,f4.extraDSFS,f3.extraCharlson,f4.extraCharlson,...
    f3.extraPcpProvVend,f4.extraPcpProvVend);
return
load('f2.mat');
load('f3.mat');
load('f4.mat');
[yr3_pred c] = computeTargetDIH_n2(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,drugs.extrafeatures2,drugs.extrafeatures3,...
    lab.extrafeatures2,lab.extrafeatures3,f2.nproviders,f3.nproviders,...
    f2.nvendors,f3.nvendors,f2.npcps,f3.npcps,f2.extraLoS,f3.extraLoS,f2.n,f3.n,...
    f2.nspec,f3.nspec,f2.nplace,f3.nplace,f2.nproc,f3.nproc,f2.ncond,f3.ncond,...
    f2.extraDSFS,f3.extraDSFS,f2.extraCharlson,f3.extraCharlson,...
    f2.extraPcpProvVend,f3.extraPcpProvVend);
yr3_pred = postProcess(yr3_pred);
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
disp(sprintf('TEST ERROR %f',err));

[target.DIH c4] = computeTargetDIH_n2(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
    drugs.extrafeatures3,drugs.extrafeatures4,lab.extrafeatures3,lab.extrafeatures4,...
    f3.nproviders,f4.nproviders,f3.nvendors,f4.nvendors,f3.npcps,f4.npcps,f3.extraLoS,f4.extraLoS,...
    f3.n,f4.n,f3.nspec,f4.nspec,f3.nplace,f4.nplace,f3.nproc,f4.nproc,f3.ncond,f4.ncond,...
    f3.extraDSFS,f4.extraDSFS,f3.extraCharlson,f4.extraCharlson,...
    f3.extraPcpProvVend,f4.extraPcpProvVend);
return
load('f2.mat');
load('f3.mat');
load('f4.mat');
[yr3_pred] = computeTargetDIH_b1(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
    lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
    f2.procedure,f3.procedure,f2.specialty,f3.specialty,f2.place,f3.place);
yr3_pred = postProcess(yr3_pred);
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
disp(sprintf('TEST ERROR %f',err));

[target.DIH] = computeTargetDIH_b1(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
    drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
    f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
    f3.specialty,f4.specialty,f3.place,f4.place);
return

ens = fitensemble(ages.yr2,logDIH.yr2,'LSBoost',10,'tree')
yr3_pred = predict(ens, ages.yr3);
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2));
disp(sprintf('TEST ERROR %f',err));

return
load('f2.mat');
load('f3.mat');
load('f4.mat');
[yr3_pred c] = computeTargetDIH_many5(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,f2.specPlace,f3.specPlace);
yr3_pred = postProcess(yr3_pred);
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
disp(sprintf('TEST ERROR %f',err));

[target.DIH c4] = computeTargetDIH_many5(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
    f3.specPlace,f4.specPlace);
return
load('f2.mat');
load('f3.mat');
load('f4.mat');
[yr3_pred c] = computeTargetDIH_n1(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,drugs.extrafeatures2,drugs.extrafeatures3,...
    lab.extrafeatures2,lab.extrafeatures3,f2.nproviders,f3.nproviders,...
    f2.nvendors,f3.nvendors,f2.npcps,f3.npcps,f2.extraLoS,f3.extraLoS,f2.n,f3.n);
yr3_pred = postProcess(yr3_pred);
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
disp(sprintf('TEST ERROR %f',err));

[target.DIH c4] = computeTargetDIH_n1(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
    drugs.extrafeatures3,drugs.extrafeatures4,lab.extrafeatures3,lab.extrafeatures4,...
    f3.nproviders,f4.nproviders,...
    f3.nvendors,f4.nvendors,f3.npcps,f4.npcps,f3.extraLoS,f4.extraLoS,f3.n,f4.n);
return

load('f2.mat');
load('f3.mat');
load('f4.mat');

[yr3_pred c] = computeTargetDIH_extradsfscharlson(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,f2.extraDSFS,f3.extraDSFS,f2.extraCharlson,f3.extraCharlson);
yr3_pred = postProcess(yr3_pred);
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2));
disp(sprintf('TEST ERROR %f',err));

[target.DIH c4] = computeTargetDIH_extradsfscharlson(ages.yr3,genders.yr3,logDIH.yr3,...
    target.ages,target.genders,f3.extraDSFS,f4.extraDSFS,f3.extraCharlson,f4.extraCharlson);
return

indices = [6,9,12,14,19,20,22,23,24];
yr3_opt_const = mean(logDIH.yr3);
yr3_var = mean((logDIH.yr3 - yr3_opt_const).^2);
[yr3_pred,yr3_weights] = ridgeRegression(all_yr3_pred(:,indices), yr3_var,...
    yr3_opt_const, yr3_rmse(indices), 1.0);
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2));
disp(sprintf('RIDGE REGRESSION TEST ERROR %f',err));
yr3_weights'

return

yr3_pred = exp(mean(log(ppp_yr3_pred(:,9:22)+1),2))-1;
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2));
disp(sprintf('%d TEST ERROR %f',size(all_yr3_pred,2),err));
return

good = 9:20;
yr3_pred = median(all_yr3_pred(:,good),2);
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2));
disp(sprintf('TEST ERROR %f',err));
return

load('f2.mat');
load('f3.mat');
load('f4.mat');

[yr3_pred c] = computeTargetDIH_condspeccombo(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,f2.condSpec,f3.condSpec);
yr3_pred = postProcess(yr3_pred);
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2));
disp(sprintf('TEST ERROR %f',err));

[target.DIH c4] = computeTargetDIH_condspeccombo(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
    f3.condSpec,f4.condSpec);
return
[yr3_pred c] = computeTargetDIH_condplacecombo(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,f2.condPlace,f3.condPlace);
yr3_pred = postProcess(yr3_pred);
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
disp(sprintf('TEST ERROR %f',err));

[target.DIH c4] = computeTargetDIH_condplacecombo(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
    f3.condPlace,f4.condPlace);
return
[yr3_pred c] = computeTargetDIH_catvec1_many3(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,drugs.extrafeatures2,drugs.extrafeatures3,...
    lab.extrafeatures2,lab.extrafeatures3,f2.nproviders,f3.nproviders,...
    f2.nvendors,f3.nvendors,f2.npcps,f3.npcps,f2.extraLoS,f3.extraLoS,f2.n,f3.n);
yr3_pred = postProcess(yr3_pred);
testerr_many3 = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2));
disp(sprintf('TEST ERROR %f',testerr_many3));

target.DIH = computeTargetDIH_catvec1_many3(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
    drugs.extrafeatures3,drugs.extrafeatures4,lab.extrafeatures3,lab.extrafeatures4,...
    f3.nproviders,f4.nproviders,...
    f3.nvendors,f4.nvendors,f3.npcps,f4.npcps,f3.extraLoS,f4.extraLoS,f3.n,f4.n);
return


[yr3_pred c] = computeTargetDIH_many3(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
    lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
    f2.procedure,f3.procedure,f2.LoS,f3.LoS,...
    f2.charlson,f3.charlson,f2.specialty,f3.specialty,...
    f2.place,f3.place,f2.DSFS,f3.DSFS);
yr3_pred = postProcess(yr3_pred);
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
disp(sprintf('TEST ERROR %f',err));

[target.DIH c4] = computeTargetDIH_many3(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
    drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
    f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
    f3.LoS,f4.LoS,f3.charlson,f4.charlson,...
    f3.specialty,f4.specialty,f3.place,f4.place,...
    f3.DSFS,f4.DSFS);
return


target.DIH = computeTargetDIH_catvec1_agesex(target,ages.yr3,genders.yr3,logDIH.yr3,...
    target.ages,target.genders);
writeTarget(sprintf('Target_18.csv'),target);
return

numpc=[85:5:140; 75:5:130];
numpc=[129:131; 118:120];
numpc=120*ones(2,1);
errs1 = []; errs2=[];
for i=1:size(numpc,2)
    [yr3_pred c] = computeTargetDIH_catvec1_many2(ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
        lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
        f2.procedure,f3.procedure,f2.specialty,f3.specialty,...
        f2.place,f3.place,numpc(2,i));
    yr3_pred = postProcess(yr3_pred);
    testerr_many2 = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2));
    errs2 = [errs2;testerr_many2];
    disp(sprintf('TEST ERROR %f, NPC: %d',testerr_many2,numpc(2,i)));

    target.DIH = computeTargetDIH_catvec1_many2(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
        drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
        f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
        f3.specialty,f4.specialty,f3.place,f4.place,numpc(2,i));

    %{
    [yr3_pred c A_vars M_vars] = computeTargetDIH_catvec1_many1(ages.yr2,genders.yr2,logDIH.yr2,...
        fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
        lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
        f2.procedure,f3.procedure,f2.LoS,f3.LoS,...
        f2.specialty,f3.specialty,...
        f2.place,f3.place,numpc(1,i));
    yr3_pred = postProcess(yr3_pred);
    testerr_many1=sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2));
    errs1 = [errs1;testerr_many1];
    disp(sprintf('TEST ERROR %f, NPC: %d',testerr_many1,numpc(1,i)));
    target.DIH = computeTargetDIH_catvec1_many1(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
        drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
        f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
        f3.LoS,f4.LoS,...
        f3.specialty,f4.specialty,f3.place,f4.place,numpc(1,i));
        %}
end
result = [numpc',errs1,errs2]
return

[yr3_pred] = computeTargetDIH_catvec1_agesex(fake_target,ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders);
yr3_pred = postProcess(yr3_pred);
err = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2)); yr3_rmse = [yr3_rmse; err];
disp(sprintf('TEST ERROR %f',err));

return

indices = [9,10,11,13,14];
indices = 9:14;
yr3_opt_const = mean(logDIH.yr3);
yr3_var = mean((logDIH.yr3 - yr3_opt_const).^2);
[yr3_pred,weights] = ridgeRegression(all_yr3_pred(:,indices), yr3_var,...
    yr3_opt_const, yr3_rmse(indices));
weights'
testerr = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2));
disp(sprintf('TEST ERROR %f',testerr));

[yr3_pred,weights] = ridgeRegression(all_yr3_pred(:,:), yr3_var,...
    yr3_opt_const, yr3_rmse(:));
weights'
testerr = sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2));
disp(sprintf('TEST ERROR %f',testerr));
return



[yr3_pred c vars] = computeTargetDIH_many3(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
    lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
    f2.procedure,f3.procedure,f2.LoS,f3.LoS,...
    f2.charlson,f3.charlson,f2.specialty,f3.specialty,...
    f2.place,f3.place,f2.DSFS,f3.DSFS);
yr3_pred = postProcess(yr3_pred);
disp(sprintf('TEST ERROR %f',sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2))));
target.DIH = computeTargetDIH_many3(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
    drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
    f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
    f3.LoS,f4.LoS,f3.charlson,f4.charlson,...
    f3.specialty,f4.specialty,f3.place,f4.place,...
    f3.DSFS,f4.DSFS);
return
[yr3_pred c vars] = computeTargetDIH_many4(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
    lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
    f2.procedure,f3.procedure,f2.LoS,f3.LoS,...
    f2.specialty,f3.specialty,...
    f2.place,f3.place);
yr3_pred = postProcess(yr3_pred);
disp(sprintf('TEST ERROR %f',sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2))));
%return
return


return
target.DIH = computeTargetDIH_catvec1_many2(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
    drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
    f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
    f3.specialty,f4.specialty,f3.place,f4.place);
[yr3_pred c] = computeTargetDIH_catvec1_many2(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
    lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
    f2.procedure,f3.procedure,...
    f2.specialty,f3.specialty,f2.place,f3.place);
yr3_pred = postProcess(yr3_pred);
disp(sprintf('TEST ERROR %f',sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2))));
return
[pred, params] = computeTargetDIH_catvec1_agesex(fake_target,ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders);
pred = postProcess(yr3_pred);
disp(sprintf('TEST ERROR %f',sqrt(mean((log(DIH.yr3+1)-log(postProcess(pred)+1)).^2))));
return
tic
[yr3_pred c] = computeTargetDIH_many1(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
    lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
    f2.procedure,f3.procedure,f2.LoS,f3.LoS,...
    f2.charlson,f3.charlson,f2.specialty,f3.specialty,...
    f2.place,f3.place);
toc
pred = postProcess(yr3_pred);
disp(sprintf('TEST ERROR %f',sqrt(mean((log(DIH.yr3+1)-log(postProcess(pred)+1)).^2))));
return

[yr3_pred c] = computeTargetDIH_many3(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
    lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
    f2.procedure,f3.procedure,f2.LoS,f3.LoS,...
    f2.charlson,f3.charlson,f2.specialty,f3.specialty,...
    f2.place,f3.place,f2.DSFS,f3.DSFS);
%yr3_pred = min(max(yr3_pred, MIN_PREDICTION), MAX_PREDICTION);
yr3_pred = postProcess(yr3_pred);
disp(sprintf('TEST ERROR %f',sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2))));
return
yr4_pred = computeTargetDIH_many3(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
    drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
    f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
    f3.LoS,f4.LoS,f3.charlson,f4.charlson,...
    f3.specialty,f4.specialty,f3.place,f4.place);
return

tic
yr3_pred = computeTargetDIH_agesex(fake_target,ages.yr2,genders.yr2,logDIH.yr2);
yr3_pred = postProcess(yr3_pred);
disp(sprintf('TEST ERROR %f',sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2))));
toc
return
target.DIH = computeTargetDIH_agesexcombo_druglabcondproc_loscharlson(...
    ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
    drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
    f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
    f3.LoS,f4.LoS,f3.charlson,f4.charlson);
yr3_pred = computeTargetDIH_agesexcombo_druglabcondproc_loscharlson(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
    lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
    f2.procedure,f3.procedure,f2.LoS,f3.LoS,...
    f2.charlson,f3.charlson);
yr3_pred = min(max(yr3_pred, MIN_PREDICTION), MAX_PREDICTION);
disp(sprintf('TEST ERROR %f',sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2))));
return

yr3_pred = computeTargetDIH_agesexcombo_druglabcondproc_loscharlson(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
    lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
    f2.procedure,f3.procedure,f2.LoS,f3.LoS,...
    f2.charlson,f3.charlson);
yr3_pred = min(max(yr3_pred, MIN_PREDICTION), MAX_PREDICTION);
disp(sprintf('TEST ERROR %f',sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2))));
return
%fid = fopen('csv','rt');
%C = textscan(fid,'%f %f %f %f %s %s %s %s %s %s %s %s %s %f','Delimiter',',','CollectOutput',1);
%fclose(fid);
[members, members_i] = sort(C{1}(:,1));
stringLoS = C{2}(members_i,5);
LoS = 1*strcmp(stringLoS,'1 day') + ...
    2*strcmp(stringLoS,'2 days') + ...
    3*strcmp(stringLoS,'3 days') + ...
    4*strcmp(stringLoS,'4 days') + ...
    5*strcmp(stringLoS,'5 days') + ...
    6*strcmp(stringLoS,'6 days') + ...
    7*strcmp(stringLoS,'1- 2 weeks') + ...
    8*strcmp(stringLoS,'2- 4 weeks') + ...
    9*strcmp(stringLoS,'4- 8 weeks') + ...
    10*strcmp(stringLoS,'8- 12 weeks') + ...
    11*strcmp(stringLoS,'12- 26 weeks') + ...
    12*strcmp(stringLoS,'26+ weeks') + ...
    13*strcmp(stringLoS,'');
LoS(C{3}(members_i)==1) = 14;
for i=1:14
    disp(sprintf('%d',sum(LoS==i)));
end
return

return
target.DIH = computeTargetDIH_many1(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
    drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
    f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
    f3.LoS,f4.LoS,f3.charlson,f4.charlson,...
    f3.specialty,f4.specialty,f3.place,f4.place);
return
yr3_pred = median(all_yr3_pred(:,7:9),2);
disp('SMALL MEDIAN PREDICTOR');
disp(sprintf('TEST ERROR %f',sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2))));
return
%{
%}

return
[yr3_pred c] = computeTargetDIH_agesexcombo_druglabcondproc_loscharlson(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
    lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
    f2.procedure,f3.procedure,f2.LoS,f3.LoS,...
    f2.charlson,f3.charlson);
disp(sprintf('TEST ERROR %f',sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2))));

return

yr3_pred = computeTargetDIH_agesexcombo_druglabcondproc(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
    lab.features2_1yr,lab.features3_1yr,f2.condGroup,f3.condGroup,...
    f2.procedure,f3.procedure);
disp(sprintf('TEST ERROR %f',sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2))))







%{
function [target_DIH c] = computeTargetDIH_many1(ages,genders,logDIH,...
    ages_test,genders_test,drugs_train,drugs_test,lab_train,lab_test,cond_train,cond_test,...
    proc_train,proc_test,los_train,los_test,charlson_train,charlson_test,...
    spec_train,spec_test,place_train,place_test)
constants;

offsets = [...
    SIZE.AGE*SIZE.SEX,...
    SIZE.DRUG_1YR,...
    SIZE.LAB_1YR,...
    SIZE.COND_GROUP,...
    SIZE.PROCEDURE,...
    SIZE.LoS,...
    SIZE.CHARLSON,...
    SIZE.SPECIALTY,...
    SIZE.PLACE,...
    ];
offsets = cumsum(offsets);
offsets = [0; offsets(1:end)'];

agesex = ages + 10*(genders-1);
nrows = length(agesex);
ncols = offsets(2);
n = offsets(end);
rows_i = 1:length(agesex);
cols_i = agesex;
val = 1;

% map the data to a new space
drugs_train = drugMap(drugs_train);
drugs_test = drugMap(drugs_test);
lab_train = labMap(lab_train);
lab_test = labMap(lab_test);
cond_train = condMap(cond_train);
cond_test = condMap(cond_test);
proc_train = procMap(proc_train);
proc_test = procMap(proc_test);
los_train = losMap(los_train);
los_test = losMap(los_test);
charlson_train = charlsonMap(charlson_train);
charlson_test = charlsonMap(charlson_test);
spec_train = specMap(spec_train);
spec_test = specMap(spec_test);
place_train = placeMap(place_train);
place_test = placeMap(place_test);

A = [full(sparse(rows_i, cols_i, val, nrows, ncols)), ...
    drugs_train, lab_train, cond_train, proc_train, los_train, charlson_train,...
    spec_train, place_train];
A=sparse(A);
cvx_begin quiet
    variables c(n);
    minimize(norm(A*c - logDIH))
    subject to
        c(139:143) == 0; % for not using charlson index
        %c(end-30:end-5) == 0; % for not using los
cvx_end
if ~strcmp(cvx_status,'Solved')
    'computeTargetDIH_many1 failed'
    keyboard
end
disp(sprintf('computeTargetDIH_many1 TRAINING ERROR: %f',sqrt((cvx_optval^2)/NUM_TARGETS)))

c_agesex = c(offsets(1)+1:offsets(2));
c_drugs = c(offsets(2)+1:offsets(3));
c_lab = c(offsets(3)+1:offsets(4));
c_cond = c(offsets(4)+1:offsets(5));
c_proc = c(offsets(5)+1:offsets(6));
c_los = c(offsets(6)+1:offsets(7));
c_charlson = c(offsets(7)+1:offsets(8));
c_spec = c(offsets(8)+1:offsets(9));
c_place = c(offsets(9)+1:offsets(10));
target_agesex = ages_test + 10*(genders_test-1);
target_DIH = c_agesex(target_agesex) + drugs_test*c_drugs + ...
    lab_test*c_lab + cond_test*c_cond + proc_test*c_proc + ...
    los_test*c_los + charlson_test*c_charlson + spec_test*c_spec + place_test*c_place;
target_DIH = exp(target_DIH)-1;
end
%TODO these functions make the arrays unsparse. Subtract the min value to
%make them sparse again
function x = condMap(x)
x = log(x+3.5);
end
function x = procMap(x)
x = log(x+0.4);
end
function x = drugMap(x)
x = log(x+0.5);
%x = log(sqrt(x)+6);
%x = sqrt(x);
end
function x = labMap(x)
x = x.^1.1;
end
function x = losMap(x)
x = x.^3.5;
%x = sqrt(x);
%x(:,27) = min(1,x(:,27));
end
function x = charlsonMap(x)
%x = log(x+1);
end
function x = specMap(x)
%nothing
end
function x = placeMap(x)
%nothing
end
%}
%{
function [target_DIH c] = computeTargetDIH_many1(ages,genders,logDIH,...
    ages_test,genders_test,drugs_train,drugs_test,lab_train,lab_test,cond_train,cond_test,...
    proc_train,proc_test,los_train,los_test,charlson_train,charlson_test,...
    spec_train,spec_test,place_train,place_test)
constants;

offsets = [...
    SIZE.AGE*SIZE.SEX,...
    SIZE.DRUG_1YR,...
    SIZE.LAB_1YR,...
    SIZE.COND_GROUP,...
    SIZE.PROCEDURE,...
    SIZE.LoS,...
    SIZE.CHARLSON,...
    SIZE.SPECIALTY,...
    SIZE.PLACE,...
    ];
offsets = cumsum(offsets);
offsets = [0; offsets(1:end)'];

agesex = ages + 10*(genders-1);
nrows = length(agesex);
ncols = offsets(2);
n = offsets(end);
rows_i = 1:length(agesex);
cols_i = agesex;
val = 1;

% map the data to a new space
drugs_train = drugMap(drugs_train);
drugs_test = drugMap(drugs_test);
lab_train = labMap(lab_train);
lab_test = labMap(lab_test);
cond_train = condMap(cond_train);
cond_test = condMap(cond_test);
proc_train = procMap(proc_train);
proc_test = procMap(proc_test);
los_train = losMap(los_train);
los_test = losMap(los_test);
charlson_train = charlsonMap(charlson_train);
charlson_test = charlsonMap(charlson_test);
spec_train = specMap(spec_train);
spec_test = specMap(spec_test);
place_train = placeMap(place_train);
place_test = placeMap(place_test);

A = [full(sparse(rows_i, cols_i, val, nrows, ncols)), ...
    drugs_train, lab_train, cond_train, proc_train, los_train, charlson_train,...
    spec_train, place_train];
A=sparse(A);
cvx_begin quiet
    variables c(n);
    minimize(norm(A*c - logDIH))
    subject to
        %c(31:end) >= 0;
        %c(offsets(3:end)) == 0;
        c(112:138) == 0; % for not using los
        c(139:143) == 0; % for not using charlson index
        %c(144:156) == 0; % for not using specialty
        %c(157:165) == 0; % for not using place
        c(160:165) == 0; %TODO randomly setting some to 0, because of overfitting
cvx_end
if ~strcmp(cvx_status,'Solved') && ~strcmp(cvx_status,'Inaccurate/Solved')
    'computeTargetDIH_many1 failed'
    keyboard
end
disp(sprintf('computeTargetDIH_many1 TRAINING ERROR: %f',sqrt((cvx_optval^2)/NUM_TARGETS)))

c_agesex = c(offsets(1)+1:offsets(2));
c_drugs = c(offsets(2)+1:offsets(3));
c_lab = c(offsets(3)+1:offsets(4));
c_cond = c(offsets(4)+1:offsets(5));
c_proc = c(offsets(5)+1:offsets(6));
c_los = c(offsets(6)+1:offsets(7));
c_charlson = c(offsets(7)+1:offsets(8));
c_spec = c(offsets(8)+1:offsets(9));
c_place = c(offsets(9)+1:offsets(10));
target_agesex = ages_test + 10*(genders_test-1);
target_DIH = c_agesex(target_agesex) + drugs_test*c_drugs + ...
    lab_test*c_lab + cond_test*c_cond + proc_test*c_proc + ...
    los_test*c_los + charlson_test*c_charlson + spec_test*c_spec + place_test*c_place;
target_DIH = exp(target_DIH)-1;
end
%TODO these functions make the arrays unsparse. Subtract the min value to
%make them sparse again
function x = condMap(x)
x = log(x+3.5);
end
function x = procMap(x)
x = log(x+0.4);
end
function x = drugMap(x)
x = log(x+0.5);
%x = log(sqrt(x)+6);
%x = sqrt(x);
end
function x = labMap(x)
x = x.^1.1;
end
function x = losMap(x)
x = x.^3.5;
%x = sqrt(x);
%x(:,27) = min(1,x(:,27));
end
function x = charlsonMap(x)
%x = log(x+1);
end
function x = specMap(x)
%nothing
end
function x = placeMap(x)
%nothing
end
%}
%{
function [target_DIH c] = computeTargetDIH_many1(ages,genders,logDIH,...
    ages_test,genders_test,drugs_train,drugs_test,lab_train,lab_test,cond_train,cond_test,...
    proc_train,proc_test,los_train,los_test,charlson_train,charlson_test,...
    spec_train,spec_test,place_train,place_test)
constants;

offsets = [...
    SIZE.AGE*SIZE.SEX,...
    SIZE.DRUG_1YR,...
    SIZE.LAB_1YR,...
    SIZE.COND_GROUP,...
    SIZE.PROCEDURE,...
    SIZE.LoS,...
    SIZE.CHARLSON,...
    SIZE.SPECIALTY,...
    SIZE.PLACE,...
    ];
offsets = cumsum(offsets);
offsets = [0; offsets(1:end)'];

agesex = ages + 10*(genders-1);
nrows = length(agesex);
ncols = offsets(2);
n = offsets(end);
rows_i = 1:length(agesex);
cols_i = agesex;
val = 1;

% map the data to a new space
drugs_train = drugMap(drugs_train);
drugs_test = drugMap(drugs_test);
lab_train = labMap(lab_train);
lab_test = labMap(lab_test);
cond_train = condMap(cond_train);
cond_test = condMap(cond_test);
proc_train = procMap(proc_train);
proc_test = procMap(proc_test);
los_train = losMap(los_train);
los_test = losMap(los_test);
charlson_train = charlsonMap(charlson_train);
charlson_test = charlsonMap(charlson_test);
spec_train = specMap(spec_train);
spec_test = specMap(spec_test);
place_train = placeMap(place_train);
place_test = placeMap(place_test);

A = [full(sparse(rows_i, cols_i, val, nrows, ncols)), ...
    drugs_train, lab_train, cond_train, proc_train, los_train, charlson_train,...
    spec_train, place_train];
A=sparse(A);
Charlson = -diag(ones(4,1),1)+eye(5);
cvx_begin quiet
    variables c(n);
    minimize(norm(A*c - logDIH))
    subject to
        %c(31:end) >= 0;
        %c(offsets(3:end)) == 0;
        c(112:138) == 0; % for not using los
        %Charlson*c(139:143) <= 0; % charlson index is of increasing badness
        c(139:143) == 0; % for not using charlson index
        %c(144:156) == 0; % for not using specialty
        %c(157:165) == 0; % for not using place
        %c(111) == 0;
        c(156) == 0;
        c(160:164) == 0; %TODO randomly setting some to 0, because of overfitting
cvx_end
if ~strcmp(cvx_status,'Solved') && ~strcmp(cvx_status,'Inaccurate/Solved')
    'computeTargetDIH_many1 failed'
    keyboard
end
disp(sprintf('computeTargetDIH_many1 TRAINING ERROR: %f',sqrt((cvx_optval^2)/NUM_TARGETS)))

c_agesex = c(offsets(1)+1:offsets(2));
c_drugs = c(offsets(2)+1:offsets(3));
c_lab = c(offsets(3)+1:offsets(4));
c_cond = c(offsets(4)+1:offsets(5));
c_proc = c(offsets(5)+1:offsets(6));
c_los = c(offsets(6)+1:offsets(7));
c_charlson = c(offsets(7)+1:offsets(8));
c_spec = c(offsets(8)+1:offsets(9));
c_place = c(offsets(9)+1:offsets(10));

agesex_test = ages_test + 10*(genders_test-1);
agesex_test = sparse(1:length(ages_test), agesex_test, 1, length(ages_test), SIZE.AGE*SIZE.SEX);
M = sparse([agesex_test,drugs_test,lab_test,cond_test,proc_test,los_test,charlson_test,...
    spec_test,place_test]);
c = hillClimb(A,c,logDIH);
target_DIH = M*c;
target_DIH = exp(target_DIH)-1;
end
%TODO these functions make the arrays unsparse. Subtract the min value to
%make them sparse again
function x = condMap(x)
x = log(x+3.5);
end
function x = procMap(x)
x = log(x+0.4);
end
function x = drugMap(x)
x = log(x+0.5);
%x = log(sqrt(x)+6);
%x = sqrt(x);
end
function x = labMap(x)
x = x.^1.1;
end
function x = losMap(x)
x = x.^3.5;
%x = sqrt(x);
%x(:,27) = min(1,x(:,27));
end
function x = charlsonMap(x)
%x = log(x+1);
end
function x = specMap(x)
%x = sqrt(x);
x = x.^0.79;
end
function x = placeMap(x)
%x = sqrt(x);
x = log(x+0.4);
end
function c = hillClimb(A,c,logDIH)
constants;
STEP = 0.001;
OVERFIT = 0.05;
for iter=1:1
    iter
    change = false;
    for i=1:length(c)
        old = norm(max(abs(max(A*c,MIN_PREDICTION)-logDIH),OVERFIT));
        c(i) = c(i) + STEP;
        new1 = norm(max(abs(max(A*c,MIN_PREDICTION)-logDIH),OVERFIT));
        c(i) = c(i) - 2*STEP;
        new2 = norm(max(abs(max(A*c,MIN_PREDICTION)-logDIH),OVERFIT));
        if new1 > old && new2 > old
            c(i) = c(i) + STEP;
        elseif new1 < new2
            change=true;
            c(i) = c(i) + 2*STEP;
        else
            change=true;
        end 
    end
    if ~change
        break
    end
end
end
%}
