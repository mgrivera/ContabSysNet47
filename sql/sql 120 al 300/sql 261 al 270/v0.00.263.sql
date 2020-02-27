/*    Jueves, 20 de Mayo de 2.010    -   v0.00.263.sql 

	Agregamos el item Concepto a la tabla tTempCartaImpuestosRetenidos 

*/


BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tTempCartaImpuestosRetenidos
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	Proveedor int NULL,
	NombreProveedor nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Rif nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Nit nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DireccionProveedor nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Ciudad nvarchar(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	NombreCiudad nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Moneda int NULL,
	SimboloMoneda nvarchar(15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	NumeroFactura nvarchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	FechaRecepcion datetime NULL,
	Concepto ntext NULL,
	MontoFactura money NULL,
	MontoSujetoARetencion money NULL,
	ImpuestoRetenidoPorc real NULL,
	ImpuestoRetenido money NULL,
	TotalFactura money NULL,
	NumeroUsuario int NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tTempCartaImpuestosRetenidos SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tTempCartaImpuestosRetenidos ON
GO
IF EXISTS(SELECT * FROM dbo.tTempCartaImpuestosRetenidos)
	 EXEC('INSERT INTO dbo.Tmp_tTempCartaImpuestosRetenidos (ClaveUnica, Proveedor, NombreProveedor, Rif, Nit, DireccionProveedor, Ciudad, NombreCiudad, Moneda, SimboloMoneda, NumeroFactura, FechaRecepcion, MontoFactura, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenido, TotalFactura, NumeroUsuario)
		SELECT ClaveUnica, Proveedor, NombreProveedor, Rif, Nit, DireccionProveedor, Ciudad, NombreCiudad, Moneda, SimboloMoneda, NumeroFactura, FechaRecepcion, MontoFactura, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenido, TotalFactura, NumeroUsuario FROM dbo.tTempCartaImpuestosRetenidos WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tTempCartaImpuestosRetenidos OFF
GO
DROP TABLE dbo.tTempCartaImpuestosRetenidos
GO
EXECUTE sp_rename N'dbo.Tmp_tTempCartaImpuestosRetenidos', N'tTempCartaImpuestosRetenidos', 'OBJECT' 
GO
ALTER TABLE dbo.tTempCartaImpuestosRetenidos ADD CONSTRAINT
	PK_tTempCartaImpuestosRetenidos PRIMARY KEY NONCLUSTERED 
	(
	ClaveUnica
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT




/****** Object:  View [dbo].[qReportCartaImpuestosRetenidos]    Script Date: 05/20/2010 12:43:41 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qReportCartaImpuestosRetenidos]'))
DROP VIEW [dbo].[qReportCartaImpuestosRetenidos]
GO

/****** Object:  View [dbo].[qReportCartaImpuestosRetenidos]    Script Date: 05/20/2010 12:43:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  View dbo.qReportCartaImpuestosRetenidos    Script Date: 28/11/00 07:01:20 p.m. *****
***** Object:  View dbo.qReportCartaImpuestosRetenidos    Script Date: 08/nov/00 9:01:17 *****
***** Object:  View dbo.qReportCartaImpuestosRetenidos    Script Date: 30/sep/00 1:10:02 ******/
CREATE VIEW [dbo].[qReportCartaImpuestosRetenidos]
AS
SELECT     ClaveUnica, Proveedor, NombreProveedor, Rif, Nit, DireccionProveedor, Ciudad, NombreCiudad, Moneda, SimboloMoneda, NumeroFactura, 
                      FechaRecepcion, Concepto, MontoFactura, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenido, TotalFactura, NumeroUsuario
FROM         dbo.tTempCartaImpuestosRetenidos

GO





--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.263', GetDate()) 