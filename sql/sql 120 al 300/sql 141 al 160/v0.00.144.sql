/*    Lunes 15 de Enero de 2003   -   v0.00.144.sql 

	Agregamos los cambios necesarios para implementar la "retención sobre el iva" a las
      facturas. 

*/ 


--  -------------------------------------
--  agregamos la tabla ParametrosBancos
--  -------------------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaParametrosBancos]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaParametrosBancos]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ParametrosBancos]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ParametrosBancos]
GO

CREATE TABLE [dbo].[ParametrosBancos] (
	[RetencionSobreIvaFlag] [bit] NULL ,
	[RetencionSobreIvaPorc] [decimal](5, 2) NULL ,
	[Cia] [int] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ParametrosBancos] WITH NOCHECK ADD 
	CONSTRAINT [PK_ParametrosBancos] PRIMARY KEY  CLUSTERED 
	(
		[Cia]
	)  ON [PRIMARY] 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaParametrosBancos
AS
SELECT     RetencionSobreIvaFlag, RetencionSobreIvaPorc, Cia
FROM         dbo.ParametrosBancos

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


--  -------------------------------
--  modificamos la tabla Facturas 
--  -------------------------------

BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.Facturas
	DROP CONSTRAINT FK_Facturas_TiposProveedor
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.Facturas
	DROP CONSTRAINT FK_Facturas_FormasDePago
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.Facturas
	DROP CONSTRAINT FK_Facturas_Proveedores
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.Facturas
	DROP CONSTRAINT FK_Facturas_Companias
GO
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.Tmp_Facturas
	(
	ClaveUnica int NOT NULL,
	Proveedor int NOT NULL,
	NumeroFactura nvarchar(25) NOT NULL,
	Tipo int NOT NULL,
	CondicionesDePago int NOT NULL,
	FechaEmision datetime NOT NULL,
	FechaRecepcion datetime NOT NULL,
	Concepto ntext NULL,
	MontoFactura money NOT NULL,
	IvaPorc real NOT NULL,
	Iva money NOT NULL,
	TotalFactura money NOT NULL,
	MontoSujetoARetencion money NULL,
	ImpuestoRetenidoPorc real NULL,
	ImpuestoRetenido money NULL,
	RetencionSobreIvaPorc real NULL,
	RetencionSobreIva money NULL,
	TotalAPagar money NOT NULL,
	Saldo money NOT NULL,
	Estado smallint NOT NULL,
	NumeroDeCuotas smallint NULL,
	FechaUltimoVencimiento datetime NULL,
	ClaveUnicaUltimoPago int NULL,
	Moneda int NOT NULL,
	CxCCxPFlag smallint NOT NULL,
	Comprobante int NULL,
	ImportacionFlag bit NULL,
	DistribuirEnCondominioFlag bit NULL,
	GrupoCondominio int NULL,
	CierreCondominio int NULL,
	CodigoInmueble nvarchar(25) NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.Facturas)
	 EXEC('INSERT INTO dbo.Tmp_Facturas (ClaveUnica, Proveedor, NumeroFactura, Tipo, CondicionesDePago, FechaEmision, FechaRecepcion, Concepto, MontoFactura, IvaPorc, Iva, TotalFactura, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenido, TotalAPagar, Saldo, Estado, NumeroDeCuotas, FechaUltimoVencimiento, ClaveUnicaUltimoPago, Moneda, CxCCxPFlag, Comprobante, ImportacionFlag, DistribuirEnCondominioFlag, GrupoCondominio, CierreCondominio, CodigoInmueble, Cia)
		SELECT ClaveUnica, Proveedor, NumeroFactura, Tipo, CondicionesDePago, FechaEmision, FechaRecepcion, Concepto, MontoFactura, IvaPorc, Iva, TotalFactura, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenido, TotalAPagar, Saldo, Estado, NumeroDeCuotas, FechaUltimoVencimiento, ClaveUnicaUltimoPago, Moneda, CxCCxPFlag, Comprobante, ImportacionFlag, DistribuirEnCondominioFlag, GrupoCondominio, CierreCondominio, CodigoInmueble, Cia FROM dbo.Facturas TABLOCKX')
GO
ALTER TABLE dbo.CuotasFactura
	DROP CONSTRAINT FK_CuotasFactura_Facturas
GO
DROP TABLE dbo.Facturas
GO
EXECUTE sp_rename N'dbo.Tmp_Facturas', N'Facturas', 'OBJECT'
GO
ALTER TABLE dbo.Facturas ADD CONSTRAINT
	PK_Facturas PRIMARY KEY NONCLUSTERED 
	(
	ClaveUnica
	) ON [PRIMARY]

GO
CREATE UNIQUE NONCLUSTERED INDEX i_pn_Facturas ON dbo.Facturas
	(
	Proveedor,
	NumeroFactura,
	Cia
	) ON [PRIMARY]
GO
ALTER TABLE dbo.Facturas WITH NOCHECK ADD CONSTRAINT
	FK_Facturas_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	)
