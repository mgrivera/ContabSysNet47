/*    Sábado, 21 de Abril de 2.012  -   v0.00.310.sql 

	Hacemos cambios a la tabla Pagos ... 

	NOTA IMPORTANTE: este select no debe seleccionar rows 

	1) Select * From Pagos Where Concepto Is Null 
		para corregir si arriba falla 
		(Update Pagos Set Concepto = 'Indefinido' Where Concepto Is Null) 
	2) Select * From dPagos Where ClaveUnicaCuotaFactura Not In (Select ClaveUnica From CuotasFactura) 
	   (NOTA: en Geh obtuvimos 88 records; los vamos a eliminar pues si no están asociados a cuotas 
	          no deben hacer mucha diferencia si están o no) 
	          
		Eliminar los registros anteriores (revisar bien antes !!!) con esta instrucción: 
		
		Delete From dPagos Where ClaveUnicaCuotaFactura Not In (Select ClaveUnica From CuotasFactura) 
		
	
	Guao, este script es big ... ejecutar por partes ? 

*/


/* CAMBIOS A LA TABLA CUOTAS_FACTURAS */ 


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
	TotalCuota money NOT NULL,
	Anticipo money NULL,
	SaldoCuota money NOT NULL,
	EstadoCuota smallint NOT NULL,
	ClaveUnicaUltimoPago int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_CuotasFactura SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_CuotasFactura ON
