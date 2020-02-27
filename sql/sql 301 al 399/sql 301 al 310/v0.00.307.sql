/*    Viernes, 23 de Marzo de 2.012  -   v0.00.307.sql 

	Hacemos ajustes leves a las tablas Facturas y CuotasFacturas
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
	DROP CONSTRAINT FK_Facturas_Monedas
GO
ALTER TABLE dbo.Monedas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Facturas
	DROP CONSTRAINT FK_Facturas_Proveedores
GO
ALTER TABLE dbo.Proveedores SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
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
	DROP CONSTRAINT FK_Facturas_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
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
	TotalAPagar money NOT NULL,
	Anticipo money NULL,
	Saldo money NOT NULL,
	Estado smallint NOT NULL,
	ClaveUnicaUltimoPago int NULL,
	Moneda int NOT NULL,
	CxCCxPFlag smallint NOT NULL,
	Comprobante int NULL,
	ImportacionFlag bit NULL,
	Ingreso datetime2(7) NULL,
	UltAct datetime2(7) NULL,
	Usuario nvarchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Facturas SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Facturas ON
GO
IF EXISTS(SELECT * FROM dbo.Facturas)
	 EXEC('INSERT INTO dbo.Tmp_Facturas (ClaveUnica, Proveedor, NumeroFactura, NumeroControl, NcNdFlag, NumeroFacturaAfectada, NumeroComprobante, NumeroOperacion, Tipo, NumeroPlanillaImportacion, CondicionesDePago, FechaEmision, FechaRecepcion, Concepto, MontoFacturaSinIva, MontoFacturaConIva, TipoAlicuota, IvaPorc, Iva, TotalFactura, CodigoConceptoRetencion, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenidoISLRAntesSustraendo, ImpuestoRetenidoISLRSustraendo, ImpuestoRetenido, FRecepcionRetencionISLR, RetencionSobreIvaPorc, RetencionSobreIva, FRecepcionRetencionIVA, TotalAPagar, Anticipo, Saldo, Estado, ClaveUnicaUltimoPago, Moneda, CxCCxPFlag, Comprobante, ImportacionFlag, Cia)
		SELECT ClaveUnica, Proveedor, NumeroFactura, NumeroControl, NcNdFlag, NumeroFacturaAfectada, NumeroComprobante, NumeroOperacion, Tipo, NumeroPlanillaImportacion, CondicionesDePago, CONVERT(date, FechaEmision), CONVERT(date, FechaRecepcion), Concepto, MontoFacturaSinIva, MontoFacturaConIva, TipoAlicuota, CONVERT(decimal(6, 3), IvaPorc), Iva, TotalFactura, CodigoConceptoRetencion, MontoSujetoARetencion, CONVERT(decimal(6, 3), ImpuestoRetenidoPorc), ImpuestoRetenidoISLRAntesSustraendo, ImpuestoRetenidoISLRSustraendo, ImpuestoRetenido, CONVERT(date, FRecepcionRetencionISLR), CONVERT(decimal(6, 3), RetencionSobreIvaPorc), RetencionSobreIva, CONVERT(date, FRecepcionRetencionIVA), TotalAPagar, Anticipo, Saldo, Estado, ClaveUnicaUltimoPago, Moneda, CxCCxPFlag, Comprobante, ImportacionFlag, Cia FROM dbo.Facturas WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Facturas OFF
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
CREATE TABLE dbo.Tmp_CuotasFactura
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	ClaveUnicaFactura int NOT NULL,
	NumeroCuota smallint NOT NULL,
	DiasVencimiento smallint NOT NULL,
	FechaVencimiento date NOT NULL,
	ProporcionCuota decimal(6, 3) NOT NULL,
	MontoCuota money NOT NULL,
	Iva money NOT NULL,
	RetencionSobreIva money NULL,
	TotalCuota money NOT NULL,
	Anticipo money NULL,
	SaldoCuota money NOT NULL,
	EstadoCuota smallint NOT NULL,
	ProporcionIva real NOT NULL,
	CantidadDeCuotas smallint NOT NULL,
	ClaveUnicaUltimoPago int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_CuotasFactura SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_CuotasFactura ON
GO
IF EXISTS(SELECT * FROM dbo.CuotasFactura)
	 EXEC('INSERT INTO dbo.Tmp_CuotasFactura (ClaveUnica, ClaveUnicaFactura, NumeroCuota, DiasVencimiento, FechaVencimiento, ProporcionCuota, MontoCuota, Iva, RetencionSobreIva, TotalCuota, Anticipo, SaldoCuota, EstadoCuota, ProporcionIva, CantidadDeCuotas, ClaveUnicaUltimoPago)
		SELECT ClaveUnica, ClaveUnicaFactura, NumeroCuota, DiasVencimiento, CONVERT(date, FechaVencimiento), CONVERT(decimal(6, 3), ProporcionCuota), MontoCuota, Iva, RetencionSobreIva, TotalCuota, Anticipo, SaldoCuota, EstadoCuota, ProporcionIva, CantidadDeCuotas, ClaveUnicaUltimoPago FROM dbo.CuotasFactura WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_CuotasFactura OFF
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




Update Facturas Set 
Ingreso = FechaEmision, 
UltAct = FechaEmision,
Usuario = 'no user'

Alter Table Facturas 
Alter Column Ingreso datetime2(7) Not Null 

Alter Table Facturas 
Alter Column UltAct datetime2(7) Not Null 

Alter Table Facturas 
Alter Column Usuario nvarchar(25) Not Null 


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.307', GetDate()) 