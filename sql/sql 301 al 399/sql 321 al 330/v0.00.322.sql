/*    Sábado, 10 de Noviembre de 2.012  -   v0.00.322.sql 

	Cuentas Contables: ahora el grupo es requerido ... 
*/

/* NOTA: este script fallará si el siguiente Select regresa registros ... 

	Select * from CuentasContables Where Grupo Is Null 
	
	Select * from CuentasContables Where Nivel1 Is Null 
	Select * from CuentasContables Where Descripcion Is Null 
	Select * from CuentasContables Where NumNiveles Is Null 
	Select * from CuentasContables Where TotDet Is Null 
	Select * from CuentasContables Where ActSusp Is Null 
	Select * from CuentasContables Where CuentaEditada Is Null 
	
	Select * From CuentasContables Where 
	LTRIM(RTrim(Cuenta)) = ''
	
	Intetar eliminar las cuentas obtenidas con el Select anterior (hay muchas relaciones que 
	impedirían que este delete funcione si hay tablas relacionadas ...) 
	
	Delete From CuentasContables Where 
	LTRIM(RTrim(Cuenta)) = ''
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
CREATE TABLE dbo.Tmp_CuentasContables
	(
	ID int NOT NULL IDENTITY (1, 1),
	Cuenta nvarchar(25) NOT NULL,
	Descripcion nvarchar(40) Not NULL,
	Nivel1 nvarchar(10) Not NULL,
	Nivel2 nvarchar(10) NULL,
	Nivel3 nvarchar(10) NULL,
	Nivel4 nvarchar(10) NULL,
	Nivel5 nvarchar(10) NULL,
	Nivel6 nvarchar(10) NULL,
	Nivel7 nvarchar(10) NULL,
	NumNiveles tinyint Not NULL,
	TotDet nvarchar(1) Not NULL,
	ActSusp nvarchar(1) Not NULL,
	Estructura int NULL,
	CuentaEditada nvarchar(30) Not NULL,
	Modelo nvarchar(30) NULL,
	Grupo int NOT NULL,
	NivelAgrupacion nvarchar(20) NULL,
	GrupoNivelAgrupacion int NULL,
	PresupuestarFlag bit NULL,
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
ALTER TABLE dbo.AnalisisContable_CuentasContables
	DROP CONSTRAINT FK_AnalisisContable_CuentasContables_CuentasContables
GO
ALTER TABLE dbo.CajaChica_Parametros
	DROP CONSTRAINT FK_CajaChica_Parametros_CuentasContables
GO
ALTER TABLE dbo.SaldosContables
	DROP CONSTRAINT FK_SaldosContables_CuentasContables1
GO
ALTER TABLE dbo.Presupuesto
	DROP CONSTRAINT FK_Presupuesto_CuentasContables1
GO
ALTER TABLE dbo.Presupuesto_AsociacionCodigosCuentas
	DROP CONSTRAINT FK_Presupuesto_AsociacionCodigosCuentas_CuentasContables1
GO
ALTER TABLE dbo.dAsientos
	DROP CONSTRAINT FK_dAsientos_CuentasContables1
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
ALTER TABLE dbo.CajaChica_RubrosCuentasContables
	DROP CONSTRAINT FK_CajaChica_RubrosCuentasContables_CuentasContables1
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
	FK_CuentasContables_tGruposContables1 FOREIGN KEY
	(
	GrupoNivelAgrupacion
	) REFERENCES dbo.tGruposContables
	(
	Grupo
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
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CajaChica_RubrosCuentasContables SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.Presupuesto_AsociacionCodigosCuentas SET (LOCK_ESCALATION = TABLE)
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
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Presupuesto SET (LOCK_ESCALATION = TABLE)
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
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.SaldosContables SET (LOCK_ESCALATION = TABLE)
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



/* aprovechamos para corregir un leve error en Tipos de Asiento y sus Asientos asociados ... */ 
Update TiposDeAsiento 
Set Tipo = LTRIM(RTrim(Tipo)) 



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.322', GetDate()) 