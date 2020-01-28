/*    Viernes, 2 de Agosto de 2.013 	-   v0.00.352d.sql 

	Cambios a la tabla tNomina 

	Importantísimo: este script fallará si el siguiente Select regresa registros 
	
	Select h.FechaNomina, h.FechaEjecucion, n.* From tNomina n Inner Join tNominaHeaders h On n.HeaderID = h.ID 
	Where n.Rubro Not In (Select Rubro From tMaestraRubros) 
	Order By h.FechaNomina
	
	Nota: si existen y son rubros muy viejos (en Risk son del 99 al 2000 (!!!), eliminarlos !! 
	
	Delete From tNomina
	Where Rubro Not In (Select Rubro From tMaestraRubros) 

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
ALTER TABLE dbo.tGruposEmpleados
	DROP CONSTRAINT FK_tGruposEmpleados_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tGruposEmpleados
	(
	Grupo int NOT NULL IDENTITY (1, 1),
	NombreGrupo nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Descripcion nvarchar(250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	GrupoNominaFlag bit NOT NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tGruposEmpleados SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tGruposEmpleados ON
GO
IF EXISTS(SELECT * FROM dbo.tGruposEmpleados)
	 EXEC('INSERT INTO dbo.Tmp_tGruposEmpleados (Grupo, NombreGrupo, Descripcion, GrupoNominaFlag, Cia)
		SELECT Grupo, NombreGrupo, CONVERT(nvarchar(250), Descripcion), GrupoNominaFlag, Cia FROM dbo.tGruposEmpleados WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tGruposEmpleados OFF
GO
ALTER TABLE dbo.tNominaHeaders
	DROP CONSTRAINT FK_tNominaHeaders_tGruposEmpleados
GO
ALTER TABLE dbo.tdGruposEmpleados
	DROP CONSTRAINT FK_tdGruposEmpleados_tGruposEmpleados1
GO
ALTER TABLE dbo.DeduccionesNomina
	DROP CONSTRAINT FK_DeduccionesNomina_tGruposEmpleados
GO
ALTER TABLE dbo.DeduccionesNomina
	DROP CONSTRAINT FK_DeduccionesNomina_tGruposEmpleados1
GO
ALTER TABLE dbo.Vacaciones
	DROP CONSTRAINT FK_Vacaciones_tGruposEmpleados
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
ALTER TABLE dbo.Vacaciones ADD CONSTRAINT
	FK_Vacaciones_tGruposEmpleados FOREIGN KEY
	(
	GrupoNomina
	) REFERENCES dbo.tGruposEmpleados
	(
	Grupo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Vacaciones SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.DeduccionesNomina ADD CONSTRAINT
	FK_DeduccionesNomina_tGruposEmpleados FOREIGN KEY
	(
	GrupoNomina
	) REFERENCES dbo.tGruposEmpleados
	(
	Grupo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.DeduccionesNomina ADD CONSTRAINT
	FK_DeduccionesNomina_tGruposEmpleados1 FOREIGN KEY
	(
	GrupoEmpleados
	) REFERENCES dbo.tGruposEmpleados
	(
	Grupo
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.DeduccionesNomina SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
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
ALTER TABLE dbo.tdGruposEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
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
ALTER TABLE dbo.tNominaHeaders SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.352d', GetDate()) 
