
setwd("C:/Users/Prerana/Desktop/UCI HAR Dataset")

#1. Merge the training and the test data.

features        <- read.table("./features.txt",header=FALSE)
activityLabel   <- read.table("./activity_labels.txt",header=FALSE)
subjectTrain    <-read.table("./train/subject_train.txt", header=FALSE)
xTrain          <- read.table("./train/X_train.txt", header=FALSE)
yTrain          <- read.table("./train/y_train.txt", header=FALSE)



colnames(activityLabel)<-c("activityId","activityType")
colnames(subjectTrain) <- "subId"
colnames(xTrain) <- features[,2]
colnames(yTrain) <- "activityId"
trainData <- cbind(yTrain,subjectTrain,xTrain)
subjectTest    <-read.table("./test/subject_test.txt", header=FALSE)
xTest         <- read.table("./test/X_test.txt", header=FALSE)
yTest         <- read.table("./test/y_test.txt", header=FALSE)
colnames(subjectTest) <- "subId"
colnames(xTest) <- features[,2]
colnames(yTest) <- "activityId"
testData <- cbind(yTest,subjectTest,xTest)
finalData <- rbind(trainData,testData)
colNames<-colnames(finalData)
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
data_mean_std <-finalData[,grepl("mean|std|subject|activityId",colnames(finalData))]

#3. #Uses descriptive activity names to name the activities in the data set

data_mean_std <- join(data_mean_std, activityLabel, by = "activityId", match = "first")

data_mean_std <-data_mean_std[,-1]

#4. Appropriately labels the data set with descriptive variable names.

names(data_mean_std) <- gsub("\\(|\\)", "", names(data_mean_std), perl  = TRUE)



names(data_mean_std) <- make.names(names(data_mean_std))



names(data_mean_std) <- gsub("Acc", "Acceleration", names(data_mean_std))
names(data_mean_std) <- gsub("^t", "Time", names(data_mean_std))
names(data_mean_std) <- gsub("^f", "Frequency", names(data_mean_std))
names(data_mean_std) <- gsub("BodyBody", "Body", names(data_mean_std))
names(data_mean_std) <- gsub("mean", "Mean", names(data_mean_std))
names(data_mean_std) <- gsub("std", "Std", names(data_mean_std))
names(data_mean_std) <- gsub("Freq", "Frequency", names(data_mean_std))
names(data_mean_std) <- gsub("Mag", "Magnitude", names(data_mean_std))

#5.creates a second, independent tidy data set with the average of each variable for each activity and each subject.


tidydata_average_sub<- ddply(data_mean_std, c("subject","activity"), numcolwise(mean))


write.table(tidydata_average_sub,file="tidydata.txt")
