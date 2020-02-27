/*    Miércoles, 8 de Mayo de 2.013 	-   v0.00.339.sql 

	Establecemos relaciones entre los movimientos de conciliación bancaria 
	y los movimientos bancarios y contables 
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
ALTER TABLE dbo.MovimientosDesdeBancos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.MovimientosBancarios ADD
	ConciliacionMovimientoID int NULL
GO
ALTER TABLE dbo.MovimientosBancarios ADD CONSTRAINT
	FK_MovimientosBancarios_MovimientosDesdeBancos FOREIGN KEY
	(
	ConciliacionMovimientoID
	) REFERENCES dbo.MovimientosDesdeBancos
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.MovimientosBancarios SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.dAsientos ADD
	ConciliacionMovimientoID int NULL
GO
ALTER TABLE dbo.dAsientos ADD CONSTRAINT
	FK_dAsientos_MovimientosDesdeBancos FOREIGN KEY
	(
	ConciliacionMovimientoID
	) REFERENCES dbo.MovimientosDesdeBancos
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.dAsientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.339', GetDate()) 