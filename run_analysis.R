library(stringi)
library(dplyr)

# Download zip file if it hasn't been downloaded
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fileName <- "UCI HAR Dataset.zip"
if (!file.exists(fileName)) {
  download.file(fileUrl, fileName, mode = "wb")
}

# Unzip zip file to directory if directory doesn't exist
dataPath <- "UCI HAR Dataset"
if (!file.exists(dataPath)) {
  unzip(fileName)
}

# Read activity labels and assign coloumn names 
activities <- read.table(file.path(dataPath, "activity_labels.txt"))
activities[,2] <- as.character(activities[,2])  
colnames(activities) <- c("activityID","activityLabels")

# Read features data
features <- read.table(file.path(dataPath, "features.txt"))
features[,2] <- as.character(features[,2])

# Read training data sets
trainSubjects <- read.table(file.path(dataPath, "train", "subject_train.txt"))
trainValues <- read.table(file.path(dataPath, "train", "X_train.txt"))
trainActivities <- read.table(file.path(dataPath, "train", "y_train.txt"))

# Read test data sets
testSubjects <- read.table(file.path(dataPath, "test", "subject_test.txt"))
testValues <- read.table(file.path(dataPath, "test", "X_test.txt"))
testActivities <- read.table(file.path(dataPath, "test", "y_test.txt"))

# STEP 1 : Merges the training and the test sets to create one data set.
TidyData <- rbind(
  cbind(trainSubjects, trainValues, trainActivities),
  cbind(testSubjects, testValues, testActivities)
)
# Assign coloumn names for merged data sets
colnames(TidyData) <- c("subject", features[,2], "activity")


# STEP 2 : Extracts only the measurements on the mean and standard deviation for each measurement. 
# Match coloumn names in data set containing mean $ standard deviation 
stdmean <- grepl("subject|activity|mean|std", colnames(TidyData))
TidyData <- TidyData[,stdmean]


# STEP 3 : Uses descriptive activity names to name the activities in the data set
# Replace activity values with named factor levels
TidyData$activity <- factor(TidyData$activity, levels = activities[,1], labels = activities[,2])

  
# Step 4 : Appropriately labels the data set with descriptive variable names. 
# Get coloumn names
coloumn <- colnames(TidyData)
defLabel <- c("^t", "^f", "Acc", "Gyro", "Mag", "Freq", "mean", "std", "BodyBody", "[\\(\\)-]")
trueLabel <- c("timeDomain", "frequencyDomain", "Accelerometer", "Gyroscope", "Magnitude", "Frequency", "Mean", "StandardDeviation", "Body", "")
# replace inappropriate labels with descriptive variable using stri_replace_all_regex function in stringi package
coloumn <- stri_replace_all_regex(coloumn, defLabel, trueLabel, F, list(case_insensitive = TRUE))
# Use new labels as coloumn names
colnames(TidyData) <- coloumn


# STEP 5 : From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
TidyDataMeans <- TidyData %>% 
  group_by(subject, activity) %>%
  summarise_all(funs(mean))


# file output : tidy_data.txt
write.table(TidyDataMeans, "tidy_data.txt", row.names = FALSE, 
            quote = FALSE)