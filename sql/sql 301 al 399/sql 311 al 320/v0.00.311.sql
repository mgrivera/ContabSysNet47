/*    Viernes, 27 de Abril de 2.012  -   v0.00.311.sql 

	Movimientos Bancarios: agregamos el item PagoID; además, 
	eliminamos el item ClaveUnicaMovimientoBancarios de Pagos 
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
ALTER TABLE dbo.MovimientosBancarios ADD
	PagoID int NULL
GO
ALTER TABLE dbo.MovimientosBancarios SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


Update m Set m.PagoID = p.ClaveUnica 
From MovimientosBancarios m Inner Join Pagos p 
On m.ClaveUnica = p.ClaveUnicaMovimientoBancario 
Where p.ClaveUnicaMovimientoBancario Is Not Null


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
ALTER TABLE dbo.Pagos
	DROP COLUMN ClaveUnicaMovimientoBancario
GO
ALTER TABLE dbo.Pagos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.311', GetDate()) 