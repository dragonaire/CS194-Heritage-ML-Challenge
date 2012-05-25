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
try
    load('cache/claims_mid2.mat');
catch
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
    save('cache/claims_mid2.mat','claims');
end

disp('Adding extra features to claims');
% add some extra DSFS features
days = [0:11]';
claims.f2.extraDSFS = getExtraFeatures(claims.f2.DSFS,days,1);
claims.f3.extraDSFS = getExtraFeatures(claims.f3.DSFS,days,1);
claims.f4.extraDSFS = getExtraFeatures(claims.f4.DSFS,days,1);
% keep the ave,min,max,stddev, and add the range
claims.f2.extraDSFS = ...
    [claims.f2.extraDSFS(:,1:4),claims.f2.extraDSFS(:,3)-claims.f2.extraDSFS(:,2)];
claims.f3.extraDSFS = ...
    [claims.f3.extraDSFS(:,1:4),claims.f3.extraDSFS(:,3)-claims.f3.extraDSFS(:,2)];
claims.f4.extraDSFS = ...
    [claims.f4.extraDSFS(:,1:4),claims.f4.extraDSFS(:,3)-claims.f4.extraDSFS(:,2)];
% add some extra Charlson features
days = [0;1;2;3;5];
claims.f2.extraCharlson = getExtraFeatures(claims.f2.charlson,days,0);
claims.f3.extraCharlson = getExtraFeatures(claims.f3.charlson,days,0);
claims.f4.extraCharlson = getExtraFeatures(claims.f4.charlson,days,0);
% keep the ave,min,max,stddev, and add the range
claims.f2.extraCharlson = [claims.f2.extraCharlson(:,1:4),...
    claims.f2.extraCharlson(:,3)-claims.f2.extraCharlson(:,2)];
claims.f3.extraCharlson = [claims.f3.extraCharlson(:,1:4),...
    claims.f3.extraCharlson(:,3)-claims.f3.extraCharlson(:,2)];
claims.f4.extraCharlson = [claims.f4.extraCharlson(:,1:4),...
    claims.f4.extraCharlson(:,3)-claims.f4.extraCharlson(:,2)];
% add some extra LoS features
days = [1;2;3;4;5;6;10;21;42;70;133;200];
claims.f2.extraLoS = getExtraFeatures(claims.f2.LoS,days,2);
claims.f3.extraLoS = getExtraFeatures(claims.f3.LoS,days,2);
claims.f4.extraLoS = getExtraFeatures(claims.f4.LoS,days,2);
save('claims.mat','claims');
end