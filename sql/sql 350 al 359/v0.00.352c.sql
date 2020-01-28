/*    Martes, 30 de Julio de 2.013 	-   v0.00.352c.sql 

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
BEGIN TRANSACTION
GO
DROP INDEX IX_tNomina ON dbo.tNomina
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
ALTER TABLE dbo.tNomina
	DROP COLUMN GrupoNomina, FechaNomina, FechaEjecucion, TipoNomina, Cia
GO
ALTER TABLE dbo.tNomina SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.352c', GetDate()) 
