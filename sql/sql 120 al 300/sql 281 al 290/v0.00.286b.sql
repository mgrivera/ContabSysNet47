/*    Viernes, 7 de Octubre de 2.011  -   v0.00.286b.sql 

	Agregamos la columna CuentaContableID a las tablas que tienen una 
	relación con CuentasContables 
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
	DROP CONSTRAINT FK_dAsientos_CentrosCosto
GO
ALTER TABLE dbo.CentrosCosto SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.dAsientos
	DROP CONSTRAINT FK_dAsientos_Asientos
GO
ALTER TABLE dbo.Asientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Presupuesto_AsociacionCodigosCuentas
	DROP CONSTRAINT FK_Presupuesto_AsociacionCodigosCuentas_Presupuesto_Codigos
GO
ALTER TABLE dbo.Presupuesto_Codigos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.dAsientos
	DROP CONSTRAINT FK_dAsientos_CuentasContables
GO
ALTER TABLE dbo.CajaChica_RubrosCuentasContables
	DROP CONSTRAINT FK_CajaChica_RubrosCuentasContables_CuentasContables
GO
ALTER TABLE dbo.Presupuesto_AsociacionCodigosCuentas
	DROP CONSTRAINT FK_Presupuesto_AsociacionCodigosCuentas_CuentasContables
GO
ALTER TABLE dbo.SaldosContables
	DROP CONSTRAINT FK_SaldosContables_CuentasContables
GO
ALTER TABLE dbo.Presupuesto
	DROP CONSTRAINT FK_Presupuesto_CuentasContables
GO
ALTER TABLE dbo.CuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CajaChica_RubrosCuentasContables
	DROP CONSTRAINT FK_CajaChica_RubrosCuentasContables_CajaChica_Rubros
GO
ALTER TABLE dbo.CajaChica_Rubros SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CajaChica_RubrosCuentasContables
	DROP CONSTRAINT FK_CajaChica_RubrosCuentasContables_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_dAsientos
	(
	NumeroAutomatico int NOT NULL,
	Partida smallint NOT NULL,
	CuentaContableID int NULL,
	Cuenta nvarchar(25) NOT NULL,
	Descripcion nvarchar(50) NOT NULL,
	Referencia nvarchar(20) NULL,
	Debe money NOT NULL,
	Haber money NOT NULL,
	CentroCosto int NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_dAsientos SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.dAsientos)
	 EXEC('INSERT INTO dbo.Tmp_dAsientos (NumeroAutomatico, Partida, Cuenta, Descripcion, Referencia, Debe, Haber, CentroCosto, Cia)
		SELECT NumeroAutomatico, Partida, Cuenta, Descripcion, Referencia, Debe, Haber, CentroCosto, Cia FROM dbo.dAsientos WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.dAsientos
GO
EXECUTE sp_rename N'dbo.Tmp_dAsientos', N'dAsientos', 'OBJECT' 
GO
ALTER TABLE dbo.dAsientos ADD CONSTRAINT
	PK_dAsientos PRIMARY KEY NONCLUSTERED 
	(
	NumeroAutomatico,
	Partida
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_dAsientos ON dbo.dAsientos
	(
	NumeroAutomatico
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.dAsientos WITH NOCHECK ADD CONSTRAINT
	FK_dAsientos_Asientos FOREIGN KEY
	(
	NumeroAutomatico
	) REFERENCES dbo.Asientos
	(
	NumeroAutomatico
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.dAsientos ADD CONSTRAINT
	FK_dAsientos_CuentasContables FOREIGN KEY
	(
	Cuenta,
	Cia
	) REFERENCES dbo.CuentasContables
	(
	Cuenta,
	Cia
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.dAsientos ADD CONSTRAINT
	FK_dAsientos_CentrosCosto FOREIGN KEY
	(
	CentroCosto
	) REFERENCES dbo.CentrosCosto
	(
	CentroCosto
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 



	
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_SaldosContables
	(
	CuentaContableID int NULL,
	Cuenta nvarchar(25) NOT NULL,
	Ano smallint NOT NULL,
	Moneda int NOT NULL,
	MonedaOriginal int NOT NULL,
	Inicial money NULL,
	Mes01 money NULL,
	Mes02 money NULL,
	Mes03 money NULL,
	Mes04 money NULL,
	Mes05 money NULL,
	Mes06 money NULL,
	Mes07 money NULL,
	Mes08 money NULL,
	Mes09 money NULL,
	Mes10 money NULL,
	Mes11 money NULL,
	Mes12 money NULL,
	Anual money NULL,
	TieneAsientosEnElMes bit NULL,
	SaldoAntAgregadoFlag bit NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_SaldosContables SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.SaldosContables)
	 EXEC('INSERT INTO dbo.Tmp_SaldosContables (Cuenta, Ano, Moneda, MonedaOriginal, Inicial, Mes01, Mes02, Mes03, Mes04, Mes05, Mes06, Mes07, Mes08, Mes09, Mes10, Mes11, Mes12, Anual, TieneAsientosEnElMes, SaldoAntAgregadoFlag, Cia)
		SELECT Cuenta, Ano, Moneda, MonedaOriginal, Inicial, Mes01, Mes02, Mes03, Mes04, Mes05, Mes06, Mes07, Mes08, Mes09, Mes10, Mes11, Mes12, Anual, TieneAsientosEnElMes, SaldoAntAgregadoFlag, Cia FROM dbo.SaldosContables WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.SaldosContables
GO
EXECUTE sp_rename N'dbo.Tmp_SaldosContables', N'SaldosContables', 'OBJECT' 
GO
ALTER TABLE dbo.SaldosContables ADD CONSTRAINT
	PK_SaldosContables PRIMARY KEY NONCLUSTERED 
	(
	Cuenta,
	Ano,
	Moneda,
	MonedaOriginal,
	Cia
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_SaldosContables ON dbo.SaldosContables
	(
	Cuenta,
	Moneda,
	Ano,
	Cia
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.SaldosContables ADD CONSTRAINT
	FK_SaldosContables_CuentasContables FOREIGN KEY
	(
	Cuenta,
	Cia
	) REFERENCES dbo.CuentasContables
	(
	Cuenta,
	Cia
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO

CREATE TABLE dbo.Tmp_Presupuesto
	(
	CuentaContableID int NULL,
	CuentaContable nvarchar(25) NOT NULL,
	Moneda int NOT NULL,
	Ano smallint NOT NULL,
	Mes01Est money NULL,
	Mes01Eje money NULL,
	Mes02Est money NULL,
	Mes02Eje money NULL,
	Mes03Est money NULL,
	Mes03Eje money NULL,
	Mes04Est money NULL,
	Mes04Eje money NULL,
	Mes05Est money NULL,
	Mes05Eje money NULL,
	Mes06Est money NULL,
	Mes06Eje money NULL,
	Mes07Est money NULL,
	Mes07Eje money NULL,
	Mes08Est money NULL,
	Mes08Eje money NULL,
	Mes09Est money NULL,
	Mes09Eje money NULL,
	Mes10Est money NULL,
	Mes10Eje money NULL,
	Mes11Est money NULL,
	Mes11Eje money NULL,
	Mes12Est money NULL,
	Mes12Eje money NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Presupuesto SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.Presupuesto)
	 EXEC('INSERT INTO dbo.Tmp_Presupuesto (CuentaContable, Moneda, Ano, Mes01Est, Mes01Eje, Mes02Est, Mes02Eje, Mes03Est, Mes03Eje, Mes04Est, Mes04Eje, Mes05Est, Mes05Eje, Mes06Est, Mes06Eje, Mes07Est, Mes07Eje, Mes08Est, Mes08Eje, Mes09Est, Mes09Eje, Mes10Est, Mes10Eje, Mes11Est, Mes11Eje, Mes12Est, Mes12Eje, Cia)
		SELECT CuentaContable, Moneda, Ano, Mes01Est, Mes01Eje, Mes02Est, Mes02Eje, Mes03Est, Mes03Eje, Mes04Est, Mes04Eje, Mes05Est, Mes05Eje, Mes06Est, Mes06Eje, Mes07Est, Mes07Eje, Mes08Est, Mes08Eje, Mes09Est, Mes09Eje, Mes10Est, Mes10Eje, Mes11Est, Mes11Eje, Mes12Est, Mes12Eje, Cia FROM dbo.Presupuesto WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.Presupuesto
GO
EXECUTE sp_rename N'dbo.Tmp_Presupuesto', N'Presupuesto', 'OBJECT' 
GO
ALTER TABLE dbo.Presupuesto ADD CONSTRAINT
	PK_Presupuesto PRIMARY KEY NONCLUSTERED 
	(
	CuentaContable,
	Moneda,
	Ano,
	Cia
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Presupuesto ADD CONSTRAINT
	FK_Presupuesto_CuentasContables FOREIGN KEY
	(
	CuentaContable,
	Cia
	) REFERENCES dbo.CuentasContables
	(
	Cuenta,
	Cia
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Presupuesto_AsociacionCodigosCuentas
	(
	CodigoPresupuesto nvarchar(70) NOT NULL,
	CuentaContableID int NULL,
	CuentaContable nvarchar(25) NOT NULL,
	CiaContab int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Presupuesto_AsociacionCodigosCuentas SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.Presupuesto_AsociacionCodigosCuentas)
	 EXEC('INSERT INTO dbo.Tmp_Presupuesto_AsociacionCodigosCuentas (CodigoPresupuesto, CuentaContable, CiaContab)
		SELECT CodigoPresupuesto, CuentaContable, CiaContab FROM dbo.Presupuesto_AsociacionCodigosCuentas WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.Presupuesto_AsociacionCodigosCuentas
GO
EXECUTE sp_rename N'dbo.Tmp_Presupuesto_AsociacionCodigosCuentas', N'Presupuesto_AsociacionCodigosCuentas', 'OBJECT' 
GO
ALTER TABLE dbo.Presupuesto_AsociacionCodigosCuentas ADD CONSTRAINT
	PK_Presupuesto_AsociacionCodigosCuentas PRIMARY KEY CLUSTERED 
	(
	CodigoPresupuesto,
	CuentaContable,
	CiaContab
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Presupuesto_AsociacionCodigosCuentas WITH NOCHECK ADD CONSTRAINT
	FK_Presupuesto_AsociacionCodigosCuentas_Presupuesto_Codigos FOREIGN KEY
	(
	CodigoPresupuesto,
	CiaContab
	) REFERENCES dbo.Presupuesto_Codigos
	(
	Codigo,
	CiaContab
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Presupuesto_AsociacionCodigosCuentas WITH NOCHECK ADD CONSTRAINT
	FK_Presupuesto_AsociacionCodigosCuentas_CuentasContables FOREIGN KEY
	(
	CuentaContable,
	CiaContab
	) REFERENCES dbo.CuentasContables
	(
	Cuenta,
	Cia
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_CajaChica_RubrosCuentasContables
	(
	Rubro smallint NOT NULL,
	CiaContab int NOT NULL,
	CuentaContableID int NULL,
	CuentaContable nvarchar(25) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_CajaChica_RubrosCuentasContables SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.CajaChica_RubrosCuentasContables)
	 EXEC('INSERT INTO dbo.Tmp_CajaChica_RubrosCuentasContables (Rubro, CiaContab, CuentaContable)
		SELECT Rubro, CiaContab, CuentaContable FROM dbo.CajaChica_RubrosCuentasContables WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.CajaChica_RubrosCuentasContables
GO
EXECUTE sp_rename N'dbo.Tmp_CajaChica_RubrosCuentasContables', N'CajaChica_RubrosCuentasContables', 'OBJECT' 
GO
ALTER TABLE dbo.CajaChica_RubrosCuentasContables ADD CONSTRAINT
	PK_CajaChica_RubrosCuentasContables PRIMARY KEY CLUSTERED 
	(
	Rubro,
	CiaContab,
	CuentaContable
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

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
ALTER TABLE dbo.CajaChica_RubrosCuentasContables ADD CONSTRAINT
	FK_CajaChica_RubrosCuentasContables_CajaChica_Rubros FOREIGN KEY
	(
	Rubro
	) REFERENCES dbo.CajaChica_Rubros
	(
	Rubro
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.CajaChica_RubrosCuentasContables ADD CONSTRAINT
	FK_CajaChica_RubrosCuentasContables_CuentasContables FOREIGN KEY
	(
	CuentaContable,
	CiaContab
	) REFERENCES dbo.CuentasContables
	(
	Cuenta,
	Cia
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT




/*
	Ahora actualizamos el item CuentaContableID con su valor en CuentasContables 
*/ 


