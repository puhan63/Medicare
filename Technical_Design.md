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

## SQL Implementation Highlights

The complete SQL ETL pipeline that powers this project is available here:

➡️ Medicare_Part_D_ETL.sql

The pipeline consists of several thousand lines of SQL implementing bulk data ingestion, validation, cleaning, standardization, feature engineering, analytical data mart creation, statistical analysis, and ETL audit logging.

The examples below highlight several representative SQL techniques used throughout the project.

### Prescriber Deduplication

CMS source files occasionally contained multiple records for the same National Provider Identifier (NPI). To produce one analytical record per provider, the ETL pipeline grouped records by NPI and retained the record with the highest prescription volume.

Representative SQL:

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
This approach creates a single representative provider profile while preserving the highest-volume prescribing record for downstream analysis.

### Population-Normalized Healthcare Metrics

Raw prescription counts can be misleading because states differ substantially in population size. To support meaningful comparisons, the ETL pipeline calculated population-adjusted utilization measures during data transformation.

Representative SQL:

```sql
CAST(o.opioid_claims AS DECIMAL(18,4))
    / NULLIF(p.population, 0) * 1000
    AS opioid_claims_per_1000,

CAST(o.total_prescribers AS DECIMAL(18,4))
    / NULLIF(p.population, 0) * 1000
    AS prescribers_per_1000
```

Using NULLIF() prevents division-by-zero errors while generating standardized per-capita healthcare metrics that can be compared fairly across all states.

## Statistical Analysis

Beyond data engineering and business intelligence reporting, this project performs statistical analysis directly within MySQL to quantify relationships among key Medicare Part D utilization metrics.

Rather than relying solely on visual interpretation of dashboard trends, the ETL pipeline calculates Pearson correlation coefficients using SQL aggregate functions. These statistical measures provide quantitative evidence supporting the relationships observed throughout the analysis.

The statistical layer demonstrates how SQL can be used not only for data preparation, but also for exploratory and analytical modeling within a healthcare analytics workflow.

### Analytical Objectives

The statistical analysis was designed to answer questions such as:

* How strongly is prescription volume associated with total drug cost?
* Does opioid prescribing increase proportionally with overall prescribing activity?
* Is healthcare utilization more closely associated with provider supply or patient population?
* Do higher beneficiary counts correspond to greater prescribing activity?
* Which healthcare metrics demonstrate the strongest statistical relationships?

These analyses complement the Tableau dashboards by providing numerical evidence for observed healthcare utilization patterns.

### Pearson Correlation Analysis

Pearson correlation coefficients were calculated directly within SQL using aggregate statistical functions.

The calculations measure the strength and direction of linear relationships between healthcare variables.

Representative analyses include:

* Total prescription volume vs. total drug cost
* Total prescription volume vs. provider count
* Total prescription volume vs. beneficiary count
* Opioid prescription volume vs. total prescription volume
* Opioid prescription volume vs. opioid prescriber count

The resulting coefficients range from −1 to +1, where:

| Correlation | Interpretation                |
| ----------- | ----------------------------- |
| **+1.0**    | Perfect positive relationship |
| **0.0**     | No linear relationship        |
| **−1.0**    | Perfect negative relationship |

These values provide an objective measure of how closely healthcare utilization metrics move together.

### SQL Implementation

Rather than exporting data to statistical software, correlation coefficients were calculated directly within MySQL using aggregate functions.

Representative SQL:

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

Using SQL for statistical calculations keeps the analytical workflow entirely within the database environment while ensuring the results remain reproducible and transparent.

### Statistical Output Datasets

The ETL pipeline generates dedicated datasets containing the calculated correlation coefficients.

These include:

**tableau_state_correlation**

State-level statistical relationships among:

* Prescription volume
* Drug cost
* Provider counts
* Opioid utilization
* Population-adjusted utilization measures

**tableau_provider_correlation**

Provider-level statistical relationships among:

* Total claims
* Drug cost
* Beneficiary count
* Opioid claims
* Overall prescribing activity

These datasets are consumed directly by Tableau to visualize the strength of relationships across multiple healthcare measures.

### Interpretation

The statistical analysis supports several of the project's primary findings.

Examples include:

* Higher prescription volume is strongly associated with increased drug spending.
* Opioid prescribing generally scales with overall prescribing activity rather than occurring independently.
* Provider availability contributes to differences in healthcare utilization across geographic regions.
* Beneficiary volume is positively associated with prescription activity.

These findings complement the dashboard visualizations by providing quantitative evidence for observed utilization patterns.

### Role Within the ETL Pipeline

The statistical analysis represents the final analytical stage of the pipeline.

The workflow proceeds through:

* Data ingestion
* Validation
* Cleaning and standardization
* Feature engineering
* Analytical data mart creation
* Statistical analysis
* Tableau visualization

Performing the statistical calculations after the analytical datasets have been fully validated ensures that the reported relationships are based on consistent, standardized, and high-quality data.

### Additional SQL Techniques Used

Beyond the examples shown above, the ETL pipeline incorporates a variety of SQL techniques commonly used in healthcare data engineering projects, including:

* Bulk data ingestion using LOAD DATA LOCAL INFILE
* Multi-table joins for integrating CMS datasets
* Aggregate functions for healthcare utilization metrics
* Conditional logic using CASE expressions
* Common Table Expressions (CTEs)
* Window functions for ranking and analytical calculations
* Population normalization using demographic reference data
* Data validation and quality checks
* Feature engineering for business intelligence reporting
* Analytical data mart creation optimized for Tableau
* ETL audit logging for transformation tracking and reproducibility

## Tableau Dashboard Design

The final analytical datasets produced by the SQL ETL pipeline power an interactive Tableau workbook consisting of a landing page and three analytical dashboards. Each dashboard is designed for a different level of analysis while using a common set of validated business rules, standardized measures, and engineered features generated during the ETL process.
 
### Dashboard 1 — Project Overview (Landing Page)

The landing page serves as the navigation hub for the Tableau workbook and provides users with an overview of the project before exploring the analytical dashboards.

The landing page includes:

* Project summary
* Navigation buttons
* Dashboard descriptions
* Instructions for exploring the workbook

This page improves usability by allowing users to move easily between the analytical dashboards while providing context for the overall project.
  
### Dashboard 2 — State-Level Prescription & Opioid Utilization Analysis

This dashboard explores Medicare Part D prescribing patterns across all U.S. states and the District of Columbia between 2013 and 2023.

The dashboard supports analysis of:

* Total prescription volume
* Opioid prescribing trends
* Population-adjusted utilization rates
* Healthcare spending
* Geographic variation
* State-to-state comparisons
* Longitudinal prescribing trends

Primary data source:

* tableau_state_dashboard

This dataset contains approximately 561 records (51 geographic regions across 11 years) and provides an executive-level view of nationwide prescribing behavior.

### Dashboard 3 — Provider Workforce & Prescribing Behavior

This dashboard focuses on provider-level prescribing activity using more than one million deduplicated Medicare Part D prescribers.

The dashboard allows users to analyze:

* Provider specialty groups
* Prescription volume
* Opioid prescribing activity
* Drug costs
* Beneficiary counts
* High-volume prescribers
* Provider segmentation

Primary data source:

* tableau_provider_dashboard

This dataset contains more than 1.03 million unique providers, supporting detailed analysis of prescribing behavior across provider types.

### Dashboard 4 — Statistical Correlation Analysis

This dashboard visualizes statistical relationships calculated directly within SQL using Pearson correlation coefficients.

The dashboard explores relationships between:

* Prescription volume and total drug cost
* Prescription volume and provider supply
* Opioid claims and total claims
* Beneficiary volume and prescribing activity
* Patient complexity and prescription utilization

Primary data sources:

* tableau_state_correlation
* tableau_provider_correlation

Unlike the other dashboards, this dashboard focuses on explaining why utilization patterns occur by quantifying relationships among key healthcare metrics.

### Dashboard Design Principles

The Tableau dashboards were designed to support both executive reporting and detailed healthcare analytics.

Key design principles include:

* Consistent color palette and visual styling
* Interactive filtering across dashboards
* Population-normalized metrics for fair geographic comparisons
* Clinically meaningful provider classifications
* Clear separation between state-level and provider-level analyses
* Dashboard layouts optimized for rapid interpretation of healthcare utilization patterns

Because all business rules, feature engineering, and statistical calculations are performed within the SQL ETL pipeline, the Tableau workbook functions primarily as a visualization layer without requiring additional data preparation.

## Performance Considerations

Although this project was developed using publicly available Medicare Part D data, the ETL pipeline was designed using practices commonly employed in production data engineering workflows. Performance considerations focused on reducing unnecessary processing, supporting efficient analytical queries, and preparing datasets optimized for business intelligence reporting.

### ETL Design

The ETL pipeline follows a staged architecture in which data is transformed incrementally rather than through a single monolithic query.

Major processing stages include:

* Bulk ingestion of raw CMS source files into staging tables
* Data validation and quality checks
* Cleaning and standardization
* Prescriber deduplication
* Feature engineering
* Statistical analysis
* Creation of analytics-ready data marts

Separating these stages simplifies debugging, improves maintainability, and allows intermediate results to be validated before progressing to downstream transformations.

### Bulk Data Loading