GO
ALTER TABLE dbo.Facturas WITH NOCHECK ADD CONSTRAINT
	FK_Facturas_Proveedores FOREIGN KEY
	(
	Proveedor
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	)
GO
ALTER TABLE dbo.Facturas WITH NOCHECK ADD CONSTRAINT
	FK_Facturas_FormasDePago FOREIGN KEY
	(
	CondicionesDePago
	) REFERENCES dbo.FormasDePago
	(
	FormaDePago
	)
GO
ALTER TABLE dbo.Facturas WITH NOCHECK ADD CONSTRAINT
	FK_Facturas_TiposProveedor FOREIGN KEY
	(
	Tipo
	) REFERENCES dbo.TiposProveedor
	(
	Tipo
	)
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.CuotasFactura WITH NOCHECK ADD CONSTRAINT
	FK_CuotasFactura_Facturas FOREIGN KEY
	(
	ClaveUnicaFactura
	) REFERENCES dbo.Facturas
	(
	ClaveUnica
	)
GO
COMMIT


--  -----------------------------------------
--  qFormaFacturas y qFormaFacturasConsulta 
--  -----------------------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaFacturas]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaFacturas]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaFacturasConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaFacturasConsulta]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaFacturas
AS
SELECT     ClaveUnica, Proveedor, NumeroFactura, Tipo, CondicionesDePago, FechaEmision, FechaRecepcion, Concepto, MontoFactura, IvaPorc, Iva, 
                      TotalFactura, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenido, RetencionSobreIvaPorc, RetencionSobreIva, TotalAPagar, Saldo, 
                      Estado, ImportacionFlag, Comprobante, CxCCxPFlag, Moneda, ClaveUnicaUltimoPago, FechaUltimoVencimiento, NumeroDeCuotas, 
                      DistribuirEnCondominioFlag, GrupoCondominio, CierreCondominio, CodigoInmueble, Cia
FROM         dbo.Facturas

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaFacturasConsulta
AS
SELECT     dbo.Facturas.ClaveUnica, dbo.Facturas.Proveedor, dbo.Proveedores.Nombre AS NombreProveedor, dbo.Facturas.NumeroFactura, 
                      dbo.Facturas.CondicionesDePago, dbo.Facturas.Tipo, dbo.TiposProveedor.Descripcion AS NombreTipo, 
                      dbo.FormasDePago.Descripcion AS NombreCondicionesDePago, dbo.Facturas.FechaEmision, dbo.Facturas.FechaRecepcion, dbo.Facturas.Concepto, 
                      dbo.Facturas.MontoFactura, dbo.Facturas.IvaPorc, dbo.Facturas.Iva, dbo.Facturas.TotalFactura, dbo.Facturas.MontoSujetoARetencion, 
                      dbo.Facturas.ImpuestoRetenidoPorc, dbo.Facturas.ImpuestoRetenido, dbo.Facturas.RetencionSobreIvaPorc, dbo.Facturas.RetencionSobreIva, 
                      dbo.Facturas.TotalAPagar, dbo.Facturas.Saldo, dbo.Facturas.Estado, dbo.Facturas.ImportacionFlag, dbo.Facturas.Comprobante, 
                      dbo.Facturas.CxCCxPFlag, dbo.Facturas.Moneda, dbo.Facturas.ClaveUnicaUltimoPago, dbo.Facturas.FechaUltimoVencimiento, 
                      dbo.Facturas.NumeroDeCuotas, dbo.Facturas.DistribuirEnCondominioFlag, dbo.Facturas.GrupoCondominio, dbo.Facturas.CierreCondominio, 
                      dbo.Facturas.CodigoInmueble, dbo.Facturas.Cia
FROM         dbo.Facturas LEFT OUTER JOIN
                      dbo.TiposProveedor ON dbo.Facturas.Tipo = dbo.TiposProveedor.Tipo LEFT OUTER JOIN
                      dbo.Proveedores ON dbo.Facturas.Proveedor = dbo.Proveedores.Proveedor LEFT OUTER JOIN
                      dbo.FormasDePago ON dbo.Facturas.CondicionesDePago = dbo.FormasDePago.FormaDePago

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

--  ------------------------
--  CuotasFactura
--  ------------------------


BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.CuotasFactura
	DROP CONSTRAINT FK_CuotasFactura_Facturas
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.CuotasFactura
	DROP CONSTRAINT FK_CuotasFactura_Companias
