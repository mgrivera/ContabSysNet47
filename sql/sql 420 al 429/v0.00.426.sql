/*    
	  Martes, 15 de Septiembre de 2.020  -   v0.00.426.sql 
	  
	  Agregamos la columna PorcentajeITF a la tabla ParametrosGlobalBancos
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
ALTER TABLE dbo.ParametrosGlobalBancos ADD
	PorcentajeITF decimal(5, 2) NULL
GO
ALTER TABLE dbo.ParametrosGlobalBancos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.426', GetDate()) 