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

- Ologit (ordinal logistic regression) : appropriate when the dependent variable is categorical and ordered
  -  "Delinquency rate" is the variable we are trying to explain (called the dependant variable) -> It is a categorical variable (low, medium, high), not a continuous one.
- Logit with 

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

Questions:

- What is the unit of the DisbursedAmount ? 



Table: Deliquency by characteristics

|                                              | Low (N=47599) | Medium (N=8464) | High (N=9316) | Total (N=65379) | p value |
| :------------------------------------------- | :-----------: | :-------------: | :-----------: | :-------------: | ------: |
| **MaritalStatus**                            |               |                 |               |                 | < 0.001 |
| De Facto                                     | 26031 (54.7%) |  4681 (55.3%)   | 5216 (56.0%)  |  35928 (55.0%)  |         |
| Divorced                                     |  422 (0.9%)   |    73 (0.9%)    |   83 (0.9%)   |   578 (0.9%)    |         |
| Married                                      |  4485 (9.4%)  |   691 (8.2%)    |  693 (7.4%)   |   5869 (9.0%)   |         |
| N/A                                          |   4 (0.0%)    |    0 (0.0%)     |   0 (0.0%)    |    4 (0.0%)     |         |
| Seperated                                    |  1498 (3.1%)  |   267 (3.2%)    |  240 (2.6%)   |   2005 (3.1%)   |         |
| Single                                       | 14107 (29.6%) |  2538 (30.0%)   | 2891 (31.0%)  |  19536 (29.9%)  |         |
| Widowed                                      |  1052 (2.2%)  |   214 (2.5%)    |  193 (2.1%)   |   1459 (2.2%)   |         |
| **Gender**                                   |               |                 |               |                 | < 0.001 |
| Female                                       | 28496 (59.9%) |  5197 (61.4%)   | 5368 (57.6%)  |  39061 (59.7%)  |         |
| Male                                         | 19100 (40.1%) |  3266 (38.6%)   | 3947 (42.4%)  |  26313 (40.2%)  |         |
| N/A                                          |   3 (0.0%)    |    1 (0.0%)     |   1 (0.0%)    |    5 (0.0%)     |         |
| **ProductGroup1Name**                        |               |                 |               |                 |   0.020 |
| Group                                        | 45338 (95.2%) |  8050 (95.1%)   | 8844 (94.9%)  |  62232 (95.2%)  |         |
| Individual/Business                          |   10 (0.0%)   |    1 (0.0%)     |   1 (0.0%)    |    12 (0.0%)    |         |
| Staff                                        |   61 (0.1%)   |    19 (0.2%)    |   4 (0.0%)    |    84 (0.1%)    |         |
| Telema                                       |  2190 (4.6%)  |   394 (4.7%)    |  467 (5.0%)   |   3051 (4.7%)   |         |
| **age_groups**                               |               |                 |               |                 |   0.063 |
| N-Miss                                       |     39142     |      6840       |     7679      |      53661      |         |
| twenties                                     |  310 (3.7%)   |    61 (3.8%)    |   72 (4.4%)   |   443 (3.8%)    |         |
| thirties                                     | 2032 (24.0%)  |   395 (24.3%)   |  425 (26.0%)  |  2852 (24.3%)   |         |
| forties                                      | 3101 (36.7%)  |   583 (35.9%)   |  594 (36.3%)  |  4278 (36.5%)   |         |
| fifties                                      | 2431 (28.7%)  |   463 (28.5%)   |  438 (26.8%)  |  3332 (28.4%)   |         |
| sixties                                      |  583 (6.9%)   |   122 (7.5%)    |  108 (6.6%)   |   813 (6.9%)    |         |
| **as.character(DisbursementDate_YearMonth)** |               |                 |               |                 | < 0.001 |
| 201901                                       |  1372 (2.9%)  |   431 (5.1%)    |  319 (3.4%)   |   2122 (3.2%)   |         |
| 201902                                       |  1216 (2.6%)  |   451 (5.3%)    |  316 (3.4%)   |   1983 (3.0%)   |         |
| 201903                                       |  1672 (3.5%)  |   529 (6.2%)    |  333 (3.6%)   |   2534 (3.9%)   |         |
| 201904                                       |  1441 (3.0%)  |   563 (6.7%)    |  226 (2.4%)   |   2230 (3.4%)   |         |
| 201905                                       |  2053 (4.3%)  |   521 (6.2%)    |  138 (1.5%)   |   2712 (4.1%)   |         |
| 201906                                       |  2870 (6.0%)  |   526 (6.2%)    |  126 (1.4%)   |   3522 (5.4%)   |         |
| 201907                                       |  2098 (4.4%)  |   369 (4.4%)    |  210 (2.3%)   |   2677 (4.1%)   |         |
| 201908                                       |  1808 (3.8%)  |   278 (3.3%)    |  141 (1.5%)   |   2227 (3.4%)   |         |
| 201909                                       |  1958 (4.1%)  |   458 (5.4%)    |  202 (2.2%)   |   2618 (4.0%)   |         |
| 201910                                       |  1866 (3.9%)  |   506 (6.0%)    |  222 (2.4%)   |   2594 (4.0%)   |         |
| 201911                                       |  1724 (3.6%)  |   827 (9.8%)    |  660 (7.1%)   |   3211 (4.9%)   |         |
| 201912                                       |  1083 (2.3%)  |  1187 (14.0%)   | 2037 (21.9%)  |   4307 (6.6%)   |         |
| 202001                                       |  282 (0.6%)   |   270 (3.2%)    | 1149 (12.3%)  |   1701 (2.6%)   |         |
| 202002                                       |  212 (0.4%)   |   176 (2.1%)    | 1484 (15.9%)  |   1872 (2.9%)   |         |
| 202003                                       |  153 (0.3%)   |   104 (1.2%)    |  780 (8.4%)   |   1037 (1.6%)   |         |
| 202005                                       |   2 (0.0%)    |    0 (0.0%)     |   0 (0.0%)    |    2 (0.0%)     |         |
| 202006                                       |  1890 (4.0%)  |    94 (1.1%)    |   30 (0.3%)   |   2014 (3.1%)   |         |
| 202007                                       |  2443 (5.1%)  |   206 (2.4%)    |  159 (1.7%)   |   2808 (4.3%)   |         |
| 202008                                       |  2136 (4.5%)  |   343 (4.1%)    |  476 (5.1%)   |   2955 (4.5%)   |         |
| 202009                                       |  751 (1.6%)   |    62 (0.7%)    |   23 (0.2%)   |   836 (1.3%)    |         |
| 202010                                       |  837 (1.8%)   |    46 (0.5%)    |   37 (0.4%)   |   920 (1.4%)    |         |
| 202011                                       |  1478 (3.1%)  |    87 (1.0%)    |   49 (0.5%)   |   1614 (2.5%)   |         |
| 202012                                       |  3449 (7.2%)  |   259 (3.1%)    |  137 (1.5%)   |   3845 (5.9%)   |         |
| 202101                                       |  853 (1.8%)   |    49 (0.6%)    |   32 (0.3%)   |   934 (1.4%)    |         |
| 202102                                       |  1136 (2.4%)  |    53 (0.6%)    |   8 (0.1%)    |   1197 (1.8%)   |         |
| 202103                                       |  1683 (3.5%)  |    34 (0.4%)    |   16 (0.2%)   |   1733 (2.7%)   |         |
| 202104                                       |  2067 (4.3%)  |    24 (0.3%)    |   5 (0.1%)    |   2096 (3.2%)   |         |
| 202105                                       |  1940 (4.1%)  |    10 (0.1%)    |   1 (0.0%)    |   1951 (3.0%)   |         |
| 202106                                       |  2884 (6.1%)  |    1 (0.0%)     |   0 (0.0%)    |   2885 (4.4%)   |         |
| 202107                                       |  1593 (3.3%)  |    0 (0.0%)     |   0 (0.0%)    |   1593 (2.4%)   |         |
| 202108                                       |  649 (1.4%)   |    0 (0.0%)     |   0 (0.0%)    |   649 (1.0%)    |         |

