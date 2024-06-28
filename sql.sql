
create database Emp_Tra
use Emp_Tra

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DOB DATE,
    Email VARCHAR(100),
    Phone VARCHAR(15)
);

CREATE TABLE Account_Types (
    AccountTypeID INT PRIMARY KEY,
    AccountTypeName VARCHAR(50)
);

CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY,
    CustomerID INT,
    AccountTypeID INT,
    Balance DECIMAL(15, 2),
    DateOpened DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (AccountTypeID) REFERENCES Account_Types(AccountTypeID)
);

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    AccountID INT,
    TransactionDate DATE,
    TransactionType VARCHAR(10),
    Amount DECIMAL(15, 2),
    Description VARCHAR(255),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

-- 1. List All Customers with Their Account Balances
SELECT c.CustomerID, c.FirstName, c.LastName, a.AccountID, a.Balance
FROM Customers c
JOIN Accounts a ON c.CustomerID = a.CustomerID
ORDER BY c.CustomerID;

-- 2. Total Balance for Each Customer
SELECT c.CustomerID, c.FirstName, c.LastName, SUM(a.Balance) AS TotalBalance
FROM Customers c
JOIN Accounts a ON c.CustomerID = a.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY TotalBalance DESC;

-- 3> Transaction Details for a Specific Account
SELECT t.TransactionID, t.AccountID, t.TransactionDate, t.TransactionType, t.Amount, t.Description
FROM Transactions t
WHERE t.AccountID = 1;

-- 4>Average Account Balance by Account Type:
SELECT at.AccountTypeName, AVG(a.Balance) AS AverageBalance
FROM Accounts a
JOIN Account_Types at ON a.AccountTypeID = at.AccountTypeID
GROUP BY at.AccountTypeName;

-- 5>Customers with No Transactions
SELECT c.CustomerID, c.FirstName, c.LastName FROM Customers c
LEFT JOIN Accounts a ON c.CustomerID = a.CustomerID 
LEFT JOIN Transactions t ON a.AccountID = t.AccountID
WHERE t.TransactionID IS NULL;

-- 6>Creating a View for Customer Account Balances
CREATE VIEW CustomerAccountBalances AS
SELECT c.CustomerID, c.FirstName, c.LastName, a.AccountID, a.Balance
FROM Customers c
JOIN Accounts a ON c.CustomerID = a.CustomerID;

SELECT * FROM CustomerAccountBalances ORDER BY Balance DESC;

-- 7> Common Table Expression (CTE) for Customer Total Balance
  WITH CustomerBalances AS (
    SELECT c.CustomerID, c.FirstName, c.LastName, SUM(a.Balance) AS TotalBalance
    FROM Customers c
    JOIN Accounts a ON c.CustomerID = a.CustomerID
    GROUP BY c.CustomerID, c.FirstName, c.LastName
)
SELECT * FROM CustomerBalances ORDER BY TotalBalance DESC;







