/* ===========================================================================================
   Project: Enterprise Sales Analytics Platform
   Layer:   Bronze ➜ Silver (Data Standardization & Business Rule Enforcement)
   Script:  CRM Sales Details Transformation

   Description:
     This transformation loads raw CRM sales records from the Bronze layer into the
     curated Silver layer. It standardizes date fields, applies business logic to ensure
     data quality, and enforces consistent numeric calculations used by downstream
     analytical models and Power BI dashboards.

   Key Processing Rules:
     - Date Normalization:
       Converts raw integer date fields (YYYYMMDD) into proper DATE types.
       Invalid or malformed values (0, incorrect length) are cast to NULL.

     - Sales Amount Reconciliation:
       Validates `sls_sales`. If missing, non-positive, or inconsistent with
       `quantity * price`, the value is recalculated to ensure accuracy.

     - Price Standardization:
       Recomputes `sls_price` when missing or invalid by dividing sales value
       by quantity (protecting against divide-by-zero).

   Why This Matters (Best Practices):
     - Ensures trusted, analytics-ready data for finance, CRM, and operations.
     - Aligns with medallion architecture standards used by modern data platforms.
     - Guarantees schema consistency for BI tools, ML pipelines, and data products.
     - Reduces downstream reprocessing caused by corrupted or incomplete source data.

   Author: Marcio Gabriel
   Last Updated: 2025-12-01
   =========================================================================================== */



INSERT INTO silver.crm_sales_details (
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
)
SELECT
sls_ord_num,
sls_prd_key,
sls_cust_id,
CASE 
	WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt::text) != 8 THEN NULL
	ELSE TO_DATE(sls_order_dt::text, 'YYYYMMDD')
END AS sls_order_dt,
CASE 
	WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt::text) != 8 THEN NULL
	ELSE TO_DATE(sls_ship_dt::text, 'YYYYMMDD')
END AS sls_ship_dt,
CASE 
	WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt::text) != 8 THEN NULL
	ELSE TO_DATE(sls_due_dt::text, 'YYYYMMDD')
END AS sls_due_dt,
CASE
	WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
	ELSE sls_sales
END AS sls_sales,
sls_quantity,
CASE
	WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity,0)
	ELSE sls_price
END AS sls_price
FROM bronze.crm_sales_details;