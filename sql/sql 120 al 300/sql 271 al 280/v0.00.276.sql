/*    Miércoles, 29 de Junio de 2.011  -   v0.00.276.sql 

	Agregamos un PK a la tabla MovimientosBancariosID, 
	para poder agregarla al entity model en ScrNetS 
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
CREATE TABLE dbo.Tmp_MovimientosBancariosId
	(
	Numero int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_MovimientosBancariosId SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.MovimientosBancariosId)
	 EXEC('INSERT INTO dbo.Tmp_MovimientosBancariosId (Numero)
		SELECT Numero FROM dbo.MovimientosBancariosId WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.MovimientosBancariosId
GO
EXECUTE sp_rename N'dbo.Tmp_MovimientosBancariosId', N'MovimientosBancariosId', 'OBJECT' 
GO
ALTER TABLE dbo.MovimientosBancariosId ADD CONSTRAINT
	PK_MovimientosBancariosId PRIMARY KEY CLUSTERED 
	(
	Numero
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.276', GetDate()) 