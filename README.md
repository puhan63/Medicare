# Medicare Part D Prescription & Opioid Utilization Analytics (SQL ETL & Tableau Project)

## Quick Summary

- Built a SQL-based ETL pipeline processing 1.4M+ Medicare Part D records
- Designed state-level and provider-level analytical data marts
- Cleaned, standardized, and validated large-scale healthcare datasets
- Implemented prescriber deduplication and geographic normalization logic
- Built Tableau dashboards for opioid utilization and cost analysis
- Performed statistical correlation analysis using SQL

This project analyzes Medicare Part D prescription drug data from the Centers for Medicare & Medicaid Services (CMS) to understand how prescribing behavior, drug costs, and opioid utilization vary across U.S. states and providers over time.

The goal was not just to explore the data, but to build a production-style SQL analytics pipeline that transforms raw CMS files into clean, validated, and Tableau-ready datasets suitable for healthcare reporting and decision-making.

The final output supports two levels of analysis:

        •	System-level trends (state and national healthcare patterns)  
        •	Provider-level behavior (individual prescriber activity and risk patterns) 

## Tech Stack

- **MySQL Workbench 8.0** — SQL ETL pipeline, data validation, feature engineering, statistical analysis, and analytical data marts.
- **Tableau Public** — Interactive dashboards for state-level, provider-level, and correlation analysis.

## Data Overview

The project uses three large CMS datasets:

        •	Prescriber-level Medicare Part D claims (~1.04M records) 
        •	Drug utilization by geography (~115K records) 
        •	Opioid prescribing rates by geography (~329K records) 

All data was processed in a SQL-based ETL pipeline built from raw ingestion to final analytical marts.

## Why This Project Matters

This project reflects a real-world healthcare analytics workflow:

		•	Raw government healthcare data is messy and inconsistent 
		•	Geographic and provider-level standardization is required before analysis 
		•	Data quality issues must be tracked, not ignored 
		•	Both system-level and provider-level views are necessary for meaningful insight 

The result is a structured, validated analytics pipeline that mirrors how healthcare data is prepared in production BI environments.

## What This Project Demonstrates

* End-to-end ETL design — built a production-style SQL pipeline that transforms raw CMS Medicare Part D datasets into clean, validated, analytics-ready data marts for business intelligence reporting.
* Large-scale healthcare data processing — processed more than 1.4 million Medicare Part D records spanning 2013–2023, integrating multiple CMS datasets into a unified analytical model.
* Data quality enforcement — implemented validation rules for geographic codes, opioid prescribing rates, duplicate providers, and standardized identifiers while preserving rejected records for auditability.
* Real-world data cleaning patterns — normalized state names, ZIP codes, FIPS codes, provider specialties, and drug labels while correcting inconsistent and missing values commonly found in public healthcare datasets.
* Provider deduplication using SQL — designed NPI-based deduplication logic to retain the most representative provider record, ensuring accurate provider-level reporting across more than one million prescribers.
* Feature engineering for analytics — created population-adjusted utilization metrics, provider classifications, prescribing rates, and other derived fields to support meaningful comparisons across states and provider groups.
* Population-normalized healthcare analytics — developed per-capita utilization measures that enable fair geographic comparisons independent of population size.
* Statistical analysis in SQL — implemented Pearson correlation calculations directly in SQL to quantify relationships among prescription volume, drug cost, provider supply, patient complexity, and opioid utilization.
* Business intelligence dashboard design — produced Tableau-ready analytical data marts powering interactive dashboards for state trends, provider behavior, opioid utilization, and statistical correlation analysis.
* Healthcare reporting and decision support — translated complex Medicare Part D data into executive-level insights supporting public health monitoring, prescribing behavior analysis, and healthcare resource planning.

## Key Questions This Project Answers:

        •	How has overall prescription activity changed from 2013–2023? 
        •	Are opioid prescriptions increasing or decoupling from total prescribing trends? 
        •	Which states have the highest opioid utilization relative to population? 
        •	How do provider types differ in prescribing behavior? 
        •	What drives prescription volume more: patient population, provider count, or cost? 
        •	Is opioid prescribing more strongly linked to system scale or provider behavior? 

## Project Architecture

The project follows a modular SQL-based ETL architecture that transforms raw CMS Medicare Part D data into validated, analytics-ready datasets for Tableau reporting and statistical analysis. The pipeline separates data ingestion, validation, cleaning, feature engineering, analytical modeling, and reporting into distinct stages, making the workflow easier to maintain, audit, and extend.

