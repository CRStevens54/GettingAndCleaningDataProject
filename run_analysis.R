fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "C:/Users/SteveC13/Desktop/Data Science Text Books/tidy data/GalaxyData.zip")


unzip(zipfile="C:/Users/SteveC13/Desktop/Data Science Text Books/tidy data/GalaxyData.zip",exdir="C:/Users/SteveC13/Desktop/Data Science Text Books/tidy data")

Feature_train <- read.table("C:/Users/SteveC13/Desktop/Data Science Text Books/tidy data/UCI HAR Dataset/train/X_train.txt")
Activity_train <- read.table("C:/Users/SteveC13/Desktop/Data Science Text Books/tidy data/UCI HAR Dataset/train/y_train.txt")
Subject_train <- read.table("C:/Users/SteveC13/Desktop/Data Science Text Books/tidy data/UCI HAR Dataset/train/subject_train.txt")

Feature_test <- read.table("C:/Users/SteveC13/Desktop/Data Science Text Books/tidy data/UCI HAR Dataset/test/X_test.txt")
Activity_test <- read.table("C:/Users/SteveC13/Desktop/Data Science Text Books/tidy data/UCI HAR Dataset/test/y_test.txt")
Subject_test <- read.table("C:/Users/SteveC13/Desktop/Data Science Text Books/tidy data/UCI HAR Dataset/test/subject_test.txt")

features <- read.table("C:/Users/SteveC13/Desktop/Data Science Text Books/tidy data/UCI HAR Dataset/features.txt")





## Step 1: Merge Data ##

Subjectdata <- rbind(Subject_train, Subject_test)
Activitydata <- rbind(Activity_train, Activity_test)
Featuresdata <- rbind(Feature_train, Feature_test)


names(Subjectdata)<-c("subject")
names(Activitydata)<- c("activity")

FeaturesNames <- read.table("C:/Users/SteveC13/Desktop/Data Science Text Books/tidy data/UCI HAR Dataset/features.txt")

names(Featuresdata)<- FeaturesNames$V2

CombinedData <- cbind(Subjectdata, Activitydata)
TotalData <- cbind(Featuresdata, CombinedData)


## Step 2: Extracts only the measurements on the mean and standard deviation for each measurement. ##


MeanorSTD_Subset <- FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]


Subsetnames<-c(as.character(MeanorSTD_Subset), "subject", "activity" )
TotalData<-subset(TotalData,select=Subsetnames)


## Step 3: Uses descriptive activity names to name the activities in the data set
## Read in labels and factorize variables in TotalData using the description names in activitylabesl.txt  ##
ActivityLabels = read.table("C:/Users/SteveC13/Desktop/Data Science Text Books/tidy data/UCI HAR Dataset/activity_labels.txt")

TotalData$activity<-factor(TotalData$activity);
TotalData$activity<- factor(TotalData$activity,labels=as.character(ActivityLabels$V2))

##  Step 4: Appropriately labels the data set with descriptive variable names. ##

names(TotalData)<-gsub("^t", "time", names(TotalData))
names(TotalData)<-gsub("^f", "frequency", names(TotalData))
names(TotalData)<-gsub("Acc", "Accelerometer", names(TotalData))
names(TotalData)<-gsub("Gyro", "Gyroscope", names(TotalData))
names(TotalData)<-gsub("Mag", "Magnitude", names(TotalData))
names(TotalData)<-gsub("BodyBody", "Body", names(TotalData))


library(plyr);
TotalData2<-aggregate(. ~subject + activity, TotalData, mean)
TotalData2<-TotalData2[order(TotalData2$subject,TotalData2$activity),]
write.csv(TotalData2, file = "TotalData2_tidydata.csv",row.name=TRUE)





