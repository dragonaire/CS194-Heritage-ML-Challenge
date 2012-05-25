
########################################
# Example GBM model for HHP
# scores ~ 0.4635 on leaderboard
# which would be 55th position of 510
# as at 9th Sept 2011
#
# Requires the data having been prepared
# using the SQL supplied
#
########################################

starttime <- proc.time()

########################################
#load the data
########################################
library(RODBC)

#set a connection to the database 
conn <- odbcDriverConnect("driver=SQL Server;database=HHP_comp;server=HONG-PC\\HONG;")

#or this method involves setting up a DSN (Data Source Name) called HHP_comp
#conn <- odbcConnect("HHP_comp")

alldata <- sqlQuery(conn,"select * from modelling_set")


########################################
# arrange the data
########################################

#identify train and leaderboard data
trainrows <- which(alldata$trainset == 1)
scorerows <- which(alldata$trainset == 0)

#sanity check the size of each set
length(trainrows)
length(scorerows)

#display the column names
colnames(alldata)

#memberid is required as key for submission set
memberid <- alldata[scorerows,'MemberID_t']

#remove redundant fields
alldata$MemberID_t <- NULL
alldata$YEAR_t <- NULL
alldata$trainset <- NULL

#target - what we are predicting
theTarget <- 'DaysInHospital'

#put the target on the log scale
alldata[trainrows,theTarget] <- log1p(alldata[trainrows,theTarget]) 

#find the position of the target
targindex <-  which(names(alldata)==theTarget)


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
fnname <- "C:\\Users\\hong\\GBM_demo2.csv"
write.csv(submission, file=fnname, row.names = FALSE)

elapsedtime <- proc.time() - starttime
cat("\nFinished\n",elapsedtime)