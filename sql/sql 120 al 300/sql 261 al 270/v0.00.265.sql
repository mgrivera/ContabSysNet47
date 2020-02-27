/*    Viernes, 09 de Julio de 2.010    -   v0.00.265.sql 

	Cambios necesarios en Proveedores y Facturas para agregar el monto Sustraendo 
	de la retención del ISLR 

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
	DROP CONSTRAINT FK_Facturas_FormasDePago
GO
ALTER TABLE dbo.FormasDePago SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Facturas
	DROP CONSTRAINT FK_Facturas_Monedas
GO
ALTER TABLE dbo.Monedas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Facturas
	DROP CONSTRAINT FK_Facturas_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Facturas
	DROP CONSTRAINT FK_Facturas_TiposProveedor
GO
ALTER TABLE dbo.Proveedores
	DROP CONSTRAINT FK_Proveedores_TiposProveedor
GO
ALTER TABLE dbo.TiposProveedor SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Proveedores
	DROP CONSTRAINT FK_Proveedores_tCiudades
GO
ALTER TABLE dbo.tCiudades SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Proveedores
	(
	Proveedor int NOT NULL,
	Nombre nvarchar(50) NOT NULL,
	Tipo int NOT NULL,
	Rif nvarchar(20) NULL,
	NatJurFlag tinyint NOT NULL,
	Nit nvarchar(20) NULL,
	ContribuyenteEspecialFlag bit NULL,
	RetencionSobreIvaPorc decimal(5, 2) NULL,
	NuestraRetencionSobreIvaPorc decimal(5, 2) NULL,
	AfectaLibroComprasFlag bit NULL,
	Beneficiario nvarchar(50) NULL,
	Concepto nvarchar(250) NULL,
	MontoCheque money NULL,
	Direccion nvarchar(255) NULL,
	Ciudad nvarchar(6) NULL,
	Telefono1 nvarchar(14) NULL,
	Telefono2 nvarchar(14) NULL,
	Fax nvarchar(14) NULL,
	Contacto1 nvarchar(50) NULL,
	Contacto2 nvarchar(50) NULL,
	NacionalExtranjeroFlag smallint NULL,
	SujetoARetencionFlag bit NULL,
	CodigoConceptoRetencion nvarchar(6) NULL,
	RetencionISLRSustraendo money NULL,
	MonedaDefault int NULL,
	FormaDePagoDefault int NULL,
	ProveedorClienteFlag smallint NULL,
	PorcentajeDeRetencion real NULL,
	AplicaIvaFlag bit NULL,
	CategoriaProveedor smallint NULL,
	MontoChequeEnMonExtFlag bit NULL,
	DirectorioCompaniaFlag bit NOT NULL,
	Ingreso datetime NOT NULL,
	UltAct datetime NOT NULL,
	Usuario nvarchar(25) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Proveedores SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.Proveedores)
	 EXEC('INSERT INTO dbo.Tmp_Proveedores (Proveedor, Nombre, Tipo, Rif, NatJurFlag, Nit, ContribuyenteEspecialFlag, RetencionSobreIvaPorc, NuestraRetencionSobreIvaPorc, AfectaLibroComprasFlag, Beneficiario, Concepto, MontoCheque, Direccion, Ciudad, Telefono1, Telefono2, Fax, Contacto1, Contacto2, NacionalExtranjeroFlag, SujetoARetencionFlag, CodigoConceptoRetencion, MonedaDefault, FormaDePagoDefault, ProveedorClienteFlag, PorcentajeDeRetencion, AplicaIvaFlag, CategoriaProveedor, MontoChequeEnMonExtFlag, DirectorioCompaniaFlag, Ingreso, UltAct, Usuario)
		SELECT Proveedor, Nombre, Tipo, Rif, NatJurFlag, Nit, ContribuyenteEspecialFlag, RetencionSobreIvaPorc, NuestraRetencionSobreIvaPorc, AfectaLibroComprasFlag, Beneficiario, Concepto, MontoCheque, Direccion, Ciudad, Telefono1, Telefono2, Fax, Contacto1, Contacto2, NacionalExtranjeroFlag, SujetoARetencionFlag, CodigoConceptoRetencion, MonedaDefault, FormaDePagoDefault, ProveedorClienteFlag, PorcentajeDeRetencion, AplicaIvaFlag, CategoriaProveedor, MontoChequeEnMonExtFlag, DirectorioCompaniaFlag, Ingreso, UltAct, Usuario FROM dbo.Proveedores WITH (HOLDLOCK TABLOCKX)')
GO
ALTER TABLE dbo.Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad
	DROP CONSTRAINT FK_Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad_Proveedores
GO
ALTER TABLE dbo.Personas
	DROP CONSTRAINT FK_Personas_Proveedores
GO
ALTER TABLE dbo.Facturas
	DROP CONSTRAINT FK_Facturas_Proveedores
GO
ALTER TABLE dbo.CuotasFactura
	DROP CONSTRAINT FK_CuotasFactura_Proveedores
GO
ALTER TABLE dbo.SaldosCompanias
	DROP CONSTRAINT FK_SaldosCompanias_Proveedores
GO
ALTER TABLE dbo.Pagos
	DROP CONSTRAINT FK_Pagos_Proveedores
GO
ALTER TABLE dbo.OrdenesPago
	DROP CONSTRAINT FK_OrdenesPago_Proveedores
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Proveedores
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos
	DROP CONSTRAINT FK_CajaChica_Reposiciones_Gastos_Proveedores
GO
DROP TABLE dbo.Proveedores
GO
EXECUTE sp_rename N'dbo.Tmp_Proveedores', N'Proveedores', 'OBJECT' 
GO
ALTER TABLE dbo.Proveedores ADD CONSTRAINT
	PK_Proveedores PRIMARY KEY NONCLUSTERED 
	(
	Proveedor
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Proveedores WITH NOCHECK ADD CONSTRAINT
	FK_Proveedores_tCiudades FOREIGN KEY
	(
	Ciudad
	) REFERENCES dbo.tCiudades
	(
	Ciudad
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Proveedores WITH NOCHECK ADD CONSTRAINT
	FK_Proveedores_TiposProveedor FOREIGN KEY
	(
	Tipo
	) REFERENCES dbo.TiposProveedor
	(
	Tipo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos ADD CONSTRAINT
	FK_CajaChica_Reposiciones_Gastos_Proveedores FOREIGN KEY
	(
	Proveedor
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.MovimientosBancarios WITH NOCHECK ADD CONSTRAINT
	FK_MovimientosBancarios_Proveedores FOREIGN KEY
	(
	ProvClte
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.MovimientosBancarios SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.OrdenesPago WITH NOCHECK ADD CONSTRAINT
	FK_OrdenesPago_Proveedores FOREIGN KEY
	(
	Proveedor
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.OrdenesPago SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Pagos WITH NOCHECK ADD CONSTRAINT
	FK_Pagos_Proveedores FOREIGN KEY
	(
	Proveedor
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Pagos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.SaldosCompanias WITH NOCHECK ADD CONSTRAINT
	FK_SaldosCompanias_Proveedores FOREIGN KEY
	(
	Compania
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.SaldosCompanias SET (LOCK_ESCALATION = TABLE)
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
	TipoAlicuota char(1) NULL,
	IvaPorc real NULL,
	Iva money NULL,
	TotalFactura money NOT NULL,
	CodigoConceptoRetencion nvarchar(6) NULL,
	MontoSujetoARetencion money NULL,
	ImpuestoRetenidoPorc real NULL,
	ImpuestoRetenidoISLRAntesSustraendo money NULL,
	ImpuestoRetenidoISLRSustraendo money NULL,
	ImpuestoRetenido money NULL,
	FRecepcionRetencionISLR datetime NULL,
	RetencionSobreIvaPorc real NULL,
	RetencionSobreIva money NULL,
	FRecepcionRetencionIVA datetime NULL,
	TotalAPagar money NOT NULL,
	Anticipo money NULL,
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
ALTER TABLE dbo.Tmp_Facturas SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.Facturas)
	 EXEC('INSERT INTO dbo.Tmp_Facturas (ClaveUnica, Proveedor, NumeroFactura, NumeroControl, NcNdFlag, NumeroFacturaAfectada, NumeroComprobante, NumeroOperacion, Tipo, NumeroPlanillaImportacion, CondicionesDePago, FechaEmision, FechaRecepcion, Concepto, MontoFacturaSinIva, MontoFacturaConIva, TipoAlicuota, IvaPorc, Iva, TotalFactura, CodigoConceptoRetencion, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenido, FRecepcionRetencionISLR, RetencionSobreIvaPorc, RetencionSobreIva, FRecepcionRetencionIVA, TotalAPagar, Anticipo, Saldo, Estado, NumeroDeCuotas, FechaUltimoVencimiento, ClaveUnicaUltimoPago, Moneda, CxCCxPFlag, Comprobante, ImportacionFlag, DistribuirEnCondominioFlag, GrupoCondominio, CierreCondominio, CodigoInmueble, Cia)
		SELECT ClaveUnica, Proveedor, NumeroFactura, NumeroControl, NcNdFlag, NumeroFacturaAfectada, NumeroComprobante, NumeroOperacion, Tipo, NumeroPlanillaImportacion, CondicionesDePago, FechaEmision, FechaRecepcion, Concepto, MontoFacturaSinIva, MontoFacturaConIva, TipoAlicuota, IvaPorc, Iva, TotalFactura, CodigoConceptoRetencion, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenido, FRecepcionRetencionISLR, RetencionSobreIvaPorc, RetencionSobreIva, FRecepcionRetencionIVA, TotalAPagar, Anticipo, Saldo, Estado, NumeroDeCuotas, FechaUltimoVencimiento, ClaveUnicaUltimoPago, Moneda, CxCCxPFlag, Comprobante, ImportacionFlag, DistribuirEnCondominioFlag, GrupoCondominio, CierreCondominio, CodigoInmueble, Cia FROM dbo.Facturas WITH (HOLDLOCK TABLOCKX)')
GO
ALTER TABLE dbo.dPagos
	DROP CONSTRAINT FK_dPagos_Facturas
GO
ALTER TABLE dbo.OrdenesPagoFacturas
	DROP CONSTRAINT FK_OrdenesPagoFacturas_Facturas1
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
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE UNIQUE NONCLUSTERED INDEX i_pn_Facturas ON dbo.Facturas
	(
	Proveedor,
	NumeroFactura,
	Cia
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.Facturas WITH NOCHECK ADD CONSTRAINT
	FK_Facturas_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Facturas WITH NOCHECK ADD CONSTRAINT
	FK_Facturas_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Facturas WITH NOCHECK ADD CONSTRAINT
	FK_Facturas_FormasDePago FOREIGN KEY
	(
	CondicionesDePago
	) REFERENCES dbo.FormasDePago
	(
	FormaDePago
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Facturas WITH NOCHECK ADD CONSTRAINT
	FK_Facturas_TiposProveedor FOREIGN KEY
	(
	Tipo
	) REFERENCES dbo.TiposProveedor
	(
	Tipo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Facturas WITH NOCHECK ADD CONSTRAINT
	FK_Facturas_Proveedores FOREIGN KEY
	(
	Proveedor
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
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
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CuotasFactura ADD CONSTRAINT
	FK_CuotasFactura_Proveedores FOREIGN KEY
	(
	Proveedor
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CuotasFactura SET (LOCK_ESCALATION = TABLE)
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
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.OrdenesPagoFacturas SET (LOCK_ESCALATION = TABLE)
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
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.dPagos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Personas WITH NOCHECK ADD CONSTRAINT
	FK_Personas_Proveedores FOREIGN KEY
	(
	Compania
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Personas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad ADD CONSTRAINT
	FK_Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad_Proveedores FOREIGN KEY
	(
	ProvClte
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad SET (LOCK_ESCALATION = TABLE)
GO
COMMIT





/****** Object:  Table [dbo].[tTempCartaImpuestosRetenidos]    Script Date: 07/14/2010 11:27:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tTempCartaImpuestosRetenidos]') AND type in (N'U'))
DROP TABLE [dbo].[tTempCartaImpuestosRetenidos]
GO


/****** Object:  Table [dbo].[tTempCartaImpuestosRetenidos]    Script Date: 07/14/2010 11:27:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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
	[Concepto] [ntext] NULL,
	[MontoFactura] [money] NULL,
	[MontoSujetoARetencion] [money] NULL,
	[ImpuestoRetenidoPorc] [real] NULL,
	[ImpuestoRetenidoISLRSustraendo] [money] NULL,
	[ImpuestoRetenido] [money] NULL,
	[TotalFactura] [money] NULL,
	[NumeroUsuario] [int] NULL,
 CONSTRAINT [PK_tTempCartaImpuestosRetenidos] PRIMARY KEY NONCLUSTERED 
(
	[ClaveUnica] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


/****** Object:  Table [dbo].[tTempWebReport_ConsultaFacturas]    Script Date: 07/14/2010 11:28:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tTempWebReport_ConsultaFacturas]') AND type in (N'U'))
DROP TABLE [dbo].[tTempWebReport_ConsultaFacturas]
GO


/****** Object:  Table [dbo].[tTempWebReport_ConsultaFacturas]    Script Date: 07/14/2010 11:28:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tTempWebReport_ConsultaFacturas](
	[Moneda] [int] NOT NULL,
	[CiaContab] [int] NOT NULL,
	[Compania] [int] NOT NULL,
	[NombreCompania] [nvarchar](50) NOT NULL,
	[RifCompania] [nvarchar](20) NULL,
	[CodigoConceptoRetencion] [nvarchar](6) NULL,
	[NumeroFactura] [nvarchar](25) NOT NULL,
	[NumeroControl] [nvarchar](20) NULL,
	[ImportacionFlag] [bit] NULL,
	[Importacion_CompraNacional] [nvarchar](50) NULL,
	[ClaveUnicaFactura] [int] NOT NULL,
	[NcNdFlag] [char](2) NULL,
	[Compra_NotaCredito] [nvarchar](50) NULL,
	[NumeroFacturaAfectada] [nvarchar](20) NULL,
	[NumeroComprobante] [char](14) NULL,
	[NumeroOperacion] [smallint] NULL,
	[Tipo] [int] NOT NULL,
	[NombreTipo] [nvarchar](50) NOT NULL,
	[CondicionesDePago] [int] NOT NULL,
	[FechaEmision] [datetime] NOT NULL,
	[FechaRecepcion] [datetime] NOT NULL,
	[Concepto] [ntext] NULL,
	[MontoFacturaSinIva] [money] NULL,
	[MontoFacturaConIva] [money] NULL,
	[BaseImponible_Reducido] [money] NULL,
	[BaseImponible_General] [money] NULL,
	[BaseImponible_Adicional] [money] NULL,
	[TipoAlicuota] [char](1) NULL,
	[IvaPorc] [real] NULL,
	[IvaPorc_Reducido] [real] NULL,
	[IvaPorc_General] [real] NULL,
	[IvaPorc_Adicional] [real] NULL,
	[Iva] [money] NULL,
	[Iva_Reducido] [money] NULL,
	[Iva_General] [money] NULL,
	[Iva_Adicional] [money] NULL,
	[TotalFactura] [money] NOT NULL,
	[MontoSujetoARetencion] [money] NULL,
	[ImpuestoRetenidoPorc] [real] NULL,
	[ImpuestoRetenidoISLRAntesSustraendo] [money] NULL,
	[ImpuestoRetenidoISLRSustraendo] [money] NULL,
	[ImpuestoRetenido] [money] NULL,
	[ImpuestoRetenido_Reducido] [money] NULL,
	[ImpuestoRetenido_General] [money] NULL,
	[ImpuestoRetenido_Adicional] [money] NULL,
	[FRecepcionRetencionISLR] [datetime] NULL,
	[RetencionSobreIvaPorc] [real] NULL,
	[RetencionSobreIva] [money] NULL,
	[FRecepcionRetencionIVA] [datetime] NULL,
	[TotalAPagar] [money] NOT NULL,
	[Anticipo] [money] NULL,
	[Saldo] [money] NOT NULL,
	[Estado] [smallint] NOT NULL,
	[NombreEstado] [nchar](10) NULL,
	[NumeroDeCuotas] [smallint] NULL,
	[FechaUltimoVencimiento] [datetime] NULL,
	[CxCCxPFlag] [smallint] NOT NULL,
	[NombreCxCCxPFlag] [char](4) NOT NULL,
	[Comprobante] [int] NULL,
	[FechaPago] [datetime] NULL,
	[MontoPagado] [money] NULL,
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_tTempWebReport_ConsultaFacturas] PRIMARY KEY CLUSTERED 
(
	[Moneda] ASC,
	[CiaContab] ASC,
	[Compania] ASC,
	[NumeroFactura] ASC,
	[NombreUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


/****** Object:  View [dbo].[qFormaProveedoresConsulta]    Script Date: 07/14/2010 11:28:54 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qFormaProveedoresConsulta]'))
DROP VIEW [dbo].[qFormaProveedoresConsulta]
GO

/****** Object:  View [dbo].[qFormaProveedoresConsulta]    Script Date: 07/14/2010 11:28:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[qFormaProveedoresConsulta]
AS
SELECT     dbo.Proveedores.Proveedor, dbo.Proveedores.Nombre, dbo.Proveedores.Tipo, dbo.TiposProveedor.Descripcion AS NombreTipoProveedor, 
                      dbo.Proveedores.Rif, dbo.Proveedores.NatJurFlag, dbo.Proveedores.Nit, dbo.Proveedores.ContribuyenteEspecialFlag, 
                      dbo.Proveedores.RetencionSobreIvaPorc, dbo.Proveedores.NuestraRetencionSobreIvaPorc, dbo.Proveedores.AfectaLibroComprasFlag, 
                      dbo.Proveedores.Beneficiario, dbo.Proveedores.Concepto, dbo.Proveedores.MontoCheque, dbo.Proveedores.Direccion, dbo.Proveedores.Ciudad, 
                      dbo.tCiudades.Descripcion AS NombreCiudad, dbo.Proveedores.Telefono1, dbo.Proveedores.Telefono2, dbo.Proveedores.Fax, 
                      dbo.Proveedores.Contacto1, dbo.Proveedores.Contacto2, dbo.Proveedores.NacionalExtranjeroFlag, dbo.Proveedores.SujetoARetencionFlag, 
                      dbo.Proveedores.MonedaDefault, dbo.Monedas.Simbolo AS SimboloMoneda, dbo.Proveedores.FormaDePagoDefault, 
                      dbo.FormasDePago.Descripcion AS NombreFormaDePago, dbo.Proveedores.ProveedorClienteFlag, dbo.Proveedores.PorcentajeDeRetencion, 
                      dbo.Proveedores.CodigoConceptoRetencion, dbo.Proveedores.RetencionISLRSustraendo, dbo.Proveedores.AplicaIvaFlag, 
                      dbo.Proveedores.CategoriaProveedor, dbo.Proveedores.MontoChequeEnMonExtFlag, dbo.Proveedores.DirectorioCompaniaFlag, 
                      dbo.Proveedores.Ingreso, dbo.Proveedores.UltAct, dbo.Proveedores.Usuario, 
                      dbo.CategoriasRetencion.Descripcion AS NombreCategoriaRetencion
FROM         dbo.Proveedores LEFT OUTER JOIN
                      dbo.CategoriasRetencion ON dbo.Proveedores.CategoriaProveedor = dbo.CategoriasRetencion.Categoria LEFT OUTER JOIN
                      dbo.FormasDePago ON dbo.Proveedores.FormaDePagoDefault = dbo.FormasDePago.FormaDePago LEFT OUTER JOIN
                      dbo.tCiudades ON dbo.Proveedores.Ciudad = dbo.tCiudades.Ciudad LEFT OUTER JOIN
                      dbo.Monedas ON dbo.Proveedores.MonedaDefault = dbo.Monedas.Moneda LEFT OUTER JOIN
                      dbo.TiposProveedor ON dbo.Proveedores.Tipo = dbo.TiposProveedor.Tipo

GO



/****** Object:  View [dbo].[qFormaFacturasConsulta]    Script Date: 07/14/2010 11:29:14 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qFormaFacturasConsulta]'))
DROP VIEW [dbo].[qFormaFacturasConsulta]
GO

/****** Object:  View [dbo].[qFormaFacturasConsulta]    Script Date: 07/14/2010 11:29:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[qFormaFacturasConsulta]
AS
SELECT     dbo.Facturas.ClaveUnica, dbo.Facturas.Proveedor, dbo.Proveedores.Nombre AS NombreProveedor, dbo.Facturas.NumeroFactura, 
                      dbo.Facturas.NumeroControl, dbo.Facturas.NcNdFlag, dbo.Facturas.NumeroFacturaAfectada, dbo.Facturas.NumeroComprobante, 
                      dbo.Facturas.NumeroOperacion, dbo.Facturas.CondicionesDePago, dbo.Facturas.Tipo, dbo.Facturas.NumeroPlanillaImportacion, 
                      dbo.TiposProveedor.Descripcion AS NombreTipo, dbo.FormasDePago.Descripcion AS NombreCondicionesDePago, dbo.Facturas.FechaEmision, 
                      dbo.Facturas.FechaRecepcion, dbo.Facturas.Concepto, dbo.Facturas.MontoFacturaSinIva, dbo.Facturas.MontoFacturaConIva, 
                      dbo.Facturas.TipoAlicuota, dbo.Facturas.IvaPorc, dbo.Facturas.Iva, dbo.Facturas.TotalFactura, dbo.Facturas.CodigoConceptoRetencion, 
                      dbo.Facturas.MontoSujetoARetencion, dbo.Facturas.ImpuestoRetenidoPorc, dbo.Facturas.ImpuestoRetenidoISLRAntesSustraendo, 
                      dbo.Facturas.ImpuestoRetenidoISLRSustraendo, dbo.Facturas.ImpuestoRetenido, dbo.Facturas.FRecepcionRetencionISLR, 
                      dbo.Facturas.RetencionSobreIvaPorc, dbo.Facturas.RetencionSobreIva, dbo.Facturas.FRecepcionRetencionIVA, dbo.Facturas.TotalAPagar, 
                      dbo.Facturas.Anticipo, dbo.Facturas.Saldo, dbo.Facturas.Estado, dbo.Facturas.ImportacionFlag, dbo.Facturas.Comprobante, dbo.Facturas.CxCCxPFlag, 
                      dbo.Facturas.Moneda, dbo.Facturas.ClaveUnicaUltimoPago, dbo.Facturas.FechaUltimoVencimiento, dbo.Facturas.NumeroDeCuotas, 
                      dbo.Facturas.DistribuirEnCondominioFlag, dbo.Facturas.GrupoCondominio, dbo.Facturas.CierreCondominio, dbo.Facturas.CodigoInmueble, 
                      dbo.Facturas.Cia
FROM         dbo.Facturas LEFT OUTER JOIN
                      dbo.TiposProveedor ON dbo.Facturas.Tipo = dbo.TiposProveedor.Tipo LEFT OUTER JOIN
                      dbo.Proveedores ON dbo.Facturas.Proveedor = dbo.Proveedores.Proveedor LEFT OUTER JOIN
                      dbo.FormasDePago ON dbo.Facturas.CondicionesDePago = dbo.FormasDePago.FormaDePago

GO



/****** Object:  View [dbo].[qFormaFacturas]    Script Date: 07/14/2010 11:29:30 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qFormaFacturas]'))
DROP VIEW [dbo].[qFormaFacturas]
GO


/****** Object:  View [dbo].[qReportCartaImpuestosRetenidos]    Script Date: 07/14/2010 11:29:47 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qReportCartaImpuestosRetenidos]'))
DROP VIEW [dbo].[qReportCartaImpuestosRetenidos]
GO


/****** Object:  View [dbo].[qFormaProveedores]    Script Date: 07/14/2010 11:30:06 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qFormaProveedores]'))
DROP VIEW [dbo].[qFormaProveedores]
GO


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
ALTER TABLE dbo.Proveedores
	DROP COLUMN DirectorioCompaniaFlag
GO
ALTER TABLE dbo.Proveedores SET (LOCK_ESCALATION = TABLE)
GO
COMMIT




/****** Object:  Table [dbo].[tTempPrintChequesContinuos]    Script Date: 07/15/2010 14:06:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tTempPrintChequesContinuos]') AND type in (N'U'))
DROP TABLE [dbo].[tTempPrintChequesContinuos]
GO

/****** Object:  Table [dbo].[tTempPrintChequesContinuos]    Script Date: 07/15/2010 14:06:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tTempPrintChequesContinuos](
	[ClaveUnica] [int] IDENTITY(1,1) NOT NULL,
	[Beneficiario] [nvarchar](60) NULL,
	[NombreBeneficiario] [nvarchar](100) NULL,
	[ConceptoCheque] [nvarchar](300) NULL,
	[sFechaEscrita] [nvarchar](50) NULL,
	[Fecha] [datetime] NULL,
	[FechaCortaEditada] [nvarchar](15) NULL,
	[Ano] [smallint] NULL,
	[NombreCompania] [nvarchar](50) NULL,
	[NumeroComprobante] [int] NULL,
	[NumeroCheque] [nvarchar](20) NULL,
	[CuentaBancaria] [nvarchar](50) NULL,
	[SimboloMoneda] [nvarchar](10) NULL,
	[NombreCiudad] [nvarchar](50) NULL,
	[EndosableFlag] [bit] NULL,
	[ClaveUnicaComprobante] [int] NULL,
	[NombreBanco] [nvarchar](50) NULL,
	[sMonto] [nvarchar](50) NULL,
	[ElaboradoPor] [nvarchar](25) NULL,
	[RevisadoPor] [nvarchar](25) NULL,
	[AprovadoPor] [nvarchar](25) NULL,
	[ContabilizadoPor] [nvarchar](25) NULL,
	[CuentaContable1] [nvarchar](30) NULL,
	[NombreCtaCont1] [nvarchar](40) NULL,
	[DescripcionPartida1] [nvarchar](50) NULL,
	[sDebeOHaber1] [nvarchar](25) NULL,
	[CuentaContable2] [nvarchar](30) NULL,
	[NombreCtaCont2] [nvarchar](40) NULL,
	[DescripcionPartida2] [nvarchar](50) NULL,
	[sDebeOHaber2] [nvarchar](25) NULL,
	[CuentaContable3] [nvarchar](30) NULL,
	[NombreCtaCont3] [nvarchar](40) NULL,
	[DescripcionPartida3] [nvarchar](50) NULL,
	[sDebeOHaber3] [nvarchar](25) NULL,
	[CuentaContable4] [nvarchar](30) NULL,
	[NombreCtaCont4] [nvarchar](40) NULL,
	[DescripcionPartida4] [nvarchar](50) NULL,
	[sDebeOHaber4] [nvarchar](25) NULL,
	[CuentaContable5] [nvarchar](30) NULL,
	[NombreCtaCont5] [nvarchar](40) NULL,
	[DescripcionPartida5] [nvarchar](50) NULL,
	[sDebeOHaber5] [nvarchar](25) NULL,
	[CuentaContable6] [nvarchar](30) NULL,
	[NombreCtaCont6] [nvarchar](40) NULL,
	[DescripcionPartida6] [nvarchar](50) NULL,
	[sDebeOHaber6] [nvarchar](25) NULL,
	[CuentaContable7] [nvarchar](30) NULL,
	[NombreCtaCont7] [nvarchar](40) NULL,
	[DescripcionPartida7] [nvarchar](50) NULL,
	[sDebeOHaber7] [nvarchar](25) NULL,
	[CuentaContable8] [nvarchar](30) NULL,
	[NombreCtaCont8] [nvarchar](40) NULL,
	[DescripcionPartida8] [nvarchar](50) NULL,
	[sDebeOHaber8] [nvarchar](25) NULL,
	[CuentaContable9] [nvarchar](30) NULL,
	[NombreCtaCont9] [nvarchar](40) NULL,
	[DescripcionPartida9] [nvarchar](50) NULL,
	[sDebeOHaber9] [nvarchar](25) NULL,
	[CuentaContable10] [nvarchar](30) NULL,
	[NombreCtaCont10] [nvarchar](40) NULL,
	[DescripcionPartida10] [nvarchar](50) NULL,
	[sDebeOHaber10] [nvarchar](25) NULL,
	[CuentaContable11] [nvarchar](30) NULL,
	[NombreCtaCont11] [nvarchar](40) NULL,
	[DescripcionPartida11] [nvarchar](50) NULL,
	[sDebeOHaber11] [nvarchar](25) NULL,
	[CuentaContable12] [nvarchar](30) NULL,
	[NombreCtaCont12] [nvarchar](40) NULL,
	[DescripcionPartida12] [nvarchar](50) NULL,
	[sDebeOHaber12] [nvarchar](25) NULL,
	[CuentaContable13] [nvarchar](30) NULL,
	[NombreCtaCont13] [nvarchar](40) NULL,
	[DescripcionPartida13] [nvarchar](50) NULL,
	[sDebeOHaber13] [nvarchar](25) NULL,
	[CuentaContable14] [nvarchar](30) NULL,
	[NombreCtaCont14] [nvarchar](40) NULL,
	[DescripcionPartida14] [nvarchar](50) NULL,
	[sDebeOHaber14] [nvarchar](25) NULL,
	[CuentaContable15] [nvarchar](30) NULL,
	[NombreCtaCont15] [nvarchar](40) NULL,
	[DescripcionPartida15] [nvarchar](50) NULL,
	[sDebeOHaber15] [nvarchar](25) NULL,
	[NumeroUsuario] [int] NOT NULL,
 CONSTRAINT [PK_tTempPrintChequesContinuos] PRIMARY KEY NONCLUSTERED 
(
	[ClaveUnica] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.265', GetDate()) 