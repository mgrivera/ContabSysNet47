/*    Viernes, 10 de Marzo de 2.006   -   v0.00.190.sql 

	Modificamos levemente la tabla tTempCartaImpuestosRetenidos y el view 
	qReportCartaImpuestosRetenidos 

*/ 

/****** Object:  View [dbo].[qReportCartaImpuestosRetenidos]    Script Date: 03/13/2006 17:29:06 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[qReportCartaImpuestosRetenidos]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[qReportCartaImpuestosRetenidos]

/****** Object:  Table [dbo].[tTempCartaImpuestosRetenidos]    Script Date: 03/13/2006 17:28:06 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tTempCartaImpuestosRetenidos]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[tTempCartaImpuestosRetenidos]


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tTempCartaImpuestosRetenidos]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[tTempCartaImpuestosRetenidos](
	[ClaveUnica] [int] IDENTITY(1,1) NOT NULL,
	[Proveedor] [int] NULL,
	[NombreProveedor] [nvarchar](50) NULL,
	[Rif] [nvarchar](20) NULL,
	[Nit] [nvarchar](20) NULL,
	[DireccionProveedor] [nvarchar](255) NULL,
	[Ciudad] [nvarchar](6) NULL,
	[NombreCiudad] [nvarchar](50) NULL,
	[Moneda] [int] NULL,
	[SimboloMoneda] [nvarchar](15) NULL,
	[NumeroFactura] [nvarchar](25) NULL,
	[FechaRecepcion] [datetime] NULL,
	[MontoFactura] [money] NULL,
	[MontoSujetoARetencion] [money] NULL,
	[ImpuestoRetenidoPorc] [real] NULL,
	[ImpuestoRetenido] [money] NULL,
	[TotalFactura] [money] NULL,
	[NumeroUsuario] [int] NULL,
 CONSTRAINT [PK_tTempCartaImpuestosRetenidos] PRIMARY KEY NONCLUSTERED 
(
	[ClaveUnica] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[qReportCartaImpuestosRetenidos]') AND OBJECTPROPERTY(id, N'IsView') = 1)
EXEC dbo.sp_executesql @statement = N'/****** Object:  View dbo.qReportCartaImpuestosRetenidos    Script Date: 28/11/00 07:01:20 p.m. *****
***** Object:  View dbo.qReportCartaImpuestosRetenidos    Script Date: 08/nov/00 9:01:17 *****
***** Object:  View dbo.qReportCartaImpuestosRetenidos    Script Date: 30/sep/00 1:10:02 ******/
CREATE VIEW [dbo].[qReportCartaImpuestosRetenidos]
AS
SELECT     ClaveUnica, Proveedor, NombreProveedor, Rif, Nit, DireccionProveedor, Ciudad, NombreCiudad, Moneda, SimboloMoneda, NumeroFactura, 
                      FechaRecepcion, MontoFactura, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenido, TotalFactura, NumeroUsuario
FROM         dbo.tTempCartaImpuestosRetenidos
' 


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.190', GetDate()) 