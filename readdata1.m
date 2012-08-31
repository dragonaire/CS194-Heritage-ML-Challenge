clear;
tic
[members,genders,ages] = readMembers();
[members,logDIH,DIH,genders,ages,claimsTrunc] = readDIH(members,genders,ages);
bins = extractBins(DIH,genders,ages);
target = readTarget(members, genders, ages);
toc
lab = readLabCounts(target,members);
toc
drugs = readDrugCounts(target,members);
toc
try
    load('claims_all.mat');
catch
    claims = readClaims(target,members);
    toc
    [claims] = add(claims,logDIH,members,target);
    claims.f2.extraCG = extraCondGroup(claims.f2.condGroup,ages.yr2);
    claims.f3.extraCG = extraCondGroup(claims.f3.condGroup,ages.yr3);
    claims.f4.extraCG = extraCondGroup(claims.f4.condGroup,target.ages);

    save('claims_all.mat', 'claims');
end
toc

makePredictions;
%TODO why is our test error so low on year 3?
computeTestErrorOnYear3;
'DONE!'
