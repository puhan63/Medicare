# Technical Design

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
