/*    Lunes, 16 de Julio de 2.012  -   v0.00.315.sql 

	Agregamos la tabla SueldoAumentado_Definición (nómina) 
	a la base de datos 


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
ALTER TABLE dbo.tMaestraRubros SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.SueldoAumentado_Definicion
	(
	ID int NOT NULL IDENTITY (1, 1),
	Cia int NOT NULL,
	Generico bit NOT NULL,
	Empleado int NULL,
	UsarSueldoMaestra bit NOT NULL,
	Monto money NULL,
	Monto_Agregar bit NOT NULL,
	Suspendido bit NOT NULL,
	Desde date NOT NULL,
	Hasta date NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.SueldoAumentado_Definicion ADD CONSTRAINT
	PK_SueldoAumentado_Definicion PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.SueldoAumentado_Definicion ADD CONSTRAINT
	FK_SueldoAumentado_Definicion_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.SueldoAumentado_Definicion ADD CONSTRAINT
	FK_SueldoAumentado_Definicion_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.SueldoAumentado_Definicion SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.SueldoAumentado_Definicion_Rubros
	(
	ID int NOT NULL IDENTITY (1, 1),
	SueldoAumentado_Definicion_ID int NOT NULL,
	Rubro int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.SueldoAumentado_Definicion_Rubros ADD CONSTRAINT
	PK_SueldoAumentado_Definicion_Rubros PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.SueldoAumentado_Definicion_Rubros ADD CONSTRAINT
	FK_SueldoAumentado_Definicion_Rubros_tMaestraRubros FOREIGN KEY
	(
	Rubro
	) REFERENCES dbo.tMaestraRubros
	(
	Rubro
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.SueldoAumentado_Definicion_Rubros ADD CONSTRAINT
	FK_SueldoAumentado_Definicion_Rubros_SueldoAumentado_Definicion FOREIGN KEY
	(
	SueldoAumentado_Definicion_ID
	) REFERENCES dbo.SueldoAumentado_Definicion
	(
	ID
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.SueldoAumentado_Definicion_Rubros SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


/* agregamos relaciones a la tabla PrestacionesSociales */ 

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
ALTER TABLE dbo.tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
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
ALTER TABLE dbo.PrestacionesSociales SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.315', GetDate()) 