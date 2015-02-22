Practical Machine Learning: Project
========================================================
## Predicting How Well Activities are Performed using Accelerometer Data

*Bing Mei*

*Feb. 20, 2015*

<br>

### Background

Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data about personal activity relatively inexpensively. Human activity recognition research has traditionally focused on discriminating between different activities, but it rarely quantifies how well these activities are done.

In this project, the goal will be to use data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants to predict "how (well)" an activity was performed by the wearer. Six young health participants were asked to perform one set of 10 repetitions of the Unilateral Dumbbell Biceps Curl in five different fashions: exactly according to the specification (Class A), throwing the elbows to the front (Class B), lifting the dumbbell only halfway (Class C), lowering the dumbbell only halfway (Class D) and throwing the hips to the front (Class E). Class A corresponds to the specified execution of the exercise, while the other 4 classes correspond to common mistakes.

More information is available from the website here: http://groupware.les.inf.puc-rio.br/har (see the section on the Weight Lifting Exercise Dataset).

### Data Processing



```r
library(caret)
library(knitr)
set.seed(12345)
```

##### 1. Loading data

```r
# load data
training <- read.csv("./pml-training.csv", header=TRUE, stringsAsFactors=FALSE, na.strings=c("NA", "", "#DIV/0!"))
testing <- read.csv("./pml-testing.csv", header=TRUE, stringsAsFactors=FALSE, na.strings=c("NA", "", "#DIV/0!"))
```

There are 19622 records in the training dataset and 20 records in the testing dataset. Both sets have 160 columns.

##### 2. Cleaning data

Since the model to be fitted using the `training` data will be applied to the `testing` data, it would be the best to clean the two datasets together in order to ensure consistency between them. Two datasets need to have the same columns before being able to be combined. So add column *problem_id* to the `training` dataset and column *classe* to the `testing` dataset. Values in these two columns are not important as long as they are not NULL or NA.


```r
training$problem_id <- 1 : dim(training)[1]
testing <- cbind(testing[, -dim(testing)[2]], classe = "TBP", problem_id = testing[, dim(testing)[2]])
all_data <- rbind(training, testing)
```

First, remove columns with two many missing values.


```r
NAs <- apply(all_data, 2, function(x) {sum(is.na(x))})
```

By eye-ball checking the values in variable NAs, it was found that a column either has no NA's or has the number of NA's close to the total number of records in the dataset (i.e. more than 19,000 out of 19642, or greater than 96.7%). Therefore, it is decided that if a column has any NA values, it is removed from the dataset.


```r
all_data <- all_data[, which(NAs == 0)]
```

Secondly, remove near-zero variance covariates.  These covariates have only one unique value (i.e. zero variance), or have very few unique values relative to the number of samples, or have a large ratio of the frequency of the most common value to the frequency of the second most common value. These variables will not contriute much prediction power to the model.  The `nearZeroVar()` function has default arguments of freqCut = 95/5 and uniqueCut = 10.


```r
NZVs <- nearZeroVar(all_data, saveMetrics = T)
all_data <- all_data[, !NZVs$nzv]
```

Thirdly, remove the columns that are not predictor variables.


```r
col2rm <- c("X", "user_name", "raw_timestamp_part_1", "raw_timestamp_part_2", "cvtd_timestamp", "num_window", "problem_id")
all_data <- all_data[, -which(colnames(all_data) %in% col2rm)]
```

After data cleaning, the final dataset now has 53 columns, incluidng:


```r
colnames(all_data)
```

```
##  [1] "roll_belt"            "pitch_belt"           "yaw_belt"            
##  [4] "total_accel_belt"     "gyros_belt_x"         "gyros_belt_y"        
##  [7] "gyros_belt_z"         "accel_belt_x"         "accel_belt_y"        
## [10] "accel_belt_z"         "magnet_belt_x"        "magnet_belt_y"       
## [13] "magnet_belt_z"        "roll_arm"             "pitch_arm"           
## [16] "yaw_arm"              "total_accel_arm"      "gyros_arm_x"         
## [19] "gyros_arm_y"          "gyros_arm_z"          "accel_arm_x"         
## [22] "accel_arm_y"          "accel_arm_z"          "magnet_arm_x"        
## [25] "magnet_arm_y"         "magnet_arm_z"         "roll_dumbbell"       
## [28] "pitch_dumbbell"       "yaw_dumbbell"         "total_accel_dumbbell"
## [31] "gyros_dumbbell_x"     "gyros_dumbbell_y"     "gyros_dumbbell_z"    
## [34] "accel_dumbbell_x"     "accel_dumbbell_y"     "accel_dumbbell_z"    
## [37] "magnet_dumbbell_x"    "magnet_dumbbell_y"    "magnet_dumbbell_z"   
## [40] "roll_forearm"         "pitch_forearm"        "yaw_forearm"         
## [43] "total_accel_forearm"  "gyros_forearm_x"      "gyros_forearm_y"     
## [46] "gyros_forearm_z"      "accel_forearm_x"      "accel_forearm_y"     
## [49] "accel_forearm_z"      "magnet_forearm_x"     "magnet_forearm_y"    
## [52] "magnet_forearm_z"     "classe"
```

