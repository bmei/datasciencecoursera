# Author: Bing Mei, 11/22/2014

# This R script loads, works with, and cleans data collected from the accelerometers from the Samsung Galaxy S smartphone.
# The data and related description can be found at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# Tasks for this course project include creating a R script named "run_analysis.R" that: 
# 1) merges the training and the test sets to create one data set.
# 2) extracts only the measurements on the mean and standard deviation for each measurement. 
# 3) uses descriptive activity names to name the activities in the data set
# 4) appropriately labels the data set with descriptive variable names. 
# 5) from the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject


setwd("C:\\Bing Files\\Coursera\\Data Science Specialization\\3_Getting and Cleaning Data\\project")

# 0) read data in and do a little pre-processing
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subj_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subj_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

features <- read.table("./UCI HAR Dataset/features.txt")
features <- as.character(features$V2)          # variable names originally read in as factors, so change them to the character type


# 1) merges the training and the test sets to create one data set
# 1-1) combine training and testing data sets
X_all <- rbind(x_train, x_test)
y_all <- rbind(y_train, y_test)
subj_all <- rbind(subj_train, subj_test)


# 2) Extracts only the measurements on the mean and standard deviation for each measurement
selcols <- grep("mean\\(\\)|std\\(\\)", features)       # get the indices of columns with mean() or std() in names
X_selcols <- X_all[, selcols]                           # selected features in X
features_sel <- features[selcols]                       # selected feature names
features_sel <- gsub("\\(\\)", "", features_sel)        # remove "()" in the selected features to make them tidy for use as column names in output file
features_sel <- gsub("-", "_", features_sel)            # replace hyphen's with underscores for the same tidiness reason as above


# 1-2) combine subject, y (activity), and all selected X data and add subject and activity to the very beginning of features
# yes, this is the second part of Part 1), which is deemed to be better to put here
data <- cbind(subj_all, y_all, X_selcols)

features_final <- c("subject", "activity", features_sel)


# 3) set table column headers using features
colnames(data) <- features_final


# 4) use descriptive activity names to replace activity code in the data set
library(plyr)
data$activity <- as.factor(data$activity)
data$activity <- revalue(data$activity, c("1"="WALKING", "2"="WALKING_UPSTAIRS", "3"="WALKING_DOWNSTAIRS", "4"="SITTING", "5"="STANDING", "6"="LAYING"))


# 5) creates a second, independent tidy data set with the average of each variable for each activity and each subject
library(dplyr)
data_grouped <- group_by(data, subject, activity)                # group data based on subject and activity
data_summarized <- summarise_each(data_grouped, funs(mean))      # calculate means for the selected measurements

write.table(data_summarized, "./UCI HAR Dataset/output_tidy_data.txt", row.name=FALSE)   # write results to a text file


# 6) verification - make sue the output data can be read back into R correctly
a <- read.table("./UCI HAR Dataset/output_tidy_data.txt", header=TRUE)
head(a, n=2)
