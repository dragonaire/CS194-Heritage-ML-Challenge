function postProcess_gbm(filename)
% Example output file from R: 'GBM_demo1.csv'

load members;  % for target

fid = fopen(filename,'rt');
C = textscan(fid,'%f %f','Delimiter',',','CollectOutput',1);
fclose(fid);

members_r = C{1}(:,1);
DIH_r = C{1}(:,2);

[memberids_r, memberids_ri] = sort(members_r);
target.DIH = postProcess(DIH_r);
target.DIH = target.DIH(memberids_ri);
target.DIH(target.memberids_i) = target.DIH;
filename = 'Target_gbm2.csv';
T = [target.memberids_orig_order';target.claimsTrunc_orig_order';target.DIH'];
fid = fopen(filename,'w');
fprintf(fid,'MemberID,ClaimsTruncated,DaysInHospital\n');
fprintf(fid,'%d,%d,%f\n',T);
fclose(fid);