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

# Make date variable : day, month, year

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

#Machine learning methods
#feature of importance
#

#PS: putting into colab might be nicer for visualizing 