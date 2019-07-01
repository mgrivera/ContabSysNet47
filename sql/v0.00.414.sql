/*    
	  Miércoles, 22 de Junio de 2.019  -   v0.00.414.sql 
	  
	  Eliminamos una relación entre las tablas Asientos y tNominaHeaders
	  (tal vez esta relación nunca ha debido existir, realmente) 
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
ALTER TABLE dbo.tNominaHeaders
	DROP CONSTRAINT FK_tNominaHeaders_Asientos
GO
ALTER TABLE dbo.Asientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tNominaHeaders SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.414', GetDate()) 


