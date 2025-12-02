/*=====================================================================================================================
 File:         silver_erp_cust_az12_etl.sql
 Author:       Marcio Gabriel
 Description:  
     Cleanses and standardizes customer attributes before loading into the Silver layer:
       - Normalizes Customer ID by removing 'NAS' prefix.
       - Validates birth dates, nullifying future dates.
       - Standardizes gender values (Male / Female / n/a).
 
 Source Table: bronze.erp_cust_az12
 Target Table: silver.erp_cust_az12

 Notes:
     • Designed for reproducible ELT pipelines.
     • Ensure upstream Bronze ingestion meets schema expectations.
=====================================================================================================================*/


INSERT INTO silver.erp_cust_az12 (
cid,
bdate,
gen
)
SELECT
CASE
	WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LENGTH(cid))
	ELSE cid
END AS cid,
CASE 
	WHEN bdate > CURRENT_DATE THEN NULL
	ELSE bdate
END AS bdate,
CASE
	WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
	WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
	ELSE 'n/a'
END AS gen
FROM bronze.erp_cust_az12;
