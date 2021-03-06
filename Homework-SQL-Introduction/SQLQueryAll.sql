-- Problem 4
SELECT * FROM Departments;

SELECT D.DepartmentID, d.Name, e.FirstName + ' ' + e.LastName AS [Manager name]
FROM Departments d
JOIN Employees e
	ON d.ManagerID = e.ManagerID;

-- Problem 5
SELECT Name AS [Department Name] FROM Departments;

-- Problem 6
SELECT FirstName, LastName, Salary FROM Employees;

-- Problem 7
SELECT FirstName + ' ' + LastName AS [Full Name] FROM Employees;

-- Problem 8
SELECT FirstName + '.' + LastName + '@softuni.bg' AS [Full Email Addresses] FROM Employees;

-- Problem 9
SELECT DISTINCT Salary FROM Employees;

-- Problem 10
SELECT FirstName + ' ' + LastName, JobTitle
FROM Employees
WHERE JobTitle = 'Sales Representative';

SELECT FirstName + ' ' + LastName, JobTitle
FROM Employees
WHERE JobTitle LIKE 'Sales%';

-- Problem 11
SELECT FirstName, LastName FROM Employees
WHERE FirstName LIKE 'SA%';

-- Problem 12
SELECT FirstName, LastName FROM Employees
WHERE LastName LIKE '%ei%';

-- Problem 13
SELECT FirstName + ' ' + LastName AS [Emploee's Name], Salary FROM Employees
WHERE Salary >= 20000 AND Salary <= 30000;

SELECT FirstName + ' ' + LastName AS [Emploee's Name], Salary FROM Employees
WHERE Salary BETWEEN 20000 AND 30000;

-- Problem 14
SELECT FirstName, LastName, Salary FROM Employees
WHERE Salary IN (25000, 14000, 12500, 23600);

-- Problem 15
SELECT * FROM Employees
WHERE ManagerID IS NULL;

-- Problem 16
SELECT * FROM Employees
WHERE Salary > 50000
ORDER BY Salary DESC;

-- Problem 17
SELECT TOP 5 * FROM Employees
ORDER BY Salary DESC;

-- Problem 18
SELECT e.FirstName, e.LastName, a.AddressText + ', ' + t.Name AS [Full Address]
FROM Employees e
JOIN Addresses a
	ON e.AddressID = a.AddressID
JOIN Towns t
	ON a.TownID = t.TownID;

-- Problem 19
SELECT e.FirstName, e.LastName, a.AddressText, t.Name AS Town
FROM Employees e, Addresses a, Towns t
WHERE e.AddressID = a.AddressID AND a.TownID = t.TownID;

-- Problem 20
SELECT e.FirstName, E.LastName, m.FirstName + ' ' + m.LastName AS [Manager Name]
FROM Employees e
JOIN Employees m
	ON e.ManagerID = m.EmployeeID;

-- Problem 21
SELECT e.FirstName + ' ' + ISNULL(e.MiddleName + ' ', '') + e.LastName AS [Employee Name],
	m.FirstName, 
	a.AddressText,
	t.Name	
FROM Employees e
JOIN Employees m
	ON e.ManagerID = m.EmployeeID 
JOIN Addresses a
	ON m.AddressID = a.AddressID
JOIN Towns t
	ON a.TownID = t.TownID;

-- Problem 22
SELECT Name 
FROM Departments
UNION
SELECT Name
FROM Towns;

-- Problem 23
SELECT e.FirstName + ' ' + ISNULL(e.MiddleName + ' ', '') + e.LastName AS [Employee Name],
	m.FirstName
FROM Employees e
LEFT OUTER JOIN Employees m
	ON e.ManagerID = m.EmployeeID;

SELECT e.FirstName + ' ' + ISNULL(e.MiddleName + ' ', '') + e.LastName AS [Employee Name],
	m.FirstName
FROM Employees e
RIGHT OUTER JOIN Employees m
	ON e.ManagerID = m.EmployeeID;

-- Problem 24
SELECT e.FirstName + ' ' + ISNULL(e.MiddleName + ' ', '') + e.LastName AS [Employee Name],
	d.Name,
	Year(e.HireDate)
FROM Employees e
JOIN Departments d
	ON e.DepartmentID = d.DepartmentID
WHERE Year(e.HireDate) BETWEEN 1995 AND 2005
	AND d.Name IN ('Sales', 'Finance');