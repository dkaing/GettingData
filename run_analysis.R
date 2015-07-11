## Download zip file

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "./data/Project.zip", method = "curl")

## Unzip import datasets

unzip("./data/Project.zip", exdir = "Coursera")
setwd("/Users/davinkaing/Coursera/UCI HAR Dataset")
features <- read.table("features.txt")
setwd("/Users/davinkaing/Coursera/UCI HAR Dataset/test")
X_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")
subject_test <- read.table("subject_test.txt")
setwd("/Users/davinkaing/Coursera/UCI HAR Dataset/train")
subject_train <- read.table("subject_train.txt")
X_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")

## Combining train & test datasets

features[,2] <- as.character(features[,2])
colnames(X_test) <- features[,2]
colnames(subject_test) <- "subject"
colnames(y_test) <- "activity_label"
newdata1 <- cbind(subject_test, y_test, X_test)

colnames(X_train) <- features[,2]
colnames(subject_train) <- "subject"
colnames(y_train) <- "activity_label"
newdata2 <- cbind(subject_train, y_train, X_train )

mergeddata <- rbind(newdata1, newdata2)
OrderedMerged <- mergeddata[order(mergeddata$subject),]

## Extract only mean & STD data

ExData <- OrderedMerged[grep("-mean..|-std..|subject|activity_label", colnames(OrderedMerged))]
ExData <- ExData[-grep("-meanFreq..", colnames(ExData))]

colnames(ExData) <- gsub("t", "Time", names(ExData))
colnames(ExData) <- gsub("Acc", "Acceleration", names(ExData))
colnames(ExData) <- gsub("f", "Frequency", names(ExData))
colnames(ExData) <- gsub("sTimed", "STD", names(ExData))
colnames(ExData) <- gsub("Mag", "Magnitude", names(ExData))
colnames(ExData) <- gsub("GraviTimey", "Gravity", names(ExData))
colnames(ExData) <- gsub("subjecTime", "Subject", names(ExData))
colnames(ExData) <- gsub("acTimeiviTimey_label", "ActivityLabel", names(ExData))

## Taking mean of each variable for each activity and subject

Exdata <- group_by(ExData, Subject, ActivityLabel)

TidyData <- aggregate(ExData, list(ExData$Subject, ExData$ActivityLabel), mean)
TidyData <- TidyData[,3:70]

## Using descriptive names to name activities in data set

TidyData[TidyData$ActivityLabel == 1, 2] <- "Walking"
TidyData[TidyData$ActivityLabel == 2, 2] <- "WalkingUpstairs"
TidyData[TidyData$ActivityLabel == 3, 2] <- "WalkingDownstairs"
TidyData[TidyData$ActivityLabel == 4, 2] <- "Sitting"
TidyData[TidyData$ActivityLabel == 5, 2] <- "Standing"
TidyData[TidyData$ActivityLabel == 6, 2] <- "Laying"

## Writing file

write.table(TidyData, file = "TidyData.txt")
