# SQL Data Analysis

A collection of SQL scripts for data exploration, analytics, and reporting on a sales data warehouse. The scripts cover time-based trends, cumulative analytics, performance comparisons, segmentation, part-to-whole analysis, and a consolidated customer report.

Built to help data analysts and BI professionals quickly explore, segment, and analyze data within a relational database. Each script focuses on one analytical theme and is written in T-SQL for SQL Server.

---

## 📂 Repository Structure

```
sql-data-analysis/
│
├── Scripts/
│   ├── ChangeOverTime.sql            # Monthly trend of customers, quantity, and revenue
│   ├── Running Total.sql             # Cumulative revenue by month
│   ├── YoY_Change.sql                # Yearly product sales vs average and prior year
│   ├── Percentage_total.sql          # Category share of total sales
│   ├── Division by group.sql         # Products grouped into cost ranges
│   ├── Customer classification.sql   # VIP / Regular / New customer counts
│   └── Report.sql                    # Consolidated customer report
│
├── Source/
│   └── DataWarehouseAnalytics.bak    # SQL Server database backup
│
└── README.md
```

---

## 📊 Scripts

| Script | Analysis Type | What it answers |
|--------|---------------|-----------------|
| `ChangeOverTime.sql` | Change over time | How do customers, quantity, and revenue move month to month? |
| `Running Total.sql` | Cumulative analysis | How is revenue accumulating over time? |
| `YoY_Change.sql` | Performance analysis | Is each product above or below its average, and did sales rise or fall vs last year? |
| `Percentage_total.sql` | Part-to-whole | Which categories contribute the most to total sales? |
| `Division by group.sql` | Data segmentation | How is product cost distributed across price bands? |
| `Customer classification.sql` | Data segmentation | How many customers are VIP, Regular, or New? |
| `Report.sql` | Reporting | What does a full customer profile look like with KPIs? |

---

## 👥 Customer Report (`Report.sql`)

Combines everything into one customer level output:

- **Profile:** customer key, number, full name, age
- **Age groups:** Under 20, 20-29, 30-39, 40-49, 50+
- **Segments:**
  - **VIP:** 12+ months history and sales of 5,000 or more
  - **Regular:** 12+ months history and sales under 5,000
  - **New:** less than 12 months history
- **Aggregates:** total orders, sales, quantity, distinct products, lifespan in months
- **KPIs:** days since last order (recency), average order value, average monthly spend

Ready to wrap in a view and plug into Power BI.

---

## 🧠 Techniques Used

- Aggregations: `SUM`, `COUNT(DISTINCT)`, `AVG`, `MIN`, `MAX`
- Window functions: `SUM() OVER`, `AVG() OVER (PARTITION BY)`, `LAG`
- Date functions: `DATETRUNC`, `YEAR`, `DATEDIFF`, `GETDATE`
- `CASE WHEN` for segmentation and banding
- CTEs and nested subqueries for step-by-step logic
- Percent of total with `SUM() OVER ()`

---

## 🗂️ Data Model

Star schema in the `gold` layer:

| Table | Description |
|-------|-------------|
| `gold.fact_sale` | Order level sales: order date, quantity, price, sales amount |
| `gold.dim_customer` | Customer attributes: name, customer number, birth date |
| `gold.dim_product` | Product attributes: name, category, cost |

---

## 🛠️ Getting Started

**Requirements**
- SQL Server 2022 or later (`DATETRUNC` is not available in older versions)
- SQL Server Management Studio (SSMS) or Azure Data Studio

**Setup**
1. Clone the repo
   ```bash
   git clone https://github.com/MoizWaheed80/sql-data-analysis.git
   ```
2. Copy `Source/DataWarehouseAnalytics.bak` to your SQL Server backup folder
3. In SSMS, right click **Databases** > **Restore Database** > **Device**, then select the `.bak` file
4. Open any script from `Scripts/` and run it against the restored database

---

## 👤 About Me

**Abdul Moiz Waheed**
Data Analyst and Analytics Engineer working with SQL Server, Power BI, and Python.

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/abdul-moiz-s2402)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/MoizWaheed80)
[![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:moizwaheed80@gmail.com)
