#HOPE analysis
rm(list = ls()) #clear the work environment

#Step 1: loading the csv into R studio
library(readr)
loans <- read_csv("HOPE_International/HOPELoansSince2019.csv")

#Cleaning Missing Data:
loans_clean <- na.omit(loans)
summary(loans_clean)
# 
65421-65379
#There were 42 missing values, ommited now

######################Step 3: Creating new variables###########################

#### AGE:

#install.packages("tidyr")# if not installed
library(tidyr)
loans2 <- separate(data = loans, col = BirthDate, into = c('day_birth', 'month_birth', 'year_birth')) #Separate year from BirthDate column
View(loans2) # checking if columns were correctly created
class(loans2$year_birth) # it is not numeric, but character format
loans2$year <- as.numeric(loans2$year_birth) # transform to numeric
class(loans2$year)#checking : now, it is numeric, ready for calculation
loans2$age <- 2021-loans2$year # create age column
hist(loans2$age) # inspect its distribution
plot(loans2$age, loans2$LateInstallments)
#remove outliers? age >80 (looks like 88, 89)

##PROBLEM: 
summary(factor(loans$BirthDate)) # 82% IS NA
# how to deal?
# OPTION 1: JUST USE NON-MISSING FOR THIS ANALYSIS
subset <-  loans4[complete.cases(loans4), ]
# OPTION 2: CHECK HOW GOOD THE EXPLANATORY VARIABLES ARE IN PREDICTING, TO SEE IF IMPUTATION WOULD WORK
# See how good is the subset for prediction
subset <-  loans4[complete.cases(loans4), ]
#split using k-fold
require(caret)
flds <- createFolds(y, k = 2, list = TRUE, returnTrain = FALSE)
names(flds)[1] <- "train"
training <- subset[flds$train,]
testing <- subset[ flds[[2]], ]

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
loans_per_customer<- tally(group_by(loans, CustomerId))
loans_per_customer <- as.numeric(loans_per_customer)
hist(loans_per_customer)
# further: put in dataset



# Make date variable : day, month, year #inspect how it plots

#Additional variables that would be relevant if available:
#occupation
#the use of the loan (ex: agriculture, shop, sewing business, etc)
#number of people in household
#location (country, city, )

################################### Tables:

#Deliquency rates per marital status:
Deliquency_per_MaritalStatus <- table(loans4$MaritalStatus, loans4$Delinquency)

#obs: rename column for typo (If I have time)


library(arsenal) 
table_one <- tableby(continent ~ ., data = gapminder) 
summary(table_one, title = "Gapminder Data")

#Deliquency rates per Gender:
table(loans$Gender, loans$Delinquency)
table(loans$Gender)
Female_percentage <- 39061 / (39061 + 26313)
Female_percentage
Male_percentage <- 26313 / (39061 + 26313)
Male_percentage

#Deliquency rates per Age:
table(loans$, loans$Delinquency)

#Deliquency rates per ProductGroupName:
table(loans$ProductGroup1Name, loans$Delinquency)

#Deliquency rates per DisbursementDate: #### treat as date ! Also: use year
table(loans$DisbursementDate, loans$Delinquency)

#Deliquency rates per DisbursedAmount: ### 
table(loans$DisbursedAmount, loans$Delinquency)

library(GGally)
loans_subset <- loans[c("Gender","MaritalStatus","ProductGroup1Name","Delinquency")]
ggpairs(data=loans_subset,aes(colour=Delinquency))

################################ REGRESSIONS: 

# ologit: for categorical variable (Deliquency rates: none, low, medium, high)
# First we evaluate at the mean:
library(foreign)
library(ggplot2)
library(MASS)
library(Hmisc)
library(reshape2)
install.packages("polr")
library(polr)
#Ordering the dependent variable
loans4$Delinquency.ordered = factor(loans4$Delinquency, levels = c("low", "medium", "high"), ordered = TRUE) 
Deliquency_frequency <- table(loans4$Deliquency.ordered)
install.packages("remotes")
library(remotes)
install_github("cran/zelig")
install_github("cran/MASS")
#install.packages("zeligverse")
#library(zeligverse)

## fit ordered logit model and store results 'ologit1'
ologit1 <- polr( Delinquency ~ age + factor(Gender) + factor(MaritalStatus) + factor(ProductGroup1Name) + DisbursementDate_YearMonth , data = subset, Hess=TRUE)
summary(ologit1)

# https://stats.idre.ucla.edu/r/dae/ordinal-logistic-regression/

mspread = mean(spread)
margins(ologit1, at =list(spread=mspread))

#Let's try over a range from 1 to 10
margins(ologit1, at =list(spread=1:10))

# Not appropriate: simple OLS (with Late Installments)
# simple regression with time and individual FE : PROBLEM: assumptions violated, estimates are not consistent
lm1 <- lm(loans4$LateInstallments ~ loans4$age + factor(loans4$Gender) + factor(loans4$MaritalStatus) + loans4$DisbursedAmount + factor(loans4$ProductGroup1Name) + factor(loans4$monthyear_Disbursement.num))
summary(lm1)

# tobit : for late installments
# adequate because of truncated data (lots of zeros), 
# it is called " censored regression"
# interpretation - signal, but for magnitude, calculate the marginal effect
#https://stats.idre.ucla.edu/r/dae/tobit-models/
require(ggplot2)
require(GGally)
require(VGAM)


stargazer(list(lm2,prbt2,mlog2), type = "text", 
          keep.stat = c("n","rsq"), float = FALSE, font.size = "small", 
          digits=3, keep=c(1:10))
#Machine learning methods
library(caret)

# Try: random forest, decision tree, 
#feature of importance
#ConfusionMatrix
#CorrelationMatrix

#PS: putting into colab might be nicer for visualizing 

# Clean up:df$x <- NULL
# Check on Sublime: data set loan vs. loans2


write.csv(loans4,"HOPE_data_for_analysis.csv" )
write.dta(loans4, "HOPE_data_for_analysis.dta")

######################################################## extra:
#Age at disbursement:

loans2$date.new <- as.Date(as.character(loans$BirthDate), format="%m/%d/%Y")
loans2$date.now <- as.Date(as.character(loans$DisbursementDate), format="%m/%d/%Y")
loans2$age_at_disbusement <- loans$date.new - loans$date.now
loans2$age <- as.numeric(loans2$DisbursementDate - loans2$BirthDate) %/% 365.25


#Age groups :
loans$age_groups <- factor(loans$age)
levels(loans$Delinquency) <- list(   elderly = )
summary(factor(loans$Delinquency))


