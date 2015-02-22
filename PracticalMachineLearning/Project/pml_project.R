setwd("C:\\Bing Files\\Coursera\\Data Science Specialization\\8_Practical Machine Learning\\project")
library(caret)
library(knitr)
set.seed(12345)

## Load Data
training <- read.csv("./pml-training.csv", header=TRUE, stringsAsFactors=FALSE, na.strings=c("NA", "", "#DIV/0!"))
testing <- read.csv("./pml-testing.csv", header=TRUE, stringsAsFactors=FALSE, na.strings=c("NA", "", "#DIV/0!"))

dim(training)
dim(testing)

## Clean Data
# combine training data and testing data for data processing
training$problem_id <- 1 : dim(training)[1]
testing <- cbind(testing[, -dim(testing)[2]], classe = "TBP", problem_id = testing[, dim(testing)[2]])
all_data <- rbind(training, testing)

# remove variables with more than 50% missing values
NAs <- apply(all_data, 2, function(x) {sum(is.na(x))})
NAs    # it was found that a variable either has no NA's or has close to all NA's
#all_data <- all_data[, which(NAs < 0.95*nrow(all_data))]
all_data <- all_data[, which(NAs == 0)]

dim(all_data)

# remove near-zero variance covariate columns
NZVs <- nearZeroVar(all_data, saveMetrics = T)
all_data <- all_data[, !NZVs$nzv]

dim(all_data)

# remove the variables that are not predictors
col2rm <- c("X", "user_name", "raw_timestamp_part_1", "raw_timestamp_part_2", "cvtd_timestamp", "num_window", "problem_id")
all_data <- all_data[, -which(colnames(all_data) %in% col2rm)]

# variables remaining in the final dataset
colnames(all_data)

# split the data back to training and testing datasets
training <- all_data[1 : dim(training)[1], ]
testing <- all_data[(1+dim(training)[1]) : (dim(training)[1]+dim(testing)[1]), ]

## Fit Models

#train_data$classe <- as.factor(train_data$classe)
#rfm <- randomForest(classe ~ ., data = train_data)
#preds <- predict(rfm, valid_data)

rfFit <- train(classe ~ ., method = "rf", data = training, trControl = trainControl(method = "cv", number = 5, allowParallel = TRUE, verboseIter = TRUE))
boostFit <- train(classe ~ ., method = "gbm", data = training, verbose=F, trControl = trainControl(method = "cv", number = 5, allowParallel = TRUE))
svmFit <- train(classe ~ ., method = "svmRadial", data = training, trControl = trainControl(method = "cv", number = 5, allowParallel = TRUE, verboseIter = TRUE))

#rfFit <- readRDS("model_rfFit.rds")
#boostFit <- readRDS("model_boostFit.rds")
#svmFit <- readRDS("model_svmFit.rds")

## Model Comparison and Selection
par(mfrow=c(1, 3))

plot(rfFit$results$mtry, rfFit$results$Accuracy, type = "n", ylim = c(0.7, 1),
     main = "Random Forest", xlab = "Selected Predictors", ylab = "Accuracy (Cross-Validation)")
lines(rfFit$results$mtry, rfFit$results$Accuracy, type="o", col="darkgreen")

plot(boostFit$results$interaction.depth, boostFit$results$Accuracy, type = "n", ylim = c(0.7, 1),
     main = "Boosting", xlab = "Max Tree Depth (w/ 150 iterations)", ylab = "Accuracy (Cross-Validation)")
lines(boostFit$results$interaction.depth[1:3], boostFit$results$Accuracy[7:9], type="o", col="red")

plot(svmFit$results$C, svmFit$results$Accuracy, type = "n", ylim = c(0.7, 1),
     main = "SVM (Radial)", xlab = "Cost", ylab = "Accuracy (Cross-Validation)")
lines(svmFit$results$C, svmFit$results$Accuracy, type="o", col="blue")

#plot(rfFit, ylim = c(0.5, 1))
#plot(boostFit, ylim = c(0.5, 1))
#plot(svmFit, ylim = c(0.5, 1))

accus = c(round(max(rfFit$results$Accuracy), 4),
          round(max(boostFit$results$Accuracy), 4),
          round(max(svmFit$results$Accuracy), 4))

accus.df <- data.frame(Fitted.Model = c("Random Forest", "Boosting (gbm)", "SVM (Radial)"), Accuracy = accus)

kable(accus.df)

## About Error Rates
# in-sample error:
infolds <- c(rfFit$control$index$Fold1, rfFit$control$index$Fold2, rfFit$control$index$Fold3, 
             rfFit$control$index$Fold4, rfFit$control$index$Fold5)
train <- training[infolds, ]
preds_in <- predict(rfFit, train)

confusionMatrix(preds_in, train$classe)$table

# out-of-sample error:
rfFit$finalModel$confusion

## Prediction
# importance of predictors
imp <- varImp(rfFit)$importance
imp <- data.frame(Predictor = rownames(imp), Importance = imp$Overall)
imp <- imp[order(imp$Importance, decreasing = T), ]
rownames(imp) <- NULL
imp[1:5,]

# predict
pred_rf <- as.character(predict(rfFit, testing))
pred_rf

