function [ pred ] = readPredictions( name )
fid = fopen(name,'rt');
C = textscan(fid,'%f %f %f','Delimiter',',','CollectOutput',1,'headerLines',1);
fclose(fid);
memberids_orig_order = C{1}(:,1);
[memberids, memberids_i] = sort(memberids_orig_order);
pred = C{1}(memberids_i,3);
end

