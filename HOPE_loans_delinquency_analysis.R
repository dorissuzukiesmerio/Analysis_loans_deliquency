#HOPE analysis
rm(list = ls()) #clear the work environment

#Step 1: loading the csv into R studio
library(readr)
loans <- read_csv("HOPE_International/HOPELoansSince2019.csv")

#Step 2: exploring the data
colnames(loans) #Variable names
View(loans) #General overview of the dataset

#Descriptive statistics of main variables 
#(Min. 1st Qu.  Median    Mean 3rd Qu.    Max.):
summary(loans$DisbursedAmount)
summary(loans$LateInstallments)
summary(loans$WorkDaysLoanWasInArrears)

# For categorical/ character variables : use "factor". Now, summary will show  how many in each category
summary(factor(loans$Gender))
summary(factor(loans$MaritalStatus))
summary(factor(loans$ProductGroup1Name))

#not too important at this stage:
summary(loans$BirthDate)
summary(loans$DisbursementDate)
#just checking, but not too relevant to know its statistics:
summary(factor(loans$LoanID))
summary(loans$CustomerId)

# Obs: I could have done in one code : summary(loans), but then would need to first create new variables for the categorical ones
#Check: unique LoanID and unique Customer ? No. See distribution of loans per customer
#See histogram
hist(loans$CustomerId, 65421, main="CustomerID", xlab="CustomerID", ylab="Number of loans per customer")
#Count how many customers have a certain number of loans
# insight: create variable to how many loans each customer has had and include that in analysis
# However: be careful since the  individual FE may capture that ? check
#install.packages("plyr") # if not installed previously
library(plyr)
count(loans, c("loans$CustomerID", "loans$LoanID"))
# Maybe: some info about difference of date between disbursements ? (create variable)

#Panel Data

#inspect missing data:
summary(loans)
#method 1: omit missing values
loans_clean <- na.omit(loans)
summary(loans_clean)
# 
65421-65379
#There were 42 missing values, ommited now


#inspect distribution of the variables
# histogram
##histogram of Disbursement Amount:
hist(loans$DisbursedAmount, 200, main="Disbursement amount", xlab="DisbursementAmount", ylab="Number of loans with that amount")
##histogram of LateInstallments:
hist(loans$LateInstallments, 30, main="LateInstallments", xlab="DisbursementAmount", ylab="Number of loans")
##
hist(loans$WorkDaysLoanWasInArrears, 300, main="WorkDaysLoanWasInArrears", xlab="WorkDaysLoanWasInArrears", ylab="Number of loans")

###Check X label !

#inspect outliers for each variable:
#boxplot

##plot data
plot(loans$LateInstallments, factor(loans$MaritalStatus), type="p", xlim=range(60,80), ylim=range(70,320), main="Relationship Between MaritalStatus and LateInstallments", xlab="LateInstallments", ylab="MaritalStatus")


#Step 3: Creating new variables
# Low, medium and high delinquency:

#Criteria:
#"low delinquency" as having 0-2 late installments; 
#"medium delinquency" as having 3-4 late installments; 
#and "high delinquency" as having 4+ late installments per loan (not per customer).
Delinquency <- factor(loans$LateInstallments)
levels(Delinquency) <- list(Low = 0:2, Medium = 3:4, High = 5:18 )
summary(factor(Delinquency))

#Useful to logit/probit models?
is_low <- factor(loans$LateInstallments)
levels(is_low) <- list(Low = 0:2, not_low = 3:18 )
summary(factor(is_low))

is_high <- factor(loans$LateInstallments)
levels(is_high) <- list(not_high = 0:4, high = 4:18 )
summary(factor(is_high))


# Make date variable : day, month, year #inspect how it plots

#Age groups:

#Additional variables that would be relevant if available:
#occupation
#the use of the loan (ex: agriculture, shop, sewing business, etc)
#number of people in household
#location (country, city, )

#Ideas: 

#OLS:
lm1 <- (, data=loans)
summary(lm1)

# simple regression with time and individual FE 

# logit and probit models

#Machine learning methods
library(caret)

# Try: random forest
#feature of importance
#ConfusionMatrix
#CorrelationMatrix

#PS: putting into colab might be nicer for visualizing 