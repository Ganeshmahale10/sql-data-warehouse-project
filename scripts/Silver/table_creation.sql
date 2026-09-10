/* 

DDL statements to create all the tables for Silver layer

It first checks whether the table already exist or not 
if exist then drop the same and create the new one

*/

--create crm_cust_info table
--cst_id	cst_key	cst_firstname	cst_lastname	cst_marital_status	cst_gndr	cst_create_date

IF OBJECT_ID('silver.crm_cust_info','U') IS NOT NULL
	DROP TABLE silver.crm_cust_info;

create table silver.crm_cust_info(
	
	cst_id int,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_lastname nvarchar(50),
	cst_marital_status  nvarchar(50),
	cst_gndr  nvarchar(50),
	cst_create_date date
	dwh_create_date datetime2 DEFAULT Getdate()
);

--create crm_prd_info table
--prd_id	prd_key	prd_nm	prd_cost	prd_line	prd_start_dt	prd_end_dt

IF OBJECT_ID('silver.crm_prd_info','U') IS NOT NULL
	DROP TABLE silver.crm_prd_info;

create table silver.crm_prd_info(
	
	prd_id  int,
	cat_id nvarchar(50),
	prd_key nvarchar(50),
	prd_nm  nvarchar(50),
	prd_cost int,
	prd_line nvarchar(50),
	prd_start_dt date,
	prd_end_dt date,
	dwh_create_date datetime2 DEFAULT Getdate()
);

--create crm_sales_details table
--sls_prd_key	sls_cust_id	sls_order_dt	sls_ship_dt	sls_due_dt	sls_sales	sls_quantity	sls_price

IF OBJECT_ID('silver.crm_sales_details','U') IS NOT NULL
	DROP TABLE silver.crm_sales_details;

create table silver.crm_sales_details(
	
	sls_ord_num nvarchar(50),
	sls_prd_key nvarchar(50),
	sls_cust_id int,
	sls_order_dt  Date,
	sls_ship_dt Date,
	sls_due_dt  Date,
	sls_sales  int,
	sls_quantity  int,
	sls_price  int,
	dwh_create_date datetime2 DEFAULT Getdate()
);


--create silver.erp_LOC_A101 table 
--CID	CNTRY

IF OBJECT_ID('silver.erp_LOC_A101','U') IS NOT NULL
	DROP TABLE silver.erp_LOC_A101;

create table silver.erp_LOC_A101(
	CID nvarchar(50),
	CNTRY nvarchar(50),
	dwh_create_date datetime2 DEFAULT Getdate()
);



--create silver.erp_CUST_AZ12 table 
--CID	BDATE	GEN

IF OBJECT_ID('silver.erp_CUST_AZ12','U') IS NOT NULL
	DROP TABLE silver.erp_CUST_AZ12;

create table silver.erp_CUST_AZ12(
	
	CID  nvarchar(50),
	BDATE date,
	GEN nvarchar(50),
	dwh_create_date datetime2 DEFAULT Getdate()

);


--create silver.erp_PX_CAT_G1V2 table 
--ID	CAT	SUBCAT	MAINTENANCE

IF OBJECT_ID('silver.erp_PX_CAT_G1V2','U') IS NOT NULL
	DROP TABLE silver.erp_PX_CAT_G1V2;

create table silver.erp_PX_CAT_G1V2(
	
	ID nvarchar(50),
	CAT nvarchar(50),
	SUBCAT nvarchar(50),
	MAINTENANCE nvarchar(50),
	dwh_create_date datetime2 DEFAULT Getdate()
);


