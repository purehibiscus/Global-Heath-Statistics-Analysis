# Global-Heath-Statistics-dashboard
This repo contains all my files on Global Health Statistics analysis including SQL analysis file, Power BI dashboard, project documentation,

Project Report on Global Health Statistics

Dashboard file download link: https://drive.google.com/file/d/1tkT8xNnPYdXVSIa3YinMJdoWNfTU6Hgh/view?usp=sharing

Title: Analyzing Global Health Statistics for Insights into Disease Burden and Healthcare Access

Introduction:
Global health statistics play a critical role in understanding the distribution and determinants of health across populations. With the increasing availability of large-scale health datasets, it has become possible to analyze trends, disparities, and the impact of health interventions across regions and income groups. This project aimed to explore global health indicators, focusing on disease burden, healthcare access, and economic impact, using data from Kaggle public repository to bring out trends, patterns and insights from the dataset having 22 columns and 1 million records.

A. Data Preparation, summary cleaning and data checks on MS Power BI Power Query:

Data Source and Attributes:

Data Source: Kaggle public datasets

About Dataset: 
This dataset provides comprehensive statistics on global health, focusing on various diseases, treatments, and outcomes. The data spans multiple countries and years, offering valuable insights for health research, epidemiology studies, and machine learning applications. The dataset includes information on the prevalence, incidence, and mortality rates of major diseases, as well as the effectiveness of treatments and healthcare infrastructure.

Data Update Frequency: Annually.
The dataset consist of 1 csv file containing 22 columns and 1 million datapoints. 

Column Descriptions:

1.  Country: The name of the country where the health data was recorded.
2.  Year: The year in which the data was collected.
3.  Disease Name: The name of the disease or health condition tracked.
4.  Disease Category: The category of the disease (e.g., Infectious, Non-Communicable).
5.  Prevalence Rate (%): The percentage of the population affected by the disease.
6.  Incidence Rate (%): The percentage of new or newly diagnosed cases.
7.  Mortality Rate (%): The percentage of the affected population that dies from the disease.
8.  Age Group: The age range most affected by the disease.
9.  Gender: The gender(s) affected by the disease (Male, Female, Both).
10. Population Affected: The total number of individuals affected by the disease.
11. Healthcare Access (%): The percentage of the population with access to healthcare.
12. Doctors per 1000: The number of doctors per 1000 people.
13. Hospital Beds per 1000: The number of hospital beds available per 1000 people.
14. Treatment Type: The primary treatment method for the disease (e.g., Medication, Surgery).
15. Average Treatment Cost (USD): The average cost of treating the disease in USD.
16. Availability of Vaccines/Treatment: Whether vaccines or treatments are available.
17. Recovery Rate (%): The percentage of people who recover from the disease.
18. DALYs: Disability-Adjusted Life Years, a measure of disease burden.
19. Improvement in 5 Years (%): The improvement in disease outcomes over the last five years.
20. Per Capita Income (USD): The average income per person in the country.
21. Education Index: The average level of education in the country.
22. Urbanization Rate (%): The percentage of the population living in urban areas.

Data Profiling, Governance and Validation:

I. Data Profiling:
 
i. Numerical columns: Data distribution and Column Statistics, checks for Minimum, Maximum, Average, Count, and Standard deviation of each numerical columns, values for all numerical columns, Checks for Unique values, Error or Empty cells, Distinct values and Value distribution were done with Microsoft Power BI Power Query's Data Preview tool from the View tab. Column quality is 100% complete and no duplicate in key fields.

ii. Categorical Columns: Unique and Distinct are checked to ensure there is no whitespaces, misspelt words, trailing spaces. Column statistics was viewed to ensure proper data distribution, this helped in ensuring there is no anomalies, outliers or any record out of context.

Data Import to MS SQL Server Management Studio through the Import file option.
- Database and Table creation using the SQL Server dialect;

CREATE TABLE dbo.global_health_statistics (
    [Country] NVARCHAR(255),
    [Year] INT,
    [Disease Name] NVARCHAR(255),
    [Disease Category] NVARCHAR(255),
    [Prevalence Rate (%)] FLOAT,
    [Incidence Rate (%)] FLOAT,
    [Mortality Rate (%)] FLOAT,
    [Age Group] NVARCHAR(255),
    [Gender] NVARCHAR(255),
    [Population Affected] INT,
    [Healthcare Access (%)] FLOAT,
    [Doctors per 1000] FLOAT,
    [Hospital Beds per 1000] FLOAT,
    [Treatment Type] NVARCHAR(255),
    [Average Treatment Cost USD] INT,
	[Availability of Vaccines/Treatment] NVARCHAR(255),
	[Recovery Rate (%)] FLOAT,
	[DALYs] INT,
	[Improvement in 5 Years (%)] FLOAT,
	[Per Capita Income (USD)] INT,
	[Education Index] FLOAT,
	[Urbanization Rate (%)] FLOAT,
); 


