USE RetailMartDB;
-- BUSINESS INSIGHTS (Used for creating dashboards)

-- KPI 1: Total Revenue, Total Orders, Avg Order Value
SELECT 
    SUM(TotalAmount) AS TotalRevenue,
    COUNT(OrderID) AS TotalOrders,
    ROUND(AVG(TotalAmount), 2) AS AvgOrderValue
FROM rm.vw_OrderTotals;


-- KPI 2: Revenue by Category & Month (pivot-friendly)
SELECT
    FORMAT(o.OrderDate, 'yyyy-MM') AS YearMonth,
    p.Category,
    SUM(od.Quantity * od.UnitPrice) AS Revenue
FROM rm.Orders o
JOIN rm.OrderDetails od ON o.OrderID = od.OrderID
JOIN rm.Products p ON od.ProductID = p.ProductID
GROUP BY FORMAT(o.OrderDate, 'yyyy-MM'), p.Category
ORDER BY YearMonth, Category;

-- KPI 3: Top 10 Customers (Name, City, Spend)
SELECT TOP 10
    c.FirstName + ' ' + c.LastName AS CustomerName,
    c.City,
    SUM(od.Quantity * od.UnitPrice) AS Spend
FROM rm.Customers c
JOIN rm.Orders o ON c.CustomerID = o.CustomerID
JOIN rm.OrderDetails od ON o.OrderID = od.OrderID
GROUP BY c.FirstName, c.LastName, c.City
ORDER BY Spend DESC;

-- KPI 4: Region Performance
SELECT o.Region, SUM(od.Quantity * od.UnitPrice) AS Revenue
FROM rm.Orders o
JOIN rm.OrderDetails od ON o.OrderID = od.OrderID
GROUP BY o.Region
ORDER BY Revenue DESC;
