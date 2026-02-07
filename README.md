# Task-8-SQL-Window-Functions

## Overview
This task focuses on using advanced SQL window functions to perform analytical reporting on a real-world sales dataset.  
The goal was to analyze sales performance using ranking, running totals, and growth analysis.

The dataset used for this task is **Amazon Sale Report**, which contains over **170,000+ rows** of transactional sales data.

---

## Tools Used
- MySQL 8+
- MySQL Workbench
- CSV Dataset (Amazon Sale Report)

---

## Key Steps Performed

1. Imported a large CSV dataset into MySQL.
2. Cleaned raw data:
   - Converted sales amount into a numeric column (`amount_num`).
   - Converted order dates into proper DATE format.
3. Used SQL aggregation and window functions to perform analysis.

---

## SQL Concepts Covered

### 1. Aggregation
- `GROUP BY` used to calculate total sales by category and product.

### 2. Ranking Functions
- `ROW_NUMBER()` for unique ranking.
- `RANK()` and `DENSE_RANK()` to handle ties in sales ranking.

### 3. Running Totals
- Calculated cumulative sales over time using:
  ```sql
  SUM() OVER (ORDER BY ...)
