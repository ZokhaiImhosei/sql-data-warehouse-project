
/*
=====================================================================================
Quality Checks
=====================================================================================
Script purpose:
       This script performs quality checks to validate the intergrity, consistency 
       and accuracy of the Gold Layer. These checks ensure:
       - Uniqueness of surrogate keys in dimension tables.
       - Refeential integrity between faact and dimension tables.
       - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Run these checks after loading silver layer.
    - Investigate and resolve any discripancies found during the checks.
=====================================================================================
*/

-- ======================================================
-- Checking 'gold.dim_customer
-- ======================================================

--to verify for duplicates : after joining multiple tables,check if any duplicates were introduced by the join logic

SELECT cst_id, COUNT (*) FROM
(
	SELECT
	    ci.cst_id,
		ci.cst_key,
		ci.cst_firstname,
		ci.cst_lastname,
		ci.cst_marital_status,
		ci.cst_gndr,
		ci.cst_create_date,
		ca.bdate,
		ca.gen,
		la.cntry
FROM
silver.crm_cust_info ci
LEFT  JOIN silver.erp_cust_az12 ca
ON     ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON     ci.cst_key = la.cid
)t  GROUP BY cst_id
HAVING COUNT (*) > 1 
-- RESULT: the result from the query executed above shows no duplicates 

-- ======================================================
-- Checking 'gold.dim_products
-- ======================================================

--checking forr quality

SELECT prd_key, COUNT(*) FROM
(SELECT
	pn.prd_id,
	pn.cat_id,
	pn.prd_key,
	pn.prd_nm,
	pn.prd_cost,
	pn.prd_line,
	pn.prd_start_dt,
	pn.prd_end_dt,
	pc.cat,
	pc.subcat,
	pc.maintenance
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL -- Filter out all historical data
)t GROUP BY prd_key HAVING COUNT(*) > 1;

-- ======================================================
-- Checking 'gold.fact_sales
-- ======================================================

--Testing the intergrtiy of the keys

SELECT * FROM gold.fact_sales;

--FOREIGN KEY INTEGRITY (DIMENSIONS)
SELECT * FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
WHERE c.customer_key IS NULL

SELECT * FROM gold.fact_sales f
LEFT JOIN gold.dim_products P
ON p.product_key = f.product_key
WHERE p.product_key IS NULL


