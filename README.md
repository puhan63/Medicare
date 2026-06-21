# Medicare Part D Prescription & Opioid Utilization Analytics (SQL ETL & Tableau Project)
This project analyzes Medicare Part D prescription drug data from the Centers for Medicare & Medicaid Services (CMS) to understand how prescribing behavior, drug costs, and opioid utilization vary across U.S. states and providers over time.

The goal was not just to explore the data, but to build a production-style SQL analytics pipeline that transforms raw CMS files into clean, validated, and Tableau-ready datasets suitable for healthcare reporting and decision-making.

The final output supports two levels of analysis:

        •	System-level trends (state and national healthcare patterns)  
        •	Provider-level behavior (individual prescriber activity and risk patterns) 

**Key Questions This Project Answers:**

        •	How has overall prescription activity changed from 2013–2023? 
        •	Are opioid prescriptions increasing or decoupling from total prescribing trends? 
        •	Which states have the highest opioid utilization relative to population? 
        •	How do provider types differ in prescribing behavior? 
        •	What drives prescription volume more: patient population, provider count, or cost? 
        •	Is opioid prescribing more strongly linked to system scale or provider behavior? 

**Project Architecture**

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

**Project Scale**

***1.4M+ healthcare records processed***

| Metric | Value |
|---------|---------:|
| Prescriber Records | 1,039,307 |
| Drug Utilization Records | 115,000+ |
| Opioid Trend Records | 329,000+ |
| States Covered | 51 |
| Years Covered | 2013–2023 |
| Final Tableau Datasets | 4 |
| Unique Prescribers (NPI) | 1,039,307 |

**Data Quality Improvements**

| Validation Step | Result |
|-----------------|---------|
| Geographic Validation | 9,268 invalid records removed |
| Opioid Rate Validation | 312,000+ values corrected |
| State/FIPS Standardization | Completed |
| Prescriber Deduplication | 1.04M unique providers retained |
| ETL Audit Logging | Implemented |

**Repository Contents**