B. Data cleaning:
Re-checking Data quality, Validation, Data type, Inconsistencies, Data range

1. Datapoints insert with SQL syntax to the global health statistics table;

BULK INSERT dbo.global_health_statistics
FROM 'C:\Users\nadanee\Desktop\MY CASE STUDES\Unclenaned datasets\Global Health Statistics.csv'
WITH (
    FIRSTROW = 2,              
    FIELDTERMINATOR = ',',    
    ROWTERMINATOR = '\n',     
    TABLOCK                   
);

2. Checking for missing values through each field using SQL syntax;

SELECT *
FROM [Data Cleaning and Analysis].[dbo].[global_health_statistics]
WHERE [Country] IS NULL
	 OR [Year] IS NULL
      OR [Disease Name] IS NULL
      OR [Disease Category] IS NULL
      OR [Prevalence Rate (%)] IS NULL
      OR [Incidence Rate (%)] IS NULL
      OR [Mortality Rate (%)] IS NULL
      OR [Age Group] IS NULL
      OR [Gender] IS NULL
      OR [Population Affected] IS NULL
      OR [Healthcare Access (%)] IS NULL
      OR [Doctors per 1000] IS NULL
      OR [Hospital Beds per 1000] IS NULL
      OR [Treatment Type] IS NULL
      OR [Average Treatment Cost USD] IS NULL
      OR [Availability of Vaccines/Treatment] IS NULL
      OR [Recovery Rate (%)] IS NULL
      OR [DALYs] IS NULL
      OR [Improvement in 5 Years (%)] IS NULL
      OR [Per Capita Income (USD)] IS NULL
      OR [Education Index] IS NULL
      OR [Urbanization Rate (%)] IS NULL;


3. Checking for data type validation;

SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM [Data Cleaning and Analysis].INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'global_health_statistics'
  AND TABLE_SCHEMA = 'dbo'
ORDER BY ORDINAL_POSITION;

4. Performing Range checks for numberical columns. Normal range =(0-100), else an outlier

SELECT
    MAX([Prevalence Rate (%)]) AS Max_Prevalence,
    MIN([Prevalence Rate (%)]) AS Min_Prevalence,
    MAX([Incidence Rate (%)]) AS Max_Incidence,
    MIN([Incidence Rate (%)]) AS Min_Incidence,
    MAX([Mortality Rate (%)]) AS Max_Mortality,
    MIN([Mortality Rate (%)]) AS Min_Mortality,
	MAX([Healthcare Access (%)]) AS Max_Healthcare,
	MIN([Healthcare Access (%)]) AS Min_Healthcare,
	MAX([Recovery Rate (%)]) AS Max_Recovery,
	MIN([Recovery Rate (%)]) AS Min_Recovery,
	MAX([Improvement in 5 Years (%)]) AS MAX_Improvemnet,
	MIN([Improvement in 5 Years (%)]) AS MIN_Improvemnet,
	MAX([Urbanization Rate (%)]) AS MAX_Urbanization,
	MIN([Urbanization Rate (%)]) AS MIN_Urbanization
FROM [Data Cleaning and Analysis].[dbo].[global_health_statistics];

5. Checking for data points inconsistencies

SELECT DISTINCT [Disease Name], 
				[Disease Category],
				COUNT(*) AS DiseaseCount
FROM [Data Cleaning and Analysis].[dbo].[global_health_statistics]
GROUP BY [Disease Name],
		[Disease Category]
ORDER BY DiseaseCount DESC;



i. Performing a brief Exploratory Data Analysis (EDA) in help understand the data distribution and patterns from Healthcare access to help address Health problems in the world.



-- 1. What are the top 5 diseases with the highest prevalence rates globally?

SELECT TOP 5 
    [Country],
    [Disease Name],
    [Prevalence Rate (%)]
FROM [Data Cleaning and Analysis].[dbo].[global_health_statistics]
ORDER BY [Prevalence Rate (%)] DESC;