GO
IF EXISTS(SELECT * FROM dbo.CuotasFactura)
	 EXEC('INSERT INTO dbo.Tmp_CuotasFactura (ClaveUnica, ClaveUnicaFactura, NumeroCuota, DiasVencimiento, FechaVencimiento, ProporcionCuota, MontoCuota, Iva, RetencionSobreIva, TotalCuota, Anticipo, SaldoCuota, EstadoCuota, ClaveUnicaUltimoPago)
		SELECT ClaveUnica, ClaveUnicaFactura, NumeroCuota, DiasVencimiento, FechaVencimiento, ProporcionCuota, MontoCuota, Iva, RetencionSobreIva, TotalCuota, Anticipo, SaldoCuota, EstadoCuota, ClaveUnicaUltimoPago FROM dbo.CuotasFactura WITH (HOLDLOCK TABLOCKX)')
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
EXECUTE sp_rename N'dbo.dFormasDePago.Proporcion', N'Tmp_ProporcionCuota', 'COLUMN' 
GO
EXECUTE sp_rename N'dbo.dFormasDePago.Tmp_ProporcionCuota', N'ProporcionCuota', 'COLUMN' 
GO
ALTER TABLE dbo.dFormasDePago ADD
	ProporcionRetencionIVA decimal(6, 3) NULL,
	ProporcionRetencionISLR decimal(6, 3) NULL
GO
ALTER TABLE dbo.dFormasDePago SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.dFormasDePago
	DROP CONSTRAINT FK_dFormasDePago_FormasDePago
GO
ALTER TABLE dbo.FormasDePago SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_dFormasDePago
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	FormaDePago int NOT NULL,
	NumeroDeCuota smallint NOT NULL,
	DiasDeVencimiento smallint NOT NULL,
	ProporcionCuota decimal(6, 3) NOT NULL,
	ProporcionIva decimal(6, 3) NULL,
	ProporcionRetencionIVA decimal(6, 3) NULL,
	ProporcionRetencionISLR decimal(6, 3) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_dFormasDePago SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_dFormasDePago ON
GO
IF EXISTS(SELECT * FROM dbo.dFormasDePago)
	 EXEC('INSERT INTO dbo.Tmp_dFormasDePago (ClaveUnica, FormaDePago, NumeroDeCuota, DiasDeVencimiento, ProporcionCuota, ProporcionIva, ProporcionRetencionIVA, ProporcionRetencionISLR)
		SELECT ClaveUnica, FormaDePago, NumeroDeCuota, DiasDeVencimiento, ProporcionCuota, ProporcionIva, ProporcionRetencionIVA, ProporcionRetencionISLR FROM dbo.dFormasDePago WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_dFormasDePago OFF
GO
DROP TABLE dbo.dFormasDePago
GO
EXECUTE sp_rename N'dbo.Tmp_dFormasDePago', N'dFormasDePago', 'OBJECT' 
GO
ALTER TABLE dbo.dFormasDePago ADD CONSTRAINT
	PK_dFormasDePago PRIMARY KEY NONCLUSTERED 
	(
	ClaveUnica
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.dFormasDePago ADD CONSTRAINT
	FK_dFormasDePago_FormasDePago FOREIGN KEY
	(
	FormaDePago
	) REFERENCES dbo.FormasDePago
	(
	FormaDePago
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT














/* CAMBIOS A LA TABLA PAGOS Y DPAGOS */ 


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
DROP TABLE dbo.PagosId
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Pagos
	DROP CONSTRAINT FK_Pagos_Monedas
GO
ALTER TABLE dbo.Monedas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Pagos
	DROP CONSTRAINT FK_Pagos_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Pagos
	DROP CONSTRAINT FK_Pagos_Proveedores
GO
ALTER TABLE dbo.Proveedores SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Pagos
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	Proveedor int NOT NULL,
	Moneda int NOT NULL,
	ClaveUnicaMovimientoBancario int NULL,
	NumeroPago nvarchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Fecha date NOT NULL,
	Monto money NULL,
	Concepto nvarchar(250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	MiSuFlag smallint NOT NULL,
	Ingreso datetime2(7) NOT NULL,
	UltAct datetime2(7) NOT NULL,
	Usuario nvarchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Pagos SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Pagos ON
GO
IF EXISTS(SELECT * FROM dbo.Pagos)
	 EXEC('INSERT INTO dbo.Tmp_Pagos (ClaveUnica, Proveedor, Moneda, ClaveUnicaMovimientoBancario, NumeroPago, Fecha, Monto, Concepto, MiSuFlag, Ingreso, UltAct, Usuario, Cia)
		SELECT ClaveUnica, Proveedor, Moneda, ClaveUnicaMovimientoBancario, NumeroPago, CONVERT(date, Fecha), Monto, Concepto, MiSuFlag, CONVERT(datetime2(7), Ingreso), CONVERT(datetime2(7), UltAct), Usuario, Cia FROM dbo.Pagos WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Pagos OFF
GO
ALTER TABLE dbo.dPagos
	DROP CONSTRAINT FK_dPagos_Pagos
GO
DROP TABLE dbo.Pagos
GO
EXECUTE sp_rename N'dbo.Tmp_Pagos', N'Pagos', 'OBJECT' 
GO
ALTER TABLE dbo.Pagos ADD CONSTRAINT
	PK_Pagos PRIMARY KEY NONCLUSTERED 
	(
	ClaveUnica
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

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
ALTER TABLE dbo.Pagos WITH NOCHECK ADD CONSTRAINT
	FK_Pagos_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Pagos ADD CONSTRAINT
	FK_Pagos_Monedas FOREIGN KEY
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
ALTER TABLE dbo.dPagos ADD CONSTRAINT
	FK_dPagos_Pagos FOREIGN KEY
	(
	ClaveUnicaPago
	) REFERENCES dbo.Pagos
	(
	ClaveUnica
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.dPagos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

























/* MÁS CAMBIOS A LA TABLA DPAGOS */ 


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
DROP TABLE dbo.dPagosId
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuotasFactura SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.dPagos
	DROP CONSTRAINT FK_dPagos_Monedas
GO
ALTER TABLE dbo.Monedas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.dPagos
	DROP CONSTRAINT FK_dPagos_Facturas
GO
ALTER TABLE dbo.Facturas SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.dPagos
	DROP COLUMN ClaveUnicaFactura, NumeroPago, FechaPago, Proveedor, Moneda, NumeroFactura, NumeroCuota, FechaEmision, FechaRecepcion, FechaVencimiento, TotalCuota, SaldoCuota, EstadoCuota, CierreCondominio, ClaveUnicaRegistroCondominio, SeleccionarParaCondominioFlag, Cia
GO
ALTER TABLE dbo.dPagos SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.dPagos
	DROP CONSTRAINT FK_dPagos_CuotasFactura
GO
ALTER TABLE dbo.CuotasFactura SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.dPagos
	DROP CONSTRAINT FK_dPagos_Pagos
GO
ALTER TABLE dbo.Pagos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_dPagos
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	ClaveUnicaPago int NOT NULL,
	ClaveUnicaCuotaFactura int NOT NULL,
	MontoPagado money NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_dPagos SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_dPagos ON
GO
IF EXISTS(SELECT * FROM dbo.dPagos)
	 EXEC('INSERT INTO dbo.Tmp_dPagos (ClaveUnica, ClaveUnicaPago, ClaveUnicaCuotaFactura, MontoPagado)
		SELECT ClaveUnica, ClaveUnicaPago, ClaveUnicaCuotaFactura, MontoPagado FROM dbo.dPagos WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_dPagos OFF
GO
DROP TABLE dbo.dPagos
GO
EXECUTE sp_rename N'dbo.Tmp_dPagos', N'dPagos', 'OBJECT' 
GO
ALTER TABLE dbo.dPagos ADD CONSTRAINT
	PK_dPagos PRIMARY KEY NONCLUSTERED 
	(
	ClaveUnica
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.dPagos ADD CONSTRAINT
	FK_dPagos_Pagos FOREIGN KEY
	(
	ClaveUnicaPago
	) REFERENCES dbo.Pagos
	(
	ClaveUnica
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
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
COMMIT



/* AGREGAMOS LA COLUMNA MODIFICADOPOR A FACTURAS  */ 

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
	DROP CONSTRAINT FK_Facturas_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
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
	 EXEC('INSERT INTO dbo.Tmp_Facturas (ClaveUnica, Proveedor, NumeroFactura, NumeroControl, NcNdFlag, NumeroFacturaAfectada, NumeroComprobante, NumeroOperacion, ComprobanteSeniat_UsarUnoExistente_Flag, Tipo, NumeroPlanillaImportacion, CondicionesDePago, FechaEmision, FechaRecepcion, Concepto, MontoFacturaSinIva, MontoFacturaConIva, TipoAlicuota, IvaPorc, Iva, TotalFactura, CodigoConceptoRetencion, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenidoISLRAntesSustraendo, ImpuestoRetenidoISLRSustraendo, ImpuestoRetenido, FRecepcionRetencionISLR, RetencionSobreIvaPorc, RetencionSobreIva, FRecepcionRetencionIVA, TotalAPagar, Anticipo, Saldo, Estado, ClaveUnicaUltimoPago, Moneda, CxCCxPFlag, Comprobante, ImportacionFlag, Ingreso, UltAct, Usuario, Cia)
		SELECT ClaveUnica, Proveedor, NumeroFactura, NumeroControl, NcNdFlag, NumeroFacturaAfectada, NumeroComprobante, NumeroOperacion, ComprobanteSeniat_UsarUnoExistente_Flag, Tipo, NumeroPlanillaImportacion, CondicionesDePago, FechaEmision, FechaRecepcion, Concepto, MontoFacturaSinIva, MontoFacturaConIva, TipoAlicuota, IvaPorc, Iva, TotalFactura, CodigoConceptoRetencion, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenidoISLRAntesSustraendo, ImpuestoRetenidoISLRSustraendo, ImpuestoRetenido, FRecepcionRetencionISLR, RetencionSobreIvaPorc, RetencionSobreIva, FRecepcionRetencionIVA, TotalAPagar, Anticipo, Saldo, Estado, ClaveUnicaUltimoPago, Moneda, CxCCxPFlag, Comprobante, ImportacionFlag, Ingreso, UltAct, Usuario, Cia FROM dbo.Facturas WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Facturas OFF
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
	DROP COLUMN ClaveUnicaUltimoPago
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
ALTER TABLE dbo.dPagos
	DROP CONSTRAINT FK_dPagos_Pagos
GO
ALTER TABLE dbo.Pagos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.dPagos ADD CONSTRAINT
	FK_dPagos_Pagos FOREIGN KEY
	(
	ClaveUnicaPago
	) REFERENCES dbo.Pagos
	(
	ClaveUnica
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.dPagos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.310', GetDate()) 