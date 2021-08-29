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

ggplot(data = loans,
       aes(x = LateInstallments, y = MaritalStatus)) +
  geom_boxplot()

library(ggplot2)
ggplot(loans,aes(x=MaritalStatus,y=LateInstallments,
                 fill=factor(MaritalStatus)))+
  geom_boxplot()+
  geom_jitter()+
  labs(title="Boxplot for Late Installments per MaritalStatus",x="MaritalStatus",y="Late Installments")+
  theme_bw()+coord_flip()+
  theme(legend.position = "none")

ggplot(data = loans,
       aes(x = LateInstallments, y = ProductGroup1Name)) +
  geom_boxplot()


##plot data
plot(loans$LateInstallments, factor(loans$MaritalStatus), type="p", xlim=range(60,80), ylim=range(70,320), main="Relationship Between MaritalStatus and LateInstallments", xlab="LateInstallments", ylab="MaritalStatus")


#Step 3: Creating new variables
# Low, medium and high delinquency:

#Criteria:
#"low delinquency" as having 0-2 late installments; 
#"medium delinquency" as having 3-4 late installments; 
#and "high delinquency" as having 4+ late installments per loan (not per customer).
loans$Delinquency <- factor(loans$LateInstallments)
#levels(loans$Delinquency) <- list(None = 0, Low = 1:2, Medium = 3:4, High = 5:18 )
levels(loans$Delinquency) <- list(Low = 0:2, Medium = 3:4, High = 5:18 )
summary(factor(loans$Delinquency))


#probit and logit ?
loans$is_low <- factor(loans$Delinquency)
levels(loans$is_low) <- list( Low = 0:2, notLow=3:18 )
summary(factor(loans$is_low)) # make dummy 0 1 ?

loans$is_high <- factor(loans$Delinquency)
levels(loans$is_high) <- list( not_high = 0:4, high=5:18 )
summary(factor(loans$is_high)) # problem

# Make date variable : day, month, year #inspect how it plots

#Age:

library(tidyr)
loans2 <- separate(data = loans, col = BirthDate, into = c('day_birth', 'month_birth', 'year_birth'))
View(loans2)
class(loans2$year_birth)
loans2$year <- as.numeric(loans2$year_birth)
class(loans2$year_birht)
loans2$age <- 2021-loans2$year_birth
hist(loans2$age)
plot(loans2$age, loans2$LateInstallments)
#Age at disbursement:
#Age groups:

loans2$date.new <- as.Date(as.character(loans$BirthDate), format="%m/%d/%Y")
loans2$date.now <- as.Date(as.character(loans$DisbursementDate), format="%m/%d/%Y")
loans2$age_at_disbusement <- loans$date.new - loans$date.now
loans2$age <- as.numeric(loans2$DisbursementDate - loans2$BirthDate) %/% 365.25
#Separate year from BirthDate column:

#
library(dplyr)
loans_per_customer<- tally(group_by(loans, CustomerId))
loans_per_customer <- as.numeric(loans_per_customer)
hist(loans_per_customer)



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

## REGRESSIONS: 
# Not appropriate: simple OLS (with Late Installments)
# simple regression with time and individual FE : PROBLEM: assumptions violated, estimates are not consistent
lm1 <- lm(loans$LateInstallments ~ factor(loans$Gender) + factor(loans$MaritalStatus) + loans$DisbursedAmount + factor(loans$ProductGroup1Name) + factor(loans$CustomerId) + loans$WorkDaysLoanWasInArrears)
summary(lm1)

# tobit : for late installments
# adequate because of truncated data (lots of zeros), 
# it is called " censored regression"
# interpretation - signal, but for magnitude, calculate the marginal effect
#https://stats.idre.ucla.edu/r/dae/tobit-models/
require(ggplot2)
require(GGally)
require(VGAM)

# ologit: for categorical variable (Deliquency rates: none, low, medium, high)
# First we evaluate at the mean:
require(foreign)
require(ggplot2)
require(MASS)
require(Hmisc)
require(reshape2)
# https://stats.idre.ucla.edu/r/dae/ordinal-logistic-regression/

mspread = mean(spread)
margins(ologit1, at =list(spread=mspread))

#Let's try over a range from 1 to 10
margins(ologit1, at =list(spread=1:10))

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