-- Who are the top 10 customers by sales volume?
SELECT 
    cs.FirstName, 
    cs.LastName, 
	COUNT(sa.SalesID) FrequencyBuy,
    ROUND(SUM(
        CAST(sa.TotalPrice AS DECIMAL(18,2)) 
        * CAST(sa.Quantity AS INT) 
        * (1 - CAST(sa.Discount AS DECIMAL(5,4)))
    ), 2) AS SumSales
FROM customers AS cs
LEFT JOIN sales AS sa ON cs.CustomerID = sa.CustomerID
GROUP BY cs.FirstName, cs.LastName
ORDER BY SumSales  DESC;

-- Can we identify any customer segments based on purchasing behavior?
SELECT c.CustomerID, COUNT(s.SalesID) AS PurchaseFrequency,
    ROUND(SUM(s.TotalPrice),2) AS TotalSpent, ROUND(AVG(s.TotalPrice), 2) AS AveragePurchaseValue,
    MAX(s.SalesDate) AS LastPurchaseDate,
CASE
    WHEN SUM(s.TotalPrice) > 200 THEN 'High Spender'
    WHEN SUM(s.TotalPrice) > 100 THEN 'Medium Spender'
ELSE 'Low Spender'
END AS SpendingCategory,
CASE
    WHEN COUNT(s.SalesID) > 10 THEN 'Frequent Buyer'
    WHEN COUNT(s.SalesID) BETWEEN 5 AND 10 THEN 'Occasional Buyer'
ELSE 'Infrequent Buyer'
END AS FrequencyCategory
    FROM sales AS s
    JOIN customers AS c 
    ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerID
ORDER BY TotalSpent DESC, PurchaseFrequency DESC;

-- What is the Purchase Size (number of items and total price) by customers from each city or country
SELECT 
    sa.CustomerID,  
	COUNT(Quantity) AS NumberofItems, 
	SUM(TotalPrice) AS SumofPrice,
	CityName,
	CountryName,
CASE
    WHEN SUM(sa.TotalPrice) > 100 THEN 'Frequent Buyer'
    WHEN SUM(sa.TotalPrice) >= 50 THEN 'Occasional Buyer'
ELSE 'Infrequent Buyer'
END AS NumberOfSales
FROM sales AS sa
    INNER JOIN customers AS cs
	ON SA.CustomerID = cs.CustomerID
	JOIN cities AS ct 
	ON cs.CityID = ct.CityID 
	JOIN countries co
	ON ct.CityID = co.CountryID
GROUP BY sa.CustomerID, co.CountryName, ct.CityName
ORDER BY SumofPrice DESC

-- What are the purchasing patterns of customers from different cities or countries?
SELECT TOP 25
      ct.CityName,
      co.CountryName,
      COUNT(sa.SalesID) AS NumberOfPurchases
FROM customers AS c
      INNER JOIN cities AS ct 
      ON c.CityID = ct.CityID
      INNER JOIN countries AS co 
      ON ct.CountryID = co.CountryID
      INNER JOIN sales AS sa 
      ON c.CustomerID = sa.CustomerID
GROUP BY 
      ct.CityName, co.CountryName
ORDER BY 
      NumberOfPurchases DESC

-- What is the average number of transactions per customer?
SELECT 
     AVG(TransactionCount) AS NumberofSales
FROM
(
    SELECT 
        customerID,
        COUNT(*) AS TransactionCount
    FROM sales
    GROUP BY customerID
) AS TransactionbyCustomer

--ALTERNATE

SELECT 
     ROUND(AVG(TransactionCount), 2) AS NumberOfSales
FROM
(
    SELECT 
        customerID,
        COUNT(*) AS TransactionCount
    FROM sales
    GROUP BY customerID
    HAVING COUNT(*) > 1
) AS TransactionByCustomer;

-- Extract seasonal trends in purchasing by customers in different city or country
SELECT TOP 5
     sa.CustomerID,
     ct.CityName,
     co.CountryName,
     MONTH(TRY_CAST(sa.SalesDate AS DATE)) AS SaleMonth,
     SUM(sa.TotalPrice) AS TotalSales
FROM
     sales AS sa
     INNER JOIN customers AS cu ON sa.CustomerID = cu.CustomerID
     INNER JOIN cities AS ct ON cu.CityID = ct.CityID
     INNER JOIN countries AS co ON ct.CountryID = co.CountryID
WHERE
     TRY_CAST(sa.SalesDate AS DATE) IS NOT NULL
GROUP BY
     sa.CustomerID, ct.CityName, co.CountryName,
     MONTH(TRY_CAST(sa.SalesDate AS DATE))
ORDER BY
     TotalSales DESC;

--ALTERNATE

SELECT TOP 5
   sa.CustomerID,
   ci.CityName,
   co.CountryName,
   MONTH(TRY_CAST(sa.SalesDate AS DATE)) AS SaleMonth,
   ROUND(SUM(sa.TotalPrice), 2) AS TotalSales
 FROM
   sales AS sa
   JOIN customers AS c ON sa.CustomerID = c.CustomerID
   JOIN cities AS ci ON c.CityID = ci.CityID
   JOIN .countries AS co ON ci.CountryID = co.CountryID
 GROUP BY sa.CustomerID, ci.CityName, co.CountryName,
   MONTH(TRY_CAST(sa.SalesDate AS DATE))
 ORDER BY TotalSales DESC;

