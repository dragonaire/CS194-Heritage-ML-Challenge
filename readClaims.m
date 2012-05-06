function [ claims ] = readClaims(target,members)
try
    load('claims.mat');
    return;
catch
    'Claims were not cached! This could take a few minutes.'
end
constants;
fid = fopen('Claims.csv','rt');
% ints: MemberID,ProviderID,Vendor,PCP
% strings: Year,Specialty,PlaceSvc,PayDelay,LengthOfStay,
% DSFS,PrimaryConditionGroup,CharlsonIndex,ProcedureGroup
% ints: SupLOS
% Note: DSFS is Days Since First Service
%TODO change textscan to use the 'HeaderLines' param
C = textscan(fid,'%f %f %f %f %s %s %s %s %s %s %s %s %s %f','Delimiter',',','CollectOutput',1);
fclose(fid);
[claims.members, members_i] = sort(C{1}(:,1));
claims.members_i = members_i;
claims.provider = C{1}(members_i,2);
claims.vendor = C{1}(members_i,3);
claims.pcp = C{1}(members_i,4);
stringYear = C{2}(members_i,1);
claims.year = 1*strcmp(stringYear, 'Y1') + 2*strcmp(stringYear, 'Y2') + ...
    3*strcmp(stringYear, 'Y3');
stringSpecialty = C{2}(members_i,2);
claims.specialty = 1*strcmp(stringSpecialty,'Anesthesiology') + ...
    2*strcmp(stringSpecialty,'Diagnostic Imaging') + ...
    3*strcmp(stringSpecialty,'Emergency') + ...
    4*strcmp(stringSpecialty,'General Practice') + ...
    5*strcmp(stringSpecialty,'Internal') + ...
    6*strcmp(stringSpecialty,'Laboratory') + ...
    7*strcmp(stringSpecialty,'Obstetrics and Gynecology') + ...
    8*strcmp(stringSpecialty,'Pathology') + ...
    9*strcmp(stringSpecialty,'Pediatrics') + ...
    10*strcmp(stringSpecialty,'Rehabilitation') + ...
    11*strcmp(stringSpecialty,'Surgery') + ...
    12*strcmp(stringSpecialty,'Other') + ...
    13*strcmp(stringSpecialty,'');
stringPlace = C{2}(members_i,3);
claims.place = 1*strcmp(stringPlace,'') + ...
    2*strcmp(stringPlace,'Ambulance') + ...
    3*strcmp(stringPlace,'Home') + ...
    4*strcmp(stringPlace,'Inpatient Hospital') + ...
    5*strcmp(stringPlace,'Independent Lab') + ...
    6*strcmp(stringPlace,'Office') + ...
    7*strcmp(stringPlace,'Outpatient Hospital') + ...
    8*strcmp(stringPlace,'Urgent Care') + ...
    9*strcmp(stringPlace,'Other');
claims.payDelay = str2double(C{2}(members_i,4));
claims.payDelay(isnan(claims.payDelay)) = 162; % for replacing 162+ with 162
claims.LoS = str2double(C{2}(members_i,5));
%TODO will have to change this 27 if we treat LoS as a continuous variable
claims.LoS(find(C{3}==0)) = 27;
claims.LoS(isnan(claims.LoS)) = 26; % for replacing 26+ with 26
claims.DSFS = parseMonthCounts(C{2}(members_i,6));
stringCondGroup = C{2}(members_i,7);
claims.condGroup = parseConditionGroup(stringCondGroup);
stringCharlson = C{2}(members_i,8);
claims.charlson = 1*strcmp(stringCharlson,'0') + ...
    2*strcmp(stringCharlson,'1-2') + ...
    3*strcmp(stringCharlson,'2-3') + ...
    4*strcmp(stringCharlson,'3-4') + ...
    5*strcmp(stringCharlson,'5+');
stringProcGroup = C{2}(members_i,9);
claims.procedure = parseProcedureGroups(stringProcGroup);

%check that parsing went as planned
'Errors?'
length(find(claims.year==0))
length(find(claims.specialty==0))
length(find(claims.place==0))
sum(claims.LoS==0)
length(find(claims.DSFS==0))
length(find(claims.condGroup==0))
length(find(claims.charlson==0))
length(find(claims.procedure==0))
checkArray(claims.year,1:SIZE.YEAR)

% Split claims into years
y1 = find(claims.year==1);
y2 = find(claims.year==2);
y3 = find(claims.year==3);
claims.y1 = getClaimsForYear(claims,y1);
claims.y2 = getClaimsForYear(claims,y2);
claims.y3 = getClaimsForYear(claims,y3);
% Calculate features for each year
claims.f2 = getFeaturesForYear(claims.y1,members.yr2,claims.y1.members);
claims.f3 = getFeaturesForYear(claims.y2,members.yr3,claims.y2.members);
claims.f4 = getFeaturesForYear(claims.y3,target.memberids,claims.y3.members);
save('claims.mat','claims');
end
function claimsForYear = getClaimsForYear(claims,yr)
claimsForYear.members = claims.members(yr);
claimsForYear.provider = claims.provider(yr);
claimsForYear.vendor = claims.vendor(yr);
claimsForYear.pcp = claims.pcp(yr);
claimsForYear.year = claims.year(yr);
claimsForYear.specialty = claims.specialty(yr);
claimsForYear.place = claims.place(yr);
claimsForYear.payDelay = claims.payDelay(yr);
claimsForYear.LoS = claims.LoS(yr);
claimsForYear.DSFS = claims.DSFS(yr);
claimsForYear.condGroup = claims.condGroup(yr);
claimsForYear.charlson = claims.charlson(yr);
claimsForYear.procedure = claims.procedure(yr);
end
function featuresForYear = getFeaturesForYear(claimsForYear,target_members,year_members)
constants
%featuresForYear.members = formFeaturesMatrix(claimsForYear.members,SIZE.,target_members,year_members);
%featuresForYear.provider = formFeaturesMatrix(claimsForYear.provider,SIZE.,target_members,year_members);
%featuresForYear.vendor = formFeaturesMatrix(claimsForYear.vendor,SIZE.,target_members,year_members);
%featuresForYear.pcp = formFeaturesMatrix(claimsForYear.pcp,SIZE.,target_members,year_members);
%featuresForYear.year = formFeaturesMatrix(claimsForYear.year,SIZE.YEAR,target_members,year_members);
featuresForYear.specialty = formFeaturesMatrix(claimsForYear.specialty,SIZE.SPECIALTY,target_members,year_members);
featuresForYear.place = formFeaturesMatrix(claimsForYear.place,SIZE.PLACE,target_members,year_members);
featuresForYear.payDelay = formFeaturesMatrix(claimsForYear.payDelay,SIZE.PAY_DELAY,target_members,year_members);
featuresForYear.LoS = formFeaturesMatrix(claimsForYear.LoS,SIZE.LoS,target_members,year_members);
%featuresForYear.DSFS = formFeaturesMatrix(claimsForYear.DSFS,SIZE.DSFS,target_members,year_members);
featuresForYear.condGroup = formFeaturesMatrix(claimsForYear.condGroup,SIZE.COND_GROUP,target_members,year_members);
featuresForYear.charlson = formFeaturesMatrix(claimsForYear.charlson,SIZE.CHARLSON,target_members,year_members);
featuresForYear.procedure = formFeaturesMatrix(claimsForYear.procedure,SIZE.PROCEDURE,target_members,year_members);
end