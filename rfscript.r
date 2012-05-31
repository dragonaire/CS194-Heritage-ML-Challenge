# Random Forest
# this script is a small forest meant to run in multiple sessions at once

# to run script in R, use:
# source('rfscript.r')

cat('\nRunning Random Forest script...\n')

cat('Enter RF session number: ')
n <- readLines(file("stdin"),1)
fnname <- paste0('RF',n,'.RData')

cat('\nLoading in sql data, setting up RF...\n')
load("sqldb.RData")
x = alldata[trainrows,-targindex]
y = alldata[trainrows,targindex]

library(randomForest)

# meta-parameters
RF_NTREES = 100
RF_NODESIZE = 10
RF_IMPORTANCE = TRUE
RF_PRINTOUT = 10

# run random forests
cat('Running RF with 100 trees...\n')
RF <- randomForest(x, y, 
		 ntree = RF_NTREES,		 
		 nodesize = RF_NODESIZE,
		 importance = RF_IMPORTANCE,
		 do.trace = RF_PRINTOUT)

# save RF object (later, load in all and combine in another session)
#save(list = ls(all=TRUE), file = fnname)
cat('\nSaving RF data...\n')
save(RF, file = fnname)
closeAllConnections()
cat('Saved, finished RF script!\n')


# COMBINING RF OBJECTS 

if(FALSE) {
# combine all (in same session)
load('RF1.RData')
load('RF2.RData')
load('RF3.RData')
load('RF4.RData')
load('RF5.RData')

library(randomForest)
RF_all <- combine(RF1,RF2,RF3,RF4,RF5)
print(RF_all)
save(RF_all, file = 'RF_all.RData')
save(list = c('RF1','RF2','RF3','RF4','RF5'), file = 'RF_1to5.RData')
RF_pred <- predict(object=RF_all, newdata=alldata[scorerows,-targindex])

submission <- cbind(memberid,RF_pred)
colnames(submission) <- c("MemberID","DaysInHospital")
fnname <- "RF500_1.csv"
write.csv(submission, file=fnname, row.names = FALSE)

RF_predfinal <- expm1(RF_pred)
submission2 <- cbind(memberid,RF_predfinal)
colnames(submission2) <- c("MemberID","DaysInHospital")
fnname <- "RF500_2.csv"
write.csv(submission2, file=fnname, row.names = FALSE)

}

# x: a data frame or matrix of predictors
# y: response
# ntree: number of iterations
# mtry: number of variables randomly sampled as candidates at each split
# replace: sampling with or without replacement?
# nodesize: min size of terminal nodes (larger means smaller trees, so less time), default size is 5 for nodesize
# maxnodes: max number of terminal nodes
# importance: calculate importance of predictors?
# localImp: casewise importance measure? true means override importance
# nPerm: number of times the OOB data are permuted per tree for assessing variable importance
