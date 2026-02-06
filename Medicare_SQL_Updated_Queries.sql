SET GLOBAL local_infile = 1;
SET SQL_SAFE_UPDATES = 0;

CREATE DATABASE IF NOT EXISTS medicare;
USE medicare;

CREATE TABLE IF NOT EXISTS medicare_part_d (
PRSCRBR_NPI CHAR(12),
Prscrbr_Last_Org_Name VARCHAR(20),
Prscrbr_First_Name VARCHAR(20),
Prscrbr_MI VARCHAR(5),
Prscrbr_Crdntls VARCHAR(20),
Prscrbr_Ent_Cd VARCHAR(5),
Prscrbr_St1 VARCHAR(100),
Prscrbr_St2 VARCHAR(100),
Prscrbr_City VARCHAR (100),
Prscrbr_State_Abrvtn VARCHAR(2),
Prscrbr_State_FIPS CHAR(5),
Prscrbr_zip5 CHAR(5),
Prscrbr_RUCA FLOAT,
Prscrbr_RUCA_Desc VARCHAR(100),
Prscrbr_Cntry VARCHAR(5),
Prscrbr_Type VARCHAR(100),
Prscrbr_Type_src VARCHAR(20),
Tot_Clms CHAR(10),
Tot_30day_Fills FLOAT,
Tot_Drug_Cst FLOAT,
Tot_Day_Suply CHAR(10),
Tot_Benes CHAR(10),
GE65_Sprsn_Flag VARCHAR(5),
GE65_Tot_Clms CHAR(10),
GE65_Tot_30day_Fills FLOAT,
GE65_Tot_Drug_Cst FLOAT,
GE65_Tot_Day_Suply CHAR(10),
GE65_Bene_Sprsn_Flag VARCHAR(5),
GE65_Tot_Benes CHAR(10),
Brnd_Sprsn_Flag VARCHAR(5),
Brnd_Tot_Clms CHAR(10),
Brnd_Tot_Drug_Cst FLOAT,
Gnrc_Sprsn_Flag VARCHAR(5),
Gnrc_Tot_Clms CHAR(10),
Gnrc_Tot_Drug_Cst FLOAT,
Othr_Sprsn_Flag VARCHAR(5),
Othr_Tot_Clms CHAR(10),
Othr_Tot_Drug_Cst FLOAT,
MAPD_Sprsn_Flag VARCHAR(5),
MAPD_Tot_Clms CHAR(10),
MAPD_Tot_Drug_Cst FLOAT,
PDP_Sprsn_Flag VARCHAR(5),
PDP_Tot_Clms CHAR(10),
PDP_Tot_Drug_Cst FLOAT,
LIS_Sprsn_Flag VARCHAR(5),
LIS_Tot_Clms CHAR(10),
LIS_Drug_Cst FLOAT,
NonLIS_Sprsn_Flag VARCHAR(5),
NonLIS_Tot_Clms CHAR(10),
NonLIS_Drug_Cst FLOAT,
Opioid_Tot_Clms CHAR(10),
Opioid_Tot_Drug_Cst FLOAT,
Opioid_Tot_Suply CHAR(10),
Opioid_Tot_Benes CHAR(10),
Opioid_Prscrbr_Rate FLOAT,
Opioid_LA_Tot_Clms CHAR(10),
Opioid_LA_Tot_Drug_Cst FLOAT,
Opioid_LA_Tot_Suply CHAR(10),
Opioid_LA_Tot_Benes CHAR(10),
Opioid_LA_Prscrbr_Rate FLOAT,
Antbtc_Tot_Clms CHAR(10),
Antbtc_Tot_Drug_Cst FLOAT,
Antbtc_Tot_Benes CHAR(10),
Antpsyct_GE65_Sprsn_Flag VARCHAR(5),
Antpsyct_GE65_Tot_Clms CHAR(10),
Antpsyct_GE65_Tot_Drug_Cst FLOAT,
Antpsyct_GE65_Bene_Suprsn_Flag VARCHAR(5),
Antpsyct_GE65_Tot_Benes CHAR(10),
Bene_Avg_Age FLOAT,
Bene_Age_LT_65_Cnt CHAR(10),
Bene_Age_65_74_Cnt CHAR(10),
Bene_Age_75_84_Cnt CHAR(10),
Bene_Age_GT_84_Cnt CHAR(10),
Bene_Feml_Cnt CHAR(10),
Bene_Male_Cnt CHAR(10),
Bene_Race_Wht_Cnt CHAR(10),
Bene_Race_Black_Cnt CHAR(10),
Bene_Race_Api_Cnt CHAR(10),
Bene_Race_Hspnc_Cnt CHAR(10),
Bene_Race_Natind_Cnt CHAR(10),
Bene_Race_Othr_Cnt CHAR(10),
Bene_Dual_Cnt CHAR(10),
Bene_Ndual_Cnt CHAR(10),
Bene_Avg_Risk_Scre FLOAT
);

CREATE TABLE medicare_part_d_2 (
Prscrbr_Geo_Lvl VARCHAR(10),
Prscrbr_Geo_Cd VARCHAR(10),
Prscrbr_Geo_Desc VARCHAR(50),
Brnd_Name VARCHAR(100),
Gnrc_Name VARCHAR(100),
Tot_Prscrbrs CHAR(10),
Tot_Clms CHAR(10),
Tot_30day_Fills FLOAT,
Tot_Drug_Cst FLOAT,
Tot_Benes CHAR(10),
GE65_Sprsn_Flag VARCHAR(5),
GE65_Tot_Clms CHAR(10),
GE65_Tot_30day_Fills FLOAT,
GE65_Tot_Drug_Cst FLOAT,
GE65_Bene_Sprsn_Flag VARCHAR(5),
GE65_Tot_Benes CHAR(10),
LIS_Bene_Cst_Shr FLOAT,
NonLIS_Bene_Cst_Shr FLOAT, 
Opioid_Drug_Flag VARCHAR(2),
Opioid_LA_Drug_Flag VARCHAR(2),
Antbtc_Drug_Flag VARCHAR(2),
Antpsyct_Drug_Flag VARCHAR(2)
);

CREATE TABLE medicare_part_d_3 (
Year_Medicare YEAR,
Prscrbr_Geo_Lvl VARCHAR(10),
Prscrbr_Geo_Cd CHAR(10),
Prscrbr_Geo_Desc VARCHAR(50),
RUCA_Cd FLOAT,
Breakout_Type VARCHAR(20),
Breakout VARCHAR(20),
Tot_Prscrbrs CHAR(10),
Tot_Opioid_Prscrbrs CHAR(10),
Tot_Opioid_Clms CHAR(10),
Tot_Clms CHAR(15),
Opioid_Prscrbng_Rate FLOAT,
Opioid_Prscrbng_Rate_5Y_Chg FLOAT,
Opioid_Prscrbng_Rate_1Y_Chg FLOAT,
LA_Tot_Opioid_Clms FLOAT,
LA_Opioid_Prscrbng_Rate FLOAT,
LA_Opioid_Prscrbng_Rate_5Y_Chg FLOAT,
LA_Opioid_Prscrbng_Rate_1Y_Chg FLOAT
);

