NUM_TARGETS = 70942;
NUM_TRAINING = 113000;
MIN_PREDICTION = 0.001; %TODO find a better way to choose this constant
MAX_PREDICTION = 14.9; %TODO find a better way to choose this constant

MAXPAYDELAY = 162;
% 1 for male, 2 for female, 0 for no sex
MALE = 1; FEMALE = 2; NOSEX = 3;
NOAGE = 10;

SIZE.SEX = 3;
SIZE.AGE = 10;

MAX_DRUG_COUNT = 7;
MAX_LAB_COUNT = 10;
SIZE.DRUG_1YR = MAX_DRUG_COUNT; % accounts for 7 drug counts over 1 year
SIZE.DRUG_2YRS = 2*MAX_DRUG_COUNT; % accounts for 7 drug counts over 2 years
SIZE.LAB_1YR = MAX_LAB_COUNT; % accounts for 10 lab counts over 1 year
SIZE.LAB_2YRS = 2*MAX_LAB_COUNT; % accounts for 10 lab counts over 2 years

SIZE.YEAR = 3;
SIZE.SPECIALTY = 13;
SIZE.PLACE = 9;
SIZE.PAY_DELAY = 162;
SIZE.LoS = 26;
SIZE.DSFS = 13;
SIZE.COND_GROUP = 46;
SIZE.CHARLSON = 5;
SIZE.PROCEDURE = 18;
%SIZE. = ;