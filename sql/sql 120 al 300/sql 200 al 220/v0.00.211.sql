/*    Jueves, 27 de Diciembre de 2.007   -   v0.00.211.sql 

	Agregamos las tablas que usamos para el proceso de reconversión monetaria 

*/ 

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tTempReport_ConversionMonetaria_Contabilidad]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tTempReport_ConversionMonetaria_Contabilidad]
GO

CREATE TABLE [dbo].[tTempReport_ConversionMonetaria_Contabilidad] (
	[Cuenta] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Tipo] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Mes] [smallint] NOT NULL ,
	[MesFiscal] [smallint] NOT NULL ,
	[Ano] [smallint] NOT NULL ,
	[Moneda] [int] NOT NULL ,
	[MonedaOriginal] [int] NOT NULL ,
	[SaldoOriginal] [money] NOT NULL ,
	[SaldoConvertido] [money] NOT NULL ,
	[NumeroUsuario] [int] NOT NULL ,
	[Cia] [int] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tTempReport_ConversionMonetaria_Contabilidad] WITH NOCHECK ADD 
	CONSTRAINT [PK_tTempReport_ConversionMonetaria_Contabilidad] PRIMARY KEY  CLUSTERED 
	(
		[Cuenta],
		[Moneda],
		[MonedaOriginal],
		[NumeroUsuario],
		[Cia]
	)  ON [PRIMARY] 
GO





if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tTempReport_ConversionMonetaria_Bancos]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tTempReport_ConversionMonetaria_Bancos]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tTempReport_ConversionMonetaria_Companias]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tTempReport_ConversionMonetaria_Companias]
GO

CREATE TABLE [dbo].[tTempReport_ConversionMonetaria_Bancos] (
	[CuentaBancaria] [int] NOT NULL ,
	[Moneda] [smallint] NOT NULL ,
	[Banco] [int] NOT NULL ,
	[Ano] [smallint] NOT NULL ,
	[SaldoInicialOriginal] [money] NOT NULL ,
	[SaldoInicialConvertido] [money] NOT NULL ,
	[NumeroUsuario] [int] NOT NULL ,
	[Cia] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tTempReport_ConversionMonetaria_Companias] (
	[Compania] [int] NOT NULL ,
	[Moneda] [int] NOT NULL ,
	[Ano] [smallint] NOT NULL ,
	[SaldoInicialOriginal] [money] NOT NULL ,
	[SaldoInicialConvertido] [money] NOT NULL ,
	[NumeroUsuario] [int] NOT NULL ,
	[Cia] [int] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tTempReport_ConversionMonetaria_Bancos] WITH NOCHECK ADD 
	CONSTRAINT [PK_tTempReport_ConversionMonetaria_Bancos] PRIMARY KEY  CLUSTERED 
	(
		[CuentaBancaria],
		[NumeroUsuario],
		[Cia]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tTempReport_ConversionMonetaria_Companias] WITH NOCHECK ADD 
	CONSTRAINT [PK_tTempReport_ConversionMonetaria_Companias] PRIMARY KEY  CLUSTERED 
	(
		[Compania],
		[NumeroUsuario],
		[Cia]
	)  ON [PRIMARY] 
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tTempReport_ConversionMonetaria_Nomina]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tTempReport_ConversionMonetaria_Nomina]
GO

CREATE TABLE [dbo].[tTempReport_ConversionMonetaria_Nomina] (
	[ClaveOriginal] [smallint] IDENTITY (1, 1) NOT NULL ,
	[TipoRegistro] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Descripcion] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[SaldoOriginal] [money] NOT NULL ,
	[SaldoConvertido] [money] NOT NULL ,
	[NumeroUsuario] [int] NOT NULL ,
	[Cia] [int] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tTempReport_ConversionMonetaria_Nomina] WITH NOCHECK ADD 
	CONSTRAINT [PK_tTempReport_ConversionMonetaria_Nomina] PRIMARY KEY  CLUSTERED 
	(
		[ClaveOriginal]
	)  ON [PRIMARY] 
GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.211', GetDate()) 