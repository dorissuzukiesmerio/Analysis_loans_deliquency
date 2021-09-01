### HOPE Analysis for Delinquency Rates 

#### Objective:

Analyze the dataset for trends correlating to higher client delinquency, as well as trends correlating to lower client delinquency

#### Exploratory analysis of the data:

> Understanding the dataset and seeking initial correlation insights

Descriptive statistics tables, boxplots and histograms reveal that :

- Distribution of Late Installments has clustering of values on zero : need to account for that in the model if "LateInstallements" is used as dependent variable
- Tables of variables and Delinquency seem to indicate relevant correlation with Date
-  82% of BirthDate are missing : which means that we either drop them (if missing values occurrence is random such as subset will meet the condition of being a random sample of the population), or impute values (check how good the explanatory variables are in predicting : train and testing). Testing the regressions with and without the missing data, and realizing the results didn't change too much, I chose to use the subset, which I called " withage"

##### Variables created :

- Delinquency levels (categorical from LateInstallements)
- Dummies for high and low delinquency (1 if high delinquency, 0 if not; 1 if low delinquency, 0 if not)
- Age (continuous from BirthDate)  and Age Groups (categorical)
- Disbursement YearMonth 

#### Methods: 

> ##### Models for y = dummy variable
>
>  y =  dummy for high delinquency ; y = dummy for low delinquency

1) Linear Probability Model (Despite limitations, it is a helpful model to include)

2) Logit

3) Probit

Interpretation : one unit change in x is correlated with beta% (or margin%) change in probability of higher/lower delinquency; *** indicate statistical significance

#### Results:  

> Table statistics "Delinquency rates per Marital Status, Gender, Product, Disbursement Date (YearMonth) " (See appendix)

- loans disbursed just before the outburst of the pandemic ( from December 2019 to March 2020 ) had the highest delinquency rates (possible explanation: expectations of ability to pay were trampled by lockdowns)
- from approximately September 2020 to present : lowest delinquency rates (possible explanation: besides being most recent, so less time to have late installment, those who took the loans were possibly a subgroup that had higher capability to not incur in delinquency )

<img src="C:\Users\doris\AppData\Roaming\Typora\typora-user-images\image-20210901012054623.png" alt="image-20210901012054623" style="zoom:33%;" />

> Regression results

Age: seems to be negatively correlated with delinquency rate (might indicate that people who are older tend to have lower delinquency rates)

Male: seems to be positively correlated with delinquency rate (might indicate that ) - though very weak magnitude

Married:  lower delinquency rate than DeFacto; no significant effect for Divorced, Separated, Single, 

obs: interpretation in relation to the DeFacto, that was taken as a benchmark	

Disbursed Amount: seems to indicate relationship, though changing magnitude would be helpful

#### Further recommendations:

- Include other variables that the literature has given evidence to be relevant in analyzing loan delinquency : location, occupation, purpose of the loan

- Ologit (ordinal logistic regression) : appropriate when the dependent variable is categorical and ordered (Desired method , however, had technical problems with "zelig" and "polr" packages)
  -  "Delinquency rate" is the variable we are trying to explain (called the dependant variable) -> It is a categorical variable (low, medium, high), not a continuous one.
- Tobit: if using "LateInstallements" as the dependent variable, it accounts for censored values on zero. Used in some research projects for loans, such as : https://assets.researchsquare.com/files/rs-684555/v1/baffb7a5-a96c-4b93-8270-694f54d20c79.pdf?c=1626786539. However: further inspect if the situation can truly hold.
- Test Machine Learning Methods for Prediction models

Other ideas : 

- Create count of other of loans per customer; date difference between disbursements ; seasonal effects (per month); difference between return and loan payment (liquidity effect);

Questions:

- What is the unit of the DisbursedAmount ? 



#### Appendix: 

Table: Delinquency by characteristics

