/*    Sábado, 6 Julio de 2.013 	-   v0.00.345a.sql 

	Grupos de nómina (de empleados): hacemos cambios para normalizar, agregar	
	relaciones, etc. 
	
	Nota IMPORTANTE: tenemos que editar la tabla de grupos de nómina (tGruposEmpleados) y 
	asignar IDs diferentes a cada uno: 
	
	1) ejecutar este script para que la relación entre GruposEmpleados y tNomina se cascade update; 
	2) luego hacer los cambios en tGruposEmpleados y luego continuar con el siguiente script ... 
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
	DROP CONSTRAINT FK_tNomina_tGruposEmpleados
GO
ALTER TABLE dbo.tGruposEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tNomina WITH NOCHECK ADD CONSTRAINT
	FK_tNomina_tGruposEmpleados FOREIGN KEY
	(
	GrupoNomina,
	Cia
	) REFERENCES dbo.tGruposEmpleados
	(
	Grupo,
	Cia
	) ON UPDATE  CASCADE 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tNomina SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tdGruposEmpleados ADD CONSTRAINT
	FK_tdGruposEmpleados_tGruposEmpleados FOREIGN KEY
	(
	Grupo,
	Cia
	) REFERENCES dbo.tGruposEmpleados
	(
	Grupo,
	Cia
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE
	
GO
ALTER TABLE dbo.tdGruposEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.345a', GetDate()) 