-- 2. How does the mortality rate vary across different age groups and disease categories?

SELECT AVG([Mortality Rate (%)]) AS AvgMortalityRate,
	[Age Group],
	[Disease Category]
FROM [Data Cleaning and Analysis].[dbo].[global_health_statistics]
WHERE [Mortality Rate (%)] IS NOT NULL
GROUP BY [Age Group],
		[Disease Category]
ORDER BY AvgMortalityRate DESC;

-- 3. Checking correlation between healthcare access and recovery rates for different diseases?

SELECT AVG([Healthcare Access (%)]) AS AvgHealthcareAccess,
		AVG([Recovery Rate (%)]) AS AvgRecoveryRate,
		[Disease Name]
FROM [Data Cleaning and Analysis].[dbo].[global_health_statistics]
WHERE [Healthcare Access (%)] IS NOT NULL  -- to avoid skewness of data
	AND [Recovery Rate (%)] IS NOT NULL
GROUP BY [Disease Name]
ORDER BY AvgHealthcareAccess DESC,
		AvgRecoveryRate DESC;



C. Data Analysis: 
The Analysis phase is divided into three parts. General Analysis(which involve Disease burden and Healthcare) and Analysis that involve Healthcare Systems and Economic Impact which would be distributed in two dashboard pages. The last part consist of calculation for KPIs and metrics.


Questions to drive Insights that will help in data-driven decision
I. Dashboard Overview Page 1: Disease Burden and Healthcare

1. What is the global burden of disease (DALYs) by disease category?
2. How does healthcare access and availability of vaccines/treatment impact disease prevalence and mortality rates?
3. What are the top 5 countries with the highest disease burden (DALYs) per capita?


II. Dashboard Drilldown Page 2: Healthcare Systems and Economic Impact

1. How does the number of doctors per 1000 population impact disease outcomes (recovery rates, mortality rates)?
2. What is the economic impact of diseases (average treatment cost, per capita income)?
3. How does urbanization rate impact disease prevalence and healthcare access?

-- a. Disease Burden and Healthcare

-- 1. What is the global burden of disease (DALYs) by disease category?

SELECT 
    [Disease Category],
    SUM([DALYs]) AS TotalDALYs
FROM [Data Cleaning and Analysis].[dbo].[global_health_statistics]
WHERE [DALYs] IS NOT NULL
GROUP BY [Disease Category]
ORDER BY TotalDALYs DESC;

-- 2. How does healthcare access and availability of vaccines/treatment impact disease prevalence and mortality rates?

SELECT [Availability of Vaccines/Treatment],
		AVG([Healthcare Access (%)]) AS AvgHealthAccess,
		AVG([Prevalence Rate (%)]) AS AvgPrevalence,
		AVG([Mortality Rate (%)]) AS AvgMortality
FROM [Data Cleaning and Analysis].[dbo].[global_health_statistics]
GROUP BY [Availability of Vaccines/Treatment];

-- 3. What are the top 5 countries with the highest disease burden (DALYs) per capita?

SELECT TOP 5 
    [Country],
    SUM(CAST([DALYs] AS BIGINT)) AS TotalDALYs,
    SUM(CAST([Population Affected] AS BIGINT)) AS TotalPopulation,
    CAST(SUM(CAST([DALYs] AS BIGINT)) AS FLOAT) / 
        NULLIF(SUM(CAST([Population Affected] AS BIGINT)), 0) AS DALYsPerCapita
FROM [Data Cleaning and Analysis].[dbo].[global_health_statistics]
WHERE [DALYs] IS NOT NULL AND [Population Affected] IS NOT NULL
GROUP BY [Country]
ORDER BY DALYsPerCapita DESC;


-- b. Healthcare Systems and Economic Impact

-- 1. How does the number of doctors per 1000 population impact disease outcomes (e.g., recovery rates, mortality rates)?

SELECT 
    CASE 
        WHEN [Doctors per 1000] < 1 THEN '< 1'
        WHEN [Doctors per 1000] BETWEEN 1 AND 2 THEN '1 - 2'
        WHEN [Doctors per 1000] BETWEEN 2 AND 3 THEN '2 - 3'
        ELSE '> 3'
    END AS DoctorDensityGroup,
    ROUND(AVG([Recovery Rate (%)]), 2) AS AvgRecoveryRate,
    ROUND(AVG([Mortality Rate (%)]), 2) AS AvgMortalityRate,
    COUNT(*) AS RecordCount
