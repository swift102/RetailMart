
USE RetailMartDB;

-- 1) Helpful composite index for frequent dashboard query
CREATE INDEX IX_OrderDetails_OrderID_ProductID ON rm.OrderDetails(OrderID, ProductID);

-- 2) Example: analyze plan for top customers 
CREATE INDEX IX_Customers_City ON rm.Customers(City);

-- 3) Covering index for Orders date-range filtering
CREATE INDEX IX_Orders_OrderDate_Customer ON rm.Orders(OrderDate, CustomerID) INCLUDE (EmployeeID, City, Region);


-- 4) Use WHERE filters before aggregations
SELECT SUM(Quantity * UnitPrice) AS Revenue
FROM rm.OrderDetails
WHERE Quantity > 0;

-- 5)  Simple ORDER BY optimization
SELECT TOP 10 ProductID, SUM(Quantity) AS TotalSold
FROM rm.OrderDetails
GROUP BY ProductID
ORDER BY TotalSold DESC;