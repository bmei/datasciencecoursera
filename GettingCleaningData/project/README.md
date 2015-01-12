## Course Project - Getting and Cleaning Data

### Script Author
##### Bing Mei


### Instructions
Save the run_analysis.R script file in your working directory and specify your working directory as the argument for function setwd() on line 14.

After donwloading the data and unzipping it, place the data folder in your working directory. The data folder should use the original given name - "UCI HAR Dataset" and don't change anything in the data folder.

Run the R script from RStudio or R Console.  The script outputs a text data file named "output_tidy_data.txt" in the "UCI HAR Dataset" directory.


### Data Source

This project uses the "Human Activity Recognition Using Smartphones Dataset", which can be downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


### Main Works Performed on the Dataset
1. Merging the training and the test sets to create one data set
2. Extracting only the measurements on the mean and standard deviation for each measurement
3. Using descriptive names for each variable
4. Appropriately labeling the data set with descriptive activity names
5. Creating a second, independent tidy data set with the average of each variable for each activity and each subject


### Script Walkthrough
The run_analysis.R script performs the following steps:
* Reads training data files into respective x_train, y_train, subj_train variables
* Reads test data files into respective x_test, y_test, subj_test variables
* Reads feaure names into the features variable and convert the variable type from factor to character
* Combines the training and test data set rows and place the combined data in respective X_all, y_all, and subj_all variables
* Extracts measurements on mean & standard deviation for each measurement using regular expressions
* Creates a unified data set (data frame) with X_all, y_all, and subj_all merged together
* Labels data columns with descriptive variable/column names by removing special characters in the column names and by replacing hyphen's with underscores in the column names
* Uses descriptive activity names to replace activity code in the data set
* Computes the average of each variable for each activity and each subject
* Writes the results to an indepenent tidy data file named output_tidy_data.txt.

