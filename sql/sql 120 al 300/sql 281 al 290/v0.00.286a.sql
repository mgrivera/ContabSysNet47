/*    Viernes, 7 de Octubre de 2.011  -   v0.00.286a.sql 

	Agregamos la columna ID a la tabla Cuentas Contables 
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
ALTER TABLE dbo.CuentasContables
	DROP CONSTRAINT FK_CuentasContables_tGruposContables
GO
ALTER TABLE dbo.CuentasContables
	DROP CONSTRAINT FK_CuentasContables_tGruposContables1
GO
ALTER TABLE dbo.tGruposContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasContables
	DROP CONSTRAINT FK_CuentasContables_NivelesAgrupacionContable
GO
ALTER TABLE dbo.NivelesAgrupacionContable SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasContables
	DROP CONSTRAINT FK_CuentasContables_EstructurasContables
GO
ALTER TABLE dbo.EstructurasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasContables
	DROP CONSTRAINT FK_CuentasContables_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_CuentasContables
	(
	ID int NOT NULL IDENTITY (1, 1),
	Cuenta nvarchar(25) NOT NULL,
	Descripcion nvarchar(40) NULL,
	Nivel1 nvarchar(10) NULL,
	Nivel2 nvarchar(10) NULL,
	Nivel3 nvarchar(10) NULL,
	Nivel4 nvarchar(10) NULL,
	Nivel5 nvarchar(10) NULL,
	Nivel6 nvarchar(10) NULL,
	Nivel7 nvarchar(10) NULL,
	NumNiveles tinyint NULL,
	TotDet nvarchar(1) NULL,
	ActSusp nvarchar(1) NULL,
	Estructura int NULL,
	CuentaEditada nvarchar(30) NULL,
	Modelo nvarchar(30) NULL,
	Grupo int NULL,
	NivelAgrupacion nvarchar(20) NULL,
	GrupoNivelAgrupacion int NULL,
	PresupuestarFlag bit NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_CuentasContables SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_CuentasContables OFF
GO
IF EXISTS(SELECT * FROM dbo.CuentasContables)
	 EXEC('INSERT INTO dbo.Tmp_CuentasContables (Cuenta, Descripcion, Nivel1, Nivel2, Nivel3, Nivel4, Nivel5, Nivel6, Nivel7, NumNiveles, TotDet, ActSusp, Estructura, CuentaEditada, Modelo, Grupo, NivelAgrupacion, GrupoNivelAgrupacion, PresupuestarFlag, Cia)
		SELECT Cuenta, Descripcion, Nivel1, Nivel2, Nivel3, Nivel4, Nivel5, Nivel6, Nivel7, NumNiveles, TotDet, ActSusp, Estructura, CuentaEditada, Modelo, Grupo, NivelAgrupacion, GrupoNivelAgrupacion, PresupuestarFlag, Cia FROM dbo.CuentasContables WITH (HOLDLOCK TABLOCKX)')
GO
ALTER TABLE dbo.Presupuesto
	DROP CONSTRAINT FK_Presupuesto_CuentasContables
GO
ALTER TABLE dbo.SaldosContables
	DROP CONSTRAINT FK_SaldosContables_CuentasContables
GO
ALTER TABLE dbo.Presupuesto_AsociacionCodigosCuentas
	DROP CONSTRAINT FK_Presupuesto_AsociacionCodigosCuentas_CuentasContables
GO
ALTER TABLE dbo.CajaChica_RubrosCuentasContables
	DROP CONSTRAINT FK_CajaChica_RubrosCuentasContables_CuentasContables
GO
ALTER TABLE dbo.dAsientos
	DROP CONSTRAINT FK_dAsientos_CuentasContables
GO
DROP TABLE dbo.CuentasContables
GO
EXECUTE sp_rename N'dbo.Tmp_CuentasContables', N'CuentasContables', 'OBJECT' 
GO
ALTER TABLE dbo.CuentasContables ADD CONSTRAINT
	PK_CuentasContables PRIMARY KEY NONCLUSTERED 
	(
	Cuenta,
	Cia
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

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
ALTER TABLE dbo.CuentasContables ADD CONSTRAINT
	FK_CuentasContables_EstructurasContables FOREIGN KEY
	(
	Estructura
	) REFERENCES dbo.EstructurasContables
	(
	Estructura
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CuentasContables ADD CONSTRAINT
	FK_CuentasContables_NivelesAgrupacionContable FOREIGN KEY
	(
	NivelAgrupacion
	) REFERENCES dbo.NivelesAgrupacionContable
	(
	NivelAgrupacion
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CuentasContables ADD CONSTRAINT
	FK_CuentasContables_tGruposContables FOREIGN KEY
	(
	Grupo
	) REFERENCES dbo.tGruposContables
	(
	Grupo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CuentasContables ADD CONSTRAINT
	FK_CuentasContables_tGruposContables1 FOREIGN KEY
	(
	GrupoNivelAgrupacion
	) REFERENCES dbo.tGruposContables
	(
	Grupo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
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
ALTER TABLE dbo.dAsientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
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
ALTER TABLE dbo.CajaChica_RubrosCuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
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
ALTER TABLE dbo.Presupuesto_AsociacionCodigosCuentas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
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
ALTER TABLE dbo.SaldosContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
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
ALTER TABLE dbo.Presupuesto SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion
Insert Into tVersion(VersionActual, Fecha) Values('v0.00.286a', GetDate()) 