LOAD DATA LOCAL INFILE 'C:/Users/dutch/Documents/Medicare_Part_D_1.csv'
INTO TABLE medicare_part_d
FIELDS TERMINATED BY ','
IGNORE 1 LINES
(PRSCRBR_NPI, Prscrbr_Last_Org_Name, Prscrbr_First_Name, Prscrbr_MI, Prscrbr_Crdntls, Prscrbr_Ent_Cd, Prscrbr_St1, Prscrbr_St2, Prscrbr_City, Prscrbr_State_Abrvtn, Prscrbr_State_FIPS, Prscrbr_zip5, Prscrbr_RUCA, Prscrbr_RUCA_Desc, Prscrbr_Cntry, Prscrbr_Type, Prscrbr_Type_src, Tot_Clms, Tot_30day_Fills, Tot_Drug_Cst, Tot_Day_Suply, Tot_Benes, GE65_Sprsn_Flag, GE65_Tot_Clms, GE65_Tot_30day_Fills, GE65_Tot_Drug_Cst, GE65_Tot_Day_Suply, GE65_Bene_Sprsn_Flag, GE65_Tot_Benes, Brnd_Sprsn_Flag, Brnd_Tot_Clms, Brnd_Tot_Drug_Cst, Gnrc_Sprsn_Flag, Gnrc_Tot_Clms, Gnrc_Tot_Drug_Cst, Othr_Sprsn_Flag, Othr_Tot_Clms, Othr_Tot_Drug_Cst, MAPD_Sprsn_Flag, MAPD_Tot_Clms, MAPD_Tot_Drug_Cst, PDP_Sprsn_Flag, PDP_Tot_Clms, PDP_Tot_Drug_Cst, LIS_Sprsn_Flag, LIS_Tot_Clms, LIS_Drug_Cst, NonLIS_Sprsn_Flag, NonLIS_Tot_Clms, NonLIS_Drug_Cst, Opioid_Tot_Clms, Opioid_Tot_Drug_Cst, Opioid_Tot_Suply, Opioid_Tot_Benes, Opioid_Prscrbr_Rate, Opioid_LA_Tot_Clms, Opioid_LA_Tot_Drug_Cst, Opioid_LA_Tot_Suply, Opioid_LA_Tot_Benes, Opioid_LA_Prscrbr_Rate, Antbtc_Tot_Clms, Antbtc_Tot_Drug_Cst, Antbtc_Tot_Benes, Antpsyct_GE65_Sprsn_Flag, Antpsyct_GE65_Tot_Clms, Antpsyct_GE65_Tot_Drug_Cst, Antpsyct_GE65_Bene_Suprsn_Flag, Antpsyct_GE65_Tot_Benes, Bene_Avg_Age, Bene_Age_LT_65_Cnt, Bene_Age_65_74_Cnt, Bene_Age_75_84_Cnt, Bene_Age_GT_84_Cnt,Bene_Feml_Cnt, Bene_Male_Cnt, Bene_Race_Wht_Cnt, Bene_Race_Black_Cnt, Bene_Race_Api_Cnt, Bene_Race_Hspnc_Cnt, Bene_Race_Natind_Cnt, Bene_Race_Othr_Cnt, Bene_Dual_Cnt, Bene_Ndual_Cnt, Bene_Avg_Risk_Scre);
SELECT *
FROM medicare_part_d;

LOAD DATA LOCAL INFILE 'C:/Users/dutch/Documents/Medicare_Part_D_2.csv'
INTO TABLE medicare_part_d_2
FIELDS TERMINATED BY ','
IGNORE 1 LINES
(Prscrbr_Geo_Lvl, Prscrbr_Geo_Cd, Prscrbr_Geo_Desc, Brnd_Name, Gnrc_Name, Tot_Prscrbrs, Tot_Clms, Tot_30day_Fills, Tot_Drug_Cst, Tot_Benes, GE65_Sprsn_Flag, GE65_Tot_Clms, GE65_Tot_30day_Fills, GE65_Tot_Drug_Cst, GE65_Bene_Sprsn_Flag, GE65_Tot_Benes, LIS_Bene_Cst_Shr, NonLIS_Bene_Cst_Shr, Opioid_Drug_Flag, Opioid_LA_Drug_Flag, Antbtc_Drug_Flag, Antpsyct_Drug_Flag);
SELECT *
FROM medicare_part_d_2;

LOAD DATA LOCAL INFILE 'C:/Users/dutch/Documents/Medicare_Part_D_3.csv'
INTO TABLE medicare_part_d_3
FIELDS TERMINATED BY ','
IGNORE 1 LINES
(Year_Medicare, Prscrbr_Geo_Lvl, Prscrbr_Geo_Cd, Prscrbr_Geo_Desc, RUCA_Cd, Breakout_Type, Breakout, Tot_Prscrbrs, Tot_Opioid_Prscrbrs, Tot_Opioid_Clms, Tot_Clms, Opioid_Prscrbng_Rate, Opioid_Prscrbng_Rate_5Y_Chg, Opioid_Prscrbng_Rate_1Y_Chg, LA_Tot_Opioid_Clms, LA_Opioid_Prscrbng_Rate, LA_Opioid_Prscrbng_Rate_5Y_Chg, LA_Opioid_Prscrbng_Rate_1Y_Chg);
SELECT *
FROM medicare_part_d_3;

CREATE TABLE medicare_part_d_staging
LIKE medicare_part_d;
SELECT *
FROM medicare_part_d_staging;
INSERT medicare_part_d_staging
SELECT *
FROM medicare_part_d;

SELECT *,
ROW_NUMBER() OVER(PARTITION BY PRSCRBR_NPI, Prscrbr_Last_Org_Name, Prscrbr_First_Name, Prscrbr_MI, Prscrbr_Crdntls, Prscrbr_Ent_Cd, Prscrbr_St1, Prscrbr_St2, Prscrbr_City, Prscrbr_State_Abrvtn, Prscrbr_State_FIPS, Prscrbr_zip5, Prscrbr_RUCA, Prscrbr_RUCA_Desc, Prscrbr_Cntry, Prscrbr_Type, Prscrbr_Type_src, Tot_Clms, Tot_30day_Fills, Tot_Drug_Cst, Tot_Day_Suply, Tot_Benes, GE65_Sprsn_Flag, GE65_Tot_Clms, GE65_Tot_30day_Fills, GE65_Tot_Drug_Cst, GE65_Tot_Day_Suply, GE65_Bene_Sprsn_Flag, GE65_Tot_Benes, Brnd_Sprsn_Flag, Brnd_Tot_Clms, Brnd_Tot_Drug_Cst, Gnrc_Sprsn_Flag, Gnrc_Tot_Clms, Gnrc_Tot_Drug_Cst, Othr_Sprsn_Flag, Othr_Tot_Clms, Othr_Tot_Drug_Cst, MAPD_Sprsn_Flag, MAPD_Tot_Clms, MAPD_Tot_Drug_Cst, PDP_Sprsn_Flag, PDP_Tot_Clms, PDP_Tot_Drug_Cst, LIS_Sprsn_Flag, LIS_Tot_Clms, LIS_Drug_Cst, NonLIS_Sprsn_Flag, NonLIS_Tot_Clms, NonLIS_Drug_Cst, Opioid_Tot_Clms, Opioid_Tot_Drug_Cst, Opioid_Tot_Suply, Opioid_Tot_Benes, Opioid_Prscrbr_Rate, Opioid_LA_Tot_Clms, Opioid_LA_Tot_Drug_Cst, Opioid_LA_Tot_Suply, Opioid_LA_Tot_Benes, Opioid_LA_Prscrbr_Rate, Antbtc_Tot_Clms, Antbtc_Tot_Drug_Cst, Antbtc_Tot_Benes, Antpsyct_GE65_Sprsn_Flag, Antpsyct_GE65_Tot_Clms, Antpsyct_GE65_Tot_Drug_Cst, Antpsyct_GE65_Bene_Suprsn_Flag, Antpsyct_GE65_Tot_Benes, Bene_Avg_Age, Bene_Age_LT_65_Cnt, Bene_Age_65_74_Cnt, Bene_Age_75_84_Cnt, Bene_Age_GT_84_Cnt,Bene_Feml_Cnt, Bene_Male_Cnt, Bene_Race_Wht_Cnt, Bene_Race_Black_Cnt, Bene_Race_Api_Cnt, Bene_Race_Hspnc_Cnt, Bene_Race_Natind_Cnt, Bene_Race_Othr_Cnt, Bene_Dual_Cnt, Bene_Ndual_Cnt, Bene_Avg_Risk_Scre) AS row_num
FROM medicare_part_d_staging;

WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER() OVER(
PARTITION BY PRSCRBR_NPI, Prscrbr_Last_Org_Name, Prscrbr_First_Name, Prscrbr_MI, Prscrbr_Crdntls, Prscrbr_Ent_Cd, Prscrbr_St1, Prscrbr_St2, Prscrbr_City, Prscrbr_State_Abrvtn, Prscrbr_State_FIPS, Prscrbr_zip5, Prscrbr_RUCA, Prscrbr_RUCA_Desc, Prscrbr_Cntry, Prscrbr_Type, Prscrbr_Type_src, Tot_Clms, Tot_30day_Fills, Tot_Drug_Cst, Tot_Day_Suply, Tot_Benes, GE65_Sprsn_Flag, GE65_Tot_Clms, GE65_Tot_30day_Fills, GE65_Tot_Drug_Cst, GE65_Tot_Day_Suply, GE65_Bene_Sprsn_Flag, GE65_Tot_Benes, Brnd_Sprsn_Flag, Brnd_Tot_Clms, Brnd_Tot_Drug_Cst, Gnrc_Sprsn_Flag, Gnrc_Tot_Clms, Gnrc_Tot_Drug_Cst, Othr_Sprsn_Flag, Othr_Tot_Clms, Othr_Tot_Drug_Cst, MAPD_Sprsn_Flag, MAPD_Tot_Clms, MAPD_Tot_Drug_Cst, PDP_Sprsn_Flag, PDP_Tot_Clms, PDP_Tot_Drug_Cst, LIS_Sprsn_Flag, LIS_Tot_Clms, LIS_Drug_Cst, NonLIS_Sprsn_Flag, NonLIS_Tot_Clms, NonLIS_Drug_Cst, Opioid_Tot_Clms, Opioid_Tot_Drug_Cst, Opioid_Tot_Suply, Opioid_Tot_Benes, Opioid_Prscrbr_Rate, Opioid_LA_Tot_Clms, Opioid_LA_Tot_Drug_Cst, Opioid_LA_Tot_Suply, Opioid_LA_Tot_Benes, Opioid_LA_Prscrbr_Rate, Antbtc_Tot_Clms, Antbtc_Tot_Drug_Cst, Antbtc_Tot_Benes, Antpsyct_GE65_Sprsn_Flag, Antpsyct_GE65_Tot_Clms, Antpsyct_GE65_Tot_Drug_Cst, Antpsyct_GE65_Bene_Suprsn_Flag, Antpsyct_GE65_Tot_Benes, Bene_Avg_Age, Bene_Age_LT_65_Cnt, Bene_Age_65_74_Cnt, Bene_Age_75_84_Cnt, Bene_Age_GT_84_Cnt,Bene_Feml_Cnt, Bene_Male_Cnt, Bene_Race_Wht_Cnt, Bene_Race_Black_Cnt, Bene_Race_Api_Cnt, Bene_Race_Hspnc_Cnt, Bene_Race_Natind_Cnt, Bene_Race_Othr_Cnt, Bene_Dual_Cnt, Bene_Ndual_Cnt, Bene_Avg_Risk_Scre) AS row_num
FROM medicare_part_d_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num >= 1;

