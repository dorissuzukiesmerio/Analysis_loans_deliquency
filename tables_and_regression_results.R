################################### Tables:

#Deliquency rates per marital status:
Delinquency_per_MaritalStatus <- table(loans4$MaritalStatus, loans4$Delinquency)
Delinquency_per_MaritalStatus

#obs: rename column for typo (If I have time): Seperated to Separated

install.packages("arsenal")
library(arsenal) 
table_one <- tableby(Delinquency ~ MaritalStatus + Gender + ProductGroup1Name , data = loans4) 
summary(table_one, title = "Gapminder Data")
# create categories age groups and disbursement amounts

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

#######Dummies : higher_delinquency and lower_delinquency######

# Linear Probability Model : simple, not best approach
lm1 <- lm(higher_delinquency ~ age + factor(Gender) + factor(MaritalStatus) + DisbursedAmount + factor(ProductGroup1Name) + factor(DisbursementDate_YearMonth), data = loans4)
summary(lm1)

lm2 <- lm(lower_delinquency ~ age + factor(Gender) + factor(MaritalStatus) + DisbursedAmount + factor(ProductGroup1Name) + factor(DisbursementDate_YearMonth), data = loans4)
summary(lm2)

# Probit :
probit1 <- glm(higher_delinquency ~ age + factor(Gender) + factor(MaritalStatus) + DisbursedAmount + factor(ProductGroup1Name) + factor(DisbursementDate_YearMonth),
               family=binomial (link=probit), data = loans4)
summary(probit1)

probit2 <- glm(lower_delinquency ~ age + factor(Gender) + factor(MaritalStatus) + DisbursedAmount + factor(ProductGroup1Name) + factor(DisbursementDate_YearMonth), 
               family=binomial (link=probit), data = loans4)
summary(probit2)

# Logit:

logit1 <- glm(higher_delinquency ~ age + factor(Gender) + factor(MaritalStatus) + DisbursedAmount + factor(ProductGroup1Name) + factor(DisbursementDate_YearMonth),
               family=binomial (link=logit), data = loans4)
summary(logit1)

logit2 <- glm(lower_delinquency ~ age + factor(Gender) + factor(MaritalStatus) + DisbursedAmount + factor(ProductGroup1Name) + factor(DisbursementDate_YearMonth), 
               family=binomial (link=logit), data = loans4)
summary(logit2)

### Levels

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
#Using Zelig:
install.packages("remotes")
library(remotes)
install_github("cran/zelig")
library(Zelig)
ologit1.z <- zelig( Delinquency ~ age + factor(Gender) + factor(MaritalStatus) + factor(ProductGroup1Name) , 
                    model = "ologit", data = subset)

summary(ologit1.z)

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





