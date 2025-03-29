-- Create Table Customers


CREATE TABLE customers(
CustomerID INT,
CustomerName VARCHAR(100),
Email VARCHAR(10),
Age INT,
GeographyID INT 
);

-- Create Table Customers_reviews

CREATE TABLE customer_reviews(
ReviewID INT,
CustomerID INT,
ProductID INT,
ReviewDate date,
Rating INT,
ReviewText VARCHAR(255)
);


-- Create Table Customer_journey

CREATE TABLE customer_journey(
JourneyID INT,
CustomerID INT,
ProductID INT,
VisitDate DATE,
Stage VARCHAR(50),
Action_by_customers VARCHAR(10),
Duration INT
);


-- Create Table Products

CREATE TABLE products(
ProductID INT,
ProductName VARCHAR(50),
Category VARCHAR(50),
Price FLOAT
);

-- Create Table Engangement_data

CREATE TABLE engagement_data(
EngagementID INT,
ContentID INT,
ContentType VARCHAR(50),
Likes INT,
EngagementDate DATE,
CampaignID INT,
ProductID INT,
Views INT,
Clicks INT
);

-- Create Table Geography

CREATE TABLE geography(
GeographyID INT,
Country VARCHAR(50),
City VARCHAR(50)

);

ALTER TABLE customers ADD COLUMN Gender VARCHAR(100);
ALTER TABLE customers
MODIFY COLUMN Gender VARCHAR(100) AFTER Email; 

USE shopeasy;
ALTER TABLE customers
MODIFY COLUMN Email VARCHAR(255);

-- Factors Influencing Customer Engagement

SELECT cj.Stage, AVG(cj.Duration) AS AvgDuration, COUNT(cj.CustomerID) AS VisitCount
FROM customer_journey cj
GROUP BY cj.Stage
ORDER BY AvgDuration DESC;


-- Customer Drop-off Stages
SELECT Stage, COUNT(*) AS DropoffCount
FROM customer_journey
WHERE Action_by_customers = 'View'
GROUP BY Stage
ORDER BY DropoffCount DESC;


-- Impact of Customer Reviews on Purchases

SELECT cr.ProductID, AVG(cr.Rating) AS AvgRating, COUNT(cr.ReviewID) AS ReviewCount
FROM customer_reviews cr
GROUP BY cr.ProductID
ORDER BY AvgRating DESC;

-- To identify negative reviews mentioning “price” or “quality concerns”:
SELECT * FROM customer_reviews
WHERE ReviewText LIKE '%price%' OR ReviewText LIKE '%quality%';

select * from customers;
select * from customer_journey;

-- Best Performing Customer Segments:
SELECT c.Gender, c.Age, COUNT(cj.CustomerID) AS TotalEngagements
FROM customers c
JOIN customer_journey cj ON c.CustomerID = cj.CustomerID
GROUP BY c.Gender, c.Age
ORDER BY TotalEngagements DESC;

-- Best Performing locations:
SELECT g.Country, COUNT(c.CustomerID) AS CustomerCount
FROM customers c
JOIN geography g ON c.GeographyID = g.GeographyID
GROUP BY g.Country
ORDER BY CustomerCount DESC;

-- Best Performing Products:
SELECT cj.ProductID, COUNT(*) AS TotalViews
FROM customer_journey cj
WHERE cj.Stage = 'ProductPage'
GROUP BY cj.ProductID
ORDER BY TotalViews DESC;

-- Sentiment Analysis from Customer Reviews

SELECT cr.rating,COUNT(*) AS review_count
FROM customer_reviews cr 
GROUP BY rating
ORDER BY rating DESC;

-- Identifying Key Complaints from Low Ratings
SELECT Rating, COUNT(*) AS frequency
FROM customer_reviews
WHERE rating <= 2
GROUP BY Rating
ORDER BY frequency DESC
LIMIT 10;

-- Customer Engagement and Purchase History

SELECT cj.CustomerID, c.CustomerName, COUNT(DISTINCT cj.ProductID) AS Total_Products_Viewed, 
       COUNT(DISTINCT ed.CampaignID) AS Total_Campaigns_Engaged, 
       COUNT(DISTINCT cr.ReviewID) AS Reviews_Given
FROM customer_journey cj
LEFT JOIN customers c ON cj.CustomerID = c.CustomerID
LEFT JOIN engagement_data ed ON cj.ProductID = ed.ProductID
LEFT JOIN customer_reviews cr ON cj.CustomerID = cr.CustomerID
GROUP BY cj.CustomerID, c.CustomerName
ORDER BY Total_Products_Viewed DESC;

select * from engagement_data;


-- Mapping Engagement Data to Customer Satisfaction


SELECT ed.ContentType, ROUND(AVG(cr.rating), 1) AS Avg_Rating, 
       SUM(ed.Views) AS Total_Views, SUM(ed.Clicks) AS Total_Clicks
FROM engagement_data ed
LEFT JOIN customer_journey cj ON ed.ProductID = cj.ProductID
LEFT JOIN customer_reviews cr ON cj.CustomerID = cr.CustomerID
GROUP BY ed.ContentType
ORDER BY Avg_Rating DESC;
