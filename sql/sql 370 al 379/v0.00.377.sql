/*    Lunes, 10 de Agosto de 2.015	-   v0.00.377.sql 

	  Agregamos la columna Signo a los MovimientosBancarios; además, agregamos la columna 
	  ContribuyenteFlag a la tabla Proveedores 
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
ALTER TABLE dbo.Proveedores
	DROP CONSTRAINT FK_Proveedores_Monedas
GO
ALTER TABLE dbo.Monedas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Proveedores
	DROP CONSTRAINT FK_Proveedores_CategoriasRetencion
GO
ALTER TABLE dbo.CategoriasRetencion SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Proveedores
	DROP CONSTRAINT FK_Proveedores_FormasDePago
GO
ALTER TABLE dbo.FormasDePago SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
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
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Chequeras
GO
ALTER TABLE dbo.Chequeras SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_MovimientosDesdeBancos
GO
ALTER TABLE dbo.MovimientosDesdeBancos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Proveedores
	(
	Proveedor int NOT NULL IDENTITY (1, 1),
	Nombre nvarchar(70) NOT NULL,
	Abreviatura nvarchar(10) NOT NULL,
	Tipo int NOT NULL,
	Rif nvarchar(20) NULL,
	NatJurFlag smallint NOT NULL,
	Nit nvarchar(20) NULL,
	ContribuyenteFlag bit NULL,
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
	BaseRetencionISLR smallint NULL,
	MonedaDefault int NULL,
	FormaDePagoDefault int NULL,
	ProveedorClienteFlag smallint NULL,
	PorcentajeDeRetencion real NULL,
	AplicaIvaFlag bit NULL,
	CategoriaProveedor int NULL,
	MontoChequeEnMonExtFlag bit NULL,
	Lote nvarchar(50) NULL,
	Ingreso datetime2(7) NOT NULL,
	UltAct datetime2(7) NOT NULL,
	Usuario nvarchar(25) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Proveedores SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Proveedores ON
GO
IF EXISTS(SELECT * FROM dbo.Proveedores)
	 EXEC('INSERT INTO dbo.Tmp_Proveedores (Proveedor, Nombre, Abreviatura, Tipo, Rif, NatJurFlag, Nit, ContribuyenteEspecialFlag, RetencionSobreIvaPorc, NuestraRetencionSobreIvaPorc, AfectaLibroComprasFlag, Beneficiario, Concepto, MontoCheque, Direccion, Ciudad, Telefono1, Telefono2, Fax, Contacto1, Contacto2, NacionalExtranjeroFlag, SujetoARetencionFlag, CodigoConceptoRetencion, RetencionISLRSustraendo, BaseRetencionISLR, MonedaDefault, FormaDePagoDefault, ProveedorClienteFlag, PorcentajeDeRetencion, AplicaIvaFlag, CategoriaProveedor, MontoChequeEnMonExtFlag, Lote, Ingreso, UltAct, Usuario)
		SELECT Proveedor, Nombre, Abreviatura, Tipo, Rif, NatJurFlag, Nit, ContribuyenteEspecialFlag, RetencionSobreIvaPorc, NuestraRetencionSobreIvaPorc, AfectaLibroComprasFlag, Beneficiario, Concepto, MontoCheque, Direccion, Ciudad, Telefono1, Telefono2, Fax, Contacto1, Contacto2, NacionalExtranjeroFlag, SujetoARetencionFlag, CodigoConceptoRetencion, RetencionISLRSustraendo, BaseRetencionISLR, MonedaDefault, FormaDePagoDefault, ProveedorClienteFlag, PorcentajeDeRetencion, AplicaIvaFlag, CategoriaProveedor, MontoChequeEnMonExtFlag, Lote, Ingreso, UltAct, Usuario FROM dbo.Proveedores WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Proveedores OFF
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos
	DROP CONSTRAINT FK_CajaChica_Reposiciones_Gastos_Proveedores
GO
ALTER TABLE dbo.OrdenesPago
	DROP CONSTRAINT FK_OrdenesPago_Proveedores
GO
ALTER TABLE dbo.SaldosCompanias
	DROP CONSTRAINT FK_SaldosCompanias_Proveedores
GO
ALTER TABLE dbo.InventarioActivosFijos
	DROP CONSTRAINT FK_InventarioActivosFijos_Proveedores
GO
ALTER TABLE dbo.Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad
	DROP CONSTRAINT FK_Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad_Proveedores
GO
ALTER TABLE dbo.Pagos
	DROP CONSTRAINT FK_Pagos_Proveedores
GO
ALTER TABLE dbo.DefinicionCuentasContables
	DROP CONSTRAINT FK_DefinicionCuentasContables_Proveedores
GO
ALTER TABLE dbo.Facturas
	DROP CONSTRAINT FK_Facturas_Proveedores
GO
ALTER TABLE dbo.Personas
	DROP CONSTRAINT FK_Personas_Proveedores
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Proveedores
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
ALTER TABLE dbo.Proveedores ADD CONSTRAINT
	FK_Proveedores_FormasDePago FOREIGN KEY
	(
	FormaDePagoDefault
	) REFERENCES dbo.FormasDePago
	(
	FormaDePago
	) ON UPDATE  CASCADE 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Proveedores ADD CONSTRAINT
	FK_Proveedores_CategoriasRetencion FOREIGN KEY
	(
	CategoriaProveedor
	) REFERENCES dbo.CategoriasRetencion
	(
	Categoria
	) ON UPDATE  CASCADE 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Proveedores ADD CONSTRAINT
	FK_Proveedores_Monedas FOREIGN KEY
	(
	MonedaDefault
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  CASCADE 
	 ON DELETE  NO ACTION 
	
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
ALTER TABLE dbo.Facturas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
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
ALTER TABLE dbo.DefinicionCuentasContables SET (LOCK_ESCALATION = TABLE)
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
BEGIN TRANSACTION
GO
ALTER TABLE dbo.InventarioActivosFijos ADD CONSTRAINT
	FK_InventarioActivosFijos_Proveedores FOREIGN KEY
	(
	Proveedor
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	) ON UPDATE  CASCADE 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.InventarioActivosFijos SET (LOCK_ESCALATION = TABLE)
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
CREATE TABLE dbo.Tmp_MovimientosBancarios
	(
	Transaccion bigint NOT NULL,
	Tipo nvarchar(2) NOT NULL,
	Fecha date NOT NULL,
	ProvClte int NULL,
	Beneficiario nvarchar(50) NOT NULL,
	Concepto nvarchar(250) NOT NULL,
	Signo bit NULL,
	MontoBase money NULL,
	Comision money NULL,
	Impuestos money NULL,
	Monto money NOT NULL,
	Ingreso datetime NOT NULL,
	UltMod datetime NOT NULL,
	Usuario nvarchar(25) NOT NULL,
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	ClaveUnicaChequera int NOT NULL,
	FechaEntregado date NULL,
	Conciliacion_FechaEjecucion smalldatetime NULL,
	Conciliacion_MovimientoBanco_Fecha smalldatetime NULL,
	Conciliacion_MovimientoBanco_Numero bigint NULL,
	Conciliacion_MovimientoBanco_Tipo nvarchar(4) NULL,
	Conciliacion_MovimientoBanco_FechaProceso smalldatetime NULL,
	Conciliacion_MovimientoBanco_Monto money NULL,
	PagoID int NULL,
	ConciliacionMovimientoID int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_MovimientosBancarios SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_MovimientosBancarios ON
GO
IF EXISTS(SELECT * FROM dbo.MovimientosBancarios)
	 EXEC('INSERT INTO dbo.Tmp_MovimientosBancarios (Transaccion, Tipo, Fecha, ProvClte, Beneficiario, Concepto, MontoBase, Comision, Impuestos, Monto, Ingreso, UltMod, Usuario, ClaveUnica, ClaveUnicaChequera, FechaEntregado, Conciliacion_FechaEjecucion, Conciliacion_MovimientoBanco_Fecha, Conciliacion_MovimientoBanco_Numero, Conciliacion_MovimientoBanco_Tipo, Conciliacion_MovimientoBanco_FechaProceso, Conciliacion_MovimientoBanco_Monto, PagoID, ConciliacionMovimientoID)
		SELECT Transaccion, Tipo, Fecha, ProvClte, Beneficiario, Concepto, MontoBase, Comision, Impuestos, Monto, Ingreso, UltMod, Usuario, ClaveUnica, ClaveUnicaChequera, FechaEntregado, Conciliacion_FechaEjecucion, Conciliacion_MovimientoBanco_Fecha, Conciliacion_MovimientoBanco_Numero, Conciliacion_MovimientoBanco_Tipo, Conciliacion_MovimientoBanco_FechaProceso, Conciliacion_MovimientoBanco_Monto, PagoID, ConciliacionMovimientoID FROM dbo.MovimientosBancarios WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_MovimientosBancarios OFF
GO
ALTER TABLE dbo.MovimientosBancariosPagosTarjetas
	DROP CONSTRAINT FK_MovimientosBancariosPagosTarjetas_MovimientosBancarios
GO
DROP TABLE dbo.MovimientosBancarios
GO
EXECUTE sp_rename N'dbo.Tmp_MovimientosBancarios', N'MovimientosBancarios', 'OBJECT' 
GO
ALTER TABLE dbo.MovimientosBancarios ADD CONSTRAINT
	PK_MovimientosBancarios PRIMARY KEY CLUSTERED 
	(
	ClaveUnica
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.MovimientosBancarios ADD CONSTRAINT
	FK_MovimientosBancarios_MovimientosDesdeBancos FOREIGN KEY
	(
	ConciliacionMovimientoID
	) REFERENCES dbo.MovimientosDesdeBancos
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.MovimientosBancarios ADD CONSTRAINT
	FK_MovimientosBancarios_Chequeras FOREIGN KEY
	(
	ClaveUnicaChequera
	) REFERENCES dbo.Chequeras
	(
	NumeroChequera
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
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
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.MovimientosBancariosPagosTarjetas ADD CONSTRAINT
	FK_MovimientosBancariosPagosTarjetas_MovimientosBancarios FOREIGN KEY
	(
	MovimientoBancarioID
	) REFERENCES dbo.MovimientosBancarios
	(
	ClaveUnica
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.MovimientosBancariosPagosTarjetas SET (LOCK_ESCALATION = TABLE)
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
CREATE TABLE dbo.Tmp_tTempWebReport_ConsultaFacturas
	(
	Moneda int NOT NULL,
	CiaContab int NOT NULL,
	Compania int NOT NULL,
	MonedaSimbolo nvarchar(6) NOT NULL,
	MonedaDescripcion nvarchar(50) NOT NULL,
	CiaContabNombre nvarchar(50) NOT NULL,
	CiaContabDireccion nvarchar(200) NULL,
	CiaContabRif nvarchar(15) NOT NULL,
	CiaContabTelefono1 nvarchar(15) NULL,
	CiaContabTelefono2 nvarchar(15) NULL,
	CiaContabFax nvarchar(15) NULL,
	CiaContabCiudad nvarchar(25) NULL,
	NombreCompania nvarchar(70) NOT NULL,
	AbreviaturaCompania nvarchar(10) NOT NULL,
	RifCompania nvarchar(20) NULL,
	NitCompania nvarchar(20) NULL,
	CompaniaDomicilio nvarchar(400) NULL,
	CompaniaTelefono nvarchar(15) NULL,
	CompaniaFax nvarchar(15) NULL,
	CompaniaCiudad nvarchar(50) NULL,
	CodigoConceptoRetencion nvarchar(6) NULL,
	ContribuyenteFlag bit NULL,
	NumeroFactura nvarchar(25) NOT NULL,
	NumeroControl nvarchar(20) NULL,
	ImportacionFlag bit NULL,
	Importacion_CompraNacional nvarchar(50) NULL,
	NumeroPlanillaImportacion nvarchar(25) NULL,
	ClaveUnicaFactura int NOT NULL,
	NcNdFlag nvarchar(2) NULL,
	Compra_NotaCredito nvarchar(50) NULL,
	NumeroFacturaAfectada nvarchar(20) NULL,
	NumeroComprobante char(14) NULL,
	NumeroOperacion smallint NULL,
	Tipo int NOT NULL,
	NombreTipo nvarchar(50) NOT NULL,
	CondicionesDePago int NOT NULL,
	CondicionesDePagoNombre nvarchar(30) NULL,
	FechaEmision datetime NOT NULL,
	FechaRecepcion datetime NOT NULL,
	Concepto ntext NULL,
	NotasFactura1 nvarchar(100) NULL,
	NotasFactura2 nvarchar(100) NULL,
	NotasFactura3 nvarchar(100) NULL,
	MontoFacturaSinIva money NULL,
	MontoFacturaConIva money NULL,
	MontoTotalFactura money NOT NULL,
	BaseImponible_Reducido money NULL,
	BaseImponible_General money NULL,
	BaseImponible_Adicional money NULL,
	TipoAlicuota char(1) NULL,
	IvaPorc decimal(6, 3) NULL,
	IvaPorc_Reducido decimal(6, 3) NULL,
	IvaPorc_General decimal(6, 3) NULL,
	IvaPorc_Adicional decimal(6, 3) NULL,
	Iva money NULL,
	Iva_Reducido money NULL,
	Iva_General money NULL,
	Iva_Adicional money NULL,
	TotalFactura money NOT NULL,
	MontoSujetoARetencion money NULL,
	ImpuestoRetenidoPorc decimal(6, 3) NULL,
	ImpuestoRetenidoISLRAntesSustraendo money NULL,
	ImpuestoRetenidoISLRSustraendo money NULL,
	ImpuestoRetenido money NULL,
	ImpuestoRetenido_Reducido money NULL,
	ImpuestoRetenido_General money NULL,
	ImpuestoRetenido_Adicional money NULL,
	FRecepcionRetencionISLR datetime NULL,
	RetencionSobreIvaPorc decimal(6, 3) NULL,
	RetencionSobreIva money NULL,
	FRecepcionRetencionIVA datetime NULL,
	ImpuestosVarios money NULL,
	RetencionesVarias money NULL,
	TotalAPagar money NOT NULL,
	Anticipo money NULL,
	Saldo money NOT NULL,
	Estado smallint NOT NULL,
	NombreEstado nchar(10) NULL,
	CxCCxPFlag smallint NOT NULL,
	NombreCxCCxPFlag char(4) NOT NULL,
	Comprobante int NULL,
	FechaPago datetime NULL,
	MontoPagado money NULL,
	NombreUsuario nvarchar(256) NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tTempWebReport_ConsultaFacturas SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.tTempWebReport_ConsultaFacturas)
	 EXEC('INSERT INTO dbo.Tmp_tTempWebReport_ConsultaFacturas (Moneda, CiaContab, Compania, MonedaSimbolo, MonedaDescripcion, CiaContabNombre, CiaContabDireccion, CiaContabRif, CiaContabTelefono1, CiaContabTelefono2, CiaContabFax, CiaContabCiudad, NombreCompania, AbreviaturaCompania, RifCompania, NitCompania, CompaniaDomicilio, CompaniaTelefono, CompaniaFax, CompaniaCiudad, CodigoConceptoRetencion, NumeroFactura, NumeroControl, ImportacionFlag, Importacion_CompraNacional, NumeroPlanillaImportacion, ClaveUnicaFactura, NcNdFlag, Compra_NotaCredito, NumeroFacturaAfectada, NumeroComprobante, NumeroOperacion, Tipo, NombreTipo, CondicionesDePago, CondicionesDePagoNombre, FechaEmision, FechaRecepcion, Concepto, NotasFactura1, NotasFactura2, NotasFactura3, MontoFacturaSinIva, MontoFacturaConIva, MontoTotalFactura, BaseImponible_Reducido, BaseImponible_General, BaseImponible_Adicional, TipoAlicuota, IvaPorc, IvaPorc_Reducido, IvaPorc_General, IvaPorc_Adicional, Iva, Iva_Reducido, Iva_General, Iva_Adicional, TotalFactura, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenidoISLRAntesSustraendo, ImpuestoRetenidoISLRSustraendo, ImpuestoRetenido, ImpuestoRetenido_Reducido, ImpuestoRetenido_General, ImpuestoRetenido_Adicional, FRecepcionRetencionISLR, RetencionSobreIvaPorc, RetencionSobreIva, FRecepcionRetencionIVA, ImpuestosVarios, RetencionesVarias, TotalAPagar, Anticipo, Saldo, Estado, NombreEstado, CxCCxPFlag, NombreCxCCxPFlag, Comprobante, FechaPago, MontoPagado, NombreUsuario)
		SELECT Moneda, CiaContab, Compania, MonedaSimbolo, MonedaDescripcion, CiaContabNombre, CiaContabDireccion, CiaContabRif, CiaContabTelefono1, CiaContabTelefono2, CiaContabFax, CiaContabCiudad, NombreCompania, AbreviaturaCompania, RifCompania, NitCompania, CompaniaDomicilio, CompaniaTelefono, CompaniaFax, CompaniaCiudad, CodigoConceptoRetencion, NumeroFactura, NumeroControl, ImportacionFlag, Importacion_CompraNacional, NumeroPlanillaImportacion, ClaveUnicaFactura, NcNdFlag, Compra_NotaCredito, NumeroFacturaAfectada, NumeroComprobante, NumeroOperacion, Tipo, NombreTipo, CondicionesDePago, CondicionesDePagoNombre, FechaEmision, FechaRecepcion, Concepto, NotasFactura1, NotasFactura2, NotasFactura3, MontoFacturaSinIva, MontoFacturaConIva, MontoTotalFactura, BaseImponible_Reducido, BaseImponible_General, BaseImponible_Adicional, TipoAlicuota, IvaPorc, IvaPorc_Reducido, IvaPorc_General, IvaPorc_Adicional, Iva, Iva_Reducido, Iva_General, Iva_Adicional, TotalFactura, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenidoISLRAntesSustraendo, ImpuestoRetenidoISLRSustraendo, ImpuestoRetenido, ImpuestoRetenido_Reducido, ImpuestoRetenido_General, ImpuestoRetenido_Adicional, FRecepcionRetencionISLR, RetencionSobreIvaPorc, RetencionSobreIva, FRecepcionRetencionIVA, ImpuestosVarios, RetencionesVarias, TotalAPagar, Anticipo, Saldo, Estado, NombreEstado, CxCCxPFlag, NombreCxCCxPFlag, Comprobante, FechaPago, MontoPagado, NombreUsuario FROM dbo.tTempWebReport_ConsultaFacturas WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.tTempWebReport_ConsultaFacturas
GO
EXECUTE sp_rename N'dbo.Tmp_tTempWebReport_ConsultaFacturas', N'tTempWebReport_ConsultaFacturas', 'OBJECT' 
GO
ALTER TABLE dbo.tTempWebReport_ConsultaFacturas ADD CONSTRAINT
	PK_tTempWebReport_ConsultaFacturas PRIMARY KEY CLUSTERED 
	(
	Moneda,
	CiaContab,
	Compania,
	NumeroFactura,
	NombreUsuario
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT

	
--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.377', GetDate()) 
