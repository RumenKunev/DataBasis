-- 1.Problem
SELECT FirstName, LastName, Salary 
FROM Employees
WHERE Salary IN (SELECT MIN(Salary) FROM Employees);

-- 2.Problem
SELECT FirstName,LastName, Salary
FROM Employees
WHERE Salary <
	(SELECT MIN(Salary) * 1.10
	FROM Employees);

-- 3.Problem
SELECT e.FirstName + ' ' + e.LastName AS [Full Name], e.Salary AS [Salary], d.Name AS [Department]
FROM Employees e 
	JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE Salary IN
	(SELECT MIN(Salary) FROM Employees
	 WHERE DepartmentID = e.DepartmentID);

-- 4.Problem
SELECT AVG(Salary) 
FROM Employees
WHERE DepartmentID = 1;

-- 5.Problem
SELECT AVG(Salary) AS [Average Salary in 'Sales Department']
FROM Employees e
	JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.Name LIKE 'Sales';

-- 6.Problem
SELECT COUNT(*) AS [Employees in 'Sales']
FROM Employees e
	JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.Name LIKE 'Sales';

-- 7.Problem
SELECT COUNT(ManagerID) 
FROM Employees;

-- 8.Problem
SELECT COUNT(*) FROM Employees
WHERE ManagerID IS NULL;

-- 9.Problem
SELECT d.Name AS [Department], AVG(Salary) AS [Average Salary]
FROM Employees e
	JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.Name
ORDER BY d.Name ASC;

-- 10.Problem
SELECT t.Name AS [Town], d.Name AS [Department], COUNT(e.EmployeeID) AS [Employees Count]
FROM Employees e
	JOIN Addresses a ON e.AddressID = a.AddressID
	JOIN Towns t ON t.TownID = a.TownID
	JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY t.Name, d.Name
ORDER BY d.Name;

-- 11.Problem
SELECT  m.FirstName, m.LastName, COUNT(e.EmployeeID) AS [Employees count]
FROM Employees e
	JOIN Employees m ON e.ManagerID = m.EmployeeID
GROUP BY m.EmployeeID, m.FirstName, m.LastName
HAVING COUNT(e.EmployeeID) = 5;	

-- 12.Problem
SELECT  e.FirstName + ' ' + ISNULL(e.MiddleName + ' ', '') + e.LastName AS [Employee Name], 
		ISNULL(m.FirstName + ' ' + m.LastName, 'No manager') AS [Manager]
FROM Employees e
	LEFT JOIN Employees m ON e.ManagerID = m.EmployeeID;
	
SELECT FirstName, ISNULL(CAST(ManagerID as nvarchar(max)), 'no manager')
FROM Employees
ORDER BY ManagerID;

SELECT FirstName, ISNULL(CONVERT(nvarchar(max), ManagerID), 'no manager')
FROM Employees
ORDER BY ManagerID;

-- 13.Problem
SELECT FirstName FROM Employees
WHERE LEN(LastName) = 5;

-- 14.Problem
SELECT CONVERT(nvarchar(6), GETDATE(), 4) + CONVERT(nvarchar(6),YEAR(GETDATE())) + ' '
	+ CONVERT(nvarchar, GETDATE(), 114) AS DateTime;

-- 15.Problem
CREATE TABLE Users (
  UserID int IDENTITY,
  UserName nvarchar(50) NOT NULL,
  UserPassword nvarchar(50) NOT NULL,
  FullName nvarchar(100) NOT NULL,
  LastLogin DATETIME,
  CONSTRAINT PK_Users PRIMARY KEY(UserID),
  CONSTRAINT UNQ_Users UNIQUE(UserName),
  CONSTRAINT CHK_Password CHECK (LEN(UserPassword) >= 5)
); 

GO

INSERT INTO [dbo].[Users]
           ([UserName]
           ,[UserPassword]
           ,[FullName]
           ,[LastLogin])
     VALUES
           ('Rumen',
            'RumenPass',
            'Rumen Kunev',
            GETDATE());
 
INSERT INTO [dbo].[Users]
           ([UserName]
           ,[UserPassword]
           ,[FullName]
           ,[LastLogin])
     VALUES
           ('Hristo',
            'Password',
            'Hristo Hristov',
            '2015-02-18');
