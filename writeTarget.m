function [] = writeTarget(filename,target)
constants;
if min(target.DIH)<MIN_PREDICTION || max(target.DIH)>MAX_PREDICTION
    sprintf('invalid prediction: %f or %f\n', min(target.DIH), max(target.DIH))
    keyboard
end
% writes predicted DIH as .csv to target filename (i.e. 'Target_1.csv')
T = [target.memberids_orig_order';target.claimsTrunc_orig_order';target.DIH'];
fid = fopen(filename,'w');
fprintf(fid,'MemberID,ClaimsTruncated,DaysInHospital\n');
fprintf(fid,'%d,%d,%f\n',T);
fclose(fid);
end