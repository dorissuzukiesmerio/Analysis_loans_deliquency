#####EXPLORATORY ANALYSIS######

rm(list = ls())
library(readr)
loans <- read_csv("HOPE_International/HOPELoansSince2019.csv")

#Understanding the data
colnames(loans) #Variable names
View(loans) #General overview of the dataset

#Descriptive statistics of continuous variables: 
#(Min. 1st Qu.  Median    Mean 3rd Qu.    Max.):
summary(loans$DisbursedAmount)
summary(loans$LateInstallments)
summary(loans$WorkDaysLoanWasInArrears)
#In visual form:
boxplot(loans$DisbursedAmount)
boxplot(loans$LateInstallments)
boxplot(loans$WorkDaysLoanWasInArrears)

hist(loans$DisbursedAmount, 500)
hist(loans$LateInstallments, 17)
hist(loans$WorkDaysLoanWasInArrears, 30)

# For categorical/ character variables : use "factor". Now, summary will show  how many in each category
summary(factor(loans$Gender))
summary(factor(loans$MaritalStatus))
summary(factor(loans$ProductGroup1Name))
# In visual form:
barchart(factor(loans$Gender))
barchart(factor(loans$MaritalStatus))
barchart(factor(loans$ProductGroup1Name))

#Dates:
summary(factor(loans$BirthDate))
summary(factor(loans$DisbursementDate))

#just checking, but not too relevant to know its statistics:
summary(loans$CustomerId) # from 100112 to 165421
summary(loans$LoanID)

# Obs: I could have done in one code : summary(loans), but then would need to first create new variables for the categorical ones
#Check: unique LoanID and unique Customer ? No. See distribution of loans per customer
#See histogram
hist(loans$CustomerId, 65421, main="CustomerID", xlab="CustomerID", ylab="Number of loans per customer")

#Count how many customers have a certain number of loans
# insight: create variable to how many loans each customer has had and include that in analysis
# However: be careful since the  individual FE may capture that ? check

#install.packages("plyr") # if not installed previously
library(plyr)
count(loans, c("loans$CustomerId", "loans$LoanID"))
# Maybe: some info about difference of date between disbursements ? (create variable)

#inspect missing data:
summary(loans)

#inspect distribution of the variables

# Histograms:
##histogram of LateInstallments:
hist(loans$LateInstallments, main="Distribution of Number of Late Installments per Loan", xlab="Number of late installments per loan", ylab="Number of loans")
#Nicer look:
install.packages("ggplot2")
library(ggplot)
ggplot2(data=loans4, aes(loans4$LateInstallments)) + 
  geom_histogram(aes(y =..density..), 
                 breaks=seq(20, 50, by = 2), 
                 col="purple", 
                 fill="orange", 
                 alpha=.2) + 
  geom_density(col=2) + 
  labs(title="Number of Late Installement per loan", x=" Count of late Installements", y="Number of loans")

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
       aes(x = LateInstallments, y = ProductGroup1Name)) +
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


################################## AFTER CREATING NEW VARIABLES:

# DISBURSEMENT DATE:
#Exploring the variable:
summary(loans4$monthyear_Disbursement.num)
summary(factor(loans4$monthyear_Disbursement.num))
plot(factor(loans4$monthyear_Disbursement.num), loans4$LateInstallments)
plot(factor(loans4$monthyear_Disbursement.num))