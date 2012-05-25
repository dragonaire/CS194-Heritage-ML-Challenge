# load data and run gbm (for cluster)

load("sqldb.RData")

########################################
# build the model
########################################

#GBM model settings, these can be varied
GBM_NTREES = 8000
GBM_SHRINKAGE = 0.002
GBM_DEPTH = 7
GBM_MINOBS = 100
GBM_FRAC = 0.9

#build the GBM model
library(gbm)
GBM_model <- gbm.fit(
             x = alldata[trainrows,-targindex]
            ,y = alldata[trainrows,targindex]
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
prediction <- predict.gbm(object = GBM_model
              ,newdata = alldata[scorerows,-targindex]
              ,GBM_NTREES)

#put on correct scale and cap
prediction <- expm1(prediction)
prediction <- pmin(15,prediction)
prediction <- pmax(0,prediction)

#plot the submission distribution
hist(prediction, breaks=8000)


########################################
#write the submission to file
########################################
submission <- cbind(memberid,prediction)
colnames(submission) <- c("MemberID","DaysInHospital")
fnname <- "GBM1.csv"
write.csv(submission, file=fnname, row.names = FALSE)

elapsedtime <- proc.time() - starttime
cat("\nFinished\n",elapsedtime)