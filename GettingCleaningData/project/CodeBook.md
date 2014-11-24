## Course Project

### Getting and Cleaning Smartphone Data for Human Activity Recognition Study

NOTE: Much content from here was taken from [1] and [2]


### Background

One of the most exciting areas in all of data science right now is wearable computing. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. Reyes-Ortiz, Anguita, Ghio, and Oneto from the Smartlab Non Linear Complex Systems Laboratory in Genoa, Italy did some experiments to collect data from the accelerometers from the Samsung Galaxy S smartphone for human activity recognition study. The experiments were carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, they captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments were video-recorded to label the data manually.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.


### Data Files

The aforementioned data set archive can be downloaded from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The dataset was randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The source files we use to create the tidy data set from the extrated data archive are:
*  `features_info.txt`: Shows information about the variables used on the feature vector.
*  `features.txt`: List of all features.
*  `activity_labels.txt`: Links the class labels with their activity name.
*  `train/X_train.txt`: Training set.
*  `train/y_train.txt`: Training labels.
*  `test/X_test.txt`: Test set.
*  `test/y_test.txt`: Test labels.
*  `train/subject_train.txt`: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
*  `test/subject_test.txt`: The same as above but for test


#### Feature Selection in Source Data Files

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern: '-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

* mean(): Mean value
* std(): Standard deviation
* mad(): Median absolute deviation 
* max(): Largest value in array
* min(): Smallest value in array
* sma(): Signal magnitude area
* energy(): Energy measure. Sum of the squares divided by the number of values. 
* iqr(): Interquartile range 
* entropy(): Signal entropy
* arCoeff(): Autorregresion coefficients with Burg order equal to 4
* correlation(): correlation coefficient between two signals
* maxInds(): index of the frequency component with largest magnitude
* meanFreq(): Weighted average of the frequency components to obtain a mean frequency
* skewness(): skewness of the frequency domain signal 
* kurtosis(): kurtosis of the frequency domain signal 
* bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
* angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

* gravityMean
* tBodyAccMean
* tBodyAccJerkMean
* tBodyGyroMean
* tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'


#### Variables in Cleaned Output Dataset

Variables within the tidy data set are as examined as follows (taken from [1]).

The first variable, subject, indicates who carried out the experiment and is represented as a number from 1 to 30.

The second variable, activity, indicates what the subject did and contains values of WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING

The rest are features selected for the output tidy dataset, which include the mean and standard deviations for each measurement. Eventually, 66 measurments were selected, as shown below, and the means of these measurements were calculated and written to the output data file named output_tidy_data.txt.

tBodyAcc_mean_X, tBodyAcc_mean_Y, tBodyAcc_mean_Z, tBodyAcc_std_X, tBodyAcc_std_Y, tBodyAcc_std_Z, tGravityAcc_mean_X, tGravityAcc_mean_Y, tGravityAcc_mean_Z, tGravityAcc_std_X, tGravityAcc_std_Y, tGravityAcc_std_Z, tBodyAccJerk_mean_X, tBodyAccJerk_mean_Y, tBodyAccJerk_mean_Z, tBodyAccJerk_std_X, tBodyAccJerk_std_Y, tBodyAccJerk_std_Z, tBodyGyro_mean_X, tBodyGyro_mean_Y, tBodyGyro_mean_Z, tBodyGyro_std_X, tBodyGyro_std_Y, tBodyGyro_std_Z, tBodyGyroJerk_mean_X, tBodyGyroJerk_mean_Y, tBodyGyroJerk_mean_Z, tBodyGyroJerk_std_X, tBodyGyroJerk_std_Y, tBodyGyroJerk_std_Z, tBodyAccMag_mean, tBodyAccMag_std, tGravityAccMag_mean, tGravityAccMag_std, tBodyAccJerkMag_mean, tBodyAccJerkMag_std, tBodyGyroMag_mean, tBodyGyroMag_std, tBodyGyroJerkMag_mean, tBodyGyroJerkMag_std, fBodyAcc_mean_X, fBodyAcc_mean_Y, fBodyAcc_mean_Z, fBodyAcc_std_X, fBodyAcc_std_Y, fBodyAcc_std_Z, fBodyAccJerk_mean_X, fBodyAccJerk_mean_Y, fBodyAccJerk_mean_Z, fBodyAccJerk_std_X, fBodyAccJerk_std_Y, fBodyAccJerk_std_Z, fBodyGyro_mean_X, fBodyGyro_mean_Y, fBodyGyro_mean_Z, fBodyGyro_std_X, fBodyGyro_std_Y, fBodyGyro_std_Z, fBodyAccMag_mean, fBodyAccMag_std, fBodyBodyAccJerkMag_mean, fBodyBodyAccJerkMag_std, fBodyBodyGyroMag_mean, fBodyBodyGyroMag_std, fBodyBodyGyroJerkMag_mean, fBodyBodyGyroJerkMag_std


### Procedure of Data Processing

1) The training and test data sets were combined into one single dataset;

2) 66 features (variables) were extracted on the mean and standard deviation for each measurement;

3) Original columns were labeled with more meaningful, descriptive names;

4) Original activity code was replaced with descriptive names too in the output data file;

5) The average of each variable for each activity and each subject was computed; and

6) The results of step 5) were output as an indepenent tidy data file named output_tidy_data.txt.


### Variables in the R Script

* x_train <- stores data from train/X_train.txt file
* y_train <- stores data from train/y_train.txt file
* subj_train <- stores data from train/subject_train.txt file
* x_test <- stores data from test/X_test.txt file
* y_test <- stores data from test/y_test.txt file
* subj_test <- stores data from test/subject_test.txt file
* X_all <- stores combined data from x_train and x_test
* y_all <- stores combined data from y_train and y_test
* subj_all <- stores combined data from subj_train and subj_test
* features <- stores data from features.txt file
* selcols <- stores the indices of features with mean() or std() in names
* features_sel <- stores selected features/measurements
* features_final <- stores features_sel plus subject and activity
* X_selcols <- selectd X data with only selected geatures/measurements included
* data <- stores the final processed data for analysis, which combines subj_all, y_all, and X_selcols
* data_grouped <- store the final processed data grouped based on subject and activity
* data_summarized <- stores means for the selected measurements


### References
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012 http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

[2] http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
