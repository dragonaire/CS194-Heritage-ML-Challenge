# random forests

load("sqldb.RData")

# meta-parameters
RF_NTREES =
RF_MTRY =
RF_REPLACE =
RF_NODESIZE =
RF_MAXNODES =
RF_IMPORTANCE =

# run random forests

library(randomForest)
randomForest(x, y = NUL, xtest = NULL, ytest = NULL,
		ntree = 500, maxnodes = NULL,
		importance = FALSE, localImp = FALSE, nPerm = 1,
		proximity, oob.prox = proximity,
		norm.votes = TRUE, do.trace = FALSE,
		corr.bias = FALSE, keep.inbag = FALSE)

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