GO

-- 16.Problem
CREATE VIEW TodayUsers AS
SELECT * FROM Users
WHERE DAY(LastLogin) = DAY(GETDATE());

GO  

SELECT * FROM TodayUsers;
GO

-- 17.Problem
CREATE TABLE Groups(
	GroupID int IDENTITY,
	GroupName nvarchar(50) NOT NULL,
	CONSTRAINT PK_Groups PRIMARY KEY(GroupID),
	CONSTRAINT UK_Users UNIQUE(GroupName)
);

GO

-- 18.Problem
ALTER TABLE Users
ADD GroupID INT FOREIGN KEY REFERENCES Groups(GroupID);
INSERT Groups VALUES ('Junior');
INSERT Groups VALUES ('Senior');
INSERT Groups VALUES ('Master');
UPDATE Users SET GroupID = 1;
INSERT Users VALUES ('Another User', 'Another Password', 'AU',  GETDATE(), 2);

ALTER TABLE Users ALTER COLUMN FullName nvarchar(100) NULL;

ALTER TABLE Users ALTER COLUMN GroupID int NOT NULL;

-- 19.Problem
INSERT INTO Users VALUES('sdd','sssSSSs', 'sssSSS', '12-02-2015', 3);
INSERT INTO Groups VALUES('THE ARCHITECT');
INSERT INTO Users VALUES('ljljlkj', 'kkkknnV', NULL, NULL, 2);

-- 20.Problem
UPDATE Groups SET GroupName = 'Master Architect'
WHERE GroupName = 'THE ARCHITECT';

UPDATE Users SET FullName = 'No data'
WHERE FullName IS NULL;

-- 21.Problem
DELETE FROM Users WHERE UserName LIKE 'Rumen';
DELETE FROM Groups WHERE GroupID = 1;

-- 22.Problem
--INSERT INTO Users
--SELECT LOWER(LEFT(FirstName, 1) + LastName) AS UserName,
--	 LOWER(LEFT(FirstName, 1) + LEFT(LastName, 1)+ '1234') AS Password,
--	 FirstName + ' ' + LastName as FullName,
--	 NULL AS LastLoginTime,
--	 2 AS GroupId
--FROM Employees

INSERT INTO Users
SELECT LEFT(LOWER(LEFT(FirstName, 1) + LEFT(ISNULL(MiddleName, '_'), 1) + LastName), 10) AS [UserName],
           LOWER(LEFT(FirstName, 1) + LastName + 'pwd') AS [UserPassword],
           FirstName + ' ' + LastName AS [FullName],
           NULL AS [LastLogin],
           2 AS [GroupID]
FROM Employees
ORDER BY LOWER(LEFT(FirstName, 1) + LastName);

-- 23.Problem
ALTER TABLE Users ALTER COLUMN UserPassword nvarchar(50) NULL;

GO
UPDATE Users SET UserPassword = NULL
WHERE LastLogin <= CAST('2013-10-03' AS DATETIME);

-- 24.Problem
DELETE FROM Users
WHERE UserPassword IS NUll;

-- 25.Problem
SELECT d.Name AS Department, e.JobTitle AS [Job Title], AVG(e.Salary) AS [Average Salary]
FROM Employees e
	JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.Name, e.JobTitle;

-- 26.Problem
SELECT d.Name AS Department, e.JobTitle AS [Job Title], MIN(e.FirstName), MIN(e.Salary) AS [Average Salary]
FROM Employees e
	JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.Name, e.JobTitle
ORDER BY d.Name;

--SELECT FirstName, LastName, d.Name, Salary
--FROM Employees e 
--	JOIN Departments d 
--	ON d.DepartmentID = e.DepartmentID
--WHERE Salary = 
--  (SELECT MIN(Salary) FROM Employees 
--   WHERE DepartmentID = e.DepartmentID)
--GROUP BY d.Name,  FirstName, LastName, Salary
--ORDER BY d.Name

-- 27.Problem
SELECT TOP 1 t.Name, COUNT(FirstName) AS [Number of Employees]
FROM Employees e
	JOIN Addresses a ON e.AddressID = a.AddressID
	JOIN Towns t ON a.TownID = t.TownID
