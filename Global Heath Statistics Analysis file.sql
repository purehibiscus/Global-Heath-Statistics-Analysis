USE [Data Cleaning and Analysis];
GO

IF OBJECT_ID('dbo.global_health_statistics', 'U') IS NOT NULL
    DROP TABLE dbo.global_health_statistics;
GO

-- Temporary import with Billing Amount as text
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




BULK INSERT dbo.global_health_statistics
FROM 'C:\Users\nadanee\Desktop\MY CASE STUDES\Unclenaned datasets\Global Health Statistics.csv'
WITH (
    FIRSTROW = 2,              
    FIELDTERMINATOR = ',',    
    ROWTERMINATOR = '\n',     
    TABLOCK                   
);

-- A. Data Validation and Governance

-- 1. checking for missing values through every column

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

-- 2. Checking for data type validation

SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM [Data Cleaning and Analysis].INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'global_health_statistics'
  AND TABLE_SCHEMA = 'dbo'
ORDER BY ORDINAL_POSITION;

-- 3. Performing Range checks for numberical columns. Normal range =(0-100), else an outlier
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

-- 4. Checking for data points inconsistencies
SELECT DISTINCT [Disease Name], 
				[Disease Category],
				COUNT(*) AS DiseaseCount
FROM [Data Cleaning and Analysis].[dbo].[global_health_statistics]
GROUP BY [Disease Name],
		[Disease Category]
ORDER BY DiseaseCount DESC;


-- B. Performing a brief Exploratory Data Analysis (EDA)

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

-- 3. Checking correlation between healthcare access and recovery rates for different diseases
SELECT AVG([Healthcare Access (%)]) AS AvgHealthcareAccess,
		AVG([Recovery Rate (%)]) AS AvgRecoveryRate,
		[Disease Name]
FROM [Data Cleaning and Analysis].[dbo].[global_health_statistics]
WHERE [Healthcare Access (%)] IS NOT NULL  -- to avoid skewness of data
	AND [Recovery Rate (%)] IS NOT NULL
GROUP BY [Disease Name]
ORDER BY AvgHealthcareAccess DESC,
		AvgRecoveryRate DESC;


-- C. General Analysis to extract Insights and Patterns
-- Here, the analysis is categorized into 2, each having questions to answer
-- a. Disease Burden and Healthcare
-- b. Healthcare Systems and Economic Impact

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

-- C. KPIs 

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












