/*    Miercoles, 2 de Marzo de 2.005   -   v0.00.169.sql 

	Hacemos unos cambios a las tablas tTempListadoMayorGeneral y ...AmbasMonedas. 

*/ 


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoMayorGeneralExcel]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoMayorGeneralExcel]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tTempListadoMayorGeneral]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tTempListadoMayorGeneral]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tTempListadoMayorGeneralAmbasMonedas]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tTempListadoMayorGeneralAmbasMonedas]
GO

CREATE TABLE [dbo].[tTempListadoMayorGeneral] (
	[ClaveUnica] [int] IDENTITY (1, 1) NOT NULL ,
	[Moneda] [int] NULL ,
	[NombreMoneda] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MonedaOriginal] [int] NULL ,
	[NombreMonedaOriginal] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Numero] [smallint] NULL ,
	[Mes] [smallint] NULL ,
	[Ano] [smallint] NULL ,
	[Fecha] [datetime] NULL ,
	[AnoMes] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Partida] [smallint] NULL ,
	[Cuenta] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Descripcion] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Referencia] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Debe] [money] NULL ,
	[Haber] [money] NULL ,
	[FactorDeCambio] [money] NULL ,
	[NumeroUsuario] [int] NULL ,
	[Cia] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tTempListadoMayorGeneralAmbasMonedas] (
	[ClaveUnica] [int] IDENTITY (1, 1) NOT NULL ,
	[Moneda] [int] NULL ,
	[NombreMoneda] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MonedaOriginal] [int] NULL ,
	[NombreMonedaOriginal] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Numero] [smallint] NULL ,
	[Mes] [smallint] NULL ,
	[Ano] [smallint] NULL ,
	[Fecha] [datetime] NULL ,
	[AnoMes] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Partida] [smallint] NULL ,
	[Cuenta] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Descripcion] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Referencia] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DebeBs] [money] NULL ,
	[HaberBs] [money] NULL ,
	[DebeDol] [money] NULL ,
	[HaberDol] [money] NULL ,
	[FactorDeCambio] [money] NULL ,
	[NumeroUsuario] [int] NULL ,
	[Cia] [int] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tTempListadoMayorGeneral] ADD 
	CONSTRAINT [PK_tTempListadoMayorGeneral] PRIMARY KEY  NONCLUSTERED 
	(
		[ClaveUnica]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [IX_tTempListadoMayorGeneral] ON [dbo].[tTempListadoMayorGeneral]([NumeroUsuario]) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tTempListadoMayorGeneralAmbasMonedas] ADD 
	CONSTRAINT [PK_tTempListadoMayorGeneralAmbasMonedas] PRIMARY KEY  NONCLUSTERED 
	(
		[ClaveUnica]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [IX_tTempListadoMayorGeneralAmbasMonedas] ON [dbo].[tTempListadoMayorGeneralAmbasMonedas]([NumeroUsuario]) ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoMayorGeneralExcel
AS
SELECT     dbo.Monedas.Simbolo AS Moneda, MonedasOriginal.Simbolo AS MonedaOriginal, dbo.CuentasContables.CuentaEditada AS CuentaContable, 
                      dbo.CuentasContables.Descripcion AS NombreCuentaContable, dbo.tTempListadoMayorGeneral.Numero AS Comprobante, 
                      dbo.tTempListadoMayorGeneral.Partida, dbo.tTempListadoMayorGeneral.Fecha, dbo.tTempListadoMayorGeneral.Descripcion AS DescComprobante, 
                      dbo.tTempListadoMayorGeneral.Referencia, dbo.tTempListadoMayorGeneral.Debe, dbo.tTempListadoMayorGeneral.Haber, 
                      dbo.tTempListadoMayorGeneral.NumeroUsuario
FROM         dbo.tTempListadoMayorGeneral INNER JOIN
                      dbo.CuentasContables ON dbo.tTempListadoMayorGeneral.Cuenta = dbo.CuentasContables.Cuenta AND 
                      dbo.tTempListadoMayorGeneral.Cia = dbo.CuentasContables.Cia LEFT OUTER JOIN
                      dbo.Monedas MonedasOriginal ON dbo.tTempListadoMayorGeneral.MonedaOriginal = MonedasOriginal.Moneda LEFT OUTER JOIN
                      dbo.Monedas ON dbo.tTempListadoMayorGeneral.Moneda = dbo.Monedas.Moneda

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.169', GetDate()) 