|                                   | Low (N=47599) | Medium (N=8464) | High (N=9316) | Total (N=65379) |
| :-------------------------------- | :-----------: | :-------------: | :-----------: | :-------------: |
| **Marital Status**                |               |                 |               |                 |
| De Facto                          | 26031 (54.7%) |  4681 (55.3%)   | 5216 (56.0%)  |  35928 (55.0%)  |
| Divorced                          |  422 (0.9%)   |    73 (0.9%)    |   83 (0.9%)   |   578 (0.9%)    |
| Married                           |  4485 (9.4%)  |   691 (8.2%)    |  693 (7.4%)   |   5869 (9.0%)   |
| N/A                               |   4 (0.0%)    |    0 (0.0%)     |   0 (0.0%)    |    4 (0.0%)     |
| Separated                         |  1498 (3.1%)  |   267 (3.2%)    |  240 (2.6%)   |   2005 (3.1%)   |
| Single                            | 14107 (29.6%) |  2538 (30.0%)   | 2891 (31.0%)  |  19536 (29.9%)  |
| Widowed                           |  1052 (2.2%)  |   214 (2.5%)    |  193 (2.1%)   |   1459 (2.2%)   |
| **Gender**                        |               |                 |               |                 |
| Female                            | 28496 (59.9%) |  5197 (61.4%)   | 5368 (57.6%)  |  39061 (59.7%)  |
| Male                              | 19100 (40.1%) |  3266 (38.6%)   | 3947 (42.4%)  |  26313 (40.2%)  |
| N/A                               |   3 (0.0%)    |    1 (0.0%)     |   1 (0.0%)    |    5 (0.0%)     |
| **Product Group**                 |               |                 |               |                 |
| Group                             | 45338 (95.2%) |  8050 (95.1%)   | 8844 (94.9%)  |  62232 (95.2%)  |
| Individual/Business               |   10 (0.0%)   |    1 (0.0%)     |   1 (0.0%)    |    12 (0.0%)    |
| Staff                             |   61 (0.1%)   |    19 (0.2%)    |   4 (0.0%)    |    84 (0.1%)    |
| Telema                            |  2190 (4.6%)  |   394 (4.7%)    |  467 (5.0%)   |   3051 (4.7%)   |
| **Age Groups**                    |               |                 |               |                 |
| N-Miss                            |     39142     |      6840       |     7679      |      53661      |
| twenties                          |  310 (3.7%)   |    61 (3.8%)    |   72 (4.4%)   |   443 (3.8%)    |
| thirties                          | 2032 (24.0%)  |   395 (24.3%)   |  425 (26.0%)  |  2852 (24.3%)   |
| forties                           | 3101 (36.7%)  |   583 (35.9%)   |  594 (36.3%)  |  4278 (36.5%)   |
| fifties                           | 2431 (28.7%)  |   463 (28.5%)   |  438 (26.8%)  |  3332 (28.4%)   |
| sixties                           |  583 (6.9%)   |   122 (7.5%)    |  108 (6.6%)   |   813 (6.9%)    |
| **Disbursement Date (YearMonth)** |               |                 |               |                 |
| 201901                            |  1372 (2.9%)  |   431 (5.1%)    |  319 (3.4%)   |   2122 (3.2%)   |
| 201902                            |  1216 (2.6%)  |   451 (5.3%)    |  316 (3.4%)   |   1983 (3.0%)   |
| 201903                            |  1672 (3.5%)  |   529 (6.2%)    |  333 (3.6%)   |   2534 (3.9%)   |
| 201904                            |  1441 (3.0%)  |   563 (6.7%)    |  226 (2.4%)   |   2230 (3.4%)   |
| 201905                            |  2053 (4.3%)  |   521 (6.2%)    |  138 (1.5%)   |   2712 (4.1%)   |
| 201906                            |  2870 (6.0%)  |   526 (6.2%)    |  126 (1.4%)   |   3522 (5.4%)   |
| 201907                            |  2098 (4.4%)  |   369 (4.4%)    |  210 (2.3%)   |   2677 (4.1%)   |
| 201908                            |  1808 (3.8%)  |   278 (3.3%)    |  141 (1.5%)   |   2227 (3.4%)   |
| 201909                            |  1958 (4.1%)  |   458 (5.4%)    |  202 (2.2%)   |   2618 (4.0%)   |
| 201910                            |  1866 (3.9%)  |   506 (6.0%)    |  222 (2.4%)   |   2594 (4.0%)   |
| 201911                            |  1724 (3.6%)  |   827 (9.8%)    |  660 (7.1%)   |   3211 (4.9%)   |
| 201912                            |  1083 (2.3%)  |  1187 (14.0%)   | 2037 (21.9%)  |   4307 (6.6%)   |
| 202001                            |  282 (0.6%)   |   270 (3.2%)    | 1149 (12.3%)  |   1701 (2.6%)   |
| 202002                            |  212 (0.4%)   |   176 (2.1%)    | 1484 (15.9%)  |   1872 (2.9%)   |
| 202003                            |  153 (0.3%)   |   104 (1.2%)    |  780 (8.4%)   |   1037 (1.6%)   |
| 202005                            |   2 (0.0%)    |    0 (0.0%)     |   0 (0.0%)    |    2 (0.0%)     |
| 202006                            |  1890 (4.0%)  |    94 (1.1%)    |   30 (0.3%)   |   2014 (3.1%)   |
| 202007                            |  2443 (5.1%)  |   206 (2.4%)    |  159 (1.7%)   |   2808 (4.3%)   |
| 202008                            |  2136 (4.5%)  |   343 (4.1%)    |  476 (5.1%)   |   2955 (4.5%)   |
| 202009                            |  751 (1.6%)   |    62 (0.7%)    |   23 (0.2%)   |   836 (1.3%)    |
| 202010                            |  837 (1.8%)   |    46 (0.5%)    |   37 (0.4%)   |   920 (1.4%)    |
| 202011                            |  1478 (3.1%)  |    87 (1.0%)    |   49 (0.5%)   |   1614 (2.5%)   |
| 202012                            |  3449 (7.2%)  |   259 (3.1%)    |  137 (1.5%)   |   3845 (5.9%)   |
| 202101                            |  853 (1.8%)   |    49 (0.6%)    |   32 (0.3%)   |   934 (1.4%)    |
| 202102                            |  1136 (2.4%)  |    53 (0.6%)    |   8 (0.1%)    |   1197 (1.8%)   |
| 202103                            |  1683 (3.5%)  |    34 (0.4%)    |   16 (0.2%)   |   1733 (2.7%)   |
| 202104                            |  2067 (4.3%)  |    24 (0.3%)    |   5 (0.1%)    |   2096 (3.2%)   |
| 202105                            |  1940 (4.1%)  |    10 (0.1%)    |   1 (0.0%)    |   1951 (3.0%)   |
| 202106                            |  2884 (6.1%)  |    1 (0.0%)     |   0 (0.0%)    |   2885 (4.4%)   |
| 202107                            |  1593 (3.3%)  |    0 (0.0%)     |   0 (0.0%)    |   1593 (2.4%)   |
| 202108                            |  649 (1.4%)   |    0 (0.0%)     |   0 (0.0%)    |   649 (1.0%)    |

