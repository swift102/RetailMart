-- RetailMart SCHEMA CREATION

IF DB_ID('RetailMartDB') IS NULL
BEGIN
    CREATE DATABASE RetailMartDB;
END
GO

USE RetailMartDB;
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'rm')
BEGIN
    EXEC('CREATE SCHEMA rm');
END
GO

-- Drop existing tables (for dev re-runs)
IF OBJECT_ID('rm.OrderDetails', 'U') IS NOT NULL DROP TABLE rm.OrderDetails;
IF OBJECT_ID('rm.Orders', 'U') IS NOT NULL DROP TABLE rm.Orders;
IF OBJECT_ID('rm.Products', 'U') IS NOT NULL DROP TABLE rm.Products;
IF OBJECT_ID('rm.Customers', 'U') IS NOT NULL DROP TABLE rm.Customers;
IF OBJECT_ID('rm.Employees', 'U') IS NOT NULL DROP TABLE rm.Employees;
GO

CREATE TABLE rm.Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName  NVARCHAR(50) NOT NULL,
    LastName   NVARCHAR(50) NOT NULL,
    Gender     NVARCHAR(10) NULL,
    Email      NVARCHAR(100) NULL UNIQUE,
    Phone      NVARCHAR(30) NULL,
    City       NVARCHAR(60) NOT NULL,
    Country    NVARCHAR(60) NOT NULL,
    JoinDate   DATE NOT NULL DEFAULT (GETDATE())
);
GO

CREATE TABLE rm.Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName  NVARCHAR(50) NOT NULL,
    LastName   NVARCHAR(50) NOT NULL,
    Region     NVARCHAR(60) NOT NULL,
    HireDate   DATE NOT NULL DEFAULT (GETDATE())
);
GO

CREATE TABLE rm.Products (
    ProductID   INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    Category    NVARCHAR(60) NOT NULL,
    UnitPrice   DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0),
    UnitCost    DECIMAL(10,2) NOT NULL CHECK (UnitCost >= 0),
    IsActive    BIT NOT NULL DEFAULT(1)
);
GO

CREATE TABLE rm.Orders (
    OrderID     INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID  INT NOT NULL,
    EmployeeID  INT NOT NULL,
    OrderDate   DATETIME NOT NULL DEFAULT(GETDATE()),
    City        NVARCHAR(60) NOT NULL,
    Region      NVARCHAR(60) NOT NULL,
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID) REFERENCES rm.Customers(CustomerID),
    CONSTRAINT FK_Orders_Employees FOREIGN KEY (EmployeeID) REFERENCES rm.Employees(EmployeeID)
);
GO

CREATE TABLE rm.OrderDetails (
    OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID   INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity  INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0),
    CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (OrderID) REFERENCES rm.Orders(OrderID) ON DELETE CASCADE,
    CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (ProductID) REFERENCES rm.Products(ProductID)
);
GO

-- Indexes
CREATE INDEX IX_Orders_OrderDate ON rm.Orders(OrderDate);
CREATE INDEX IX_OrderDetails_OrderID ON rm.OrderDetails(OrderID);
CREATE INDEX IX_OrderDetails_ProductID ON rm.OrderDetails(ProductID);
CREATE INDEX IX_Customers_City ON rm.Customers(City);
GO

-- View for total order amounts 
CREATE VIEW rm.vw_OrderTotals AS
SELECT 
    o.OrderID,
    SUM(od.Quantity * od.UnitPrice) AS TotalAmount
FROM rm.Orders o
JOIN rm.OrderDetails od ON o.OrderID = od.OrderID
GROUP BY o.OrderID;
GO


