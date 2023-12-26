/*DATA CLEANSING/*

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














































