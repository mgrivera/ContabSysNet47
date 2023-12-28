/*    
	  Lunes, 27 de Noviembre de 2.023  -   v0.00.453.sql 
	  
	  Agregamos la columna UltMod a la tabla: CuentasContables 
	  
	  ==============================================================================================================
	  Nota importante: ejecutar con cuidado (por partes?), pues elimina/crea muchas estructuras (constraints) 
	  y mejor tener cuidado al ejecutarlo. 
	  ==============================================================================================================
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
	DROP CONSTRAINT FK_CuentasContables_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
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
	DROP CONSTRAINT FK_CuentasContables_tGruposContables1
GO
ALTER TABLE dbo.CuentasContables
	DROP CONSTRAINT FK_CuentasContables_tGruposContables
GO
ALTER TABLE dbo.tGruposContables SET (LOCK_ESCALATION = TABLE)
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
CREATE TABLE dbo.Tmp_CuentasContables
	(
	ID int NOT NULL IDENTITY (1, 1),
	Cuenta nvarchar(25) NOT NULL,
	Descripcion nvarchar(40) NOT NULL,
	Nivel1 nvarchar(10) NOT NULL,
	Nivel2 nvarchar(10) NULL,
	Nivel3 nvarchar(10) NULL,
	Nivel4 nvarchar(10) NULL,
	Nivel5 nvarchar(10) NULL,
	Nivel6 nvarchar(10) NULL,
	Nivel7 nvarchar(10) NULL,
	NumNiveles tinyint NOT NULL,
	TotDet nvarchar(1) NOT NULL,
	ActSusp nvarchar(1) NOT NULL,
	Estructura int NULL,
	CuentaEditada nvarchar(30) NOT NULL,
	Modelo nvarchar(30) NULL,
	Grupo int NOT NULL,
	NivelAgrupacion nvarchar(20) NULL,
	GrupoNivelAgrupacion int NULL,
	PresupuestarFlag bit NULL,
	UltMod datetime2(7) NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_CuentasContables SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_CuentasContables ON
GO
IF EXISTS(SELECT * FROM dbo.CuentasContables)
	 EXEC('INSERT INTO dbo.Tmp_CuentasContables (ID, Cuenta, Descripcion, Nivel1, Nivel2, Nivel3, Nivel4, Nivel5, Nivel6, Nivel7, NumNiveles, TotDet, ActSusp, Estructura, CuentaEditada, Modelo, Grupo, NivelAgrupacion, GrupoNivelAgrupacion, PresupuestarFlag, Cia)
		SELECT ID, Cuenta, Descripcion, Nivel1, Nivel2, Nivel3, Nivel4, Nivel5, Nivel6, Nivel7, NumNiveles, TotDet, ActSusp, Estructura, CuentaEditada, Modelo, Grupo, NivelAgrupacion, GrupoNivelAgrupacion, PresupuestarFlag, Cia FROM dbo.CuentasContables WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_CuentasContables OFF
GO
ALTER TABLE dbo.Presupuesto_AsociacionCodigosCuentas
	DROP CONSTRAINT FK_Presupuesto_AsociacionCodigosCuentas_CuentasContables1
GO
ALTER TABLE dbo.ConciliacionesBancarias
	DROP CONSTRAINT FK_ConciliacionesBancarias_CuentasContables
GO
ALTER TABLE dbo.CajaChica_Parametros
	DROP CONSTRAINT FK_CajaChica_Parametros_CuentasContables
GO
ALTER TABLE dbo.AnalisisContable_CuentasContables
	DROP CONSTRAINT FK_AnalisisContable_CuentasContables_CuentasContables
GO
ALTER TABLE dbo.CajaChica_RubrosCuentasContables
	DROP CONSTRAINT FK_CajaChica_RubrosCuentasContables_CuentasContables1
GO
ALTER TABLE dbo.CuentasBancariasCuentasContables
	DROP CONSTRAINT FK_CuentasBancariasCuentasContables_CuentasContables
GO
ALTER TABLE dbo.CuentasBancariasCuentasContables
	DROP CONSTRAINT FK_CuentasBancariasCuentasContables_CuentasContables1
GO
ALTER TABLE dbo.CuentasBancariasCuentasContables
	DROP CONSTRAINT FK_CuentasBancariasCuentasContables_CuentasContables2
GO
ALTER TABLE dbo.CuentasBancariasCuentasContables
	DROP CONSTRAINT FK_CuentasBancariasCuentasContables_CuentasContables3
GO
ALTER TABLE dbo.Contab_BalanceComprobacion
	DROP CONSTRAINT FK_Contab_BalanceComprobacion_CuentasContables
GO
ALTER TABLE dbo.dAsientos
	DROP CONSTRAINT FK_dAsientos_CuentasContables1
GO
ALTER TABLE dbo.tCuentasContablesPorEmpleadoYRubro
	DROP CONSTRAINT FK_tCuentasContablesPorEmpleadoYRubro_CuentasContables
GO
ALTER TABLE dbo.DefinicionCuentasContables
	DROP CONSTRAINT FK_DefinicionCuentasContables_CuentasContables
GO
ALTER TABLE dbo.CuentasBancarias
	DROP CONSTRAINT FK_CuentasBancarias_CuentasContables
GO
ALTER TABLE dbo.CuentasBancarias
	DROP CONSTRAINT FK_CuentasBancarias_CuentasContables1
GO
ALTER TABLE dbo.Presupuesto
	DROP CONSTRAINT FK_Presupuesto_CuentasContables1
GO
ALTER TABLE dbo.Contab_ConsultaCuentasYMovimientos
	DROP CONSTRAINT FK_Contab_ConsultaCuentasYMovimientos_CuentasContables
GO
ALTER TABLE dbo.ParametrosNomina
	DROP CONSTRAINT FK_ParametrosNomina_CuentasContables
GO
ALTER TABLE dbo.Temp_Contab_Report_BalanceGeneral
	DROP CONSTRAINT FK_Temp_Contab_Report_BalanceGeneral_CuentasContables
GO
ALTER TABLE dbo.SaldosContables
	DROP CONSTRAINT FK_SaldosContables_CuentasContables1
GO
DROP TABLE dbo.CuentasContables
GO
EXECUTE sp_rename N'dbo.Tmp_CuentasContables', N'CuentasContables', 'OBJECT' 
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
	FK_CuentasContables_tGruposContables1 FOREIGN KEY
	(
	GrupoNivelAgrupacion
	) REFERENCES dbo.tGruposContables
	(
	Grupo
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
	FK_CuentasContables_NivelesAgrupacionContable FOREIGN KEY
	(
	NivelAgrupacion
	) REFERENCES dbo.NivelesAgrupacionContable
	(
	NivelAgrupacion
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
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
ALTER TABLE dbo.Temp_Contab_Report_BalanceGeneral ADD CONSTRAINT
	FK_Temp_Contab_Report_BalanceGeneral_CuentasContables FOREIGN KEY
	(
	CuentaContableID
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Temp_Contab_Report_BalanceGeneral SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.ParametrosNomina ADD CONSTRAINT
	FK_ParametrosNomina_CuentasContables FOREIGN KEY
	(
	CuentaContableNomina
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  SET NULL 
	 ON DELETE  SET NULL 
	
GO
ALTER TABLE dbo.ParametrosNomina SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Contab_ConsultaCuentasYMovimientos ADD CONSTRAINT
	FK_Contab_ConsultaCuentasYMovimientos_CuentasContables FOREIGN KEY
	(
	CuentaContableID
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Contab_ConsultaCuentasYMovimientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Presupuesto ADD CONSTRAINT
	FK_Presupuesto_CuentasContables1 FOREIGN KEY
	(
	CuentaContableID
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Presupuesto SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
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
ALTER TABLE dbo.CuentasBancarias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.DefinicionCuentasContables ADD CONSTRAINT
	FK_DefinicionCuentasContables_CuentasContables FOREIGN KEY
	(
	CuentaContableID
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.DefinicionCuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tCuentasContablesPorEmpleadoYRubro ADD CONSTRAINT
	FK_tCuentasContablesPorEmpleadoYRubro_CuentasContables FOREIGN KEY
	(
	CuentaContable
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.tCuentasContablesPorEmpleadoYRubro SET (LOCK_ESCALATION = TABLE)
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
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Contab_BalanceComprobacion ADD CONSTRAINT
	FK_Contab_BalanceComprobacion_CuentasContables FOREIGN KEY
	(
	CuentaContableID
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Contab_BalanceComprobacion SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasBancariasCuentasContables ADD CONSTRAINT
	FK_CuentasBancariasCuentasContables_CuentasContables FOREIGN KEY
	(
	CuentaContableComision
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CuentasBancariasCuentasContables ADD CONSTRAINT
	FK_CuentasBancariasCuentasContables_CuentasContables1 FOREIGN KEY
	(
	CuentaContableComision2
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CuentasBancariasCuentasContables ADD CONSTRAINT
	FK_CuentasBancariasCuentasContables_CuentasContables2 FOREIGN KEY
	(
	CuentaContableImpuestos
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CuentasBancariasCuentasContables ADD CONSTRAINT
	FK_CuentasBancariasCuentasContables_CuentasContables3 FOREIGN KEY
	(
	CuentaContableCxC
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CuentasBancariasCuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CajaChica_RubrosCuentasContables ADD CONSTRAINT
	FK_CajaChica_RubrosCuentasContables_CuentasContables1 FOREIGN KEY
	(
	CuentaContableID
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.CajaChica_RubrosCuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.AnalisisContable_CuentasContables ADD CONSTRAINT
	FK_AnalisisContable_CuentasContables_CuentasContables FOREIGN KEY
	(
	CuentaContable_ID
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.AnalisisContable_CuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CajaChica_Parametros ADD CONSTRAINT
	FK_CajaChica_Parametros_CuentasContables FOREIGN KEY
	(
	CuentaContablePuenteID
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CajaChica_Parametros SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
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
ALTER TABLE dbo.ConciliacionesBancarias SET (LOCK_ESCALATION = TABLE)
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


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.453', GetDate()) 