```text
                 CMS Medicare Part D Source Files
      (Prescribers, Drug Utilization, Opioid Trends)
                           │
                           ▼
                  SQL Staging Tables
                           │
                           ▼
             Data Validation & Quality Checks
                           │
                           ▼
          Cleaning & Standardization
                           │
                           ▼
           Geographic Normalization
                           │
                           ▼
            Prescriber Deduplication
                           │
                           ▼
             Provider Classification
                           │
                           ▼
            Feature Engineering
                           │
                           ▼
               Analytical Data Marts
                           │
          ┌────────────────┼────────────────┐
          │                │                │
          ▼                ▼                ▼
 State Dashboard     Provider Dashboard   Correlation Datasets
     Dataset              Dataset
          │                │                │
          └────────────────┼────────────────┘
                           │
                           ▼
             Interactive Tableau Dashboards
```

The ETL pipeline produces four analytics-ready datasets that support interactive Tableau dashboards for state-level prescription trends, provider performance, opioid utilization, and statistical correlation analysis. Because the datasets are fully validated, standardized, and feature engineered within SQL, no additional data preparation is required in the reporting layer.

📘 **For detailed technical documentation—including the ETL architecture, validation framework, SQL implementation, feature engineering, statistical methodology, dashboard design, and database optimization—see [Technical_Design.md](Technical_Design.md).**

## Project Scale

***Total pipeline volume: ~1.48M healthcare records processed across three Medicare Part D datasets (2013–2023).***

| Metric | Value |
|---------|---------:|
| Prescriber Records | 1,039,307 |
| Drug Utilization Records | 115,000+ |
| Opioid Trend Records | 329,000+ |
| States Covered | 51 |
| Years Covered | 2013–2023 |
| Final Tableau Datasets | 4 |
| Unique Prescribers (NPI) | 1,039,307 |

### Validation Results

| Validation Step | Result |
|-----------------|---------|
| Geographic Validation | 9,268 invalid records removed |
| Opioid Rate Validation | 312,000+ values corrected |
| State/FIPS Standardization | Completed |
| Prescriber Deduplication | 1.04M unique providers retained |
| ETL Audit Logging | Implemented |

## Data Quality

The ETL pipeline performs comprehensive data quality validation and standardization before records enter the analytical data marts. Rather than removing questionable data without explanation, the pipeline applies reproducible validation rules, preserves auditability, and ensures that downstream analyses are based on consistent, reliable data.

### Validation and Cleaning Performed

* Geographic validation to remove non-U.S. states, territories, military addresses, and invalid location codes
* State, ZIP code, and FIPS code standardization across all datasets
* Prescriber deduplication using National Provider Identifier (NPI) while retaining the record with the highest claims volume
* Text standardization for provider names, specialties, and drug descriptions
* Opioid prescribing rate validation by converting invalid values outside the expected 0–1 range to NULL while preserving the original records
* Population normalization to enable fair comparisons across states of different sizes
* Cross-dataset validation to ensure geographic consistency between prescriber, utilization, and opioid datasets

## Data Quality Results

| Validation Process         | Result                                    |
| -------------------------- | ----------------------------------------- |
| Geographic validation      | 9,268 invalid records removed             |
| Prescriber deduplication   | 1,039,307 unique providers retained       |
| Opioid rate validation     | 312,000+ invalid values corrected         |
| State/FIPS standardization | Completed across all datasets             |
| ETL audit logging          | Implemented for all major transformations |

The cleaned and validated datasets were then transformed into analytics-ready data marts used directly by the Tableau dashboards and statistical analyses, eliminating the need for additional data preparation during reporting.

📘 Additional implementation details, SQL logic, and transformation methodology are documented in Technical_Design.md.

## Final Analytical Datasets

The ETL pipeline produces four analytics-ready datasets designed specifically for business intelligence reporting and statistical analysis. Each dataset contains validated, standardized, and engineered features that require no additional data preparation before use in Tableau.

### Final Outputs

* tableau_state_dashboard — State-level dataset containing annual prescription utilization, opioid prescribing metrics, healthcare costs, provider counts, and population-normalized measures for all 50 states and the District of Columbia (561 rows).
* tableau_provider_dashboard — Provider-level dataset containing more than 1 million deduplicated prescriber records with provider classifications, prescription utilization, opioid prescribing activity, beneficiary counts, and cost metrics.
* tableau_state_correlation — Statistical summary dataset containing Pearson correlation coefficients that quantify relationships between statewide prescription volume, opioid utilization, healthcare costs, provider counts, and population-adjusted metrics.
* tableau_provider_correlation — Statistical summary dataset measuring relationships between provider-level prescribing behavior, opioid utilization, beneficiary volume, total claims, drug costs, and patient complexity indicators.

