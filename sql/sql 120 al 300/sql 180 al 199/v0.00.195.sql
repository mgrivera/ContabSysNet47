/*    Lunes, 17 de Julio de 2.006   -   v0.00.195.sql 

	Agregamos los items: NdNcFlag y NumeroFacturaAfectada a la tabla Facturas. 
	El objetivo de estos dos nuevos items es producir el reporte de comprobantes de 
	retención del impuesto Iva para el Seniat. 

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
ALTER TABLE dbo.Facturas
	DROP CONSTRAINT FK_Facturas_Proveedores
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Facturas
	DROP CONSTRAINT FK_Facturas_Monedas
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Facturas
	DROP CONSTRAINT FK_Facturas_TiposProveedor
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Facturas
	DROP CONSTRAINT FK_Facturas_FormasDePago
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Facturas
	DROP CONSTRAINT FK_Facturas_Companias
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Facturas
	(
	ClaveUnica int NOT NULL,
	Proveedor int NOT NULL,
	NumeroFactura nvarchar(25) NOT NULL,
	NumeroControl nvarchar(20) NULL,
	NcNdFlag char(2) NULL,
	NumeroFacturaAfectada nvarchar(20) NULL,
	NumeroComprobante char(14) NULL,
	NumeroOperacion smallint NULL,
	Tipo int NOT NULL,
	NumeroPlanillaImportacion nvarchar(25) NULL,
	CondicionesDePago int NOT NULL,
	FechaEmision datetime NOT NULL,
	FechaRecepcion datetime NOT NULL,
	Concepto ntext NULL,
	MontoFacturaSinIva money NULL,
	MontoFacturaConIva money NULL,
	IvaPorc real NULL,
	Iva money NULL,
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
	 EXEC('INSERT INTO dbo.Tmp_Facturas (ClaveUnica, Proveedor, NumeroFactura, NumeroControl, NumeroComprobante, NumeroOperacion, Tipo, NumeroPlanillaImportacion, CondicionesDePago, FechaEmision, FechaRecepcion, Concepto, MontoFacturaSinIva, MontoFacturaConIva, IvaPorc, Iva, TotalFactura, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenido, RetencionSobreIvaPorc, RetencionSobreIva, TotalAPagar, Saldo, Estado, NumeroDeCuotas, FechaUltimoVencimiento, ClaveUnicaUltimoPago, Moneda, CxCCxPFlag, Comprobante, ImportacionFlag, DistribuirEnCondominioFlag, GrupoCondominio, CierreCondominio, CodigoInmueble, Cia)
		SELECT ClaveUnica, Proveedor, NumeroFactura, NumeroControl, NumeroComprobante, NumeroOperacion, Tipo, NumeroPlanillaImportacion, CondicionesDePago, FechaEmision, FechaRecepcion, Concepto, MontoFacturaSinIva, MontoFacturaConIva, IvaPorc, Iva, TotalFactura, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenido, RetencionSobreIvaPorc, RetencionSobreIva, TotalAPagar, Saldo, Estado, NumeroDeCuotas, FechaUltimoVencimiento, ClaveUnicaUltimoPago, Moneda, CxCCxPFlag, Comprobante, ImportacionFlag, DistribuirEnCondominioFlag, GrupoCondominio, CierreCondominio, CodigoInmueble, Cia FROM dbo.Facturas WITH (HOLDLOCK TABLOCKX)')
GO
ALTER TABLE dbo.CuotasFactura
	DROP CONSTRAINT FK_CuotasFactura_Facturas
GO
ALTER TABLE dbo.dPagos
	DROP CONSTRAINT FK_dPagos_Facturas
GO
ALTER TABLE dbo.OrdenesPagoFacturas
	DROP CONSTRAINT FK_OrdenesPagoFacturas_Facturas1
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
ALTER TABLE dbo.Facturas WITH NOCHECK ADD CONSTRAINT
	FK_Facturas_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
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
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.OrdenesPagoFacturas WITH NOCHECK ADD CONSTRAINT
	FK_OrdenesPagoFacturas_Facturas1 FOREIGN KEY
	(
	Proveedor,
	NumeroFactura,
	Cia
	) REFERENCES dbo.Facturas
	(
	Proveedor,
	NumeroFactura,
	Cia
	)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.dPagos WITH NOCHECK ADD CONSTRAINT
	FK_dPagos_Facturas FOREIGN KEY
	(
	ClaveUnicaFactura
	) REFERENCES dbo.Facturas
	(
	ClaveUnica
	)
GO
COMMIT
BEGIN TRANSACTION
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





IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[qFormaFacturas]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[qFormaFacturas]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[qFormaFacturasConsulta]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[qFormaFacturasConsulta]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tTempListadoIvaRetenido]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[tTempListadoIvaRetenido]





SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tTempListadoIvaRetenido]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[tTempListadoIvaRetenido](
	[ClaveUnica] [int] IDENTITY(1,1) NOT NULL,
	[Proveedor] [int] NULL,
	[NombreProveedor] [nvarchar](50) NULL,
	[RifProveedor] [nvarchar](20) NULL,
	[CedulaProveedor] [nvarchar](20) NULL,
	[NatJurFlag] [nvarchar](30) NULL,
	[MesFiscal] [smallint] NULL,
	[AnoFiscal] [smallint] NULL,
	[Moneda] [int] NULL,
	[NombreMoneda] [nvarchar](50) NULL,
	[MiNombre] [nvarchar](50) NULL,
	[MiRif] [nvarchar](12) NULL,
	[MiDireccion] [nvarchar](150) NULL,
	[NcNdFlag] [char](2) NULL,
	[NumeroFacturaAfectada] [nvarchar](25) NULL,
	[NumeroComprobante] [char](14) NULL,
	[NumeroOperacion] [smallint] NULL,
	[FechaFactura] [datetime] NULL,
	[FechaRecepcion] [datetime] NULL,
	[NumeroDocumentoEditado] [nvarchar](30) NULL,
	[NumeroFactura] [nvarchar](25) NULL,
	[NumeroNotaCredito] [nvarchar](25) NULL,
	[NumeroNotaDebito] [nvarchar](25) NULL,
	[TipoTransaccion] [tinyint] NULL,
	[NumeroControl] [nvarchar](25) NULL,
	[TotalFactura] [money] NULL,
	[MontoFacturaSinIva] [money] NULL,
	[MontoFacturaConIva] [money] NULL,
	[PorcentajeIva] [float] NULL,
	[Iva] [money] NULL,
	[RetencionSobreIvaPorc] [real] NULL,
	[RetencionSobreIva] [money] NULL,
	[NumeroUsuario] [int] NULL,
 CONSTRAINT [PK__tTempListadoIvaR__2F1AED73] PRIMARY KEY CLUSTERED 
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
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[qFormaFacturasConsulta]') AND OBJECTPROPERTY(id, N'IsView') = 1)
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[qFormaFacturasConsulta]
AS
SELECT     dbo.Facturas.ClaveUnica, dbo.Facturas.Proveedor, dbo.Proveedores.Nombre AS NombreProveedor, dbo.Facturas.NumeroFactura, 
                      dbo.Facturas.NumeroControl, dbo.Facturas.NcNdFlag, dbo.Facturas.NumeroFacturaAfectada, dbo.Facturas.NumeroComprobante, 
                      dbo.Facturas.NumeroOperacion, dbo.Facturas.CondicionesDePago, dbo.Facturas.Tipo, dbo.Facturas.NumeroPlanillaImportacion, 
                      dbo.TiposProveedor.Descripcion AS NombreTipo, dbo.FormasDePago.Descripcion AS NombreCondicionesDePago, dbo.Facturas.FechaEmision, 
                      dbo.Facturas.FechaRecepcion, dbo.Facturas.Concepto, dbo.Facturas.MontoFacturaSinIva, dbo.Facturas.MontoFacturaConIva, dbo.Facturas.IvaPorc, 
                      dbo.Facturas.Iva, dbo.Facturas.TotalFactura, dbo.Facturas.MontoSujetoARetencion, dbo.Facturas.ImpuestoRetenidoPorc, 
                      dbo.Facturas.ImpuestoRetenido, dbo.Facturas.RetencionSobreIvaPorc, dbo.Facturas.RetencionSobreIva, dbo.Facturas.TotalAPagar, 
                      dbo.Facturas.Saldo, dbo.Facturas.Estado, dbo.Facturas.ImportacionFlag, dbo.Facturas.Comprobante, dbo.Facturas.CxCCxPFlag, dbo.Facturas.Moneda, 
                      dbo.Facturas.ClaveUnicaUltimoPago, dbo.Facturas.FechaUltimoVencimiento, dbo.Facturas.NumeroDeCuotas, 
                      dbo.Facturas.DistribuirEnCondominioFlag, dbo.Facturas.GrupoCondominio, dbo.Facturas.CierreCondominio, dbo.Facturas.CodigoInmueble, 
                      dbo.Facturas.Cia
FROM         dbo.Facturas LEFT OUTER JOIN
                      dbo.TiposProveedor ON dbo.Facturas.Tipo = dbo.TiposProveedor.Tipo LEFT OUTER JOIN
                      dbo.Proveedores ON dbo.Facturas.Proveedor = dbo.Proveedores.Proveedor LEFT OUTER JOIN
                      dbo.FormasDePago ON dbo.Facturas.CondicionesDePago = dbo.FormasDePago.FormaDePago
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[qFormaFacturas]') AND OBJECTPROPERTY(id, N'IsView') = 1)
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[qFormaFacturas]
AS
SELECT     ClaveUnica, Proveedor, NumeroFactura, NumeroControl, NcNdFlag, NumeroFacturaAfectada, NumeroComprobante, NumeroOperacion, Tipo, 
                      NumeroPlanillaImportacion, CondicionesDePago, FechaEmision, FechaRecepcion, Concepto, IvaPorc, MontoFacturaSinIva, MontoFacturaConIva, Iva, 
                      TotalFactura, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenido, RetencionSobreIvaPorc, RetencionSobreIva, TotalAPagar, Saldo, 
                      Estado, ImportacionFlag, Comprobante, CxCCxPFlag, Moneda, ClaveUnicaUltimoPago, FechaUltimoVencimiento, NumeroDeCuotas, 
                      DistribuirEnCondominioFlag, GrupoCondominio, CierreCondominio, CodigoInmueble, Cia
FROM         dbo.Facturas
' 




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.195', GetDate()) 