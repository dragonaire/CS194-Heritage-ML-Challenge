function [members_struct,genders_struct,ages_struct] = readMembers()
constants;
fid = fopen('Members.csv','rt');
C = textscan(fid,'%f %s %s','Delimiter',',','CollectOutput',1);
[members, member_numbers_i] = sort(C{1});
stringAges = C{2}(member_numbers_i,1);
stringGenders = C{2}(member_numbers_i,2);
genders = MALE*strcmp(stringGenders, 'M') + FEMALE*strcmp(stringGenders, 'F') + ...
    NOSEX*strcmp(stringGenders, '');
fclose(fid);

% There are 10 age buckets with values 1-10. 10 means no age specified.
ages = strcmp(stringAges, '0-9') + 2*strcmp(stringAges, '10-19') + ...
    3*strcmp(stringAges, '20-29') + 4*strcmp(stringAges, '30-39') + ...
    5*strcmp(stringAges, '40-49') + 6*strcmp(stringAges, '50-59') + ...
    7*strcmp(stringAges, '60-69') + 8*strcmp(stringAges, '70-79') + ...
    9*strcmp(stringAges, '80+') + 10*strcmp(stringAges, '');
checkArray(ages,1:SIZE.AGE);

members_struct.all = members;
genders_struct.all = genders;
ages_struct.all = ages;
end