FROM [Data Cleaning and Analysis].[dbo].[global_health_statistics]
WHERE [Doctors per 1000] IS NOT NULL
  AND [Recovery Rate (%)] IS NOT NULL
  AND [Mortality Rate (%)] IS NOT NULL
GROUP BY 
    CASE 
        WHEN [Doctors per 1000] < 1 THEN '< 1'
        WHEN [Doctors per 1000] BETWEEN 1 AND 2 THEN '1 - 2'
        WHEN [Doctors per 1000] BETWEEN 2 AND 3 THEN '2 - 3'
        ELSE '> 3'
    END
ORDER BY DoctorDensityGroup;


-- 2. What is the economic impact of diseases (average treatment cost, per capita income)?

WITH CostAndIncomeCTE AS (
    SELECT 
        [Disease Name],
        CAST([Average Treatment Cost USD] AS FLOAT) AS TreatmentCost,
        CAST([Per Capita Income (USD)] AS FLOAT) AS Income
    FROM [Data Cleaning and Analysis].[dbo].[global_health_statistics]
    WHERE [Average Treatment Cost USD] IS NOT NULL 
      AND [Per Capita Income (USD)] IS NOT NULL
),
AggregatedCTE AS (
    SELECT 
        [Disease Name],
        ROUND(AVG(TreatmentCost), 2) AS AvgTreatmentCost,
        ROUND(AVG(Income), 2) AS AvgIncome
    FROM CostAndIncomeCTE
    GROUP BY [Disease Name]
)
SELECT 
    [Disease Name],
    AvgTreatmentCost,
    AvgIncome,
    ROUND((AvgTreatmentCost / NULLIF(AvgIncome, 0)) * 100, 2) AS CostToIncomeRatioPercent
FROM AggregatedCTE
ORDER BY CostToIncomeRatioPercent DESC;


-- 3. How does urbanization rate impact disease prevalence and healthcare access?

SELECT 
    CASE 
        WHEN [Urbanization Rate (%)] < 30 THEN 'Low (<30%)'
        WHEN [Urbanization Rate (%)] BETWEEN 30 AND 60 THEN 'Medium (30-60%)'
        WHEN [Urbanization Rate (%)] BETWEEN 60 AND 80 THEN 'High (60-80%)'
        ELSE 'Very High (>80%)'
    END AS UrbanizationLevel,
    ROUND(AVG([Prevalence Rate (%)]), 2) AS AvgPrevalenceRate,
    ROUND(AVG([Healthcare Access (%)]), 2) AS AvgHealthcareAccess,
    COUNT(*) AS RecordCount
FROM [Data Cleaning and Analysis].[dbo].[global_health_statistics]
WHERE [Urbanization Rate (%)] IS NOT NULL
  AND [Prevalence Rate (%)] IS NOT NULL
  AND [Healthcare Access (%)] IS NOT NULL
GROUP BY 
    CASE 
        WHEN [Urbanization Rate (%)] < 30 THEN 'Low (<30%)'
        WHEN [Urbanization Rate (%)] BETWEEN 30 AND 60 THEN 'Medium (30-60%)'
        WHEN [Urbanization Rate (%)] BETWEEN 60 AND 80 THEN 'High (60-80%)'
        ELSE 'Very High (>80%)'
    END
ORDER BY UrbanizationLevel;


-- C. Key Performance Indicators(KPIs) and metrics for Business Intelligence

-- 1. Total DALYs by disease category

SELECT 
    [Disease Category],
    SUM([DALYs]) AS TotalDALYs
FROM [Data Cleaning and Analysis].[dbo].[global_health_statistics]
WHERE [DALYs] IS NOT NULL
GROUP BY [Disease Category]
ORDER BY TotalDALYs DESC;

-- 2. Average prevalence rate by disease category

SELECT 
    [Disease Category],
    AVG([Prevalence Rate (%)]) AS AvgPrevalenceRate
FROM [Data Cleaning and Analysis].[dbo].[global_health_statistics]
WHERE [Prevalence Rate (%)] IS NOT NULL
GROUP BY [Disease Category]
ORDER BY AvgPrevalenceRate DESC;

-- 3. Average mortality rate by disease category

SELECT 
    [Disease Category],
    AVG([Mortality Rate (%)]) AS AvgMortalityRate
