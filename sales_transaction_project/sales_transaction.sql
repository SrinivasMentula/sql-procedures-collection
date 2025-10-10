/*

 Author : Srinivas Menthula 
 Date : 10/10/2025 (DD/MM/YYYY)


*/

USE [sample_one]

GO

IF NOT EXISTS 
(
SELECT 1 FROM sys.tables
where name  =   'sales_inbound'

)
BEGIN 
CREATE TABLE dbo.sales_inbound 
(
    id  bigint identity ,
	transaction_id  int ,
	transaction_date date,
	shopcode varchar(10),
	productId int ,
	quantity  int,
	unitPrice  decimal(10,2),
	payment_method  varchar(20),
	currency  varchar(5),
	discount   decimal(5,2)
	constraint pk_sales_inbound primary key  (shopcode,transaction_id)
)

END

GO
-------------------------------------------------------------------------------------

--Table creation for the conversition data 

IF NOT EXISTS 
(
SELECT 1 FROM 
sys.tables
where name = 'sales_conversition_data'
)

BEGIN

CREATE TABLE dbo.sales_conversition_data
(
	id bigint  identity  , 
	currency varchar(20),
	conversionRate Decimal(12,6),
	start_date date ,
	end_date  date,
	isActive  char(1) , 
	updatedAt datetime default getdate()

)

END


GO
-------------------------------------------------------------
--Table creation for the outbound table data 



IF NOT EXISTS 
(
	SELECT 1  FROM sys.tables
	where name = 'sales_report' and SCHEMA_ID = SCHEMA_ID('dbo')
)
BEGIN 
CREATE TABLE   dbo.sales_report
(
ReportDate date ,
ShopCode varchar(20),
TotalQuantity  int ,
"TotalSales(USD)" decimal(9,2),
PaymentMethod varchar(20),
currency  varchar(20),
"AvgTransactionValue (USD)" decimal(9,2)

)

END

GO
------------------------------------------------------------------------------------
-- CONVERSITION DAILY TABLE WHCIH IS USED TO STORE THE UPDATED VALUES  OF  ALL THE CONVERSITIONS 
if not exists 
(
SELECT 1 FROM sys.tables
where name = 'sales_conversition_daily_inbond' and schema_id = schema_id('dbo')
)
BEGIN 

	CREATE TABLE  dbo.sales_conversition_daily_inbond
(
 id  int identity, 
 currency varchar(20),
 conversionRate decimal(9,2),
 reported_date  date default  cast(getdate() as date)
)
END 

GO
------------------------------------------------------------------------------------------------

--Creation of execption  capture table

IF NOT EXISTS 
(

	SELECT * FROM sys.tables  where name = 'sales_exception' and schema_id = schema_id('dbo')


)
BEGIN 

CREATE TABLE dbo.sales_exception
(
id  bigint identity , 
module_name  varchar(120),
error_msg varchar(max),
created_date  datetime  default  getdate()
)

END 

GO 

-------------------------------------------------------------------------------------------------------------
--Creation of the execution tracking log table 

IF NOT EXISTS 

(

	SELECT 1 FROM SYS.tables
	WHERE NAME = 'sales_execution_log '
	AND SCHEMA_ID = SCHEMA_ID('DBO')


)

BEGIN 

CREATE TABLE dbo.sales_execution_log 
(
  id bigint identity ,
  module_name varchar(120),
  "status" varchar(10) , 
  Reported_date datetime default getdate()
)

END

---------------------------------------------------------------------

GO
CREATE OR ALTER Procedure dbo.usp_sales_conversition_update
AS

BEGIN 

    DECLARE @module_name  varchar(120)= 'dbo.usp_sales_conversition_update'


	BEGIN TRY 

		BEGIN TRAN conversitionRate 

			DROP  TABLE IF EXISTS #temp_modified_conversionRates

				SELECT 
					scd.currency as currency , 
					scid.conversionRate as  updated_rate ,
					scid.reported_date as end_date
					into 
					#temp_modified_conversionRates
				FROM 
					dbo.sales_conversition_data scd
					inner join 
					sales_conversition_daily_inbond scid 

				on (scd.currency = scid.currency 
					and  CAST (scd.conversionRate AS decimal(9,2)) <> cast (scid.conversionRate as decimal(9,2))
					)
                   WHERE isActive = 'Y'
			-- Updating the sales_conversition_data setting the modfied currency falg to N and end date

			update dbo.sales_conversition_data
	       
				   set end_date = tdc.end_date,
					   isActive = 'N',
					   updatedAt = GETDATE()
				   from 
					   sales_conversition_data scd 
					   join  #temp_modified_conversionRates tdc 
				   on scd.currency = tdc.currency
				   where scd.isActive = 'Y'

			---Inserting the  new conversition rate

			INSERT INTO dbo.sales_conversition_data
			(
				currency,
				conversionRate,
				start_date,
				end_date,
				isActive , 
				updatedAt
			)
			SELECT 
			  currency,
			  updated_rate,
			  cast(getdate() as date),
			  NULL,
			  'Y',
			  GETDATE()
			  from #temp_modified_conversionRates tmc

			  INSERT INTO dbo.sales_execution_log 
			  (
			  module_name,
			  status,
			  Reported_date
			  )
			  values
			  (
			      @module_name, 
				  'Success',
				  GETDATE()

			  )

		COMMIT TRAN conversitionRate

	END TRY 
	BEGIN CATCH 
	IF @@TRANCOUNT > 0 
	BEGIN 
	  ROLLBACK TRAN conversitionRate
	END
	INSERT INTO dbo.dbo.sales_exception
	(
	module_name ,
	error_msg
	)
	values 
	(
	 @module_name,
	 ERROR_MESSAGE()
	)
	
	 INSERT INTO dbo.sales_execution_log 
			  (
			  module_name,
			  status,
			  Reported_date
			  )
			  values
			  (
			      @module_name, 
				  'Fail',
				  GETDATE()
			  );
	THROW;

	END CATCH 

