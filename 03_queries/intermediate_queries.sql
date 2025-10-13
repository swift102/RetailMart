USE RetailMartDB;

-- 1) Products Never Sold
SELECT 
    p.ProductID, 
    p.ProductName
FROM rm.Products p
LEFT JOIN rm.OrderDetails od ON p.ProductID = od.ProductID
WHERE od.ProductID IS NULL;

-- 2) Customer Distribution by Gender
SELECT 
    Gender, 
    COUNT(*) AS NumCustomers
FROM rm.Customers
GROUP BY Gender;


-- 3) Total Sales by Category
SELECT 
    p.Category, 
    SUM(od.Quantity * od.UnitPrice) AS CategoryRevenue
FROM rm.OrderDetails od
JOIN rm.Products p ON od.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY CategoryRevenue DESC;


-- 4) Monthly Revenue Trend (Last 12 Months)
SELECT 
    FORMAT(o.OrderDate, 'yyyy-MM') AS YearMonth,
    SUM(od.Quantity * od.UnitPrice) AS MonthlyRevenue
FROM rm.Orders o
JOIN rm.OrderDetails od ON o.OrderID = od.OrderID
WHERE o.OrderDate >= DATEADD(MONTH, -12, GETDATE())
GROUP BY FORMAT(o.OrderDate, 'yyyy-MM')
ORDER BY YearMonth;


-- 5) Top 5 Customers by Spend
SELECT TOP 5 
    c.CustomerID, 
    c.FirstName, 
    c.LastName,
    SUM(od.Quantity * od.UnitPrice) AS TotalSpend
FROM rm.Customers c
JOIN rm.Orders o ON c.CustomerID = o.CustomerID
JOIN rm.OrderDetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY TotalSpend DESC;


-- 6) Top 10 Customers by Total Spend
SELECT TOP 10 
    c.CustomerID, 
    c.FirstName, 
    c.LastName,
    SUM(od.Quantity * od.UnitPrice) AS TotalSpend
FROM rm.Customers c
JOIN rm.Orders o ON c.CustomerID = o.CustomerID
JOIN rm.OrderDetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY TotalSpend DESC;


-- 7) Total Revenue by Product Category
SELECT 
    p.Category, 
    SUM(od.Quantity * od.UnitPrice) AS TotalRevenue
FROM rm.Products p
JOIN rm.OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.Category
ORDER BY TotalRevenue DESC;


-- 8) Product Profitability (Revenue − Cost) by Category
-- Highlights profit margins per category
SELECT 
    p.Category,
    SUM(od.Quantity * (od.UnitPrice - p.UnitCost)) AS Profit
FROM rm.Products p
JOIN rm.OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.Category
ORDER BY Profit DESC;


-- 9) Employee Sales Leaderboard
-- Measures the total sales volume handled by each employee
SELECT 
    e.EmployeeID, 
    e.FirstName, 
    e.LastName,
    SUM(od.Quantity * od.UnitPrice) AS SalesVolume
FROM rm.Employees e
JOIN rm.Orders o ON e.EmployeeID = o.EmployeeID
JOIN rm.OrderDetails od ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY SalesVolume DESC;


-- 10) Revenue Contribution by Category
-- Displays total sales per category (used to compute percentages later)
SELECT 
    p.Category, 
    SUM(od.Quantity * od.UnitPrice) AS TotalSales
FROM rm.Products p
JOIN rm.OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.Category
ORDER BY TotalSales DESC;


-- 11) Average Order Value (AOV) by Region
-- Calculates average total order amount per region using a CTE
WITH OrderTotals AS (
    SELECT 
        o.OrderID,
        o.Region,
        SUM(od.Quantity * od.UnitPrice) AS OrderTotal
    FROM rm.Orders o
    JOIN rm.OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY o.OrderID, o.Region
)
SELECT 
    Region,
    ROUND(AVG(OrderTotal), 2) AS AvgOrderValue
FROM OrderTotals
GROUP BY Region
ORDER BY AvgOrderValue DESC;


-- 12) Revenue Contribution Percentage by Category
-- Calculates how much each category contributes to total revenue
SELECT 
    p.Category,
    ROUND(
        (SUM(od.Quantity * od.UnitPrice) * 100.0) /
        SUM(SUM(od.Quantity * od.UnitPrice)) OVER(),
    2) AS SalesPercentage
FROM rm.Products p
JOIN rm.OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.Category
ORDER BY SalesPercentage DESC;
