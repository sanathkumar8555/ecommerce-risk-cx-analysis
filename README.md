# E-Commerce Risk & Customer Experience Analytics

## Project Overview

This project analyzes the Brazilian Olist e-commerce dataset to identify delivery issues, customer experience patterns, seller risk indicators, and seller-category combinations that may require further investigation.

The project combines SQL and Excel to transform raw transactional data into business-focused risk and customer experience insights.

## Business Objective

The analysis focuses on answering questions such as:

- What is the overall order and delivery performance?
- Which freight-cost segments experience higher late-delivery rates?
- How do customers rate their shopping experience?
- Which sellers show multiple risk indicators?
- Which seller-category combinations should be prioritized for further investigation?
- How do order exceptions change over time?

## Tools Used

- MySQL — data querying, joins, aggregations, CTEs and analytical queries
- Microsoft Excel — data validation, PivotTables, formulas, ranking and dashboard creation
- SQL — KPI calculation and multi-table analysis
- Excel Charts — visualization and business reporting

## Dataset

Brazilian E-Commerce Public Dataset by Olist.

The analysis uses data related to:

- Orders
- Customers
- Sellers
- Products
- Order Items
- Payments
- Customer Reviews
- Geolocation

The dataset contains approximately 100K orders and supporting transactional records.

## Project Workflow

### 1. Data Cleaning

The datasets were reviewed for:

- Missing values
- Duplicate records
- Invalid or unusual values
- Date consistency
- Delivery status
- Review-score quality
- Payment anomalies
- Product and seller data quality

Additional analytical fields were created where required.

### 2. SQL Analysis

SQL was used to analyze:

- Order performance
- Delivery performance
- Customer experience
- Seller performance
- Product/category performance
- Freight-related delivery risk
- Multi-factor seller risk indicators

The analysis uses concepts including:

- JOINs
- GROUP BY / HAVING
- CASE statements
- CTEs
- Aggregate functions
- Window functions
- Ranking

### 3. Excel Analysis

Excel was used for additional investigation and validation through:

- PivotTables
- XLOOKUP
- COUNTIF / COUNTIFS
- Ranking
- Percentage calculations
- Seller-level analysis
- Seller-category analysis

### 4. Dashboard

A final Excel dashboard was created to communicate the major findings and KPIs.

![E-Commerce Risk & Customer Experience Dashboard](dashboard/dashboard.png)

## Key KPIs

| KPI | Result |
|---|---:|
| Total Orders | 99,441 |
| Late Delivery Rate | 6.77% |
| Average Review Score | 4.09 |
| Low-Rated Reviews (1–2 stars) | 14.69% |
| Sellers Meeting Investigation Screening Criteria | 65 |
| Seller-Category Combinations Meeting Final Screening Criteria | 77 |

## Key Findings

### Delivery Performance

The overall late-delivery rate was **6.77%**.

### Freight Risk

Late-delivery rates increased across the analyzed freight-cost buckets:

- Under 20: **6.15%**
- 20–49: **7.84%**
- 50–99: **8.29%**
- 100+: **9.90%**

This indicates that higher-freight orders in this dataset were associated with higher late-delivery rates.

### Customer Experience

The average customer review score was **4.09 / 5**.

However, **14.69%** of valid reviews were low-rated (1–2 stars), providing a useful segment for customer-experience investigation.

### Seller Risk Screening

Using the defined screening criteria, **65 of 210 analyzed sellers** were identified for further investigation.

These flags represent analytical screening indicators and should not be interpreted as proof of seller misconduct.

### Multi-Factor Analysis

The final analysis identified **77 seller-category combinations** meeting the defined multi-factor screening criteria.

These combinations can be prioritized for deeper investigation based on delivery and customer-experience indicators.

## Business Recommendations

- Prioritize flagged seller-category combinations for deeper investigation.
- Monitor sellers displaying multiple risk indicators rather than relying on a single metric.
- Closely monitor high-freight orders due to their higher observed late-delivery rates.
- Investigate recurring low customer ratings alongside delivery performance.
- Use order volume when interpreting percentage-based risk metrics.
- Continue monitoring delivery exceptions over time.

## Important Analytical Limitation

Some periods contain very small order volumes.

For example, the extreme exception rates observed in Sep-2016 and Sep–Oct-2018 are based on small samples and should not be interpreted in the same way as high-volume months.

Seller investigation flags are screening indicators designed to prioritize further review, not conclusions of fraudulent or improper behavior.