FROM [Data Cleaning and Analysis].[dbo].[global_health_statistics]
WHERE [Mortality Rate (%)] IS NOT NULL
GROUP BY [Disease Category]
ORDER BY AvgMortalityRate DESC;

-- 4. Average healthcare access rate by country

SELECT 
    [Country],
    AVG([Healthcare Access (%)]) AS AvgHealthcareAccess
FROM [Data Cleaning and Analysis].[dbo].[global_health_statistics]
WHERE [Healthcare Access (%)] IS NOT NULL
GROUP BY [Country]
ORDER BY AvgHealthcareAccess DESC;

-- 5. Average number of doctors per 1000 population by country

SELECT 
    [Country],
    AVG([Doctors per 1000]) AS AvgDoctorsPer1000
FROM [Data Cleaning and Analysis].[dbo].[global_health_statistics]
WHERE [Doctors per 1000] IS NOT NULL
GROUP BY [Country]
ORDER BY AvgDoctorsPer1000 DESC;


ALTER TABLE [Data Cleaning and Analysis].[dbo].[global_health_statistics] -- changing the Treatment cost column data type to float
ALTER COLUMN [Average Treatment Cost USD] DECIMAL(18, 2);


-- 6. Average treatment cost by disease category

SELECT 
    [Disease Category],
    AVG([Average Treatment Cost USD]) AS AvgTreatmentCost
FROM [Data Cleaning and Analysis].[dbo].[global_health_statistics]
WHERE [Average Treatment Cost USD] IS NOT NULL
GROUP BY [Disease Category]
ORDER BY AvgTreatmentCost DESC;

ALTER TABLE [Data Cleaning and Analysis].[dbo].[global_health_statistics]  -- changing Per Capita Income column data type to float
ALTER COLUMN [Per Capita Income (USD)] DECIMAL(18, 2);


-- 7.  Average per capita income by country

SELECT 
    [Country],
    AVG([Per Capita Income (USD)]) AS AvgPerCapitaIncome
FROM [Data Cleaning and Analysis].[dbo].[global_health_statistics]
WHERE [Per Capita Income (USD)] IS NOT NULL
GROUP BY [Country]
ORDER BY AvgPerCapitaIncome DESC;

-- 8. Average urbanization rate by country

SELECT 
    [Country],
    AVG([Urbanization Rate (%)]) AS AvgUrbanizationRate
FROM [Data Cleaning and Analysis].[dbo].[global_health_statistics]
WHERE [Urbanization Rate (%)] IS NOT NULL
GROUP BY [Country]
ORDER BY AvgUrbanizationRate DESC;

Power Query and DAX calculations:
A calculated column for Average Prevalence rate is added to the data, Custom columns for grouping doctors per 1000 is added too. Added DAX measures including Total population, Total DALYs, Top Country Affected Name to mention a few.


D. Data Visualizations and Reports:
For charts creation and Dashboard development, analyzed data was saved into tables and using the Power BI data import wizard for MS SQL Server database.

