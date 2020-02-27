/*    Viernes, 4 de Octubre de 2.013 	-   v0.00.358.sql 

	Agregamos el item Periodicidad a la tabla de deducciones ISLR 
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
ALTER TABLE dbo.DeduccionesISLR
	DROP CONSTRAINT FK_DeduccionesISLR_tEmpleados
GO
ALTER TABLE dbo.tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.DeduccionesISLR
	DROP CONSTRAINT FK_DeduccionesISLR_tGruposEmpleados
GO
ALTER TABLE dbo.tGruposEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.DeduccionesISLR
	DROP CONSTRAINT FK_DeduccionesISLR_tMaestraRubros
GO
ALTER TABLE dbo.tMaestraRubros SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_DeduccionesISLR
	(
	ID int NOT NULL IDENTITY (1, 1),
	Rubro int NOT NULL,
	GrupoNomina int NULL,
	Empleado int NULL,
	Desde date NOT NULL,
	TipoNomina nvarchar(10) NOT NULL,
	Periodicidad nvarchar(2) NULL,
	Porcentaje decimal(9, 6) NOT NULL,
	Base nvarchar(10) NOT NULL,
	SuspendidoFlag bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_DeduccionesISLR SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_DeduccionesISLR ON
GO
IF EXISTS(SELECT * FROM dbo.DeduccionesISLR)
	 EXEC('INSERT INTO dbo.Tmp_DeduccionesISLR (ID, Rubro, GrupoNomina, Empleado, Desde, TipoNomina, Porcentaje, Base, SuspendidoFlag)
		SELECT ID, Rubro, GrupoNomina, Empleado, Desde, TipoNomina, Porcentaje, Base, SuspendidoFlag FROM dbo.DeduccionesISLR WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_DeduccionesISLR OFF
GO
DROP TABLE dbo.DeduccionesISLR
GO
EXECUTE sp_rename N'dbo.Tmp_DeduccionesISLR', N'DeduccionesISLR', 'OBJECT' 
GO
ALTER TABLE dbo.DeduccionesISLR ADD CONSTRAINT
	PK_DeduccionesISLR PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.DeduccionesISLR ADD CONSTRAINT
	FK_DeduccionesISLR_tMaestraRubros FOREIGN KEY
	(
	Rubro
	) REFERENCES dbo.tMaestraRubros
	(
	Rubro
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.DeduccionesISLR ADD CONSTRAINT
	FK_DeduccionesISLR_tGruposEmpleados FOREIGN KEY
	(
	GrupoNomina
	) REFERENCES dbo.tGruposEmpleados
	(
	Grupo
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.DeduccionesISLR ADD CONSTRAINT
	FK_DeduccionesISLR_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.358', GetDate()) 
