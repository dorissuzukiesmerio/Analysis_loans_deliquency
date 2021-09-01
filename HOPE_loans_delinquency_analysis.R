#HOPE analysis: PART 1 : DATASET

# Step 0 : making sure that packages are installed, and environment clean
#packages to install in R to be able to run this code:
install.packages("ggplot")
install.packages("caret")
install.packages("glm")
install.packages("readr")
install.packages("tidyr")
#obs: I like to load the package further on, as I need to use it: library(), or require()

rm(list = ls()) #clear the work environment

# Step 1: loading the csv into R studio
library(readr)
loans <- read_csv("HOPE_International/HOPELoansSince2019.csv")
summary(loans)

# Step 2 : Exploratory analysis (see separate file) 
# Purpose: to better understand the need for creating variables, and which are the most appropriate models

######################Step 3: Creating new variables###########################

#### AGE:

library(tidyr)
loans2 <- separate(data = loans, col = BirthDate, into = c('day_birth', 'month_birth', 'year_birth')) #Separate year from BirthDate column
View(loans2) # checking if columns were correctly created
class(loans2$year_birth) # it is not numeric, but character format
loans2$year <- as.numeric(loans2$year_birth) # transform to numeric
class(loans2$year)#checking : now, it is numeric, ready for calculation
loans2$age <- 2021-loans2$year # create age column
hist(loans2$age) # inspect its distribution
plot(loans2$age, loans2$LateInstallments)
#remove outlier? age==89

### DISBURSEMENT DATE: 

library(tidyr)
loans3 <- separate(data = loans2, col = DisbursementDate, into = c('month_disbursementDate', 'day_disbursementDate', 'year_disbursementDate')) #Separate year from DisbursementDate column

# Add leading zeros to month
loans3$month_disbursementDate_0 <- paste0("0", loans3$month_disbursementDate)
#Use only the 2 last digits
substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}
loans3$month_Disb.correct <- substrRight(loans3$month_disbursementDate_0, 2)
# use as character still , otherwise, 0 will be dropped! 
#concat just year and month
loans4<-transform(loans3, monthyear_Disbursement.correct=paste0(year_disbursementDate, month_Disb.correct))
loans4$monthyear_Disbursement.num <- as.numeric(loans4$monthyear_Disbursement.correct) # transform to numeric

## DELINQUENCY 

loans4$Delinquency <- factor(loans4$LateInstallments)
#levels(loans$Delinquency) <- list(None = 0, Low = 1:2, Medium = 3:4, High = 5:18 )
levels(loans4$Delinquency) <- list(Low = 0:2, Medium = 3:4, High = 5:18 )
summary(factor(loans4$Delinquency))
loans4$Delinquency <- ordered(loans4$Delinquency)


# Dummies of higher and lower delinquency for probit and logit models:

loans4$higher_delinquency <- ifelse(loans4$Delinquency == 'High', 1, 0)
loans4$lower_delinquency <- ifelse(loans4$Delinquency == 'Low', 1, 0)

#Clean up:
loans4$month_disbursementDate_0 <- NULL # dropping
loans4$month_Disb.correct <- NULL
loans4$monthyear_Disbursement.correct <- NULL
loans4$DisbursementDate_YearMonth<-loans4$monthyear_Disbursement.num # renaming
loans4$monthyear_Disbursement.num <- NULL

# LOANS PER CUSTOMER:
library(dplyr)
loans4$loans_per_customer<- tally(group_by(loans4, CustomerId))
loans4$loans_per_customer <- as.numeric(loans4$loans_per_customer)
hist(loans4$loans_per_customer)
# further: put in dataset


write.csv(loans4,"HOPE_dataset_loans4_updated.csv" )

# Make date variable : day, month, year #inspect how it plots

#Additional variables that would be relevant if available:
#occupation
#the use of the loan (ex: agriculture, shop, sewing business, etc)
#number of people in household
#location (country, city, )

#################### FIXING variable PROBLEMS:
##PROBLEM: MISSING BIRTHDATE for a huge portion of the dataset
summary(factor(loans$BirthDate)) # 82% IS NA
# how to deal?
# OPTION 1: JUST USE NON-MISSING FOR THIS ANALYSIS
subset <-  loans4[complete.cases(loans4), ]

# OPTION 2: CHECK HOW GOOD THE EXPLANATORY VARIABLES ARE IN PREDICTING, TO SEE IF IMPUTATION WOULD WORK
# See how good is the subset for prediction

#split using k-fold, dividing into 2
require(caret)
flds <- createFolds( subset$Delinquency, k = 2, list = TRUE, returnTrain = FALSE)
names(flds)[1] <- "train"
training <- subset[flds$train,]
testing <- subset[ flds[[2]], ]

### Decision Tree
install.packages("e1071")
library(e1071)
ModFit_rpart <- train(Delinquency~.,data=training,method="rpart",
                      parms = list(split = "gini"))
predict_rpart <- predict(ModFit_rpart,testing)
confusionMatrix(predict_rpart, testing$Delinquency)

# If adequate, then:
# method 1: set NA to mean
NA2mean <- function(x) replace(x, is.na(x), mean(x, na.rm = TRUE))
new_loans4 <-replace(loans4, TRUE, lapply(loans4, NA2mean))
summary(factor(new_loans4$age))

# method 2: imputation with Bootstrap Aggregation Imputation:
library(caret)
PreImputeBag <- preProcess(loans4,method="bagImpute")
DataImputeBag <- predict(PreImputeBag,loans4)

# method 3: imputation via knn
install.packages("RANN")
library(RANN)
MData <- loans4[,-c(1,5,6)]
PreImputeKNN <- preProcess(MData,method="knnImpute",k=5)
DataImputeKNN <- predict(PreImputeKNN,MData)
#Convert back to original scale
RescaleDataM <- t(t(DataImputeKNN)*PreImputeKNN$std+PreImputeKNN$mean)


######################################################## extra:
#Age at disbursement (to explore):

loans2$date.new <- as.Date(as.character(loans$BirthDate), format="%m/%d/%Y")
loans2$date.now <- as.Date(as.character(loans$DisbursementDate), format="%m/%d/%Y")
loans2$age_at_disbusement <- loans$date.new - loans$date.now
loans2$age <- as.numeric(loans2$DisbursementDate - loans2$BirthDate) %/% 365.25


#Age groups (done):
hist(loans4$age)
loans4$age_groups <- factor(loans4$age)
levels(loans4$age_groups) <- list( twenties = 20:29, thirties = 30:39, forties = 40:49, fifties = 50:59, sixties = 60:69)
summary(factor(loans4$age_groups))
loans4$age_groups <- ordered(loans4$age_groups)
summary(loans4$age_groups)

# Disbursement_amounts_categories: PROBLEM: SHOULDN'T HAVE NA'S
#Inspecting again to see what would be reasonable:
hist(loans4$DisbursedAmount, 200)
boxplot(loans4$DisbursedAmount)
summary(loans4$DisbursedAmount)
#Decision: use the quantiles
# Creating:
loans4$amount_levels <- factor(loans4$DisbursedAmount)
levels(loans4$amount_levels) <- list( first_q = 55000:200000, second_q = 200000:311060, third_q = 311060:350000, forth_q = 350000: 6000000)
summary(factor(loans4$amount_levels))
loans4$amount_levels <- ordered(loans4$amount_levels)
summary(loans4$amount_levels)



