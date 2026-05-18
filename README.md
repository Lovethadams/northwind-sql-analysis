# Northwind Sales Analysis — SQL Project

## Overview
This project analyzes the Northwind database using PostgreSQL and advanced SQL window functions. It answers 5 key business questions about employee performance, revenue trends, customer value, and product sales.

## Tools Used
- PostgreSQL
- VS Code + SQLTools Extension

## Database
The Northwind database is a sample database containing sales data for a fictional company. It includes tables for customers, orders, employees, products, and more.

## Business Questions Answered

1. **Which employees handled the most orders?** — `RANK()`
2. **What is the running total of revenue by month?** — `SUM() OVER`
3. **Which customers are above average order value?** — `AVG() OVER`
4. **What is the top selling product per category?** — `ROW_NUMBER()`
5. **What is the month over month sales growth?** — `LAG()`

## Key Findings
- **Margaret Peacock** was the top performing employee with 156 orders
- Revenue shows consistent growth from 1996 to early 1998, with a sharp drop in May 1998
- **QUICK-Stop** had the highest average order value among all customers
- **Côte de Blaye** was the top product in the Beverages category

## Files
- `northwind_analysis.sql` — All 5 SQL queries with comments