Boxplots:

<img src="C:\Users\doris\AppData\Roaming\Typora\typora-user-images\image-20210901013813389.png" alt="image-20210901013813389" style="zoom:25%;" />

<img src="C:\Users\doris\AppData\Roaming\Typora\typora-user-images\image-20210901013835444.png" alt="image-20210901013835444" style="zoom:25%;" />

<img src="C:\Users\doris\AppData\Roaming\Typora\typora-user-images\image-20210901013854416.png" alt="image-20210901013854416" style="zoom:25%;" />

<img src="C:\Users\doris\AppData\Roaming\Typora\typora-user-images\image-20210901013914321.png" alt="image-20210901013914321" style="zoom:25%;" />

Regression results:

 

===========================================================================================================================================================

​                                             Dependent variable:                       

​                       \--------------------------------------------------------------------------------------------------------------

​                       higher_delinquency lower_delinquency higher_delinquency lower_delinquency higher_delinquency lower_delinquency

​                          OLS        OLS       probit      probit      logistic     logistic  

​                          (1)        (2)        (3)        (4)        (5)        (6)    

\-----------------------------------------------------------------------------------------------------------------------------------------------------------

age                        -0.001*      0.001**      -0.004*      0.004**      -0.006*      0.006**   

​                         (0.0003)     (0.0004)      (0.002)      (0.002)      (0.004)      (0.003)   

​                                                                              

factor(Gender)Male                0.013**       0.005      0.078**       0.021      0.157**       0.040   

​                         (0.006)      (0.008)      (0.038)      (0.031)      (0.070)      (0.054)   

​                                                                             

factor(MaritalStatus)Divorced           0.001       -0.015       0.004       -0.059       -0.012      -0.099   

​                         (0.022)      (0.029)      (0.136)      (0.113)      (0.251)      (0.192)   

​                                                                             

factor(MaritalStatus)Married           -0.023***     0.038***     -0.156***     0.170***     -0.278***     0.283***   

​                         (0.007)      (0.009)      (0.048)      (0.039)      (0.090)      (0.068)   

​                                                                             

factor(MaritalStatus)Seperated           0.029       -0.033       0.193       -0.124       0.323       -0.218   

​                         (0.023)      (0.029)      (0.137)      (0.117)      (0.252)      (0.199)   

​                                                                              

factor(MaritalStatus)Single            -0.002       0.003       -0.011       0.016       -0.028       0.026   

​                         (0.006)      (0.008)      (0.041)      (0.034)      (0.076)      (0.058)   

​                                                                              

factor(MaritalStatus)Widowed            -0.015      -0.003       -0.088      -0.011       -0.170      -0.017   

​                         (0.017)      (0.022)      (0.107)      (0.087)      (0.197)      (0.149)   

​                                                                              

DisbursedAmount                 -0.00000***     0.00000*     -0.00000***     0.00000**    -0.00000***     0.00000**  

​                         (0.000)      (0.000)     (0.00000)     (0.00000)     (0.00000)     (0.00000)  

​                                                                              

factor(ProductGroup1Name)Individual/Business   0.360**      -0.279       6.992       -1.763*      17.336      -3.071**   

​                         (0.148)      (0.192)      (62.492)      (0.921)     (305.854)      (1.524)   

​                                                                             

factor(ProductGroup1Name)Staff                                                               

​                                                                              

​                                                                             

\-----------------------------------------------------------------------------------------------------------------------------------------------------------

Observations                    11,726      11,726       11,726      11,726       11,726      11,726   

R2                         0.301       0.295                                        

Adjusted R2                    0.299       0.292                                         

Log Likelihood                                    -3,267.948    -5,078.413     -3,267.079    -5,081.520  

Akaike Inf. Crit.                                   6,619.895     10,240.830     6,618.157     10,247.040  

Residual Std. Error (df = 11684)          0.290       0.377                                        

F Statistic (df = 41; 11684)           123.005***    119.220***                                       

===========================================================================================================================================================

Note:                                                              *p<0.1; **p<0.05; ***p<0.01