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
summary(loans$Gender) #Transform into dummies
loans$female <- factor(loans$Gender)
summary(loans$female)

summary(loans$MaritalStatus)
summary(loans$ProductGroup1Name)
summary(loans$DisbursedAmount)
summary(loans$LateInstallments)
summary(loans$WorkDaysLoanWasInArrears)
#not too important at this stage:
summary(loans$BirthDate)
summary(loans$DisbursementDate)
#just checking, but not too relevant to know its statistics:
summary(loans$LoanID)
summary(loans$CustomerId)
#Panel Data

#inspect missing data

#inspect distribution of the variables
# histogram
#inspect outliers for each variable:
#boxplot



#Step 3: Creating new variables
# Low, medium and high delinquency:

# Make date variable : day, month, year

#Age groups:

#

#Ideas: 

#OLS:
lm1 <- (, data=loans)
summary(lm1)

# simple regression with time and individual FE 

#Machine learning methods
#feature of importance
#