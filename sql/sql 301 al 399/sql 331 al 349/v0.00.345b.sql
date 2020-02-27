/*    Lunes, 8 de Julio de 2.013 	-   v0.00.345b.sql 

	Grupos de nómina (de empleados): hacemos cambios para normalizar, agregar	
	relaciones, etc. 
	
	Nota: 
	
	1) el siguiente select no debe traer results ... de hacerlo, creo que podemos 
	eliminar el/los grupos (que se muestren) sin consecuencias antes de iniciar el script 
	(pues no creo que tNomina tenga records para compañías que no existan!) 
	
	Select * From tGruposEmpleados Where Cia Not In (Select Numero From Companias) 
	
	(eliminarlos, si existen, con esta instrucción) 
	Delete From tGruposEmpleados Where Cia Not In (Select Numero From Companias) 
	
	(podríamos revisar tNomina a ver si hay nóminas con ese GrupoNomina (no debería haber 
	ninguna pues, como dijimos arriba, no deben existir nóminas para Cias que no existan 
	en Companias))
	
	2) el siguiente select no debe regresar registros 
	Select * From tNomina Where Cia Not In (Select Numero From Companias) 
	
	3) tampoco éste
	Select * From tdGruposEmpleados Where Empleado Not In (Select Empleado From tEmpleados) 
	(de haber, los podemos eliminar sin problemas, pues es lógico que no existen como empleados ...) 
	Delete From tdGruposEmpleados Where Empleado Not In (Select Empleado From tEmpleados) 
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
DROP TABLE dbo.tGruposEmpleadosId
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tGruposEmpleados
	(
	Grupo int NOT NULL IDENTITY (1, 1),
	NombreGrupo nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Descripcion ntext COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	GrupoNominaFlag bit NOT NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tGruposEmpleados SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tGruposEmpleados ON
GO
IF EXISTS(SELECT * FROM dbo.tGruposEmpleados)
	 EXEC('INSERT INTO dbo.Tmp_tGruposEmpleados (Grupo, NombreGrupo, Descripcion, GrupoNominaFlag, Cia)
		SELECT Grupo, NombreGrupo, Descripcion, GrupoNominaFlag, Cia FROM dbo.tGruposEmpleados WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tGruposEmpleados OFF
GO
ALTER TABLE dbo.tNomina
	DROP CONSTRAINT FK_tNomina_tGruposEmpleados
GO
ALTER TABLE dbo.tdGruposEmpleados
	DROP CONSTRAINT FK_tdGruposEmpleados_tGruposEmpleados
GO
DROP TABLE dbo.tGruposEmpleados
GO
EXECUTE sp_rename N'dbo.Tmp_tGruposEmpleados', N'tGruposEmpleados', 'OBJECT' 
GO
ALTER TABLE dbo.tGruposEmpleados ADD CONSTRAINT
	PK_tGruposEmpleados_1 PRIMARY KEY CLUSTERED 
	(
	Grupo
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tGruposEmpleados ADD CONSTRAINT
	FK_tGruposEmpleados_Companias FOREIGN KEY
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
DROP INDEX IX_tdGruposEmpleados ON dbo.tdGruposEmpleados
GO
ALTER TABLE dbo.tdGruposEmpleados ADD CONSTRAINT
	FK_tdGruposEmpleados_tGruposEmpleados1 FOREIGN KEY
	(
	Grupo
	) REFERENCES dbo.tGruposEmpleados
	(
	Grupo
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO


ALTER TABLE dbo.tdGruposEmpleados ADD CONSTRAINT
	FK_tdGruposEmpleados_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO


ALTER TABLE dbo.tdGruposEmpleados
	DROP COLUMN Cia
GO
ALTER TABLE dbo.tdGruposEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
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
ALTER TABLE dbo.tNomina SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
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
ALTER TABLE dbo.tNomina SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.345b', GetDate()) 