GO
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.Tmp_CuotasFactura
	(
	ClaveUnica int NOT NULL,
	ClaveUnicaFactura int NOT NULL,
	Proveedor int NOT NULL,
	NumeroFactura nvarchar(25) NOT NULL,
	FechaEmision datetime NOT NULL,
	FechaRecepcion datetime NOT NULL,
	NumeroCuota smallint NOT NULL,
	DiasVencimiento smallint NOT NULL,
	FechaVencimiento datetime NOT NULL,
	ProporcionCuota real NOT NULL,
	MontoCuota money NOT NULL,
	Iva money NOT NULL,
	RetencionSobreIva money NULL,
	TotalCuota money NOT NULL,
	SaldoCuota money NOT NULL,
	EstadoCuota smallint NOT NULL,
	ProporcionIva real NOT NULL,
	CantidadDeCuotas smallint NOT NULL,
	ClaveUnicaUltimoPago int NULL,
	Moneda int NOT NULL,
	CxCCxPFlag smallint NOT NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.CuotasFactura)
	 EXEC('INSERT INTO dbo.Tmp_CuotasFactura (ClaveUnica, ClaveUnicaFactura, Proveedor, NumeroFactura, FechaEmision, FechaRecepcion, NumeroCuota, DiasVencimiento, FechaVencimiento, ProporcionCuota, MontoCuota, Iva, TotalCuota, SaldoCuota, EstadoCuota, ProporcionIva, CantidadDeCuotas, ClaveUnicaUltimoPago, Moneda, CxCCxPFlag, Cia)
		SELECT ClaveUnica, ClaveUnicaFactura, Proveedor, NumeroFactura, FechaEmision, FechaRecepcion, NumeroCuota, DiasVencimiento, FechaVencimiento, ProporcionCuota, MontoCuota, Iva, TotalCuota, SaldoCuota, EstadoCuota, ProporcionIva, CantidadDeCuotas, ClaveUnicaUltimoPago, Moneda, CxCCxPFlag, Cia FROM dbo.CuotasFactura TABLOCKX')
GO
DROP TABLE dbo.CuotasFactura
GO
EXECUTE sp_rename N'dbo.Tmp_CuotasFactura', N'CuotasFactura', 'OBJECT'
GO
ALTER TABLE dbo.CuotasFactura ADD CONSTRAINT
	PK_CuotasFactura PRIMARY KEY NONCLUSTERED 
	(
	ClaveUnica
	) ON [PRIMARY]

GO
ALTER TABLE dbo.CuotasFactura WITH NOCHECK ADD CONSTRAINT
	FK_CuotasFactura_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	)
GO
ALTER TABLE dbo.CuotasFactura WITH NOCHECK ADD CONSTRAINT
	FK_CuotasFactura_Facturas FOREIGN KEY
	(
	ClaveUnicaFactura
	) REFERENCES dbo.Facturas
	(
	ClaveUnica
	)
GO
COMMIT


--  ------------------------
--  qFormaCuotasFactura
--  ------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaCuotasFactura]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaCuotasFactura]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qFormaCuotasFactura    Script Date: 28/11/00 07:01:25 p.m. *****
***** Object:  View dbo.qFormaCuotasFactura    Script Date: 08/nov/00 9:01:16 *****
***** Object:  View dbo.qFormaCuotasFactura    Script Date: 30/sep/00 1:10:01 ******/
CREATE VIEW dbo.qFormaCuotasFactura
AS
SELECT     ClaveUnica, ClaveUnicaFactura, Proveedor, NumeroFactura, FechaEmision, FechaRecepcion, NumeroCuota, DiasVencimiento, FechaVencimiento, 
                      ProporcionCuota, MontoCuota, Iva, RetencionSobreIva, TotalCuota, SaldoCuota, EstadoCuota, ProporcionIva, CantidadDeCuotas, 
                      ClaveUnicaUltimoPago, Moneda, CxCCxPFlag
FROM         dbo.CuotasFactura

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

--  ------------------------
--  tTempListadoIvaRetenido
--  ------------------------



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tTempListadoIvaRetenido]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tTempListadoIvaRetenido]
GO

CREATE TABLE [dbo].[tTempListadoIvaRetenido] (
	[ClaveUnica] [int] IDENTITY (1, 1) NOT NULL ,
	[Proveedor] [int] NULL ,
	[NombreProveedor] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Rif] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Cedula] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NatJurFlag] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Moneda] [int] NULL ,
	[NombreMoneda] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NumeroFactura] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FechaRecepcion] [datetime] NULL ,
	[MontoFactura] [money] NULL ,
	[Iva] [money] NULL ,
	[RetencionSobreIvaPorc] [real] NULL ,
	[RetencionSobreIva] [money] NULL ,
	[NumeroUsuario] [int] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tTempListadoIvaRetenido] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[ClaveUnica]
	)  ON [PRIMARY] 
GO


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.144', GetDate()) 