CREATE TABLE `medicare_part_d_staging2` (
`PRSCRBR_NPI` CHAR(12) DEFAULT NULL,
`Prscrbr_Last_Org_Name` VARCHAR(20) DEFAULT NULL,
`Prscrbr_First_Name` VARCHAR(20) DEFAULT NULL,
`Prscrbr_MI` VARCHAR(5) DEFAULT NULL,
`Prscrbr_Crdntls` VARCHAR(20) DEFAULT NULL,
`Prscrbr_Ent_Cd` VARCHAR(5) DEFAULT NULL,
`Prscrbr_St1` VARCHAR(100) DEFAULT NULL,
`Prscrbr_St2` VARCHAR(100) DEFAULT NULL,
`Prscrbr_City` VARCHAR (100) DEFAULT NULL,
`Prscrbr_State_Abrvtn` VARCHAR(2) DEFAULT NULL,
`Prscrbr_State_FIPS` CHAR(5) DEFAULT NULL,
`Prscrbr_zip5` CHAR(5) DEFAULT NULL,
`Prscrbr_RUCA` FLOAT DEFAULT NULL,
`Prscrbr_RUCA_Desc` VARCHAR(100) DEFAULT NULL,
`Prscrbr_Cntry` VARCHAR(5) DEFAULT NULL,
`Prscrbr_Type` VARCHAR(100) DEFAULT NULL,
`Prscrbr_Type_src` VARCHAR(20) DEFAULT NULL,
`Tot_Clms` CHAR(10) DEFAULT NULL,
`Tot_30day_Fills` FLOAT DEFAULT NULL,
`Tot_Drug_Cst` FLOAT DEFAULT NULL,
`Tot_Day_Suply` CHAR(10) DEFAULT NULL,
`Tot_Benes` CHAR(10) DEFAULT NULL,
`GE65_Sprsn_Flag` VARCHAR(5) DEFAULT NULL,
`GE65_Tot_Clms` CHAR(10) DEFAULT NULL,
`GE65_Tot_30day_Fills` FLOAT DEFAULT NULL,
`GE65_Tot_Drug_Cst` FLOAT DEFAULT NULL,
`GE65_Tot_Day_Suply` CHAR(10) DEFAULT NULL,
`GE65_Bene_Sprsn_Flag` VARCHAR(5) DEFAULT NULL,
`GE65_Tot_Benes` CHAR(10) DEFAULT NULL,
`Brnd_Sprsn_Flag` VARCHAR(5) DEFAULT NULL,
`Brnd_Tot_Clms` CHAR(10) DEFAULT NULL,
`Brnd_Tot_Drug_Cst` FLOAT DEFAULT NULL,
`Gnrc_Sprsn_Flag` VARCHAR(5) DEFAULT NULL,
`Gnrc_Tot_Clms` CHAR(10) DEFAULT NULL,
`Gnrc_Tot_Drug_Cst` FLOAT DEFAULT NULL,
`Othr_Sprsn_Flag` VARCHAR(5) DEFAULT NULL,
`Othr_Tot_Clms` CHAR(10) DEFAULT NULL,
`Othr_Tot_Drug_Cst` FLOAT DEFAULT NULL,
`MAPD_Sprsn_Flag` VARCHAR(5) DEFAULT NULL,
`MAPD_Tot_Clms` CHAR(10) DEFAULT NULL,
`MAPD_Tot_Drug_Cst` FLOAT DEFAULT NULL,
`PDP_Sprsn_Flag` VARCHAR(5) DEFAULT NULL,
`PDP_Tot_Clms` CHAR(10) DEFAULT NULL,
`PDP_Tot_Drug_Cst` FLOAT DEFAULT NULL,
`LIS_Sprsn_Flag` VARCHAR(5) DEFAULT NULL,
`LIS_Tot_Clms` CHAR(10) DEFAULT NULL,
`LIS_Drug_Cst` FLOAT DEFAULT NULL,
`NonLIS_Sprsn_Flag` VARCHAR(5) DEFAULT NULL,
`NonLIS_Tot_Clms` CHAR(10) DEFAULT NULL,
`NonLIS_Drug_Cst` FLOAT DEFAULT NULL,
`Opioid_Tot_Clms` CHAR(10) DEFAULT NULL,
`Opioid_Tot_Drug_Cst` FLOAT DEFAULT NULL,
`Opioid_Tot_Suply` CHAR(10) DEFAULT NULL,
`Opioid_Tot_Benes` CHAR(10) DEFAULT NULL,
`Opioid_Prscrbr_Rate` FLOAT DEFAULT NULL,
`Opioid_LA_Tot_Clms` CHAR(10) DEFAULT NULL,
`Opioid_LA_Tot_Drug_Cst` FLOAT DEFAULT NULL,
`Opioid_LA_Tot_Suply` CHAR(10) DEFAULT NULL,
`Opioid_LA_Tot_Benes` CHAR(10) DEFAULT NULL,
`Opioid_LA_Prscrbr_Rate` FLOAT DEFAULT NULL,
`Antbtc_Tot_Clms` CHAR(10) DEFAULT NULL,
`Antbtc_Tot_Drug_Cst` FLOAT DEFAULT NULL,
`Antbtc_Tot_Benes` CHAR(10) DEFAULT NULL,
`Antpsyct_GE65_Sprsn_Flag` VARCHAR(5) DEFAULT NULL,
`Antpsyct_GE65_Tot_Clms` CHAR(10) DEFAULT NULL,
`Antpsyct_GE65_Tot_Drug_Cst` FLOAT DEFAULT NULL,
`Antpsyct_GE65_Bene_Suprsn_Flag` VARCHAR(5) DEFAULT NULL,
`Antpsyct_GE65_Tot_Benes` CHAR(10) DEFAULT NULL,
`Bene_Avg_Age` FLOAT DEFAULT NULL,
`Bene_Age_LT_65_Cnt` CHAR(10) DEFAULT NULL,
`Bene_Age_65_74_Cnt` CHAR(10) DEFAULT NULL,
`Bene_Age_75_84_Cnt` CHAR(10) DEFAULT NULL,
`Bene_Age_GT_84_Cnt` CHAR(10) DEFAULT NULL,
`Bene_Feml_Cnt` CHAR(10) DEFAULT NULL,
`Bene_Male_Cnt` CHAR(10) DEFAULT NULL,
`Bene_Race_Wht_Cnt` CHAR(10) DEFAULT NULL,
`Bene_Race_Black_Cnt` CHAR(10) DEFAULT NULL,
`Bene_Race_Api_Cnt` CHAR(10) DEFAULT NULL,
`Bene_Race_Hspnc_Cnt` CHAR(10) DEFAULT NULL,
`Bene_Race_Natind_Cnt` CHAR(10) DEFAULT NULL,
`Bene_Race_Othr_Cnt` CHAR(10) DEFAULT NULL,
`Bene_Dual_Cnt` CHAR(10) DEFAULT NULL,
`Bene_Ndual_Cnt` CHAR(10) DEFAULT NULL,
`Bene_Avg_Risk_Scre` FLOAT DEFAULT NULL,
`row_num` INT 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM medicare_part_d_staging2
WHERE row_num > 1;

INSERT INTO medicare_part_d_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY PRSCRBR_NPI, Prscrbr_Last_Org_Name, Prscrbr_First_Name, Prscrbr_MI, Prscrbr_Crdntls, Prscrbr_Ent_Cd, Prscrbr_St1, Prscrbr_St2, Prscrbr_City, Prscrbr_State_Abrvtn, Prscrbr_State_FIPS, Prscrbr_zip5, Prscrbr_RUCA, Prscrbr_RUCA_Desc, Prscrbr_Cntry, Prscrbr_Type, Prscrbr_Type_src, Tot_Clms, Tot_30day_Fills, Tot_Drug_Cst, Tot_Day_Suply, Tot_Benes, GE65_Sprsn_Flag, GE65_Tot_Clms, GE65_Tot_30day_Fills, GE65_Tot_Drug_Cst, GE65_Tot_Day_Suply, GE65_Bene_Sprsn_Flag, GE65_Tot_Benes, Brnd_Sprsn_Flag, Brnd_Tot_Clms, Brnd_Tot_Drug_Cst, Gnrc_Sprsn_Flag, Gnrc_Tot_Clms, Gnrc_Tot_Drug_Cst, Othr_Sprsn_Flag, Othr_Tot_Clms, Othr_Tot_Drug_Cst, MAPD_Sprsn_Flag, MAPD_Tot_Clms, MAPD_Tot_Drug_Cst, PDP_Sprsn_Flag, PDP_Tot_Clms, PDP_Tot_Drug_Cst, LIS_Sprsn_Flag, LIS_Tot_Clms, LIS_Drug_Cst, NonLIS_Sprsn_Flag, NonLIS_Tot_Clms, NonLIS_Drug_Cst, Opioid_Tot_Clms, Opioid_Tot_Drug_Cst, Opioid_Tot_Suply, Opioid_Tot_Benes, Opioid_Prscrbr_Rate, Opioid_LA_Tot_Clms, Opioid_LA_Tot_Drug_Cst, Opioid_LA_Tot_Suply, Opioid_LA_Tot_Benes, Opioid_LA_Prscrbr_Rate, Antbtc_Tot_Clms, Antbtc_Tot_Drug_Cst, Antbtc_Tot_Benes, Antpsyct_GE65_Sprsn_Flag, Antpsyct_GE65_Tot_Clms, Antpsyct_GE65_Tot_Drug_Cst, Antpsyct_GE65_Bene_Suprsn_Flag, Antpsyct_GE65_Tot_Benes, Bene_Avg_Age, Bene_Age_LT_65_Cnt, Bene_Age_65_74_Cnt, Bene_Age_75_84_Cnt, Bene_Age_GT_84_Cnt,Bene_Feml_Cnt, Bene_Male_Cnt, Bene_Race_Wht_Cnt, Bene_Race_Black_Cnt, Bene_Race_Api_Cnt, Bene_Race_Hspnc_Cnt, Bene_Race_Natind_Cnt, Bene_Race_Othr_Cnt, Bene_Dual_Cnt, Bene_Ndual_Cnt, Bene_Avg_Risk_Scre) AS row_num
FROM medicare_part_d_staging;
DELETE
FROM medicare_part_d_staging2
WHERE row_num > 1;
SELECT *
FROM medicare_part_d_staging2;

CREATE TABLE medicare_part_d_2_staging
LIKE medicare_part_d_2;
SELECT *
FROM medicare_part_d_2_staging;
INSERT medicare_part_d_2_staging
SELECT *
FROM medicare_part_d_2;

SELECT *,
ROW_NUMBER() OVER(PARTITION BY Prscrbr_Geo_Lvl, Prscrbr_Geo_Cd, Prscrbr_Geo_Desc, Brnd_Name, Gnrc_Name, Tot_Prscrbrs, Tot_Clms, Tot_30day_Fills, Tot_Drug_Cst, Tot_Benes, GE65_Sprsn_Flag, GE65_Tot_Clms, GE65_Tot_30day_Fills, GE65_Tot_Drug_Cst, GE65_Bene_Sprsn_Flag, GE65_Tot_Benes, LIS_Bene_Cst_Shr, NonLIS_Bene_Cst_Shr, Opioid_Drug_Flag, Opioid_LA_Drug_Flag, Antbtc_Drug_Flag, Antpsyct_Drug_Flag) AS row_num
FROM medicare_part_d_2_staging;

WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Prscrbr_Geo_Lvl, Prscrbr_Geo_Cd, Prscrbr_Geo_Desc, Brnd_Name, Gnrc_Name, Tot_Prscrbrs, Tot_Clms, Tot_30day_Fills, Tot_Drug_Cst, Tot_Benes, GE65_Sprsn_Flag, GE65_Tot_Clms, GE65_Tot_30day_Fills, GE65_Tot_Drug_Cst, GE65_Bene_Sprsn_Flag, GE65_Tot_Benes, LIS_Bene_Cst_Shr, NonLIS_Bene_Cst_Shr, Opioid_Drug_Flag, Opioid_LA_Drug_Flag, Antbtc_Drug_Flag, Antpsyct_Drug_Flag) AS row_num
FROM medicare_part_d_2_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num >= 1;

CREATE TABLE `medicare_part_d_2_staging2` (
`Prscrbr_Geo_Lvl` VARCHAR(10) DEFAULT NULL,
`Prscrbr_Geo_Cd` VARCHAR(10) DEFAULT NULL,
`Prscrbr_Geo_Desc` VARCHAR(50) DEFAULT NULL,
`Brnd_Name` VARCHAR(100) DEFAULT NULL,
`Gnrc_Name` VARCHAR(100) DEFAULT NULL,
`Tot_Prscrbrs` CHAR(10) DEFAULT NULL,
`Tot_Clms` CHAR(10) DEFAULT NULL,
`Tot_30day_Fills` FLOAT DEFAULT NULL,
`Tot_Drug_Cst` FLOAT DEFAULT NULL,
`Tot_Benes` CHAR(10) DEFAULT NULL,
`GE65_Sprsn_Flag` VARCHAR(5) DEFAULT NULL,
`GE65_Tot_Clms` CHAR(10) DEFAULT NULL,
`GE65_Tot_30day_Fills` FLOAT DEFAULT NULL,
`GE65_Tot_Drug_Cst` FLOAT DEFAULT NULL,
`GE65_Bene_Sprsn_Flag` VARCHAR(5) DEFAULT NULL,
`GE65_Tot_Benes` CHAR(10) DEFAULT NULL,
`LIS_Bene_Cst_Shr` FLOAT DEFAULT NULL,
`NonLIS_Bene_Cst_Shr` FLOAT DEFAULT NULL, 
`Opioid_Drug_Flag` VARCHAR(2) DEFAULT NULL,
`Opioid_LA_Drug_Flag` VARCHAR(2) DEFAULT NULL,
`Antbtc_Drug_Flag` VARCHAR(2) DEFAULT NULL,
`Antpsyct_Drug_Flag` VARCHAR(2) DEFAULT NULL,
 `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM medicare_part_d_2_staging2
WHERE row_num > 1;

INSERT INTO medicare_part_d_2_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Prscrbr_Geo_Lvl, Prscrbr_Geo_Cd, Prscrbr_Geo_Desc, Brnd_Name, Gnrc_Name, Tot_Prscrbrs, Tot_Clms, Tot_30day_Fills, Tot_Drug_Cst, Tot_Benes, GE65_Sprsn_Flag, GE65_Tot_Clms, GE65_Tot_30day_Fills, GE65_Tot_Drug_Cst, GE65_Bene_Sprsn_Flag, GE65_Tot_Benes, LIS_Bene_Cst_Shr, NonLIS_Bene_Cst_Shr, Opioid_Drug_Flag, Opioid_LA_Drug_Flag, Antbtc_Drug_Flag, Antpsyct_Drug_Flag) AS row_num
FROM medicare_part_d_2_staging;
DELETE
FROM medicare_part_d_2_staging2
WHERE row_num > 1;
SELECT *
FROM medicare_part_d_2_staging2;

CREATE TABLE medicare_part_d_3_staging
LIKE medicare_part_d_3;
SELECT *
FROM medicare_part_d_3_staging;
INSERT medicare_part_d_3_staging
SELECT *
FROM medicare_part_d_3;

SELECT *,
ROW_NUMBER() OVER(PARTITION BY Year_Medicare, Prscrbr_Geo_Lvl, Prscrbr_Geo_Cd, Prscrbr_Geo_Desc, RUCA_Cd, Breakout_Type, Breakout, Tot_Prscrbrs, Tot_Opioid_Prscrbrs, Tot_Opioid_Clms, Tot_Clms, Opioid_Prscrbng_Rate, Opioid_Prscrbng_Rate_5Y_Chg, Opioid_Prscrbng_Rate_1Y_Chg, LA_Tot_Opioid_Clms, LA_Opioid_Prscrbng_Rate, LA_Opioid_Prscrbng_Rate_5Y_Chg, LA_Opioid_Prscrbng_Rate_1Y_Chg) AS row_num
FROM medicare_part_d_3_staging;

WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Year_Medicare, Prscrbr_Geo_Lvl, Prscrbr_Geo_Cd, Prscrbr_Geo_Desc, RUCA_Cd, Breakout_Type, Breakout, Tot_Prscrbrs, Tot_Opioid_Prscrbrs, Tot_Opioid_Clms, Tot_Clms, Opioid_Prscrbng_Rate, Opioid_Prscrbng_Rate_5Y_Chg, Opioid_Prscrbng_Rate_1Y_Chg, LA_Tot_Opioid_Clms, LA_Opioid_Prscrbng_Rate, LA_Opioid_Prscrbng_Rate_5Y_Chg, LA_Opioid_Prscrbng_Rate_1Y_Chg) AS row_num
FROM medicare_part_d_3_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num >= 1;

CREATE TABLE `medicare_part_d_3_staging2` (
`Year_Medicare` YEAR DEFAULT NULL,
`Prscrbr_Geo_Lvl` VARCHAR(10) DEFAULT NULL,
`Prscrbr_Geo_Cd` CHAR(10) DEFAULT NULL,
`Prscrbr_Geo_Desc` VARCHAR(50) DEFAULT NULL,
`RUCA_Cd` FLOAT DEFAULT NULL,
`Breakout_Type` VARCHAR(20) DEFAULT NULL,
`Breakout` VARCHAR(20) DEFAULT NULL,
`Tot_Prscrbrs` CHAR(10) DEFAULT NULL,
`Tot_Opioid_Prscrbrs` CHAR(10) DEFAULT NULL,
`Tot_Opioid_Clms` CHAR(10) DEFAULT NULL,
`Tot_Clms` CHAR(15) DEFAULT NULL,
`Opioid_Prscrbng_Rate` FLOAT DEFAULT NULL,
`Opioid_Prscrbng_Rate_5Y_Chg` FLOAT DEFAULT NULL,
`Opioid_Prscrbng_Rate_1Y_Chg` FLOAT DEFAULT NULL,
`LA_Tot_Opioid_Clms` FLOAT DEFAULT NULL,
`LA_Opioid_Prscrbng_Rate` FLOAT DEFAULT NULL,
`LA_Opioid_Prscrbng_Rate_5Y_Chg` FLOAT DEFAULT NULL,
`LA_Opioid_Prscrbng_Rate_1Y_Chg` FLOAT DEFAULT NULL,
`row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM medicare_part_d_3_staging2
WHERE row_num > 1;

INSERT INTO medicare_part_d_3_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY Year_Medicare, Prscrbr_Geo_Lvl, Prscrbr_Geo_Cd, Prscrbr_Geo_Desc, RUCA_Cd, Breakout_Type, Breakout, Tot_Prscrbrs, Tot_Opioid_Prscrbrs, Tot_Opioid_Clms, Tot_Clms, Opioid_Prscrbng_Rate, Opioid_Prscrbng_Rate_5Y_Chg, Opioid_Prscrbng_Rate_1Y_Chg, LA_Tot_Opioid_Clms, LA_Opioid_Prscrbng_Rate, LA_Opioid_Prscrbng_Rate_5Y_Chg, LA_Opioid_Prscrbng_Rate_1Y_Chg) AS row_num
FROM medicare_part_d_3_staging;
DELETE
FROM medicare_part_d_3_staging2
WHERE row_num > 1;
SELECT *
FROM medicare_part_d_3_staging2;

