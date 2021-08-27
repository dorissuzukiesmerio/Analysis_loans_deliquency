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

#inspect missing data:
summary(loans)
#method 1: omit missing values
loans_clean <- na.omit(loans)
summary(loans_clean)
# 
65421-65379
#There were 42 missing values, ommited now


#inspect distribution of the variables
# Histograms:
##histogram of LateInstallments:
hist(loans$LateInstallments, main="Distribution of Number of Late Installments per Loan", xlab="Number of late installments per loan", ylab="Number of loans")
##histogram of Disbursement Amount:
hist(loans$DisbursedAmount, 200, main="Disbursement amount", xlab="DisbursementAmount", ylab="Number of loans with that amount")
## lots of zeros: tobit is an appropriate model 
hist(loans$WorkDaysLoanWasInArrears, main="WorkDaysLoanWasInArrears", xlab="WorkDaysLoanWasInArrears", ylab="Number of loans")

###Check X label !

#inspect outliers for each variable:
#Boxplot
library(ggplot2)
ggplot(loans,aes(x=ProductGroup1Name,y=LateInstallments,
               fill=factor(ProductGroup1Name)))+
  geom_boxplot()+
  geom_jitter()+
  labs(title="Boxplot for Late Installments per ProductGroup1Name",x="ProductGroup1Name",y="Late Installments")+
  theme_bw()+coord_flip()+
  theme(legend.position = "none")

library(ggplot2)
ggplot(loans,aes(x=MaritalStatus,y=LateInstallments,
                 fill=factor(MaritalStatus)))+
  geom_boxplot()+
  geom_jitter()+
  labs(title="Boxplot for Late Installments per MaritalStatus",x="MaritalStatus",y="Late Installments")+
  theme_bw()+coord_flip()+
  theme(legend.position = "none")


##plot data
plot(loans$LateInstallments, factor(loans$MaritalStatus), type="p", xlim=range(60,80), ylim=range(70,320), main="Relationship Between MaritalStatus and LateInstallments", xlab="LateInstallments", ylab="MaritalStatus")


#Step 3: Creating new variables
# Low, medium and high delinquency:

#Criteria:
#"low delinquency" as having 0-2 late installments; 
#"medium delinquency" as having 3-4 late installments; 
#and "high delinquency" as having 4+ late installments per loan (not per customer).
loans$Delinquency <- factor(loans$LateInstallments)
levels(loans$Delinquency) <- list(None = 0, Low = 1:2, Medium = 3:4, High = 5:18 )
#levels(loans$Delinquency) <- list(Low = 0:2, Medium = 3:4, High = 5:18 )
summary(factor(loans$Delinquency))

# Make date variable : day, month, year #inspect how it plots

#Age:
#Separate year from BirthDate column:
# method 1:
loans$Date_of_birth <- data.frame(do.call("rbind", strsplit(as.character(loans$BirthDate), "/", fixed = TRUE)))
lapply(Date_of_birth, transform, Date_of_birth.X3 = 2021 -  Date_of_birth.X3)

#method 2:
install.packages("stringr")
library(stringr)
as(loans$BirthDate, integer , strict=TRUE, ext)
str_split_fixed(loans$BirthDate, "/", 3)
lapply(Date_of_birth, transform, Date_of_birth.X3 = 2021 -  Date_of_birth.X3)


#method 3:
install.packages("tidyr")
library(tidyr) 
loans %>%
separate(loans$BirthDate, c("month", "day", "year"), "/")

library(eeptools)
x <- as.Date(loans$BirthDate)
age_calc(x[1],x[2], units = "years")
# Age groups:

#Additional variables that would be relevant if available:
#occupation
#the use of the loan (ex: agriculture, shop, sewing business, etc)
#number of people in household
#location (country, city, )

#Step 4:

# Tables:

#Deliquency rates per marital status:
table(loans$MaritalStatus, loans$Delinquency)
#obs: rename column for typo (If I have time)

#Deliquency rates per Gender:
table(loans$Gender, loans$Delinquency)
table(loans$Gender)
Female_percentage <- 39061 / (39061 + 26313)
Female_percentage
Male_percentage <- 26313 / (39061 + 26313)
Male_percentage

#Deliquency rates per Age:

#Deliquency rates per ProductGroupName:

#Deliquency rates per DisbursementDate:

#Deliquency rates per DisbursedAmount:


## REGRESSIONS: 
# simple OLS: with Late Installments
# simple regression with time and individual FE 
lm1 <- lm(loans$LateInstallments ~ factor(loans$Gender) + factor(loans$MaritalStatus) + loans$DisbursedAmount + factor(loans$ProductGroup1Name) + factor(loans$CustomerId) + loans$WorkDaysLoanWasInArrears)
summary(lm1)

# tobit : for late installments
# adequate because of truncated data (lots of zeros)
# interpretation - signal, but for magnitude, calculate the marginal effect

# ologit: for categorical variable (Deliquency rates: none, low, medium, high)

#Machine learning methods
library(caret)

# Try: random forest, decision tree, 
#feature of importance
#ConfusionMatrix
#CorrelationMatrix

#PS: putting into colab might be nicer for visualizing 