END 

-------------------------------------------------------------------------
Go 
IF NOT EXISTS
(

SELECT 1 FROM sys.database_principals 
where name = 'Truncate_proxy' and type = 'S'

)
BEGIN 

CREATE USER Truncate_proxy without login

END 

GRANT ALTER ON dbo.sales_report to Truncate_proxy

---------------------

USE [sample_one]
GO

/****** Object:  StoredProcedure [dbo].[usp_truncate_table_with_proxy]    Script Date: 10/10/2025 3:13:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Understanding the transcation handling in the nested procedure 


CREATE   OR ALTER     procedure [dbo].[usp_truncate_table_with_proxy]  
( @tablename nvarchar(20), @schemaname nvarchar(30))
with execute as 'Truncate_proxy'  
as   
begin   

Declare @sql nvarchar(max)

--declare @tablename nvarchar(20) = N'employees_two'
--Declare @Schemaname nvarchar(20) = N'dbo'


			
SET @sql = 	 N'IF EXISTS 	(SELECT * FROM sys.tables 
				where object_id = OBJECT_ID('''+@tablename+'''))
				
				BEGIN 

				Truncate table '+@Schemaname +'.'+@tablename+'
			    END '
  exec( @sql)
end


GO





GO

/*
 Author : 'Srinivas Mentula'
 Descrption: This will write the aggregated sales data into the sales out report table   by the curreny reference from the currency converstion 
 Date   2025/10/10
*/

CREATE OR ALTER procedure  dbo.usp_sales_report

AS

BEGIN 

	DECLARE @module_name varchar(20) = 'dbo.usp_sales_report'

	BEGIN TRY 

	BEGIN TRAN SALES_REPORT

--- CREATING TEMP TABLE THAT WILL HAVE THE NET  VALUE OF THE TRANSACTION AFTER DEDUCTING the unitPrice and Discount4
   drop table if exists #temp_sales_converted_data
	SELECT 
		TRANSACTION_ID , 
		transaction_date,
		shopcode,
		productId,
		quantity,
		unitPrice,
		payment_method,
		discount ,
		cast ((unitPrice-discount) as decimal(9,2)) as NetPrice,
		t2.currency AS curreny_region,
		Cast (t2.conversionRate as decimal(9,2)) as conversionRate, 
		cast ((unitPrice-discount) * t2.conversionRate as decimal(9,2))  as NetPriceInUSD
		INTO #temp_sales_converted_data
	FROM dbo.sales_inbound t1
		left join dbo.sales_conversition_data t2
	on 
		(t1.currency = t2.currency 
		and t1.transaction_date >= t2.start_date
		 and (t1.transaction_date<=  dateadd(day,-1,t2.end_date) or t2.end_date is null
			 ))
	---Finding the aggregated date  based on the transaction date ,shop code , mode of payment 
	--Truncating the sales_report_table before_ingesting_the data 


	exec  [dbo].[usp_truncate_table_with_proxy] @tablename  = 'sales_report' , @schemaname = 'dbo'

	--Truncating the table using the proxy user 


		insert into dbo.sales_report 
			(
			ReportDate,
			ShopCode,
			TotalQuantity,
			"TotalSales(USD)",
			PaymentMethod, 
			currency ,
			"AvgTransactionValue (USD)"
			)
		SELECT 
		  transaction_date as reportDate,
		  ShopCode , 
		  sum(quantity) as TotalQuantity ,
		  sum(netPriceInUSD) as "TotalSales(USD)",
		  payment_method,
		  'USD' as currency,
		  avg(netPriceInUSD) as "AvgTransactionValue (USD)"
		fROM #temp_sales_converted_data
		GROUP BY 
			transaction_date , shopcode ,payment_method
		INSERT INTO dbo.sales_execution_log 
		(
		module_name,
		status,
		Reported_date
		)
		values
		(
			@module_name, 
			'Success',
			GETDATE()
		)

	COMMIT TRAN  SALES_report 
	END TRY 
	BEGIN CATCH 
			IF @@TRANCOUNT > 0 
				BEGIN 
					ROLLBACK TRAN SALES_REPORT
				END 
			INSERT INTO dbo.dbo.sales_exception
			(
			module_name ,
			error_msg
			)
			values 
			(
			 @module_name,
			 ERROR_MESSAGE()
			)
	
			 INSERT INTO dbo.sales_execution_log 
					  (
					  module_name,
					  status,
					  Reported_date
					  )
					  values
					  (
						  @module_name, 
						  'Fail',
						  GETDATE()
					  );
			THROW;
	END CATCH 

END 







