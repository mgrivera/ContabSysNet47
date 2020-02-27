/*    Martes, 23 de Junio de 2.009  -   v0.00.251.sql 

	Eliminamos el item Fecha a la tabla de Gastos en el 
	Control de Caja Chica 

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
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos
	DROP COLUMN Fecha
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.251', GetDate()) 