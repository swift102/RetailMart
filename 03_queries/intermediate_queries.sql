USE RetailMartDB;

-- 1) Products Never Sold
-- Business Value: Helps identify inactive inventory items that generate no sales, guiding decisions on promotions or discontinuation.
SELECT 
    p.ProductID, 
    p.ProductName
FROM rm.Products p
LEFT JOIN rm.OrderDetails od ON p.ProductID = od.ProductID
WHERE od.ProductID IS NULL;


-- 2) Customer Distribution by Gender
-- Business Value: Provides insight into gender-based market segmentation for targeted marketing or product development strategies.
SELECT 
    Gender, 
    COUNT(*) AS NumCustomers
FROM rm.Customers
GROUP BY Gender;




-- 3) Total Sales by Category
-- Business Value: Highlights which product categories that drive the most revenue, informing inventory prioritization and pricing.
SELECT 
    p.Category, 
    SUM(od.Quantity * od.UnitPrice) AS CategoryRevenue
FROM rm.OrderDetails od
JOIN rm.Products p ON od.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY CategoryRevenue DESC;


-- 4) Monthly Revenue Trend (Last 12 Months)
-- Business Value: Reveals monthly performance trends to identify seasonality or sales growth over time.
SELECT 
    FORMAT(o.OrderDate, 'yyyy-MM') AS YearMonth,
    SUM(od.Quantity * od.UnitPrice) AS MonthlyRevenue
FROM rm.Orders o
JOIN rm.OrderDetails od ON o.OrderID = od.OrderID
WHERE o.OrderDate >= DATEADD(MONTH, -12, GETDATE())
GROUP BY FORMAT(o.OrderDate, 'yyyy-MM')
ORDER BY YearMonth;


-- 5) Top 5 Customers by Spend
-- Business Value: Identifies high-value customers for loyalty programs or personalized retention campaigns.
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
-- Business Value: Expands customer analysis to top 10 buyers, supporting targeted marketing and customer relationship management.
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
-- Business Value: Measures category contribution to overall sales, helping managers allocate marketing budgets effectively.
SELECT 
    p.Category, 
    SUM(od.Quantity * od.UnitPrice) AS TotalRevenue
FROM rm.Products p
JOIN rm.OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.Category
ORDER BY TotalRevenue DESC;


-- 8) Product Profitability (Revenue − Cost) by Category
-- Business Value: Calculates true profitability across categories, highlighting where margins are strongest or weakest.
SELECT 
    p.Category,
    SUM(od.Quantity * (od.UnitPrice - p.UnitCost)) AS Profit
FROM rm.Products p
JOIN rm.OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.Category
ORDER BY Profit DESC;


-- 9) Employee Sales Leaderboard
-- Business Value: Evaluates employee performance based on total sales volume, useful for incentives or bonuses.
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
-- Business Value: Displays category-wise revenue split, providing a base for understanding product mix performance.
SELECT 
    p.Category, 
    SUM(od.Quantity * od.UnitPrice) AS TotalSales
FROM rm.Products p
JOIN rm.OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.Category
ORDER BY TotalSales DESC;



-- 11) Average Order Value (AOV) by Region
-- Business Value: Measures customer spending behavior by region, revealing regional purchasing power and marketing opportunities.
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
-- Business Value: Shows each category’s share of total revenue, helping identify top contributors for strategic business focus.
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


-- 13) Rank Top 10 Products by Revenue
-- Business Value: Identifies best-selling products, supporting demand forecasting and stock planning.
WITH ProductRevenue AS (
    SELECT p.ProductID, p.ProductName, SUM(od.Quantity * od.UnitPrice) AS Revenue
    FROM rm.Products p
    JOIN rm.OrderDetails od ON p.ProductID = od.ProductID
    GROUP BY p.ProductID, p.ProductName
)
SELECT TOP 10 *, RANK() OVER (ORDER BY Revenue DESC) AS RevenueRank
FROM ProductRevenue
ORDER BY Revenue DESC;


-- 14) Cumulative Monthly Sales
-- Business Value: Tracks sales growth over time, providing cumulative insights for trend and goal monitoring.
WITH Monthly AS (
    SELECT CAST(EOMONTH(o.OrderDate) AS DATE) AS MonthEnd,
           SUM(od.Quantity * od.UnitPrice) AS Revenue
    FROM rm.Orders o
    JOIN rm.OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY CAST(EOMONTH(o.OrderDate) AS DATE)
)
SELECT MonthEnd,
       Revenue,
       SUM(Revenue) OVER (ORDER BY MonthEnd ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CumRevenue
FROM Monthly
ORDER BY MonthEnd;


-- 15) Employee Sales Leaderboard (Ranked)
-- Business Value: Creates ranked view of employee sales performance and recognition of top performers.
WITH EmpSales AS (
    SELECT e.EmployeeID, e.FirstName, e.LastName,
           SUM(od.Quantity * od.UnitPrice) AS Sales
    FROM rm.Employees e
    JOIN rm.Orders o ON e.EmployeeID = o.EmployeeID
    JOIN rm.OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY e.EmployeeID, e.FirstName, e.LastName
)
SELECT *, DENSE_RANK() OVER (ORDER BY Sales DESC) AS SalesRank
FROM EmpSales
ORDER BY Sales DESC;
