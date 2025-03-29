Customer Behavior Analysis

This README provides all the necessary details to set up, execute, and analyze customer feedback data. 

How to Run the Project
Set Up MySQL Database
Create the required tables in MySQL using schema.sql.
Load initial data using CSV imports.
Execute Python Script for Data Cleaning & Import
After importing the data clean the csv using pandas

Run SQL Queries for Analysis
Use MySQL Workbench or any SQL client to run the queries.




Project Overview

This project analyzes customer reviews, engagement data, and purchase behavior to improve customer satisfaction and business performance. The goal is to identify key concerns from negative reviews, track engagement with marketing campaigns, and suggest strategies to enhance customer retention. Data will be loaded to the tables using Pandas 
Database Schema
The project utilizes the following tables:

Customers

CustomerID (INT)
CustomerName (VARCHAR)
Email (VARCHAR)
Gender (VARCHAR)
Age (INT)
GeographyID (INT)

Customer_reviews


ReviewID (INT)
CustomerID (INT, Foreign Key -> customers)
ProductID (INT, Foreign Key -> products)
Rating (INT, 1-5 scale)
ReviewText (TEXT)
ReviewDate (DATE)

Products

Lists products with their categories and prices.
ProductID (INT)
ProductName (VARCHAR)
Category (VARCHAR)
Price (DECIMAL)

Engagement_data

EngagementID (INT)
ContentID (VARCHAR)
ContentType (VARCHAR)
EngagementDate (DATE)
CampaignID (INT)
ProductID (INT, Foreign Key -> products)
Views (INT)
Clicks (INT)

Geography

GeographyID (INT)
Country (VARCHAR)
City (VARCHAR)
Customer journey
JourneyID (INT)
CustomerID (INT)
 ProductID (INT)
VisitDate (DATE)
Stage (VARCHAR)
Action_by_customers (VARCHAR)
 Duration (INT)

Python Script for Data Cleaning and MySQL Import

Steps Covered in the Script:

Load CSV data using Pandas.
Handle missing values and duplicates.
Clean text data (e.g., remove special characters from reviews).
Establish a connection with MySQL using mysql-connector-python.
Insert cleaned data into the respective MySQL tables.

Import pandas as pd 
Import mysql.connector

Load CSV data
Customers = pd.read_csv(‘customers.csv’) 
Reviews = pd.read_csv(‘customer_reviews.csv’)
Products = pd.read_csv(‘products.csv’) 
Engagement = pd.read_csv(‘engagement_data.csv’) 
Geography = pd.read_csv(‘geography.csv’)
Customer Journey = pd.read_csv(‘cutomer_journey.csv’)

Data Cleaning
Remove duplicates, remove null values and split columns and change data type if required 
Establish MySQL connection
Conn = mysql.connector.connect( user  = 'newuser',passcode = "Apps@5566",host = 'localhost',db_name = "shopeasy")

Insert data into MySQL (example for customers)
cursor = db_connection.cursor()
insert_query = """
INSERT INTO customers (CustomerID, CustomerName, Email, Gender, Age, GeographyID)
VALUES (%s, %s, %s, %s, %s, %s) """
 Cursor.close() Conn.close()

SQL Queries for Analysis

Customers engaging with reviews before purchasing have higher conversion rates.

SELECT Stage, COUNT(*) AS DropoffCount FROM customer_journey WHERE Action_by_customers = ‘View’ GROUP BY Stage ORDER BY DropoffCount DESC;

Impact of Customer reviews on Purchases

SELECT cr.ProductID, AVG(cr.Rating) AS AvgRating, COUNT(cr.ReviewID) AS ReviewCountFROM customer_reviews cr GROUP BY cr.ProductID
ORDER BY AvgRating DESC;

Best Performing Products, Locations & Segments

SELECT c.Gender, c.Age, COUNT(cj.CustomerID) AS TotalEngagements
FROM customers c JOIN customer_journey cj ON c.CustomerID = cj.CustomerID GROUP BY c.Gender, c.Age ORDER BY TotalEngagements DESC;

SELECT g.Country, COUNT(c.CustomerID) AS CustomerCount
FROM customers c JOIN geography g ON c.GeographyID = g.GeographyID GROUP BY g.Country


SELECT cj.ProductID, COUNT(*) AS TotalViews FROM customer_journey c
WHERE cj.Stage = ‘ProductPage’ GROUP BY cj.ProductID
ORDER BY TotalViews DESC;

Insights & Recommendations

1)Factors Influencing Customer Engagement
 
Customers spend more time on the homepage but drop off before reaching the product pages.
 
Product pages with more clicks and longer duration tend to have better reviews


2)Customer Drop-off Stages
 
A significant drop-off occurs on the product page, suggesting pricing concerns or weak product descriptions.
 
Customers engaging with reviews before purchasing have higher conversion rates.


 
3)Best performing customer segment,locations and products: 

Females aged 30-45 convert at higher rates.

Customers from Germany and the UK engage the most.
 
Items with detailed descriptions and higher review counts get more views and clicks.


Get Customer Reviews and Sentiments

SELECT c.CustomerName, p.ProductName, cr.Rating, cr.ReviewText FROM customer_reviews cr JOIN customers c ON cr.CustomerID = c.CustomerID JOIN products p ON cr.ProductID = p.ProductID WHERE cr.Rating <= 2;
Track Engagement with Marketing Campaigns
SELECT e.ContentType, e.EngagementDate, p.ProductName, e.Views, e.Clicks FROM engagement_data e JOIN products p ON e.ProductID = p.ProductID ORDER BY e.Views DESC;
Identify Customer Purchase Trends by Age Group
SELECT c.Age, COUNT(cr.ProductID) AS TotalPurchases FROM customers c JOIN customer_reviews cr ON c.CustomerID = cr.CustomerID GROUP BY c.Age ORDER BY TotalPurchases DESC;

Insights & Recommendations

4.  Customer Sentiment:

Many customers leave negative reviews about product quality.
Products with low ratings should be reviewed for quality improvements.
5. Engagement & Marketing Performance:

Social media campaigns drive high engagement but low conversions.
Email newsletters generate more clicks but fewer views.
6. Purchase Behavior:

Customers aged 25-35 are the most active buyers.
Pricing analysis can help optimize product cost for better sales.



Technology Stack
Database: MySQL
Data Processing: Python (Pandas, MySQL Connector)