Finally, after the data cleaned, we need to reconstruct the `training` and `testing` datasets.


```r
training <- all_data[1 : dim(training)[1], ]
testing <- all_data[(1+dim(training)[1]) : (dim(training)[1]+dim(testing)[1]), ]
```

##### 3. Data spliting for training and cross validation

No explicit data spliting is performed to separate the `training` dataset into two, one for training and the other for cross-validation.  Instead, the chosen machine learning techniques from the *caret* package will be instructed to split the data on the fly.  Basically, 5-fold cross validation will be used, as described in the **Model Fitting** section below.

### Model Fitting

Three types of models are attempted in this study, which are random forest, boosting, and SVM. They are among the most popular machine learning algorithms. 5-fold cross validation is specified for the model training process.


```r
tCtrl <- trainControl(method = "cv", number = 5, verboseIter = TRUE)
```

Since the dependent variable - column *classe* in the `training` dataset is of the *character* type, it needs to be converted to *factors* before model fitting.


```r
training$classe <- as.factor(training$classe)
```

##### 1. Random Forest Model


```r
rfFit <- train(classe ~ ., method = "rf", data = training, trControl = tCtrl)
```

##### 2. Boosting Model


```r
boostFit <- train(classe ~ ., method = "gbm", data = training, trControl = tCtrl)
```

##### 3. SVM Model


```r
svmFit <- train(classe ~ ., method = "svmRadial", data = training, trControl = tCtrl)
```

### Model Comparison and Selection

Accuracies of the three fitted models, based on 5-fold cross validation, are shown in the plots and table below.



```r
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
```

![](pml_project_final_files/figure-html/unnamed-chunk-16-1.png) 


```r
accus = c(round(max(rfFit$results$Accuracy), 4),
          round(max(boostFit$results$Accuracy), 4),
          round(max(svmFit$results$Accuracy), 4))
             
accus.df <- data.frame(Fitted.Model = c("Random Forest", "Boosting (gbm)", "SVM (Radial)"), Accuracy = accus)

kable(accus.df)
```



Fitted.Model      Accuracy
---------------  ---------
Random Forest       0.9944
Boosting (gbm)      0.9624
SVM (Radial)        0.9328

It can be seen from the plots and table that all the three models produce accuracies greater than 0.9, which is very good.  Among the three, the random forest model performs the best, reporting an accuracy of 0.9944.  Therefore, it is chosen for prediction on the `testing` dataset.

#### About Error Rates

This section discusses a little bit on the error rates of the chosen random forest model - `rfFit`. It is expected that the *out-of-sample error rate* should be larger than the *in-sample error rate*. Let's check. The *in-sample error rate* is computed by applying the model to the 5-fold training data, as follows. The confusion table indicates a 0% *in-sample error rate*.


```r
infolds <- c(rfFit$control$index$Fold1, rfFit$control$index$Fold2, rfFit$control$index$Fold3, 
             rfFit$control$index$Fold4, rfFit$control$index$Fold5)
train <- training[infolds, ]
preds_in <- predict(rfFit, train)

confusionMatrix(preds_in, train$classe)$table
```

```
##           Reference
## Prediction     A     B     C     D     E
##          A 22320     0     0     0     0
##          B     0 15188     0     0     0
##          C     0     0 13688     0     0
##          D     0     0     0 12864     0
##          E     0     0     0     0 14428
```

The *out-of-sample error rate* is computed as 1 minus Accuracy on cross validation data, which is 1 - 0.9944 = 0.56%. The *out-of-sample error rate* is indeed larger than the *in-sample error rate*.

### Final Model and Prediction

The random forest model contains 500 trees with 27 variables tried at each split. The top five important predictors in this model are:

```r
imp <- varImp(rfFit)$importance
imp <- data.frame(Predictor = rownames(imp), Importance = imp$Overall)
imp <- imp[order(imp$Importance, decreasing = T), ]
rownames(imp) <- NULL
imp[1:5,]
```

```
##       Predictor Importance
## 1     roll_belt  100.00000
## 2 pitch_forearm   57.47249
## 3      yaw_belt   53.97337
## 4    pitch_belt   43.76373
## 5  roll_forearm   43.59423
```

Now use the fitted random forest model to predict on the `testing` dataset.

```r
pred_rf <- as.character(predict(rfFit, testing))
pred_rf
```

```
##  [1] "B" "A" "B" "A" "A" "E" "D" "B" "A" "A" "B" "C" "B" "A" "E" "E" "A"
## [18] "B" "B" "B"
```

Finally, write out the results to separate files for automated grading later.

```r
# This pml_write_files() function is provided by course instructor
pml_write_files = function(x){
    n = length(x)
    for(i in 1:n){
        filename = paste0("problem_id_", i, ".txt")
        write.table(x[i], file=filename, quote=FALSE, row.names=FALSE, col.names=FALSE)
    }
}

pml_write_files(pred_rf)
```

### Assessment of Predictions

The 20 predictions made above on the `testing` dataset were submitted online for automated grading, and all were found to be correct.  This indicates the model truely performs well.
