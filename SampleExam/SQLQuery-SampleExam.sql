-- Problem 1.

SELECT Title FROM Ads
ORDER BY Title ASC;

-- Problem 2.

SELECT Title, [Date] FROM Ads
WHERE [Date] BETWEEN '2014-12-26' AND '2015-01-02'
ORDER BY [Date];

--SELECT 
--	Title,
--	[Date]
--FROM Ads
--WHERE [Date] >= '26-Dec-2014' 
--AND [Date] < '2-Jan-2015'
--ORDER BY [Date]

-- Problem 3.

SELECT 
	Title, 
	[Date],
	CASE
		WHEN ImageDataURL IS NULL THEN 'no'
		WHEN ImageDataURL IS NOT NULL THEN 'yes'
	END
	AS [Has Image]
FROM Ads
ORDER BY Id;

-- Problem 4.

SELECT * FROM Ads
WHERE 
	TownId IS NULL
	OR CategoryId IS NULL 
	OR ImageDataURL IS NULL 
ORDER BY Id;

-- Problem 5.

SELECT a.Title, t.Name AS Town
FROM Ads a
LEFT JOIN Towns t ON a.TownId = t.Id
ORDER BY a.Id;

-- Problem 6.

SELECT 
	a.Title, 
	c.Name AS CategoryName,
	t.Name AS TownName,
	s.Status
FROM Ads a
LEFT JOIN Towns t ON a.TownId = t.Id
LEFT JOIN Categories c ON a.CategoryId = c.Id
LEFT JOIN AdStatuses s ON a.StatusId = s.Id
ORDER BY a.Id;

-- Problem 7.

SELECT 
	a.Title, 
	c.Name AS CategoryName,
	t.Name AS TownName,
	s.Status
FROM Ads a
LEFT JOIN Towns t ON a.TownId = t.Id
LEFT JOIN Categories c ON a.CategoryId = c.Id
LEFT JOIN AdStatuses s ON a.StatusId = s.Id
WHERE s.Status = 'Published' AND
	t.Name IN ('Sofia', 'Blagoevgrad', 'Stara Zagora')
ORDER BY a.Title;

-- Problem 8.

SELECT MIN([Date]) AS MinDate, MAX([Date]) AS MaxDate
FROM Ads;

-- Problem 9.

SELECT TOP 10 a.Title, a.[Date], s.[Status]
FROM Ads a
JOIN AdStatuses s ON a.StatusId = s.Id
ORDER BY a.[Date] DESC;

-- Problem 10.

DECLARE @firstDate date;
SET @firstDate = (SELECT MIN(Date) FROM Ads);

SELECT a.Id, a.Title, a.[Date], s.[Status]
FROM Ads a
JOIN AdStatuses s ON a.StatusId = s.Id
WHERE DATEDIFF(YEAR, a.Date, @firstDate) = 0
	AND DATEDIFF(MONTH, a.Date, @firstDate) = 0
	AND s.Status <> 'Published'
ORDER BY a.Id;

--SELECT a.Id, a.Title, a.[Date], s.[Status]
--FROM Ads a
--JOIN AdStatuses s ON a.StatusId = s.Id
--WHERE MONTH(a.Date) = (SELECT MONTH(MIN(Date)) FROM Ads)
--	AND YEAR(a.Date) = (SELECT YEAR(MIN(Date)) FROM Ads)	
--	AND s.Status <> 'Published'
--ORDER BY a.Id;

-- Problem 11.

SELECT [Status], COUNT(*) AS [Count]
FROM Ads a
JOIN AdStatuses s ON a.StatusId = s.Id
GROUP BY [Status]
ORDER BY [Status];

-- Problem 12.

SELECT t.[Name] AS [Town Name], s.[Status], COUNT(*) AS [Count]
FROM Ads a
JOIN AdStatuses s ON a.StatusId = s.Id
JOIN Towns t ON a.TownId = t.Id
GROUP BY t.[Name], s.[Status]
ORDER BY t.[Name], s.[Status];

-- Problem 13.

SELECT
	DISTINCT u.UserName AS [UserName], 
	COUNT(a.Id) AS [AdsCount],
	CASE MIN(r.Name)
		WHEN 'Administrator' THEN 'yes'
		ELSE 'no'
	END 
	AS [IsAdministrator] 
FROM Ads a
	RIGHT JOIN AspNetUsers u ON a.OwnerId = u.Id
	LEFT JOIN AspNetUserRoles ur ON u.Id = ur.UserId
	LEFT JOIN AspNetRoles r ON ur.RoleId = r.Id 
GROUP BY u.UserName
ORDER BY u.UserName;

SELECT
  MIN(u.UserName) as UserName, 
  COUNT(a.Id) as AdsCount,
  (CASE WHEN admins.UserName IS NULL THEN 'no' ELSE 'yes' END) AS IsAdministrator
FROM 
  AspNetUsers u
  LEFT JOIN Ads a ON u.Id = a.OwnerId
  LEFT JOIN (
    SELECT DISTINCT u.UserName
    FROM AspNetUsers u
    LEFT JOIN AspNetUserRoles ur ON ur.UserId = u.Id
    LEFT JOIN AspNetRoles r ON ur.RoleId = r.Id
    WHERE r.Name = 'Administrator'
  ) AS admins ON u.UserName = admins.UserName
