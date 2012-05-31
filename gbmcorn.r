# load data and run gbm (for cluster)

# to run script in R, use:
# source('gbmcorn.r')

cat('\nRunning Gradient Boosting Machine script...')

cat('\nEnter GBM session number: ')
n <- readLines(file("stdin"),1)

cat('\nEnter number of GBM trees: ')
num_trees <- readLines(file("stdin"),1)
fnbase <- paste0('GBM', num_trees, '_', n,'_')
num_trees <- as.integer(num_trees)

cat('\nLoading in sql data, setting up GBM...\n')
load("sqldb.RData")
x = alldata[trainrows,-targindex]
y = alldata[trainrows,targindex]


########################################
# build the model
########################################

starttime <- proc.time()

#GBM model settings, these can be varied
GBM_NTREES = num_trees
GBM_SHRINKAGE = 0.002
GBM_DEPTH = 7
GBM_MINOBS = 100
GBM_FRAC = 0.9

#build the GBM model
library(gbm)
GBM_model <- gbm.fit(
             x
	    ,y            
	    ,distribution = "gaussian"
            ,n.trees = GBM_NTREES
            ,shrinkage = GBM_SHRINKAGE
            ,interaction.depth = GBM_DEPTH
            ,n.minobsinnode = GBM_MINOBS
	    ,bag.fraction = GBM_FRAC
            ,verbose = TRUE) 

#list variable importance
summary(GBM_model,GBM_NTREES)

#predict for the leaderboard data
GBM_pred <- predict.gbm(
               object = GBM_model
              ,newdata = alldata[scorerows,-targindex]
              ,GBM_NTREES)

#put on correct scale and cap
GBM_pred2 <- expm1(GBM_pred)
#prediction <- pmin(15,prediction)
#prediction <- pmax(0,prediction)

#plot the submission distribution
#hist(GBM_pred, breaks = GBM_NTREES)


########################################
#write the submission to file
########################################

cat('\nSaving GBM logDIH prediction...\n')
submission <- cbind(memberid,GBM_pred)
colnames(submission) <- c('MemberID','DaysInHospital')
fnname <- paste0(fnbase, 'logDIH.csv')
write.csv(submission, file = fnname, row.names = FALSE)
cat('Saved')

cat('\nSaving GBM DIH prediction...\n')
submission2 <- cbind(memberid,GBM_pred2)
colnames(submission2) <- c('MemberID','DaysInHospital')
fnname2 <- paste0(fnbase, 'DIH.csv')
write.csv(submission2, file = fnname2, row.names = FALSE)
cat('Saved')

closeAllConnections()

elapsedtime <- proc.time() - starttime
cat('\nElapsed Time: ', elapsedtime, "\nFinished GBM script!\n")