These analytical datasets serve as the direct data source for the Tableau dashboards and SQL-based statistical analyses, requiring no additional joins, cleaning, or transformation within the reporting layer.


## Technical Design Documentation

Detailed technical documentation describing the design and implementation of the ETL pipeline is available in Technical_Design.md.

The document includes:

* ETL architecture and workflow
* Data ingestion strategy
* Data validation and quality framework
* Cleaning and standardization methodology
* Prescriber deduplication logic
* Feature engineering and provider classification
* Statistical analysis methodology
* Tableau dashboard design
* SQL implementation details and design decisions
* Database indexing and performance considerations

📘 Technical_Design.md

## SQL Pipeline

The complete SQL ETL pipeline that powers this project is available here:

📄 Medicare_Part_D_ETL.sql

The pipeline performs:

- Bulk ingestion of CMS Medicare Part D source files into SQL staging tables
- Data cleaning, validation, and standardization
- Geographic filtering and normalization of state, ZIP code, and FIPS data
- Prescriber deduplication using National Provider Identifier (NPI)
- Provider classification into clinically meaningful groups
- Population-normalized metric calculations for state-level comparisons
- Feature engineering for business intelligence reporting
- Statistical analysis using SQL-based Pearson correlation calculations
- Creation of analytics-ready data marts for Tableau dashboards
- ETL audit logging to support data quality tracking and reproducibility

## SQL Analysis

The investigative SQL queries used to validate ETL results, verify business rules, analyze data quality issues, and perform statistical correlation analysis are available here:

