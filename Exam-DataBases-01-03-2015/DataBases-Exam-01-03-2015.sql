--01

SELECT PeakName
FROM Peaks
ORDER BY PeakName;

--02

SELECT TOP 30 CountryName, Population
FROM Countries
WHERE ContinentCode = 'EU'
ORDER BY Population DESC, CountryName;

--03

SELECT 
	CountryName,
	CountryCode,
	CASE 
		WHEN CurrencyCode = 'EUR' THEN 'Euro'
		ELSE 'Not Euro'
	END
	AS Currency 
FROM Countries
ORDER BY CountryName;

--04

SELECT 
	CountryName AS [Country Name],
	IsoCode AS [ISO Code]
FROM Countries
WHERE (LEN(CountryName) - LEN(Replace(CountryName, 'A', ''))) >= 3
ORDER BY IsoCode;

--05

SELECT 
	p.PeakName,
	m.MountainRange AS Mountain,
	p.Elevation
FROM Peaks p
JOIN Mountains m ON p.MountainId = m.Id
ORDER BY Elevation DESC;

--06

SELECT 
	p.PeakName,
	m.MountainRange AS Mountain,
	c.CountryName,
	con.ContinentName
FROM Peaks p
JOIN Mountains m ON p.MountainId = m.Id
JOIN MountainsCountries mc ON m.Id = mc.MountainId
JOIN Countries c ON mc.CountryCode = c.CountryCode
JOIN Continents con ON con.ContinentCode = c.ContinentCode
ORDER BY p.PeakName, c.CountryName;


--07

SELECT 
	r.RiverName AS [River],
	COUNT(cr.CountryCode) AS [Countries Count]
FROM Rivers r
LEFT JOIN CountriesRivers cr ON r.Id = cr.RiverId
GROUP BY r.Id, r.RiverName
HAVING COUNT(cr.CountryCode) >= 3
ORDER BY r.RiverName;

--08

SELECT
	MAX(Elevation) AS MaxElevation,
	MIN(Elevation) AS MinElevation,
	AVG(Elevation) AS AverageElevation
FROM Peaks;

--09

SELECT
	c.CountryName,
	con.ContinentName,
	ISNULL(COUNT(r.Id), 0) AS [RiversCount],
	ISNULL(SUM(r.Length), 0) AS TotalLength
FROM Countries c
LEFT JOIN CountriesRivers cr ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers r ON cr.RiverId = r.Id
LEFT JOIN Continents con ON c.ContinentCode = con.ContinentCode
GROUP BY c.CountryCode, c.CountryName, con.ContinentName
ORDER BY COUNT(c.CountryCode) DESC, SUM(r.Length) DESC, c.CountryName;


--10

SELECT
	cu.CurrencyCode,
	cu.Description AS Currency,
	COUNT(c.CountryCode) AS NumberOfCountries
FROM Currencies cu
LEFT JOIN Countries c ON cu.CurrencyCode = c.CurrencyCode
GROUP BY cu.CurrencyCode, cu.Description
ORDER BY COUNT(c.CountryCode) DESC, cu.Description;


--11

SELECT 
	con.ContinentName AS ContinentName,
	SUM(CAST(c.AreaInSqKm AS DECIMAL (15,0))) AS CountriesArea,
	SUM(CAST(c.Population AS DECIMAL (15,0))) AS CountriesPopulation
FROM Continents con
LEFT JOIN Countries c ON c.ContinentCode = con.ContinentCode
GROUP BY con.ContinentCode, con.ContinentName
ORDER BY SUM(CAST(c.Population AS DECIMAL (15,0))) DESC;

--12

SELECT 
	c.CountryName,
	MAX(p.Elevation) AS HighestPeakElevation,
	MAX(r.Length) AS LongestRiverLength
FROM Countries c
LEFT JOIN MountainsCountries mc ON mc.CountryCode = c.CountryCode
LEFT JOIN Peaks p ON mc.MountainId = p.MountainId
LEFT JOIN CountriesRivers cr ON cr.CountryCode = c.CountryCode
LEFT JOIN Rivers r ON r.Id = cr.RiverId
GROUP BY c.ContinentCode, c.CountryName
ORDER BY MAX(p.Elevation) DESC, MAX(r.Length) DESC, c.CountryName;

--13

SELECT 
	p.PeakName,
	r.RiverName,
	LOWER(p.PeakName + SUBSTRING(r.RiverName, 2, (LEN(r.RiverName) - 1) )) AS Mix
FROM Peaks p, Rivers r
WHERE RIGHT(p.PeakName,1) = LEFT(r.RiverName,1)
ORDER BY p.PeakName + r.RiverName;
	
--14

SELECT 
	c.CountryName AS Country,
	p.PeakName AS [Highest Peak Name],
	p.Elevation AS [Highest Peak Elevation],
	m.MountainRange AS Mountain
FROM Countries c
LEFT JOIN MountainsCountries mc ON mc.CountryCode = c.CountryCode
LEFT JOIN Peaks p ON mc.MountainId = p.MountainId
LEFT JOIN Mountains m on p.MountainId = m.Id
GROUP BY c.CountryCode, c.CountryName
HAVING p.Id = (SELECT 
	Id As PeakID, 
	MAX(Elevation) AS HighestPeak
FROM Peaks)
GROUP BY MAX(Elevation)


SELECT 
	Id As PeakID, 
	MAX(Elevation) AS HighestPeak
FROM Peaks
GROUP BY MountainId, Id

--15

USE [Geography]
CREATE TABLE Monasteries(
	Id int NOT NULL IDENTITY PRIMARY KEY,
	Name nvarchar(50) NOT NULL,
	CountryCode char(2) NOT NULL
)
GO


ALTER TABLE Monasteries ADD CONSTRAINT FK_Monasteries_Countries
FOREIGN KEY(CountryCode) REFERENCES Countries(CountryCode)
GO

INSERT INTO Monasteries(Name, CountryCode) VALUES
('Rila Monastery “St. Ivan of Rila”', 'BG'), 
('Bachkovo Monastery “Virgin Mary”', 'BG'),
('Troyan Monastery “Holy Mother''s Assumption”', 'BG'),
('Kopan Monastery', 'NP'),
('Thrangu Tashi Yangtse Monastery', 'NP'),
('Shechen Tennyi Dargyeling Monastery', 'NP'),
('Benchen Monastery', 'NP'),
('Southern Shaolin Monastery', 'CN'),
('Dabei Monastery', 'CN'),
('Wa Sau Toi', 'CN'),
('Lhunshigyia Monastery', 'CN'),
('Rakya Monastery', 'CN'),
('Monasteries of Meteora', 'GR'),
('The Holy Monastery of Stavronikita', 'GR'),
('Taung Kalat Monastery', 'MM'),
('Pa-Auk Forest Monastery', 'MM'),
('Taktsang Palphug Monastery', 'BT'),
('Sümela Monastery', 'TR')

ALTER TABLE Countries ADD IsDeleted BIT NULL DEFAULT 0
GO

UPDATE Countries
SET IsDeleted = 1
WHERE CountryCode IN (SELECT 
	c.CountryCode
	
FROM Countries c
JOIN CountriesRivers cr ON cr.CountryCode = c.CountryCode
JOIN Rivers r ON r.Id = cr.RiverId
GROUP BY c.CountryCode
HAVING COUNT(r.Id) > 3);


SELECT m.Name AS Monastery,
	c.CountryName AS Country
FROM Monasteries m
JOIN Countries c ON m.CountryCode = c.CountryCode
WHERE c.IsDeleted IS NULL
ORDER BY m.Name