Full SQL ETL Pipeline: [View SQL Code](https://github.com/puhan63/Medicare/blob/main/Medicare_SQL_Updated_Queries.sql)

**Interactive Tableau Dashboards**

This project includes a multi-dashboard Tableau solution consisting of a landing page and three analytical dashboards. The dashboards allow users to explore Medicare Part D utilization patterns at both the state and provider levels.

**View Interactive Tableau Dashboard:**  
[Medicare Part D Utilization Analytics Dashboard](https://public.tableau.com/app/profile/patricia.uhan/viz/Medicare_Part_D_Final/ProjectOverview?publish=yes)

**Dashboard Navigation**

![Landing Page](https://github.com/puhan63/Medicare/blob/main/Project%20Overview.png)


**Data Overview**

The project uses three large CMS datasets:

        •	Prescriber-level Medicare Part D claims (~1.04M records) 
        •	Drug utilization by geography (~115K records) 
        •	Opioid prescribing rates by geography (~329K records) 

All data was processed in a SQL-based ETL pipeline built from raw ingestion to final analytical marts.

**End-to-End Workflow**

1. Data Ingestion

        All datasets were loaded into SQL staging tables using bulk ingestion (LOAD DATA LOCAL INFILE) and preserved in raw form for reproducibility.

2. Data Cleaning & Standardization (Major Focus Area)

        A significant portion of the project focused on resolving real-world healthcare data issues:
        
        Geographic Cleaning

                •	Removed invalid and non-U.S. geographic codes (PR, VI, GU, AE, AP, AA, etc.) 
                •	Eliminated 9,268 invalid geographic records 
                •	Stored rejected records separately for auditability 

        Data Standardization

                •	Normalized state codes, ZIP codes, and FIPS codes 
                •	Standardized text fields (names, specialties, drug labels) 
                •	Ensured consistent formatting across all datasets 

        Numeric Validation

                •	Removed invalid opioid prescribing rates (<0 or >1) 
                •	Converted out-of-range values (~312K records) to NULL instead of deleting 
                •	Preserved record structure while preventing analytical distortion 

3. Prescriber Deduplication (NPI-Level Logic)

        Prescriber data often contained multiple records per provider.
        
        A deduplication strategy was implemented:

                •	Grouped by NPI 
                •	Retained record with maximum total claims per provider 

        Result:

                •	1,039,307 unique prescriber records 

4. Provider Classification (Healthcare Segmentation)

        Prescribers were grouped into clinically meaningful categories:

                •	PHYSICIAN 
                •	ADVANCED_PRACTICE 
                •	DENTAL 
                •	PODIATRY / OPTOMETRY 
                •	PHARMACY 
                •	FACILITY / ORGANIZATIONAL PROVIDERS 
                •	LOW_IMPACT_OTHER 
                •	UNKNOWN 

        This allowed downstream analysis of prescribing behavior by provider type rather than raw specialty text.

5. Geographic Validation & Filtering

        To ensure consistency in state-level reporting:

                •	Only U.S. states were retained 
                •	Territories and invalid regions were removed 
                •	State-level drug and opioid datasets were aligned using FIPS mapping 

**Key SQL Techniques**

The complete SQL ETL pipeline can be viewed here:

➡️ **[Full SQL Pipeline](https://github.com/puhan63/Medicare/blob/main/Medicare_SQL_Updated_Queries.sql)**

***Prescriber Deduplication Using SQL***

CMS source data occasionally contained duplicate NPI records. To preserve the most representative provider profile, the record with the highest claims volume was retained.

```sql
CREATE TABLE prescriber_clean AS
SELECT r.*
FROM raw_prescriber r
JOIN (
    SELECT
        npi,
        MAX(total_claims) AS max_claims
    FROM raw_prescriber
    GROUP BY npi
) m
ON r.npi = m.npi
AND r.total_claims = m.max_claims;
```

***Population-Normalized State Metrics***

To support fair state comparisons, opioid utilization and provider counts were normalized by population.

```sql
CAST(o.opioid_claims AS DECIMAL(18,4))
    / NULLIF(p.population, 0) * 1000
    AS opioid_claims_per_1000,

CAST(o.total_prescribers AS DECIMAL(18,4))
    / NULLIF(p.population, 0) * 1000
    AS prescribers_per_1000
```

***Pearson Correlation Analysis in SQL***

Relationships between prescribing volume, cost, and patient complexity were calculated directly in SQL using Pearson correlation coefficients.

```sql
(AVG(total_claims * total_drug_cost)
 - AVG(total_claims) * AVG(total_drug_cost))
/
NULLIF(
    STDDEV(total_claims)
    * STDDEV(total_drug_cost),
0)
AS corr_claims_cost
```
**State-Level Dataset (Executive View)**

**State-Level Dashboard**

![State Dashboard](https://github.com/puhan63/Medicare/blob/main/Medicare%20Part%20D%20and%20Opioid%20Utilization%20Trends.png)

This dashboard explores prescription utilization, opioid prescribing rates, population-adjusted metrics, and geographic variation across all U.S. states.

		tableau_dataset

			 •	561 rows (51 states × 11 years)

				Contains:

				•	Total claims 
                •	Opioid claims
				•	Population-adjusted metrics 
                •	Cost and utilization measures
				

				Used for:

                •	State comparisons
				•	Trend analysis
                •	Public health reporting
				•	Geographic opioid analysis

**Provider-Level Dataset (Clinical Behavior View)**

**Provider-Level Dashboard**

![Provider Dashboard](https://github.com/puhan63/Medicare/blob/main/Prescriber%20Workforce%20and%20Healthcare%20Utilization.png)

This dashboard examines prescribing behavior across provider groups, opioid utilization patterns, and high-volume prescribers.

        tableau_prescriber_dataset

                •	1,039,307 prescriber records 

				Contains: 

                •	Total claims per provider 
                •	Opioid claims 
                •	Prescriber group classification 
                •	Risk score relationships 
                •	Cost and utilization metrics 

		        Used for:

                •	Provider segmentation 
                •	High-risk prescribing analysis 
                •	Specialty comparisons 
                •	Behavioral pattern analysis 

**Statistical Analysis Layer**

**Correlation Analysis Dashboard**

![Correlation Dashboard](https://github.com/puhan63/Medicare/blob/main/Drivers%20of%20Medicare%20Utilization%20and%20Opioid%20Prescribing.png)

This dashboard visualizes relationships between claims volume, cost, provider counts, risk scores, and opioid prescribing activity.

        State Correlation Matrix

                •	Claims vs Cost 
                •	Claims vs Prescribers 
                •	Opioid Claims vs Opioid Prescribers 

        Provider Correlation Matrix

                •	Claims vs Cost 
                •	Claims vs Beneficiaries 
                •	Opioid Claims vs Total Claims 
                •	Risk Score vs Claims 
                •	Risk Score vs Opioid Claims 

        These outputs quantify relationships between healthcare utilization, cost, and prescribing behavior.

**ETL Governance & Auditability**

        An ETL audit logging system was implemented to track all major transformations:
        
        Tracked:

                •	Records removed due to invalid geography 
                •	Deduplication outcomes 
                •	Cleaning operations affecting numeric fields 

        This ensures full transparency and reproducibility of all transformations.

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

**Tools & Techniques**

	•	MySQL (ETL + analysis) 
	•	Window functions (deduplication, ranking) 
	•	Aggregations and joins 
	•	Data validation rules 
	•	Correlation analysis (SQL-based Pearson calculations) 
	•	Tableau (final visualization layer) 

**Why This Project Matters**

	This project reflects a real-world healthcare analytics workflow:

		•	Raw government healthcare data is messy and inconsistent 
		•	Geographic and provider-level standardization is required before analysis 
		•	Data quality issues must be tracked, not ignored 
		•	Both system-level and provider-level views are necessary for meaningful insight 

	The result is a structured, validated analytics pipeline that mirrors how healthcare data is prepared in production BI environments.

**Future Enhancements**

	•	Predictive modeling for high-risk prescribers 
	•	Time-series forecasting for opioid utilization trends 
	•	County-level geographic expansion 
	•	Integration of socioeconomic and demographic data 
	•	Anomaly detection for unusual prescribing patterns
