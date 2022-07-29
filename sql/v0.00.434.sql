/*    
	  Lunes, 11 de Mayo 2.022  -   v0.00.434.sql 
	  
	  Cuentas bancarias: agregamos la columna ComisionPorc 
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
ALTER TABLE dbo.CuentasBancarias
	DROP CONSTRAINT FK_CuentasBancarias_DefinicionArchivoMovBanco
GO
ALTER TABLE dbo.DefinicionArchivoMovBanco SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.CuentasBancarias
	DROP CONSTRAINT FK_CuentasBancarias_CuentasContables
GO
ALTER TABLE dbo.CuentasBancarias
	DROP CONSTRAINT FK_CuentasBancarias_CuentasContables1
GO
ALTER TABLE dbo.CuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasBancarias
	DROP CONSTRAINT FK_CuentasBancarias_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
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
CREATE TABLE dbo.Tmp_CuentasBancarias
	(
	CuentaInterna int NOT NULL IDENTITY (1, 1),
	Agencia int NOT NULL,
	CuentaBancaria nvarchar(50) NOT NULL,
	Tipo nvarchar(2) NOT NULL,
	Moneda int NOT NULL,
	LineaCredito money NULL,
	Estado char(2) NOT NULL,
	ComisionPorc decimal(6, 3) NULL,
	CuentaContable int NULL,
	CuentaContableGastosIDB int NULL,
	FormatoImpresionCheque smallint NULL,
	GenerarTransaccionesAOtraCuentaFlag bit NULL,
	CuentaBancariaAsociada int NULL,
	NombrePlantillaWord nvarchar(100) NULL,
	NumeroDefinicion_ArchivoMovBanco smallint NULL,
	NumeroContrato nvarchar(20) NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_CuentasBancarias SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_CuentasBancarias ON
GO
IF EXISTS(SELECT * FROM dbo.CuentasBancarias)
	 EXEC('INSERT INTO dbo.Tmp_CuentasBancarias (CuentaInterna, Agencia, CuentaBancaria, Tipo, Moneda, LineaCredito, Estado, CuentaContable, CuentaContableGastosIDB, FormatoImpresionCheque, GenerarTransaccionesAOtraCuentaFlag, CuentaBancariaAsociada, NombrePlantillaWord, NumeroDefinicion_ArchivoMovBanco, NumeroContrato, Cia)
		SELECT CuentaInterna, Agencia, CuentaBancaria, Tipo, Moneda, LineaCredito, Estado, CuentaContable, CuentaContableGastosIDB, FormatoImpresionCheque, GenerarTransaccionesAOtraCuentaFlag, CuentaBancariaAsociada, NombrePlantillaWord, NumeroDefinicion_ArchivoMovBanco, NumeroContrato, Cia FROM dbo.CuentasBancarias WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_CuentasBancarias OFF
GO
ALTER TABLE dbo.ConciliacionesBancarias
	DROP CONSTRAINT FK_ConciliacionesBancarias_CuentasBancarias
GO
ALTER TABLE dbo.Chequeras
	DROP CONSTRAINT FK_Chequeras_CuentasBancarias
GO
ALTER TABLE dbo.Disponibilidad_MontosRestringidos_ConsultaDisponibilidad
	DROP CONSTRAINT FK_Disponibilidad_MontosRestringidos_ConsultaDisponibilidad_CuentasBancarias
GO
ALTER TABLE dbo.Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad
	DROP CONSTRAINT FK_Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad_CuentasBancarias
GO
ALTER TABLE dbo.CuentasBancariasCuentasContables
	DROP CONSTRAINT FK_CuentasBancariasCuentasContables_CuentasBancarias
GO
ALTER TABLE dbo.Disponibilidad_MontosRestringidos
	DROP CONSTRAINT FK_Disponibilidad_MontosRestringidos_CuentasBancarias
GO
ALTER TABLE dbo.Saldos
	DROP CONSTRAINT FK_Saldos_CuentasBancarias
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
	FK_CuentasBancarias_Agencias FOREIGN KEY
	(
	Agencia
	) REFERENCES dbo.Agencias
	(
	Agencia
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
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
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Saldos WITH NOCHECK ADD CONSTRAINT
	FK_Saldos_CuentasBancarias FOREIGN KEY
	(
	CuentaBancaria
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Saldos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
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
ALTER TABLE dbo.Chequeras WITH NOCHECK ADD CONSTRAINT
	FK_Chequeras_CuentasBancarias FOREIGN KEY
	(
	NumeroCuenta
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Chequeras SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.ConciliacionesBancarias ADD CONSTRAINT
	FK_ConciliacionesBancarias_CuentasBancarias FOREIGN KEY
	(
	CuentaBancaria
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.ConciliacionesBancarias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.434', GetDate()) 