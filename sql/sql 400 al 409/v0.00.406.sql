/*    
	  Jueves, 7/Jun/2.018   -   v0.00.406.sql 
	  
	  Agregamos la columna AplicaSustraendo a la tabla CategoriasRetencion
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
ALTER TABLE dbo.CategoriasRetencion ADD
	AplicaSustraendo bit NULL
GO
ALTER TABLE dbo.CategoriasRetencion SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.406', GetDate()) 
