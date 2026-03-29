# Medicare Part D Prescription & Opioid Trends Analysis

The Centers for Medicare & Medicaid Services (CMS) provides detailed data on prescription drugs dispensed to Medicare Part D beneficiaries. This dataset includes key information such as prescriber National Provider Identifiers (NPIs), total drug costs, brand and generic drug names, and geographic variations in prescribing behavior. Notably, the dataset also captures opioid prescribing rates at the regional level.

This project focuses on performing a comprehensive analysis of these data to identify meaningful patterns and insights related to medication utilization and prescription claims among Medicare recipients. The goal is to synthesize the information into actionable findings that enhance understanding of prescribing trends, cost dynamics, and opioid-related behaviors within the Medicare system.

**Trend Analysis:**
Conducted a year-over-year assessment of overall prescription drug claims and opioid-related claims to identify patterns, shifts, and emerging trends in medication utilization.

**Demographic Impact Assessment:**
Analyzed annual variations in prescriber counts, opioid prescriber counts, and total drug costs to understand their influence on prescribing behavior and overall claims activity.

**Performance Analysis:**
Assessed the correlations between drug cost, prescriber counts, opioid prescriber counts, and both overall and opioid-related claims to determine the strength and direction of these relationships and their impact on prescribing outcomes.

An Interactive Tableau dashboard can be downloaded [here](https://public.tableau.com/views/MedicareTableau4/MedicareClaimsandOpioidPrescribingPatterns?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link) and [here](https://public.tableau.com/views/MedicareTableau4/MedicareClaimsandOpioidPrescribingPatternsII?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link).

**DATA STRUCTURE & INITIAL CHECKS**

**Data Cleaning and Preparation**

**Data Ingestion**

The initial dataset consisted of three Medicare Part D tables: Prescribers – by Provider and Drug (1,048,576 rows), Prescribers – by Geography and Drug (115,937 rows), and Opioid Prescribing Rates – by Geography (328,891 rows). All tables were ingested into a SQL-based data pipeline and stored in raw staging tables to support structured preprocessing and ensure reproducibility.

**Data Cleaning and Standardization**

Text fields were normalized by trimming whitespace, standardizing capitalization, and removing special characters, ensuring consistency in prescriber names and drug identifiers. ZIP codes were converted to a five-digit format, and FIPS codes were zero-padded to two digits. A custom zip_state_map table containing 24 validated ZIP-to-state mappings was used to backfill missing state values. Non-U.S. states, territories, and military codes were removed, eliminating 9,269 records and ensuring state-level consistency.

Numeric fields were validated by removing records with negative values for total_claims, total_drug_cost, and opioid_claims. Opioid prescribing rates were constrained to valid proportions between 0 and 1; out-of-range values (~27% of prescribers, 312,272 records) were set to NULL to prevent distortion in downstream calculations. Drug names and geographic codes were standardized across all 115,936 drug records, and non-state-level records were removed to maintain alignment with U.S. states. Similar cleaning and standardization were applied to the opioid trends dataset, including trimming and zero-padding geographic codes (327,279 records affected) and removing non-state-level or invalid geographic records.

Indexes were created on key columns such as prescriber identifiers (npi), state codes, and year fields to optimize query performance during aggregations and trend analyses.

**Initial Data Integrity and Quality Control**

Missing and incomplete records were addressed by backfilling state values using the ZIP-to-state map and standardizing numeric fields. Duplicates were removed by selecting the record with the maximum total claims per NPI, producing 1,039,306 unique prescriber records. Records with missing, undefined, or invalid prescriber types were assigned to the UNKNOWN category to ensure all observations were accounted for. Irrelevant records, including non-state-level entries and territories, were removed to maintain consistency in state-level analyses.

**Prescriber Categorization**

Prescribers were grouped into clinically meaningful categories to support interpretable analysis of prescribing patterns. A new prescriber_group column was added to classify providers into PHYSICIAN, ADVANCED_PRACTICE, DENTAL, PODIATRY_OPTOMETRY, PHARMACY, FACILITY_OR_SUPPLIER, LOW_IMPACT_OTHER, and UNKNOWN groups. Physicians were identified based on specialty, affecting 402,650 records, while advanced practice clinicians such as nurse practitioners, physician assistants, CRNAs, and nurse midwives were classified separately (296,953 records). Dental providers were identified using keywords such as “DENT” or “ORAL” (154,282 records), and podiatry/optometry providers were grouped based on specialty (37,184 records). Facility or supplier-related prescribers were identified with keywords such as “HOSPITAL,” “CLINIC,” and “CENTER” (18,671 records). Any remaining prescribers that did not fit prior classifications were assigned to LOW_IMPACT_OTHER (102,637 records). Missing or undefined prescriber types were classified as UNKNOWN (136 records). This categorization ensured every prescriber in the dataset could be analyzed in a meaningful group.

**Aggregation and Merging**

State-level summary tables were created by aggregating total claims and drug costs from the raw drug dataset (state_drug_totals, 51 rows) and by aggregating total prescribers, opioid prescribers, opioid claims, and overall claims from the opioid trends dataset (state_opioid_totals, 561 rows, covering 51 states across 11 Medicare years). The final medicare_combined table was generated by joining the cleaned prescriber table with the state-level drug and opioid totals, standardizing prescriber names, and aligning all records by state. This resulted in a comprehensive dataset of 11,432,366 rows, ready for analysis at both the prescriber and state levels. Indexes were created on state and medicare_year columns to optimize filtering, grouping, and aggregation performance for this large dataset.

**Post-Processing and Validation**

After all cleaning, merging, and indexing operations, database integrity checks (unique_checks and foreign_key_checks) were re-enabled to enforce relational constraints. The resulting dataset is fully cleaned, standardized, and integrated, providing a robust foundation for prescriber-level and state-level analyses of drug utilization and opioid prescribing trends.

**EXECUTIVE SUMMARY**

**OVERVIEW OF FINDINGS**

An analysis of claims, prescribing patterns, and drug costs over time reveals several clear trends. Overall claims increased steadily across the study period, with the fewest claims observed in 2013 and a peak in 2023. In contrast, opioid-related claims declined from 2016 through 2023, with the highest level occurring in 2016, indicating a sustained reduction in opioid claim volume in recent years. Drug costs remained stable throughout the period, showing no significant long-term fluctuations. Prescribing activity increased overall, as the total number of prescribers rose over time, again with the lowest count in 2013 and the highest in 2023. While the number of opioid prescribers showed a modest increase from 2016 to 2023, this change was not significant, and opioid prescriber counts remained relatively stable across the full 2013–2023 timeframe. Collectively, these findings suggest growth in overall utilization and provider participation, alongside stabilization in costs and a decline in opioid-specific claims.

Below is part of the Tableau dashboard reflecting medicare claims and opioid prescribing patterns from 2013-2023. More examples are included throughout the report. The entire interactive dashboard can be downloaded [here](https://public.tableau.com/views/MedicareTableau4/MedicareClaimsandOpioidPrescribingPatterns?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link) and [here](https://public.tableau.com/views/MedicareTableau4/MedicareClaimsandOpioidPrescribingPatternsII?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link).

**ANALYSIS OF DEMOGRAPHICS**

Prescriber Counts: The total number of prescribers increased over time, reaching its lowest level in 2013 and peaking in 2023. During this period, overall claims per prescriber rose steadily, indicating increased prescribing activity on a per-provider basis, even as the share of opioid claims relative to overall claims declined from its highest level in 2014 to its lowest level in 2023.

Opioid Prescriber Counts: The number of opioid prescribers experienced a slight increase between 2016 and 2023; however, this change was not substantial, and counts remained largely stable throughout the 2013–2023 period. In contrast, opioid claims per prescriber peaked in 2016 and declined thereafter, suggesting a sustained reduction in opioid prescribing intensity per provider over time.

Drug Cost: Drug costs remained largely stable over the study period, with no significant long-term fluctuations from 2013 to 2023. Costs also remained consistent when measured per NPI.

![image](https://github.com/puhan63/Medicare/blob/main/Medicare%20Image%201.png)

**PERFORMANCE ANALYSIS**

The analysis identified several positive correlations among key prescribing and claims measures. Overall claims were positively correlated with both the total number of prescribers and the number of opioid prescribers, indicating that increases in provider participation were associated with higher claim volumes. Overall claims were also positively correlated with opioid claims, suggesting that trends in total utilization moved in tandem with opioid-related utilization. In addition, opioid claims showed a positive relationship with the total number of prescribers, reflecting broader prescribing activity. A positive correlation was also observed between opioid prescribers and total prescribers, as well as between opioid prescribers and opioid claims, highlighting that changes in the number of opioid-prescribing providers were closely aligned with both overall provider counts and opioid-specific claim activity.

![image](https://github.com/puhan63/Medicare/blob/main/Medicare%20Image%202.png)

**RECOMMENDATIONS**

**Targeted Prescriber Education**

Provide focused education on non-opioid pain management alternatives for prescribers with higher-than-average opioid prescribing rates.

**Clinical Auditing and Mentorship**

Implement audit-and-feedback programs and pair high opioid prescribers with experienced clinical mentors to support evidence-based prescribing and clinical decision-making.

**Policy Awareness and Compliance Training**

Enhance education around state and local opioid prescribing policies to ensure prescribers remain informed of current regulatory guidelines.

**Provider-Type Prescribing Analysis**

Examine differences in opioid prescribing patterns between Doctor of Osteopathic Medicine (DO) and Medical Doctor (MD) providers to identify variation in practice behaviors.

**Practice-Type Prescribing Patterns**

Analyze opioid prescribing rates across practice types (e.g., pain management, family practice, primary care) to understand specialty-driven differences in utilization.

**Alternative Treatment Utilization Review**

Encourage assessment of non-pharmacologic treatment approaches—such as physical therapy or complementary medicine—prior to initiating opioid therapy, where clinically appropriate.

**FUTURE STEPS**

**Geographic and Policy-Based Analysis**

Evaluate regional differences in opioid prescribing, including comparisons between states with and without legalized marijuana, to assess potential policy-related impacts on opioid utilization.

**Patient Population and Case Complexity Adjustment**

Analyze opioid prescribing rates in the context of patient demographics and clinical complexity to distinguish appropriate prescribing from potential overutilization.

**Access to Care and Resource Availability Assessment**

Assess whether opioid prescribing rates are correlated with access to alternative pain management resources, such as specialists, physical therapy services, or multidisciplinary care teams.

**Demographic Influence Evaluation**

Examine the relationship between the average age of local populations and opioid prescribing rates to determine whether aging populations drive higher utilization.

**Predictive Risk Modeling**

Develop predictive models to identify providers or regions at elevated risk for future increases in opioid prescription claims, enabling proactive monitoring and early intervention.
