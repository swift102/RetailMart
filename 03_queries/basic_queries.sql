
USE RetailMartDB;
-- BASIC QUERIES

-- 1) View all customers
SELECT * 
FROM rm.Customers;

-- 2) Customers in Johannesburg
SELECT FirstName, LastName, City 
FROM rm.Customers 
WHERE City = N'Johannesburg';

-- 3) Find products above R300
SELECT ProductName, Category, UnitPrice 
FROM rm.Products 
WHERE UnitPrice > 300
ORDER BY UnitPrice DESC;

-- 4) Orders with customer names (latest 10)
SELECT TOP 10 o.OrderID, o.OrderDate, c.FirstName, c.LastName, o.City
FROM rm.Orders o
JOIN rm.Customers c ON o.CustomerID = c.CustomerID
ORDER BY o.OrderDate DESC;

-- 5) Count total orders
SELECT COUNT(*) AS TotalOrders FROM rm.Orders;

-- 6) Distinct cities we sell in
SELECT DISTINCT City FROM rm.Orders ORDER BY City;

-- 7) Find a customer by email (example)
SELECT * FROM rm.Customers WHERE Email LIKE '%example.com';
