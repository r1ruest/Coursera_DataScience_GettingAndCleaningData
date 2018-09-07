# Peer-graded Assignment: Getting and Cleaning Data Course Project

# You should create one R script called run_analysis.R that does the following.

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

rm(list=ls())

setwd("T://Data_Science/OnlineKurs_Coursera/03_GettingAndCleanindData/UCI HAR Dataset/")

# load datasets
labels <- read.table("activity_labels.txt", col.names = c("Code","activity")) # activity labels
# test
subject_test <- read.table("test/subject_test.txt")
data_test <- read.table("test/X_test.txt")
activity_test <- read.table("test/y_test.txt")
# train
subject_train <- read.table("train/subject_train.txt")
data_train <- read.table("train/X_train.txt")
activity_train <- read.table("train/y_train.txt")
# features
features <- read.table("features.txt", col.names = c("index", "featuresName"))

# 1. Merges the training and the test sets to create one data set. ----
# merge datasets
dat <- rbind(data_train, data_test)
names(dat)
names(dat) <- features[,2] # rename column with features

activity <- rbind(activity_train, activity_test) 
subject <- rbind(subject_train, subject_test)
dat1 <- cbind(activity, dat)
dat1 <- cbind(subject, dat1)
names(dat1)[1:2] <- c("subject", "activity_code")


# 2. Extracts only the measurements on the mean and standard deviation for each measurement. ----
ind <- grep("mean|std", names(dat1))
dat1 <- dat1[,c(1,2,ind)]

# 3. Uses descriptive activity names to name the activities in the data set ----
dat1 <- merge(dat1, labels, by.x = "activity_code", by.y  = "Code")
dat1 <- dat1[,c(2:length(dat1))]



# 4. Appropriately labels the data set with descriptive variable names. 

names(dat1)
names(dat1) <- gsub("\\(|\\)", "", names(dat1)) 
names(dat1) <- gsub("Acc", "Acceleration", names(dat1))
names(dat1) <- gsub("^t", "Time", names(dat1))
names(dat1) <- gsub("^f", "Frequency", names(dat1))
names(dat1) <- gsub("BodyBody", "Body", names(dat1))
names(dat1) <- gsub("mean", "Mean", names(dat1))
names(dat1) <- gsub("std", "Std", names(dat1))
names(dat1) <- gsub("Freq", "Frequency", names(dat1))
names(dat1) <- gsub("Mag", "Magnitude", names(dat1))


# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(plyr)
tidydata <- ddply(dat1, .(subject, activity), numcolwise(mean))


