indices=find(yr4_rmse>0);
[target.DIH,with_overfit,weights] = ridgeRegression(allDIH,indices,...
    {LEADERBOARD_VAR,LEADERBOARD_OPT_CONST, yr4_rmse, 0.3});
weights'
ox=-0.00035*ones(size(weights)); oy=-0.015*ones(size(weights));
scatter(yr4_rmse(indices),weights,'filled')
name{1}='Linear1'; 
name{2}='Linear2';
name{3}='Linear3'; 
name{4}='Linear4';
name{5}='Linear5'; 
name{6}='Linear6';
name{7}='Linear7'; 
name{8}='Linear8'; 
name{9}='Linear9';
name{10}='Linear10';
name{11}='Linear11';
name{12}='CatVec1';
name{13}='CatVec2';
name{14}='CatVec3';
name{15}='Linear12';
name{16}='Linear13';
name{17}='CatVec3';
name{18}='Linear14';
name{19}='Linear15';
name{20}='Linear16';
name{21}='Median1';
name{22}='Median2';
name{23}='Median3'; %oy(7)=0.012;
name{24}='Mean';
name{25}='Linear17';
name{26}='GBM1'; %oy(9)=0.012;
name{27}='Linear18';
name{28}='Median4';
name{29}='SVM1';
name{30}='Median5';
name{31}='SVM2';
name{32}='MARS1';
name{33}='Factor1';
name{34}='Factor2'; %ox(12)=-0.00065; oy(12)=0;
name{35}='Linear1';
name{36}='CatVec4';
name{37}='SVM3';
name{38}='MARS2';
name{39}='GBM2'; 
name{40}='GBM3'; 
name{41}='const'; 
name{42}='Ens1'; 
name{43}='GBM4'; 
name{44}='GBM5'; 
name{45}='GBM6'; %ox(15)=-0.0006;
name{46}='Median6'; %ox(16)=-0.0002; oy(16)=0.012;
name{47}='Median7';
name{48}='Median8';
name{49}='Median9';
name{50}='Ens2'; 
name{51}='Ens3'; 
name{52}='Median10';
name{53}='RF1';
name{54}='RR1';
name{55}='RF2';
for i=1:length(indices)
    text(yr4_rmse(indices(i))+ox(i),weights(i)+oy(i),name{indices(i)})
end
xlabel('\fontsize{16}Predictor Score');
ylabel('\fontsize{16}Weight of Predictor');
title('\fontsize{16}Greedily Selected Ridge Regression Weights');
axis([0.4615 0.4803 -0.4 0.2])
return

indices=[8,9,14,17,20,22,23,25,26,32,33,34,36,40,45,46];
[target.DIH,with_overfit,weights] = ridgeRegression(allDIH,indices,...
    {LEADERBOARD_VAR,LEADERBOARD_OPT_CONST, yr4_rmse, 0.3});
weights'
ox=-0.00035*ones(size(weights)); oy=-0.015*ones(size(weights));
scatter(yr4_rmse(indices),weights,'filled')
name{8}='Linear1'; 
name{9}='Linear2';
name{14}='VSP1';
name{17}='VSP2';
name{20}='Linear3';
name{22}='Median1';
name{23}='Median2'; oy(7)=0.012;
name{25}='Linear4';
name{26}='GBM1'; oy(9)=0.012;
name{32}='MARS';
name{33}='VSP3';
name{34}='VSP4'; ox(12)=-0.00065; oy(12)=0;
name{36}='VSP5';
name{40}='GBM2'; 
name{45}='GBM3'; ox(15)=-0.0006;
name{46}='Median3'; ox(16)=-0.0002; oy(16)=0.012;
for i=1:length(indices)
    text(yr4_rmse(indices(i))+ox(i),weights(i)+oy(i),name{indices(i)})
end
xlabel('\fontsize{16}Predictor Score');
ylabel('\fontsize{16}Weight of Predictor');
title('\fontsize{16}Greedily Selected Ridge Regression Weights');
axis([0.4615 0.4803 -0.4 0.2])
return
have = find(yr4_rmse>0);
allDIH = postProcessReal(allDIH);
[target.DIH,with_overfit,weights0] = ridgeRegressionPrint(allDIH,have,...
    {LEADERBOARD_VAR,LEADERBOARD_OPT_CONST, yr4_rmse, 0.3,0.000});
weights0'
[target.DIH,with_overfit,weights1] = ridgeRegressionPrint(allDIH,have,...
    {LEADERBOARD_VAR,LEADERBOARD_OPT_CONST, yr4_rmse, 0.3,0.0001});
weights1'
[target.DIH,with_overfit,weights2] = ridgeRegressionPrint(allDIH,have,...
    {LEADERBOARD_VAR,LEADERBOARD_OPT_CONST, yr4_rmse, 0.3,0.003});
weights2'
p=scatter(yr4_rmse(have),weights0,'m','filled')
hold on
scatter(yr4_rmse(have),weights1,'b','filled')
scatter(yr4_rmse(have),weights2,'g','filled')
xlabel('\fontsize{16}Predictor Score');
ylabel('\fontsize{16}Weight of Predictor');
title('\fontsize{16}Regularization in Ridge Regression');
legend('No Regularization','1/30th of Our Regularization','Our Regularization');
return
[pred,c,ptest] = computeTargetDIH_svmprint(ages.yr3,genders.yr3,logDIH.yr3,target.ages,target.genders,...
            drugs.features3_1yr,drugs.features4_1yr,lab.features3_1yr,lab.features4_1yr,...
            f3.condGroup,f4.condGroup,f3.procedure,f4.procedure,...
            f3.specialty,f4.specialty,f3.place,f4.place,...
            drugs.extrafeatures3,drugs.extrafeatures4,lab.extrafeatures3,lab.extrafeatures4,...
            f3.nproviders,f4.nproviders,f3.nvendors,f4.nvendors,f3.npcps,f4.npcps,f3.extraLoS,f4.extraLoS,...
            f3.n,f4.n,f3.nspec,f4.nspec,f3.nplace,f4.nplace,f3.nproc,f4.nproc,f3.ncond,f4.ncond,...
            f3.extraDSFS,f4.extraDSFS,f3.extraCharlson,f4.extraCharlson,...
            f3.extraPcpProvVend,f4.extraPcpProvVend);
plot(0:25,c,'LineWidth',3);
xlabel('\fontsize{16}# of SVMs Predicting Hospitalization');
ylabel('\fontsize{16}Predicted Days in Hospital');
title('\fontsize{16}SVM Predictions');
counts=zeros(26,1);
for i=0:25
    counts(i+1) = length(find(ptest==i));
end
plot(0:25,counts,'LineWidth',3);
xlabel('\fontsize{16}# of SVMs Predicting Hospitalization');
ylabel('\fontsize{16}Number of Patients');
title('\fontsize{16}SVM Counts');
return
[pred,cmale,cfemale] = computeTargetDIH_agesexcombo(ages.yr3,genders.yr3,logDIH.yr3,...
            target.ages,target.genders);
%plot male
p=plot(5:10:85, cmale(1:end-1),'LineWidth',3)
hold on
set(p,'Color','red');
plot(5:10:85, cfemale(1:end-1),'LineWidth',3)
axis([0 90 0 0.5])
xlabel('\fontsize{16}Age'); ylabel('\fontsize{16}Predicted Days in Hospital');
title('\fontsize{16}Days in Hospital by Age and Gender');
legend('male','female');
