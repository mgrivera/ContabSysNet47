/*    Sábado, 20 de Agosto de 2.011  -   v0.00.278.sql 

	Eliminamos varias tablas del tipo xxxxID, las cuales ya 
	no son usadas pues los PK que estas tablas permitían 
	mantener son Identity 
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
DROP TABLE dbo.TiposProveedorId
GO
COMMIT
BEGIN TRANSACTION
GO
DROP TABLE dbo.tDepartamentosId
GO
COMMIT
BEGIN TRANSACTION
GO
DROP TABLE dbo.tCargosId
GO
COMMIT
BEGIN TRANSACTION
GO
DROP TABLE dbo.ProveedoresId
GO
COMMIT
BEGIN TRANSACTION
GO
DROP TABLE dbo.PersonasId
GO
COMMIT
BEGIN TRANSACTION
GO
DROP TABLE dbo.MonedasId
GO
COMMIT
BEGIN TRANSACTION
GO
DROP TABLE dbo.FormasDePagoId
GO
COMMIT
BEGIN TRANSACTION
GO
DROP TABLE dbo.CategoriasRetencionId
GO
COMMIT
BEGIN TRANSACTION
GO
DROP TABLE dbo.AtributosId
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion
Insert Into tVersion(VersionActual, Fecha) Values('v0.00.278', GetDate()) 