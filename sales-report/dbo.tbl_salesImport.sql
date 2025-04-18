/****** Object:  Table [dbo].[tbl_salesImport]    Script Date: 4/7/2025 3:34:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_salesImport](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[InvoiceID] [varchar](200) NULL,
	[Branch] [varchar](5) NULL,
	[City] [varchar](100) NULL,
	[Customer] [varchar](100) NULL,
	[Gender] [varchar](10) NULL,
	[productLine] [varchar](100) NULL,
	[UnitPrice] [decimal](9, 2) NULL,
	[Qty] [int] NULL,
	[Tax] [decimal](9, 2) NULL,
	[Total] [decimal](30, 2) NULL,
	[Date] [date] NULL,
	[Time] [time](7) NULL,
	[Payment] [varchar](max) NULL,
	[Cogs] [varchar](20) NULL,
	[GrossMargin] [decimal](9, 2) NULL,
	[GrossIncome] [decimal](9, 2) NULL,
	[Rating] [decimal](9, 2) NULL,
	[CreateDateTime] [datetime] NULL,
 CONSTRAINT [pk_salesImport_Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[tbl_salesImport] ADD  DEFAULT (getdate()) FOR [CreateDateTime]
GO

CREATE  NONCLUSTERED INDEX IX_tbl_salesImport on dbo.tbl_salesImport
(
 [Branch],
 [Date]
 )
	


