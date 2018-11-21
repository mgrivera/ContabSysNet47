/*    
	  Viernes, 09/Mar/2.018   -   v0.00.402.sql 
	  
	  Agregamos 'cascade delete' a algunas relaciones entre CuentasContables y otras tablas. La idea es que, 
	  los registros asociados en algunas tablas, se eliminen en forma automática cuando se elimina una cuenta 
	  contable ... 
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
ALTER TABLE dbo.ConciliacionesBancarias
	DROP CONSTRAINT FK_ConciliacionesBancarias_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.ConciliacionesBancarias
	DROP CONSTRAINT FK_ConciliacionesBancarias_CuentasBancarias
GO
ALTER TABLE dbo.CuentasBancarias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO

ALTER TABLE dbo.dAsientos
	DROP CONSTRAINT FK_dAsientos_CuentasContables1
GO
ALTER TABLE dbo.ConciliacionesBancarias
	DROP CONSTRAINT FK_ConciliacionesBancarias_CuentasContables
GO
ALTER TABLE dbo.Presupuesto_AsociacionCodigosCuentas
	DROP CONSTRAINT FK_Presupuesto_AsociacionCodigosCuentas_CuentasContables1
GO
ALTER TABLE dbo.SaldosContables
	DROP CONSTRAINT FK_SaldosContables_CuentasContables1
GO
ALTER TABLE dbo.CuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.SaldosContables ADD CONSTRAINT
	FK_SaldosContables_CuentasContables1 FOREIGN KEY
	(
	CuentaContableID
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.SaldosContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Presupuesto_AsociacionCodigosCuentas ADD CONSTRAINT
	FK_Presupuesto_AsociacionCodigosCuentas_CuentasContables1 FOREIGN KEY
	(
	CuentaContableID
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Presupuesto_AsociacionCodigosCuentas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_ConciliacionesBancarias
	(
	ID int NOT NULL IDENTITY (1, 1),
	Descripcion nvarchar(250) NOT NULL,
	Desde date NOT NULL,
	Hasta date NOT NULL,
	CiaContab int NOT NULL,
	CuentaBancaria int NOT NULL,
	CuentaContable int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_ConciliacionesBancarias SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_ConciliacionesBancarias ON
GO
IF EXISTS(SELECT * FROM dbo.ConciliacionesBancarias)
	 EXEC('INSERT INTO dbo.Tmp_ConciliacionesBancarias (ID, Descripcion, Desde, Hasta, CiaContab, CuentaBancaria, CuentaContable)
		SELECT ID, Descripcion, Desde, Hasta, CiaContab, CuentaBancaria, CuentaContable FROM dbo.ConciliacionesBancarias WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_ConciliacionesBancarias OFF
GO
ALTER TABLE dbo.MovimientosDesdeBancos
	DROP CONSTRAINT FK_MovimientosDesdeBancos_ConciliacionesBancarias
GO
DROP TABLE dbo.ConciliacionesBancarias
GO
EXECUTE sp_rename N'dbo.Tmp_ConciliacionesBancarias', N'ConciliacionesBancarias', 'OBJECT' 
GO
ALTER TABLE dbo.ConciliacionesBancarias ADD CONSTRAINT
	PK_ConciliacionesBancarias PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

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
ALTER TABLE dbo.ConciliacionesBancarias ADD CONSTRAINT
	FK_ConciliacionesBancarias_Companias FOREIGN KEY
	(
	CiaContab
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.ConciliacionesBancarias ADD CONSTRAINT
	FK_ConciliacionesBancarias_CuentasContables FOREIGN KEY
	(
	CuentaContable
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  SET NULL 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.MovimientosDesdeBancos ADD CONSTRAINT
	FK_MovimientosDesdeBancos_ConciliacionesBancarias FOREIGN KEY
	(
	ConciliacionBancariaID
	) REFERENCES dbo.ConciliacionesBancarias
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.MovimientosDesdeBancos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.dAsientos ADD CONSTRAINT
	FK_dAsientos_CuentasContables1 FOREIGN KEY
	(
	CuentaContableID
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  CASCADE 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.dAsientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.402', GetDate()) 
