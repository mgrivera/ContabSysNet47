/*    Martes, 29 de Mayo de 2.012  -   v0.00.313.sql 

	Agregamos las tablas 'Temp' para las consultas: mayor general y 
	libro de compras 

*/


/****** Object:  Table [dbo].[Temp_Bancos_Report_LibroCompras]    Script Date: 05/29/2012 12:08:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Temp_Bancos_Report_LibroCompras]') AND type in (N'U'))
DROP TABLE [dbo].[Temp_Bancos_Report_LibroCompras]
GO

/****** Object:  Table [dbo].[Temp_Bancos_Report_LibroCompras]    Script Date: 05/29/2012 12:08:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Temp_Bancos_Report_LibroCompras](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NombreCiaContab] [nvarchar](50) NOT NULL,
	[FechaDocumento] [date] NOT NULL,
	[CompaniaRif] [nvarchar](20) NULL,
	[CompaniaNombre] [nvarchar](50) NOT NULL,
	[ComprobanteSeniat] [nvarchar](20) NULL,
	[NumeroPlanillaImportacion] [nvarchar](25) NULL,
	[TipoDocumento] [nvarchar](4) NOT NULL,
	[NumeroDocumento] [nvarchar](25) NOT NULL,
	[NumeroDocumentoAfectado] [nvarchar](25) NULL,
	[MontoTotalMasIva] [money] NOT NULL,
	[MontoNoImponible] [money] NULL,
	[MontoImponible] [money] NULL,
	[IvaPorc] [decimal](5, 2) NULL,
	[MontoIva] [money] NULL,
	[RetencionIvaPorc] [decimal](5, 2) NULL,
	[MontoRetencionIva] [money] NULL,
	[Usuario] [nvarchar](25) NOT NULL,
 CONSTRAINT [PK_Temp_Bancos_Report_LibroCompras] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


/****** Object:  Table [dbo].[Temp_Contab_Report_MayorGeneral]    Script Date: 05/29/2012 12:08:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Temp_Contab_Report_MayorGeneral]') AND type in (N'U'))
DROP TABLE [dbo].[Temp_Contab_Report_MayorGeneral]
GO

/****** Object:  Table [dbo].[Temp_Contab_Report_MayorGeneral]    Script Date: 05/29/2012 12:08:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Temp_Contab_Report_MayorGeneral](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NombreCia] [nvarchar](6) NOT NULL,
	[SimboloMoneda] [nvarchar](6) NOT NULL,
	[CuentaContable] [nvarchar](25) NOT NULL,
	[NombreCuenta] [nvarchar](50) NOT NULL,
	[OrderBy] [int] NOT NULL,
	[Fecha] [date] NOT NULL,
	[Comprobante] [smallint] NULL,
	[Descripcion] [nvarchar](75) NOT NULL,
	[SaldoInicial] [money] NULL,
	[Haber] [money] NULL,
	[Debe] [money] NULL,
	[SaldoFinal] [money] NULL,
	[Usuario] [nvarchar](25) NOT NULL,
 CONSTRAINT [PK_Temp_Contab_Report_MayorGeneral] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.313', GetDate()) 