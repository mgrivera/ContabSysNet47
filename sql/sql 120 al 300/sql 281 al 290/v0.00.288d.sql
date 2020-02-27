/*    Jueves, 20 de Octubre de 2.011  -   v0.00.288d.sql 

	Hacemos cambios importantes a las tablas que corresponden a 
	Movimientos Bancarios 
	
	NOTA IMPORTANTE: falló en Geh, porqué? Ejecutar por partes para revisar ... 
	(Nota: para Lacoste se ejecutó perfectamente) 
	
	
	Ejecutar esta instrucción: creo que solo en Geh puede pasar, pues agregamos *antes* ActivosFijos (???!!!) 
	(nota: en Lacoste se ejecutó bien; sin ejecutar la instrucción que sigue!) 
	
	ALTER TABLE dbo.InventarioActivosFijos
	DROP CONSTRAINT FK_InventarioActivosFijos_Companias
	
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
DROP TABLE dbo.CompaniasId
GO
COMMIT
BEGIN TRANSACTION
GO
DROP TABLE dbo.ChequerasId
GO
COMMIT
BEGIN TRANSACTION
GO
DROP TABLE dbo.CuentasBancariasId
GO
COMMIT
BEGIN TRANSACTION
GO
DROP TABLE dbo.MovimientosBancariosId
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasBancarias
	DROP CONSTRAINT FK_CuentasBancarias_DefinicionArchivoMovBanco
GO
ALTER TABLE dbo.DefinicionArchivoMovBanco SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasBancarias
	DROP CONSTRAINT FK_CuentasBancarias_Agencias
GO
ALTER TABLE dbo.Agencias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasBancarias
	DROP CONSTRAINT FK_CuentasBancarias_Bancos
GO
ALTER TABLE dbo.Bancos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasBancarias
	DROP CONSTRAINT FK_CuentasBancarias_Monedas
GO
ALTER TABLE dbo.Monedas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Proveedores
GO
ALTER TABLE dbo.Proveedores SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Companias
	(
	Numero int NOT NULL IDENTITY (1, 1),
	Nombre nvarchar(50) NOT NULL,
	NombreCorto nvarchar(25) NOT NULL,
	Abreviatura nvarchar(5) NULL,
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
ALTER TABLE dbo.Asientos
	DROP CONSTRAINT FK_Asientos_Companias
GO
ALTER TABLE dbo.Disponibilidad_MontosRestringidos
	DROP CONSTRAINT FK_Disponibilidad_MontosRestringidos_Companias
GO
ALTER TABLE dbo.tCiaSeleccionada
	DROP CONSTRAINT FK_tCiaSeleccionada_Companias
GO
ALTER TABLE dbo.UltimoMesCerradoContab
	DROP CONSTRAINT FK_UltimoMesCerradoContab_Companias
GO
ALTER TABLE dbo.MesesDelAnoFiscal
	DROP CONSTRAINT FK_MesesDelAnoFiscal_Companias
GO
ALTER TABLE dbo.ParametrosContab
	DROP CONSTRAINT FK_ParametrosContab_Companias
GO
ALTER TABLE dbo.CuentasContables
	DROP CONSTRAINT FK_CuentasContables_Companias
GO
ALTER TABLE dbo.Entradas
	DROP CONSTRAINT FK_Entradas_Companias
GO
ALTER TABLE dbo.Salidas
	DROP CONSTRAINT FK_Salidas_Companias
GO
ALTER TABLE dbo.UltimoMesCerrado
	DROP CONSTRAINT FK_UltimoMesCerrado_Companias
GO
ALTER TABLE dbo.NivelesAgrupacionContableMontosEstimados
	DROP CONSTRAINT FK_NivelesAgrupacionContableMontosEstimados_Companias
GO
ALTER TABLE dbo.Pagos
	DROP CONSTRAINT FK_Pagos_Companias
GO
ALTER TABLE dbo.Saldos
	DROP CONSTRAINT FK_Saldos_Companias
GO
ALTER TABLE dbo.SaldosCompanias
	DROP CONSTRAINT FK_SaldosCompanias_Companias
GO
ALTER TABLE dbo.CuotasFactura
	DROP CONSTRAINT FK_CuotasFactura_Companias
GO
ALTER TABLE dbo.OrdenesPago
	DROP CONSTRAINT FK_OrdenesPago_Companias
GO
ALTER TABLE dbo.CajaChica_RubrosCuentasContables
	DROP CONSTRAINT FK_CajaChica_RubrosCuentasContables_Companias
GO
ALTER TABLE dbo.Presupuesto_Codigos
	DROP CONSTRAINT FK_Presupuesto_Codigos_Companias
GO
ALTER TABLE dbo.Facturas
	DROP CONSTRAINT FK_Facturas_Companias
GO
ALTER TABLE dbo.CuentasBancarias
	DROP CONSTRAINT FK_CuentasBancarias_Companias
GO
ALTER TABLE dbo.CajaChica_CajasChicas
	DROP CONSTRAINT FK_CajaChica_CajasChicas_Companias
GO














/*vamos por aquí !!!!!!!!!!!!!!! */ 


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
ALTER TABLE dbo.CuentasBancarias
	DROP CONSTRAINT FK_CuentasBancarias_CuentasContables
