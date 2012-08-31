NUM_TARGETS = 70942;
NUM_TRAINING = 113000;
MIN_PREDICTION_L = 0.054; %For log space. Taken from Market Makers milestone 1
MAX_PREDICTION_L = log(15+1)/2; %TODO find a better way to choose this constant
MIN_PREDICTION = exp(MIN_PREDICTION_L)-1;
MAX_PREDICTION = exp(MAX_PREDICTION_L)-1; %==4; %TODO find a better way to choose this constant

LEADERBOARD_OPT_CONST = log(0.209179 + 1);
LEADERBOARD_VAR = (0.486459)^2;

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
SIZE.LoS = 14;
SIZE.DSFS = 13;
SIZE.COND_GROUP = 46;
SIZE.CHARLSON = 5;
SIZE.PROCEDURE = 18;
SIZE.CLAIMS_TRUNC = 1;
SIZE.NCLAIMS = 1;
SIZE.PROVIDER = 14700;
SIZE.VENDOR = 6388;
SIZE.PCP = 1360;
SIZE.EXTRA = 7;
SIZE.EXTRADSFS = 5;
SIZE.EXTRACHARLSON = 5;
SIZE.EXTRAPROB = 12;
SIZE.EXTRACG = 3;

MANY1_NUMPC = 130;
MANY2_NUMPC = 120;
CATVEC_TERMINATE_THRESH = 0.01;
