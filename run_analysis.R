# Loading the required library

library(dplyr)
library(data.table)

# Download the dataset if it's not already downloaded and unzip it

fileName <- "getdata_projectfiles_UCI HAR Dataset.zip"
fileURL <-
  "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if (!file.exists(fileName)) {
  download.file(fileURL, fileName)
  unzip(fileName)
}

# Reading the meta data

features <-
  read.table("./UCI HAR Dataset/features.txt", col.names = c("ID", "feature"))
activityLabels <-
  read.table("./UCI HAR Dataset/activity_labels.txt",
             col.names = c("ID", "activity"))

# Reading the training data

subject_train <-
  read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
X_train <-
  read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features$feature)
y_train <-
  read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "ID")

# Reading the test data

subject_test <-
  read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
X_test <-
  read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features$feature)
y_test <-
  read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "ID")

# 1. Merges the training and the test sets to create one data set

subject_data <- bind_rows(subject_train, subject_test)
X_data <- bind_rows(X_train, X_test)
y_data <- bind_rows(y_train, y_test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement

X_mean_std <- select(X_data, matches("mean|std"))

# 3. Uses descriptive activity names to name the activities in the data set
# X_data already has descriptive name

y_data <-
  inner_join(y_data, activityLabels, by = "ID") %>% select(activity)

# 4. Appropriately labels the data set with descriptive variable names

names(X_mean_std) <- names(
  X_mean_std %>%
    rename_with(~ gsub("Acc", "Accelerometer", .x)) %>%
    rename_with(~ gsub("Mag", "Magnitude", .x)) %>%
    rename_with(~ gsub("Gyro", "Gyroscope", .x)) %>%
    rename_with(~ gsub("angle", "Angle", .x)) %>%
    rename_with(~ gsub("gravity", "Gravity", .x)) %>%
    rename_with(~ gsub("BodyBody", "Body", .x)) %>%
    rename_with(~ gsub("^t", "Time", .x)) %>%
    rename_with(~ gsub("\\.t", ".Time", .x)) %>%
    rename_with(~ gsub("^f|Freq", "Frequency", .x)) %>%
    rename_with(~ gsub("\\.$|\\.\\.$", "", .x))
)

# 5. From the data set in step 4, creates a second, independent tidy data set
#    with the average of each variable for each activity and each subject

allData <- bind_cols(X_mean_std, y_data, subject_data)

tidyData <-
  allData %>% group_by(activity, subject) %>% summarise(across(.fns = mean))

# download csv & text file of tidy data

write.csv(tidyData, "./tidyData.csv", row.names = FALSE)
write.table(tidyData, "./tidyData.txt", row.names = FALSE)
