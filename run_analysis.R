#setup the working directory
setwd('/Users/JingwenLiang/Documents/coursera/UCI HAR Dataset/');

#read data change the feature names
training = read.csv("train/X_train.txt", sep="", header = FALSE)
training[,562] = read.csv("train/Y_train.txt", sep = "", header = FALSE)
training[,563] = read.csv("train/subject_train.txt", sep = "", header = FALSE)
testing = read.csv("test/X_test.txt", sep = "", header = FALSE)
testing[,562] = read.csv("test/Y_test.txt", sep = "", header = FALSE)
testing[,563] = read.csv("test/subject_test.txt", sep = "", header = FALSE)


#1. Merges the training and the test sets to create one data set.
data = rbind(training, testing)

#2. Extracts only the measurements on the mean and standard deviation for each 
#measurement. 

features = read.csv("features.txt", sep="", header=FALSE)
goodFeatures <- grep(""-mean\\(\\)|-std\\(\\)"", features[,2])
features <- features[goodFeatures,]
goodFeatures <- unique(c(goodFeatures, 562, 563))
data = data[, goodFeatures]
colnames(data) <- c(features$V2, "Activity", "Subject")
colnames(data) <- tolower(colnames(data))

# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive activity names.
activityLabels = read.csv("activity_labels.txt", sep="", header=FALSE)
currentActivity = 1
for (currentActivityLabel in activityLabels$V2) {
    data$activity <- gsub(currentActivity, currentActivityLabel, data$activity)
    currentActivity <- currentActivity + 1
}
data$activity <- as.factor(data$activity)
data$subject <- as.factor(data$subject)

# 5. Create a second, independent tidy data set with the average of each variable 
#for each activity and each subject. 
tidy = aggregate(data, by=list(activity = data$activity, subject=data$subject),
                 mean,)
# Remove the subject and activity column, since a mean of those has no use
write.csv(tidy[,1:88], "tidy.txt", sep="\t")

