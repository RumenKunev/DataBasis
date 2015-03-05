--Problem 1.

--Create a database with two tables
--Persons (id (PK), first name, last name, SSN) and Accounts (id (PK), person id (FK), balance). Insert few records for testing. 
--Write a stored procedure that selects the full names of all persons.

CREATE DATABASE [Clients]
GO

USE Clients
GO

CREATE TABLE Persons(
	ID int IDENTITY PRIMARY KEY(ID) NOT NULL,
	FirstName nvarchar(30) NOT NULL,
	LastName nvarchar(30) NOT NULL,
	SSN nvarchar(30) NULL
);
GO

CREATE TABLE Accounts(
	ID int IDENTITY PRIMARY KEY(ID) NOT NULL,
	PersonID int FOREIGN KEY REFERENCES Persons(ID) NOT NULL,
	Balance MONEY NULL
);
GO

INSERT INTO Persons (FirstName, LastName, SSN)
	VALUES ('Peter', 'Petrov', '8801011263')
INSERT INTO Persons (FirstName, LastName, SSN)
	VALUES ('Georgi', 'Georgiev', '8602021591')
INSERT INTO Persons (FirstName, LastName, SSN)
	VALUES ('Todor', 'Todorov', '8104119601')

INSERT INTO Accounts (PersonID, Balance)
	VALUES (1, 3654.125)
INSERT INTO Accounts (PersonID, Balance)
	VALUES (1, 12.125)
INSERT INTO Accounts (PersonID, Balance)
	VALUES (2, 8994.125)
INSERT INTO Accounts (PersonID, Balance)
	VALUES (2, 11125.125)
INSERT INTO Accounts (PersonID, Balance)
	VALUES (3, 6666589.125)

GO

CREATE PROC usp_GetUsersFullname
AS
	SELECT (FirstName + ' ' + LastName) AS [Full Name]
	FROM Persons
GO

EXEC usp_GetUsersFullname;

--Problem 2.
-- Your task is to create a stored procedure that accepts a number as a parameter and returns all persons who have
-- more money in their accounts than the supplied number.

USE Clients
GO

CREATE PROC usp_GetPersonsByBankBalanceMoreThan (@accountBalance money)
AS
	SELECT p.FirstName, p.LastName, a.Balance
	FROM Persons p
		JOIN Accounts a ON p.ID = a.PersonID
	WHERE a.Balance > @accountBalance;
GO

EXEC usp_GetPersonsByBankBalanceMoreThan 8000;
GO

--
--CREATE PROC usp_SelectAllPersonsByMoneyMoreOf(@minMoney money)
--AS
--SELECT
--	FirstName + ' ' + LastName AS [Full Name],
--	SUM(a.Balance) AS Sum
--FROM Persons p
--	JOIN Accounts a
--		ON a.PersonId = p.Id
--GROUP BY	a.PersonId,
--			FirstName,
--			LastName
--HAVING SUM(a.Balance) >= @minMoney
--GO
--
--EXEC usp_SelectAllPersonsByMoneyMoreOf 7000


--Problem 3.
-- Your task is to create a function that accepts as parameters – sum, yearly interest rate and number of months.
-- It should calculate and return the new sum. Write a SELECT to test whether the function works as expected.

USE Clients
GO

CREATE FUNCTION ufn_CalculateInterestAmount (@amount money, @interestRate float, @months int) RETURNS money
AS
BEGIN
	DECLARE @sum money;
	SET @sum = @amount + (@amount * (@interestRate / 100) * (@months / 12))
	RETURN @sum;
END

SELECT FirstName + ' ' + LastName AS [Full Name],
	dbo.ufn_CalculateInterestAmount(a.Balance, 20, 55) AS FutureAmount
FROM Persons p
	JOIN Accounts a ON a.PersonId = p.Id;


--Problem 4. 
--Create a stored procedure that uses the function from the previous example.
--Your task is to create a stored procedure that uses the function from the previous example to 
--give an interest to a person's account for one month. It should take the AccountId and the interest rate as parameters.

USE Clients
GO

