/*    Lunes, 13 de Enero de 2.013 	-   v0.00.366.sql 

	Nómina: cambios a la tabla de Faltas 
	
	Nota: revisar antes si hay faltas registradas; deben ser preservadas ... 
	(Select * From Empleados_Faltas)
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
ALTER TABLE dbo.Empleados_Faltas
	DROP CONSTRAINT FK_Empleados_Faltas_tEmpleados
GO
ALTER TABLE dbo.tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tGruposEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Empleados_Faltas
	(
	ID int NOT NULL IDENTITY (1, 1),
	Empleado int NOT NULL,
	Desde date NOT NULL,
	Hasta date NOT NULL,
	CantDias smallint NOT NULL,
	CantDiasSabDom smallint NULL,
	CantDiasFeriados smallint NULL,
	CantDiasHabiles smallint NULL,
	CantHoras smallint NULL,
	Descontar bit NOT NULL,
	Descontar_FechaNomina date NULL,
	Descontar_GrupoNomina int NULL,
	Base nvarchar(10) NULL,
	Observaciones text NULL,
	DescripcionRubroNomina nvarchar(250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Empleados_Faltas SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Empleados_Faltas ON
GO
IF EXISTS(SELECT * FROM dbo.Empleados_Faltas)
	 EXEC('INSERT INTO dbo.Tmp_Empleados_Faltas (ID, Empleado, Desde, Hasta, CantDias, Descontar, Observaciones, DescripcionRubroNomina)
		SELECT ID, Empleado, Desde, Hasta, CantDias, Descontar, Observaciones, DescripcionRubroNomina FROM dbo.Empleados_Faltas WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Empleados_Faltas OFF
GO
DROP TABLE dbo.Empleados_Faltas
GO
EXECUTE sp_rename N'dbo.Tmp_Empleados_Faltas', N'Empleados_Faltas', 'OBJECT' 
GO
ALTER TABLE dbo.Empleados_Faltas ADD CONSTRAINT
	PK_Empleados_Faltas PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Empleados_Faltas ADD CONSTRAINT
	FK_Empleados_Faltas_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Empleados_Faltas ADD CONSTRAINT
	FK_Empleados_Faltas_tGruposEmpleados FOREIGN KEY
	(
	Descontar_GrupoNomina
	) REFERENCES dbo.tGruposEmpleados
	(
	Grupo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT


Update Empleados_Faltas Set CantDiasSabDom = 0, CantDiasFeriados = 0, CantDiasHabiles = 0
	
	
Alter Table Empleados_Faltas Alter Column CantDiasSabDom smallint NOT NULL
Alter Table Empleados_Faltas Alter Column CantDiasFeriados smallint NOT NULL
Alter Table Empleados_Faltas Alter Column CantDiasHabiles smallint NOT NULL



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
ALTER TABLE dbo.tNominaHeaders SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.tNomina_SalarioIntegral
	(
	ID int NOT NULL IDENTITY (1, 1),
	HeaderID int NOT NULL,
	Empleado int NOT NULL,
	SueldoBasico_Mensual money NOT NULL,
	SueldoBasico_Diario money NOT NULL,
	BonoVacacional_Dias smallint NOT NULL,
	BonoVacacional_Monto money NOT NULL,
	BonoVacacional_Diario money NOT NULL,
	Utilidades_Dias smallint NOT NULL,
	Utilidades_Monto money NOT NULL,
	Utilidades_Diario money NOT NULL,
	SalarioIntegral_Diario money NOT NULL,
	SalarioIntegral_Monto money NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.tNomina_SalarioIntegral ADD CONSTRAINT
	PK_tNomina_SalarioIntegral PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

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
ALTER TABLE dbo.tNomina_SalarioIntegral ADD CONSTRAINT
	FK_tNomina_SalarioIntegral_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
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
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.366', GetDate()) 
