-- Tommy Tight 
-- Data Management 
-- SQL Assignment 2

USE AdventureWorks2014

-- Problem 1 Part A
SELECT      Name, ROUND(SUM(SubTotal), 0) AS 'Revenue'
FROM        Sales.SalesOrderHeader  SOH
INNER JOIN  Sales.SalesTerritory    ST
ON          SOH.TerritoryID = ST.TerritoryID     
GROUP BY    Name
ORDER BY    ROUND(SUM(SubTotal), 0) DESC

-- Problem 1 Part B
SELECT      Name, 
            (DATEPART(MM, OrderDate)) AS 'Order Month', 
            (DATEPART(YY, OrderDate)) AS 'Order Year', 
            ROUND(SUM(SubTotal), 0) AS 'Revenue'
FROM        Sales.SalesOrderHeader  SOH
INNER JOIN  Sales.SalesTerritory    ST
ON          SOH.TerritoryID = ST.TerritoryID
WHERE       DATEPART(YY, OrderDate) = 2013     
GROUP BY    Name, DATEPART(MM, OrderDate), DATEPART(YY, OrderDate)
ORDER BY    Name, DATEPART(MM, OrderDate)

-- Problem 1 Part C 

SELECT      DISTINCT Name AS 'AwardWinners'
FROM        Sales.SalesOrderHeader SOH
INNER JOIN  Sales.SalesTerritory ST
ON          SOH.TerritoryID = ST.TerritoryID
GROUP BY    Name, DATEPART(YY, OrderDate), DATEPART(MM, OrderDate)
HAVING      DATEPART(YY, OrderDate) = 2013 AND ROUND(SUM(SubTotal),0) > 750000
ORDER BY    Name

-- Problem 1 Part D

SELECT      Name AS 'TrainingTerritories'
FROM        Sales.SalesTerritory
EXCEPT
SELECT      DISTINCT Name 
FROM        Sales.SalesOrderHeader SOH
INNER JOIN  Sales.SalesTerritory ST
ON          SOH.TerritoryID = ST.TerritoryID
GROUP BY    Name, DATEPART(YY, OrderDate), DATEPART(MM, OrderDate)
HAVING      DATEPART(YY, OrderDate) = 2013 AND ROUND(SUM(SubTotal),0) > 750000
ORDER BY    Name

-- Problem 2 Part A 
SELECT      P.Name, SUM(OrderQty) AS 'Quantity'
FROM        Production.Product P
INNER JOIN  Sales.SalesOrderDetail SOD
ON          P.ProductID = SOD.ProductID
WHERE       P.FinishedGoodsFlag = 1
GROUP BY    P.Name
HAVING      SUM(OrderQty) < 50
ORDER BY    SUM(OrderQty) DESC


-- Problem 2 Part B
SELECT      CR.Name, MAX(TaxRate) AS 'MaxTaxRate'
FROM        Sales.SalesTaxRate STR
INNER JOIN  Person.StateProvince SP
ON          STR.StateProvinceID = SP.StateProvinceID
INNER JOIN  Person.CountryRegion CR
ON          SP.CountryRegionCode = CR.CountryRegionCode
GROUP BY    CR.Name
ORDER BY    MAX(TaxRate) DESC

-- Problem 2 Part C
SELECT      DISTINCT S.Name AS 'StoreName', ST.Name AS 'TerritoryName'
FROM        Sales.SalesOrderHeader SOH
INNER JOIN  Sales.SalesOrderDetail SOD
ON          SOH.SalesOrderID = SOD.SalesOrderID
INNER JOIN  Production.Product P
ON          SOD.ProductID = P.ProductID
INNER JOIN  Sales.Customer C
ON          SOH.CustomerID = C.CustomerID          
INNER JOIN  Sales.Store S
ON          C.StoreID = S.BusinessEntityID          
INNER JOIN  Sales.SalesTerritory ST
ON          C.TerritoryID = ST.TerritoryID
WHERE       P.Name LIKE '%HELMET%' AND 
            DATEPART(YY, ShipDate) = 2014 AND 
            DATEPART(MM, ShipDate) = 2 AND 
            DATEPART(DD, ShipDate) < 6
ORDER BY    ST.Name, S.Name
