/*
===========================================================
Project: Medicare Part D Utilization Analytics
Author: Patricia Uhan
Purpose: Build analytical datasets supporting
state-level utilization, cost, and opioid trend analysis.

PROJECT PURPOSE:
This pipeline transforms raw Medicare Part D datasets into a structured analytical model
to support trend analysis, cost evaluation, and opioid utilization insights in Tableau.

ANALYTICAL FLOW:
RAW DATA → CLEANING → FEATURE ENGINEERING → AGGREGATION → ANALYTICS → TABLEAU MODEL
===========================================================
*/

-- =====================================================
-- SYSTEM CONFIGURATION (ETL ENVIRONMENT SETUP)
-- =====================================================

-- ETL environment configuration
SET GLOBAL local_infile = 1; 
SET SQL_SAFE_UPDATES = 0; 
SET unique_checks = 0; 
SET foreign_key_checks = 0;

-- =====================================================
-- DATABASE INITIALIZATION
-- =====================================================

-- Analytics database
CREATE DATABASE IF NOT EXISTS medicare_analytics; 
USE medicare_analytics;

-- =====================================================
-- ETL AUDIT LOGGING
-- =====================================================

CREATE TABLE etl_audit_log (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    process_step VARCHAR(100) NOT NULL,
    source_table VARCHAR(100),
    rows_before INT,
    rows_after INT,
    rows_removed INT,
    process_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/*
ANALYTICAL ASSUMPTIONS

- State-level drug spending data is available only as aggregate totals
  and is treated as a fixed state attribute.

- Duplicate NPIs are resolved by retaining the record with the highest
  total claims volume.

- U.S. territories and non-state geographic entities are excluded from
  state-level analyses.

- This project is intended for population-level healthcare analytics
  and reporting, not patient-level clinical decision support.

LIMITATIONS

- Medicare Part D represents only Medicare beneficiaries
  and should not be generalized to the entire U.S. population.

- Prescribing activity reflects prescription claims
  rather than confirmed medication consumption.

- State-level aggregate drug spending measures are
  not risk-adjusted for demographic differences.

- Correlation analyses are descriptive and should not
  be interpreted as causal relationships.
*/

-- =====================================================
-- DROP EXISTING OBJECTS
-- =====================================================

DROP VIEW IF EXISTS
    prescriber_analysis_dataset,
    state_analysis_dataset;

DROP TABLE IF EXISTS
    raw_prescriber,
    raw_drug,
    raw_opioid_trends,
    prescriber_clean,
    state_drug_totals_static,
    state_opioid_totals,
    state_opioid_population,
    state_population,
    drug_missing_geo,
    state_fips,
    zip_state_map,
    tableau_dataset,
    tableau_prescriber_dataset,
    tableau_state_correlation_matrix,
    tableau_prescriber_correlation_matrix,
    rejected_numeric_records,
    rejected_geographic_records;

-- =====================================================
-- RAW DATA INGESTION LAYER
-- =====================================================

-- Prescriber-level Medicare Part D claims data
CREATE TABLE raw_prescriber ( 
	npi VARCHAR(10), 
	last_name VARCHAR(50), 
	first_name VARCHAR(50), 
	middle_initial VARCHAR(5), 
	credentials VARCHAR(20), 
	address1 VARCHAR(100), 
	address2 VARCHAR(100), 
	city VARCHAR(100), 
	state CHAR(2), 
	zip CHAR(10), 
	prescriber_type VARCHAR(100), 
	total_claims INT, 
	total_30day_fills DECIMAL(12,2), 
	total_drug_cost DECIMAL(14,2), 
	total_day_supply INT, 
	total_beneficiaries INT, 
	opioid_claims INT, 
	opioid_cost DECIMAL(14,2), 
	opioid_beneficiaries INT, 
	opioid_prescribing_rate DECIMAL(8,4), 
	avg_beneficiary_age DECIMAL(5,2), 
	avg_risk_score DECIMAL(6,3) 
);

-- Drug-level aggregation data across geographic regions
CREATE TABLE raw_drug ( 
	geo_level VARCHAR(20), 
	geo_code VARCHAR(10), 
	geo_description VARCHAR(100), 
	brand_name VARCHAR(100), 
	generic_name VARCHAR(100), 
	total_prescribers INT, 
	total_claims INT, 
	total_drug_cost DECIMAL(14,2), 
	total_beneficiaries INT, 
	opioid_flag TINYINT 
);

-- State-level opioid prescribing trends over time
CREATE TABLE raw_opioid_trends ( 
	medicare_year YEAR, 
	geo_level VARCHAR(20), 
	geo_code VARCHAR(10), 
	geo_description VARCHAR(100), 
	total_prescribers INT, 
	opioid_prescribers INT, 
	opioid_claims INT, 
	total_claims INT, 
	opioid_prescribing_rate DECIMAL(8,4) 
);

-- =====================================================
-- DATA VALIDATION TABLES
-- =====================================================

CREATE TABLE rejected_numeric_records
LIKE raw_prescriber;

CREATE TABLE rejected_geographic_records
LIKE raw_prescriber;

ALTER TABLE rejected_numeric_records
ADD rejection_reason VARCHAR(255);

ALTER TABLE rejected_geographic_records
ADD rejection_reason VARCHAR(255);

-- =====================================================
-- DATA INGESTION (CSV LOAD PROCESS)
-- =====================================================

-- Load prescriber dataset
LOAD DATA LOCAL INFILE 
'C:/Users/dutch/Documents/Medicare_Part_D_1.csv' 
INTO TABLE raw_prescriber 
CHARACTER SET utf8mb4 
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 ROWS 
( 
npi,last_name,first_name,middle_initial,credentials,address1,address2,
city,state,zip, prescriber_type, total_claims,total_30day_fills,
total_drug_cost,total_day_supply,total_beneficiaries,
opioid_claims,opioid_cost,opioid_beneficiaries,opioid_prescribing_rate,
avg_beneficiary_age,avg_risk_score 
);

-- Load drug dataset
LOAD DATA LOCAL INFILE 
'C:/Users/dutch/Documents/Medicare_Part_D_2.csv' 
INTO TABLE raw_drug 
CHARACTER SET utf8mb4 
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 ROWS 
( 
geo_level,geo_code,geo_description,brand_name,generic_name, 
total_prescribers,total_claims,total_drug_cost,
total_beneficiaries, opioid_flag 
);

-- Load opioid trend dataset
LOAD DATA LOCAL INFILE 
'C:/Users/dutch/Documents/Medicare_Part_D_3.csv' 
INTO TABLE raw_opioid_trends 
CHARACTER SET utf8mb4 
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 ROWS 
( 
medicare_year,geo_level,geo_code,geo_description,total_prescribers,
opioid_prescribers, opioid_claims,total_claims, opioid_prescribing_rate 
);

-- =====================================================
-- GEOGRAPHIC REFERENCE SYSTEM
-- =====================================================

-- FIPS-to-state mapping table for geographic normalization
CREATE TABLE state_fips ( 	
	fips CHAR(2), 
	state CHAR(2) 
);

INSERT INTO state_fips VALUES 
('01','AL'),('02','AK'),('04','AZ'),('05','AR'),('06','CA'),
('08','CO'),('09','CT'),('10','DE'),('11','DC'),('12','FL'),
('13','GA'),('15','HI'),('16','ID'),('17','IL'),('18','IN'),
('19','IA'),('20','KS'),('21','KY'),('22','LA'),('23','ME'),
('24','MD'),('25','MA'),('26','MI'),('27','MN'),('28','MS'),
('29','MO'),('30','MT'),('31','NE'),('32','NV'),('33','NH'),
('34','NJ'),('35','NM'),('36','NY'),('37','NC'),('38','ND'),
('39','OH'),('40','OK'),('41','OR'),('42','PA'),('44','RI'),
('45','SC'),('46','SD'),('47','TN'),('48','TX'),('49','UT'),
('50','VT'),('51','VA'),('53','WA'),('54','WV'),('55','WI'),
('56','WY');

-- ZIP-to-state mapping for data enrichment
CREATE TABLE zip_state_map (
    zip CHAR(5) PRIMARY KEY,
    state CHAR(2)
);

INSERT INTO zip_state_map (zip, state) VALUES
('33410','FL'),('85013','AZ'),('90026','CA'),('33308','FL'),
('72205','AR'),('28501','NC'),('38103','TN'),('60133','IL'),
('14642','NY'),('33483','FL'),('49660','MI'),('83221','ID'),
('80012','CO'),('96792','HI'),('93003','CA'),('77478','TX'),
('92119','CA'),('93505','CA'),('38119','TN');

-- Certain source records contain abbreviated ZIP values.
-- These mappings are retained to recover valid state information
-- for records that would otherwise have missing geography.
INSERT INTO zip_state_map (zip, state) VALUES
('780','PR'), ('7922','NJ'), ('969','PR');

SELECT zip, COUNT(*) AS count
FROM zip_state_map
GROUP BY zip
HAVING count > 1;

SELECT *
FROM zip_state_map
WHERE zip IS NULL OR state IS NULL;

SELECT COUNT(*) AS total_rows
FROM zip_state_map;

-- =====================================================
-- POPULATION REFERENCE DATA
-- =====================================================

-- State population estimates used to support
-- population-adjusted utilization calculations.

CREATE TABLE state_population (
    state CHAR(2),
    medicare_year YEAR,
    population BIGINT
);

-- Prevent duplicate state-year entries
ALTER TABLE state_population
ADD PRIMARY KEY (state, medicare_year);

-- Load state population data from CSV
LOAD DATA LOCAL INFILE
'C:/Users/dutch/Documents/state_population.csv'
INTO TABLE state_population
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(state, medicare_year, population);

-- Remove invalid rows created by blank lines or bad imports
DELETE FROM state_population
WHERE state IS NULL
   OR medicare_year IS NULL
   OR population IS NULL
   OR state = ''
   OR medicare_year = 0
   OR population = 0;

-- DATA VALIDATION CHECKS
SELECT COUNT(*) AS rows_loaded
FROM state_population;

SELECT *
FROM state_population
LIMIT 10;

SELECT DISTINCT medicare_year
FROM state_population
ORDER BY medicare_year;

SELECT DISTINCT medicare_year
FROM raw_opioid_trends
ORDER BY medicare_year;

-- =====================================================
-- DATA CLEANING & STANDARDIZATION LAYER
-- =====================================================

-- Standardize text fields and remove formatting inconsistencies
UPDATE raw_prescriber 
SET 
	first_name = NULLIF(TRIM(first_name),''), 
	last_name = NULLIF(TRIM(last_name),''), 
	city = NULLIF(TRIM(city),''), 
	state = UPPER(TRIM(state)), 
	credentials = NULLIF(TRIM(credentials),''), 
	prescriber_type = UPPER(TRIM(prescriber_type)),
	zip = LEFT(TRIM(zip),5);

-- Enrich missing state values using ZIP mapping logic
UPDATE raw_prescriber p
JOIN zip_state_map z
  ON LEFT(p.zip, 5) = z.zip
SET p.state = z.state
WHERE p.state = 'XX' OR p.state IS NULL;

-- Remove invalid or non-US geographic entries
-- Audit row count before filtering
SELECT COUNT(*) INTO @before_count
FROM raw_prescriber;

INSERT INTO rejected_geographic_records
SELECT
    *,
    'Invalid or non-US geography'
FROM raw_prescriber
WHERE state IN (
    'ZZ','AA','AE','AP','AS',
    'GU','MP','PR','VI','FM'
);

DELETE FROM raw_prescriber
WHERE state IN (
    'ZZ','AA','AE','AP','AS',
    'GU','MP','PR','VI','FM'
);

-- Audit row count after filtering
SELECT COUNT(*) INTO @after_count
FROM raw_prescriber;

INSERT INTO etl_audit_log (
    process_step,
    source_table,
    rows_before,
    rows_after,
    rows_removed
)
VALUES (
    'Remove Invalid Geographic Records',
    'raw_prescriber',
    @before_count,
    @after_count,
    @before_count - @after_count
);

-- Standardize categorical formatting
UPDATE raw_prescriber
SET prescriber_type = REPLACE(prescriber_type, '&', 'AND');

UPDATE raw_prescriber
SET prescriber_type = REPLACE(prescriber_type, '/', ' ');

-- Remove invalid numeric records to ensure data integrity
SELECT COUNT(*) INTO @before_count
FROM raw_prescriber;

INSERT INTO rejected_numeric_records
SELECT
    *,
    'Negative claims/cost values'
FROM raw_prescriber
WHERE total_claims < 0
   OR total_drug_cost < 0
   OR opioid_claims < 0;

DELETE FROM raw_prescriber
WHERE total_claims < 0
   OR total_drug_cost < 0
   OR opioid_claims < 0;

SELECT COUNT(*) INTO @after_count
FROM raw_prescriber;

INSERT INTO etl_audit_log (
    process_step,
    source_table,
    rows_before,
    rows_after,
    rows_removed
)
VALUES (
    'Remove Invalid Numeric Records',
    'raw_prescriber',
    @before_count,
    @after_count,
    @before_count - @after_count
);

-- Normalize opioid prescribing rate to valid probability range
UPDATE raw_prescriber 
SET opioid_prescribing_rate = NULL 
WHERE opioid_prescribing_rate < 0 
OR opioid_prescribing_rate > 1;

-- Standardize drug naming conventions and geographic identifiers
UPDATE raw_drug 
SET brand_name = UPPER(TRIM(brand_name)), 
generic_name = UPPER(TRIM(generic_name)), 
geo_code = LPAD(TRIM(geo_code), 2, '0');

DELETE FROM raw_drug 
WHERE geo_level <> 'STATE';

-- Remove non-state regions from drug data
DELETE FROM raw_drug
WHERE geo_code NOT IN (
    '01','02','04','05','06','08','09','10','11','12','13','15','16','17',
    '18','19','20','21','22','23','24','25','26','27','28','29','30','31',
    '32','33','34','35','36','37','38','39','40','41','42','44','45','46',
    '47','48','49','50','51','53','54','55','56'
);

-- Standardize geographic identifiers for state-level trend analysis
UPDATE raw_opioid_trends
SET geo_code = LPAD(TRIM(geo_code), 2, '0');

DELETE FROM raw_opioid_trends 
WHERE geo_level <> 'STATE';

-- Remove non-state regions from opioid trends
DELETE FROM raw_opioid_trends
WHERE geo_code NOT IN (
    '01','02','04','05','06','08','09','10','11','12','13','15','16','17',
    '18','19','20','21','22','23','24','25','26','27','28','29','30','31',
    '32','33','34','35','36','37','38','39','40','41','42','44','45','46',
    '47','48','49','50','51','53','54','55','56'
);

-- FIPS validation
SELECT DISTINCT geo_code
FROM raw_drug
WHERE LENGTH(geo_code) <> 2;

SELECT DISTINCT geo_code
FROM raw_opioid_trends
WHERE LENGTH(geo_code) <> 2;
 
-- GEOGRAPHY DATA QUALITY FIXES 

CREATE TABLE drug_missing_geo AS 
SELECT * 
FROM raw_drug 
WHERE geo_code IS NULL;

DELETE FROM raw_drug 
WHERE geo_code IS NULL;

-- Create indexes after bulk loading to improve query performance
-- while minimizing load-time index maintenance costs.

CREATE INDEX idx_raw_npi_claims 
ON raw_prescriber(npi, total_claims);

CREATE INDEX idx_raw_state 
ON raw_prescriber(state);

CREATE INDEX idx_drug_state 
ON raw_drug(geo_code);

CREATE INDEX idx_opioid_state_year 
ON raw_opioid_trends(geo_code, medicare_year);


-- DEDUPLICATE PRESCRIBERS 

-- RATIONALE:
-- CMS source data occasionally contains duplicate NPIs
-- representing differing reporting snapshots.

-- To preserve the most complete utilization profile,
-- the record with the highest total claims volume
-- is retained as the authoritative observation.

-- Alternative approaches (latest reporting period,
-- field-level reconciliation) were not possible
-- given available source metadata.

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


-- Audit NPI deduplication results
SELECT COUNT(*) INTO @before_count
FROM raw_prescriber;

SELECT COUNT(*) INTO @after_count
FROM prescriber_clean;

INSERT INTO etl_audit_log (
    process_step,
    source_table,
    rows_before,
    rows_after,
    rows_removed
)
VALUES (
    'NPI Deduplication',
    'prescriber_clean',
    @before_count,
    @after_count,
    @before_count - @after_count
);

ALTER TABLE prescriber_clean
ADD id INT AUTO_INCREMENT PRIMARY KEY;

CREATE INDEX idx_prescriber_state
ON prescriber_clean(state);

-- =====================================================
-- RISK-ADJUSTED METRICS (PRESCRIBER LEVEL)
-- =====================================================

ALTER TABLE prescriber_clean
ADD risk_adjusted_claim_rate DECIMAL(18,6),
ADD risk_adjusted_opioid_rate DECIMAL(18,6);

UPDATE prescriber_clean
SET risk_adjusted_claim_rate =
    total_claims / NULLIF(avg_risk_score, 0),

    risk_adjusted_opioid_rate =
    opioid_claims / NULLIF(avg_risk_score, 0);

-- DROP UNUSED VARIABLES

ALTER TABLE prescriber_clean
DROP COLUMN first_name,
DROP COLUMN last_name,
DROP COLUMN middle_initial,
DROP COLUMN address1,
DROP COLUMN address2,
DROP COLUMN city,
DROP COLUMN zip;

-- PRESCRIBER TYPE STANDARDIZATION + GROUPING

-- Add grouped category column
ALTER TABLE prescriber_clean
ADD prescriber_group VARCHAR(50);

-- Category assignments are applied sequentially.
-- Earlier classifications take precedence over later fallback rules.

-- PHYSICIANS (core prescribing drivers)
UPDATE prescriber_clean
SET prescriber_group = 'PHYSICIAN'
WHERE prescriber_type IN (
'INTERNAL MEDICINE','FAMILY MEDICINE','FAMILY PRACTICE',
'CARDIOLOGY','DERMATOLOGY','NEUROLOGY','PSYCHIATRY',
'GENERAL SURGERY','ORTHOPEDIC SURGERY','EMERGENCY MEDICINE',
'ANESTHESIOLOGY','RADIOLOGY','GASTROENTEROLOGY',
'ENDOCRINOLOGY','NEPHROLOGY','UROLOGY','PULMONARY DISEASE',
'OBSTETRICS AND GYNECOLOGY','OPHTHALMOLOGY',
'RHEUMATOLOGY','GERIATRIC MEDICINE','ONCOLOGY'
);

-- ADVANCED PRACTICE (important for opioid trends)
UPDATE prescriber_clean
SET prescriber_group = 'ADVANCED_PRACTICE'
WHERE prescriber_type IN (
'NURSE PRACTITIONER',
'PHYSICIAN ASSISTANT',
'CERTIFIED REGISTERED NURSE ANESTHETIST (CRNA)',
'CERTIFIED NURSE MIDWIFE'
);

-- DENTAL
UPDATE prescriber_clean
SET prescriber_group = 'DENTAL'
WHERE prescriber_type LIKE '%DENT%'
   OR prescriber_type LIKE '%ORAL%';

-- PODIATRY / OPTOMETRY
UPDATE prescriber_clean
SET prescriber_group = 'PODIATRY_OPTOMETRY'
WHERE prescriber_type IN ('PODIATRY','OPTOMETRY');

-- PHARMACY
UPDATE prescriber_clean
SET prescriber_group = 'PHARMACY'
WHERE prescriber_type LIKE '%PHARM%';

-- FACILITY / ORGANIZATIONAL PROVIDERS
UPDATE prescriber_clean
SET prescriber_group = 'FACILITY_OR_ORGANIZATIONAL_PROVIDERS'
WHERE prescriber_type LIKE '%HOSPITAL%'
   OR prescriber_type LIKE '%CLINIC%'
   OR prescriber_type LIKE '%CENTER%'
   OR prescriber_type LIKE '%FACILITY%'
   OR prescriber_type LIKE '%ORGANIZATION%'
   OR prescriber_type LIKE '%SUPPL%';

-- OTHER CLINICAL SUPPORT ROLES
UPDATE prescriber_clean
SET prescriber_group = 'OTHER_CLINICAL_SUPPORT_ROLES'
WHERE prescriber_group IS NULL
AND (
    prescriber_type LIKE '%TECH%'
 OR prescriber_type LIKE '%ASSISTANT%'
 OR prescriber_type LIKE '%AIDE%'
 OR prescriber_type LIKE '%THERAP%'
 OR prescriber_type LIKE '%COUNSEL%'
);

-- Missing or undefined provider classifications
UPDATE prescriber_clean
SET prescriber_group = 'UNKNOWN'
WHERE prescriber_type IS NULL
   OR prescriber_type IN ('', 'NULL', 'UNDEFINED PHYSICIAN TYPE');

-- Remaining uncategorized provider types
UPDATE prescriber_clean
SET prescriber_group = 'LOW_IMPACT_OTHER'
WHERE prescriber_group IS NULL;

-- =====================================================
-- FEATURE ENGINEERING & AGGREGATION LAYER
-- =====================================================

/*
IMPORTANT METHODOLOGICAL NOTE:

Drug spending measures were available only as aggregate state-level totals
and were therefore treated as time-invariant covariates within the
longitudinal state-year analytical framework.

These variables do not vary over time and should be interpreted as
structural state characteristics rather than time-varying predictors.
*/

CREATE TABLE state_drug_totals_static AS 
SELECT 
    f.state,
    SUM(d.total_claims) AS total_drug_claims,
    SUM(d.total_drug_cost) AS total_drug_cost,
    SUM(d.total_prescribers) AS total_prescribers
FROM raw_drug d
JOIN state_fips f 
    ON d.geo_code = f.fips
GROUP BY f.state;

CREATE TABLE state_opioid_totals AS 
SELECT 
    f.state,
    o.medicare_year,
    SUM(o.total_prescribers) AS total_prescribers,
    SUM(o.opioid_prescribers) AS opioid_prescribers,
    SUM(o.opioid_claims) AS opioid_claims,
    SUM(o.total_claims) AS overall_claims
FROM raw_opioid_trends o
JOIN state_fips f 
    ON o.geo_code = f.fips
GROUP BY f.state, o.medicare_year;

-- =====================================================
-- POPULATION JOIN VALIDATION
-- =====================================================

-- Verify every state-year observation has a matching
-- population record before creating population-adjusted metrics.

SELECT
    o.state,
    o.medicare_year
FROM state_opioid_totals o
LEFT JOIN state_population p
       ON o.state = p.state
      AND o.medicare_year = p.medicare_year
WHERE p.population IS NULL;

-- =====================================================
-- POPULATION-NORMALIZED STATE DATASET
-- =====================================================

CREATE TABLE state_opioid_population AS
SELECT
    o.state,
    o.medicare_year,

    p.population,

    o.total_prescribers,
    o.opioid_prescribers,
    o.opioid_claims,
    o.overall_claims,

    -- per 1,000 population metrics
    CAST(o.total_prescribers AS DECIMAL(18,4))
        / NULLIF(p.population, 0) * 1000
        AS prescribers_per_1000,

    CAST(o.opioid_prescribers AS DECIMAL(18,4))
        / NULLIF(p.population, 0) * 1000
        AS opioid_prescribers_per_1000,

    CAST(o.opioid_claims AS DECIMAL(18,4))
        / NULLIF(p.population, 0) * 1000
        AS opioid_claims_per_1000,

    CAST(o.overall_claims AS DECIMAL(18,4))
        / NULLIF(p.population, 0) * 1000
        AS claims_per_1000

FROM state_opioid_totals o
JOIN state_population p
    ON o.state = p.state
   AND o.medicare_year = p.medicare_year;

-- =====================================================
-- FINAL TABLE (TABLEAU READY) STATE-YEAR
-- =====================================================
/*
Final analytical dataset for Tableau reporting and visualization.

Grain:
One row per state per Medicare year.

Contains:
- Drug utilization metrics
- Opioid prescribing metrics
- Prescriber workforce metrics
- Derived utilization and cost measures

Primary use cases:
- State-level opioid prescribing trend analysis
- Geographic variation in utilization and spending
- Prescriber workforce capacity assessment
- Comparative healthcare cost analysis
*/

-- NOTE: state_drug_totals is time-invariant and does not vary by medicare_year
-- It is joined to state-year data as a fixed state-level covariate

CREATE TABLE tableau_dataset AS
SELECT
    o.state,
    o.medicare_year,

    p.population,

    -- Core Utilization
    d.total_drug_claims,
    d.total_drug_cost,

    -- Opioid Utilization
    o.overall_claims,
    o.opioid_claims,

    -- Workforce
    o.total_prescribers,
    o.opioid_prescribers,

    -- Per-capita metrics (KEY ADDITION)
    CAST(o.opioid_claims AS DECIMAL(18,4))
        / NULLIF(p.population, 0) * 1000
        AS opioid_claims_per_1000,

    CAST(o.total_prescribers AS DECIMAL(18,4))
        / NULLIF(p.population, 0) * 1000
        AS prescribers_per_1000,

    CAST(o.opioid_prescribers AS DECIMAL(18,4))
        / NULLIF(p.population, 0) * 1000
        AS opioid_prescribers_per_1000,

    -- Derived Metrics (unchanged)
    (
        CAST(o.opioid_claims AS DECIMAL(18,4))
        / NULLIF(o.overall_claims,0)
    ) AS opioid_claim_rate,

    (
        CAST(o.opioid_prescribers AS DECIMAL(18,4))
        / NULLIF(o.total_prescribers,0)
    ) AS opioid_prescriber_rate,

    (
        CAST(d.total_drug_cost AS DECIMAL(18,4))
        / NULLIF(d.total_drug_claims,0)
    ) AS cost_per_claim,

    (
        CAST(o.overall_claims AS DECIMAL(18,4))
        / NULLIF(o.total_prescribers,0)
    ) AS claims_per_prescriber,

    (
        CAST(o.opioid_claims AS DECIMAL(18,4))
        / NULLIF(o.opioid_prescribers,0)
    ) AS opioid_claims_per_prescriber

FROM state_opioid_totals o
LEFT JOIN state_drug_totals_static d
    ON o.state = d.state
LEFT JOIN state_population p
    ON o.state = p.state
   AND o.medicare_year = p.medicare_year;

-- =====================================================
-- FINAL TABLEAU PRESCRIBER DATASET
-- =====================================================
/*
Final prescriber-level dataset for Tableau reporting.

Grain:
One row per prescriber (NPI).

Contains:
- Prescriber characteristics
- Utilization metrics
- Opioid prescribing measures
- Beneficiary and risk indicators

Primary use cases:
- Provider segmentation and benchmarking
- Prescribing behavior analysis
- Specialty-level utilization comparisons
- High-volume prescriber identification
*/

CREATE TABLE tableau_prescriber_dataset AS
SELECT
    npi,
    state,
    prescriber_type,
    prescriber_group,

    total_claims,
    total_30day_fills,
    total_day_supply,
    total_drug_cost,
    total_beneficiaries,

    opioid_claims,
    opioid_cost,
    opioid_beneficiaries,
    opioid_prescribing_rate,

    avg_beneficiary_age,
    avg_risk_score,

    -- Risk-adjusted metrics
    -- Utilization normalized by average beneficiary risk score
    (
        CAST(total_claims AS DECIMAL(18,4))
        / NULLIF(avg_risk_score, 0)
    ) AS risk_adjusted_claim_volume,

    (
        CAST(opioid_claims AS DECIMAL(18,4))
        / NULLIF(avg_risk_score, 0)
    ) AS risk_adjusted_opioid_volume,

    -- Derived Metrics
    (
        CAST(total_drug_cost AS DECIMAL(18,4))
        / NULLIF(total_claims,0)
    ) AS cost_per_claim,

    (
        CAST(opioid_claims AS DECIMAL(18,4))
        / NULLIF(total_claims,0)
    ) AS opioid_claim_rate,

    (
        CAST(total_claims AS DECIMAL(18,4))
        / NULLIF(total_beneficiaries,0)
    ) AS claims_per_beneficiary

FROM prescriber_clean;

-- =====================================================
-- TABLEAU INDEXES
-- =====================================================

CREATE INDEX idx_tableau_state_year
ON tableau_dataset(state, medicare_year);

CREATE INDEX idx_tableau_prescriber_group
ON tableau_prescriber_dataset(prescriber_group);

CREATE INDEX idx_tableau_prescriber_state
ON tableau_prescriber_dataset(state);

-- =====================================================
-- EXPLORATORY ANALYTICS QUERIES
-- =====================================================

-- Opioid Trend Over Time
SELECT state, medicare_year,
       SUM(opioid_claims) AS opioid_claims
FROM state_opioid_totals 
GROUP BY state, medicare_year
ORDER BY state, medicare_year;

-- Cost per Claim by State
SELECT state,
       SUM(total_drug_cost) / SUM(total_drug_claims) AS cost_per_claim
FROM state_drug_totals_static
GROUP BY state
ORDER BY cost_per_claim DESC;

-- High Opioid States
SELECT state,
       SUM(opioid_claims)/SUM(overall_claims) AS opioid_ratio
FROM state_opioid_totals
GROUP BY state
ORDER BY opioid_ratio DESC;

-- Prescriber Behavior
SELECT prescriber_group,
       COUNT(*) AS prescriber_count,
       AVG(opioid_prescribing_rate) AS avg_opioid_rate,
       SUM(opioid_claims) AS total_opioid_claims
FROM prescriber_clean
GROUP BY prescriber_group
ORDER BY total_opioid_claims DESC;

-- Top Prescribers by Volume
SELECT prescriber_group, npi, total_claims
FROM (
    SELECT prescriber_group, npi, total_claims,
           ROW_NUMBER() OVER (
               PARTITION BY prescriber_group 
               ORDER BY total_claims DESC
           ) AS rn
    FROM prescriber_clean
) t
WHERE rn <= 5;

-- States with Highest Total Drug Spend
SELECT state,
       SUM(total_drug_cost) AS total_cost
FROM state_drug_totals_static
GROUP BY state
ORDER BY total_cost DESC;

-- Opioid vs Non-Opioid Utilization
SELECT state,
       SUM(opioid_claims) AS opioid_claims,
       SUM(overall_claims) - SUM(opioid_claims) AS non_opioid_claims
FROM state_opioid_totals
GROUP BY state;

/*
INTERPRETATION NOTE

Correlation coefficients reported below describe
associations between variables and should not be
interpreted as evidence of causality.
*/

-- =====================================================
-- EXPLORATORY STATISTICS (CORRELATION ANALYSIS)
-- =====================================================

-- PRESCRIBER-LEVEL ANALYSIS (INDIVIDUAL)
CREATE OR REPLACE VIEW prescriber_analysis_dataset AS
SELECT
    total_claims,
    total_drug_cost,
    opioid_claims,
    total_beneficiaries,
    avg_risk_score
FROM prescriber_clean
WHERE total_claims IS NOT NULL
  AND total_drug_cost IS NOT NULL
  AND opioid_claims IS NOT NULL
  AND total_beneficiaries IS NOT NULL
  AND avg_risk_score IS NOT NULL;

-- Pearson correlation coefficients calculated directly in SQL
-- using covariance divided by the product of standard deviations.

SELECT

-- Core Volume & Cost
(AVG(total_claims * total_drug_cost) - AVG(total_claims)*AVG(total_drug_cost))
/ NULLIF(STDDEV(total_claims)*STDDEV(total_drug_cost),0)
AS corr_claims_cost,

(AVG(total_beneficiaries * total_claims) - AVG(total_beneficiaries)*AVG(total_claims))
/ NULLIF(STDDEV(total_beneficiaries)*STDDEV(total_claims),0)
AS corr_beneficiaries_claims,

(AVG(total_beneficiaries * total_drug_cost) - AVG(total_beneficiaries)*AVG(total_drug_cost))
/ NULLIF(STDDEV(total_beneficiaries)*STDDEV(total_drug_cost),0)
AS corr_beneficiaries_cost,

-- Opioid Behavior
(AVG(opioid_claims * total_claims) - AVG(opioid_claims)*AVG(total_claims))
/ NULLIF(STDDEV(opioid_claims)*STDDEV(total_claims),0)
AS corr_opioid_claims_total_claims,

(AVG(opioid_claims * total_beneficiaries) - AVG(opioid_claims)*AVG(total_beneficiaries))
/ NULLIF(STDDEV(opioid_claims)*STDDEV(total_beneficiaries),0)
AS corr_opioid_beneficiaries,

-- Risk Adjustment
(AVG(avg_risk_score * total_claims) - AVG(avg_risk_score)*AVG(total_claims))
/ NULLIF(STDDEV(avg_risk_score)*STDDEV(total_claims),0)
AS corr_risk_claims,

(AVG(avg_risk_score * opioid_claims) - AVG(avg_risk_score)*AVG(opioid_claims))
/ NULLIF(STDDEV(avg_risk_score)*STDDEV(opioid_claims),0)
AS corr_risk_opioid

FROM prescriber_analysis_dataset;

-- STATE-LEVEL ANALYSIS (SYSTEM)
CREATE OR REPLACE VIEW state_analysis_dataset AS
SELECT
    o.state,
    o.medicare_year,

    d.total_drug_claims,
    d.total_drug_cost,

    o.total_prescribers,
    o.opioid_prescribers,
    o.opioid_claims,
    o.overall_claims

FROM state_opioid_totals o

LEFT JOIN state_drug_totals_static d
    ON o.state = d.state;
    
-- Pearson correlation coefficients calculated directly in SQL
-- using covariance divided by the product of standard deviations.

SELECT

-- System Scale
(AVG(total_drug_claims * total_drug_cost) - AVG(total_drug_claims)*AVG(total_drug_cost))
/ NULLIF(STDDEV(total_drug_claims)*STDDEV(total_drug_cost),0)
AS corr_claims_cost,

-- Workforce Capacity
(AVG(total_drug_claims * total_prescribers) - AVG(total_drug_claims)*AVG(total_prescribers))
/ NULLIF(STDDEV(total_drug_claims)*STDDEV(total_prescribers),0)
AS corr_claims_prescribers,

-- Opioid Workforce
(AVG(opioid_claims * opioid_prescribers) - AVG(opioid_claims)*AVG(opioid_prescribers))
/ NULLIF(STDDEV(opioid_claims)*STDDEV(opioid_prescribers),0)
AS corr_opioid_claims_prescribers

FROM state_analysis_dataset;

-- TREND ANALYSIS
SELECT
    medicare_year,
    SUM(overall_claims) AS total_claims,
    SUM(opioid_claims) AS opioid_claims,
    SUM(total_prescribers) AS total_prescribers,
    SUM(opioid_prescribers) AS opioid_prescribers
FROM state_opioid_totals
GROUP BY medicare_year
ORDER BY medicare_year;

SELECT
    medicare_year,
    SUM(overall_claims) AS total_claims,
    LAG(SUM(overall_claims)) OVER (ORDER BY medicare_year) AS prev_year,
    (SUM(overall_claims) - LAG(SUM(overall_claims)) OVER (ORDER BY medicare_year))
    / LAG(SUM(overall_claims)) OVER (ORDER BY medicare_year) AS yoy_growth
FROM state_opioid_totals
GROUP BY medicare_year
ORDER BY medicare_year;

-- =====================================================
-- ETL AUDIT SUMMARY
-- =====================================================

SELECT *
FROM etl_audit_log
ORDER BY audit_id;

-- =====================================================
-- FINAL RESET
-- =====================================================
-- Re-enable safety checks
SET unique_checks = 1;
SET foreign_key_checks = 1;

SELECT *
FROM tableau_dataset;

SELECT *
FROM tableau_prescriber_dataset;

-- ============================================
-- STATE CORRELATION MATRIX TABLE (TABLEAU READY)
-- ============================================

CREATE TABLE tableau_state_correlation_matrix AS

SELECT 'Claims vs Cost' AS relationship,
(AVG(total_drug_claims * total_drug_cost)
 - AVG(total_drug_claims)*AVG(total_drug_cost))
/ NULLIF(STDDEV(total_drug_claims)*STDDEV(total_drug_cost),0)
AS correlation
FROM state_analysis_dataset

UNION ALL

SELECT 'Claims vs Prescribers',
(AVG(total_drug_claims * total_prescribers)
 - AVG(total_drug_claims)*AVG(total_prescribers))
/ NULLIF(STDDEV(total_drug_claims)*STDDEV(total_prescribers),0)
FROM state_analysis_dataset

UNION ALL

SELECT 'Opioid Claims vs Opioid Prescribers',
(AVG(opioid_claims * opioid_prescribers)
 - AVG(opioid_claims)*AVG(opioid_prescribers))
/ NULLIF(STDDEV(opioid_claims)*STDDEV(opioid_prescribers),0)
FROM state_analysis_dataset;

SELECT *
FROM tableau_state_correlation_matrix;

-- ============================================
-- PRESCRIBERS CORRELATION MATRIX TABLE (TABLEAU READY)
-- ============================================
CREATE TABLE tableau_prescriber_correlation_matrix AS

SELECT 'Claims vs Cost' AS relationship,
(AVG(total_claims * total_drug_cost)
 - AVG(total_claims)*AVG(total_drug_cost))
/ NULLIF(STDDEV(total_claims)*STDDEV(total_drug_cost),0)
AS correlation
FROM prescriber_analysis_dataset

UNION ALL

SELECT 'Claims vs Beneficiaries',
(AVG(total_claims * total_beneficiaries)
 - AVG(total_claims)*AVG(total_beneficiaries))
/ NULLIF(STDDEV(total_claims)*STDDEV(total_beneficiaries),0)
FROM prescriber_analysis_dataset

UNION ALL

SELECT 'Opioid Claims vs Total Claims',
(AVG(opioid_claims * total_claims)
 - AVG(opioid_claims)*AVG(total_claims))
/ NULLIF(STDDEV(opioid_claims)*STDDEV(total_claims),0)
FROM prescriber_analysis_dataset

UNION ALL

SELECT 'Risk Score vs Claims',
(AVG(avg_risk_score * total_claims)
 - AVG(avg_risk_score)*AVG(total_claims))
/ NULLIF(STDDEV(avg_risk_score)*STDDEV(total_claims),0)
FROM prescriber_analysis_dataset

UNION ALL

SELECT 'Risk Score vs Opioid Claims',
(AVG(avg_risk_score * opioid_claims)
 - AVG(avg_risk_score)*AVG(opioid_claims))
/ NULLIF(STDDEV(avg_risk_score)*STDDEV(opioid_claims),0)
FROM prescriber_analysis_dataset;

SELECT *
FROM tableau_prescriber_correlation_matrix;