Large CMS source files were imported using LOAD DATA LOCAL INFILE, which provides significantly faster performance than row-by-row insert operations.

Bulk loading enables efficient ingestion of more than 1.4 million Medicare Part D records while preserving the original source data for reproducibility.

### Analytical Data Marts

Rather than querying multiple raw source tables for every analysis, the ETL pipeline produces denormalized analytical data marts specifically designed for reporting.

These curated datasets:

* Minimize complex joins during reporting
* Reduce repeated calculations
* Improve dashboard responsiveness
* Simplify SQL queries used for business intelligence

This approach mirrors common data warehouse practices where reporting tables are optimized for analytical workloads rather than transactional processing.

### Statistical Processing

Pearson correlation coefficients were calculated after the analytical datasets had been fully validated and standardized.

Performing statistical analysis on curated datasets provides several advantages:

* Eliminates unnecessary processing of invalid records
* Ensures consistent analytical inputs
* Produces reproducible statistical results
* Separates data engineering from analytical processing

This staged approach improves both maintainability and computational efficiency.

### Database Optimization

The ETL pipeline incorporates several SQL design practices intended to support efficient execution and reporting.

Examples include:

* Targeted indexing on frequently queried columns
* Aggregate calculations performed within SQL
* Population-normalized metrics calculated during ETL rather than at visualization time
* Deduplication performed once during transformation instead of repeatedly during analysis
* Reusable analytical datasets designed for downstream reporting

These techniques reduce redundant computation and simplify dashboard queries.

### Business Intelligence Performance

The final Tableau dashboards connect directly to the analytical data marts generated by the ETL pipeline.

Because validation, cleaning, feature engineering, and statistical calculations are completed during ETL, Tableau functions primarily as a visualization layer rather than a data transformation tool.

This design provides:

* Faster dashboard loading
* Simpler calculated fields
* Consistent business logic across visualizations
* Improved maintainability
* Reproducible analytical results

Separating data engineering from visualization reflects best practices commonly used in healthcare business intelligence environments.

## ETL Governance & Auditability

A key objective of this project was to build an ETL pipeline that is not only accurate, but also transparent, reproducible, and easy to validate. Rather than treating data cleaning as a black box, the pipeline documents each major transformation and preserves sufficient information to understand how the raw CMS source data evolves into analytics-ready datasets.

### Data Quality Transparency

Validation rules were applied consistently throughout the ETL process to identify incomplete, inconsistent, or invalid records before they entered the analytical data marts.

Examples include:

* Geographic validation
* Provider deduplication
* Opioid prescribing rate validation
* State and FIPS code standardization
* Cross-dataset consistency checks

Each validation stage was designed to improve analytical reliability while preserving a clear understanding of why records were modified or excluded.

### ETL Audit Logging

The pipeline includes an ETL audit logging process to document major transformations performed during data preparation.

Examples of tracked activities include:

* Records removed during geographic validation
* Prescriber deduplication outcomes
* Numeric validation and correction of opioid prescribing rates
* Data cleaning and standardization operations
* Creation of analytical data marts

Maintaining an audit trail improves transparency and provides a reproducible record of how the final analytical datasets were produced.

### Reproducibility

The ETL pipeline was designed to produce consistent results each time it is executed against the same CMS source files.

Reproducibility is supported through:

* Standardized SQL transformation logic
* Deterministic validation rules
* Repeatable feature engineering processes
* Consistent analytical dataset creation
* Version-controlled SQL scripts

This approach ensures that analyses and dashboards can be regenerated without requiring manual intervention or undocumented processing steps.

### Separation of Responsibilities

The project separates each stage of the analytics workflow into distinct responsibilities.

* Raw CMS data ingestion
* Data validation
* Cleaning and standardization
* Feature engineering
* Statistical analysis
* Analytical data mart creation
* Tableau visualization

Separating these responsibilities improves maintainability, simplifies debugging, and ensures that business intelligence reporting is built upon validated and consistent data.

### Healthcare Analytics Best Practices

The ETL design reflects principles commonly used in healthcare analytics and business intelligence projects.

These include:

* Preserving raw source data
* Applying reproducible validation rules
* Standardizing data before analysis
* Maintaining transparent transformation logic
* Separating data engineering from visualization
* Building analytics-ready data marts optimized for reporting

Following these practices results in a workflow that is easier to audit, extend, and maintain while producing reliable datasets for downstream analysis.

## Summary

The completed ETL pipeline transforms more than 1.4 million Medicare Part D records into validated, standardized, and analytics-ready datasets that support interactive Tableau dashboards and SQL-based statistical analysis. By emphasizing data quality, reproducibility, auditability, and modular ETL design, the project demonstrates the end-to-end workflow commonly used to prepare large-scale healthcare data for business intelligence and decision support.
