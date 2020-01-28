/*    
	  Jueves, 15/Jun/2.017   -   v0.00.397.sql 
	  Agregamos cascade delete a relaciones entre algunas tablas en la base de datos 
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
ALTER TABLE dbo.DefinicionCuentasContables
	DROP CONSTRAINT FK_DefinicionCuentasContables_Proveedores
GO
ALTER TABLE dbo.SaldosCompanias
	DROP CONSTRAINT FK_SaldosCompanias_Proveedores
GO
ALTER TABLE dbo.Proveedores SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.SaldosCompanias WITH NOCHECK ADD CONSTRAINT
	FK_SaldosCompanias_Proveedores FOREIGN KEY
	(
	Compania
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.SaldosCompanias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.DefinicionCuentasContables ADD CONSTRAINT
	FK_DefinicionCuentasContables_Proveedores FOREIGN KEY
	(
	Compania
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.DefinicionCuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.397', GetDate()) 
