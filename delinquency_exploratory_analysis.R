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
#Inspecting correlation between LateInstallments and WorkDaysLoanWasInASrrears
plot(loans4$WorkDaysLoanWasInArrears, loans4$LateInstallments)
days_late_model <- lm(loans4$LateInstallments ~ loans4$WorkDaysLoanWasInArrears )
abline(days_late_model, col = "red")

# For categorical/ character variables : use "factor". Now, summary will show  how many in each category
summary(factor(loans$Gender))
summary(factor(loans$MaritalStatus))
summary(factor(loans$ProductGroup1Name))
# In visual form:
barchart(factor(loans$Gender))
barchart(factor(loans$MaritalStatus))
barchart(factor(loans$ProductGroup1Name))

plot(factor(loans$Gender), loans$LateInstallments, main = "Distribution of Late Installements per Gender", xlab = "Gender", ylab = "Number of Late Installements", col="pink")
plot(factor(loans$MaritalStatus), loans$LateInstallments, main = "Distribution of Late Installements per Marital Status", xlab = "Marital Status", ylab = "Number of Late Installements", col="purple")
plot(factor(loans$ProductGroup1Name), loans$LateInstallments, main = "Distribution of Late Installements per Product Group", xlab = "Product Group", ylab = "Number of Late Installements", col="brown")

#Dates:
summary(factor(loans$BirthDate))
summary(factor(loans$DisbursementDate))
#Boxplots with distribution of late installements per month:
plot(factor(loans4$DisbursementDate_YearMonth), loans4$LateInstallments, main = "Distribution of Late Installments per Month", xlab = "Disbursement Date (YearMonth)", ylab = "Number of Late Installments", col="yellow")

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


#inspect outliers for each variable:
#Boxplot

library(ggplot2)
ggplot(loans,aes(x=ProductGroup1Name,y=LateInstallments,
                 fill=factor(ProductGroup1Name)))+
  geom_boxplot()+
  labs(title="Boxplot for Late Installments per ProductGroup1Name",x="ProductGroup1Name",y="Late Installments")+
  theme_bw()+coord_flip()+
  theme(legend.position = "none")

ggplot(loans,aes(x=MaritalStatus,y=LateInstallments,
                 fill=factor(MaritalStatus)))+
  geom_boxplot()+
  labs(title="Boxplot for Late Installments per MaritalStatus",x="MaritalStatus",y="Late Installments")+
  theme_bw()+coord_flip()+
  theme(legend.position = "none")

ggplot(loans,aes(x=Gender,y=LateInstallments,
                 fill=factor(Gender)))+
  geom_boxplot()+
  labs(title="Boxplot for Late Installments per Gender",x="Gender",y="Late Installments")+
  theme_bw()+coord_flip()+
  theme(legend.position = "none")

ggplot(loans4,aes(x=age_groups,y=LateInstallments,
                 fill=factor(age_groups)))+
  geom_boxplot()+
  labs(title="Boxplot for Late Installments per Age Group",x="Age Group",y="Late Installments")+
  theme_bw()+coord_flip()+
  theme(legend.position = "none")

ggplot(loans4,aes(x=age_groups,y=LateInstallments,
                  fill=factor(age_groups)))+
  geom_boxplot()+
  labs(title="Boxplot for Late Installments per Age Group",x="Age Group",y="Late Installments")+
  theme_bw()+coord_flip()+
  theme(legend.position = "none")



################################## AFTER CREATING NEW VARIABLES:

# DISBURSEMENT DATE:
#Exploring the variable:
summary(loans4$DisbursementDate_YearMonth)
summary(factor(loans4$DisbursementDate_YearMonth))
plot(factor(loans4$DisbursementDate_YearMonth), loans4$LateInstallments)
plot(factor(loans4$DisbursementDate_YearMonth))