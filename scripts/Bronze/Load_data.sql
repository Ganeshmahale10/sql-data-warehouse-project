--EXEC bronze.sp_load_bronze

-- Bulk Upload of the data into table from .csv files

CREATE or ALTER PROCEDURE bronze.sp_load_bronze AS
BEGIN
	
	DECLARE @start_time DATETIME, @end_time DATETIME, @Batch_start_time DATETIME, @Batch_end_time DATETIME ;

	BEGIN TRY
		
		SET @Batch_start_time = GETDATE();
		--cust_info.csv

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_cust_info;

		BULK INSERT bronze.crm_cust_info 
		FROM 'E:\SQL\Barraaaa\Dataware house project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();

		PRINT '>> LOAD DURATION :' + cast(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR(20)) + ' SECONDS'
		--select * from bronze.crm_cust_info;


		--prd_info.csv

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_prd_info;

		BULK INSERT bronze.crm_prd_info 
		FROM 'E:\SQL\Barraaaa\Dataware house project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();

		PRINT '>> LOAD DURATION :' + cast(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR(20)) + ' SECONDS'
		--select * from bronze.crm_prd_info;


		--sales_details.csv

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_sales_details;

		BULK INSERT bronze.crm_sales_details 
		FROM 'E:\SQL\Barraaaa\Dataware house project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();

		PRINT '>> LOAD DURATION :' + cast(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR(20)) + ' SECONDS'
		--select * from bronze.crm_sales_details;


		--CUST_AZ12.csv

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_CUST_AZ12;

		BULK INSERT bronze.erp_CUST_AZ12 
		FROM 'E:\SQL\Barraaaa\Dataware house project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();

		PRINT '>> LOAD DURATION :' + cast(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR(20)) + ' SECONDS'
		--select * from bronze.erp_CUST_AZ12;


		--LOC_A101.csv

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_LOC_A101;

		BULK INSERT bronze.erp_LOC_A101 
		FROM 'E:\SQL\Barraaaa\Dataware house project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();

		PRINT '>> LOAD DURATION :' + cast(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR(20)) + ' SECONDS'
		--select * from bronze.erp_LOC_A101;


		--PX_CAT_G1V2.csv

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;

		BULK INSERT bronze.erp_PX_CAT_G1V2 
		FROM 'E:\SQL\Barraaaa\Dataware house project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();

		PRINT '>> LOAD DURATION :' + cast(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR(20)) + ' SECONDS'
		--select * from bronze.erp_PX_CAT_G1V2;

		SET @Batch_end_time = GETDATE();
		PRINT '======================================================================='
		PRINT 'LOADING OF THE BRONZE BATCH IS COMPLETED :'
		PRINT '>> BATCH LOAD DURATION :' + cast(DATEDIFF(second,@Batch_start_time,@Batch_end_time) AS NVARCHAR(20)) + ' SECONDS'
		PRINT '======================================================================='

	END TRY

	BEGIN CATCH
	
		PRINT '==========================================='
		PRINT 'ERROR Occured while loading Bronze tables'
		PRINT 'ERROR' + ERROR_Message();
		PRINT 'ERROR' + CAST(ERROR_NUMBER() as VARCHAR(50));
		PRINT 'ERROR' + CAST(ERROR_STATE() as varchar(50));
		PRINT '==========================================='

	END CATCH

END

