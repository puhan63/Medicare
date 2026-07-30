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

CMS Medicare Part D Files
       
		│
        ▼
  
  SQL Staging Tables
        
		│
        ▼

Data Cleaning & Validation
        
		│
        ▼
 
 Geographic Filtering
        
		│
        ▼
 
 Prescriber Deduplication
        
		│
        ▼
 
 Provider Classification
        
		│
        ▼
 
 Analytical Data Marts
        
		│
        ├──────────────► State Dashboard Dataset
        │
        ├──────────────► Provider Dashboard Dataset
        │
        └──────────────► Correlation Analysis Dataset
                                │
                                ▼
                         Tableau Dashboards

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

### Data Quality Improvements

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

**Key Findings (High-Level Insights)**

1. Prescription Volume Drives Cost
States and providers with higher claim volumes consistently show higher drug costs, indicating that utilization is the primary cost driver in Medicare Part D.
________________________________________

2. Opioid Prescribing Is Declining Relative to Total Claims
While overall prescription activity has increased over time, opioid claims have declined relative to total utilization, indicating a structural shift in prescribing behavior post-2016.
________________________________________

3. Provider Capacity Strongly Influences Utilization
Higher prescriber counts are strongly associated with increased claim volume, suggesting that system capacity is a key driver of healthcare utilization.
________________________________________

4. Opioid Activity Is Linked to Overall Prescribing Behavior
Opioid claims scale with total claims, suggesting opioid prescribing is more reflective of general prescribing intensity than isolated provider behavior.
________________________________________

5. Patient Complexity Matters
Risk score correlations show that higher patient complexity is associated with increased prescribing activity, including opioid utilization.
________________________________________

**Tableau Dashboards**

	This project produces four Tableau-ready datasets:

		•	State-level dashboard (561 rows) → trends, geography, population-adjusted analysis 
		•	Provider-level dashboard (1M+ rows) → behavioral and specialty analysis 
		•	State correlation matrix (3 rows) → system-level relationships 
		•	Provider correlation matrix (5 rows) → clinical behavior drivers 

	These support interactive dashboards for:

		•	Opioid utilization mapping 
		•	Cost and claims trends 
		•	Provider segmentation 
		•	Risk-based prescribing analysis 

**Future Enhancements**

	•	Predictive modeling for high-risk prescribers 
	•	Time-series forecasting for opioid utilization trends 
	•	County-level geographic expansion 
	•	Integration of socioeconomic and demographic data 
	•	Anomaly detection for unusual prescribing patterns

## Repository Contents

- 📄 Full SQL ETL Pipeline: [View SQL Code](https://github.com/puhan63/Medicare/blob/main/Medicare_SQL_Updated_Queries.sql)
- 📊 Tableau Dashboards (State, Provider, Correlation)
- 📁 Cleaned Analytical Data Marts
- 📘 Data Documentation
- 🧠 Feature Engineering Logic
