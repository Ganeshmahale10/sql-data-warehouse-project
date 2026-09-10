/* Tests to check the data quality of the bronze layer */


-- Table name : bronze.crm_cust_info

-- Check for duplicate and Null values 

select cst_id,COUNT(*) as cust_count from bronze.crm_cust_info
group by cst_id
having COUNT(*) > 1 AND cst_id is NULL


select * from bronze.crm_cust_info 
where cst_id is NULL


--check extra spaces in the data

select * from bronze.crm_cust_info
where cst_firstname != TRIM(cst_firstname)


select * from bronze.crm_cust_info
where cst_lastname != TRIM(cst_lastname)


-- Table name : bronze.crm_prd_info

select * from bronze.crm_prd_info where prd_key IN ('AC-HE-HL-U509-B','BI-MB-BK-M68B-46')

-- Check for duplicate and Null values 

select prd_id,count(*) as count_prd from bronze.crm_prd_info
group by prd_id
having count(*) > 1 

select * from bronze.crm_prd_info
where prd_id IS NULL


select prd_key,count(*) as count_prd from bronze.crm_prd_info
group by prd_key
having count(*) > 1 


-- Table name silver.erp_CUST_AZ12
--check for NAS in CID column

select * from silver.erp_CUST_AZ12
where CID like '%NAS%'

select Distinct GEN from silver.erp_CUST_AZ12
