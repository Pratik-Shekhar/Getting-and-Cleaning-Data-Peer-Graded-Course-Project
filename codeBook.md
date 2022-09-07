Getting and Cleaning Data - peer assessment project

The original data was transformed by

1. Merging the training and the test sets to create one data set.
2. Extracting only the measurements on the mean and standard deviation for each measurement.
3. Using descriptive activity names to name the activities in the data set
4. Appropriately labeling the data set with descriptive activity names.
5. Creating a second, independent tidy data set with the average of each variable for each activity and each subject.

About R script

1. File with R code "run_analysis.R" perform 5 steps in accordance with the assigned task of the project

About variables:

1. X_train, y_train, subject_train, X_test, y_test and subject_test contain the data from the downloaded files.
2. subject_data, X_data and y_data  merge the previous datasets for further analysis.
3. features contains the correct names for the X_data dataset, which are applied to the column names stored in X_data
4. activity_labels contains the correct names for the y_data dataset, which are applied to the column names stored in y_data
