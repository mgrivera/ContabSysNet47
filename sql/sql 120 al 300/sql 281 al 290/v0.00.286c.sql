/*    Viernes, 7 de Octubre de 2.011  -   v0.00.286c.sql 

	Agregamos nuevas relaciones entre CuentasContables y las 
	tables (5) relacionadas ... 
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
ALTER TABLE dbo.dAsientos
	DROP CONSTRAINT FK_dAsientos_CuentasContables
GO
ALTER TABLE dbo.SaldosContables
	DROP CONSTRAINT FK_SaldosContables_CuentasContables
GO
ALTER TABLE dbo.Presupuesto
	DROP CONSTRAINT FK_Presupuesto_CuentasContables
GO
ALTER TABLE dbo.Presupuesto_AsociacionCodigosCuentas
	DROP CONSTRAINT FK_Presupuesto_AsociacionCodigosCuentas_CuentasContables
GO
ALTER TABLE dbo.CajaChica_RubrosCuentasContables
	DROP CONSTRAINT FK_CajaChica_RubrosCuentasContables_CuentasContables
GO
ALTER TABLE dbo.CuentasContables
	DROP CONSTRAINT PK_CuentasContables
GO
ALTER TABLE dbo.CuentasContables ADD CONSTRAINT
	PK_CuentasContables PRIMARY KEY NONCLUSTERED 
	(
	ID
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE UNIQUE NONCLUSTERED INDEX IX_CuentasContables ON dbo.CuentasContables
	(
	Cuenta,
	Cia
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.CuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.dAsientos
	DROP CONSTRAINT PK_dAsientos
GO
ALTER TABLE dbo.dAsientos ADD CONSTRAINT
	PK_dAsientos PRIMARY KEY NONCLUSTERED 
	(
	NumeroAutomatico,
	Partida,
	CuentaContableID
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

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
ALTER TABLE dbo.dAsientos
	DROP COLUMN Cuenta, Cia
GO
ALTER TABLE dbo.dAsientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
DROP INDEX IX_SaldosContables ON dbo.SaldosContables
GO
ALTER TABLE dbo.SaldosContables
	DROP CONSTRAINT PK_SaldosContables
GO
ALTER TABLE dbo.SaldosContables ADD CONSTRAINT
	PK_SaldosContables_1 PRIMARY KEY CLUSTERED 
	(
	CuentaContableID,
	Ano,
	Moneda,
	MonedaOriginal
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.SaldosContables ADD CONSTRAINT
	FK_SaldosContables_CuentasContables1 FOREIGN KEY
	(
	CuentaContableID
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  CASCADE 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.SaldosContables
	DROP COLUMN Cuenta
GO
ALTER TABLE dbo.SaldosContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Presupuesto
	DROP CONSTRAINT PK_Presupuesto
GO
ALTER TABLE dbo.Presupuesto ADD CONSTRAINT
	PK_Presupuesto_1 PRIMARY KEY CLUSTERED 
	(
	CuentaContableID,
	Moneda,
	Ano
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Presupuesto ADD CONSTRAINT
	FK_Presupuesto_CuentasContables1 FOREIGN KEY
	(
	CuentaContableID
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  CASCADE 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Presupuesto
	DROP COLUMN CuentaContable
GO
ALTER TABLE dbo.Presupuesto SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Presupuesto_AsociacionCodigosCuentas
	DROP CONSTRAINT PK_Presupuesto_AsociacionCodigosCuentas
GO
ALTER TABLE dbo.Presupuesto_AsociacionCodigosCuentas ADD CONSTRAINT
	PK_Presupuesto_AsociacionCodigosCuentas_1 PRIMARY KEY CLUSTERED 
	(
	CodigoPresupuesto,
	CuentaContableID,
	CiaContab
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Presupuesto_AsociacionCodigosCuentas ADD CONSTRAINT
	FK_Presupuesto_AsociacionCodigosCuentas_CuentasContables1 FOREIGN KEY
	(
	CuentaContableID
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  CASCADE 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Presupuesto_AsociacionCodigosCuentas
	DROP COLUMN CuentaContable
GO
ALTER TABLE dbo.Presupuesto_AsociacionCodigosCuentas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CajaChica_RubrosCuentasContables
	DROP CONSTRAINT PK_CajaChica_RubrosCuentasContables
GO
ALTER TABLE dbo.CajaChica_RubrosCuentasContables ADD CONSTRAINT
	PK_CajaChica_RubrosCuentasContables_1 PRIMARY KEY CLUSTERED 
	(
	Rubro,
	CiaContab,
	CuentaContableID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.CajaChica_RubrosCuentasContables ADD CONSTRAINT
	FK_CajaChica_RubrosCuentasContables_CuentasContables1 FOREIGN KEY
	(
	CuentaContableID
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  CASCADE 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CajaChica_RubrosCuentasContables
	DROP COLUMN CuentaContable
GO
ALTER TABLE dbo.CajaChica_RubrosCuentasContables SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.dAsientos
	DROP CONSTRAINT PK_dAsientos
GO
ALTER TABLE dbo.dAsientos ADD CONSTRAINT
	PK_dAsientos PRIMARY KEY CLUSTERED 
	(
	NumeroAutomatico,
	Partida
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.dAsientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion
Insert Into tVersion(VersionActual, Fecha) Values('v0.00.286c', GetDate()) 