# 🏬 RetailMart — SQL Server Portfolio Project

![SQL Server](https://img.shields.io/badge/Database-SQL%20Server-CC2927?logo=microsoftsqlserver&logoColor=white)
![Language](https://img.shields.io/badge/Language-TSQL-blue)
![Level](https://img.shields.io/badge/Progress-Beginner%20→%20Advanced-brightgreen)
![Status](https://img.shields.io/badge/Status-Actively%20Developed-success)

---

### 🧭 Overview

**RetailMart** is a hands-on SQL Server project designed to showcase SQL skills from **beginner to advanced**.  
It simulates a small retail business and demonstrates practical data-engineering and analytics concepts such as:

- Database design & normalization  
- Data population with realistic retail data  
- Analytical queries (joins, aggregations, CTEs, window functions)  
- Business insights & KPI reporting  
- Query optimization and indexing  

The goal of this repository is to serve as a **learning and portfolio project** for mastering SQL step-by-step — without using any other programming language.

---

### 🧱 Current Progress

✅ Database created in **SQL Server**  
✅ Schema: `rm`  
✅ Tables: `Customers`, `Employees`, `Products`, `Orders`, `OrderDetails`  
✅ Data successfully inserted  
✅ Added **advanced analytical queries** (CTEs, window functions, ranking, subqueries)  
✅ Added **business insights & KPI queries** for key metrics  
🧩 Next steps: expand advanced analytics and performance optimization

---

### 📊 Business Insights & KPIs

Recent additions include key performance indicators and analytical queries such as:

- **Total Revenue, Total Orders, Average Order Value**
- **Revenue by Category & Region**
- **Top 10 Customers by Spend**
- **Monthly Sales Trend (YoY Analysis)**
- **Employee Sales Leaderboard**
- **Product Profitability by Category**

These insights provide the foundation for dashboard visualization and executive-level reporting.

---

### 🧠 Analytical Focus Areas

| Area | Concepts Demonstrated |
|------|------------------------|
| **Data Aggregation** | SUM, AVG, COUNT, GROUP BY, HAVING |
| **Advanced SQL Logic** | CTEs, Subqueries, CASE Expressions |
| **Window Functions** | RANK, DENSE_RANK, LAG, SUM OVER |
| **Data Cleaning** | ISNULL, COALESCE, CAST, TRIM |
| **Performance Optimization** | Indexing, query restructuring, reusable views |
| **Reporting Layer** | KPI-driven metrics and trend analysis |

---

### ⚙️ How to Run Locally

1. Open **SQL Server Management Studio (SSMS)** or **Azure Data Studio**  
2. Run `01_schema/create_tables.sql` to create the database and schema  
3. Run `02_data/insert_sample_data.sql` to populate tables  
4. Explore analytical and KPI queries in:
   - `03_queries/intermediate_queries.sql`
   - `04_queries/advanced_queries.sql`
   - `05_queries/business_insights.sql`

---

### 🚀 Upcoming Additions

- Time-series revenue analysis (YoY and MoM)
- Stored procedures for reusable KPI reports
- Index tuning and performance benchmarks
- Power BI / Tableau visualization layer

---

### 📂 Repository Structure
RetailMart/
├── 01_schema/
│ └── create_tables.sql
├── 02_data/
│ └── insert_sample_data.sql
├── 03_queries/
│ ├── basic_queries.sql
│ ├── intermediate_queries.sql
│ └── advanced_queries.sql
├── 04_reports/
│ └── business_insights.sql
└── README.md

### 🧩 Purpose

This repository demonstrates **end-to-end SQL analytics** —  
from **data modeling** and **query logic** to **KPI computation** — designed for analysts, data engineers, and anyone aiming to showcase **real-world SQL proficiency**.
