function target = readTarget(members, genders, ages)
fid = fopen('Target.csv','rt');
C = textscan(fid,'%f %f %f','Delimiter',',','CollectOutput',1);
fclose(fid);
target.memberids_orig_order = C{1}(:,1);
[target.memberids, target.memberids_i] = sort(target.memberids_orig_order);
target.claimsTrunc_orig_order = C{1}(:,2);
target.claimsTrunc = target.claimsTrunc_orig_order(target.memberids_i);
target.DIH = C{1}(target.memberids_i,3); %TODO this should be empty

target.genders = extractMemberTraits( members.all, target.memberids, genders.all );
target.ages = extractMemberTraits( members.all, target.memberids, ages.all );
end