-- STANDARDIZING THE DATA

UPDATE medicare_part_d_staging2
SET
    PRSCRBR_NPI = TRIM(PRSCRBR_NPI),
    Prscrbr_Last_Org_Name = TRIM(Prscrbr_Last_Org_Name),
    Prscrbr_First_Name = TRIM(Prscrbr_First_Name),
    Prscrbr_MI = TRIM(Prscrbr_MI),
    Prscrbr_Crdntls = TRIM(Prscrbr_Crdntls),
    Prscrbr_Ent_Cd = TRIM(Prscrbr_Ent_Cd),
    Prscrbr_St1 = TRIM(Prscrbr_St1),
    Prscrbr_St2 = TRIM(Prscrbr_St2),
    Prscrbr_City = TRIM(Prscrbr_City),
    Prscrbr_State_Abrvtn = TRIM(Prscrbr_State_Abrvtn),
    Prscrbr_State_FIPS = TRIM(Prscrbr_State_FIPS),
    Prscrbr_zip5 = TRIM(Prscrbr_zip5),
    Prscrbr_RUCA_Desc = TRIM(Prscrbr_RUCA_Desc),
    Prscrbr_Cntry = TRIM(Prscrbr_Cntry),
    Prscrbr_Type = TRIM(Prscrbr_Type),
    Prscrbr_Type_src = TRIM(Prscrbr_Type_src),
    GE65_Sprsn_Flag = TRIM(GE65_Sprsn_Flag),
    GE65_Bene_Sprsn_Flag = TRIM(GE65_Bene_Sprsn_Flag),
    Brnd_Sprsn_Flag = TRIM(Brnd_Sprsn_Flag),
    Gnrc_Sprsn_Flag = TRIM(Gnrc_Sprsn_Flag),
    Othr_Sprsn_Flag = TRIM(Othr_Sprsn_Flag),
    MAPD_Sprsn_Flag = TRIM(MAPD_Sprsn_Flag),
    PDP_Sprsn_Flag = TRIM(PDP_Sprsn_Flag),
    LIS_Sprsn_Flag = TRIM(LIS_Sprsn_Flag),
    NonLIS_Sprsn_Flag = TRIM(NonLIS_Sprsn_Flag),
    Antpsyct_GE65_Sprsn_Flag = TRIM(Antpsyct_GE65_Sprsn_Flag);

UPDATE medicare_part_d_2_staging2
SET
    Prscrbr_Geo_Lvl = TRIM(Prscrbr_Geo_Lvl),
    Prscrbr_Geo_Cd = TRIM(Prscrbr_Geo_Cd),
    Prscrbr_Geo_Desc = TRIM(Prscrbr_Geo_Desc),
    Brnd_Name = TRIM(Brnd_Name),
    Gnrc_Name = TRIM(Gnrc_Name),
    Tot_Prscrbrs = TRIM(Tot_Prscrbrs),
    Tot_Clms = TRIM(Tot_Clms),
    Tot_Benes = TRIM(Tot_Benes),
    GE65_Sprsn_Flag = TRIM(GE65_Sprsn_Flag),
    GE65_Tot_Clms = TRIM(GE65_Tot_Clms),
    GE65_Bene_Sprsn_Flag = TRIM(GE65_Bene_Sprsn_Flag),
    GE65_Tot_Benes = TRIM(GE65_Tot_Benes),
    Opioid_Drug_Flag = TRIM(Opioid_Drug_Flag),
    Opioid_LA_Drug_Flag = TRIM(Opioid_LA_Drug_Flag),
    Antbtc_Drug_Flag = TRIM(Antbtc_Drug_Flag),
    Antpsyct_Drug_Flag = TRIM(Antpsyct_Drug_Flag);

UPDATE medicare_part_d_3_staging2
SET
    Prscrbr_Geo_Lvl = TRIM(Prscrbr_Geo_Lvl),
    Prscrbr_Geo_Cd = TRIM(Prscrbr_Geo_Cd),
    Prscrbr_Geo_Desc = TRIM(Prscrbr_Geo_Desc),
    Breakout_Type = TRIM(Breakout_Type),
    Breakout = TRIM(Breakout),
    Tot_Prscrbrs = TRIM(Tot_Prscrbrs),
    Tot_Opioid_Prscrbrs = TRIM(Tot_Opioid_Prscrbrs),
    Tot_Opioid_Clms = TRIM(Tot_Opioid_Clms),
    Tot_Clms = TRIM(Tot_Clms);
    
SELECT DISTINCT Prscrbr_MI
FROM medicare_part_d_staging2
ORDER BY 1;

