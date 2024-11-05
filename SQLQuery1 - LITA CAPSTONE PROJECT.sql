---------------------------------------PROJECT 1-----------------------------------------

SELECT * FROM [dbo].[LITA Capstone SalesData] 

-1--Total Sales for each Product Category----
select Product, SUM (Quantity) AS Total_Sales
from [dbo].[LITA Capstone SalesData] 
GROUP BY Product


-2----The Number of Sales Transactions in each Region----
select Region, COUNT(*) AS Total_Transaction
from [dbo].[LITA Capstone SalesData] 
GROUP BY region
 

-3--The Highest Selling Product by Total Sales Value
SELECT TOP 1 
    Product, 
    SUM(CAST(Quantity AS INT) * CAST(UnitPrice AS INT)) AS Total_Revenue
FROM 
    [dbo].[LITA Capstone SalesData] 
GROUP BY 
    Product
ORDER BY 
    Total_Revenue DESC;


-4---Total Revenue per Product
SELECT Product, SUM(Total_Sales) AS Total_Revenue
FROM [dbo].[LITA Capstone SalesData] 
GROUP BY product


-5---Monthly Sales Totals for the Current Year
SELECT 
    MONTH(OrderDate) AS Month, 
    SUM(Total_Sales) AS Monthly_Sales
FROM 
   [dbo].[LITA Capstone SalesData]
WHERE 
    YEAR(OrderDate) = YEAR(GETDATE())
GROUP BY 
    MONTH(OrderDate);


-6--- Top 5 Customers by Total Purchase Amount 
SELECT TOP 5 
    Customer_Id, 
    SUM(Total_Sales) AS Total_Purchase
FROM 
   [dbo].[LITA Capstone SalesData]
GROUP BY 
    Customer_Id
ORDER BY 
    Total_Purchase DESC;


-7--- The Percentage of Total Sales Contributed by Each Region ----
SELECT 
    Region, 
    (CAST(SUM(Total_Sales) AS FLOAT) / 
     (SELECT CAST(SUM(Total_Sales) AS FLOAT) 
      FROM  [dbo].[LITA Capstone SalesData]) * 100) AS Sales_Percentage
FROM 
     [dbo].[LITA Capstone SalesData]
GROUP BY 
    Region;


-8-----Products with no Sales in the last quarter-----
SELECT MIN(OrderDate) AS Earliest_Order, 
MAX(OrderDate) AS Latest_Order
FROM [dbo].[LITA Capstone SalesData]


---- Products with no Sales in the Last Available Quarter (April - June 2024) ----
SELECT DISTINCT Product
FROM [dbo].[LITA Capstone SalesData]
WHERE 
    Product NOT IN (
        SELECT Product
        FROM [dbo].[LITA Capstone SalesData]
        WHERE OrderDate BETWEEN '2024-04-01' AND '2024-06-30'
    );


-----------------------------------PROJECT 2-------------------------------------

SELECT * FROM [dbo].[LITA Capstone CustomerData] 

--------Total Number of Customers from each Region--------
SELECT Region, COUNT(CustomerID) AS Total_Customer
FROM [dbo].[LITA Capstone CustomerData] 
GROUP BY region;


-----The most Popular Subscription Type by Number of Customers------
SELECT TOP 1 SubscriptionType, COUNT(CustomerID) AS Total_Customer
FROM [dbo].[LITA Capstone CustomerData]
GROUP BY SubscriptionType;


------------Customers Who Cancelled the their Subscription within 6 Months----------------
SELECT CustomerID, SubscriptionType
FROM [dbo].[LITA Capstone CustomerData]
WHERE DATEDIFF(Month, SubscriptionStart, SubscriptionEnd) <= 6;


SELECT CustomerID, SubscriptionType, SubscriptionStart, SubscriptionEnd,
       DATEDIFF(Month, SubscriptionStart, SubscriptionEnd) AS SubscriptionDuration
FROM [dbo].[LITA Capstone CustomerData]
WHERE SubscriptionEnd IS NOT NULL;

SELECT CustomerID, SubscriptionType
FROM [dbo].[LITA Capstone CustomerData]
WHERE SubscriptionEnd IS NOT NULL 
AND DATEDIFF(Month, SubscriptionStart, SubscriptionEnd) > 6;



---------Average Subscription Duration for all Customers------
SELECT AVG(DATEDIFF(month, SubscriptionStart, SubscriptionEnd)) 
AS Average_Duration
FROM [dbo].[LITA Capstone CustomerData];


------Customer with Subcriptions Longer than 12 months-----
SELECT CustomerID, SubscriptionType
FROM [dbo].[LITA Capstone CustomerData]
WHERE DATEDIFF(Month, SubscriptionStart, SubscriptionEnd) > 12;


-----Total Revenue by Subscription Type----------------------
SELECT SubscriptionType, SUM(Revenue) AS Total_Revenue
FROM [dbo].[LITA Capstone CustomerData]
GROUP BY SubscriptionType;


------Top 3 Region by Subscription Cancellation-----------
SELECT Top 3 Region, 
COUNT(Canceled) AS Subscription_Cancellations
FROM [dbo].[LITA Capstone CustomerData]
GROUP BY Region
ORDER BY Subscription_Cancellations DESC;


---------Total Number of Active and Cancelled Subscriptions---------------
SELECT 
   SUM(CASE WHEN Canceled IS NULL THEN 1 ELSE 0 END) 
   AS Active_Subscriptions,
   SUM(CASE WHEN Canceled IS NOT NULL THEN 1 ELSE 0 END) AS Canceled_Subscriptions
FROM [dbo].[LITA Capstone CustomerData];
