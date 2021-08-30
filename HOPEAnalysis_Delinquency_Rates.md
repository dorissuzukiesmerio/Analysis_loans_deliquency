### HOPE Analysis for Delinquency Rates 

#### Objective:

Analyze this dataset for trends correlating to higher client delinquency, as well as trends correlating to lower client delinquency:

“low delinquency” as having 0-2 late installments; 

“medium delinquency” as having 3-4 late installments;

 “high delinquency” as having 4+ late installments **per loan** (not per customer)

#### Available data:

late installments (number of loan repayments due that clients didn't make on time)

work days the loan was in arrears (AKA work days during which their loan was not up-to-date on payments owed to HOPE)

#### Understanding the data: 

Descriptive statistics tables, boxplots and histograms reveal that :

- Distribution of Late Installments has clustering of values on zero : need to account for that in  the model if "LateInstallements" is used as dependent variable
- Tables with demographic characteristics and Late Installements / Deliquency reveal correlation :

Variables created :

- Delinquency levels (from LateInstallements)

- Age (from BirthDate)
- Disbursement YearMonth : to include the dummies in the regression

#### Methods: 

Primary method:

- Ologit: appropriate when the dependent variable is categorical
  -  "Delinquency rate" is the variable we are trying to explain (called the dependant variable) -> It is a categorical variable (low, medium, high), not a continuous one.

Other methods to compare:

- OLS : however, might yield inconsistent estimates
- Tobit: if using "LateInstallements" as the dependent variable, it accounts for censored values on zero. Used in some research projects for loans. However: further inspect if the situation can truly 
- Random forest:

#### Results:  

N/A

#### Conclusion:

N/A

#### Further recommendations:

- Include other variables that the literature has given evidence to be relevant in analyzing loan delinquency : location, occupation, purpose of the loan
- Create variable : count of other of loans per customer, and date difference between disbursements 
- Small detail : Calculate age at disbursement, create age categories