/*    Viernes, 21 de Octubre de 2.011  -   v0.00.289.sql 

	Agregamos Nemonico a la tabla Proveedores 
	
	NOTA IMPORTANTE: solo en Geh, esta instrucción puede pasar (creo) - probar: 
	
	(Geh: corrió si antes ejecutamos la instrucción que sigue) 
	(Nota: ejecutamos bien en Lacoste *sin* ejecutar la instrucción que sigue ... 
	
	ALTER TABLE dbo.InventarioActivosFijos
	DROP CONSTRAINT FK_InventarioActivosFijos_Proveedores

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
CREATE TABLE dbo.Tmp_Bancos
	(
	Banco int NOT NULL IDENTITY (1, 1),
	Nombre nvarchar(50) NOT NULL,
	NombreCorto nvarchar(10) NULL,
	Abreviatura nvarchar(6) NULL,
	DefinicionParaElArchivo int NULL,
	NombreArchivoDeTexto nvarchar(150) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Bancos SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Bancos ON
GO
IF EXISTS(SELECT * FROM dbo.Bancos)
	 EXEC('INSERT INTO dbo.Tmp_Bancos (Banco, Nombre, NombreCorto, Abreviatura, DefinicionParaElArchivo, NombreArchivoDeTexto)
		SELECT Banco, Nombre, NombreCorto, Abreviatura, DefinicionParaElArchivo, NombreArchivoDeTexto FROM dbo.Bancos WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Bancos OFF
GO
ALTER TABLE dbo.CuentasBancarias
	DROP CONSTRAINT FK_CuentasBancarias_Bancos
GO
ALTER TABLE dbo.BancosInfoTarjetas
	DROP CONSTRAINT FK_BancosInfoTarjetas_Bancos
GO
ALTER TABLE dbo.Agencias
	DROP CONSTRAINT FK_Agencias_Bancos
GO
DROP TABLE dbo.Bancos
GO
EXECUTE sp_rename N'dbo.Tmp_Bancos', N'Bancos', 'OBJECT' 
GO
ALTER TABLE dbo.Bancos ADD CONSTRAINT
	PK_Bancos PRIMARY KEY NONCLUSTERED 
	(
	Banco
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Agencias WITH NOCHECK ADD CONSTRAINT
	FK_Agencias_Bancos FOREIGN KEY
	(
	Banco
	) REFERENCES dbo.Bancos
	(
	Banco
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Agencias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.BancosInfoTarjetas WITH NOCHECK ADD CONSTRAINT
	FK_BancosInfoTarjetas_Bancos FOREIGN KEY
	(
	Banco
	) REFERENCES dbo.Bancos
	(
	Banco
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.BancosInfoTarjetas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO

CREATE TABLE dbo.Tmp_Companias
	(
	Numero int NOT NULL IDENTITY (1, 1),
	Nombre nvarchar(50) NOT NULL,
	NombreCorto nvarchar(25) NOT NULL,
	Abreviatura nvarchar(6) NULL,
	Rif nvarchar(12) NULL,
	Direccion nvarchar(150) NULL,
	Ciudad nvarchar(25) NULL,
	EntidadFederal nvarchar(50) NULL,
	ZonaPostal nvarchar(15) NULL,
	Telefono1 nvarchar(14) NULL,
	Telefono2 nvarchar(14) NULL,
	Fax nvarchar(14) NULL,
	EmailServerName nvarchar(100) NULL,
	EmailServerPort int NULL,
	EmailServerSSLFlag bit NULL,
	EmailServerCredentialsUserName nvarchar(100) NULL,
	EmailServerCredentialsPassword nvarchar(50) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Companias SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Companias ON
GO
IF EXISTS(SELECT * FROM dbo.Companias)
	 EXEC('INSERT INTO dbo.Tmp_Companias (Numero, Nombre, NombreCorto, Abreviatura, Rif, Direccion, Ciudad, EntidadFederal, ZonaPostal, Telefono1, Telefono2, Fax, EmailServerName, EmailServerPort, EmailServerSSLFlag, EmailServerCredentialsUserName, EmailServerCredentialsPassword)
		SELECT Numero, Nombre, NombreCorto, Abreviatura, Rif, Direccion, Ciudad, EntidadFederal, ZonaPostal, Telefono1, Telefono2, Fax, EmailServerName, EmailServerPort, EmailServerSSLFlag, EmailServerCredentialsUserName, EmailServerCredentialsPassword FROM dbo.Companias WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Companias OFF
GO
ALTER TABLE dbo.tCiaSeleccionada
	DROP CONSTRAINT FK_tCiaSeleccionada_Companias
GO
ALTER TABLE dbo.Asientos
	DROP CONSTRAINT FK_Asientos_Companias
GO
ALTER TABLE dbo.CuentasBancarias
	DROP CONSTRAINT FK_CuentasBancarias_Companias
GO
ALTER TABLE dbo.Saldos
	DROP CONSTRAINT FK_Saldos_Companias
GO
ALTER TABLE dbo.Disponibilidad_MontosRestringidos
	DROP CONSTRAINT FK_Disponibilidad_MontosRestringidos_Companias
GO
ALTER TABLE dbo.CajaChica_CajasChicas
	DROP CONSTRAINT FK_CajaChica_CajasChicas_Companias
GO
ALTER TABLE dbo.Facturas
	DROP CONSTRAINT FK_Facturas_Companias
GO
ALTER TABLE dbo.Presupuesto_Codigos
	DROP CONSTRAINT FK_Presupuesto_Codigos_Companias
GO
ALTER TABLE dbo.CajaChica_RubrosCuentasContables
	DROP CONSTRAINT FK_CajaChica_RubrosCuentasContables_Companias
GO
ALTER TABLE dbo.OrdenesPago
	DROP CONSTRAINT FK_OrdenesPago_Companias
GO
ALTER TABLE dbo.CuotasFactura
	DROP CONSTRAINT FK_CuotasFactura_Companias
GO
ALTER TABLE dbo.SaldosCompanias
	DROP CONSTRAINT FK_SaldosCompanias_Companias
GO
ALTER TABLE dbo.Pagos
	DROP CONSTRAINT FK_Pagos_Companias
GO
ALTER TABLE dbo.NivelesAgrupacionContableMontosEstimados
	DROP CONSTRAINT FK_NivelesAgrupacionContableMontosEstimados_Companias
GO
ALTER TABLE dbo.UltimoMesCerrado
	DROP CONSTRAINT FK_UltimoMesCerrado_Companias
GO
ALTER TABLE dbo.Salidas
	DROP CONSTRAINT FK_Salidas_Companias
GO
ALTER TABLE dbo.Entradas
	DROP CONSTRAINT FK_Entradas_Companias
GO
ALTER TABLE dbo.CuentasContables
	DROP CONSTRAINT FK_CuentasContables_Companias
GO
ALTER TABLE dbo.ParametrosContab
	DROP CONSTRAINT FK_ParametrosContab_Companias
GO
ALTER TABLE dbo.MesesDelAnoFiscal
	DROP CONSTRAINT FK_MesesDelAnoFiscal_Companias
GO
ALTER TABLE dbo.UltimoMesCerradoContab
	DROP CONSTRAINT FK_UltimoMesCerradoContab_Companias
GO
DROP TABLE dbo.Companias
GO
EXECUTE sp_rename N'dbo.Tmp_Companias', N'Companias', 'OBJECT' 
GO
ALTER TABLE dbo.Companias ADD CONSTRAINT
	PK_Companias PRIMARY KEY NONCLUSTERED 
	(
	Numero
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.UltimoMesCerradoContab ADD CONSTRAINT
	FK_UltimoMesCerradoContab_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.UltimoMesCerradoContab SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.MesesDelAnoFiscal ADD CONSTRAINT
	FK_MesesDelAnoFiscal_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.MesesDelAnoFiscal SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.ParametrosContab ADD CONSTRAINT
	FK_ParametrosContab_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.ParametrosContab SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasContables WITH NOCHECK ADD CONSTRAINT
	FK_CuentasContables_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Entradas WITH NOCHECK ADD CONSTRAINT
	FK_Entradas_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Entradas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Salidas WITH NOCHECK ADD CONSTRAINT
	FK_Salidas_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Salidas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.UltimoMesCerrado WITH NOCHECK ADD CONSTRAINT
	FK_UltimoMesCerrado_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.UltimoMesCerrado SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.NivelesAgrupacionContableMontosEstimados ADD CONSTRAINT
	FK_NivelesAgrupacionContableMontosEstimados_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.NivelesAgrupacionContableMontosEstimados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CajaChica_RubrosCuentasContables ADD CONSTRAINT
	FK_CajaChica_RubrosCuentasContables_Companias FOREIGN KEY
	(
	CiaContab
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.CajaChica_RubrosCuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Presupuesto_Codigos WITH NOCHECK ADD CONSTRAINT
	FK_Presupuesto_Codigos_Companias FOREIGN KEY
	(
	CiaContab
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Presupuesto_Codigos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CajaChica_CajasChicas ADD CONSTRAINT
	FK_CajaChica_CajasChicas_Companias FOREIGN KEY
	(
	CiaContab
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.CajaChica_CajasChicas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Disponibilidad_MontosRestringidos ADD CONSTRAINT
	FK_Disponibilidad_MontosRestringidos_Companias FOREIGN KEY
	(
	CiaContab
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Disponibilidad_MontosRestringidos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Saldos WITH NOCHECK ADD CONSTRAINT
	FK_Saldos_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Saldos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasBancarias WITH NOCHECK ADD CONSTRAINT
	FK_CuentasBancarias_Bancos FOREIGN KEY
	(
	Banco
	) REFERENCES dbo.Bancos
	(
	Banco
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CuentasBancarias WITH NOCHECK ADD CONSTRAINT
	FK_CuentasBancarias_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CuentasBancarias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Asientos ADD CONSTRAINT
	FK_Asientos_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Asientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tCiaSeleccionada ADD CONSTRAINT
	FK_tCiaSeleccionada_Companias FOREIGN KEY
	(
	CiaSeleccionada
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.tCiaSeleccionada SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

/* vamos por aqui! */ 

