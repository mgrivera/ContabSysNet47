/*    Domingo, 16 de Febrero de 2.014 	-   v0.00.368c.sql 

	Cambios para implementar mejoras en retenciones de impuesto ... 
	Proveedores: agregamos columna para base de calculo de retención de islr 
	(no imp, imp, ambos, manual) 
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
CREATE TABLE dbo.Tmp_Proveedores
	(
	Proveedor int NOT NULL IDENTITY (1, 1),
	Nombre nvarchar(70) NOT NULL,
	Abreviatura nvarchar(10) NOT NULL,
	Tipo int NOT NULL,
	Rif nvarchar(20) NULL,
	NatJurFlag smallint NOT NULL,
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
	BaseRetencionISLR smallint NULL,
	MonedaDefault int NULL,
	FormaDePagoDefault int NULL,
	ProveedorClienteFlag smallint NULL,
	PorcentajeDeRetencion real NULL,
	AplicaIvaFlag bit NULL,
	CategoriaProveedor int NULL,
	MontoChequeEnMonExtFlag bit NULL,
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
	 EXEC('INSERT INTO dbo.Tmp_Proveedores (Proveedor, Nombre, Abreviatura, Tipo, Rif, NatJurFlag, Nit, ContribuyenteEspecialFlag, RetencionSobreIvaPorc, NuestraRetencionSobreIvaPorc, AfectaLibroComprasFlag, Beneficiario, Concepto, MontoCheque, Direccion, Ciudad, Telefono1, Telefono2, Fax, Contacto1, Contacto2, NacionalExtranjeroFlag, SujetoARetencionFlag, CodigoConceptoRetencion, RetencionISLRSustraendo, MonedaDefault, FormaDePagoDefault, ProveedorClienteFlag, PorcentajeDeRetencion, AplicaIvaFlag, CategoriaProveedor, MontoChequeEnMonExtFlag, Ingreso, UltAct, Usuario)
		SELECT Proveedor, Nombre, Abreviatura, Tipo, Rif, NatJurFlag, Nit, ContribuyenteEspecialFlag, RetencionSobreIvaPorc, NuestraRetencionSobreIvaPorc, AfectaLibroComprasFlag, Beneficiario, Concepto, MontoCheque, Direccion, Ciudad, Telefono1, Telefono2, Fax, Contacto1, Contacto2, NacionalExtranjeroFlag, SujetoARetencionFlag, CodigoConceptoRetencion, RetencionISLRSustraendo, MonedaDefault, FormaDePagoDefault, ProveedorClienteFlag, PorcentajeDeRetencion, AplicaIvaFlag, CategoriaProveedor, MontoChequeEnMonExtFlag, Ingreso, UltAct, Usuario FROM dbo.Proveedores WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Proveedores OFF
GO
ALTER TABLE dbo.Facturas
	DROP CONSTRAINT FK_Facturas_Proveedores
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Proveedores
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
ALTER TABLE dbo.Personas
	DROP CONSTRAINT FK_Personas_Proveedores
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
CREATE TABLE dbo.Tmp_ImpuestosRetencionesDefinicion
	(
	ID int NOT NULL IDENTITY (1, 1),
	Predefinido smallint NULL,
	ImpuestoRetencion smallint NOT NULL,
	Descripcion nvarchar(50) NOT NULL,
	Base smallint NULL,
	Porcentaje decimal(6, 3) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_ImpuestosRetencionesDefinicion SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_ImpuestosRetencionesDefinicion ON
GO
IF EXISTS(SELECT * FROM dbo.ImpuestosRetencionesDefinicion)
	 EXEC('INSERT INTO dbo.Tmp_ImpuestosRetencionesDefinicion (ID, Predefinido, ImpuestoRetencion, Descripcion, Base, Porcentaje)
		SELECT ID, Predefinido, ImpuestoRetencion, Descripcion, Base, Porcentaje FROM dbo.ImpuestosRetencionesDefinicion WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_ImpuestosRetencionesDefinicion OFF
GO
ALTER TABLE dbo.Facturas_Impuestos
	DROP CONSTRAINT FK_Facturas_Impuestos_ImpuestosRetencionesDefinicion
GO
DROP TABLE dbo.ImpuestosRetencionesDefinicion
GO
EXECUTE sp_rename N'dbo.Tmp_ImpuestosRetencionesDefinicion', N'ImpuestosRetencionesDefinicion', 'OBJECT' 
GO
ALTER TABLE dbo.ImpuestosRetencionesDefinicion ADD CONSTRAINT
	PK_ImpuestosRetencionesDefinicion PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
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
ALTER TABLE dbo.Facturas_Impuestos SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.Facturas_Impuestos
	DROP CONSTRAINT FK_Facturas_Impuestos_Facturas
GO
ALTER TABLE dbo.Facturas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Facturas_Impuestos ADD CONSTRAINT
	FK_Facturas_Impuestos_Facturas FOREIGN KEY
	(
	FacturaID
	) REFERENCES dbo.Facturas
	(
	ClaveUnica
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Facturas_Impuestos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.368c', GetDate()) 