GROUP BY OwnerId, u.UserName, admins.UserName
ORDER BY u.UserName


-- Problem 14.

SELECT 
	COUNT(*) AS [AdsCount], 
	CASE
		WHEN t.Name IS NULL THEN '(no town)'
		WHEN t.Name IS NOT NULL THEN t.Name
	END 
	AS [Town]
FROM Ads a
LEFT JOIN Towns t ON a.TownId = t.Id
GROUP BY a.TownId, t.Name
HAVING (COUNT(*) BETWEEN 2 AND 4)
	OR t.Name IS NULL
ORDER BY t.Name;

--SELECT
--  COUNT(a.Id) as AdsCount,
--  ISNULL(t.Name, '(no town)') as Town
--FROM
--  Ads a
--  LEFT JOIN Towns t ON a.TownId = t.Id
--GROUP BY t.Name
--HAVING COUNT(a.Id) BETWEEN 2 AND 3
--ORDER BY t.Name

-- Problem 15.

SELECT 
	a1.Date AS FirstDate,
	a2.Date AS SecondDate
FROM Ads a1, Ads a2
WHERE a2.Date > a1.Date 
	AND DATEDIFF(HOUR, a1.Date, a2.Date) < 12
ORDER BY FirstDate, SecondDate;

--SELECT a1.Date AS FirstDate, a2.Date AS SecondDate
--FROM Ads a1, Ads a2
--WHERE
--  a2.Date > a1.Date AND
--  DATEDIFF(second, a1.Date, a2.Date) < 12 * 60 * 60
--ORDER BY a1.Date, a2.Date

-- Problem 16.

UPDATE Ads
SET TownId = (SELECT TownId FROM Towns WHERE Name = 'Paris')
WHERE DATENAME (WEEKDAY, [Date]) = 'Friday';

--UPDATE Ads
--SET TownId = (SELECT TownId FROM Towns WHERE Name='Paris')
--WHERE DATEPART(weekday, Date) = 6

UPDATE Ads
SET TownId = 
	(SELECT TownId FROM Towns
	WHERE Name = 'Hamburg')
WHERE DATENAME(weekday,[Date]) = 'Thursday';


DELETE FROM Ads
WHERE OwnerId IN
	(SELECT u.Id 
	FROM AspNetUsers u
		JOIN AspNetUserRoles ur ON u.Id = ur.UserId
		JOIN AspNetRoles r ON ur.RoleId = r.Id
	WHERE r.Name = 'Partner');

--DELETE FROM Ads
--FROM Ads a
--  JOIN AspNetUsers u ON a.OwnerId = u.Id
--  JOIN AspNetUserRoles ur ON u.Id = ur.UserId
--  JOIN AspNetRoles r ON r.Id = ur.RoleId
--  WHERE r.Name = 'Partner'

INSERT INTO Ads([Title], [Text], [Date], [OwnerId], [StatusId])
VALUES ('Free Book', 'Free C# Book', GETDATE (), 
	(SELECT Id FROM AspNetUsers WHERE UserName = 'nakov'),
	(SELECT Id FROM AdStatuses WHERE [Status] = 'Waiting Approval'));


SELECT
  t.Name as Town,
  c.Name as Country,
  COUNT(a.Id) as AdsCount
FROM
  Ads a
  FULL OUTER JOIN Towns t ON a.TownId = t.Id
  FULL OUTER JOIN Countries c ON t.CountryId = c.Id
GROUP BY t.Name, c.Name
ORDER BY t.Name, c.Name

-- Problem 17.

CREATE VIEW AllAds AS
SELECT 
	a.Id,
	a.Title, 
	u.UserName AS Author, 
	Date, 
	t.Name AS Town, 
	c.Name AS Category, 
	s.Status AS Status
FROM Ads a
LEFT JOIN AspNetUsers u ON a.OwnerId = u.Id
LEFT JOIN AdStatuses s ON a.StatusId = s.Id
LEFT JOIN Categories c ON a.CategoryId = c.Id
LEFT JOIN Towns t ON a.TownId = t.Id;

GO  


SELECT * FROM AllAds;

CREATE FUNCTION fn_ListUsersAds()
	RETURNS @tbl_UsersAds TABLE(
		UserName NVARCHAR(MAX),
		AdDates NVARCHAR(MAX)
	)
AS
BEGIN
	DECLARE UsersCursor CURSOR FOR
		SELECT UserName FROM AspNetUsers
		ORDER BY UserName DESC;
	OPEN UsersCursor;
	DECLARE @username NVARCHAR(MAX);
	FETCH NEXT FROM UsersCursor INTO @username;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @ads NVARCHAR(MAX) = NULL;
		SELECT
			@ads = CASE
				WHEN @ads IS NULL THEN CONVERT(NVARCHAR(MAX), Date, 112)
				ELSE @ads + '; ' + CONVERT(NVARCHAR(MAX), Date, 112)
			END
		FROM AllAds
		WHERE Author = @username
		ORDER BY Date;

		INSERT INTO @tbl_UsersAds
		VALUES(@username, @ads)
		
		FETCH NEXT FROM UsersCursor INTO @username;
	END;
	CLOSE UsersCursor;
	DEALLOCATE UsersCursor;
	RETURN;
END
GO

SELECT * FROM fn_ListUsersAds()