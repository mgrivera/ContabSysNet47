/*    Lunes, 19 de Agosto de 2.013 	-   v0.00.354.sql 

	Hacemos cambios a la tabla PrestacionesSociales
	El objetivo es agregar la tabla ...Headers para 
	pasarla a asp.net (y mejorar todo el proceso) 
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
ALTER TABLE dbo.PrestacionesSociales
	DROP CONSTRAINT FK_PrestacionesSociales_tEmpleados
GO
ALTER TABLE dbo.tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.PrestacionesSociales
	DROP CONSTRAINT FK_PrestacionesSociales_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.PrestacionesSocialesHeaders
	(
	ID int NOT NULL IDENTITY (1, 1),
	Mes smallint NOT NULL,
	Ano smallint NOT NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrestacionesSocialesHeaders ADD CONSTRAINT
	PK_PrestacionesSocialesHeaders PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.PrestacionesSocialesHeaders SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_PrestacionesSociales
	(
	ID int NOT NULL IDENTITY (1, 1),
	HeaderID int NULL,
	Empleado int NOT NULL,
	Mes smallint NOT NULL,
	Ano smallint NOT NULL,
	FechaIngreso smalldatetime NOT NULL,
	AnosServicio smallint NOT NULL,
	AnosServicioPrestaciones smallint NOT NULL,
	PrimerMesPrestacionesFlag bit NOT NULL,
	CantidadDiasTrabajadosPrimerMes tinyint NULL,
	SueldoBasico money NOT NULL,
	SueldoBasicoDiario money NOT NULL,
	DiasVacaciones smallint NOT NULL,
	BonoVacacional money NOT NULL,
	BonoVacacionalDiario money NOT NULL,
	Utilidades money NOT NULL,
	UtilidadesDiarias money NOT NULL,
	SueldoDiarioAumentado money NOT NULL,
	DiasPrestaciones smallint NOT NULL,
	MontoPrestaciones money NOT NULL,
	AnoCumplidoFlag bit NOT NULL,
	CantidadDiasAdicionales tinyint NULL,
	MontoPrestacionesDiasAdicionales money NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_PrestacionesSociales SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_PrestacionesSociales OFF
GO
IF EXISTS(SELECT * FROM dbo.PrestacionesSociales)
	 EXEC('INSERT INTO dbo.Tmp_PrestacionesSociales (Empleado, Mes, Ano, FechaIngreso, AnosServicio, AnosServicioPrestaciones, PrimerMesPrestacionesFlag, CantidadDiasTrabajadosPrimerMes, SueldoBasico, SueldoBasicoDiario, DiasVacaciones, BonoVacacional, BonoVacacionalDiario, Utilidades, UtilidadesDiarias, SueldoDiarioAumentado, DiasPrestaciones, MontoPrestaciones, AnoCumplidoFlag, CantidadDiasAdicionales, MontoPrestacionesDiasAdicionales, Cia)
		SELECT Empleado, Mes, Ano, FechaIngreso, AnosServicio, AnosServicioPrestaciones, PrimerMesPrestacionesFlag, CantidadDiasTrabajadosPrimerMes, SueldoBasico, SueldoBasicoDiario, DiasVacaciones, BonoVacacional, BonoVacacionalDiario, Utilidades, UtilidadesDiarias, SueldoDiarioAumentado, DiasPrestaciones, MontoPrestaciones, AnoCumplidoFlag, CantidadDiasAdicionales, MontoPrestacionesDiasAdicionales, Cia FROM dbo.PrestacionesSociales WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.PrestacionesSociales
GO
EXECUTE sp_rename N'dbo.Tmp_PrestacionesSociales', N'PrestacionesSociales', 'OBJECT' 
GO
ALTER TABLE dbo.PrestacionesSociales ADD CONSTRAINT
	PK_borre1 PRIMARY KEY CLUSTERED 
	(
	Empleado,
	Mes,
	Ano,
	Cia
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.PrestacionesSociales ADD CONSTRAINT
	FK_PrestacionesSociales_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.PrestacionesSociales ADD CONSTRAINT
	FK_PrestacionesSociales_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT

/* para copiar los items desde PrestacionesSociales a PrestacionesSocialesHeaders ... */ 

