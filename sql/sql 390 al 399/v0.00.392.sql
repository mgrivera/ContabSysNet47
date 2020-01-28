/*    
	  Lunes, 20/Feb/2.017   -   v0.00.392.sql 

	  Días feriados (en nómina): agregamos tipo para diferenciar: FERiados / BANCarios 
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
ALTER TABLE dbo.DiasFiestaNacional ADD
	Tipo nvarchar(4) NULL
GO
ALTER TABLE dbo.DiasFiestaNacional SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

Update DiasFiestaNacional Set Tipo = 'FER' 

ALTER TABLE DiasFiestaNacional Alter Column Tipo nvarchar(4) Not Null 


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.392', GetDate()) 