📄 **[Medicare_Part_D_SQL_Analysis.sql](https://github.com/puhan63/Medicare-Part-D/blob/main/Medicare_Part_D_SQL_Analysis.sql)**

The analysis script includes:

- Data quality verification
- Geographic validation analysis
- Prescriber deduplication verification
- Opioid prescribing trend analysis
- Population-normalized state comparisons
- Provider utilization analysis
- Pearson correlation calculations
- Validation of analytical data marts

## Statistical Correlation Analysis

In addition to building analytics-ready datasets, this project performs statistical analysis directly within SQL to quantify relationships between healthcare utilization, prescribing behavior, provider characteristics, and drug costs.

Pearson correlation coefficients were calculated using SQL aggregate functions to measure the strength and direction of relationships between key healthcare metrics at both the state and provider levels.

The analysis investigates questions such as:

- How strongly prescription volume is associated with total drug cost
- Whether opioid prescribing increases proportionally with overall prescribing activity
- The relationship between provider supply and prescription utilization
- How beneficiary volume influences prescribing behavior
- Whether patient complexity is associated with higher prescribing activity

The statistical results are stored in dedicated analytical datasets that feed the Tableau correlation dashboards:

- `tableau_state_correlation`
- `tableau_provider_correlation`

These datasets provide quantitative evidence supporting the business insights presented throughout the project and demonstrate how SQL can be used for both data engineering and statistical analysis within a healthcare analytics workflow.

📘 **Additional details, SQL implementation, mathematical methodology, and interpretation of the correlation analyses are documented in [Technical_Design.md](Technical_Design.md).**

**Interactive Tableau Dashboards**

This project includes a multi-dashboard Tableau solution consisting of a landing page and three analytical dashboards. The dashboards allow users to explore Medicare Part D utilization patterns at both the state and provider levels.

**View Interactive Tableau Dashboard:**  
[Medicare Part D Utilization Analytics Dashboard](https://public.tableau.com/app/profile/patricia.uhan/viz/Medicare_Part_D_Final/ProjectOverview?publish=yes)

**Dashboard Navigation**

![Landing Page](https://github.com/puhan63/Medicare/blob/main/Project%20Overview.png)

**State-Level Dataset (Executive View)**

**State-Level Dashboard**

![State Dashboard](https://github.com/puhan63/Medicare/blob/main/Medicare%20Part%20D%20and%20Opioid%20Utilization%20Trends.png)

**Provider-Level Dataset (Clinical Behavior View)**

**Provider-Level Dashboard**

![Provider Dashboard](https://github.com/puhan63/Medicare/blob/main/Prescriber%20Workforce%20and%20Healthcare%20Utilization.png)

**Statistical Analysis Layer**

**Correlation Analysis Dashboard**

![Correlation Dashboard](https://github.com/puhan63/Medicare/blob/main/Drivers%20of%20Medicare%20Utilization%20and%20Opioid%20Prescribing.png)

## Key Findings (High-Level Insights)

***Answers to the key questions above, based on the dashboard results:***

* Prescription volume is the primary driver of Medicare Part D spending — States and provider groups with the highest prescription volumes consistently generated the highest total drug costs, indicating that utilization, rather than unusually expensive prescriptions, is the dominant contributor to overall spending.
* Opioid prescribing has declined relative to overall Medicare Part D utilization — Although total prescription activity increased across the 2013–2023 study period, opioid prescribing represented a progressively smaller share of total prescriptions, reflecting long-term changes in prescribing practices following national opioid stewardship initiatives.
* Population-adjusted metrics reveal meaningful geographic differences — Normalizing prescription activity by state population identified states with disproportionately high opioid utilization that were not necessarily those with the highest raw prescription volumes, demonstrating the importance of per-capita analysis for fair geographic comparisons.
* Provider supply is strongly associated with prescription utilization — States with larger prescriber workforces consistently generated higher prescription volumes, suggesting that healthcare system capacity is a major contributor to utilization patterns.
* Provider prescribing behavior is closely tied to overall prescribing intensity — High-volume prescribers generally wrote more opioid prescriptions as well, indicating that opioid utilization is more strongly associated with overall prescribing activity than with isolated provider behavior.
* SQL-based correlation analysis quantified relationships across healthcare utilization metrics — Pearson correlation calculations performed directly in SQL demonstrated measurable relationships among prescription volume, drug costs, beneficiary counts, provider supply, and opioid prescribing, providing statistical evidence to support the dashboard findings.

## Detailed Dashboard Insights

### State Utilization Dashboard

- Prescription utilization increased steadily across the 2013–2023 study period.
- Population-adjusted opioid prescribing varied considerably across states, highlighting geographic differences that are less visible in raw prescription counts.
- Total drug costs closely tracked overall prescription volume, reinforcing utilization as the primary spending driver.

### Provider Performance Dashboard

- Prescription activity differed substantially across provider classifications, with physician groups accounting for the majority of Medicare Part D claims.
- High-volume prescribers also tended to generate higher opioid prescription counts, although prescribing intensity varied by provider group.
- Provider classification simplified thousands of specialty descriptions into clinically meaningful categories for downstream analysis.

### Statistical Correlation Dashboard

- Strong positive relationships were observed between prescription volume and total drug cost.
- Provider supply was positively associated with overall prescription utilization.
- Beneficiary volume, prescription activity, and opioid utilization demonstrated measurable statistical relationships that support the project's healthcare utilization findings.

## Future Enhancements

	•	Predictive modeling for high-risk prescribers 
	•	Time-series forecasting for opioid utilization trends 
	•	County-level geographic expansion 
	•	Integration of socioeconomic and demographic data 
	•	Anomaly detection for unusual prescribing patterns

## Requirements

- MySQL Workbench 8.0
- CMS Medicare Part D source files (2013–2023)
- Tableau Public (optional, for viewing and recreating the dashboards)

## How To Run

1. Set up a MySQL Workbench 8.0 environment and ensure `local_infile` is enabled for bulk data loading.
2. Clone this repository and update the file paths in the `LOAD DATA LOCAL INFILE` statements so they point to your local copies of the CMS Medicare Part D source files.
3. Run `Medicare_Part_D_ETL.sql` from beginning to end. The script performs the complete ETL workflow, including raw data ingestion, validation, cleaning, standardization, feature engineering, provider deduplication, analytical data mart creation, and ETL audit logging.
4. Query the final analytical datasets directly, or connect Tableau Public (or another BI tool) to the completed data marts for interactive reporting.
5. Optionally, run `Medicare_Part_D_SQL_Analysis.sql` to review the investigative SQL queries used to validate ETL results, verify business rules, analyze data quality, and reproduce the statistical correlation analyses presented in the dashboards.

## Repository Contents

| File                             | Description                                                                         |
| -------------------------------- | ----------------------------------------------------------------------------------- |
| README.md                        | Project overview, architecture, dashboard previews, setup instructions              |
| Technical_Design.md              | ETL architecture, validation framework, SQL implementation, dashboard documentation |
| Medicare_Part_D_ETL.sql          | Complete SQL ETL pipeline                                                           |
| Medicare_Part_D_SQL_Analysis.sql | Read-only SQL analysis and validation queries                                       |
| Tableau Workbook                 | Interactive dashboards                                                              |
| Analytical Data Marts            | Final Tableau-ready datasets                                                        |
