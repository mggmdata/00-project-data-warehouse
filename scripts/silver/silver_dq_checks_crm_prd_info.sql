/*===============================================================
  FILE:    dq_checks_crm_prd_info.sql
  SCRIPT:  Data Quality Validation – crm_prd_info (Silver Layer)
  AUTHOR:  Marcio Gabriel
  DATE:    2025-11-30

  PURPOSE:
      This script performs data quality checks on the Silver Layer
      table: silver.crm_prd_info. The validations ensure data 
      integrity, consistency, and readiness for consumption in 
      analytics and downstream layers.

  CHECKS INCLUDED:
      1. Primary Key Integrity
         - Detect NULLs or duplicate prd_id values.

      2. Text Standardization
         - Detect leading/trailing spaces in prd_nm.

      3. Numeric Validation
         - Detect NULL or negative values in prd_cost.

      4. Data Standardization
         - Review distinct values for prd_line.

      5. Temporal Consistency
         - Detect invalid date ranges (prd_end_dt < prd_start_dt).

  EXPECTATION:
      All checks should return zero rows.
===============================================================*/


-- Check For Nulls Or Duplicates in Primery Key
-- Expectation: No Result
SELECT
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1;

-- Check for unwanted Spaces
-- Expactation: No Results
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);


-- Check for nulls or Negatives Numbers
--- Expactation: No Results
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data Standarnization & Consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

-- Check Invalid Data Orders
SELECT * 
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;