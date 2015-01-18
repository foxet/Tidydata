##  Load data from different files
test<-cbind(read.table('UCI HAR Dataset/test/subject_test.txt'),
            read.table('UCI HAR Dataset/test/y_test.txt'),
            read.table('UCI HAR Dataset/test/X_test.txt'))
train<-cbind(read.table('UCI HAR Dataset/train/subject_train.txt'),
            read.table('UCI HAR Dataset/train/y_train.txt'),
            read.table('UCI HAR Dataset/train/X_train.txt'))

##  step 1:Merges the training and the test sets to create one data set.
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
desall<-data.frame(var=names(extract_data))
desall[,'nchar']<-sapply(extract_data[1,],nchar)
desall[,'des']<-paste('Variable type:',sapply(extract_data,class),' Range: ',sapply(extract_data,range)[1,],'...',sapply(extract_data,range)[2,],sep='')
desall[grep('Body',desall$var),'Body']<-'The body acceleration signal is measured'
desall[grep('Gravity',desall$var),'Gravity']<-'The gravity acceleration signal is measured'
desall[grep('-X',desall$var),'x']<-' in x axial'
desall[grep('-Y',desall$var),'y']<-' in y axial'
desall[grep('-Z',desall$var),'Z']<-' in z axial'
desall[grep('Acc',desall$var),'acc']<-' from the accelerometer.'
desall[grep('Gyro',desall$var),'gyro']<-' from the gyroscope.'
desall[grep('Jerk',desall$var),'jerk']<-'And the Jerk signals was obtain from this signal.'
desall[grep('Mag',desall$var),'magnitude']<-'Also, the magnitude of these three-dimensional signals were calculated using the Euclidean norm.'
desall[grep('fBody|fGravity',desall$var),'FFT']<-'Finally a Fast Fourier Transform (FFT) was applied to this signal.'
desall[grep('mean\\(\\)',desall$var),'mean']<-'Mean value were estimated from these signals.'
desall[grep('std',desall$var),'std']<-'Standard deviation were estimated from these signals.'
desall[grep('meanFreq',desall$var),'meanFreq']<-'Weighted average of the frequency components to obtain a mean frequency.'
#desall[is.na(desall)]=''
for(i in 3:nrow(desall)) {
        tdata<-desall[i,-c(1:3)]
        temp<-!(is.na(tdata))
        desall[i,'com']<-paste(tdata[temp],collapse='')
}

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

desall<-cbind(data_names,desall[,c('var','nchar','des','com')])
write.table(desall,file='CodeBook.txt',row.names=FALSE) 

