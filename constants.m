NUM_TARGETS = 70942;
NUM_TRAINING = 113000;
MIN_PREDICTION = 0;
MAX_PREDICTION = 15;

MAXPAYDELAY = 162;
% 1 for male, 2 for female, 0 for no sex
MALE = 1; FEMALE = 2; NOSEX = 3;
NOAGE = 10;

BUCKET_RANGES.SEX = 1:3;
BUCKET_RANGES.AGE = 1:10;

BUCKET_RANGES.DRUG_1YR = 1:7; % accounts for 7 drug counts over 1 year
BUCKET_RANGES.DRUG_2YRS = 1:14; % accounts for 7 drug counts over 2 years

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