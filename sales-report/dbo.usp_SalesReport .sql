/****** Object:  StoredProcedure [dbo].[usp_SalesReport]    Script Date: 4/7/2025 4:08:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create or alter  proc [dbo].[usp_SalesReport] 
as 
	begin 
		set nocount on

		/*variable declartion for logging*/

		declare @row_COUNT int,
				@ErrorMessage varchar(MAX)

		/*Intialasing the try block*/

		begin try 
			begin tran salesReport
		/* Temp_table creation for the  BaseCalucaltions*/
			drop table if exists #temp_1
						
						create table #temp_1
						(
							sales_date date,
							Branch varchar(20),
							City varchar(20),
							Total_Sales Decimal(38,2),
							Total_Transactions Decimal(38,2),
							Average_Basket_Value Decimal(38,2),
							Member_COUNT int,
							Normal_COUNT int,
							Payment_Cash int,
							Payment_Credit int,
							Payment_Ewallet int,
							Sales_Male int,
							Sales_Female int,
							Total_Quantity_Sold int,
							Average_Rating decimal(38,2),
							GrossIncome decimal(38,2),
							Total_COGS decimal(38,2),
							Gross_Margin_Percentage decimal(38,2), 
							HOUR_00 decimal(38,2),
							HOUR_01 decimal(38,2),
							HOUR_02 decimal(38,2),
							HOUR_03 decimal(38,2),
							HOUR_04 decimal(38,2),
							HOUR_05 decimal(38,2),
							HOUR_06 decimal(38,2),
							HOUR_07 decimal(38,2),
							HOUR_08 decimal(38,2),
							HOUR_09 decimal(38,2),
							HOUR_10 decimal(38,2),
							HOUR_11 decimal(38,2),
							HOUR_12 decimal(38,2),
							HOUR_13 decimal(38,2),
							HOUR_14 decimal(38,2),
							HOUR_15 decimal(38,2),
							HOUR_16 decimal(38,2),
							HOUR_17 decimal(38,2),
							HOUR_18 decimal(38,2),
							HOUR_19 decimal(38,2),
							HOUR_20 decimal(38,2),
							HOUR_21 decimal(38,2),
							HOUR_22 decimal(38,2),
							HOUR_23 decimal(38,2)

						)

						create clustered index idx_#temp_1_sales_date_branch on #temp_1 (sales_date,Branch)
	
						insert into #temp_1
						(
							Sales_Date,
							Branch,
							City,
							Total_Sales,
							Total_Transactions,
							Average_Basket_Value,
							Member_COUNT,
							Normal_COUNT,
							Payment_Cash,
							Payment_Credit,
							Payment_Ewallet,
							Sales_Male,
							Sales_Female,
							Total_Quantity_Sold,
							Average_Rating,
							GrossIncome,
							Total_COGS,
							Gross_Margin_Percentage,
							HOUR_00,
							HOUR_01,
							HOUR_02,
							HOUR_03,
							HOUR_04,
							HOUR_05,
							HOUR_06,
							HOUR_07,
							HOUR_08,
							HOUR_09,
							HOUR_10,
							HOUR_11,
							HOUR_12,
							HOUR_13,
							HOUR_14,
							HOUR_15,
							HOUR_16,
							HOUR_17,
							HOUR_18,
							HOUR_19,
							HOUR_20,
							HOUR_21,
							HOUR_22,
							HOUR_23

							)
		
						select 
							Date as Sales_Date,
							Branch ,
							city,
							CAST(SUM(Total) as decimal(38,2)) as Total_Sales ,
							COUNT(invoiceId) as Total_Transactions,
							SUM(Total)/ COUNT(invoiceId) as Average_Basket_Value ,
							SUM (CASE WHEN Customer = 'Member' THEN 1 ELSE 0 END )  as Member_COUNT ,
							SUM (CASE WHEN Customer != 'Member' THEN 1 ELSE 0 END ) as Normal_COUNT,
							COUNT(CASE WHEN Payment = 'Cash' THEN 1 ELSE 0 END)  as Payment_Cash,
							COUNT(CASE WHEN Payment = 'Credit card' THEN 1 ELSE 0 END)  as Payment_Credit,
							COUNT(CASE WHEN Payment = 'Ewallet' THEN 1 ELSE 0 END)  as Payment_Ewallet,
							SUM( CASE WHEN GENDer = 'Male' THEN Total ELSE 0 END) as Sales_Male,
							SUM( CASE WHEN GENDer = 'Female' THEN Total ELSE 0 END) as Sales_Female,
							SUM(Qty) as Total_Quantity_Sold,
							CAST(avg(Rating) as decimal(38,2)   )as Average_Rating,
							SUM(Total) as GrossIncome,
							0 as  Total_COGS,
							CAST(avg(GrossMargin)  as Decimal(38,2 )) as Gross_Margin_Percentage,
							SUM(CASE WHEN DATEPART(HOUR,time) =0 THEN total ELSE 0 END) as HOUR_0,
							SUM(CASE WHEN DATEPART(HOUR,time) =1 THEN total ELSE 0 END) as HOUR_1,
							SUM(CASE WHEN DATEPART(HOUR,time) =2 THEN total ELSE 0 END ) as HOUR_2,
							SUM(CASE WHEN DATEPART(HOUR,time) =3 THEN total ELSE 0 END ) as HOUR_3,
							SUM(CASE WHEN DATEPART(HOUR,time) =4 THEN total ELSE 0 END ) as HOUR_4,
							SUM(CASE WHEN DATEPART(HOUR,time) =5 THEN total ELSE 0 END ) as HOUR_5,
							SUM(CASE WHEN DATEPART(HOUR,time) =6 THEN total ELSE 0 END ) as HOUR_6,
							SUM(CASE WHEN DATEPART(HOUR,time) =7 THEN total ELSE 0 END ) as HOUR_7,
							SUM(CASE WHEN DATEPART(HOUR,time) =8 THEN total ELSE 0 END ) as HOUR_8,
							SUM(CASE WHEN DATEPART(HOUR,time) =9 THEN total ELSE 0 END ) as HOUR_9,
							SUM(CASE WHEN DATEPART(HOUR,time) =10 THEN total ELSE 0 END  ) as HOUR_10,
							SUM(CASE WHEN DATEPART(HOUR,time) =11 THEN total ELSE 0 END ) as HOUR_11,
							SUM(CASE WHEN DATEPART(HOUR,time) =12 THEN total ELSE 0  END) as HOUR_12,
							SUM(CASE WHEN DATEPART(HOUR,time) =13THEN total ELSE 0 END ) as HOUR_13,
							SUM(CASE WHEN DATEPART(HOUR,time) =14THEN total ELSE 0 END) as HOUR_14,
							SUM(CASE WHEN DATEPART(HOUR,time) =15THEN total ELSE 0 END ) as HOUR_15,
							SUM(CASE WHEN DATEPART(HOUR,time) =16 THEN total ELSE 0 END ) as HOUR_16,
							SUM(CASE WHEN DATEPART(HOUR,time) =17 THEN total ELSE 0  END) as HOUR_17,
							SUM(CASE WHEN DATEPART(HOUR,time) =18 THEN total ELSE 0 END ) as HOUR_18,
							SUM(CASE WHEN DATEPART(HOUR,time) =19THEN total ELSE 0 END ) as HOUR_19,
							SUM(CASE WHEN DATEPART(HOUR,time) =20 THEN total ELSE 0 END ) as HOUR_20,
							SUM(CASE WHEN DATEPART(HOUR,time) =21 THEN total ELSE 0 END) as HOUR_21,
							SUM(CASE WHEN DATEPART(HOUR,time) =22THEN total ELSE 0 END ) as HOUR_22,
							SUM(CASE WHEN DATEPART(HOUR,time) =23 THEN total ELSE 0 END ) as HOUR_23
						from 						
							dbo.tbl_SalesImport
						group by 
							Date ,
							Branch ,
							city

					/*creation of temp table for getting the Product Line which has highest sales */
						drop table if exists #temp_t2

						create table #temp_t2 (
							sales_Date date,
							branch varchar(20),
							city varchar(20),
							productLine varchar(100),
							"ProductRank" int

						)
					
						CREATE NONCLUSTERED INDEX idx_temp_t2_rank1
						ON #temp_t2 (sales_date, branch)
						INCLUDE (productLine)
						WHERE ProductRank = 1

						insert into #temp_t2
							(
								sales_date,
								branch,
								city,
								productLine,
								ProductRank
			
							)
								select  
									date as Sales_Date, 
									branch,
									city, 
									productLine,
									--SUM(Total) as Total_SalesPerProduct,
									DENSE_RANK() over( partition by date,branch order by SUM(Total) Desc) as "ProductRank"
								from dbo.tbl_SalesImport
								group by 
									date, 
									branch,
									city,
									productline

						truncate table dbo.tbl_SalesReportOut

						insert into dbo.tbl_SalesReportOut 
							(

								Sale_Date,
								Branch,
								City,
								Total_Sales,
								Total_Transactions,
								Average_Basket_Value,
								productLine,
								Member_COUNT,
								Normal_COUNT,
								Payment_Cash,
								Payment_Credit,
								Payment_Ewallet,
								Sales_Male,
								Sales_Female,
								Total_Quantity_Sold,
								Average_Rating,
								GrossIncome,
								Total_COGS,
								Gross_Margin_Percentage,
								HOUR_00,
								HOUR_01,
								HOUR_02,
								HOUR_03,
								HOUR_04,
								HOUR_05,
								HOUR_06,
								HOUR_07,
								HOUR_08,
								HOUR_09,
								HOUR_10,
								HOUR_11,
								HOUR_12,
								HOUR_13,
								HOUR_14,
								HOUR_15,
								HOUR_16,
								HOUR_17,
								HOUR_18,
								HOUR_19,
								HOUR_20,
								HOUR_21,
								HOUR_22,
								HOUR_23


							)


						select 
							distinct
							t1.sales_date,
							t1.branch,
							t1.city,
							t1.total_sales,
							t1.total_transactions,
							t1.average_basket_value,
							t2.productline as top_selling_product_line,
							t1.member_count,
							t1.normal_count,
							t1.payment_cash,
							t1.payment_credit,
							t1.payment_ewallet,
							t1.sales_male,
							t1.sales_female,
							t1.total_quantity_sold,
							t1.average_rating,
							t1.grossincome,
							total_cogs,
							t1.gross_margin_percentage,
							t1.hour_00,
							t1.hour_01,
							t1.hour_02,
							t1.hour_03,
							t1.hour_04,
							t1.hour_05,
							t1.hour_06,
							t1.hour_07,
							t1.hour_08,
							t1.hour_09,
							t1.hour_10,
							t1.hour_11,
							t1.hour_12,
							t1.hour_13,
							t1.hour_14,
							t1.hour_15,
							t1.hour_16,
							t1.hour_17,
							t1.hour_18,
							t1.hour_19,
							t1.hour_20,
							t1.hour_21,
							t1.hour_22,
							t1.hour_23
						from #temp_1 t1 
						left outer join #temp_t2 t2 
							on t1.sales_date = t2.sales_date and t1.branch = t2.branch
						where t2.productrank= 1
						
						set @row_COUNT = @@ROWCOUNT

						insert  into  dbo.ExecutionLog
						(
							LogDate,
							ProcedureName,
							RowsAffected,
							[Status]

						)
						values 
						(
							GETDATE(),
							'dbo.usp_SalesReport',
							@row_COUNT,
							'Successs'
						);
					commit tran salesreport;
				END try 
			begin  catch
				if	@@TRANCOUNT > 0
					rollback ;
				set @ErrorMessage = ERROR_MESSAGE()
				insert  into  dbo.ExecutionLog
						(
							LogDate,
							ProcedureName,
							RowsAffected,
							[Status]

						)
						values 
						(
							GETDATE(),
							'dbo.usp_SalesReport',
							@@ROWCOUNT,
							'Failed'
						);

						insert into dbo.ExceptionLog
								(
									Sp_Name,
									ErrorMessage

								)
						values
							(
								 'dbo.usp_SalesReport',
								 @ErrorMessage
							);


				throw;
		END catch;
	END;



