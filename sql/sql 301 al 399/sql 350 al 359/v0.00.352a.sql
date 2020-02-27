/*    Martes, 30 de Julio de 2.013 	-   v0.00.352a.sql 

	Cambios a la tabla tNomina 
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
ALTER TABLE dbo.tNomina
	DROP CONSTRAINT FK_tNomina_tEmpleados
GO
ALTER TABLE dbo.tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tNomina
	DROP CONSTRAINT FK_tNomina_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tNomina
	DROP CONSTRAINT FK_tNomina_tGruposEmpleados1
GO
ALTER TABLE dbo.tGruposEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.tNominaHeaders
	(
	ID int NOT NULL IDENTITY (1, 1),
	FechaNomina date NOT NULL,
	FechaEjecucion datetime2(7) NOT NULL,
	GrupoNomina int NOT NULL,
	Desde date NULL,
	Hasta date NULL,
	CantidadDias smallint NULL,
	Tipo nvarchar(1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	ProvieneDe nvarchar(50) NULL,
	ProvieneDe_ID int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.tNominaHeaders ADD CONSTRAINT
	PK_tNominaHeaders PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tNominaHeaders SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tNomina
	(
	NumeroUnico int NOT NULL IDENTITY (1, 1),
	HeaderID int NULL,
	GrupoNomina int NOT NULL,
	Empleado int NOT NULL,
	FechaNomina smalldatetime NOT NULL,
	Rubro int NOT NULL,
	Tipo nvarchar(1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Descripcion nvarchar(250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Monto money NOT NULL,
	FechaEjecucion datetime NOT NULL,
	AplicaPrestacionesFlag bit NULL,
	TipoNomina nvarchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	MostrarEnElReciboFlag bit NULL,
	MontoBase money NULL,
	CantDias tinyint NULL,
	VacFraccionFlag char(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	FraccionarFlag bit NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tNomina SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tNomina ON
GO
IF EXISTS(SELECT * FROM dbo.tNomina)
	 EXEC('INSERT INTO dbo.Tmp_tNomina (NumeroUnico, GrupoNomina, Empleado, FechaNomina, Rubro, Tipo, Descripcion, Monto, FechaEjecucion, AplicaPrestacionesFlag, TipoNomina, MostrarEnElReciboFlag, MontoBase, CantDias, VacFraccionFlag, FraccionarFlag, Cia)
		SELECT NumeroUnico, GrupoNomina, Empleado, FechaNomina, Rubro, Tipo, Descripcion, Monto, FechaEjecucion, AplicaPrestacionesFlag, TipoNomina, MostrarEnElReciboFlag, MontoBase, CantDias, VacFraccionFlag, FraccionarFlag, Cia FROM dbo.tNomina WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tNomina OFF
GO
DROP TABLE dbo.tNomina
GO
EXECUTE sp_rename N'dbo.Tmp_tNomina', N'tNomina', 'OBJECT' 
GO
ALTER TABLE dbo.tNomina ADD CONSTRAINT
	PK_tNomina PRIMARY KEY NONCLUSTERED 
	(
	NumeroUnico
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_tNomina ON dbo.tNomina
	(
	GrupoNomina,
	Cia
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.tNomina ADD CONSTRAINT
	FK_tNomina_tGruposEmpleados1 FOREIGN KEY
	(
	GrupoNomina
	) REFERENCES dbo.tGruposEmpleados
	(
	Grupo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tNomina ADD CONSTRAINT
	FK_tNomina_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.tNomina ADD CONSTRAINT
	FK_tNomina_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.352a', GetDate()) 