GROUP BY t.Name
ORDER BY [Number of Employees] DESC;

-- 28.Problem
SELECT t.Name, COUNT(ManagerID) AS [Number of managers]
FROM Employees e
	JOIN Addresses a ON e.AddressID = a.AddressID
	JOIN Towns t ON t.TownID = a.TownID 
WHERE e.EmployeeID IN
		(SELECT DISTINCT ManagerID	
		FROM Employees  
		WHERE ManagerID IS NOT NULL)
GROUP BY t.Name;

--SELECT t.Name AS [Town], COUNT(DISTINCT e.ManagerID) AS [NUMBER OF Managers]
--FROM Employees e
--  JOIN Employees m
--    ON e.ManagerID = m.EmployeeID
--  JOIN Addresses a
--    ON m.AddressID = a.AddressID
--  JOIN Towns t
--    ON a.TownID = t.TownID
--GROUP BY t.Name;

-- 29.Problem
CREATE TABLE WorkingHours(
	ID int PRIMARY KEY IDENTITY NOT NULL,
	EmployeeId int FOREIGN KEY REFERENCES Employees(EmployeeId)  NOT NULL,
    Date datetime NULL,
    Task nvarchar(150) NOT NULL,
    Hours int NOT NULL,
    Comments ntext NULL
);

-- Problem 30.	Issue few SQL statements to insert, update and delete of some data in the table.
-- Problem 31.	Define a table WorkHoursLogs to track all changes in the WorkHours table with triggers.
CREATE TABLE WorkHoursLogs
(
        Id int PRIMARY KEY IDENTITY NOT NULL,
		Message nvarchar(150) NOT NULL,
		DateOfChange datetime NOT NULL
)

GO

CREATE TRIGGER  tr_WorkHoursInsert 
ON WorkHours
 FOR INSERT
AS 
	INSERT INTO WorkHoursLogs (Message, DateOfChange)
	VALUES('Added row', GETDATE ( ))
GO

CREATE TRIGGER  tr_WorkHoursDelete 
ON WorkHours
 FOR DELETE
AS 
	INSERT INTO WorkHoursLogs (Message, DateOfChange)
	VALUES('Deleted row', GETDATE ( ))
GO

CREATE TRIGGER  tr_WorkHoursUpdate
ON WorkHours
 FOR UPDATE
AS 
	INSERT INTO WorkHoursLogs (Message, DateOfChange)
	VALUES('Update row', GETDATE ( ))
GO

INSERT INTO WorkHours (EmployeeId, Date, Task, Hours)
	VALUES(10, GETDATE ( ), 'Bla-Bla', 10)

INSERT INTO WorkHours (EmployeeId, Date, Task, Hours)
	VALUES(11, GETDATE ( ), 'Bla-Bla-2', 100)

DELETE WorkHours
WHERE EmployeeId = 10

UPDATE WorkHours
SET Task = 'Bla-Bla Ura-a-a'
WHERE EmployeeId = 11

SELECT * FROM WorkHoursLogs

-- Problem 32.	Start a database transaction, delete all employees from the 'Sales' department along 
-- with all dependent records from the pother tables. At the end rollback the transaction.
BEGIN TRAN
DELETE  Employees
WHERE DepartmentID = 
	(SELECT DepartmentID 
	 FROM Departments
	 WHERE Name = 'Sales')

SELECT * FROM Employees e
	JOIN Departments d
		ON e.DepartmentID = d.DepartmentID
WHERE d.Name = 'Sales'
ROLLBACK TRAN

-- Problem 33.	Start a database transaction and drop the table EmployeesProjects.
BEGIN TRAN
DROP TABLE EmployeesProjects
ROLLBACK TRAN

-- Problem 34.	Find how to use temporary tables in SQL Server.
SELECT * INTO ##TempTableProjects
FROM EmployeesProjects
 
 DROP TABLE EmployeesProjects
 
 CREATE TABLE EmployeesProjects
  (
   EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID) NOT NULL,
   ProjectID INT FOREIGN KEY REFERENCES Projects(ProjectID) NOT NULL,
  )
 
 INSERT INTO EmployeesProjects
 SELECT * FROM  ##TempTableProjects