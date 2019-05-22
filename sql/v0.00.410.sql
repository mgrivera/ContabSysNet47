/*    
	  Viernes, 7 de Marzo de 2.019  -   v0.00.410.sql 
	  
	  Agregamos cascade delete entre bancos/agencias/cuentas bancarias/chequeras/mov banc 
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
ALTER TABLE dbo.Agencias
	DROP CONSTRAINT FK_Agencias_Bancos
GO
ALTER TABLE dbo.Bancos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasBancarias
	DROP CONSTRAINT FK_CuentasBancarias_Agencias
GO
ALTER TABLE dbo.Agencias WITH NOCHECK ADD CONSTRAINT
	FK_Agencias_Bancos FOREIGN KEY
	(
	Banco
	) REFERENCES dbo.Bancos
	(
	Banco
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Agencias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasBancarias WITH NOCHECK ADD CONSTRAINT
	FK_CuentasBancarias_Agencias FOREIGN KEY
	(
	Agencia
	) REFERENCES dbo.Agencias
	(
	Agencia
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.CuentasBancarias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.410', GetDate()) 