GO
ALTER TABLE dbo.CuentasBancarias
	DROP CONSTRAINT FK_CuentasBancarias_CuentasContables1
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
CREATE TABLE dbo.Tmp_CuentasBancarias
	(
	CuentaInterna int NOT NULL IDENTITY (1, 1),
	Agencia int NOT NULL,
	CuentaBancaria nvarchar(50) NOT NULL,
	Tipo nvarchar(2) NOT NULL,
	Moneda int NOT NULL,
	LineaCredito money NULL,
	Banco int NULL,
	Estado char(2) NOT NULL,
	CuentaContable int NULL,
	CuentaContableGastosIDB int NULL,
	FormatoImpresionCheque smallint NULL,
	GenerarTransaccionesAOtraCuentaFlag bit NULL,
	CuentaBancariaAsociada int NULL,
	NombrePlantillaWord nvarchar(100) NULL,
	NumeroDefinicion_ArchivoMovBanco smallint NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_CuentasBancarias SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_CuentasBancarias ON
GO
IF EXISTS(SELECT * FROM dbo.CuentasBancarias)
	 EXEC('INSERT INTO dbo.Tmp_CuentasBancarias (CuentaInterna, Agencia, CuentaBancaria, Tipo, Moneda, LineaCredito, Banco, Estado, CuentaContable, CuentaContableGastosIDB, FormatoImpresionCheque, GenerarTransaccionesAOtraCuentaFlag, CuentaBancariaAsociada, NombrePlantillaWord, NumeroDefinicion_ArchivoMovBanco, Cia)
		SELECT CuentaInterna, Agencia, CuentaBancaria, Tipo, Moneda, LineaCredito, Banco, Estado, CuentaContable, CuentaContableGastosIDB, FormatoImpresionCheque, GenerarTransaccionesAOtraCuentaFlag, CuentaBancariaAsociada, NombrePlantillaWord, NumeroDefinicion_ArchivoMovBanco, Cia FROM dbo.CuentasBancarias WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_CuentasBancarias OFF
GO
ALTER TABLE dbo.CuentasBancariasCuentasContables
	DROP CONSTRAINT FK_CuentasBancariasCuentasContables_CuentasBancarias
GO
ALTER TABLE dbo.Disponibilidad_MontosRestringidos_ConsultaDisponibilidad
	DROP CONSTRAINT FK_Disponibilidad_MontosRestringidos_ConsultaDisponibilidad_CuentasBancarias
GO
ALTER TABLE dbo.Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad
	DROP CONSTRAINT FK_Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad_CuentasBancarias
GO
ALTER TABLE dbo.Disponibilidad_MontosRestringidos
	DROP CONSTRAINT FK_Disponibilidad_MontosRestringidos_CuentasBancarias
GO
ALTER TABLE dbo.Saldos
	DROP CONSTRAINT FK_Saldos_CuentasBancarias
GO
ALTER TABLE dbo.Chequeras
	DROP CONSTRAINT FK_Chequeras_CuentasBancarias
GO
DROP TABLE dbo.CuentasBancarias
GO
EXECUTE sp_rename N'dbo.Tmp_CuentasBancarias', N'CuentasBancarias', 'OBJECT' 
GO
ALTER TABLE dbo.CuentasBancarias ADD CONSTRAINT
	PK_CuentasBancarias PRIMARY KEY NONCLUSTERED 
	(
	CuentaInterna
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

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
ALTER TABLE dbo.CuentasBancarias WITH NOCHECK ADD CONSTRAINT
	FK_CuentasBancarias_Agencias FOREIGN KEY
	(
	Agencia
	) REFERENCES dbo.Agencias
	(
	Agencia
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CuentasBancarias WITH NOCHECK ADD CONSTRAINT
	FK_CuentasBancarias_DefinicionArchivoMovBanco FOREIGN KEY
	(
	NumeroDefinicion_ArchivoMovBanco
	) REFERENCES dbo.DefinicionArchivoMovBanco
	(
	NumeroDefinicion
	) ON UPDATE  CASCADE 
	 ON DELETE  NO ACTION 
	 NOT FOR REPLICATION

GO
ALTER TABLE dbo.CuentasBancarias ADD CONSTRAINT
	FK_CuentasBancarias_CuentasContables FOREIGN KEY
	(
	CuentaContable
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CuentasBancarias ADD CONSTRAINT
	FK_CuentasBancarias_CuentasContables1 FOREIGN KEY
	(
	CuentaContableGastosIDB
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Chequeras
GO
ALTER TABLE dbo.Chequeras WITH NOCHECK ADD CONSTRAINT
	FK_Chequeras_CuentasBancarias FOREIGN KEY
	(
	NumeroCuenta
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Chequeras SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.Saldos WITH NOCHECK ADD CONSTRAINT
	FK_Saldos_CuentasBancarias FOREIGN KEY
	(
	CuentaBancaria
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Saldos SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.Disponibilidad_MontosRestringidos ADD CONSTRAINT
	FK_Disponibilidad_MontosRestringidos_CuentasBancarias FOREIGN KEY
	(
	CuentaBancaria
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Disponibilidad_MontosRestringidos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad ADD CONSTRAINT
	FK_Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad_CuentasBancarias FOREIGN KEY
	(
	CuentaBancaria
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Disponibilidad_MontosRestringidos_ConsultaDisponibilidad ADD CONSTRAINT
	FK_Disponibilidad_MontosRestringidos_ConsultaDisponibilidad_CuentasBancarias FOREIGN KEY
	(
	CuentaBancaria
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Disponibilidad_MontosRestringidos_ConsultaDisponibilidad SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasBancariasCuentasContables WITH NOCHECK ADD CONSTRAINT
	FK_CuentasBancariasCuentasContables_CuentasBancarias FOREIGN KEY
	(
	CuentaInterna
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CuentasBancariasCuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_MovimientosBancarios
	(
	Transaccion nvarchar(20) NOT NULL,
	CuentaInterna int NOT NULL,
	Tipo nvarchar(2) NOT NULL,
	Fecha datetime NOT NULL,
	Mes smallint NOT NULL,
	Ano smallint NOT NULL,
	ProvClte int NULL,
	Beneficiario nvarchar(50) NULL,
	Concepto nvarchar(250) NULL,
	MontoBase money NULL,
	Comision money NULL,
	Impuestos money NULL,
	Monto money NOT NULL,
	Ingreso datetime NULL,
	UltMod datetime NULL,
	Comprobante int NULL,
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	ClaveUnicaChequera int NOT NULL,
	FechaEntregado datetime NULL,
	Conciliacion_FechaEjecucion smalldatetime NULL,
	Conciliacion_MovimientoBanco_Fecha smalldatetime NULL,
	Conciliacion_MovimientoBanco_Numero nvarchar(50) NULL,
	Conciliacion_MovimientoBanco_Tipo nvarchar(4) NULL,
	Conciliacion_MovimientoBanco_FechaProceso smalldatetime NULL,
	Conciliacion_MovimientoBanco_Monto money NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_MovimientosBancarios SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_MovimientosBancarios ON
GO
IF EXISTS(SELECT * FROM dbo.MovimientosBancarios)
	 EXEC('INSERT INTO dbo.Tmp_MovimientosBancarios (Transaccion, CuentaInterna, Tipo, Fecha, Mes, Ano, ProvClte, Beneficiario, Concepto, MontoBase, Comision, Impuestos, Monto, Ingreso, UltMod, Comprobante, ClaveUnica, ClaveUnicaChequera, FechaEntregado, Conciliacion_FechaEjecucion, Conciliacion_MovimientoBanco_Fecha, Conciliacion_MovimientoBanco_Numero, Conciliacion_MovimientoBanco_Tipo, Conciliacion_MovimientoBanco_FechaProceso, Conciliacion_MovimientoBanco_Monto)
		SELECT Transaccion, CuentaInterna, Tipo, Fecha, Mes, Ano, ProvClte, Beneficiario, Concepto, MontoBase, Comision, Impuestos, Monto, Ingreso, UltMod, Comprobante, ClaveUnica, ClaveUnicaChequera, FechaEntregado, Conciliacion_FechaEjecucion, Conciliacion_MovimientoBanco_Fecha, Conciliacion_MovimientoBanco_Numero, Conciliacion_MovimientoBanco_Tipo, Conciliacion_MovimientoBanco_FechaProceso, Conciliacion_MovimientoBanco_Monto FROM dbo.MovimientosBancarios WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_MovimientosBancarios OFF
GO
DROP TABLE dbo.MovimientosBancarios
GO
EXECUTE sp_rename N'dbo.Tmp_MovimientosBancarios', N'MovimientosBancarios', 'OBJECT' 
GO
ALTER TABLE dbo.MovimientosBancarios ADD CONSTRAINT
	PK_MovimientosBancarios PRIMARY KEY NONCLUSTERED 
	(
	Transaccion,
	CuentaInterna,
	Tipo
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_MovimientosBancarios ON dbo.MovimientosBancarios
	(
	CuentaInterna
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
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
COMMIT




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion
Insert Into tVersion(VersionActual, Fecha) Values('v0.00.288d', GetDate()) 