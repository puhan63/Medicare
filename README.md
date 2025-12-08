# Medicare

The Centers for Medicare & Medicaid Services (CMS) provides detailed data on prescription drugs dispensed to Medicare Part D beneficiaries. This dataset includes key information such as prescriber National Provider Identifiers (NPIs), total drug costs, brand and generic drug names, and geographic variations in prescribing behavior. Notably, the dataset also captures opioid prescribing rates at the regional level.

This project focuses on performing a comprehensive analysis of these data to identify meaningful patterns and insights related to medication utilization and prescription claims among Medicare recipients. The goal is to synthesize the information into actionable findings that enhance understanding of prescribing trends, cost dynamics, and opioid-related behaviors within the Medicare system.

**Trend Analysis:**
Conducted a year-over-year assessment of overall prescription drug claims and opioid-related claims to identify patterns, shifts, and emerging trends in medication utilization.

**Demographic Impact Assessment:**
Analyzed annual variations in prescriber counts, opioid prescriber counts, and total drug costs to understand their influence on prescribing behavior and overall claims activity.

**Performance Analysis:**
Assessed the correlations between drug cost, prescriber counts, opioid prescriber counts, and both overall and opioid-related claims to determine the strength and direction of these relationships and their impact on prescribing outcomes.

An Interactive Tableau dashboard can be downloaded [here]().

**DATA STRUCTURE & INITIAL CHECKS**

**Data Cleaning and Preparation**

The initial data source consisted of three Medicare Part D tables:

**Medicare Part D Prescribers – by Provider and Drug**

**Medicare Part D Prescribers – by Geography and Drug**

**Medicare Part D Opioid Prescribing Rates – by Geography**

*The Prescribers – by Provider and Drug* table contained 1,048,576 records. *The Prescribers – by Geography and Drug* table contained 115,937 records, and the *Opioid Prescribing Rates – by Geography* table contained 328,891 records.

Prior to analysis, the datasets underwent a full data-quality and preprocessing workflow, including cleaning, standardization, and preparation for merging. After these procedures were completed, the integrated dataset contained 1,132,560 records. All data processing and analysis were conducted using SQL. The SQL queries used for these inspections are available [here]().

**Initial Data Integrity and Quality Control**

**Missing Values and Skewness:**
An initial assessment indicated that most variables exhibited either positive or negative skewness, as well as kurtosis. Key variables of interest—including Tot_Clms, Tot_Drug_Cst, Tot_Prscrb, Tot_Opioid_Prscrb, and Tot_Opioid_Clms—demonstrated positive skewness and elevated kurtosis. Skewness and kurtosis were calculated in Excel due to its ease of use. The corresponding values are provided in the referenced table. Because Spearman’s rank correlation coefficient is less sensitive to outliers, it was selected as the primary method for assessing bivariate associations.

**Handling Incomplete Records:** 
Missing data was determined to be structured rather than random. Consequently, any row missing information from several critical columns—Tot_Prscrbr, Tot_Opioid_Clms, and Tot_Opioid_Prscrbr, which were central to the analysis objectives—was removed from the dataset which consisted of 4,920 rows. 

Duplicate Records: Duplicate records were identified using a staging table methodology. A total of 455,575 redundant rows were subsequently deleted to ensure data integrity for analysis.

Irrelevant Data: To streamline the dataset and improve processing efficiency, columns that were not relevant to the analysis objectives were removed. Columns with systematically missing data were also excluded.
