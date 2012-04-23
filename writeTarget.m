fid = fopen('Target_1.csv','w');
fprintf(fid,'MemberID,ClaimsTruncated,DaysInHospital\n');
fprintf(fid,'%d,%d,%f\n',[target_memberids_orig_order';target_claimsTrunc_orig_order';target_DIH']);
fclose(fid);