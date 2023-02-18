

/*

CREATE TABLE

*/

CREATE TABLE EmployeeDemographics
(EmployeeID int,
FirstName varchar(50),
LastName varchar(50),
Age int,
Gender varchar(50)
)

CREATE TABLE EmployeeSalary
(EmployeeID int,
JobTilt varchar(50),
Salalry int)

INSERT INTO EmployeeDemographics VALUES
(1001, 'Jim', 'Halpert', 30, 'Male'),
(1002, 'Pam', 'Beasley', 30, 'Female'),
(1003, 'Dwight', 'Schrute', 29, 'Male'),
(1004, 'Angela', 'Martin', 31, 'Female'),
(1005, 'Toby', 'Flenderson', 32, 'Male'),
(1006, 'Michael', 'Scott', 35, 'Male'),
(1007, 'Meredith', 'Palmer', 32, 'Female'),
(1008, 'Stanley', 'Hudson', 38, 'Male'),
(1009, 'Kevin', 'Malone', 31, 'Male')


INSERT INTO EmployeeSalary VALUES
(1001, 'Salesman', 45000),
(1002, 'Receptionist', 36000),
(1003, 'Salesman', 63000),
(1004, 'Accountant', 4000),
(1005, 'HR', 50000),
(1006, 'Regional Manager', 65000),
(1007, 'Supplier Relations', 41000),
(1008, 'Salesman', 48000),
(1009, 'Accountant', 42000)

SELECT *
FROM EmployeeDemographics   
WHERE FirstName IN ('Jim', 'Michael')

SELECT Gender, Age, COUNT(Gender) AS CountGender
FROM EmployeeDemographics
WHERE Age > 31
GROUP BY Gender, Age
ORDER BY CountGender DESC

-----------------------------------------------------------------------------------------------------------------------

SELECT JobTilt, AVG(Salalry)
FROM EmployeeDemographics
Inner Join EmployeeSalary
        ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
WHERE JobTilt = 'Salesman'
GROUP BY JobTilt

-- Using Union

SELECT *
FROM EmployeeDemographics
UNION 
SELECT *
FROM EmployeeSalary

-- Using Case

SELECT FirstName, LastName, JobTilt, Salalry,
CASE
  WHEN JobTilt = 'Salesman' THEN Salalry + (Salalry * .10)
	WHEN JobTilt = 'Accountant' THEN Salalry + (Salalry * .05)
	WHEN JobTilt = 'HR' THEN Salalry + (Salalry * .000001)
	ELSE Salalry + (Salalry * .03)
END as SalaryAfterraise
FROM EmployeeDemographics
JOIN EmployeeSalary
  ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID


UPDATE EmployeeDemographics
SET EmployeeID = 1012
WHERE FirstName = 'Holly' AND LastName = 'Flax'
     
------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
/*

CTE'S

*/

WITH CTE_Employee as
(SELECT FirstName, LastName, Gender, Salalry
, COUNT(gender) OVER (PARTITION BY Gender) as TotalGender
, AVG(gender) OVER (PARTITION BY Gender) as AvgSalary
FROM EmployeeDemographics emp
JOIN EmployeeSalary sal
  ON emp.EmployeeID = sal.EmployeeID
WHERE Salalry > '45000'
)
SELECT *
FROM CTE_Employee


/*

Temp Tables

*/

CREATE TABLE #temp_Employee (
EmployeeID int,
JobTitle varchar(100),
Salary int
)

SELECT *
FROM #temp_Employee

INSERT INTO #temp_Employee VALUES (
'1001', 'HR', '45000'
)

INSERT INTO #temp_Employee
SELECT *
FROM EmployeeSalary


DROP TABLE IF EXISTS #Temp_Employee2
CREATE TABLE #Temp_Employee2 (
JobTitle varchar(50),
EmployeesPerJob int,
AvgAge int,
AvgSalary int )

INSERT INTO #Temp_Employee2
SELECT JobTilt, Count(JobTilt),AVG(Age), AVG(Salalry)
FROM EmployeeDemographics emp
Inner Join EmployeeSalary sal
        ON emp.EmployeeID = sal.EmployeeID
GROUP BY JobTilt

SELECT *
FROM #Temp_Employee2

----------------------------------------------------------------------------------------------------------------------------------------------

/*

String Functions - TRIM, LTRIM, RTRIM, Substring, Upper, lower

*/

CREATE TABLE EmployeeErrors (
EmlpoyeeID varchar(50),
Firstname varchar(50),
LastName varchar(50)
)

Insert into EmployeeErrors values
('1001 ', 'Jimbo', 'Halbert'),
(' 1002', 'Pamela', 'Beasely'),
('1005', 'TOby', 'Flenderson - Fired')

Select *
From EmployeeErrors

-- Using TRIM, LTrim, RTrim

Select EmployeeID, TRIM(EmployeeID) AS IDTRIM
From EmployeeErrors

Select EmployeeID, LTRIM(EmployeeID) AS IDTRIM
From EmployeeErrors

Select EmployeeID, RTRIM(EmployeeID) AS IDTRIM
From EmployeeErrors

-- Using Replace

Select Lastname, Replace(Lastname, '- Fired', '') AS LastNameFixed
From EmployeeErrors

-- Using substring

Select SUBSTRING(FirstName,1,3)
From EmployeeErrors

Select err.FirstName, SUBSTRING(err.FirstName,1,3), dem.FirstName, SUBSTRING(dem.FirstName,1,3)
From EmployeeErrors err
JOIN EmployeeDemographics dem
  ON SUBSTRING(err.FirstName,1,3) = SUBSTRING(dem.FirstName,1,3)

/*

Stored Procedures

*/

CREATE PROCEDURE TEST
AS
Select *
FROM EmployeeDemographics

EXEC TEST

CREATE PROCEDURE Temp_Employees
AS
CREATE TABLE #Temp_Employee2 (
JobTitle varchar(50),
EmployeesPerJob int,
AvgAge int,
AvgSalary int )

INSERT INTO #Temp_Employee2
SELECT JobTilt, Count(JobTilt),AVG(Age), AVG(Salalry)
FROM EmployeeDemographics emp
Inner Join EmployeeSalary sal
        ON emp.EmployeeID = sal.EmployeeID
GROUP BY JobTilt

Select *
From #Temp_Employee2

EXEC Temp_Employees

/*

Subqueries (in the Select, From, and Where Statement)

*/ 

Select *
From EmployeeSalary

-- Subquery in Select

Select EmployeeID, Salalry, (Select AVG(Salalry) From EmployeeSalary) as AllAvgSalary
From EmployeeSalary

-- How to do it with Partition by

Select EmployeeID, Salalry, AVG(Salalry) over () as AllAvgSalary
From EmployeeSalary

-- Subquery in From

Select a.EmployeeID, AllAvgSalary
From (Select EmployeeID, Salalry, AVG(Salalry) over () as AllAvgSalary
       From EmployeeSalary) a

-- Subquery in Where

Select EmployeeID, JobTilt, Salalry
From EmployeeSalary
Where EmployeeID in (
        Select EmployeeID
		From EmployeeDemographics
		Where Age > 30)