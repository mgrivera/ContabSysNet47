/*    Martes, 22 de marzo de 2.007   -   v0.00.205.sql 

	Modificamos levemente el Listado de Compras 

*/ 


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qReportListadoCompras]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qReportListadoCompras]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tTempListadoCompras]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tTempListadoCompras]
GO

CREATE TABLE [dbo].[tTempListadoCompras] (
	[ClaveUnica] [int] IDENTITY (1, 1) NOT NULL ,
	[NumeroFactura] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FechaRecepcion] [datetime] NULL ,
	[Proveedor] [int] NULL ,
	[NombreProveedor] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RifProveedor] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NumeroPlanillaImportacion] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MontoFactura] [money] NULL ,
	[TotalFactura] [money] NULL ,
	[MontoSinDerechoACredito] [money] NULL ,
	[MontoSinDerechoACreditoNac] [money] NULL ,
	[MontoSinDerechoACreditoExt] [money] NULL ,
	[MontoBaseFactImportacion] [money] NULL ,
	[IvaPorcFactImportacion] [real] NULL ,
	[IvaFactImportacion] [money] NULL ,
	[BaseImponibleNCExt] [money] NULL ,
	[IvaNCExt] [money] NULL ,
	[MontoBaseFactNacional] [money] NULL ,
	[IvaPorcFactNacional] [real] NULL ,
	[IvaFactNacional] [money] NULL ,
	[BaseImponibleNCNac] [money] NULL ,
	[IvaNCNac] [money] NULL ,
	[RetencionSobreIvaPorc] [decimal](5, 2) NULL ,
	[RetencionSobreIva] [money] NULL ,
	[NumeroUsuario] [int] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tTempListadoCompras] ADD 
	CONSTRAINT [PK_tTempListadoCompras] PRIMARY KEY  NONCLUSTERED 
	(
		[ClaveUnica]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [IX_tTempListadoCompras] ON [dbo].[tTempListadoCompras]([NumeroUsuario]) ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qReportListadoCompras    Script Date: 28/11/00 07:01:20 p.m. *****
***** Object:  View dbo.qReportListadoCompras    Script Date: 08/nov/00 9:01:17 *****
***** Object:  View dbo.qReportListadoCompras    Script Date: 30/sep/00 1:10:03 *****




*/
CREATE VIEW dbo.qReportListadoCompras
AS
SELECT     ClaveUnica, NumeroFactura, FechaRecepcion, Proveedor, NombreProveedor, RifProveedor, DATEPART(day, FechaRecepcion) AS Dia, 
                      DATEPART(month, FechaRecepcion) AS Mes, DATEPART(year, FechaRecepcion) AS Ano, NumeroPlanillaImportacion, MontoFactura, TotalFactura, 
                      MontoSinDerechoACredito, ISNULL(MontoSinDerechoACreditoNac, 0) AS MontoSinDerechoACreditoNac, ISNULL(MontoSinDerechoACreditoExt, 0) 
                      AS MontoSinDerechoACreditoExt, ISNULL(MontoBaseFactImportacion, 0) AS MontoBaseFactImportacion, IvaPorcFactImportacion, 
                      ISNULL(IvaFactImportacion, 0) AS IvaFactImportacion, ISNULL(BaseImponibleNCExt, 0) AS BaseImponibleNCExt, ISNULL(IvaNCExt, 0) AS IvaNCExt, 
                      ISNULL(MontoBaseFactNacional, 0) AS MontoBaseFactNacional, IvaPorcFactNacional, ISNULL(IvaFactNacional, 0) AS IvaFactNacional, 
                      ISNULL(BaseImponibleNCNac, 0) AS BaseImponibleNCNac, ISNULL(IvaNCNac, 0) AS IvaNCNac, RetencionSobreIvaPorc, RetencionSobreIva, 
                      NumeroUsuario
FROM         dbo.tTempListadoCompras

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.205', GetDate()) 