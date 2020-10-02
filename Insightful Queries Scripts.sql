--Names: 
-- Teh Huan Xi Kester (P1922897)
-- Alwinderjit Singh Basant (P1935996)
-- Jason Lou (P1837902)
-- Wong En Ting Kelyn (P1935800)
-- Team: Team OkBoomer
-- Class: DIT/FT/2B/21
-- Insightful queries.

use CarSalesOkBoomerDW;

-- |Sales|
-- 1. List the least profitable product and order by the office that contributed to the most loss. Show each offices’ loss percentage in relation to the total loss.
-- Reasoning: 
-- Allows the business owner to identify the least profitable product and the offices related to the loss 
-- so that necessary action (Such as prioritising the importation of stock) can be made towards changing it.
--
-- Question:
-- List the least profitable product and order by the office that contributed to the most loss. 
-- 1. What is the product that produced the most loss?
-- 2. Which is the office of said product that contributed most to that loss?
--
-- Query 1:
Select *, data.Difference/data.Loss * 100 as 'Difference % of Loss' from
(
-- First Query
SELECT productName, priceEach, buyPrice,buyPrice-priceEach as 'Difference', SUM(buyPrice - priceEach) OVER(PARTITION BY productName) 
AS Loss, O.officeCode, O.city
FROM SalesFacts S
INNER JOIN ProductsDIM P ON S.ProductSK = P.ProductSK
INNER JOIN OfficesDIM O on S.OfficesSK = O.OfficesSK
WHERE priceEach < buyPrice 
--
) as data order by Loss desc, 8 desc

-- |Staff/Offices|
-- 2. Best performing office based on total sales during a defined period. (Between 2003 and 2004)
-- Can also be used in where clause: WHERE T.Quarter = 4
--
-- Reasoning:
-- Allows the business owner to identify offices that done well during a 
-- specified period by descending order of total revenue earned. 
--
-- Question:
-- 1. What is the best performing office in terms of total sales between 2003 and 2004?

select O.officeCode, O.city, COUNT(S.orderNumber) as 'No. of orders', ROUND(SUM(S.quantityOrdered*S.priceEach),2) as 'Total Revenue'
from SalesFacts S 
inner join OfficesDIM O on O.OfficesSK = S.OfficesSK
inner join TimeDIM T on T.Timekey = S.orderDate
WHERE T.Year >= '2003' AND T.Year <= '2004' -- Date Where Clauses.
group by O.officeCode, O.city
order by 4 desc;

-- |Seasons of Sales|
-- 3. Give the percentage of orderStatus(shipped, cancelled, disputed, inprocess, resolved, on hold) 
--    over total orders over the 4 quarters of each year.
-- Reasoning:
-- Allows the business owner to see which order makes up the most percentage in a certain quarter to
-- uncover weak points in the business in the business delivery system.
-- 
-- Question:
-- 1. What is the percentage of each orderStatus type over the 4 quarters of the year?

----- Final Select
SELECT *, ROUND((CAST(TheFinalData.[Orders Count] AS FLOAT) / CAST(TheFinalData.[Total Orders] AS FLOAT)) * 100, 4) 'Percentage' FROM
(
---- Third Select (Get total count of orders)
SELECT *, SUM(FinalData.[Orders Count]) OVER() 'Total Orders' FROM
(
--- Second Select (Get count of orders in quarter)
SELECT Count(Data.orderNumber) 'Orders Count', Data.orderStatus, Data.Quarter 
FROM
(
-- First Select (Get Basic Data)
select orderNumber, orderStatus, TimeDIM.Quarter from SalesFacts
inner join TimeDIM ON TimeDIM.TimeKey = SalesFacts.orderDate
group by orderNumber, orderStatus, TimeDIM.Quarter
--
) AS Data GROUP BY Data.OrderStatus, Data.Quarter
---
) AS FinalData
----
) AS TheFinalData;
-----


-- |Orders/Customer|
-- 4. Compute the money spent by each customer based on their orders. 
--	  Also, show each customer's spending as a percentage of total spending by all customers. 
--    Sort by percentage spent.
--
-- Reasoning:
-- To analyse who are their frequent customers so as to better address their needs.--
--
-- Questions:
-- 1. Who is the customer who spent the most.
-- 2. What is the percentage of the total revenue of this customer.

--- Secondary Select
SELECT *, (SpendingData.[Customer Spent] / SpendingData.[Total Spent]) *100 'Percentange Spent' FROM
(
-- First Select
SELECT CustomersDIM.customerNumber, ROUND(SUM(quantityOrdered * priceEach), 2) 'Customer Spent',
(SELECT ROUND(SUM(quantityOrdered * priceEach), 2) 'Total Money Spent' FROM SalesFacts) AS 'Total Spent' FROM SalesFacts /* Get total spent */
INNER JOIN CustomersDIM ON CustomersDIM.CustomerSK = SalesFacts.CustomerSK
GROUP BY CustomersDIM.customerNumber
--
) AS SpendingData
ORDER BY (SpendingData.[Customer Spent] / SpendingData.[Total Spent]) * 100 DESC;
---