UPDATE medicare_part_d_staging2
SET Prscrbr_MI = NULL 
WHERE Prscrbr_MI IN ('-', '''', '(', '0', '2', '5', '6');

SELECT DISTINCT Prscrbr_City
FROM medicare_part_d_staging2
ORDER BY 1;

UPDATE medicare_part_d_staging2
SET Prscrbr_City = CASE 
    WHEN Prscrbr_City = '1 Jarrett White Road'     THEN 'Honolulu'
    WHEN Prscrbr_City = '1120 15th St'             THEN 'Augusta'
    WHEN Prscrbr_City = '150bergen Streetnewark'   THEN 'Newark'
    WHEN Prscrbr_City = '19131'                    THEN 'Philadelphia'
    WHEN Prscrbr_City = '222-19 Linden Blvd'       THEN 'Jamaica'
    WHEN Prscrbr_City = '2500 Alhambra Avenue'     THEN 'Martinez'
    ELSE Prscrbr_City
END
WHERE Prscrbr_City IN (
    '1 Jarrett White Road',
    '1120 15th St',
    '150bergen Streetnewark',
    '19131',
    '222-19 Linden Blvd',
    '2500 Alhambra Avenue'
);

UPDATE medicare_part_d_staging2
SET Prscrbr_City = NULL
WHERE Prscrbr_City IN ('200', '3 Fl', '400"', '420', '612', 'A.P.O.');

-- REMOVING COLUMNS AND ROWS

SELECT *
FROM medicare_part_d_3_staging2
WHERE Tot_Prscrbrs IS NULL
AND Tot_Opioid_Prscrbrs IS NULL
AND Tot_Opioid_Clms IS NULL;

SELECT COUNT(*)
FROM medicare_part_d_3_staging2
WHERE Tot_Prscrbrs IS NULL
AND Tot_Opioid_Prscrbrs IS NULL
AND Tot_Opioid_Clms IS NULL;

DELETE
FROM medicare_part_d_3_staging2
WHERE Tot_Prscrbrs IS NULL
AND Tot_Opioid_Prscrbrs IS NULL
AND Tot_Opioid_Clms IS NULL;

-- JOINING DATA

SELECT
    p.PRSCRBR_NPI AS npi,
    CONCAT(p.Prscrbr_First_Name, ' ', p.Prscrbr_Last_Org_Name) AS prescriber_name,
    d2.Brnd_Name AS brand,
    d2.Tot_Clms AS brand_claims,
    d2.Tot_Drug_Cst AS drug_cost,
    d3.Year_Medicare AS year_medicare,
    d3.Tot_Prscrbrs AS perscribers,
    d3.Tot_Opioid_Prscrbrs AS opioid_perscribers, 
	d3.Tot_Opioid_Clms AS opioid_claims,
    d3.Tot_Clms AS overall_claims 
FROM medicare_part_d_staging2 p
JOIN medicare_part_d_2_staging2 d2
    ON p.Prscrbr_State_Abrvtn = d2.Prscrbr_Geo_Cd
JOIN medicare_part_d_3_staging2 d3
    ON d2.Prscrbr_Geo_Cd = d3.Prscrbr_Geo_Cd
ORDER BY d3.Year_Medicare ASC, overall_claims DESC;

CREATE TABLE medicare_combined AS
SELECT
    p.PRSCRBR_NPI AS npi,
    CONCAT(p.Prscrbr_First_Name, ' ', p.Prscrbr_Last_Org_Name) AS prescriber_name,
    d2.Brnd_Name AS brand,
    d2.Tot_Clms AS brand_claims,
    d2.Tot_Drug_Cst AS drug_cost,
    d3.Year_Medicare AS year_medicare,
    d3.Tot_Prscrbrs AS prescribers,
    d3.Tot_Opioid_Prscrbrs AS opioid_prescribers, 
    d3.Tot_Opioid_Clms AS opioid_claims,
    d3.Tot_Clms AS overall_claims 
FROM medicare_part_d_staging2 p
JOIN medicare_part_d_2_staging2 d2
    ON p.Prscrbr_State_Abrvtn = d2.Prscrbr_Geo_Cd
JOIN medicare_part_d_3_staging2 d3
    ON d2.Prscrbr_Geo_Cd = d3.Prscrbr_Geo_Cd
ORDER BY d3.Year_Medicare ASC, overall_claims DESC;

-- EXPLOATORY ANALYSIS

SELECT *
FROM medicare_combined;

SELECT COUNT(*)
FROM medicare_combined;

-- Highest & Lowest Overall and Opioid Claims per Year (with prescriber details)
WITH ranked AS (
    SELECT
        year_medicare,
        npi,
        prescriber_name,
        brand,
        overall_claims,
        opioid_claims,

        ROW_NUMBER() OVER (PARTITION BY year_medicare ORDER BY overall_claims DESC) AS rn_high_overall,
        ROW_NUMBER() OVER (PARTITION BY year_medicare ORDER BY overall_claims ASC)  AS rn_low_overall,

        ROW_NUMBER() OVER (PARTITION BY year_medicare ORDER BY opioid_claims DESC) AS rn_high_opioid,
        ROW_NUMBER() OVER (PARTITION BY year_medicare ORDER BY opioid_claims ASC)  AS rn_low_opioid
    FROM medicare_combined
)

SELECT
    year_medicare,

    -- Highest overall claims
    MAX(CASE WHEN rn_high_overall = 1 THEN prescriber_name END) AS highest_overall_prescriber,
    MAX(CASE WHEN rn_high_overall = 1 THEN npi END) AS highest_overall_npi,
    MAX(CASE WHEN rn_high_overall = 1 THEN brand END) AS highest_overall_brand,
    MAX(CASE WHEN rn_high_overall = 1 THEN overall_claims END) AS highest_overall_claims,

    -- Lowest overall claims
    MAX(CASE WHEN rn_low_overall = 1 THEN prescriber_name END) AS lowest_overall_prescriber,
    MAX(CASE WHEN rn_low_overall = 1 THEN npi END) AS lowest_overall_npi,
    MAX(CASE WHEN rn_low_overall = 1 THEN brand END) AS lowest_overall_brand,
    MAX(CASE WHEN rn_low_overall = 1 THEN overall_claims END) AS lowest_overall_claims,

    -- Highest opioid claims
    MAX(CASE WHEN rn_high_opioid = 1 THEN prescriber_name END) AS highest_opioid_prescriber,
    MAX(CASE WHEN rn_high_opioid = 1 THEN npi END) AS highest_opioid_npi,
    MAX(CASE WHEN rn_high_opioid = 1 THEN brand END) AS highest_opioid_brand,
    MAX(CASE WHEN rn_high_opioid = 1 THEN opioid_claims END) AS highest_opioid_claims,

    -- Lowest opioid claims
    MAX(CASE WHEN rn_low_opioid = 1 THEN prescriber_name END) AS lowest_opioid_prescriber,
    MAX(CASE WHEN rn_low_opioid = 1 THEN npi END) AS lowest_opioid_npi,
    MAX(CASE WHEN rn_low_opioid = 1 THEN brand END) AS lowest_opioid_brand,
    MAX(CASE WHEN rn_low_opioid = 1 THEN opioid_claims END) AS lowest_opioid_claims

FROM ranked
GROUP BY year_medicare
ORDER BY year_medicare;

-- Highest & Lowest Prescribers, Opioid Prescribers & Drug Cost per Year (with details)
WITH ranked AS (
    SELECT
        year_medicare,
        npi,
        prescriber_name,
        brand,
        prescribers,
        opioid_prescribers,
        drug_cost,

        ROW_NUMBER() OVER (PARTITION BY year_medicare ORDER BY prescribers DESC) AS rn_high_prescribers,
        ROW_NUMBER() OVER (PARTITION BY year_medicare ORDER BY prescribers ASC)  AS rn_low_prescribers,

        ROW_NUMBER() OVER (PARTITION BY year_medicare ORDER BY opioid_prescribers DESC) AS rn_high_opioid_prescribers,
        ROW_NUMBER() OVER (PARTITION BY year_medicare ORDER BY opioid_prescribers ASC)  AS rn_low_opioid_prescribers,

        ROW_NUMBER() OVER (PARTITION BY year_medicare ORDER BY drug_cost DESC) AS rn_high_cost,
        ROW_NUMBER() OVER (PARTITION BY year_medicare ORDER BY drug_cost ASC)  AS rn_low_cost
    FROM medicare_combined
)

SELECT
    year_medicare,

    -- Prescribers
    MAX(CASE WHEN rn_high_prescribers = 1 THEN prescriber_name END) AS highest_prescribers_name,
    MAX(CASE WHEN rn_high_prescribers = 1 THEN npi END) AS highest_prescribers_npi,
    MAX(CASE WHEN rn_high_prescribers = 1 THEN brand END) AS highest_prescribers_brand,
    MAX(CASE WHEN rn_high_prescribers = 1 THEN prescribers END) AS highest_prescribers,

    MAX(CASE WHEN rn_low_prescribers = 1 THEN prescriber_name END) AS lowest_prescribers_name,
    MAX(CASE WHEN rn_low_prescribers = 1 THEN npi END) AS lowest_prescribers_npi,
    MAX(CASE WHEN rn_low_prescribers = 1 THEN brand END) AS lowest_prescribers_brand,
    MAX(CASE WHEN rn_low_prescribers = 1 THEN prescribers END) AS lowest_prescribers,

    -- Opioid prescribers
    MAX(CASE WHEN rn_high_opioid_prescribers = 1 THEN prescriber_name END) AS highest_opioid_prescribers_name,
    MAX(CASE WHEN rn_high_opioid_prescribers = 1 THEN npi END) AS highest_opioid_prescribers_npi,
    MAX(CASE WHEN rn_high_opioid_prescribers = 1 THEN brand END) AS highest_opioid_prescribers_brand,
    MAX(CASE WHEN rn_high_opioid_prescribers = 1 THEN opioid_prescribers END) AS highest_opioid_prescribers,

    MAX(CASE WHEN rn_low_opioid_prescribers = 1 THEN prescriber_name END) AS lowest_opioid_prescribers_name,
    MAX(CASE WHEN rn_low_opioid_prescribers = 1 THEN npi END) AS lowest_opioid_prescribers_npi,
    MAX(CASE WHEN rn_low_opioid_prescribers = 1 THEN brand END) AS lowest_opioid_prescribers_brand,
    MAX(CASE WHEN rn_low_opioid_prescribers = 1 THEN opioid_prescribers END) AS lowest_opioid_prescribers,

    -- Drug Cost
    MAX(CASE WHEN rn_high_cost = 1 THEN prescriber_name END) AS highest_cost_name,
    MAX(CASE WHEN rn_high_cost = 1 THEN npi END) AS highest_cost_npi,
    MAX(CASE WHEN rn_high_cost = 1 THEN brand END) AS highest_cost_brand,
    MAX(CASE WHEN rn_high_cost = 1 THEN drug_cost END) AS highest_drug_cost,

    MAX(CASE WHEN rn_low_cost = 1 THEN prescriber_name END) AS lowest_cost_name,
    MAX(CASE WHEN rn_low_cost = 1 THEN npi END) AS lowest_cost_npi,
    MAX(CASE WHEN rn_low_cost = 1 THEN brand END) AS lowest_cost_brand,
    MAX(CASE WHEN rn_low_cost = 1 THEN drug_cost END) AS lowest_drug_cost

FROM ranked
GROUP BY year_medicare
ORDER BY year_medicare;

-- Correlation Between Drug Cost, Prescribers, Opioid Prescribers and Claims

WITH 
avg_vals AS (
    SELECT
        AVG(drug_cost) AS avg_dc,
        AVG(prescribers) AS avg_pr,
        AVG(opioid_prescribers) AS avg_op,
        AVG(overall_claims) AS avg_oc,
        AVG(opioid_claims) AS avg_ocp
    FROM medicare_combined
)

SELECT
    -- drug cost correlations
    SUM((drug_cost - avg_dc) * (overall_claims - avg_oc)) /
    SQRT(SUM(POW(drug_cost - avg_dc, 2)) * SUM(POW(overall_claims - avg_oc, 2)))
    AS corr_drug_cost_overall_claims,

    SUM((drug_cost - avg_dc) * (opioid_claims - avg_ocp)) /
    SQRT(SUM(POW(drug_cost - avg_dc, 2)) * SUM(POW(opioid_claims - avg_ocp, 2)))
    AS corr_drug_cost_opioid_claims,

    -- prescribers correlations
    SUM((prescribers - avg_pr) * (overall_claims - avg_oc)) /
    SQRT(SUM(POW(prescribers - avg_pr, 2)) * SUM(POW(overall_claims - avg_oc, 2)))
    AS corr_prescribers_overall_claims,

    SUM((prescribers - avg_pr) * (opioid_claims - avg_ocp)) /
    SQRT(SUM(POW(prescribers - avg_pr, 2)) * SUM(POW(opioid_claims - avg_ocp, 2)))
    AS corr_prescribers_opioid_claims,

    -- opioid prescribers correlations
    SUM((opioid_prescribers - avg_op) * (overall_claims - avg_oc)) /
    SQRT(SUM(POW(opioid_prescribers - avg_op, 2)) * SUM(POW(overall_claims - avg_oc, 2)))
    AS corr_opioid_prescribers_overall_claims,

    SUM((opioid_prescribers - avg_op) * (opioid_claims - avg_ocp)) /
    SQRT(SUM(POW(opioid_prescribers - avg_op, 2)) * SUM(POW(opioid_claims - avg_ocp, 2)))
    AS corr_opioid_prescribers_opioid_claims

FROM medicare_combined, avg_vals;

-- Spearman's Rank Correlation for Drug Cost, Prescribers, 
-- Opioid Prescribers, Overall Claims, and Opioid Claims

WITH ranked AS (
    SELECT
        *,
        RANK() OVER (ORDER BY drug_cost) AS r_drug_cost,
        RANK() OVER (ORDER BY prescribers) AS r_prescribers,
        RANK() OVER (ORDER BY opioid_prescribers) AS r_opioid_prescribers,
        RANK() OVER (ORDER BY overall_claims) AS r_overall_claims,
        RANK() OVER (ORDER BY opioid_claims) AS r_opioid_claims
    FROM medicare_combined
),

avg_vals AS (
    SELECT
        AVG(r_drug_cost) AS avg_r_dc,
        AVG(r_prescribers) AS avg_r_pr,
        AVG(r_opioid_prescribers) AS avg_r_op,
        AVG(r_overall_claims) AS avg_r_oc,
        AVG(r_opioid_claims) AS avg_r_ocp
    FROM ranked
)

SELECT
    -- Spearman correlation: drug cost vs claims
    SUM((r_drug_cost - avg_r_dc) * (r_overall_claims - avg_r_oc)) /
    SQRT(SUM(POWER(r_drug_cost - avg_r_dc, 2)) * SUM(POWER(r_overall_claims - avg_r_oc, 2)))
    AS spearman_drug_cost_overall_claims,

    SUM((r_drug_cost - avg_r_dc) * (r_opioid_claims - avg_r_ocp)) /
    SQRT(SUM(POWER(r_drug_cost - avg_r_dc, 2)) * SUM(POWER(r_opioid_claims - avg_r_ocp, 2)))
    AS spearman_drug_cost_opioid_claims,

    -- Spearman correlation: prescribers vs claims
    SUM((r_prescribers - avg_r_pr) * (r_overall_claims - avg_r_oc)) /
    SQRT(SUM(POWER(r_prescribers - avg_r_pr, 2)) * SUM(POWER(r_overall_claims - avg_r_oc, 2)))
    AS spearman_prescribers_overall_claims,

    SUM((r_prescribers - avg_r_pr) * (r_opioid_claims - avg_r_ocp)) /
    SQRT(SUM(POWER(r_prescribers - avg_r_pr, 2)) * SUM(POWER(r_opioid_claims - avg_r_ocp, 2)))
    AS spearman_prescribers_opioid_claims,

    -- Spearman correlation: opioid prescribers vs claims
    SUM((r_opioid_prescribers - avg_r_op) * (r_overall_claims - avg_r_oc)) /
    SQRT(SUM(POWER(r_opioid_prescribers - avg_r_op, 2)) * SUM(POWER(r_overall_claims - avg_r_oc, 2)))
    AS spearman_opioid_prescribers_overall_claims,

    SUM((r_opioid_prescribers - avg_r_op) * (r_opioid_claims - avg_r_ocp)) /
    SQRT(SUM(POWER(r_opioid_prescribers - avg_r_op, 2)) * SUM(POWER(r_opioid_claims - avg_r_ocp, 2)))
    AS spearman_opioid_prescribers_opioid_claims

FROM ranked, avg_vals;

SELECT *
FROM medicare_combined;

SELECT *
FROM medicare_combined
WHERE year_medicare = '2023';






