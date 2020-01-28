/*    
	  Martes, 20 de Enero de 2.020  -   v0.00.423.sql 
	  
	  Agregamos la columna Convertir a la tabla Monedas  
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
ALTER TABLE dbo.Monedas ADD
	Convertir bit NULL
GO
ALTER TABLE dbo.Monedas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

Update Monedas Set Convertir = 1 

ALTER TABLE dbo.Monedas Alter Column Convertir bit Not NULL

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.423', GetDate()) 


