/*    
	  Viernes, 12 de Febrero de 2.021  -   v0.00.430.sql 
	  
	  Agregamos la columna Lote a la tabla Movimientos Bancarios 
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
ALTER TABLE dbo.MovimientosBancarios ADD Lote nvarchar(150) NULL
GO
ALTER TABLE dbo.MovimientosBancarios SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.430', GetDate()) 