# Technical Design

This document provides detailed technical documentation for the Medicare Part D Prescription & Opioid Utilization Analytics project. It describes the design and implementation of the SQL ETL pipeline, including data ingestion, validation, cleaning, feature engineering, analytical data mart creation, statistical analysis, and Tableau dashboard development.

The project processes more than 1.4 million CMS Medicare Part D records spanning 2013–2023 and demonstrates a production-style healthcare analytics workflow built entirely in MySQL Workbench 8.0. The pipeline transforms raw CMS datasets into validated, analytics-ready datasets that support interactive business intelligence dashboards and statistical analyses.

The sections below describe the architecture, implementation decisions, SQL techniques, governance, and reporting design used throughout the project.

## Table of Contents

1. [Project Architecture](#project-architecture)
2. [Project Scale](#project-scale)
3. [ETL Pipeline Design](#etl-pipeline-design)
4. [Data Ingestion](#data-ingestion)
5. [Data Validation Framework](#data-validation-framework)
6. [Data Cleaning & Standardization](#data-cleaning--standardization)
7. [Prescriber Deduplication](#prescriber-deduplication)
8. [Feature Engineering](#feature-engineering)
9. [SQL Implementation Highlights](#sql-implementation-highlights)
10. [Statistical Analysis](#statistical-analysis)
11. [Final Analytical Datasets](#final-analytical-datasets)
12. [Tableau Dashboard Design](#tableau-dashboard-design)
13. [ETL Governance & Auditability](#etl-governance--auditability)
14. [Performance Considerations](#performance-considerations)

## Project Architecture

The Medicare Part D Prescription & Opioid Utilization Analytics project follows a modular SQL-based ETL architecture that transforms raw Centers for Medicare & Medicaid Services (CMS) datasets into validated, analytics-ready data marts for business intelligence reporting and statistical analysis.

The pipeline separates data ingestion, validation, cleaning, feature engineering, analytical modeling, and reporting into distinct stages. This modular design improves maintainability, supports auditability, and allows each processing stage to be validated independently before data progresses to the next phase.

```text
              CMS Medicare Part D Source Files
    (Prescribers, Drug Utilization, Opioid Trends)
                           │
                           ▼
                  SQL Staging Tables
                           │
                           ▼
             Data Validation Framework
                           │
                           ▼
          Cleaning & Standardization
                           │
                           ▼
          Geographic Normalization
                           │
                           ▼
         Prescriber Deduplication (NPI)
                           │
                           ▼
            Provider Classification
                           │
                           ▼
              Feature Engineering
                           │
                           ▼
             Final Analytical Datasets
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
          Interactive Tableau Public Dashboards
```

### ETL Design Principles

The architecture was designed around several core principles commonly used in healthcare analytics and business intelligence environments:

- **Modular processing** — Each ETL stage performs a specific responsibility, making the pipeline easier to maintain, troubleshoot, and extend.
- **Data quality first** — Validation occurs before analytical datasets are created to ensure reporting is based on accurate, standardized, and reproducible data.
- **Auditability** — Major transformations, rejected records, and validation outcomes are preserved to support transparency and reproducibility.
- **Analytics-ready outputs** — Final datasets are fully cleaned, standardized, and feature engineered before being consumed by Tableau, eliminating the need for additional transformations within the reporting layer.
- **Scalable design** — The workflow processes more than 1.4 million Medicare Part D records while maintaining a structure that can be expanded to incorporate additional CMS datasets and future analytical requirements.

The ETL pipeline ultimately produces four analytics-ready datasets that support interactive Tableau dashboards for state-level prescription trends, provider performance, opioid utilization, and SQL-based statistical correlation analysis.

## ETL Pipeline Design

The ETL pipeline was designed to transform raw CMS Medicare Part D datasets into validated, analytics-ready datasets for business intelligence reporting and statistical analysis. Each processing stage performs a distinct function within the workflow, allowing data quality to be verified before records progress to downstream analytical tables.

### Data Ingestion

The three CMS Medicare Part D source files were loaded into SQL staging tables using `LOAD DATA LOCAL INFILE`. Raw source data was preserved without modification to provide a reproducible starting point for all downstream transformations and validation processes.

### Data Cleaning & Standardization

Following ingestion, the pipeline applied a series of cleaning and standardization procedures to improve data consistency and analytical reliability.

Major cleaning activities included:

- Standardizing state abbreviations, ZIP codes, and FIPS codes
- Normalizing provider names, specialties, and drug descriptions
- Removing invalid geographic records
- Correcting inconsistent formatting across datasets
- Validating opioid prescribing rate values
- Preserving invalid values for auditability rather than silently deleting records

### Prescriber Deduplication

CMS source data occasionally contained multiple records for the same National Provider Identifier (NPI). To ensure accurate provider-level reporting, the pipeline retained the record representing the highest prescribing activity while removing duplicate provider records.

This process produced a final dataset containing **1,039,307 unique prescribers**.

### Provider Classification

Provider specialties were consolidated into clinically meaningful categories to simplify downstream analysis and dashboard reporting.

Classification groups included:

- PHYSICIAN
- ADVANCED PRACTICE
- DENTAL
- PODIATRY / OPTOMETRY
- PHARMACY
- FACILITY / ORGANIZATIONAL PROVIDERS
- LOW IMPACT OTHER
- UNKNOWN

Grouping providers into broader categories improved comparison across specialties while reducing variability in the original CMS specialty descriptions.

### Geographic Validation

To ensure consistent state-level reporting, geographic information was validated and standardized throughout the ETL process.

Validation included:

- Removing territories, military addresses, and other non-U.S. geographic codes
- Standardizing state abbreviations and FIPS codes
- Aligning state-level utilization datasets using consistent geographic identifiers
- Removing invalid geographic records prior to analytical dataset creation

Subsequent sections describe the specific validation framework, SQL implementation details, feature engineering methodology, and statistical analyses used throughout the project.

## Data Validation Framework

Before records entered the final analytical datasets, the ETL pipeline applied a comprehensive validation framework to ensure that reporting and statistical analyses were based on accurate, consistent, and reliable data. Rather than silently removing questionable records, validation rules were designed to preserve auditability by documenting rejected records and maintaining reproducible transformation logic.

Validation occurred after raw data ingestion and before feature engineering, allowing downstream analytical datasets to be built exclusively from standardized and validated data.

### Geographic Validation

Geographic information was validated to ensure that only valid U.S. state-level records were included in the analytical datasets.

Validation activities included:

- Removing territories and non-U.S. geographic codes (PR, VI, GU, AE, AP, AA, etc.)
- Validating state abbreviations and FIPS codes
- Standardizing geographic identifiers across all CMS datasets
- Aligning state-level utilization and opioid datasets using consistent geographic mappings

This process eliminated **9,268 invalid geographic records** while preserving the rejected records for auditing purposes.

### Opioid Prescribing Rate Validation

Opioid prescribing rate variables were validated to ensure all values fell within the expected range of **0.0 to 1.0**.

Validation rules included:

- Identifying negative prescribing rates
- Identifying prescribing rates greater than 1.0
- Converting invalid values to `NULL` rather than deleting records
- Preserving record structure while preventing invalid values from distorting downstream analyses

More than **312,000 out-of-range values** were corrected during this process.

### Prescriber Validation

Provider records were validated using the National Provider Identifier (NPI) to eliminate duplicate provider profiles while preserving the most representative record for each prescriber.

Validation included:

- Identifying duplicate NPIs
- Selecting the provider record with the highest prescription volume
- Removing duplicate provider records
- Preserving one validated provider profile for each unique NPI

The final analytical dataset retained **1,039,307 unique prescribers**.

### Cross-Dataset Validation

Additional validation procedures ensured consistency across all CMS source datasets before analytical data marts were created.

Cross-dataset validation included:

- Verifying consistent geographic identifiers across datasets
- Confirming standardized state and FIPS mappings
- Validating population reference data used for normalization
- Ensuring compatible field definitions between analytical datasets

### Validation Summary

| Validation Rule | Purpose | Result |
|-----------------|---------|--------|
| Geographic validation | Remove invalid geographic records | 9,268 records removed |
| State/FIPS standardization | Standardize geographic identifiers | Completed |
| Opioid prescribing rate validation | Correct invalid utilization rates | 312,000+ values corrected |
| Prescriber validation | Remove duplicate provider records | 1,039,307 unique prescribers retained |
| Cross-dataset validation | Ensure consistent analytical inputs | Completed |

The validated datasets produced by this framework became the foundation for feature engineering, SQL-based statistical analysis, and the final Tableau-ready analytical datasets.

## Data Validation Framework

Before any transformations were applied, the ETL pipeline validated each source dataset to ensure that only reliable records progressed into the analytical layer. Validation rules were designed to identify inconsistent, incomplete, and invalid healthcare data while preserving auditability throughout the ETL process.

### Validation Rules

#### Geographic Validation

The pipeline validated geographic information across all CMS datasets by:

* Removing non-U.S. territories and military address codes (PR, VI, GU, AE, AP, AA, etc.)
* Verifying valid U.S. state abbreviations
* Confirming FIPS code consistency
* Separating rejected records for audit and quality review

#### Result

* 9,268 invalid geographic records removed before analytical processing

#### Provider Validation

Provider records were validated to ensure a single, reliable profile for each prescriber.

Validation included:

* National Provider Identifier (NPI) verification
* Duplicate provider detection
* Validation of specialty information
* Cross-checking provider identifiers across datasets

#### Numeric Validation

Numeric healthcare measures were validated before analysis.

Validation included:

* Opioid prescribing rates constrained to the expected 0–1 range
* Population values checked before rate calculations
* Division-by-zero prevention using NULLIF()
* Invalid numeric values converted to NULL instead of removing entire records

Result

* More than 312,000 invalid opioid rate values corrected while preserving record integrity

#### Cross-Dataset Validation

Relationships between datasets were verified to ensure consistent reporting.

Validation included:

* Matching state abbreviations across datasets
* Verifying FIPS mappings
* Confirming geographic alignment between prescriber, utilization, and opioid datasets

Only records passing validation were promoted to the transformation layer.

## Data Cleaning & Standardization

After validation, the remaining records were transformed into a consistent analytical format suitable for reporting and downstream analysis.

### Geographic Standardization

The pipeline standardized geographic attributes across all datasets by:

* Normalizing state abbreviations
* Standardizing ZIP codes
* Standardizing FIPS codes
* Removing inconsistent formatting

This produced a single, consistent geographic structure for state-level reporting.

### Text Standardization

Text fields were standardized to improve reporting consistency.

Examples include:

* Provider names
* Provider specialties
* Drug names
* Drug descriptions

Standardization removed formatting inconsistencies and reduced duplicate category values during analysis.

### Prescriber Deduplication

CMS source files occasionally contained multiple records for the same provider.

To create one analytical record per prescriber, the ETL pipeline:

* Grouped records by National Provider Identifier (NPI)
* Retained the record with the highest total claims
* Removed duplicate provider records

Result

* 1,039,307 unique prescribers retained

### Provider Classification

Provider specialties were grouped into clinically meaningful categories for analysis.

Classification groups include:

* PHYSICIAN
* ADVANCED PRACTICE
* DENTAL
* PODIATRY / OPTOMETRY
* PHARMACY
* FACILITY / ORGANIZATIONAL PROVIDERS
* LOW_IMPACT_OTHER
* UNKNOWN

Grouping thousands of specialty descriptions into broader provider categories simplifies dashboard analysis while preserving meaningful clinical distinctions.

### Population Normalization

To support fair comparisons between states of different sizes, population-adjusted measures were calculated during transformation.

Derived metrics include:

* Prescriptions per 1,000 residents
* Opioid claims per 1,000 residents
* Prescribers per 1,000 residents

These engineered measures enable meaningful comparisons independent of state population size.

## Feature Engineering

Once the source data had been validated, cleaned, standardized, and deduplicated, the ETL pipeline generated a series of derived variables to support business intelligence reporting and statistical analysis. These engineered features transformed raw CMS data into metrics that were immediately usable for dashboarding and healthcare decision-making without requiring additional calculations in Tableau.

The feature engineering layer focused on creating standardized measures that improve comparability across providers, states, and years while simplifying downstream analysis.

### Population-Normalized Metrics

Raw prescription counts can be misleading because states vary greatly in population size. To enable meaningful comparisons, several utilization metrics were normalized using annual state population estimates.

Derived measures include:

* Prescriptions per 1,000 residents
* Opioid claims per 1,000 residents
* Prescribers per 1,000 residents
* Drug cost per capita
* Beneficiaries per 1,000 residents

These population-adjusted metrics allow states of different sizes to be compared on an equal basis rather than by total volume alone.

### Provider Classification

Individual CMS provider specialties were grouped into broader clinical categories to simplify reporting and improve interpretability.

Examples include:

* PHYSICIAN
* ADVANCED PRACTICE
* DENTAL
* PODIATRY / OPTOMETRY
* PHARMACY
* FACILITY / ORGANIZATIONAL PROVIDERS
* LOW_IMPACT_OTHER
* UNKNOWN

These standardized provider groups support provider-level comparisons while reducing the complexity associated with hundreds of specialty descriptions.

### Geographic Features

Geographic attributes were standardized and enriched to support state-level reporting.

Engineered geographic fields include:

* Standardized state abbreviations
* Standardized FIPS codes
* Population estimates
* Population-adjusted utilization metrics

These features ensure consistent geographic reporting across all CMS datasets.

### Analytical Measures

Additional business metrics were calculated to support executive reporting and healthcare analytics.

Derived analytical measures include:

* Total prescription volume
* Total opioid prescription volume
* Total drug cost
* Total beneficiary count
* Total prescriber count
* Average claims per provider
* Average drug cost per claim

These measures form the foundation of the Tableau dashboards and SQL-based statistical analyses.

### Correlation Analysis Features

Several engineered variables were created specifically for statistical analysis of prescribing behavior.

These features support Pearson correlation calculations examining relationships between:

* Prescription volume and total drug cost
* Prescription volume and provider supply
* Opioid claims and total prescription activity
* Beneficiary volume and prescription utilization
* Patient complexity and prescribing behavior

The resulting statistical datasets provide quantitative evidence supporting the healthcare insights presented throughout the project.

### Business Intelligence Readiness

The completed feature engineering process produced analytics-ready datasets requiring no additional calculations or transformations within Tableau.

As a result, dashboard development focused entirely on visualization and business interpretation rather than data preparation, closely mirroring production business intelligence workflows used in healthcare organizations.

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
