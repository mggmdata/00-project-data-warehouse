/* ========================================================================
   File:        crm_cust_info_silver_etl.sql
   Purpose:     Load curated customer data into silver.crm_cust_info
   Author:      Marcio Gabriel
   Date:        2025-11-30

   Description:
       This script performs the Bronze → Silver transformation for
       CRM customer information. It applies:
         - Deduplication (latest record per customer)
         - Data cleaning (trim whitespace)
         - Data standardization (gender & marital status mapping)
         - Null handling and filtering
         - Final insert into the Silver layer

   Expected Result:
       Insert only the most recent and standardized records
       into silver.crm_cust_info.
   ======================================================================== */

INSERT INTO silver.crm_cust_info (
    cst_id,
    cst_key,
    cst_firstname,
    csf_lastname,
    cst_material_status,
    cst_gndr,
    cst_create_date
)
SELECT 
    cst_id,
    cst_key,
    TRIM(cst_firstname) AS cst_firstname,
    TRIM(csf_lastname) AS csf_lastname,
    CASE
        WHEN UPPER(TRIM(cst_material_status)) = 'S' THEN 'Single'
        WHEN UPPER(TRIM(cst_material_status)) = 'M' THEN 'Married'
        ELSE 'n/a'
    END AS cst_material_status,
    CASE
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN '_
