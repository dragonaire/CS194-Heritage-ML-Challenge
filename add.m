function [claims] = add(claims,logDIH,members,target)
try
    load('claims2.mat');
catch
    constants;
    %load('claims.mat');
    % Split claims into years and 
    % Calculate features for each year
    y1 = find(claims.year==1);
    claims_y1 = getClaimsForYear(claims,y1);
    clear y1;
    y2 = find(claims.year==2);
    claims_y2 = getClaimsForYear(claims,y2);
    clear y2;
    y3 = find(claims.year==3);
    claims_y3 = getClaimsForYear(claims,y3);
    clear y3;
    % f2
    [phosp,aveLog,numInClass] = ...
        getProbOfHospitalization(claims_y1.pcp,claims_y1.members,members.comb23,logDIH.comb23,SIZE.PCP);
    [pcp] = addFeatures(claims_y1.pcp,claims_y1.members,phosp,aveLog,numInClass,100,NUM_TRAINING);
    [phosp,aveLog,numInClass] = ...
        getProbOfHospitalization(claims_y1.provider,claims_y1.members,members.comb23,logDIH.comb23,SIZE.PROVIDER);
    [provider] = addFeatures(claims_y1.provider,claims_y1.members,phosp,aveLog,numInClass,250,NUM_TRAINING);
    [phosp,aveLog,numInClass] = ...
        getProbOfHospitalization(claims_y1.vendor,claims_y1.members,members.comb23,logDIH.comb23,SIZE.VENDOR);
    [vendor] = addFeatures(claims_y1.vendor,claims_y1.members,phosp,aveLog,numInClass,200,NUM_TRAINING);
    claims.f2.extraPcpProvVend = extractMemberTraits(members.all,members.yr2,[pcp,provider,vendor]);
    % f3
    [phosp,aveLog,numInClass] = ...
        getProbOfHospitalization(claims_y2.pcp,claims_y2.members,members.comb23,logDIH.comb23,SIZE.PCP);
    [pcp] = addFeatures(claims_y2.pcp,claims_y2.members,phosp,aveLog,numInClass,100,NUM_TRAINING);
    [phosp,aveLog,numInClass] = ...
        getProbOfHospitalization(claims_y2.provider,claims_y2.members,members.comb23,logDIH.comb23,SIZE.PROVIDER);
    [provider] = addFeatures(claims_y2.provider,claims_y2.members,phosp,aveLog,numInClass,250,NUM_TRAINING);
    [phosp,aveLog,numInClass] = ...
        getProbOfHospitalization(claims_y2.vendor,claims_y2.members,members.comb23,logDIH.comb23,SIZE.VENDOR);
    [vendor] = addFeatures(claims_y2.vendor,claims_y2.members,phosp,aveLog,numInClass,200,NUM_TRAINING);
    claims.f3.extraPcpProvVend = extractMemberTraits(members.all,members.yr3,[pcp,provider,vendor]);
    % f4
    [phosp,aveLog,numInClass] = ...
        getProbOfHospitalization(claims_y3.pcp,claims_y3.members,members.comb23,logDIH.comb23,SIZE.PCP);
    [pcp] = addFeatures(claims_y3.pcp,claims_y3.members,phosp,aveLog,numInClass,100,NUM_TRAINING);
    [phosp,aveLog,numInClass] = ...
        getProbOfHospitalization(claims_y3.provider,claims_y3.members,members.comb23,logDIH.comb23,SIZE.PROVIDER);
    [provider] = addFeatures(claims_y3.provider,claims_y3.members,phosp,aveLog,numInClass,250,NUM_TRAINING);
    [phosp,aveLog,numInClass] = ...
        getProbOfHospitalization(claims_y3.vendor,claims_y3.members,members.comb23,logDIH.comb23,SIZE.VENDOR);
    [vendor] = addFeatures(claims_y3.vendor,claims_y3.members,phosp,aveLog,numInClass,200,NUM_TRAINING);
    claims.f4.extraPcpProvVend = extractMemberTraits(members.all,target.memberids,[pcp,provider,vendor]);
    
    clear claims_y1;
    clear claims_y2;
    clear claims_y3;
    save('claims2.mat','claims');
end
end
function [phosp,aveLog,numInClass] = getProbOfHospitalization(f,members,logmems,logDIH,n)
logDIH = augment(logDIH,logmems,unique(members));
% f is a feature like pcp, vendor, or provider for each claim
% members is a list of the members for each claim. Claims are sorted by
% memberid, which are in the range [1,113000].
% n is the number of unique elements in f
members = makeUnique(members,size(unique(members),1),true); % rebucket from 1-113000
m = size(f,1);
[f, fi] = sort(f);
members=members(fi);
hospitalized = (logDIH>0);
numInClass = zeros(n,1);
totalHosp = zeros(n,1); % count of visits to hospital
totalLog = zeros(n,1); % 
j=1;
for i=1:n
    jmin = j;
    while j<=m  && f(j)==i
        j=j+1;
    end
    mem=members(jmin:j-1);
    mem = unique(mem);
    numInClass(i) = length(mem);
    totalHosp(i) = sum(hospitalized(mem));
    totalLog(i) = sum(logDIH(mem));
    if j>m 
        break;
    end
end
% set to 0 since not all pcps, vendors, and providers are represented in
% each year.
phosp = totalHosp./numInClass; phosp(isnan(phosp)) = 0; 
aveLog = totalLog./numInClass; aveLog(isnan(aveLog)) = 0;
if min(numInClass) == 0
    disp('problem in getProbOfHospitalization');
    %keyboard
end
end
function [fout] = addFeatures(f,members,phosp,aveLog,numInClass,thresh,m)
members = makeUnique(members,size(unique(members),1),true); % rebucket from 1-113000
% m is the number of members
sum((numInClass>=thresh))
group = (numInClass<thresh);
numInGroup = sum(numInClass(numInClass<thresh))
phospgroup = phosp.*numInClass; phospgroup=sum(phospgroup(numInClass<thresh))/numInGroup
aveLoggroup = aveLog.*numInClass; aveLoggroup=sum(aveLoggroup(numInClass<thresh))/numInGroup
fout= zeros(m,4); % max,ave,logmax,logave
curmem = 1;
s = 0; t = 0; slog = 0;
for i=1:length(f)
    while members(i)~=curmem
        if t > 0
            fout(curmem,2) = s/t;
            fout(curmem,4) = slog/t;
            s = 0; t = 0; slog = 0;
        end
        curmem = curmem+1;
    end
    if group(f(i))
        fout(curmem,1) = max(fout(curmem,1), phospgroup);
        fout(curmem,3) = max(fout(curmem,3), aveLoggroup);
        s = s+numInGroup*phospgroup;
        t = t+numInGroup;
        slog = slog+numInGroup*aveLoggroup;
    else
        fout(curmem,1) = max(fout(curmem,1), phosp(f(i)));
        fout(curmem,3) = max(fout(curmem,3), aveLog(f(i)));
        s = s+numInClass(f(i))*phosp(f(i));
        t = t+numInClass(f(i));
        slog = slog+numInClass(f(i))*aveLog(f(i));
    end
end
if t > 0
    fout(curmem,2) = s/t;
    fout(curmem,4) = slog/t;
end
end
% adds zeros in the place of missing member data
function [d_] = augment(data,datamems,mems)
d_ = zeros(size(mems));
[c,ia,ib]=intersect(datamems,mems);
d_(ib) = data(ia);
end