/*    
	  Miércoles, 04/Ene/2017   -   v0.00.387.sql 

	  Agregamos la tabla CompaniasYUsuarios, para mantener un registro de quienes pueden 
	  acceder cuales compañías ... 
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
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.aspnet_Users SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.CompaniasYUsuarios
	(
	PK int NOT NULL IDENTITY (1, 1),
	Compania int NOT NULL,
	Usuario uniqueidentifier NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.CompaniasYUsuarios ADD CONSTRAINT
	PK_CompaniasYUsuarios PRIMARY KEY CLUSTERED 
	(
	PK
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.CompaniasYUsuarios ADD CONSTRAINT
	FK_CompaniasYUsuarios_aspnet_Users FOREIGN KEY
	(
	Usuario
	) REFERENCES dbo.aspnet_Users
	(
	UserId
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.CompaniasYUsuarios ADD CONSTRAINT
	FK_CompaniasYUsuarios_Companias FOREIGN KEY
	(
	Compania
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.CompaniasYUsuarios SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.387', GetDate()) 
