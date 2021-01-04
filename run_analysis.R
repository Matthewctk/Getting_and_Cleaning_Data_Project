library(reshape2)

if(!file.exists("./data.zip")){
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "./data.zip", method = "curl")
unzip("data.zip")
}

activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
selected_features <- grepl("mean|std", features[,2])
features_name <- features[selected_features, 2]
features_name <- c(features_name, "activity", "subject")

training_set <-  read.table("./UCI HAR Dataset/train/X_train.txt")[,selected_features]
training_activities <-  read.table("./UCI HAR Dataset/train/y_train.txt")
train_subject <-  read.table("./UCI HAR Dataset/train/subject_train.txt")
train <- cbind(training_set, training_activities, train_subject)

testing_set <-  read.table("./UCI HAR Dataset/test/X_test.txt")[,selected_features]
testing_activities <-  read.table("./UCI HAR Dataset/test/y_test.txt")
test_subject <-  read.table("./UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testing_set, testing_activities, test_subject)

merged <- rbind(train, test)
colnames(merged) <- features_name
merged$activity <- factor(merged$activity, levels = activity[, 1], labels = activity[,2])
merged$subject <- factor(merged$subject, levels = 1:30)

new_merged <- melt(merged, id = c("activity", "subject"))
new_merged <- dcast(new_merged, activity + subject ~ variable, mean)

write.table(new_merged, file = "./tidy_data.txt", row.names = FALSE)
