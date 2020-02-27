/*    Lunes, 25 de Junio de 2.013 	-   v0.00.342.sql 

	Cambios leves a la tabla VacacPorAnoParticulares 

	Nota: este query no debe seleccionar registros ... 

	Select * From VacacPorAnoParticulares Where Empleado Not In (Select Empleado From tEmpleados) 
	
	Elminarlos si existen 
	
	Delete From VacacPorAnoParticulares Where Empleado Not In (Select Empleado From tEmpleados) 
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
ALTER TABLE dbo.tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.VacacPorAnoParticulares ADD CONSTRAINT
	FK_VacacPorAnoParticulares_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.VacacPorAnoParticulares SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.342', GetDate()) 