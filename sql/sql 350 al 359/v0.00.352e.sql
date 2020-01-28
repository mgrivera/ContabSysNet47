/*    Lunes, 5 de Agosto de 2.013 	-   v0.00.352e.sql 

	Cambios a la tabla tNomina
	Agregamos el item SalarioFlag a tNomina y eliminamos el item Sueldo de la tabla de Empleados 
	
	Nota: este script fallará si el siguiente Select regresa algún item: 
	Select * From tNomina Where HeaderID Is Null 
	
	Nota: este script fallará si el siguiente Select regresa algún item: 
	Select * From tRubrosAsignados Where Periodicidad Is Null 
	
	corregirlo así: Update tRubrosAsignados Set Periodicidad = 'S' Where Periodicidad Is Null 
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
	DROP CONSTRAINT FK_tNomina_tMaestraRubros
GO
ALTER TABLE dbo.tMaestraRubros SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tNomina
	DROP CONSTRAINT FK_tNomina_tNominaHeaders
GO
ALTER TABLE dbo.tNominaHeaders SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tNomina
	DROP CONSTRAINT FK_tNomina_tEmpleados
GO
ALTER TABLE dbo.tEmpleados
	DROP COLUMN SueldoPromedio, SueldoBasico
GO
ALTER TABLE dbo.tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tNomina
	(
	NumeroUnico int NOT NULL IDENTITY (1, 1),
	HeaderID int NULL,
	Empleado int NOT NULL,
	Rubro int NOT NULL,
	Tipo nvarchar(1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Descripcion nvarchar(250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Monto money NOT NULL,
	AplicaPrestacionesFlag bit NULL,
	MostrarEnElReciboFlag bit NULL,
	MontoBase money NULL,
	CantDias tinyint NULL,
	SalarioFlag bit NULL,
	VacFraccionFlag char(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	FraccionarFlag bit NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tNomina SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tNomina ON
GO
IF EXISTS(SELECT * FROM dbo.tNomina)
	 EXEC('INSERT INTO dbo.Tmp_tNomina (NumeroUnico, HeaderID, Empleado, Rubro, Tipo, Descripcion, Monto, AplicaPrestacionesFlag, MostrarEnElReciboFlag, MontoBase, CantDias, VacFraccionFlag, FraccionarFlag)
		SELECT NumeroUnico, HeaderID, Empleado, Rubro, Tipo, Descripcion, Monto, AplicaPrestacionesFlag, MostrarEnElReciboFlag, MontoBase, CantDias, VacFraccionFlag, FraccionarFlag FROM dbo.tNomina WITH (HOLDLOCK TABLOCKX)')
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
ALTER TABLE dbo.tNomina ADD CONSTRAINT
	FK_tNomina_tMaestraRubros FOREIGN KEY
	(
	Rubro
	) REFERENCES dbo.tMaestraRubros
	(
	Rubro
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT

Update tNomina Set SalarioFlag = 0 
Alter TABLE tNomina Alter Column SalarioFlag bit Not NULL


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
CREATE TABLE dbo.Tmp_tNominaHeaders
	(
	ID int NOT NULL IDENTITY (1, 1),
	FechaNomina date NOT NULL,
	FechaEjecucion datetime2(7) NOT NULL,
	GrupoNomina int NOT NULL,
	Desde date NULL,
	Hasta date NULL,
	CantidadDias smallint NULL,
	Tipo nvarchar(1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	AgregarSueldo bit NULL,
	AgregarDeduccionesObligatorias bit NULL,
	ProvieneDe nvarchar(50) NULL,
	ProvieneDe_ID int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tNominaHeaders SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tNominaHeaders ON
GO
IF EXISTS(SELECT * FROM dbo.tNominaHeaders)
	 EXEC('INSERT INTO dbo.Tmp_tNominaHeaders (ID, FechaNomina, FechaEjecucion, GrupoNomina, Desde, Hasta, CantidadDias, Tipo, ProvieneDe, ProvieneDe_ID)
		SELECT ID, FechaNomina, FechaEjecucion, GrupoNomina, Desde, Hasta, CantidadDias, Tipo, ProvieneDe, ProvieneDe_ID FROM dbo.tNominaHeaders WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tNominaHeaders OFF
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

Update tNominaHeaders Set AgregarSueldo = 0, AgregarDeduccionesObligatorias = 0 
Alter TABLE tNominaHeaders Alter Column AgregarSueldo bit Not NULL
Alter TABLE tNominaHeaders Alter Column AgregarDeduccionesObligatorias bit Not NULL


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
	DROP CONSTRAINT FK_tNomina_tNominaHeaders
GO
ALTER TABLE dbo.tNominaHeaders SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tNomina
	DROP CONSTRAINT FK_tNomina_tMaestraRubros
GO
ALTER TABLE dbo.tMaestraRubros SET (LOCK_ESCALATION = TABLE)
GO
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
CREATE TABLE dbo.Tmp_tNomina
	(
	NumeroUnico int NOT NULL IDENTITY (1, 1),
	HeaderID int NULL,
	Empleado int NOT NULL,
	Rubro int NOT NULL,
	Tipo nvarchar(1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Descripcion nvarchar(250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Monto money NOT NULL,
	AplicaPrestacionesFlag bit NULL,
	MostrarEnElReciboFlag bit NULL,
	MontoBase money NULL,
	CantDias tinyint NULL,
	SueldoFlag bit NULL,
	SalarioFlag bit NOT NULL,
	VacFraccionFlag char(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	FraccionarFlag bit NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tNomina SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tNomina ON
GO
IF EXISTS(SELECT * FROM dbo.tNomina)
	 EXEC('INSERT INTO dbo.Tmp_tNomina (NumeroUnico, HeaderID, Empleado, Rubro, Tipo, Descripcion, Monto, AplicaPrestacionesFlag, MostrarEnElReciboFlag, MontoBase, CantDias, SalarioFlag, VacFraccionFlag, FraccionarFlag)
		SELECT NumeroUnico, HeaderID, Empleado, Rubro, Tipo, Descripcion, Monto, AplicaPrestacionesFlag, MostrarEnElReciboFlag, MontoBase, CantDias, SalarioFlag, VacFraccionFlag, FraccionarFlag FROM dbo.tNomina WITH (HOLDLOCK TABLOCKX)')
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
ALTER TABLE dbo.tNomina ADD CONSTRAINT
	FK_tNomina_tMaestraRubros FOREIGN KEY
	(
	Rubro
	) REFERENCES dbo.tMaestraRubros
	(
	Rubro
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
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
COMMIT

Update tNomina Set SueldoFlag = 0
Alter TABLE tNomina Alter Column SueldoFlag bit Not NULL


Alter Table tNomina Alter Column HeaderID int Not Null 

-- el item Periodicidad es ahora Not Null en tRubrosAsignados 
Alter Table tRubrosAsignados Alter Column Periodicidad nvarchar(2) NOT NULL


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.352e', GetDate()) 
