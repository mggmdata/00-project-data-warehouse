/* ========================================================================
   File:        crm_cust_info_data_quality.sql
   Purpose:     Data Quality Checks for silver.crm_cust_info
   Author:     	Marcio Gabriel
   Date:        <2025-11-30>

   Description:
       This script performs data validation checks on the 
       silver.crm_cust_info table to ensure:
         - No duplicates or nulls in primary keys
         - No trailing or leading spaces in text fields
         - Proper data standardization and consistency

   Expected Result:
       All queries should return zero rows unless data issues exist.
   ======================================================================== */

SELECT * FROM silver.crm_cust_info LIMIT 100;

-- Check For Nulls or Duplicates in Primary Key
-- Expected: No Result
SELECT  
    cst_id,
    COUNT(*)
FROM silver.crm_cust_info 
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for Unwanted Spaces (firstname)
-- Expected: No Result
SELECT cst_firstname 
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- Check for Unwanted Spaces (gender)
-- Expected: No Result
SELECT cst_gndr 
FROM silver.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

-- Data Standardization & Consistency (gender)
SELECT DISTINCT cst_gndr 
FROM silver.crm_cust_info;

-- Data Standardization & Consistency (material status)
SELECT DISTINCT cst_material_status 
FROM silver.crm_cust_info;