BEGIN TRANSACTION
GO

CREATE TABLE dbo.Tmp_Proveedores
	(
	Proveedor int NOT NULL IDENTITY (1, 1),
	Nombre nvarchar(50) NOT NULL,
	Abreviatura nvarchar(10) NULL,
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
		SELECT Proveedor, Nombre, Tipo, Rif, NatJurFlag, Nit, ContribuyenteEspecialFlag, RetencionSobreIvaPorc, NuestraRetencionSobreIvaPorc, AfectaLibroComprasFlag, Beneficiario, Concepto, MontoCheque, Direccion, Ciudad, Telefono1, Telefono2, Fax, Contacto1, Contacto2, NacionalExtranjeroFlag, SujetoARetencionFlag, CodigoConceptoRetencion, RetencionISLRSustraendo, MonedaDefault, FormaDePagoDefault, ProveedorClienteFlag, PorcentajeDeRetencion, AplicaIvaFlag, CategoriaProveedor, MontoChequeEnMonExtFlag, Ingreso, UltAct, Usuario FROM dbo.Proveedores WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Proveedores OFF
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Proveedores
GO
ALTER TABLE dbo.Personas
	DROP CONSTRAINT FK_Personas_Proveedores
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
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos
	DROP CONSTRAINT FK_CajaChica_Reposiciones_Gastos_Proveedores
GO
ALTER TABLE dbo.Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad
	DROP CONSTRAINT FK_Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad_Proveedores
GO
ALTER TABLE dbo.CuotasFactura
	DROP CONSTRAINT FK_CuotasFactura_Proveedores
GO









/* NOTA: hasta aquí corre !!! */ 




















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
ALTER TABLE dbo.CuotasFactura WITH NOCHECK ADD CONSTRAINT
	FK_CuotasFactura_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
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
ALTER TABLE dbo.OrdenesPago ADD CONSTRAINT
	FK_OrdenesPago_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
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
ALTER TABLE dbo.SaldosCompanias WITH NOCHECK ADD CONSTRAINT
	FK_SaldosCompanias_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
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
ALTER TABLE dbo.Facturas SET (LOCK_ESCALATION = TABLE)
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


Update Bancos Set Abreviatura = Substring(Nombre, 1, 6) Where Abreviatura = '' Or Abreviatura Is Null 
Update Companias Set Abreviatura = Substring(Nombre, 1, 6) Where Abreviatura = '' Or Abreviatura Is Null 
Update Proveedores Set Abreviatura = Substring(Nombre, 1, 10) Where Abreviatura = '' Or Abreviatura Is Null 


Alter TABLE Bancos Alter Column Abreviatura nvarchar(6) NOt NULL
Alter TABLE Companias Alter Column Abreviatura nvarchar(6) Not NULL
Alter TABLE Proveedores Alter Column Abreviatura nvarchar(10) Not NULL
	
	
	
--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion
Insert Into tVersion(VersionActual, Fecha) Values('v0.00.289', GetDate()) 