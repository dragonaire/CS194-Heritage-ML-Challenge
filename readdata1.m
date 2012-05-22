clear;
tic
[members,genders,ages] = readMembers();
[members,logDIH,DIH,genders,ages,claimsTrunc] = readDIH(members,genders,ages);
bins = extractBins(DIH,genders,ages);
target = readTarget(members, genders, ages);
toc
claims = readClaims(target,members);
toc
drugs = readDrugCounts(target,members);
toc
lab = readLabCounts(target,members);
toc
%TODO
%[claims] = add(claims,logDIH,members,target);

%target.condGroup = extractMemberTraits(claim_members, target.memberids, condGroup);
%target.proc = extractMemberTraits(claim_members, target.memberids, procedure);

%TODO clean up member numbers to be in the range 1-113000 and keep a
%mapping back to original numbers



makePredictions;
%TODO why is our test error so low on year 3?
computeTestErrorOnYear3;
'DONE!'