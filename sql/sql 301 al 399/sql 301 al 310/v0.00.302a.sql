/*    Lunes, 16 de Enero de 2.012  -   v0.00.302a.sql 

	Cambiamos un poco la estrucutura de las tablas Facturas y CuotasFacturas, 
	básicamente, para eliminar redundancias (columnas y relaciones) 
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
ALTER TABLE dbo.Facturas
	DROP COLUMN NumeroDeCuotas, FechaUltimoVencimiento, DistribuirEnCondominioFlag, GrupoCondominio, CierreCondominio, CodigoInmueble
GO
ALTER TABLE dbo.Facturas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.302a', GetDate()) 