/*    Viernes, 23 de Enero de 2.009  -   v0.00.235.sql 

	Agregamos items (2) a la tabla Companias para registrar los datos del 
	Email server 

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
ALTER TABLE dbo.Companias ADD
	EmailServerCredentialsUserName nvarchar(100) NULL,
	EmailServerCredentialsPassword nvarchar(50) NULL
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion(VersionActual, Fecha) Values('v0.00.235', GetDate()) 