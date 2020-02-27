/*    Sábado, 20 de Agosto de 2.011  -   v0.00.279.sql 

	Agregamos algunas relaciones a las tablas 
	Proveedores y Personas 
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
ALTER TABLE dbo.Personas
	DROP CONSTRAINT FK_Personas_Atributos
GO
ALTER TABLE dbo.Atributos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Personas
	DROP CONSTRAINT FK_Personas_Titulos
GO
ALTER TABLE dbo.Titulos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Personas
	DROP CONSTRAINT FK_Personas_tCargos
GO
ALTER TABLE dbo.tCargos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CategoriasRetencion SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.FormasDePago SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Monedas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Proveedores
	(
	Proveedor int NOT NULL IDENTITY (1, 1),
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
	CategoriaProveedor int NULL,
	MontoChequeEnMonExtFlag bit NULL,
	Ingreso datetime NOT NULL,
	UltAct datetime NOT NULL,
	Usuario nvarchar(25) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Proveedores SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Proveedores ON
GO
IF EXISTS(SELECT * FROM dbo.Proveedores)
	 EXEC('INSERT INTO dbo.Tmp_Proveedores (Proveedor, Nombre, Tipo, Rif, NatJurFlag, Nit, ContribuyenteEspecialFlag, RetencionSobreIvaPorc, NuestraRetencionSobreIvaPorc, AfectaLibroComprasFlag, Beneficiario, Concepto, MontoCheque, Direccion, Ciudad, Telefono1, Telefono2, Fax, Contacto1, Contacto2, NacionalExtranjeroFlag, SujetoARetencionFlag, CodigoConceptoRetencion, RetencionISLRSustraendo, MonedaDefault, FormaDePagoDefault, ProveedorClienteFlag, PorcentajeDeRetencion, AplicaIvaFlag, CategoriaProveedor, MontoChequeEnMonExtFlag, Ingreso, UltAct, Usuario)
		SELECT Proveedor, Nombre, Tipo, Rif, NatJurFlag, Nit, ContribuyenteEspecialFlag, RetencionSobreIvaPorc, NuestraRetencionSobreIvaPorc, AfectaLibroComprasFlag, Beneficiario, Concepto, MontoCheque, Direccion, Ciudad, Telefono1, Telefono2, Fax, Contacto1, Contacto2, NacionalExtranjeroFlag, SujetoARetencionFlag, CodigoConceptoRetencion, RetencionISLRSustraendo, MonedaDefault, FormaDePagoDefault, ProveedorClienteFlag, PorcentajeDeRetencion, AplicaIvaFlag, CONVERT(int, CategoriaProveedor), MontoChequeEnMonExtFlag, Ingreso, UltAct, Usuario FROM dbo.Proveedores WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Proveedores OFF
GO
ALTER TABLE dbo.Facturas
	DROP CONSTRAINT FK_Facturas_Proveedores
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
ALTER TABLE dbo.Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad
	DROP CONSTRAINT FK_Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad_Proveedores
GO
ALTER TABLE dbo.Personas
	DROP CONSTRAINT FK_Personas_Proveedores
GO
ALTER TABLE dbo.CuotasFactura
	DROP CONSTRAINT FK_CuotasFactura_Proveedores
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
	FK_Proveedores_Monedas FOREIGN KEY
	(
	MonedaDefault
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  CASCADE 
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
COMMIT
BEGIN TRANSACTION
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
ALTER TABLE dbo.tDepartamentos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Personas
	(
	Persona int NOT NULL IDENTITY (1, 1),
	Compania int NOT NULL,
	Nombre nvarchar(50) NOT NULL,
	Apellido nvarchar(50) NOT NULL,
	Cargo int NOT NULL,
	Titulo nvarchar(10) NOT NULL,
	DiaCumpleAnos tinyint NULL,
	MesCumpleAnos smallint NULL,
	Telefono nvarchar(25) NULL,
	Departamento int NULL,
	Fax nvarchar(25) NULL,
	Celular nvarchar(25) NULL,
	email nvarchar(50) NULL,
	Atributo int NULL,
	Notas nvarchar(250) NULL,
	Ingreso smalldatetime NOT NULL,
	UltAct smalldatetime NOT NULL,
	Usuario nvarchar(25) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Personas SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Personas ON
GO
IF EXISTS(SELECT * FROM dbo.Personas)
	 EXEC('INSERT INTO dbo.Tmp_Personas (Persona, Compania, Nombre, Apellido, Cargo, Titulo, DiaCumpleAnos, MesCumpleAnos, Telefono, Fax, Celular, email, Atributo, Notas, Ingreso, UltAct, Usuario)
		SELECT Persona, Compania, Nombre, Apellido, Cargo, Titulo, DiaCumpleAnos, MesCumpleAnos, Telefono, Fax, Celular, email, Atributo, Notas, Ingreso, UltAct, Usuario FROM dbo.Personas WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Personas OFF
GO
DROP TABLE dbo.Personas
GO
EXECUTE sp_rename N'dbo.Tmp_Personas', N'Personas', 'OBJECT' 
GO
ALTER TABLE dbo.Personas ADD CONSTRAINT
	PK_Personas PRIMARY KEY CLUSTERED 
	(
	Persona
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_Personas ON dbo.Personas
	(
	Compania
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
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
ALTER TABLE dbo.Personas WITH NOCHECK ADD CONSTRAINT
	FK_Personas_tCargos FOREIGN KEY
	(
	Cargo
	) REFERENCES dbo.tCargos
	(
	Cargo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Personas WITH NOCHECK ADD CONSTRAINT
	FK_Personas_Titulos FOREIGN KEY
	(
	Titulo
	) REFERENCES dbo.Titulos
	(
	Titulo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Personas WITH NOCHECK ADD CONSTRAINT
	FK_Personas_Atributos FOREIGN KEY
	(
	Atributo
	) REFERENCES dbo.Atributos
	(
	Atributo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Personas ADD CONSTRAINT
	FK_Personas_tDepartamentos FOREIGN KEY
	(
	Departamento
	) REFERENCES dbo.tDepartamentos
	(
	Departamento
	) ON UPDATE  CASCADE 
	 ON DELETE  NO ACTION 
	
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
ALTER TABLE dbo.Personas
	DROP CONSTRAINT FK_Personas_tDepartamentos
GO
ALTER TABLE dbo.tDepartamentos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Personas
	DROP CONSTRAINT FK_Personas_Atributos
GO
ALTER TABLE dbo.Atributos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Personas
	DROP CONSTRAINT FK_Personas_Titulos
GO
ALTER TABLE dbo.Titulos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Personas
	DROP CONSTRAINT FK_Personas_tCargos
GO
ALTER TABLE dbo.tCargos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Personas
	DROP CONSTRAINT FK_Personas_Proveedores
GO
ALTER TABLE dbo.Proveedores SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Personas
	(
	Persona int NOT NULL IDENTITY (1, 1),
	Compania int NOT NULL,
	Nombre nvarchar(50) NOT NULL,
	Apellido nvarchar(50) NOT NULL,
	Cargo int NOT NULL,
	Titulo nvarchar(10) NOT NULL,
	DiaCumpleAnos tinyint NULL,
	MesCumpleAnos smallint NULL,
	Telefono nvarchar(25) NULL,
	Departamento int NULL,
	Fax nvarchar(25) NULL,
	Celular nvarchar(25) NULL,
	email nvarchar(50) NULL,
	Atributo int NULL,
	Notas nvarchar(250) NULL,
	DefaultFlag bit NULL,
	Ingreso smalldatetime NOT NULL,
	UltAct smalldatetime NOT NULL,
	Usuario nvarchar(25) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Personas SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Personas ON
GO
IF EXISTS(SELECT * FROM dbo.Personas)
	 EXEC('INSERT INTO dbo.Tmp_Personas (Persona, Compania, Nombre, Apellido, Cargo, Titulo, DiaCumpleAnos, MesCumpleAnos, Telefono, Departamento, Fax, Celular, email, Atributo, Notas, Ingreso, UltAct, Usuario)
		SELECT Persona, Compania, Nombre, Apellido, Cargo, Titulo, DiaCumpleAnos, MesCumpleAnos, Telefono, Departamento, Fax, Celular, email, Atributo, Notas, Ingreso, UltAct, Usuario FROM dbo.Personas WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Personas OFF
GO
DROP TABLE dbo.Personas
GO
EXECUTE sp_rename N'dbo.Tmp_Personas', N'Personas', 'OBJECT' 
GO
ALTER TABLE dbo.Personas ADD CONSTRAINT
	PK_Personas PRIMARY KEY CLUSTERED 
	(
	Persona
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_Personas ON dbo.Personas
	(
	Compania
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
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
ALTER TABLE dbo.Personas WITH NOCHECK ADD CONSTRAINT
	FK_Personas_tCargos FOREIGN KEY
	(
	Cargo
	) REFERENCES dbo.tCargos
	(
	Cargo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Personas WITH NOCHECK ADD CONSTRAINT
	FK_Personas_Titulos FOREIGN KEY
	(
	Titulo
	) REFERENCES dbo.Titulos
	(
	Titulo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Personas WITH NOCHECK ADD CONSTRAINT
	FK_Personas_Atributos FOREIGN KEY
	(
	Atributo
	) REFERENCES dbo.Atributos
	(
	Atributo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Personas ADD CONSTRAINT
	FK_Personas_tDepartamentos FOREIGN KEY
	(
	Departamento
	) REFERENCES dbo.tDepartamentos
	(
	Departamento
	) ON UPDATE  CASCADE 
	 ON DELETE  NO ACTION 
	
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
CREATE TABLE dbo.Tmp_Monedas
	(
	Moneda int NOT NULL IDENTITY (1, 1),
	Descripcion nvarchar(50) NOT NULL,
	Simbolo nvarchar(6) NOT NULL,
	NacionalFlag bit NOT NULL,
	DefaultFlag bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Monedas SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Monedas ON
GO
IF EXISTS(SELECT * FROM dbo.Monedas)
	 EXEC('INSERT INTO dbo.Tmp_Monedas (Moneda, Descripcion, Simbolo, NacionalFlag, DefaultFlag)
		SELECT Moneda, Descripcion, Simbolo, NacionalFlag, DefaultFlag FROM dbo.Monedas WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Monedas OFF
GO
ALTER TABLE dbo.CambiosMonedas
	DROP CONSTRAINT FK_CambiosMonedas_Monedas
GO
ALTER TABLE dbo.dPagos
	DROP CONSTRAINT FK_dPagos_Monedas
GO
ALTER TABLE dbo.Presupuesto_Montos
	DROP CONSTRAINT FK_Presupuesto_Montos_Monedas
GO
ALTER TABLE dbo.Asientos
	DROP CONSTRAINT FK_Asientos_Monedas
GO
ALTER TABLE dbo.Asientos
	DROP CONSTRAINT FK_Asientos_Monedas1
GO
ALTER TABLE dbo.Disponibilidad_MontosRestringidos
	DROP CONSTRAINT FK_Disponibilidad_MontosRestringidos_Monedas
GO
ALTER TABLE dbo.CuentasBancarias
	DROP CONSTRAINT FK_CuentasBancarias_Monedas
GO
ALTER TABLE dbo.NivelesAgrupacionContableMontosEstimados
	DROP CONSTRAINT FK_NivelesAgrupacionContableMontosEstimados_Monedas
GO
ALTER TABLE dbo.CuotasFactura
	DROP CONSTRAINT FK_CuotasFactura_Monedas
GO
ALTER TABLE dbo.Facturas
	DROP CONSTRAINT FK_Facturas_Monedas
GO
ALTER TABLE dbo.Pagos
	DROP CONSTRAINT FK_Pagos_Monedas
GO
ALTER TABLE dbo.OrdenesPago
	DROP CONSTRAINT FK_OrdenesPago_Monedas
GO
ALTER TABLE dbo.Proveedores
	DROP CONSTRAINT FK_Proveedores_Monedas
GO
DROP TABLE dbo.Monedas
GO
EXECUTE sp_rename N'dbo.Tmp_Monedas', N'Monedas', 'OBJECT' 
GO
ALTER TABLE dbo.Monedas ADD CONSTRAINT
	PK_Monedas PRIMARY KEY NONCLUSTERED 
	(
	Moneda
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
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
ALTER TABLE dbo.Proveedores SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.OrdenesPago ADD CONSTRAINT
	FK_OrdenesPago_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.OrdenesPago SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
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
ALTER TABLE dbo.Pagos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
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
ALTER TABLE dbo.Facturas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuotasFactura WITH NOCHECK ADD CONSTRAINT
	FK_CuotasFactura_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CuotasFactura SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.NivelesAgrupacionContableMontosEstimados ADD CONSTRAINT
	FK_NivelesAgrupacionContableMontosEstimados_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.NivelesAgrupacionContableMontosEstimados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasBancarias WITH NOCHECK ADD CONSTRAINT
	FK_CuentasBancarias_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CuentasBancarias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Disponibilidad_MontosRestringidos ADD CONSTRAINT
	FK_Disponibilidad_MontosRestringidos_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Disponibilidad_MontosRestringidos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Asientos ADD CONSTRAINT
	FK_Asientos_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Asientos ADD CONSTRAINT
	FK_Asientos_Monedas1 FOREIGN KEY
	(
	MonedaOriginal
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Asientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Presupuesto_Montos WITH NOCHECK ADD CONSTRAINT
	FK_Presupuesto_Montos_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Presupuesto_Montos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.dPagos ADD CONSTRAINT
	FK_dPagos_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.dPagos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CambiosMonedas ADD CONSTRAINT
	FK_CambiosMonedas_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.CambiosMonedas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

--  ------------------------------------
--  cambiamos NatJurFlag a smallint 
--  ------------------------------------


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
	Nombre nvarchar(50) NOT NULL,
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
	MonedaDefault int NULL,
	FormaDePagoDefault int NULL,
	ProveedorClienteFlag smallint NULL,
	PorcentajeDeRetencion real NULL,
	AplicaIvaFlag bit NULL,
	CategoriaProveedor int NULL,
	MontoChequeEnMonExtFlag bit NULL,
	Ingreso datetime NOT NULL,
	UltAct datetime NOT NULL,
	Usuario nvarchar(25) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Proveedores SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Proveedores ON
GO
IF EXISTS(SELECT * FROM dbo.Proveedores)
	 EXEC('INSERT INTO dbo.Tmp_Proveedores (Proveedor, Nombre, Tipo, Rif, NatJurFlag, Nit, ContribuyenteEspecialFlag, RetencionSobreIvaPorc, NuestraRetencionSobreIvaPorc, AfectaLibroComprasFlag, Beneficiario, Concepto, MontoCheque, Direccion, Ciudad, Telefono1, Telefono2, Fax, Contacto1, Contacto2, NacionalExtranjeroFlag, SujetoARetencionFlag, CodigoConceptoRetencion, RetencionISLRSustraendo, MonedaDefault, FormaDePagoDefault, ProveedorClienteFlag, PorcentajeDeRetencion, AplicaIvaFlag, CategoriaProveedor, MontoChequeEnMonExtFlag, Ingreso, UltAct, Usuario)
		SELECT Proveedor, Nombre, Tipo, Rif, CONVERT(smallint, NatJurFlag), Nit, ContribuyenteEspecialFlag, RetencionSobreIvaPorc, NuestraRetencionSobreIvaPorc, AfectaLibroComprasFlag, Beneficiario, Concepto, MontoCheque, Direccion, Ciudad, Telefono1, Telefono2, Fax, Contacto1, Contacto2, NacionalExtranjeroFlag, SujetoARetencionFlag, CodigoConceptoRetencion, RetencionISLRSustraendo, MonedaDefault, FormaDePagoDefault, ProveedorClienteFlag, PorcentajeDeRetencion, AplicaIvaFlag, CategoriaProveedor, MontoChequeEnMonExtFlag, Ingreso, UltAct, Usuario FROM dbo.Proveedores WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Proveedores OFF
GO
ALTER TABLE dbo.CuotasFactura
	DROP CONSTRAINT FK_CuotasFactura_Proveedores
GO
ALTER TABLE dbo.Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad
	DROP CONSTRAINT FK_Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad_Proveedores
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos
	DROP CONSTRAINT FK_CajaChica_Reposiciones_Gastos_Proveedores
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Proveedores
GO
ALTER TABLE dbo.OrdenesPago
	DROP CONSTRAINT FK_OrdenesPago_Proveedores
GO
ALTER TABLE dbo.Pagos
	DROP CONSTRAINT FK_Pagos_Proveedores
GO
ALTER TABLE dbo.SaldosCompanias
	DROP CONSTRAINT FK_SaldosCompanias_Proveedores
GO
ALTER TABLE dbo.Facturas
	DROP CONSTRAINT FK_Facturas_Proveedores
GO
ALTER TABLE dbo.Personas
	DROP CONSTRAINT FK_Personas_Proveedores
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




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion
Insert Into tVersion(VersionActual, Fecha) Values('v0.00.279', GetDate()) 