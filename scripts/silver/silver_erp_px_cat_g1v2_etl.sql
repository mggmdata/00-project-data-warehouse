/*=====================================================================================================================
 Project:      Medallion Architecture – Silver Layer Enrichment
 File:         silver_erp_px_cat_g1v2_etl.sql
 Author:       Marcio Gabriel
 Description:  
     Promotes raw product category data from Bronze to Silver with structural validation:
       - Ensures consistent schema for product category hierarchy (category, subcategory).
       - Prepares standardized attributes for downstream consumption.
 
 Source Table: bronze.erp_px_cat_g1v2
 Target Table: silver.erp_px_cat_g1v2

 Notes:
     • No transformations applied — passthrough load.
     • Silver layer guarantees clean, structured, ready-for-analytics data.
=====================================================================================================================*/


INSERT INTO silver.erp_px_cat_g1v2(
id,
cat,
subcat,
maintence
)
SELECT
id,
cat,
subcat,
maintence
FROM bronze.erp_px_cat_g1v2;
