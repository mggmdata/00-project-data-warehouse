/* ========================================================================
   File:        crm_cust_info_bronze_dq.sql
   Purpose:     Data Quality Checks for bronze.crm_cust_info
   Author:      Marcio Gabriel
   Date:        2025-11-30

   Description:
       This script validates the raw CRM customer data stored in the
       Bronze layer. It checks for:
         - Null or duplicate primary keys
         - Unwanted blank spaces in text fields
         - Data standardization patterns before Silver transformation

   Expected Result:
       All queries should return zero rows unless data issues exist.
   ======================================================================== */

-- Check For Nulls or Duplicates in Primary Key
-- Expectation: No Result
SELECT  
    cst_id,
    COUNT(*)
FROM bronze.crm_cust_info 
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for Unwanted Spaces in First Name
-- Expectation: No Result
SELECT cst_firstname 
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- Check for Unwanted Spaces in Gender
-- Expectation: No Result
SELECT cst_gndr 
FROM bronze.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

-- Data Standardization & Consistency: Gender Values
SELECT DISTINCT cst_gndr 
FROM bronze.crm_cust_info;

-- Data Standardization & Consistency: Marital Status Values
SELECT DISTINCT cst_material_status 
FROM bronze.crm_cust_info;
