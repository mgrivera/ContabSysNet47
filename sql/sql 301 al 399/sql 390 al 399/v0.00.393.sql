/*    
	  Viernes, 24/Feb/2.017   -   v0.00.393.sql 

	  Agregamos las columnas FechaPago y DescripcionRubroSueldo a la tabla tNominaHeaders
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
ALTER TABLE dbo.tNominaHeaders
	DROP CONSTRAINT FK_tNominaHeaders_tGruposEmpleados
GO
ALTER TABLE dbo.tGruposEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tNominaHeaders
	DROP CONSTRAINT FK_tNominaHeaders_Asientos
GO
ALTER TABLE dbo.Asientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tNominaHeaders
	(
	ID int NOT NULL IDENTITY (1, 1),
	FechaNomina date NOT NULL,
	FechaEjecucion datetime2(7) NOT NULL,
	GrupoNomina int NOT NULL,
	Desde date NULL,
	Hasta date NULL,
	FechaPago date NULL,
	DescripcionRubroSueldo nvarchar(250) NULL,
	CantidadDias smallint NULL,
	Tipo nvarchar(2) NOT NULL,
	AgregarSueldo bit NOT NULL,
	AgregarDeduccionesObligatorias bit NOT NULL,
	ProvieneDe nvarchar(50) NULL,
	ProvieneDe_ID int NULL,
	AsientoContableID int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tNominaHeaders SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tNominaHeaders ON
GO
IF EXISTS(SELECT * FROM dbo.tNominaHeaders)
	 EXEC('INSERT INTO dbo.Tmp_tNominaHeaders (ID, FechaNomina, FechaEjecucion, GrupoNomina, Desde, Hasta, CantidadDias, Tipo, AgregarSueldo, AgregarDeduccionesObligatorias, ProvieneDe, ProvieneDe_ID, AsientoContableID)
		SELECT ID, FechaNomina, FechaEjecucion, GrupoNomina, Desde, Hasta, CantidadDias, Tipo, AgregarSueldo, AgregarDeduccionesObligatorias, ProvieneDe, ProvieneDe_ID, AsientoContableID FROM dbo.tNominaHeaders WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tNominaHeaders OFF
GO
ALTER TABLE dbo.tNomina_SalarioIntegral
	DROP CONSTRAINT FK_tNomina_SalarioIntegral_tNominaHeaders
GO
ALTER TABLE dbo.tNomina
	DROP CONSTRAINT FK_tNomina_tNominaHeaders
GO
DROP TABLE dbo.tNominaHeaders
GO
EXECUTE sp_rename N'dbo.Tmp_tNominaHeaders', N'tNominaHeaders', 'OBJECT' 
GO
ALTER TABLE dbo.tNominaHeaders ADD CONSTRAINT
	PK_tNominaHeaders PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tNominaHeaders ADD CONSTRAINT
	FK_tNominaHeaders_Asientos FOREIGN KEY
	(
	AsientoContableID
	) REFERENCES dbo.Asientos
	(
	NumeroAutomatico
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tNominaHeaders ADD CONSTRAINT
	FK_tNominaHeaders_tGruposEmpleados FOREIGN KEY
	(
	GrupoNomina
	) REFERENCES dbo.tGruposEmpleados
	(
	Grupo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tNomina ADD CONSTRAINT
	FK_tNomina_tNominaHeaders FOREIGN KEY
	(
	HeaderID
	) REFERENCES dbo.tNominaHeaders
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.tNomina SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tNomina_SalarioIntegral ADD CONSTRAINT
	FK_tNomina_SalarioIntegral_tNominaHeaders FOREIGN KEY
	(
	HeaderID
	) REFERENCES dbo.tNominaHeaders
	(
	ID
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.tNomina_SalarioIntegral SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.393', GetDate()) 
