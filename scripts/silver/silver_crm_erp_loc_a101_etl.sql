/*=====================================================================================================================
 Project:      Medallion Architecture – Silver Layer Enrichment
 File:         silver_crm_erp_loc_a101_etl.sql
 Author:       Marcio Gabriel
 Description:  
     Cleanses and standardizes location attributes before loading into the Silver layer:
       - Removes hyphens from Customer ID.
       - Standardizes country values (Germany, United States, n/a).
 
 Source Table: bronze.erp_loc_a101
 Target Table: silver.erp_loc_a101

 Notes:
     • Ensures consistent location data for downstream analytics in the Gold layer.
     • Designed for maintainable and reproducible ELT pipelines.
=====================================================================================================================*/


INSERT INTO silver.erp_loc_a101 (
cid,
cntry
)
SELECT
REPLACE(cid, '-', '') AS cid,
CASE 
	WHEN TRIM(cntry) = 'DE' THEN 'Germany'
	WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
	WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
	ELSE cntry
END AS cntry
FROM bronze.erp_loc_a101;

