--Updating Tables
Update sales
  set TotalPrice = Price
   from sales sa
     left join products pr
on sa.ProductID = pr.ProductID

-- Total Sales/Profit by Product
SELECT 
      pro.ProductName, 
	  ROUND(SUM((Price*Quantity)*(1-discount)), 2) TotalSales
FROM  products pro
      LEFT JOIN sales Sa
	  ON pro.ProductID = sa.ProductID
GROUP BY 
      pro.ProductName
ORDER BY TotalSales desc

-- Total Profits
SELECT 
      ROUND(SUM((Price*Quantity)*(1-discount)), 2) TotalProfit
FROM products pro
      LEFT JOIN sales Sa
	  ON pro.ProductID = sa.ProductID
ORDER BY 
      TotalProfit desc

-- Which product has the highest sales volume?
SELECT TOP 10 
       pro.ProductName, round(sum(Quantity),2) As TotalSales
FROM   products as pro
       LEFT JOIN sales Sa
	   ON pro.ProductID = sa.ProductID
GROUP BY 
	   pro.ProductName
ORDER BY TotalSales desc;

-- What is the average discount applied to sales transactions?
SELECT 
      AVG(discount) as AverageDiscount
FROM sales

-- How does the discount level affect the total sales volume?
SELECT 
	  ROUND(SUM(Quantity*Price), 4) as TotalQuantity, 
	  ROUND(SUM((Quantity*Price)*(1-discount)),4) as Price
FROM products pro
      LEFT JOIN sales Sa
	  ON pro.ProductID = sa.ProductID
GROUP BY 
	   Discount
ORDER BY Discount

-- Which salesperson has the highest number of sales?
SELECT 
        em.FirstName,
        em.LastName,
	    COUNT(Quantity) as TotalQuantitySales
FROM  employees em
	    LEFT JOIN sales sa
	    ON em.EmployeeID = sa.SalesPersonID
GROUP BY 
        em.EmployeeID, 
	    em.FirstName, 
	    em.LastName
ORDER BY TotalQuantitySales desc;

-- Which city has the highest purchase volume?
SELECT 
      CityName, 
	  SUM(sa.quantity) TotalPurchase
FROM cities ct
	  INNER JOIN employees  em
	  ON ct.CityID = em.CityID
	  INNER JOIN sales  sa
	  ON em.EmployeeID = sa.SalesPersonID
GROUP BY CityName
ORDER BY TotalPurchase  desc

-- Average Sale Amount: Top 20 markets by average sale amount
SELECT TOP 20  
      pr.ProductName, 
	  AVG(TotalPrice) as AvergageCostPrice
FROM products as pr
      LEFT JOIN sales as sa
      ON pr.ProductID = sa.ProductID
WHERE TotalPrice is not null
GROUP BY 
      pr.ProductName
ORDER BY AvergageCostPrice desc

--Product with the Highest sales by Month and Year 
SELECT TOP 10
      ProductName,
	  COUNT(sa.salesID)  AS NumberofSales,
	  MONTH(TRY_CAST(sa.SalesDate AS DATE)) AS SaleMonth,
	  YEAR(TRY_CAST(sa.SalesDate AS DATE)) AS SaleMonth
FROM products as pr
      INNER JOIN sales as sa
      ON pr.ProductID = sa.ProductID
GROUP BY pr.ProductName,
	  MONTH(TRY_CAST(sa.SalesDate AS DATE)),
	  YEAR(TRY_CAST(sa.SalesDate AS DATE)); 