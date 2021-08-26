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

#PS: putting into colab might be nicer for visualizing 