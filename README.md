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

Medicare Part D Prescribers – by Provider and Drug

Medicare Part D Prescribers – by Geography and Drug

Medicare Part D Opioid Prescribing Rates – by Geography

The Prescribers – by Provider and Drug table contained 1,048,576 records. The Prescribers – by Geography and Drug table contained 115,937 records, and the Opioid Prescribing Rates – by Geography table contained 328,891 records.

Prior to analysis, the datasets underwent a full data-quality and preprocessing workflow, including cleaning, standardization, and preparation for merging. After these procedures were completed, the integrated dataset contained 1,132,560 records. All data processing and analysis were conducted using SQL. The SQL queries used for these inspections are available [here]().
