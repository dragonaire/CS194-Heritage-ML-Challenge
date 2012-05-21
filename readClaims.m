function [ claims ] = readClaims(target,members)
try
    load('claims.mat');
    return;
catch
    disp('Claims were not cached! This could take a few minutes.');
end
constants;
try
    load('claims_mid.mat');
catch
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
    claims_year = 1*strcmp(stringYear, 'Y1') + 2*strcmp(stringYear, 'Y2') + ...
        3*strcmp(stringYear, 'Y3');
    clear stringYear;
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
    clear stringSpecialty;
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
    clear stringPlace;
    claims.payDelay = str2double(C{2}(members_i,4));
    claims.payDelay(isnan(claims.payDelay)) = 162; % for replacing 162+ with 162
    stringLoS = C{2}(members_i,5);
    claims.LoS = 1*strcmp(stringLoS,'1 day') + ...
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
    clear stringLoS;
    claims.LoS(C{3}(members_i)==1) = 14;
    claims.DSFS = parseMonthCounts(C{2}(members_i,6));
    stringCondGroup = C{2}(members_i,7);
    claims.condGroup = parseConditionGroup(stringCondGroup);
    stringCharlson = C{2}(members_i,8);
    claims.charlson = 1*strcmp(stringCharlson,'0') + ...
        2*strcmp(stringCharlson,'1-2') + ...
        3*strcmp(stringCharlson,'2-3') + ...
        4*strcmp(stringCharlson,'3-4') + ...
        5*strcmp(stringCharlson,'5+');
    clear stringCharlson;
    stringProcGroup = C{2}(members_i,9);
    claims.procedure = parseProcedureGroups(stringProcGroup);
    clear stringProcGroup;
    save('claims_mid.mat','claims','claims_year');
end
try 
    load('cache/unique.mat');
catch
    provider = makeUnique(claims.provider,SIZE.PROVIDER);
    vendor = makeUnique(claims.vendor,SIZE.VENDOR);
    pcp = makeUnique(claims.pcp,SIZE.PCP);
    save('cache/unique.mat','provider','vendor','pcp');
end
claims.provider = provider; clear provider;
claims.vendor = vendor; clear vendor;
claims.pcp = pcp; clear pcp;

%check that parsing went as planned
'Errors?'
length(find(claims_year==0))
length(find(claims.specialty==0))
length(find(claims.place==0))
sum(claims.LoS==0)
length(find(claims.DSFS==0))
length(find(claims.condGroup==0))
length(find(claims.charlson==0))
length(find(claims.procedure==0))
checkArray(claims_year,1:SIZE.YEAR)

% Split claims into years and 
% Calculate features for each year
disp('Making new features year 1');
y1 = find(claims_year==1);
claims_y1 = getClaimsForYear(claims,y1);
clear y1;
claims.f2 = getFeaturesForYear(claims_y1,members.yr2,claims_y1.members);
clear claims_y1;

disp('Making new features year 2');
y2 = find(claims_year==2);
claims_y2 = getClaimsForYear(claims,y2);
clear y2;
claims.f3 = getFeaturesForYear(claims_y2,members.yr3,claims_y2.members);
clear claims_y2;

disp('Making new features year 3');
y3 = find(claims_year==3);
claims_y3 = getClaimsForYear(claims,y3);
clear y3;
claims.f4 = getFeaturesForYear(claims_y3,target.memberids,claims_y3.members);
clear claims_y3;
claims.year = claims_year;

% add some extra LoS features
days = [1;2;3;4;5;6;10;21;42;70;133;200];
claims.f2.extraLoS = getExtraFeatures(claims.f2.LoS,days,2);
claims.f3.extraLoS = getExtraFeatures(claims.f3.LoS,days,2);
claims.f4.extraLoS = getExtraFeatures(claims.f4.LoS,days,2);
save('claims.mat','claims');
end
function claimsForYear = getClaimsForYear(claims,yr)
claimsForYear.members = claims.members(yr);
claimsForYear.provider = claims.provider(yr);
claimsForYear.vendor = claims.vendor(yr);
claimsForYear.pcp = claims.pcp(yr);
%claimsForYear.year = claims.year(yr);
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
featuresForYear.nproviders = countUnique(claimsForYear.provider,SIZE.PROVIDER,target_members,year_members);
featuresForYear.nvendors = countUnique(claimsForYear.vendor,SIZE.VENDOR,target_members,year_members);
featuresForYear.npcps = countUnique(claimsForYear.pcp,SIZE.PCP,target_members,year_members);
%featuresForYear.members = formFeaturesMatrix(claimsForYear.members,SIZE.,target_members,year_members);
%featuresForYear.provider = formFeaturesMatrix(claimsForYear.provider,SIZE.,target_members,year_members);
%featuresForYear.vendor = formFeaturesMatrix(claimsForYear.vendor,SIZE.,target_members,year_members);
%featuresForYear.pcp = formFeaturesMatrix(claimsForYear.pcp,SIZE.,target_members,year_members);
%featuresForYear.year = formFeaturesMatrix(claimsForYear.year,SIZE.YEAR,target_members,year_members);
featuresForYear.specialty = formFeaturesMatrix(claimsForYear.specialty,SIZE.SPECIALTY,target_members,year_members);
featuresForYear.place = formFeaturesMatrix(claimsForYear.place,SIZE.PLACE,target_members,year_members);
featuresForYear.payDelay = formFeaturesMatrix(claimsForYear.payDelay,SIZE.PAY_DELAY,target_members,year_members);
featuresForYear.LoS = formFeaturesMatrix(claimsForYear.LoS,SIZE.LoS,target_members,year_members);
featuresForYear.DSFS = formFeaturesMatrix(claimsForYear.DSFS,SIZE.DSFS,target_members,year_members);
featuresForYear.condGroup = formFeaturesMatrix(claimsForYear.condGroup,SIZE.COND_GROUP,target_members,year_members);
featuresForYear.charlson = formFeaturesMatrix(claimsForYear.charlson,SIZE.CHARLSON,target_members,year_members);
featuresForYear.procedure = formFeaturesMatrix(claimsForYear.procedure,SIZE.PROCEDURE,target_members,year_members);
featuresForYear.n = full(sum(featuresForYear.place,2)); % chose place because it has smallest dimension
%{
condSpec = claimsForYear.condGroup + SIZE.COND_GROUP*(claimsForYear.specialty-1);
featuresForYear.condSpec = formFeaturesMatrix(condSpec, SIZE.COND_GROUP*SIZE.SPECIALTY,...
    target_members,year_members);
clear condSpec;
condPlace = claimsForYear.condGroup + SIZE.COND_GROUP*(claimsForYear.place-1);
featuresForYear.condPlace = formFeaturesMatrix(condPlace, SIZE.COND_GROUP*SIZE.PLACE,...
    target_members,year_members);
clear condPlace;
%}
end