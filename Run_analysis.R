Install.packages("reshape")
library(reshape)
library(plyr))

xTrain = read.table("./train/X_train.txt")
yTrain = read.table("./train/y_train.txt")
subjectTrain = read.table("./train/subject_train.txt")

xTest = read.table("./test/X_test.txt")
yTest = read.table("./test/y_test.txt")
subjectTest = read.table("./test/subject_test.txt")

featuresdf = read.table("./features.txt")
headings = featuresdf$V2

#transfer headings to data set
colnames(xTrain) = headings
colnames(xTest) = headings

#change V1 variable to descriptive variable "activity"
yTest <- rename(yTest, c(V1="activity"))
yTrain <- rename(yTrain, c(V1="activity"))

# change data values in yTest according to activity_labels.txt file
activitydf  = read.table("./activity_labels.txt")

#convert variable names to lowercase
activityLabels = tolower(levels(activitydf$V2))

#convert $activity to factor and add descriptive labels
yTrain$activity = factor(yTrain$activity,labels = activityLabels)
yTest$activity = factor(yTest$activity,yTest$activity,labels = activityLabels)

subjectTrain <- rename(subjectTrain, c(V1="subjectid"))
subjectTest <- rename(subjectTest, c(V1="subjectid"))

train = cbind(xTrain, subjectTrain, yTrain)
test = cbind(xTest, subjectTest, yTest)

#combine data set
finalData = rbind(train, test)

pattern = "mean|std|subjectid|activity"
tidyData = finalData[,grep(pattern , names(finalData), value=TRUE)]

# summarize data
result = ddply(tidyData, .(activity, subjectid), numcolwise(mean))

# write file to output
write.table(result, file="result.txt", sep = "\t", append=F)

