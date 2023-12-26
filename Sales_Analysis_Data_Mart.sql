/*

DATA MART SALES AND PERFORMANCE ANALYSIS 

INTRODUCTION:
Data Mart is my latest venture and I want your help to analyze the sales and performance of my venture. In June 2020 - large scale supply changes were made at Data Mart. All Data Mart products now use sustainable packaging methods in every single step from the farm all the way to the customer.
I need your help to quantify the impact of this change on the sales performance for Data Mart and its separate business areas.


SCHEMA USED: WEEKLY_SALES TABLE

 COLUMN_NAME  |  DATA_TYPE    |
 week_date    |   date        |
 region       |   varchar(20) |
 platform     |   varchar(20) |
 segment      |   varchar(20) |
 customer     |   varchar(20) |
 transactions |   int         |
 sales        |   int         |
 


CASE STUDY QUESTIONS

A. Data Cleansing Steps

In a single query, perform the following operations and generate a new table in the data_mart schema named clean_weekly_sales:
1. Add a week_number as the second column for each week_date value, for example any value from the 1st of January to 7th of January will be 1, 8th to 14th will be 2, etc.
2. Add a month_number with the calendar month for each week_date value as the 3rd column
3. Add a calendar_year column as the 4th column containing either 2018, 2019 or 2020 values
4. Add a new column called age_band after the original segment column using the following mapping on the number inside the segment value

SEGMENT  |  AGE_BAND      |
   1     |   Young Adults |
   2     |   Middle Aged  |
3 or 4   |   Retirees     |


5. Add a new demographic column using the following mapping for the first letter in the segment values:

 SEGMENT  |  DEMOGRAPHIC |
    C     |    Couples   |
    F     |    Families  |
    
6.Ensure all null string values with an "unknown" string value in the original segment column as well as the new age_band and demographic columns
7.Generate a new avg_transaction column as the sales value divided by transactions rounded to 2 decimal places for each record
/*
SELECT * FROM WEEKLY_SALES ;

CREATE TABLE CLEAN_WEEKLY_SALES AS 
SELECT WEEK_DATE,
WEEK(WEEK_DATE) AS WEEK_NUMBER,
MONTH(WEEK_DATE) AS MONTH_NUMBER,
YEAR(WEEK_DATE) AS YEAR_NUMBER,
REGION, PLATFORM,
CASE WHEN SEGMENT = 'NULL' THEN 'UNKNOWN'
ELSE SEGMENT
END AS SEGMENT,
CASE WHEN RIGHT(SEGMENT,1) = '1' THEN 'YOUNG ADULTS'
WHEN RIGHT(SEGMENT,1) = '2' THEN 'MIDDLE AGED'
WHEN RIGHT(SEGMENT,1) IN ('3','4') THEN 'RETIREES'
ELSE 'UNKNOWN'
END AS AGE_BAND,
CASE WHEN LEFT(SEGMENT,1) = 'C' THEN 'COUPLES'
WHEN LEFT(SEGMENT,1) = 'F' THEN 'FAMILIES'
ELSE 'UNKNOWN'
END AS DEMOGRAPHIC,
CUSTOMER_TYPE, TRANSACTIONS, SALES,
ROUND(SALES/TRANSACTIONS,2) AS AVG_TRANSACTION
FROM WEEKLY_SALES ;


SELECT *
FROM CLEAN_WEEKLY_SALES
LIMIT 10 ;

/*
B. Data Exploration


1.Which week numbers are missing from the dataset? /*

CREATE TABLE SEQ100
(X INT NOT NULL AUTO_INCREMENT PRIMARY KEY) ;
INSERT INTO SEQ100 VALUES (),(),(),(),(),(),(),(),(),() ;
INSERT INTO SEQ100 VALUES (),(),(),(),(),(),(),(),(),() ;
INSERT INTO SEQ100 VALUES (),(),(),(),(),(),(),(),(),() ;
INSERT INTO SEQ100 VALUES (),(),(),(),(),(),(),(),(),() ;
INSERT INTO SEQ100 VALUES (),(),(),(),(),(),(),(),(),() ;
INSERT INTO SEQ100 
SELECT X+50
FROM SEQ100;

SELECT *
FROM SEQ100

CREATE TABLE SEQ52 AS (
SELECT X 
FROM SEQ100
LIMIT 52) ;

SELECT DISTINCT X AS WEEK_DAY
FROM SEQ52 
WHERE X NOT IN (
SELECT DISTINCT WEEK_NUMBER
FROM CLEAN_WEEKLY_SALES) ;

/*2.How many total transactions were there for each year in the dataset?/*

SELECT YEAR_NUMBER, 
SUM(TRANSACTIONS) AS TOTAL_TRANSACTIONS
FROM CLEAN_WEEKLY_SALES
GROUP BY YEAR_NUMBER ;


/*3.What are the total sales for each region for each month?/*

SELECT REGION, MONTH_NUMBER,
SUM(SALES) AS TOTAL_SALES
FROM CLEAN_WEEKLY_SALES
GROUP BY REGION, MONTH_NUMBER ;

/*4.What is the total count of transactions for each platform/*

SELECT PLATFORM, 
SUM(TRANSACTIONS) AS TOTAL_TRANSACTIONS
FROM CLEAN_WEEKLY_SALES
GROUP BY PLATFORM ;

/*5.What is the percentage of sales for Retail vs Shopify for each month?/*

WITH CTE AS (
SELECT MONTH_NUMBER, YEAR_NUMBER, PLATFORM,
SUM(SALES) AS MONTHLY_SALES
FROM CLEAN_WEEKLY_SALES
GROUP BY MONTH_NUMBER, YEAR_NUMBER, PLATFORM
)

SELECT MONTH_NUMBER, YEAR_NUMBER,
ROUND(100* MAX(CASE WHEN PLATFORM = 'RETAIL' THEN MONTHLY_SALES ELSE NULL END)/ SUM(MONTHLY_SALES),2) AS RETAIL_PERCENTAGE,
ROUND(100* MAX(CASE WHEN PLATFORM = 'SHOPIFY' THEN MONTHLY_SALES ELSE NULL END)/ SUM(MONTHLY_SALES),2) AS SHOPIFY_PERCENTAGE
FROM CTE
GROUP BY MONTH_NUMBER, YEAR_NUMBER 
ORDER BY MONTH_NUMBER, YEAR_NUMBER ;


/*6.What is the percentage of sales by demographic for each year in the dataset?/*

SELECT YEAR_NUMBER, DEMOGRAPHIC,
SUM(SALES) AS YEARLY_SALES,
ROUND((100 * SUM(SALES)/SUM(SUM(SALES)) OVER(PARTITION BY DEMOGRAPHIC)),2) AS PERCENTAGE
FROM CLEAN_WEEKLY_SALES
GROUP BY YEAR_NUMBER, DEMOGRAPHIC
ORDER BY YEAR_NUMBER, DEMOGRAPHIC ;

/*7.Which age_band and demographic values contribute the most to Retail sales?/*

SELECT AGE_BAND, DEMOGRAPHIC,
SUM(SALES) AS TOTAL_SALES
FROM CLEAN_WEEKLY_SALES
WHERE PLATFORM = 'RETAIL'
GROUP BY AGE_BAND, DEMOGRAPHIC
ORDER BY TOTAL_SALES DESC LIMIT 1 ;














































