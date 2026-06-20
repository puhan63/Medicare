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

**Provider-Level Dataset (Clinical Behavior View)**

tableau_prescriber_dataset

•	1,039,307 prescriber records 

•	Contains: 

o	Total claims per provider 

o	Opioid claims 

o	Prescriber group classification 

o	Risk score relationships 

o	Cost and utilization metrics 

Used for:

•	Provider segmentation 

•	High-risk prescribing analysis 

•	Specialty comparisons 

•	Behavioral pattern analysis 

**Statistical Analysis Layer**

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







An Interactive Tableau dashboard can be downloaded [here](https://public.tableau.com/views/MedicareTableau4/MedicareClaimsandOpioidPrescribingPatterns?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link) and [here](https://public.tableau.com/views/MedicareTableau4/MedicareClaimsandOpioidPrescribingPatternsII?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link).



Prescribers were grouped into clinically meaningful categories to support interpretable analysis of prescribing patterns. A new prescriber_group column was added to classify providers into PHYSICIAN, ADVANCED_PRACTICE, DENTAL, PODIATRY_OPTOMETRY, PHARMACY, FACILITY_OR_SUPPLIER, LOW_IMPACT_OTHER, and UNKNOWN groups. Physicians were identified based on specialty, affecting 402,650 records, while advanced practice clinicians such as nurse practitioners, physician assistants, CRNAs, and nurse midwives were classified separately (296,953 records). Dental providers were identified using keywords such as “DENT” or “ORAL” (154,282 records), and podiatry/optometry providers were grouped based on specialty (37,184 records). Facility or supplier-related prescribers were identified with keywords such as “HOSPITAL,” “CLINIC,” and “CENTER” (18,671 records). Any remaining prescribers that did not fit prior classifications were assigned to LOW_IMPACT_OTHER (102,637 records). Missing or undefined prescriber types were classified as UNKNOWN (136 records). This categorization ensured every prescriber in the dataset could be analyzed in a meaningful group.




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
