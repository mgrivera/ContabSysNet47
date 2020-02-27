/*    Lunes, 20 de Abril de 2.009  -   v0.00.248.sql 

	Hacemos algunas modificaciones a las tablas 
	Contab_ConsultaComprobantesContables y ..._Partidas 

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
ALTER TABLE dbo.Contab_ConsultaComprobantesContables_Partidas
	DROP CONSTRAINT FK_Contab_ConsultaComprobantesContables_Partidas_Contab_ConsultaComprobantesContables
GO
EXECUTE sp_rename N'dbo.Contab_ConsultaComprobantesContables', N'tTempWebReport_ConsultaComprobantesContables', 'OBJECT' 
GO
ALTER TABLE dbo.tTempWebReport_ConsultaComprobantesContables
	DROP COLUMN NombreTipo, NombreMoneda, SimboloMoneda, NombreMonedaOriginal, SimboloMonedaOriginal, NombreCiaContab
GO
ALTER TABLE dbo.tTempWebReport_ConsultaComprobantesContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
EXECUTE sp_rename N'dbo.Contab_ConsultaComprobantesContables_Partidas', N'tTempWebReport_ConsultaComprobantesContables_Partidas', 'OBJECT' 
GO
ALTER TABLE dbo.tTempWebReport_ConsultaComprobantesContables_Partidas ADD CONSTRAINT
	FK_tTempWebReport_ConsultaComprobantesContables_Partidas_tTempWebReport_ConsultaComprobantesContables FOREIGN KEY
	(
	NumeroAutomatico,
	CiaContab,
	NombreUsuario
	) REFERENCES dbo.tTempWebReport_ConsultaComprobantesContables
	(
	NumeroAutomatico,
	CiaContab,
	NombreUsuario
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.tTempWebReport_ConsultaComprobantesContables_Partidas
	DROP COLUMN CuentaContableEditada, NombreCuentaContable
GO
ALTER TABLE dbo.tTempWebReport_ConsultaComprobantesContables_Partidas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.248', GetDate()) 