CREATE PROC usp_CalculateMonthlyInterest(@accountID int, @interestRate FLOAT)
AS
	SELECT 
		ID, 
		Balance, 
		dbo.ufn_CalculateInterestAmount(Balance,@interestRate,1) - Balance AS [Monthly Interest]
	FROM Accounts
	WHERE ID = @accountID
GO

EXEC usp_CalculateMonthlyInterest 1, 4


-- Problem 5.	Add two more stored procedures WithdrawMoney and DepositMoney.

CREATE PROC usp_DepositMoney (@accountId INT, @money MONEY)
AS
	BEGIN TRAN
	DECLARE @currentBalance MONEY = 
		(SELECT a.Balance
		FROM Accounts a
		WHERE a.ID = @accountId)

	UPDATE Accounts SET Balance = @currentBalance + @money
	WHERE ID = @accountId

	IF ((SELECT a.Balance
		FROM Accounts a
		WHERE a.ID = @accountId)
		= @currentBalance + @money)
	BEGIN
			COMMIT TRAN
	END
	 
	ELSE
	BEGIN
		ROLLBACK TRAN
	END
GO

CREATE PROC usp_WithdrawMoney (@accountId  int, @money money)
AS
	DECLARE @oldSum money
	SELECT 	@oldSum = Balance
	FROM Accounts
	WHERE ID = @accountId

	IF (@money < 0) 
		BEGIN
			RAISERROR ('The amount must be positive.', 16, 1)
		END

	IF (@money > @oldSum) 
		BEGIN
			RAISERROR ('the amount should be less than the balance.', 16, 1)
		END

	UPDATE Accounts
	SET Balance = (Balance - @money)
	WHERE ID = @accountId
GO


-- Problem 6.	Create table Logs.
USE [Clients]
GO

CREATE TABLE Logs(
	LogId int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	AccountId int NOT NULL,
	OldValue money NULL,
	NewValue money NULL)

GO

CREATE TRIGGER tr_BankAccountsChange ON Accounts
FOR UPDATE
AS
INSERT INTO dbo.Logs (AccountId, NewValue, OldValue)
	SELECT
		d.ID,
		i.Balance,
		d.Balance
	FROM INSERTED i
		JOIN DELETED d
			ON d.ID = i.ID
GO

UPDATE Accounts SET Balance = 10000
WHERE ID = 1;


-- Problem 7.	Define function in the SoftUni database.
use SoftUni

GO
CREATE FUNCTION ufn_chechWord(@string nvarchar(100), @word nvarchar(100)) RETURNS INT
	BEGIN
		DECLARE  @char nvarchar(1)

		DECLARE @wcount int, @index int, @len int
		SET @wcount= 0
		SET @index = 1
		SET @len= LEN(@word)
	
		WHILE @index <= @len
		BEGIN
			set @char = SUBSTRING(@word, @index, 1)

			if CHARINDEX(@char, @string) = 0
				BEGIN
					RETURN 0
				END

			SET @index= @index+ 1
		END

		RETURN 1
	END
GO

DECLARE empCursor CURSOR READ_ONLY FOR
	(SELECT e.FirstName, e.LastName, t.Name
	FROM Employees e
		JOIN Addresses a
			ON a.AddressID = e.AddressID
		JOIN Towns t
			ON t.TownID = a.TownID)

OPEN empCursor
DECLARE @firstName char(50), @lastName char(50), @town char(50), @string char(50)
FETCH NEXT FROM empCursor INTO @firstName, @lastName, @town

SET @string = 'isofagrek'

WHILE @@FETCH_STATUS = 0
  BEGIN
    FETCH NEXT FROM empCursor INTO @firstName, @lastName, @town
	IF dbo.ufn_chechWord(@string, @firstName) = 1
		BEGIN
			print @firstName
		END	
	IF dbo.ufn_chechWord(@string, @lastName) = 1
		BEGIN
			print @lastName
		END	
	IF dbo.ufn_chechWord(@string, @town) = 1
		BEGIN
			print @town
		END	
  END

CLOSE empCursor
DEALLOCATE empCursor