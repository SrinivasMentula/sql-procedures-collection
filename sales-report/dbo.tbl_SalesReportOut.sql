/****** Object:  Table [dbo].[tbl_SalesReportOut]    Script Date: 4/7/2025 3:58:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_SalesReportOut](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Sale_Date] [date] NULL,
	[Branch] [varchar](20) NULL,
	[city] [varchar](20) NULL,
	[Total_Sales] [decimal](38, 10) NULL,
	[Total_Transactions] [bigint] NULL,
	[Average_Basket_Value] [decimal](38, 10) NULL,
	[productLine] [varchar](max) NULL,
	[Member_Count] [int] NULL,
	[Normal_Count] [int] NULL,
	[Payment_Cash] [int] NULL,
	[Payment_Credit] [int] NULL,
	[Payment_Ewallet] [int] NULL,
	[Sales_Male] [decimal](38, 2) NULL,
	[Sales_Female] [decimal](38, 2) NULL,
	[Total_Quantity_Sold] [decimal](38, 2) NULL,
	[Average_Rating] [decimal](9, 2) NULL,
	[GrossIncome] [decimal](38, 2) NULL,
	[Total_COGS] [int] NULL,
	[Gross_Margin_Percentage] [decimal](9, 2) NULL,
	[Hour_00] [decimal](38, 2) NULL,
	[Hour_01] [decimal](38, 2) NULL,
	[Hour_02] [decimal](38, 2) NULL,
	[Hour_03] [decimal](38, 2) NULL,
	[Hour_04] [decimal](38, 2) NULL,
	[Hour_05] [decimal](38, 2) NULL,
	[Hour_06] [decimal](38, 2) NULL,
	[Hour_07] [decimal](38, 2) NULL,
	[Hour_08] [decimal](38, 2) NULL,
	[Hour_09] [decimal](38, 2) NULL,
	[Hour_10] [decimal](38, 2) NULL,
	[Hour_11] [decimal](38, 2) NULL,
	[Hour_12] [decimal](38, 2) NULL,
	[Hour_13] [decimal](38, 2) NULL,
	[Hour_14] [decimal](38, 2) NULL,
	[Hour_15] [decimal](38, 2) NULL,
	[Hour_16] [decimal](38, 2) NULL,
	[Hour_17] [decimal](38, 2) NULL,
	[Hour_18] [decimal](38, 2) NULL,
	[Hour_19] [decimal](38, 2) NULL,
	[Hour_20] [decimal](38, 2) NULL,
	[Hour_21] [decimal](38, 2) NULL,
	[Hour_22] [decimal](38, 2) NULL,
	[Hour_23] [decimal](38, 2) NULL,
	[CreatedDateTime] [datetime] NULL,
 CONSTRAINT [pk_SalesReportOut_Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[tbl_SalesReportOut] ADD  DEFAULT (getdate()) FOR [CreatedDateTime]
GO


