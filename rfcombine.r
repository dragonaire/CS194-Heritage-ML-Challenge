# Random Forest
# this script is meant to combine many small RFs into one suitable for predictions

# to run script in R, use:
# source('rfcombine.r')

cat('\nRunning Random Forest combine and predict script...\n')

cat('\nLoading in sql data and RF objects...\n')
load("sqldb.RData")

# load individual RF objects generated from 'rfscript.r'
nobj = 10
for(i in 1:nobj) {
    fnname <- paste0('RF',i,'.RData')
    load(fnname)
}

if(FALSE) {
load('RF1.RData')  # RF1 <- RF
load('RF2.RData')  # RF2 <- RF
load('RF3.RData')  # RF3 <- RF
load('RF4.RData')  # RF4 <- RF
load('RF5.RData')  # RF5 <- RF
}

# load RF lib and combine, print, save, predict, and write to csv
cat('\nCombine RFs, print, save, predict...\n')
library(randomForest)
RF_all <- combine(RF1,RF2,RF3,RF4,RF5,RF6,RF7,RF8,RF9,RF10)
print(RF_all)
save(RF_all, file = 'RF_all.RData')
#save(list = c('RF1','RF2','RF3','RF4','RF5'), file = 'RF_1to5.RData')
RF_pred <- predict(object=RF_all, newdata=alldata[scorerows,-targindex])

cat('\nSaving RF logDIH prediction...\n')
submission <- cbind(memberid,RF_pred)
colnames(submission) <- c('MemberID','DaysInHospital')
fnname <- 'RF1000_all_logDIH.csv'
write.csv(submission, file = fnname, row.names = FALSE)
cat('Saved')

cat('\nSaving RF DIH prediction...\n')
RF_predfinal <- expm1(RF_pred)
submission2 <- cbind(memberid,RF_predfinal)
colnames(submission2) <- c('MemberID','DaysInHospital')
fnname <- 'RF1000_all_DIH.csv'
write.csv(submission2, file = fnname, row.names = FALSE)
cat('nSaved\n')

closeAllConnections()

cat('\nFinished RF combine script!\n')
