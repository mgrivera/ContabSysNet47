/*    Miércoles, 1 de Mayo de 2.013 	-   v0.00.338.sql 

	Hacemos cambios muy menores a la tabla ParametrosGlobalBancos 

	Nota importante: este script fallará si el siguiente Select regresa 
	registros: 

	Select * From ParametrosGlobalBancos Where TipoAsientoDefault Is Not Null 
		And TipoAsientoDefault Not In (Select Tipo From TiposDeAsiento) 


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
ALTER TABLE dbo.TiposDeAsiento SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.ParametrosGlobalBancos ADD CONSTRAINT
	FK_ParametrosGlobalBancos_TiposDeAsiento FOREIGN KEY
	(
	TipoAsientoDefault
	) REFERENCES dbo.TiposDeAsiento
	(
	Tipo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.ParametrosGlobalBancos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.338', GetDate()) 