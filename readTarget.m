fid = fopen('Target.csv','rt');
C = textscan(fid,'%f %f %f','Delimiter',',','CollectOutput',1);
fclose(fid);
target_memberids_orig_order = C{1}(:,1);
[target_memberids, target_memberids_i] = sort(target_memberids_orig_order);
target_claimsTrunc_orig_order = C{1}(:,2);
target_claimsTrunc = target_claimsTrunc_orig_order(target_memberids_i);
target_DIH = C{1}(target_memberids_i,3);

target_genders = extractMemberTraits( members, target_memberids, genders );
target_ages = extractMemberTraits( members, target_memberids, ages );