Insert Into PrestacionesSocialesHeaders (Mes, Ano, Cia) 

Select Distinct Mes, Ano, Cia 
From PrestacionesSociales 
Order by Cia, Ano, Mes 


Update p Set p.HeaderID = h.ID 
From PrestacionesSociales p Inner Join PrestacionesSocialesHeaders h On p.Mes = h.Mes And p.Ano = h.Ano And p.Cia = h.Cia 


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
ALTER TABLE dbo.PrestacionesSociales
	DROP CONSTRAINT FK_PrestacionesSociales_tEmpleados
GO
ALTER TABLE dbo.tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.PrestacionesSociales
	DROP CONSTRAINT FK_PrestacionesSociales_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.PrestacionesSocialesHeaders ADD CONSTRAINT
	FK_PrestacionesSocialesHeaders_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.PrestacionesSocialesHeaders SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_PrestacionesSociales
	(
	ID int NOT NULL IDENTITY (1, 1),
	HeaderID int NOT NULL,
	Empleado int NOT NULL,
	FechaIngreso smalldatetime NOT NULL,
	AnosServicio smallint NOT NULL,
	AnosServicioPrestaciones smallint NOT NULL,
	PrimerMesPrestacionesFlag bit NOT NULL,
	CantidadDiasTrabajadosPrimerMes tinyint NULL,
	SueldoBasico money NOT NULL,
	SueldoBasicoDiario money NOT NULL,
	DiasVacaciones smallint NOT NULL,
	BonoVacacional money NOT NULL,
	BonoVacacionalDiario money NOT NULL,
	Utilidades money NOT NULL,
	UtilidadesDiarias money NOT NULL,
	SueldoDiarioAumentado money NOT NULL,
	DiasPrestaciones smallint NOT NULL,
	MontoPrestaciones money NOT NULL,
	AnoCumplidoFlag bit NOT NULL,
	CantidadDiasAdicionales tinyint NULL,
	MontoPrestacionesDiasAdicionales money NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_PrestacionesSociales SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_PrestacionesSociales ON
GO
IF EXISTS(SELECT * FROM dbo.PrestacionesSociales)
	 EXEC('INSERT INTO dbo.Tmp_PrestacionesSociales (ID, HeaderID, Empleado, FechaIngreso, AnosServicio, AnosServicioPrestaciones, PrimerMesPrestacionesFlag, CantidadDiasTrabajadosPrimerMes, SueldoBasico, SueldoBasicoDiario, DiasVacaciones, BonoVacacional, BonoVacacionalDiario, Utilidades, UtilidadesDiarias, SueldoDiarioAumentado, DiasPrestaciones, MontoPrestaciones, AnoCumplidoFlag, CantidadDiasAdicionales, MontoPrestacionesDiasAdicionales)
		SELECT ID, HeaderID, Empleado, FechaIngreso, AnosServicio, AnosServicioPrestaciones, PrimerMesPrestacionesFlag, CantidadDiasTrabajadosPrimerMes, SueldoBasico, SueldoBasicoDiario, DiasVacaciones, BonoVacacional, BonoVacacionalDiario, Utilidades, UtilidadesDiarias, SueldoDiarioAumentado, DiasPrestaciones, MontoPrestaciones, AnoCumplidoFlag, CantidadDiasAdicionales, MontoPrestacionesDiasAdicionales FROM dbo.PrestacionesSociales WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_PrestacionesSociales OFF
GO
DROP TABLE dbo.PrestacionesSociales
GO
EXECUTE sp_rename N'dbo.Tmp_PrestacionesSociales', N'PrestacionesSociales', 'OBJECT' 
GO
ALTER TABLE dbo.PrestacionesSociales ADD CONSTRAINT
	PK_PrestacionesSociales PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.PrestacionesSociales ADD CONSTRAINT
	FK_PrestacionesSociales_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.PrestacionesSociales ADD CONSTRAINT
	FK_PrestacionesSociales_PrestacionesSocialesHeaders FOREIGN KEY
	(
	HeaderID
	) REFERENCES dbo.PrestacionesSocialesHeaders
	(
	ID
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
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
ALTER TABLE dbo.PrestacionesSocialesHeaders
	DROP CONSTRAINT FK_PrestacionesSocialesHeaders_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_PrestacionesSocialesHeaders
	(
	ID int NOT NULL IDENTITY (1, 1),
	Mes smallint NOT NULL,
	Ano smallint NOT NULL,
	CantDiasUtilidades smallint NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_PrestacionesSocialesHeaders SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_PrestacionesSocialesHeaders ON
GO
IF EXISTS(SELECT * FROM dbo.PrestacionesSocialesHeaders)
	 EXEC('INSERT INTO dbo.Tmp_PrestacionesSocialesHeaders (ID, Mes, Ano, Cia)
		SELECT ID, Mes, Ano, Cia FROM dbo.PrestacionesSocialesHeaders WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_PrestacionesSocialesHeaders OFF
GO
ALTER TABLE dbo.PrestacionesSociales
	DROP CONSTRAINT FK_PrestacionesSociales_PrestacionesSocialesHeaders
GO
DROP TABLE dbo.PrestacionesSocialesHeaders
GO
EXECUTE sp_rename N'dbo.Tmp_PrestacionesSocialesHeaders', N'PrestacionesSocialesHeaders', 'OBJECT' 
GO
ALTER TABLE dbo.PrestacionesSocialesHeaders ADD CONSTRAINT
	PK_PrestacionesSocialesHeaders PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.PrestacionesSocialesHeaders ADD CONSTRAINT
	FK_PrestacionesSocialesHeaders_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.PrestacionesSociales ADD CONSTRAINT
	FK_PrestacionesSociales_PrestacionesSocialesHeaders FOREIGN KEY
	(
	HeaderID
	) REFERENCES dbo.PrestacionesSocialesHeaders
	(
	ID
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.PrestacionesSociales SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


Update PrestacionesSocialesHeaders Set CantDiasUtilidades = 60 
Alter TABLE PrestacionesSocialesHeaders Alter Column CantDiasUtilidades smallint Not NULL




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
ALTER TABLE dbo.PrestacionesSocialesHeaders
	DROP CONSTRAINT FK_PrestacionesSocialesHeaders_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_PrestacionesSocialesHeaders
	(
	ID int NOT NULL IDENTITY (1, 1),
	Desde date NULL,
	Hasta date NULL,
	Mes smallint NOT NULL,
	Ano smallint NOT NULL,
	CantDiasUtilidades smallint NOT NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_PrestacionesSocialesHeaders SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_PrestacionesSocialesHeaders ON
GO
IF EXISTS(SELECT * FROM dbo.PrestacionesSocialesHeaders)
	 EXEC('INSERT INTO dbo.Tmp_PrestacionesSocialesHeaders (ID, Mes, Ano, CantDiasUtilidades, Cia)
		SELECT ID, Mes, Ano, CantDiasUtilidades, Cia FROM dbo.PrestacionesSocialesHeaders WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_PrestacionesSocialesHeaders OFF
GO
ALTER TABLE dbo.PrestacionesSociales
	DROP CONSTRAINT FK_PrestacionesSociales_PrestacionesSocialesHeaders
GO
DROP TABLE dbo.PrestacionesSocialesHeaders
GO
EXECUTE sp_rename N'dbo.Tmp_PrestacionesSocialesHeaders', N'PrestacionesSocialesHeaders', 'OBJECT' 
GO
ALTER TABLE dbo.PrestacionesSocialesHeaders ADD CONSTRAINT
	PK_PrestacionesSocialesHeaders PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.PrestacionesSocialesHeaders ADD CONSTRAINT
	FK_PrestacionesSocialesHeaders_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.PrestacionesSociales ADD CONSTRAINT
	FK_PrestacionesSociales_PrestacionesSocialesHeaders FOREIGN KEY
	(
	HeaderID
	) REFERENCES dbo.PrestacionesSocialesHeaders
	(
	ID
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.PrestacionesSociales SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

	
--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.354', GetDate()) 
