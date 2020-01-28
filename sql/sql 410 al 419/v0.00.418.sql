/*    
	  Lunes, 25 de Noviembre de 2.019  -   v0.00.418.sql 
	  
	  Agregamos la tabla que permitirá guardar los links de documentos de asientos 
	  que se pueden registrar en Dropbox 
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
ALTER TABLE dbo.Asientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Asientos_Documentos_Links
	(
	Id int NOT NULL IDENTITY (1, 1),
	NumeroAutomatico int NOT NULL,
	Link varchar(350) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Asientos_Documentos_Links ADD CONSTRAINT
	PK_Asientos_Documentos_Links PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Asientos_Documentos_Links ADD CONSTRAINT
	FK_Asientos_Documentos_Links_Asientos FOREIGN KEY
	(
	NumeroAutomatico
	) REFERENCES dbo.Asientos
	(
	NumeroAutomatico
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Asientos_Documentos_Links SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.418', GetDate()) 


