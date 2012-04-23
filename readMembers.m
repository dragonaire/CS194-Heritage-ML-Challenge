fid = fopen('Members.csv','rt');
C = textscan(fid,'%f %s %s','Delimiter',',','CollectOutput',1);
[members, member_numbers_i] = sort(C{1});
stringAges = C{2}(member_numbers_i,1);
stringGenders = C{2}(member_numbers_i,2);
% 1 for male, 2 for female, 0 for no sex
MALE = 1; FEMALE = 2; NOSEX = 0;
genders = MALE*strcmp(stringGenders, 'M') + FEMALE*strcmp(stringGenders, 'F');
fclose(fid);
malei = (genders==1);
femalei = (genders==2);
nosexi = (genders==0);

ages = parseAges(stringAges);