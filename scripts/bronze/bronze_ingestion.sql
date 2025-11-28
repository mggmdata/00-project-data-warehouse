/*******************************************************************************
 * FILE: bronze_ingestion.sql
 * PURPOSE: Loads raw CSV data into Bronze layer tables using the psql \copy
 * meta-command, and performs a basic row count validation check for
 * each loaded table.
 *
 * EXECUTION ENVIRONMENT:
 * This script MUST be executed via the **psql** command-line interface.
 * The \copy command requires client-side execution to read local files.
 *
 * OWNERSHIP:
 * DATA STEWARD: [Your Team/Group Name, e.g., Data Engineering - Ingestion]
 *
 * CHANGE LOG:
 * [2025-11-28] - [Your Name] - Initial creation. Added loads for crm_cust_info
 * and sales_transactions tables.
 *
 * USAGE INSTRUCTIONS:
 * 1. Ensure all CSV files are accessible to the user running psql.
 *
 ******************************************************************************/


/*
##### RUN THIS COMMANDS ON PSQL CLI  CHANGE THE FILE PATH #####

******************************************************************************

\copy bronze.crm_cust_info FROM 'C:\Users\Gabriel\Desktop\projects\00-project-data-warehouse\datasets\source_crm\cust_info.csv' WITH(FORMAT CSV,HEADER true);
\copy bronze.crm_prd_info FROM 'C:\Users\Gabriel\Desktop\projects\00-project-data-warehouse\datasets\source_crm\prd_info.csv' WITH(FORMAT CSV,HEADER true);
\copy bronze.crm_sales_details FROM 'C:\Users\Gabriel\Desktop\projects\00-project-data-warehouse\datasets\source_crm\sales_details.csv' WITH(FORMAT CSV,HEADER true);
\copy bronze.erp_cust_az12 FROM 'C:\Users\Gabriel\Desktop\projects\00-project-data-warehouse\datasets\source_erp\CUST_AZ12.csv' WITH(FORMAT CSV,HEADER true);
\copy bronze.erp_loc_a101 FROM 'C:\Users\Gabriel\Desktop\projects\00-project-data-warehouse\datasets\source_erp\loc_a101.csv' WITH(FORMAT CSV,HEADER true);
\copy bronze.erp_px_cat_g1v2 FROM 'C:\Users\Gabriel\Desktop\projects\00-project-data-warehouse\datasets\source_erp\PX_CAT_G1V2.csv' WITH(FORMAT CSV,HEADER true);

******************************************************************************

*/

-- Verify Files Total Rows
SELECT COUNT(*) AS "total_rows", 'crm_cust_info' AS "table" FROM bronze.crm_cust_info
UNION
SELECT COUNT(*) AS "total_rows", 'crm_prd_info' AS "table" FROM bronze.crm_prd_info
UNION 
SELECT COUNT(*) AS "total_rows", 'crm_sales_details' AS "table" FROM bronze.crm_sales_details
UNION
SELECT COUNT(*) AS "total_rows", 'erp_cust_az12' AS "table" FROM bronze.erp_cust_az12
UNION
SELECT COUNT(*) AS "total_rows", 'erp_loc_a101' AS "table" FROM bronze.erp_loc_a101
UNION
SELECT COUNT(*) AS "total_rows", 'erp_px_cat_g1v2' AS "table" FROM bronze.erp_px_cat_g1v2;
