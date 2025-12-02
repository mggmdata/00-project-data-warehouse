/* ===========================================================================================
   Project: Enterprise Sales Analytics Platform
   Layer:   Bronze & Silver (Data Quality Validation)
   Script:  CRM Sales Details – Data Quality Checks

   Description:
     This script performs systematic data quality validations across the Bronze and Silver
     layers for CRM sales records. It ensures that all transformed data adheres to business
     rules before being consumed by analytics, forecasting models, and reporting pipelines.

   Validation Categories:

     1. Date Integrity Checks:
        - Ensures date fields comply with expected YYYYMMDD structure.
        - Flags invalid or out-of-range dates (e.g., 0, malformed values, unrealistic years).
        - Verifies chronological consistency between order, ship, and due dates.

     2. Sales, Quantity, and Price Consistency:
        - Validates the core financial dependency: Sales = Quantity * Price.
        - Detects missing, zero, negative, or mathematically inconsistent values.
        - Highlights rows requiring recalculation or remediation in the Silver layer.

     3. Cross-Layer Quality Assurance (Bronze ➜ Silver):
        - Re-runs key DQ rules on Silver after business rules and corrections are applied.
        - Ensures Silver output is clean, reliable, and compliant with analytical standards.

   Why This Matters:
     - Establishes data trust and prevents inaccurate financial metrics in BI dashboards.
     - Reduces propagation of data errors across downstream data products.
     - Aligns with modern data engineering practices used by high-scale data teams.
     - Supports automated DQ monitoring, incident detection, and lineage tracking.

   Author: Marcio Gabriel
   Last Updated: 2025-12-01
   =========================================================================================== */


-- Check for Invalid Dates
SELECT
NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
OR LENGTH(sls_due_dt::text) != 8
OR sls_due_dt > 20500101
OR sls_due_dt < 19000101;

-- Check Invalid Date Orders
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

-- Check Data Consistency: Betwenn Sales, Quantity, and Price
--- >> Sales = Quantity * Price
--- >> Values must be not NULL, zero or negativa
SELECT DISTINCT
sls_sales AS old_sls_value,
sls_quantity,
sls_price AS old_sls_price,
CASE
	WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
	ELSE sls_sales
END AS sls_sales,
CASE
	WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity,1)
	ELSE sls_price
END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales < 0 OR sls_quantity < 0 OR sls_price < 0
ORDER BY sls_sales, sls_quantity, sls_price;


/*SILVER DQ*/
-- Check for Invalid Dates
SELECT
NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM silver.crm_sales_details
WHERE sls_due_dt <= 0 
OR LENGTH(sls_due_dt::text) != 8
OR sls_due_dt > 20500101
OR sls_due_dt < 19000101;

-- Check Invalid Date Orders
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

-- Check Data Consistency: Betwenn Sales, Quantity, and Price
--- >> Sales = Quantity * Price
--- >> Values must be not NULL, zero or negativa
SELECT DISTINCT
sls_ord_num,
sls_prd_key,
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales < 0 OR sls_quantity < 0 OR sls_price < 0
ORDER BY sls_sales, sls_quantity, sls_price;

