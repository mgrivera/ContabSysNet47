/*
   15 April 202413:03:20
   User: DB_A4654C_dbContabArsa_admin
   Server: SQL5055.site4now.net
   Database: DB_A4654C_dbContabArsa
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
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
ALTER TABLE dbo.tCiaSeleccionada
	DROP CONSTRAINT FK_tCiaSeleccionada_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tCiaSeleccionada
	(
	ID int NOT NULL IDENTITY (1, 1),
	CiaSeleccionada int NOT NULL,
	Nombre nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	NombreCorto nvarchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Abreviatura nvarchar(6) NOT NULL,
	Usuario int NOT NULL,
	UsuarioLS nvarchar(255) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tCiaSeleccionada SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tCiaSeleccionada ON
GO
IF EXISTS(SELECT * FROM dbo.tCiaSeleccionada)
	 EXEC('INSERT INTO dbo.Tmp_tCiaSeleccionada (ID, CiaSeleccionada, Nombre, NombreCorto, Usuario, UsuarioLS)
		SELECT ID, CiaSeleccionada, Nombre, NombreCorto, Usuario, UsuarioLS FROM dbo.tCiaSeleccionada WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tCiaSeleccionada OFF
GO
DROP TABLE dbo.tCiaSeleccionada
GO
EXECUTE sp_rename N'dbo.Tmp_tCiaSeleccionada', N'tCiaSeleccionada', 'OBJECT' 
GO
ALTER TABLE dbo.tCiaSeleccionada ADD CONSTRAINT
	PK_tCiaSeleccionada PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tCiaSeleccionada ADD CONSTRAINT
	FK_tCiaSeleccionada_Companias FOREIGN KEY
	(
	CiaSeleccionada
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT
