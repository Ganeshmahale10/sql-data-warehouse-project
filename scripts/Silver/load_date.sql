--EXEC silver.sp_load_silver

CREATE OR ALTER PROCEDURE silver.sp_load_silver AS
BEGIN 

  BEGIN TRY 
/* Truncating the table first then Applying Transformation on the data present in the bronze layer tables and then
inserting it into Silver layer tables 

Table Name : silver.crm_cust_info 

*/


	TRUNCATE Table silver.crm_cust_info;

	with cte as (
	select 
	*,
	ROW_NUMBER() over (partition by cst_id order by cst_create_date desc) as latest_record
	from bronze.crm_cust_info)

	Insert into silver.crm_cust_info (cst_id ,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_marital_status,
		cst_gndr,
		cst_create_date)

	select 
		cst_id ,
		cst_key ,
		TRIM(cst_firstname) as cst_firstname ,
		TRIM(cst_lastname) as cst_lastname ,
		CASE 
			when UPPER(TRIM(cst_marital_status)) = 'S' then 'Single'
			when UPPER(TRIM(cst_marital_status)) = 'M' then 'Married'
			else 'n/a'
		END cst_marital_status,

		CASE 
			when UPPER(TRIM(cst_gndr)) = 'M' then 'Male'
			when UPPER(TRIM(cst_gndr)) = 'F' then 'Female'
			else 'n/a'
		END cst_gndr,
		cst_create_date 
	from cte
	where latest_record = 1;


/* Applying Transformation on the data present in the bronze layer tables and then
inserting it into Silver layer tables 

Table Name : silver.crm_prd_info 

*/

	TRUNCATE Table silver.crm_prd_info;

	Insert into silver.crm_prd_info(
		prd_id,
		cat_id,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt )

	select 
		prd_id ,
		REPLACE(SUBSTRING(prd_key,1,5),'-','_') as cat_id,
		SUBSTRING(prd_key,7,LEN(prd_key)) as prd_key,
		prd_nm  ,
		ISNULL(prd_cost,0) as prd_cost,
		CASE UPPER(TRIM(prd_line))
			when 'R' then 'Road'
			when 'S' then 'Other Sales'
			when 'M' then 'Mountains'
			Else 'n/a'
		END as prd_line ,
		CAST(prd_start_dt as date) as prd_start_dt,
		CAST(LEAD(prd_start_dt) over(partition by prd_key order by prd_start_dt)-1 as date) as prd_end_dt
	from 
		bronze.crm_prd_info;


/* Applying Transformation on the data present in the bronze layer tables and then
inserting it into Silver layer tables 

Table Name : silver.crm_sales_details 

*/

	TRUNCATE Table silver.crm_sales_details;

	Insert into silver.crm_sales_details(
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt ,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price  )
	
	select 
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		case 
			when sls_order_dt = 0 or LEN(sls_order_dt) != 8 then NULL
			ELSE CAST(CAST(sls_order_dt as varchar) as date)
		END AS sls_order_dt,
		case 
			when sls_ship_dt = 0 or LEN(sls_ship_dt) != 8 then NULL
			ELSE CAST(CAST(sls_ship_dt as varchar) as date)
		END AS sls_ship_dt,
		case 
			when sls_due_dt = 0 or LEN(sls_due_dt) != 8 then NULL
			ELSE CAST(CAST(sls_due_dt as varchar) as date)
		END AS sls_due_dt,
		CASE when sls_sales IS NULL or sls_sales <= 0 or sls_sales != sls_quantity * ABS(sls_price)
			then sls_quantity * sls_price
			ELSE sls_sales
		END AS sls_sales,  
		sls_quantity,
		CASE when sls_price IS NULL or sls_price <= 0
			then sls_sales / ISNULL(sls_quantity,0)
			ELSE sls_price
		END AS sls_price
	from bronze.crm_sales_details;



/* Applying Transformation on the data present in the Bronze layer tables and then
inserting it into Silver layer tables 

Table Name : silver.erp_CUST_AZ12

*/

	TRUNCATE Table silver.erp_CUST_AZ12;

	Insert into silver.erp_CUST_AZ12(
		CID,
		BDATE,
		GEN )

	select 
		TRIM(REPLACE(CID,'NAS','')) AS CID,
		CASE when BDATE > GETDATE() then NULL
			 ELSE BDATE
		END AS BDATE,
		CASE when UPPER(TRIM(GEN)) = 'F' then 'Female'
			 when UPPER(TRIM(GEN)) = 'M' then 'Male'
			 when GEN IS NULL or GEN = '' then 'n/a'
			 ELSE GEN
		END AS GEN
	from bronze.erp_CUST_AZ12;



/* Applying Transformation on the data present in the bronze layer tables and then
inserting it into Silver layer tables 

Table Name : silver.erp_LOC_A101

*/

	TRUNCATE Table silver.erp_LOC_A101;

	INSERT into silver.erp_LOC_A101 (
		CID,
		CNTRY )

	select 
		TRIM(REPLACE(CID,'-','')) AS CID,
		CASE	
			WHEN TRIM(CNTRY) = 'DE' then 'Germany'
			WHEN TRIM(CNTRY) IN ('US','USA') then 'United States'
			WHEN TRIM(CNTRY) IS NULL or TRIM(CNTRY) = '' then 'n/a'
			ELSE TRIM(CNTRY)
		END AS CNTRY
	from bronze.erp_LOC_A101;


/*

Truncating the table first then Applying Transformation on the data present in the bronze layer tables and then
inserting it into Silver layer tables 

Table Name : silver.erp_PX_CAT_G1V2

*/

	TRUNCATE Table silver.erp_PX_CAT_G1V2;

	INSERT INTO silver.erp_PX_CAT_G1V2
		(ID ,
		CAT ,
		SUBCAT ,
		MAINTENANCE )

	select 
		ID,
		CAT ,
		SUBCAT ,
		MAINTENANCE 
	FROM bronze.erp_PX_CAT_G1V2;

  END TRY 
	
  BEGIN CATCH 

	  PRINT '==========================================='  
	  PRINT 'ERROR Occured while loading Silver tables'  
	  PRINT 'ERROR' + ERROR_Message();  
	  PRINT 'ERROR' + CAST(ERROR_NUMBER() as VARCHAR(50));  
	  PRINT 'ERROR' + CAST(ERROR_STATE() as varchar(50));  
	  PRINT '==========================================='  

  END CATCH
END





