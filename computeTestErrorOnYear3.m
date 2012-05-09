tic
constants;
% setup fake target to stand in for year 3 testing
fake_target.memberids = members.yr3;
fake_target.claimsTrunc = claimsTrunc.yr3;
%fake_target.DIH = DIH.yr3;
fake_target.genders = genders.yr3;
fake_target.ages = ages.yr3;

all_yr3_pred = [];
ppp_yr3_pred = [];

yr3_pred = computeTargetDIH_sexonly(fake_target,logDIH.genders.yr2);
ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
yr3_pred = postProcess(yr3_pred);
disp(sprintf('TEST ERROR %f',sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2))));
all_yr3_pred = [all_yr3_pred, yr3_pred];

yr3_pred = computeTargetDIH_ageonly(fake_target,bins.yr2);
ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
yr3_pred = postProcess(yr3_pred);
disp(sprintf('TEST ERROR %f',sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2))));
all_yr3_pred = [all_yr3_pred, yr3_pred];

%TODO there's something wrong with the predictions. 1 prediction is missing
%yr3_pred = computeTargetDIH_DIHonly(fake_target,logDIH,members,true);
%ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
%disp(sprintf('TEST ERROR %f',sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2))));
%all_yr3_pred = [all_yr3_pred, yr3_pred];

yr3_pred = computeTargetDIH_agesex(fake_target,ages.yr2,genders.yr2,logDIH.yr2);
ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
yr3_pred = postProcess(yr3_pred);
disp(sprintf('TEST ERROR %f',sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2))));
all_yr3_pred = [all_yr3_pred, yr3_pred];

yr3_pred = computeTargetDIH_agesexdrug(fake_target,ages.yr2,genders.yr2,...
    logDIH.yr2,drugs.features2_1yr,drugs.features3_1yr);
ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
yr3_pred = postProcess(yr3_pred);
disp(sprintf('TEST ERROR %f',sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2))));
all_yr3_pred = [all_yr3_pred, yr3_pred];

yr3_pred = computeTargetDIH_agesexdruglab(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
    lab.features2_1yr,lab.features3_1yr);
ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
yr3_pred = postProcess(yr3_pred);
disp(sprintf('TEST ERROR %f',sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2))));
all_yr3_pred = [all_yr3_pred, yr3_pred];

yr3_pred = computeTargetDIH_agesexdruglab_sqrt(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
    lab.features2_1yr,lab.features3_1yr);
ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
yr3_pred = postProcess(yr3_pred);
disp(sprintf('TEST ERROR %f',sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2))));
all_yr3_pred = [all_yr3_pred, yr3_pred];

yr3_pred = computeTargetDIH_agesexcombo_druglab(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
    lab.features2_1yr,lab.features3_1yr);
ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
yr3_pred = postProcess(yr3_pred);
disp(sprintf('TEST ERROR %f',sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2))));
all_yr3_pred = [all_yr3_pred, yr3_pred];

yr3_pred = computeTargetDIH_agesexcombo_druglabcondproc(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
    lab.features2_1yr,lab.features3_1yr,claims.f2.condGroup,claims.f3.condGroup,...
    claims.f2.procedure,claims.f3.procedure);
ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
yr3_pred = postProcess(yr3_pred);
disp(sprintf('TEST ERROR %f',sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2))));
all_yr3_pred = [all_yr3_pred, yr3_pred];

yr3_pred = computeTargetDIH_agesexcombo_druglabcondproc_loscharlson(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
    lab.features2_1yr,lab.features3_1yr,claims.f2.condGroup,claims.f3.condGroup,...
    claims.f2.procedure,claims.f3.procedure,claims.f2.LoS,claims.f3.LoS,...
    claims.f2.charlson,claims.f3.charlson);
ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
yr3_pred = postProcess(yr3_pred);
disp(sprintf('TEST ERROR %f',sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2))));
all_yr3_pred = [all_yr3_pred, yr3_pred];

[yr3_pred c] = computeTargetDIH_many1(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
    lab.features2_1yr,lab.features3_1yr,claims.f2.condGroup,claims.f3.condGroup,...
    claims.f2.procedure,claims.f3.procedure,claims.f2.LoS,claims.f3.LoS,...
    claims.f2.charlson,claims.f3.charlson,claims.f2.specialty,claims.f3.specialty,...
    claims.f2.place,claims.f3.place);
ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
yr3_pred = postProcess(yr3_pred);
disp(sprintf('TEST ERROR %f',sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2))));
all_yr3_pred = [all_yr3_pred, yr3_pred];

[yr3_pred c] = computeTargetDIH_many3(ages.yr2,genders.yr2,logDIH.yr2,...
    fake_target.ages,fake_target.genders,drugs.features2_1yr,drugs.features3_1yr,...
    lab.features2_1yr,lab.features3_1yr,claims.f2.condGroup,claims.f3.condGroup,...
    claims.f2.procedure,claims.f3.procedure,claims.f2.LoS,claims.f3.LoS,...
    claims.f2.charlson,claims.f3.charlson,claims.f2.specialty,claims.f3.specialty,...
    claims.f2.place,claims.f3.place,claims.f2.DSFS,claims.f3.DSFS);
ppp_yr3_pred = [ppp_yr3_pred, yr3_pred]; % pre-post-process
yr3_pred = postProcess(yr3_pred);
disp(sprintf('TEST ERROR %f',sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2))));
all_yr3_pred = [all_yr3_pred, yr3_pred];

%get median DIH for each member
yr3_pred = median(all_yr3_pred(:,9:11),2);
disp('SMALL MEDIAN PREDICTOR');
disp(sprintf('TEST ERROR %f',sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2))));

%get median DIH for each member
yr3_pred = median(ppp_yr3_pred(:,9:11),2);
yr3_pred = postProcess(yr3_pred);
disp('PRE-POST-PROCESS SMALL MEDIAN PREDICTOR');
disp(sprintf('TEST ERROR %f',sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2))));

%get mean DIH for each member
yr3_pred = mean(all_yr3_pred,2);
disp('MEDIAN PREDICTOR');
disp(sprintf('TEST ERROR %f',sqrt(mean((log(DIH.yr3+1)-log(yr3_pred+1)).^2))));
toc