-- 1. Total Disability-Adjusted Life Years(DALYs) by Disease category: Area chart
-- 2. Total DALYs, Total Population and DALYs per Capita by Country: Map chart
-- 3. Healthcare Access, Prevalence and Mortality Rates Rate by Availability of Vaccines/Treatment: Stacked bar chart
-- 4. Economic Impact of Diseases by Average Cost of Treatment &  Per Capita Income: Line and Stacked Column chart
-- 5. Doctors density group impact by Disease Outcomes(Recovery and Mortality rates (%): Non-shaded Area chart
-- 6. Average of Healthcare Access (%), Average of Prevalence Rate (%) and Count of Urbanization Rate (%) by Urbanization Level: Line and Stacked Area chart

KPI cards
Dashboard page 1
--1. Total DALYs
--2. Average Prevalence Rate(%)
--3. Average Mortality Rate(%)
--4. Average Healthcare Access Rate(%)
--5. Average Doctors per 1000(K)

Dashboard Drilldown page 2
--1. Average Treatment Cost(USD)
--2. Average per Capita Income(USD)
--3. Average Urbanization Rate(%)
--4. Average Population Affected(K)
--5. Average Healthcare Access Rate(%)
--6. Average Recovery Rate(%)
--7. Average Hospital Beds per 1000(K)
--8. Average Improvement in 5 years(%)
--9. Average of Incidence Rate(%)
--10. Top Country Affected Name

Dashboard Page Navigation:
The dashboard pages are interactive, allowing users to navigate by selecting elements such as country names, disease names, or their corresponding bars in the charts. A slicer has been added to the first page, providing dropdown options for both Country and Disease Name. An information icon on Page 1 allows users to navigate to Page 2, while a back icon on Page 2 returns users to Page 1. These icons have been configured using the Action feature in the icon formatting pane. On some systems, holding the Ctrl key may be required when clicking the icons.
Slicer and filter options are configured to apply across both pages using the Show Panes group under the View tab. Additionally, features such as Drill-through, Cross-report, and Apply all filters have been enabled to improve dashboard navigation and provide more comprehensive insights.

E. Insights:

1. Non-communicable diseases (e.g. Genetic, Metabolic, Autoimmune, and Cardiovascular diseases) are accounted for the largest share of DALYs, indicating they are the biggest contributors to long-term health loss with an addition of a communicable disease (Parasitic) all having a total of (227,000,000) Million per disease.
2. Diseases with higher availability of vaccines/treatment and greater healthcare access showed lower prevalence and mortality rates. This imply that public health interventions programs are effective in reducing disease burden.
3. Countries such as Argentina, Brazil, France, India, and Russia showed that they are struggling with low healthcare access, low income, and a high burden of specific disease categories (e.g. Genetic, Metabolic and Autoimmune diseases) resulting to high DALYs.
4. The data shows that higher doctors density is correlated  with high recovery rates and lower mortality, thereby confirming that health workforce availability influences patients outcomes directly.
5. Highly urbanized areas tend to have better healthcare access however, they may have higher risk of disease prevalence; possibly due to lifestyle diseases in the cities.
6. The Economic impact of some diseases that may require a large share of per capita income which may result in high economic burden particularly in the low-income regions.
7. Countries (e.g. Russia, South Africa, and Nigeria) with low per capita income but high treatment costs have rigid healthcare access issues, pointing to the need for financial protection mechanisms like subsidies or insurance.

Recommendations:
1. Implementing some national strategies focused on early screening, health education, and lifestyle interventions to reduce the burden of genetic, metabolic, autoimmune, and cardiovascular diseases. This will help in extending prevention and management of non-communicable diseases.
2. Broadening Access to Vaccines and Treatments, Increasing investment in vaccine coverage, essential medicines, mobile clinics, and outreach services especially in high-burden, low-access areas to lower disease prevalence and mortality.
3. Prioritizing international aid and healthcare investment in countries such as Argentina, Brazil, France, India, and Russia, which face significant disease burdens coupled with low healthcare access and income.
4. Boosting Healthcare Workforce, Improving recruitment, training, and distribution of healthcare professionals, support community health workers, and invest in telemedicine and digital infrastructure to enhance healthcare access and outcomes.
5. Unveiling of urban health initiatives to mitigate lifestyle-related conditions, regulating environmental risks, and encouraging healthy behaviors through city planning and workplace wellness programs.
6. Establishment or expansion of universal health coverage, subsidized insurance, price regulation, and micro-insurance schemes to reduce the economic burden of treatment especially to target low-income regions.
7. Quantify the economic impact of diseases, support income protection for the chronically ill patients, and align health strategies with national economic development to ensure sustainable health financing

Summary:
Countries with lower income levels tend to have higher mortality rates due to inadequate access to healthcare, resulting in higher Disability-Adjusted Life Years (DALYs). While urban regions often have better healthcare facilities, they may also experience a higher prevalence of diseases linked to lifestyle factors. Targeted deployment of healthcare professionals to low-income areas can help reduce the burden of high-impact diseases, ultimately lowering DALYs across regions.

Conclusions:
The analysis highlights that non-communicable diseases—particularly genetic, metabolic, autoimmune, and cardiovascular—are the leading contributors to long-term health loss, with parasitic diseases also posing significant challenges in low-income settings. A strong correlation exists between healthcare access, availability of treatment, and improved health outcomes, particularly in countries with high doctor density and robust public health infrastructure. However, nations such as Argentina, Brazil, India, France, Russia, and others face compounded challenges from limited healthcare access, economic hardship, and high disease burdens. Urbanization introduces both healthcare advantages and elevated risks of lifestyle-related illnesses, while the high economic costs of treatment in low-income regions call for urgent financial protection mechanisms. To address these issues, a multidimensional strategy involving early prevention, expanded access to care, workforce strengthening, economic support, and integrated health-economic policy is essential to reduce the disease burden and improve health equity across nations.
