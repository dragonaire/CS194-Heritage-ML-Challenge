function [] = writeTarget(filename,target_params)
% writes predicted DIH as .csv to target filename (i.e. 'Target_1.csv')
size(target_params.memberids_orig_order)
size(target_params.claimsTrunc_orig_order)
size(target_params.DIH)
T = [target_params.memberids_orig_order,target_params.claimsTrunc_orig_order,target_params.DIH];
fid = fopen(filename,'w');
fprintf(fid,'MemberID,ClaimsTruncated,DaysInHospital\n');
fprintf(fid,'%d,%d,%f\n',T);
fclose(fid);
end