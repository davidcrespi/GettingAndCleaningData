# Load the necessary libraries
library(tidyverse)
library(stringr)

# Read in data files
trainDataX <- read_table('X_train.txt',col_names = FALSE)
testDataX <- read_table('X_test.txt',col_names = FALSE)
trainDatay <- read_table('y_train.txt',col_names = FALSE)
testDatay <- read_table('y_test.txt',col_names = FALSE)
columnNames <- read.table('features.txt')[,2] %>% as.character()
subjectTrain <- read_table('subject_train.txt',col_names = FALSE)
subjectTest <- read_table('subject_test.txt',col_names = FALSE)
activityLabels <- read_table('activity_labels.txt',col_names = FALSE)
names(activityLabels) <- c('ActivityID','Activity')

# Clean up the column names and set the column names of read in files to match these

# Add column numbers to avoid duplication
for(i in 1:length(columnNames)) columnNames[i] <- str_c(columnNames[i],'_column_',i)
names(trainDataX) <- columnNames
names(testDataX) <- columnNames
names(trainDatay) <- 'ActivityID'
names(testDatay) <- 'ActivityID'

# Combine all data into fullData
subjects <- bind_rows(subjectTrain,subjectTest) %>% select(SubjectID = X1)
fullDataX <- bind_rows(trainDataX,testDataX)
fullDatay <- bind_rows(trainDatay,testDatay)
fullData <- bind_cols(subjects,fullDataX,fullDatay) %>% left_join(activityLabels) %>% select(-ActivityID)

# Mean and sd by column
meanByColumn <- fullData %>% select(-SubjectID,-Activity) %>% summarise_each(funs(mean))
sdByColumn <- fullData %>% select(-SubjectID,-Activity) %>% summarise_each(funs(sd))
statsByColumn <- bind_rows(meanByColumn,sdByColumn)
rownames(statsByColumn) <- c('mean','sd')

# Grouped mean by column
groupedMeansByColumn <- fullData %>% group_by(SubjectID,Activity) %>% summarise_each(funs(mean))

