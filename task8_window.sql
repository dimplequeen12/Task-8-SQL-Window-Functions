ALTER TABLE sales
MODIFY promotion_ids TEXT;

ALTER TABLE sales
MODIFY amount VARCHAR(50);

SET GLOBAL local_infile = 1;

USE task8_db;

LOAD DATA LOCAL INFILE 'C:/Users/Acer/Downloads/Amazon Sale Report.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(idx, order_id, order_date, status, fulfilment, sales_channel,
 ship_service_level, style, category, size,  size, asin,
 courier_status, qty, currency, amount,
 ship_city, ship_state, ship_postal_code, ship_country,
 promotion_ids, b2b, fulfilled_by);
 
 DESCRIBE sales;
 
 USE task8_db;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Amazon Sale Report.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(idx, order_id, order_date, status, fulfilment, sales_channel,
 ship_service_level, style, sku, category, size, asin,
 courier_status, qty, currency, amount,
 ship_city, ship_state, ship_postal_code, ship_country,
 promotion_ids, b2b, fulfilled_by, @extra);

SELECT COUNT(*) FROM sales;

 SELECT order_id, sku, category, size, amount
FROM sales
LIMIT 5;

SET SQL_SAFE_UPDATES = 0;

UPDATE sales
SET amount = REPLACE(amount, ',', '')
WHERE amount IS NOT NULL;

SET SQL_SAFE_UPDATES = 1;

SELECT amount FROM sales LIMIT 5;

ALTER TABLE sales
MODIFY amount DECIMAL(10,2);

SELECT amount
FROM sales
WHERE amount IS NULL
   OR amount = ''
   OR amount = ' '
   OR amount NOT REGEXP '^[0-9]+(\\.[0-9]+)?$'
LIMIT 10;

SET SQL_SAFE_UPDATES = 0;

UPDATE sales
SET amount = '0'
WHERE amount IS NULL
   OR amount = ''
   OR amount = ' '
   OR amount NOT REGEXP '^[0-9]+(\\.[0-9]+)?$';
   
   SET SQL_SAFE_UPDATES = 1;

SELECT amount
FROM sales
WHERE amount NOT REGEXP '^[0-9]+(\\.[0-9]+)?$'
LIMIT 5;

ALTER TABLE sales
MODIFY amount DECIMAL(10,2);

SET SQL_SAFE_UPDATES = 0;

UPDATE sales
SET amount_num = CAST(amount AS DECIMAL(10,2));

SET SQL_SAFE_UPDATES = 1;

SELECT amount, amount_num
FROM sales
LIMIT 5;

DESCRIBE sales;

ALTER TABLE sales ADD COLUMN amount_num DECIMAL(10,2);

SET SQL_SAFE_UPDATES = 0;

UPDATE sales
SET amount_num = 
  CASE
    WHEN amount REGEXP '^[0-9]+(\\.[0-9]+)?$' THEN CAST(amount AS DECIMAL(10,2))
    ELSE 0.00
  END;

SET SQL_SAFE_UPDATES = 1;

SELECT amount, amount_num
FROM sales
LIMIT 5;

SELECT COUNT(*) FROM sales;

SELECT 
    category,
    SUM(amount_num) AS total_sales
FROM sales
GROUP BY category
ORDER BY total_sales DESC;

SELECT 
    sku,
    SUM(amount_num) AS total_sales
FROM sales
GROUP BY sku
ORDER BY total_sales DESC
LIMIT 10;
SELECT
    sku,
    SUM(amount_num) AS total_sales,
    ROW_NUMBER() OVER (ORDER BY SUM(amount_num) DESC) AS row_num
FROM sales
GROUP BY sku;

SELECT
    sku,
    SUM(amount_num) AS total_sales,
    RANK() OVER (ORDER BY SUM(amount_num) DESC) AS sales_rank
FROM sales
GROUP BY sku;

SELECT
    sku,
    SUM(amount_num) AS total_sales,
    DENSE_RANK() OVER (ORDER BY SUM(amount_num) DESC) AS dense_sales_rank
FROM sales
GROUP BY sku;

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(amount_num) AS monthly_sales
FROM sales
GROUP BY month
ORDER BY month;

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(amount_num) AS monthly_sales,
    SUM(SUM(amount_num)) OVER (
        ORDER BY DATE_FORMAT(order_date, '%Y-%m')
    ) AS running_total_sales
FROM sales
GROUP BY month
ORDER BY month;

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(amount_num) AS monthly_sales,
    LAG(SUM(amount_num)) OVER (
        ORDER BY DATE_FORMAT(order_date, '%Y-%m')
    ) AS prev_month_sales
FROM sales
GROUP BY month
ORDER BY month;

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(amount_num) AS monthly_sales,
    LAG(SUM(amount_num)) OVER (
        ORDER BY DATE_FORMAT(order_date, '%Y-%m')
    ) AS prev_month_sales,
    SUM(amount_num)
      - LAG(SUM(amount_num)) OVER (
          ORDER BY DATE_FORMAT(order_date, '%Y-%m')
        ) AS mom_growth
FROM sales
GROUP BY month
ORDER BY month;

WITH product_sales AS (
    SELECT
        category,
        sku,
        SUM(amount_num) AS total_sales
    FROM sales
    GROUP BY category, sku
),
ranked_products AS (
    SELECT
        category,
        sku,
        total_sales,
        DENSE_RANK() OVER (
            PARTITION BY category
            ORDER BY total_sales DESC
        ) AS rnk
    FROM product_sales
)
SELECT
    category,
    sku,
    total_sales
FROM ranked_products
WHERE rnk <= 3
ORDER BY category, total_sales DESC;








