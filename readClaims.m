function [ members,providers,vendors,pcps, ] = readClaims()

fid = fopen('Claims.csv','rt');
% MemberID,ProviderID,Vendor,PCP,Year,Specialty,PlaceSvc,PayDelay,LengthOfStay,
% DSFS,PrimaryConditionGroup,CharlsonIndex,ProcedureGroup,SupLOS
% Note: DSFS is Days Since First Service
C = textscan(fid,'%f %f %f %f %s %s %s %s %s %s %s %s %s %f','Delimiter',',','CollectOutput',1);
fclose(fid);
[members, members_i] = sort(C{1}(:,1));
providers = C{1}(members_i,2);
vendors = C{1}(members_i,3);
pcps = C{1}(members_i,4);
stringYear = C{2}(members_i,1);
years = strcmp(stringYear, 'Y1') + 2*strcmp(stringYear, 'Y2') + ...
    3*strcmp(stringYear, 'Y3');
stringSpecialty = C{2}(members_i,2);
%TODO
string = C{2}(members_i,3);
string = C{2}(members_i,4);
string = C{2}(members_i,5);
string = C{2}(members_i,6);
string = C{2}(members_i,7);
string = C{2}(members_i,8);
string = C{2}(members_i,9);

end

