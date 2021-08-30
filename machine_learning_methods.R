### MACHINE LEARNING:
rm(list = ls())
library(readr)
loans <- read_csv("HOPE_International/HOPELoansSince2019.csv")

#Split into training and testing:

# method 1: use DataPartition
ind1 <- createDataPartition(y=loans4$Delinquency,p=0.6,list=FALSE,times=1)
#list=FALSE, prevent returning result as a list
#times=1 to create the resample size. Default value is 1.
training <- loans4[ind1,]
testing  <- loans4[-ind1,] 

fitControl <- trainControl(method="cv", number=10)
# train the model
model <- train(Delinquency~., data=training, 
               trControl=fitControl, method="lda")

### Decision Tree
ModFit_rpart <- train(Species~.,data=training,method="rpart",
                      parms = list(split = "gini"))
# gini can be replaced by chisquare, entropy, information

#fancier plot
library(rattle)
fancyRpartPlot(ModFit_rpart$finalModel)

predict_rpart <- predict(ModFit_rpart,testing)
confusionMatrix(predict_rpart, testing$Species)

testing$PredRight <- predict_rpart==testing$Species
ggplot(testing,aes(x=Petal.Width,y=Petal.Length))+
  geom_point(aes(col=PredRight))

#### RANDOM FOREST:
ModFit_rf <- train(Species~.,data=training,method="rf",prox=TRUE)

predict_rf <- predict(ModFit_rf,testing)
confusionMatrix(predict_rf, testing$Species)

testing$PredRight <- predict_rf==testing$Species
ggplot(testing,aes(x=Petal.Width,y=Petal.Length))+
  geom_point(aes(col=PredRight))




# summarize results
print(model)
predict1 <- predict(model,testing)

#`Regression Model Evaluation metrics:`
postResample(prediction,testing$Ozone)

confusionMatrix(predict,testing)


############Feauture of importance
library(adabag)
library(caret)
ModFit_adaboost <- boosting(Delinquency~.,data=training,mfinal = 10, coeflearn = "Breiman")
importanceplot(ModFit_adaboost)
predict_Ada <- predict(ModFit_adaboost,newdata=testing)
confusionMatrix(testing$Species,as.factor(predict_Ada$class))
