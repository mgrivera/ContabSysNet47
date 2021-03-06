/*    S�bado, 14 de Diciembre de 2.013 	-   v0.00.364a.sql 

	Facturas: Otros impuestos y retenciones - cambios para implementar �sto 
	
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
ALTER TABLE dbo.DefinicionCuentasContables
	DROP CONSTRAINT FK_DefinicionCuentasContables_CuentasContables
GO
ALTER TABLE dbo.CuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.DefinicionCuentasContables
	DROP CONSTRAINT FK_DefinicionCuentasContables_Monedas
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
ALTER TABLE dbo.DefinicionCuentasContables
	DROP CONSTRAINT FK_DefinicionCuentasContables_TiposProveedor
GO
ALTER TABLE dbo.Facturas
	DROP CONSTRAINT FK_Facturas_TiposProveedor
GO
ALTER TABLE dbo.TiposProveedor SET (LOCK_ESCALATION = TABLE)
GO
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
	DROP CONSTRAINT FK_Facturas_Proveedores
GO
ALTER TABLE dbo.DefinicionCuentasContables
	DROP CONSTRAINT FK_DefinicionCuentasContables_Proveedores
GO
ALTER TABLE dbo.Proveedores SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.ImpuestosRetencionesDefinicion
	(
	ID int NOT NULL IDENTITY (1, 1),
	Descripcion nvarchar(50) NOT NULL,
	Base smallint NULL,
	Porcentaje decimal(5, 3) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.ImpuestosRetencionesDefinicion ADD CONSTRAINT
	PK_ImpuestosRetencionesDefinicion PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.ImpuestosRetencionesDefinicion SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_DefinicionCuentasContables
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	Rubro int NULL,
	Compania int NULL,
	Moneda int NULL,
	Concepto smallint NOT NULL,
	Concepto2 smallint NULL,
	CuentaContableID int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_DefinicionCuentasContables SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_DefinicionCuentasContables ON
GO
IF EXISTS(SELECT * FROM dbo.DefinicionCuentasContables)
	 EXEC('INSERT INTO dbo.Tmp_DefinicionCuentasContables (ClaveUnica, Rubro, Compania, Moneda, Concepto, CuentaContableID)
		SELECT ClaveUnica, Rubro, Compania, Moneda, Concepto, CuentaContableID FROM dbo.DefinicionCuentasContables WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_DefinicionCuentasContables OFF
GO
DROP TABLE dbo.DefinicionCuentasContables
GO
EXECUTE sp_rename N'dbo.Tmp_DefinicionCuentasContables', N'DefinicionCuentasContables', 'OBJECT' 
GO
ALTER TABLE dbo.DefinicionCuentasContables ADD CONSTRAINT
	PK_DefinicionCuentasContables PRIMARY KEY NONCLUSTERED 
	(
	ClaveUnica
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.DefinicionCuentasContables ADD CONSTRAINT
	FK_DefinicionCuentasContables_Proveedores FOREIGN KEY
	(
	Compania
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.DefinicionCuentasContables ADD CONSTRAINT
	FK_DefinicionCuentasContables_TiposProveedor FOREIGN KEY
	(
	Rubro
	) REFERENCES dbo.TiposProveedor
	(
	Tipo
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.DefinicionCuentasContables ADD CONSTRAINT
	FK_DefinicionCuentasContables_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.DefinicionCuentasContables ADD CONSTRAINT
	FK_DefinicionCuentasContables_CuentasContables FOREIGN KEY
	(
	CuentaContableID
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Facturas
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	Proveedor int NOT NULL,
	NumeroFactura nvarchar(25) NOT NULL,
	NumeroControl nvarchar(20) NULL,
	NcNdFlag char(2) NULL,
	NumeroFacturaAfectada nvarchar(20) NULL,
	NumeroComprobante char(14) NULL,
	NumeroOperacion smallint NULL,
	ComprobanteSeniat_UsarUnoExistente_Flag bit NULL,
	Tipo int NOT NULL,
	NumeroPlanillaImportacion nvarchar(25) NULL,
	CondicionesDePago int NOT NULL,
	FechaEmision date NOT NULL,
	FechaRecepcion date NOT NULL,
	Concepto ntext NULL,
	MontoFacturaSinIva money NULL,
	MontoFacturaConIva money NULL,
	TipoAlicuota char(1) NULL,
	IvaPorc decimal(6, 3) NULL,
	Iva money NULL,
	TotalFactura money NOT NULL,
	CodigoConceptoRetencion nvarchar(6) NULL,
	MontoSujetoARetencion money NULL,
	ImpuestoRetenidoPorc decimal(6, 3) NULL,
	ImpuestoRetenidoISLRAntesSustraendo money NULL,
	ImpuestoRetenidoISLRSustraendo money NULL,
	ImpuestoRetenido money NULL,
	FRecepcionRetencionISLR date NULL,
	RetencionSobreIvaPorc decimal(6, 3) NULL,
	RetencionSobreIva money NULL,
	FRecepcionRetencionIVA date NULL,
	OtrosImpuestosRetenciones money NULL,
	TotalAPagar money NOT NULL,
	Anticipo money NULL,
	Saldo money NOT NULL,
	Estado smallint NOT NULL,
	ClaveUnicaUltimoPago int NULL,
	Moneda int NOT NULL,
	CxCCxPFlag smallint NOT NULL,
	Comprobante int NULL,
	ImportacionFlag bit NULL,
	ModificadoPor nvarchar(10) NULL,
	Ingreso datetime2(7) NOT NULL,
	UltAct datetime2(7) NOT NULL,
	Usuario nvarchar(25) NOT NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Facturas SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Facturas ON
GO
IF EXISTS(SELECT * FROM dbo.Facturas)
	 EXEC('INSERT INTO dbo.Tmp_Facturas (ClaveUnica, Proveedor, NumeroFactura, NumeroControl, NcNdFlag, NumeroFacturaAfectada, NumeroComprobante, NumeroOperacion, ComprobanteSeniat_UsarUnoExistente_Flag, Tipo, NumeroPlanillaImportacion, CondicionesDePago, FechaEmision, FechaRecepcion, Concepto, MontoFacturaSinIva, MontoFacturaConIva, TipoAlicuota, IvaPorc, Iva, TotalFactura, CodigoConceptoRetencion, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenidoISLRAntesSustraendo, ImpuestoRetenidoISLRSustraendo, ImpuestoRetenido, FRecepcionRetencionISLR, RetencionSobreIvaPorc, RetencionSobreIva, FRecepcionRetencionIVA, TotalAPagar, Anticipo, Saldo, Estado, ClaveUnicaUltimoPago, Moneda, CxCCxPFlag, Comprobante, ImportacionFlag, ModificadoPor, Ingreso, UltAct, Usuario, Cia)
		SELECT ClaveUnica, Proveedor, NumeroFactura, NumeroControl, NcNdFlag, NumeroFacturaAfectada, NumeroComprobante, NumeroOperacion, ComprobanteSeniat_UsarUnoExistente_Flag, Tipo, NumeroPlanillaImportacion, CondicionesDePago, FechaEmision, FechaRecepcion, Concepto, MontoFacturaSinIva, MontoFacturaConIva, TipoAlicuota, IvaPorc, Iva, TotalFactura, CodigoConceptoRetencion, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenidoISLRAntesSustraendo, ImpuestoRetenidoISLRSustraendo, ImpuestoRetenido, FRecepcionRetencionISLR, RetencionSobreIvaPorc, RetencionSobreIva, FRecepcionRetencionIVA, TotalAPagar, Anticipo, Saldo, Estado, ClaveUnicaUltimoPago, Moneda, CxCCxPFlag, Comprobante, ImportacionFlag, ModificadoPor, Ingreso, UltAct, Usuario, Cia FROM dbo.Facturas WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Facturas OFF
GO
ALTER TABLE dbo.CuotasFactura
	DROP CONSTRAINT FK_CuotasFactura_Facturas
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
	FK_Facturas_Proveedores FOREIGN KEY
	(
	Proveedor
	) REFERENCES dbo.Proveedores
	(
	Proveedor
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
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Facturas_Impuestos
	(
	ID int NOT NULL IDENTITY (1, 1),
	FacturaID int NOT NULL,
	ImpRetID int NOT NULL,
	MontoBase money NULL,
	Porcentaje decimal(5, 3) NULL,
	Monto money NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Facturas_Impuestos ADD CONSTRAINT
	PK_Facturas_Impuestos PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Facturas_Impuestos ADD CONSTRAINT
	FK_Facturas_Impuestos_ImpuestosRetencionesDefinicion FOREIGN KEY
	(
	ImpRetID
	) REFERENCES dbo.ImpuestosRetencionesDefinicion
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Facturas_Impuestos ADD CONSTRAINT
	FK_Facturas_Impuestos_Facturas FOREIGN KEY
	(
	FacturaID
	) REFERENCES dbo.Facturas
	(
	ClaveUnica
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Facturas_Impuestos SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.CuotasFactura WITH NOCHECK ADD CONSTRAINT
	FK_CuotasFactura_Facturas FOREIGN KEY
	(
	ClaveUnicaFactura
	) REFERENCES dbo.Facturas
	(
	ClaveUnica
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.CuotasFactura SET (LOCK_ESCALATION = TABLE)
GO
COMMIT




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
ALTER TABLE dbo.CuotasFactura
	DROP CONSTRAINT FK_CuotasFactura_Facturas
GO
ALTER TABLE dbo.Facturas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_CuotasFactura
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	ClaveUnicaFactura int NOT NULL,
	NumeroCuota smallint NOT NULL,
	DiasVencimiento smallint NOT NULL,
	FechaVencimiento date NOT NULL,
	ProporcionCuota decimal(6, 3) NOT NULL,
	MontoCuota money NOT NULL,
	Iva money NULL,
	RetencionSobreIva money NULL,
	RetencionSobreISLR money NULL,
	OtrosImpuestosRetenciones money NULL,
	TotalCuota money NOT NULL,
	Anticipo money NULL,
	SaldoCuota money NOT NULL,
	EstadoCuota smallint NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_CuotasFactura SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_CuotasFactura ON
GO
IF EXISTS(SELECT * FROM dbo.CuotasFactura)
	 EXEC('INSERT INTO dbo.Tmp_CuotasFactura (ClaveUnica, ClaveUnicaFactura, NumeroCuota, DiasVencimiento, FechaVencimiento, ProporcionCuota, MontoCuota, Iva, RetencionSobreIva, RetencionSobreISLR, TotalCuota, Anticipo, SaldoCuota, EstadoCuota)
		SELECT ClaveUnica, ClaveUnicaFactura, NumeroCuota, DiasVencimiento, FechaVencimiento, ProporcionCuota, MontoCuota, Iva, RetencionSobreIva, RetencionSobreISLR, TotalCuota, Anticipo, SaldoCuota, EstadoCuota FROM dbo.CuotasFactura WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_CuotasFactura OFF
GO
ALTER TABLE dbo.dPagos
	DROP CONSTRAINT FK_dPagos_CuotasFactura
GO
DROP TABLE dbo.CuotasFactura
GO
EXECUTE sp_rename N'dbo.Tmp_CuotasFactura', N'CuotasFactura', 'OBJECT' 
GO
ALTER TABLE dbo.CuotasFactura ADD CONSTRAINT
	PK_CuotasFactura PRIMARY KEY NONCLUSTERED 
	(
	ClaveUnica
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.CuotasFactura WITH NOCHECK ADD CONSTRAINT
	FK_CuotasFactura_Facturas FOREIGN KEY
	(
	ClaveUnicaFactura
	) REFERENCES dbo.Facturas
	(
	ClaveUnica
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.dPagos ADD CONSTRAINT
	FK_dPagos_CuotasFactura FOREIGN KEY
	(
	ClaveUnicaCuotaFactura
	) REFERENCES dbo.CuotasFactura
	(
	ClaveUnica
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.dPagos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.364a', GetDate()) 
