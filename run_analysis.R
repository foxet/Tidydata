##  step 1:Merges the training and the test sets to create one data set.
test<-cbind(read.table('UCI HAR Dataset/test/subject_test.txt'),
            read.table('UCI HAR Dataset/test/y_test.txt'),
            read.table('UCI HAR Dataset/test/X_test.txt'))
train<-cbind(read.table('UCI HAR Dataset/train/subject_train.txt'),
            read.table('UCI HAR Dataset/train/y_train.txt'),
            read.table('UCI HAR Dataset/train/X_train.txt'))

datas<-rbind(test,train) 
f_name<-read.table('UCI HAR Dataset/features.txt',stringsAsFactors=FALSE)[,2]
names(datas)<-c('Id','Activity',f_name)

## step 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
extract_data<-datas[,c(1,2,grep('mean|std',names(datas),ignore.case=FALSE))]

## step 3: Uses descriptive activity names to name the activities in the data set
labels<-read.table('UCI HAR Dataset/activity_labels.txt',stringsAsFactors=FALSE)[,2]
transform(extract_data,Activity=as.factor(Activity))
levels(extract_data$Activity)=labels

## step 4: labels the data set with descriptive variable names.
data_names<-names(extract_data)
data_names<-gsub('\\btBody','TimeBody',data_names)
data_names<-gsub('\\bfBodyBody','FFTBody',data_names)
data_names<-gsub('\\bfBody','FFTBody',data_names)
data_names<-gsub('\\btGravity','Gravity',data_names)
data_names<-gsub('Acc','Accelerometer',data_names)
data_names<-gsub('Gyro','Gyroscope',data_names)
data_names<-gsub('Jerk','Jerk',data_names)
data_names<-gsub('Mag','Magnitude',data_names)
data_names<-gsub('-std\\(\\)','Std',data_names)
data_names<-gsub('-mean\\(\\)','Mean',data_names)
data_names<-gsub('-meanFreq\\(\\)','Meanfreq',data_names)
data_names<-gsub('-X','X',data_names)
data_names<-gsub('-Y','Y',data_names)
data_names<-gsub('-Z','Z',data_names)
names(extract_data)<-data_names

## step 5: creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_data<-aggregate(x=extract_data,by=list(extract_data$Id,extract_data$Activity),FUN=mean)
tidy_data=tidy_data[order(tidy_data[,c('Id')]),-c(1,2)]

## save tidy_data as a seperated file
write.table(tidy_data,file='tidy_data.txt',row.names=FALSE) 

