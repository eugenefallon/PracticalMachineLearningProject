## Initial research for the project

## Setup 
library(caret)
library(dplyr)
library(randomForest)
trainurl <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
testurl <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"

## Download and load the data, cleaning up the data during load
download.file(trainurl, "./train.csv", method = "curl")
download.file(testurl, "./test.csv", method = "curl")
train <- read.csv("./train.csv", na.strings = c("", "NA", "#DIV/0!"))
test <- read.csv("./test.csv", na.strings = c("", "NA", "#DIV/0!"))  

## Build our model
## First create the training set
table(train$classe)
set.seed(999)
inTrain <- createDataPartition(train$classe, p = 0.7, list = FALSE)
training <- train[inTrain,]
testing <- train[-inTrain,]

## Now remove features that are not likely to contribute to the model using the nearZeroVar function
nsv <- nearZeroVar(training)
training <- training[, -nsv]
training <- select(training, -(X:num_window))
training<-training[,colSums(is.na(training))/nrow(training) < 0.50]

## Train the model using Random Forest
RFmodel <- randomForest(classe~., data = training, method = "class")

## Cross validate the model to determine accuracy
myPredict <- predict(RFmodel, testing, type = "class")
confusionMatrix(myPredict, testing$classe)

## Run our predictions for the supplied test set
pResults <- predict(RFmodel, test, type = "class")
pResults

## Write out our prediction files for submission
n = length(pResults)
    for(i in 1:n){
        filename = paste0("problem_id_",i,".txt")
        write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
    }