Update d Set CuentaContableID = c.ID
From Presupuesto_AsociacionCodigosCuentas d Inner Join CuentasContables c On d.CuentaContable = c.Cuenta And d.CiaContab = c.Cia 

Update d Set CuentaContableID = c.ID
From CajaChica_RubrosCuentasContables d Inner Join CuentasContables c On d.CuentaContable = c.Cuenta And d.CiaContab = c.Cia 

Update d Set CuentaContableID = c.ID
From dAsientos d Inner Join CuentasContables c On d.Cuenta = c.Cuenta And d.Cia = c.Cia 

Update d Set CuentaContableID = c.ID
From SaldosContables d Inner Join CuentasContables c On d.Cuenta = c.Cuenta And d.Cia = c.Cia 

Update d Set CuentaContableID = c.ID
From Presupuesto d Inner Join CuentasContables c On d.CuentaContable = c.Cuenta And d.Cia = c.Cia 


/*
	El nuevo item (CuentaContableID debe ser Not Null 
*/ 


Alter Table Presupuesto_AsociacionCodigosCuentas Alter Column CuentaContableID int Not Null 
Alter Table CajaChica_RubrosCuentasContables Alter Column CuentaContableID int Not Null 
Alter Table dAsientos Alter Column CuentaContableID int Not Null 
Alter Table SaldosContables Alter Column CuentaContableID int Not Null 
Alter Table Presupuesto Alter Column CuentaContableID int Not Null 


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion
Insert Into tVersion(VersionActual, Fecha) Values('v0.00.286b', GetDate()) 