/*===============================================================
  FILE:    etl_load_crm_prd_info.sql
  SCRIPT:  Bronze → Silver ETL – crm_prd_info
  AUTHOR:  Marcio Gabriel
  DATE:    2025-11-30

  PURPOSE:
      This script transforms and loads product data from the
      Bronze Layer into the Silver Layer. It performs cleansing,
      standardization, and derivation of business-ready fields.

  TRANSFORMATIONS INCLUDED:
      1. Category Derivation
         - Extract first 5 chars of prd_key and replace '-' with '_'.

      2. Product Key Normalization
         - Extract product key suffix from prd_key.

      3. Text Cleanup
         - Trim and standardize prd_line descriptions.

      4. Numeric Handling
         - Replace NULL product cost values with 0.

      5. Temporal Logic
         - Derive prd_end_dt using LEAD() to define effective periods.

  SOURCE:
      bronze.crm_prd_info

  TARGET:
      silver.crm_prd_info

===============================================================*/


INSERT INTO silver.crm_prd_info(
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)
SELECT
prd_id,
REPLACE(SUBSTRING(prd_key, 1, 5),'-','_') AS cat_id,
SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
prd_nm,
COALESCE(prd_cost, 0) AS prd_cost,
CASE UPPER(TRIM(prd_line))
	WHEN  'M' THEN 'Mountain'
	WHEN  'R' THEN 'Road'
	WHEN  'S' THEN 'Other Sales'
	WHEN  'T' THEN 'Touring'
	ELSE 'n/a'
END AS prd_line,
prd_start_dt,
LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS prd_end_dt
FROM bronze.crm_prd_info;