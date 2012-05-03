NUM_TARGETS = 70942;
NUM_TRAINING = 113000;
MIN_PREDICTION = 0.001; %TODO find a better way to choose this constant
MAX_PREDICTION = 14.9; %TODO find a better way to choose this constant

MAXPAYDELAY = 162;
% 1 for male, 2 for female, 0 for no sex
MALE = 1; FEMALE = 2; NOSEX = 3;
NOAGE = 10;

BUCKET_RANGES.SEX = 1:3;
BUCKET_RANGES.AGE = 1:10;

MAX_DRUG_COUNT = 7;
MAX_LAB_COUNT = 10;
BUCKET_RANGES.DRUG_1YR = 1:MAX_DRUG_COUNT; % accounts for 7 drug counts over 1 year
BUCKET_RANGES.DRUG_2YRS = 1:2*MAX_DRUG_COUNT; % accounts for 7 drug counts over 2 years
BUCKET_RANGES.LAB_1YR = 1:MAX_LAB_COUNT; % accounts for 10 lab counts over 1 year
BUCKET_RANGES.LAB_2YRS = 1:2*MAX_LAB_COUNT; % accounts for 10 lab counts over 2 years

BUCKET_RANGES.YEAR = 1:3;
BUCKET_RANGES.SPECIALTY = 1:13;
BUCKET_RANGES.PLACE = 1:9;
BUCKET_RANGES.PAY_DELAY = 1:162;
BUCKET_RANGES.LoS = -1:26;
BUCKET_RANGES.DSFS = 1:13;
BUCKET_RANGES.COND_GROUP = 1:46;
BUCKET_RANGES.CHARLSON = 1:5;
BUCKET_RANGES.PROCEDURE = 1:18;
%BUCKET_RANGES. = 1:;