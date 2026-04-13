CREATE DATABASE hr_project;
USE  hr_project;
 CREATE TABLE hr_data(
    Age INT,
    Attrition VARCHAR(10),
    BusinessTravel VARCHAR(50),
    DailyRate INT,
    Department VARCHAR(50),
    DistanceFromHome INT,
    Education INT,
    EducationField VARCHAR(50),
    EmployeeCount INT,
    EmployeeNumber INT,
    EnvironmentSatisfaction INT,
    Gender VARCHAR(10),
    HourlyRate INT,
    JobInvolvement INT,
    JobLevel INT,
    JobRole VARCHAR(50),
    JobSatisfaction INT,
    MaritalStatus VARCHAR(20),
    MonthlyIncome INT,
    MonthlyRate INT,
    NumCompaniesWorked INT,
    Over18 VARCHAR(5),
    OverTime VARCHAR(10),
    PercentSalaryHike INT,
    PerformanceRating INT,
    RelationshipSatisfaction INT,
    StandardHours INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    TrainingTimesLastYear INT,
    WorkLifeBalance INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT
);

SELECT * FROM hr_data ;


/* clean ddata */
SELECT * FROM  hr_data
WHERE Age IS NULL or Attrition is NULL;

/*check duplicates*/
SELECT   EmployeeNumber,COUNT(*)
FROM hr_data
GROUP BY  EmployeeNumber
HAVING COUNT(*)>1;

/*clean attrition*/
UPDATE hr_data
SET attrition =UPPER(attrition);
UPDATE hr_data
SET attrition ='Yes'
WHERE attrition= 'YES';

/* cleaning attrition*/
UPDATE hr_data
SET attrition ='No'
where attrition ='NO';
/*checking unncessary columns*/
SELECT COUNT(DISTINCT EmployeeCount ) FROM hr_data;
SELECT COUNT(DISTINCT StandardHours )FROM hr_data;
SELECT COUNT(DISTINCT   Over18)FROM hr_Data;

SELECT DISTINCT Over18 FROM hr_Data;
SELECT COUNT(*) as total_rows,
SUM(CASE WHEN over18 IS NULL THEN 1 ELSE 0 END)AS null_count
FROM hr_Data;

/*DROP OVER18 TABLE*/
ALTER TABLE hr_Data
DROP COLUMN over18;
ALTER TABLE hr_Data
DROP COLUMN  EmployeeCount,
DROP COLUMN   StandardHours;

/*EDA*/
SELECT attrition, COUNT(*)
FROM hr_Data 
GROUP BY attrition;
/*. Attrition Rate (KPI)*/
SELECT 
(COUNT(CASE WHEN attrition ='Yes' THEN 1 END) * 100.0 )/COUNT(*) AS attrition_rate
FROM hr_Data;
/*Department wise Attrition*/
SELECT Department,COUNT(*),
SUM(CASE WHEN attrition ='Yes' THEN 1 ELSE 0 END) AS left_emp,
 ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)*100.0)/COUNT(*),2) AS attrition_rate
FROM hr_data
GROUP BY Department;

/*. Overtime impact*/
 SELECT Overtime, COUNT(*) AS total,
 SUM(CASE WHEN attrition ='Yes' THEN 1 ELSE 0 END)left_emp,
 ROUND((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)*100.0)/COUNT(*),2) AS attrition_rate
 FROM hr_data
 GROUP BY  Overtime;
 
 /*. Salary vs Attrition*/
 SELECT attrition, ROUND(AVG(  MonthlyIncome),2) AS avg_Salary
 FROM hr_data
 GROUP BY  attrition;
 
 /*. Top Risk Job Roles*/
 SELECT   JobRole, COUNT(*)AS total_emp,
 SUM(CASE WHEN attrition ='Yes' THEN 1 ELSE 0 END)*100.0 / COUNT(*) AS left_emp,
 ROUND((SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END )*100.0)/COUNT(*),2)AS attrition_rate
 FROM hr_Data
 GROUP BY Jobrole
 ORDER BY attrition_rate DESC;

/*. Performance vs Attrition*/
SELECT  PerformanceRating, COUNT(*)
AS total,
SUM(CASE WHEN attrition ='Yes' THEN 1 ELSE 0 END) as left_emp,
ROUND((SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END)*100.0)/COUNT(*),2) AS attrition_rate
FROM hr_data
GROUP BY PerformanceRating;
