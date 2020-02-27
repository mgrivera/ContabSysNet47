/*    Lunes, 17 de Julio de 2.006   -   v0.00.196.sql 

	Modificamos levemente el listado de compras (en Bancos) para agregar una versión Excel que 
	muestre los items: Retención Iva % y Retención Iva 

*/ 


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[qReportListadoComprasVersionExcel]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[qReportListadoComprasVersionExcel]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tTempListadoCompras]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[tTempListadoCompras]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [tTempListadoCompras](
	[ClaveUnica] [int] IDENTITY(1,1) NOT NULL,
	[NumeroFactura] [nvarchar](25) NULL,
	[FechaRecepcion] [datetime] NULL,
	[Proveedor] [int] NULL,
	[NombreProveedor] [nvarchar](50) NULL,
	[RifProveedor] [nvarchar](20) NULL,
	[NumeroPlanillaImportacion] [nvarchar](25) NULL,
	[MontoFactura] [money] NULL,
	[TotalFactura] [money] NULL,
	[MontoSinDerechoACredito] [money] NULL,
	[MontoBaseFactImportacion] [money] NULL,
	[IvaPorcFactImportacion] [real] NULL,
	[IvaFactImportacion] [money] NULL,
	[MontoBaseFactNacional] [money] NULL,
	[IvaPorcFactNacional] [real] NULL,
	[IvaFactNacional] [money] NULL,
	[RetencionSobreIvaPorc] [decimal](5, 2) NULL,
	[RetencionSobreIva] [money] NULL,
	[NumeroUsuario] [int] NULL,
 CONSTRAINT [PK_tTempListadoCompras] PRIMARY KEY NONCLUSTERED 
(
	[ClaveUnica] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE NONCLUSTERED INDEX [IX_tTempListadoCompras] ON [tTempListadoCompras] 
(
	[NumeroUsuario] ASC
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [qReportListadoComprasVersionExcel]
AS
SELECT     NumeroFactura, FechaRecepcion, NombreProveedor, RifProveedor, NumeroPlanillaImportacion, MontoFactura, TotalFactura, 
                      MontoSinDerechoACredito, MontoBaseFactImportacion, IvaPorcFactImportacion, IvaFactImportacion, MontoBaseFactNacional, IvaPorcFactNacional, 
                      IvaFactNacional, RetencionSobreIvaPorc, RetencionSobreIva, NumeroUsuario
FROM         dbo.tTempListadoCompras
GO


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.196', GetDate()) 