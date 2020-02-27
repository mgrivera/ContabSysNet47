/*    Lunes, 28 de Mayo de 2.012  -   v0.00.312.sql 

	CuentasBancarias: hacemos una corrección menor para eliminar 
	la relación entre esta tabla y Bancos; no es necesaria pues existe 
	una relación con Agencias 
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
ALTER TABLE dbo.CuentasBancarias
	DROP CONSTRAINT FK_CuentasBancarias_Bancos
GO
ALTER TABLE dbo.Bancos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasBancarias
	DROP COLUMN Banco
GO
ALTER TABLE dbo.CuentasBancarias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT





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
DROP TABLE dbo.AgenciasId
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Agencias
	DROP CONSTRAINT FK_Agencias_Bancos
GO
ALTER TABLE dbo.Bancos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Agencias
	(
	Banco int NOT NULL,
	Agencia int NOT NULL IDENTITY (1, 1),
	Nombre nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Direccion nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Telefono1 nvarchar(14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Telefono2 nvarchar(14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Fax nvarchar(14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Contacto1 nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Contacto2 nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Agencias SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Agencias ON
GO
IF EXISTS(SELECT * FROM dbo.Agencias)
	 EXEC('INSERT INTO dbo.Tmp_Agencias (Banco, Agencia, Nombre, Direccion, Telefono1, Telefono2, Fax, Contacto1, Contacto2)
		SELECT Banco, Agencia, Nombre, Direccion, Telefono1, Telefono2, Fax, Contacto1, Contacto2 FROM dbo.Agencias WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Agencias OFF
GO
ALTER TABLE dbo.CuentasBancarias
	DROP CONSTRAINT FK_CuentasBancarias_Agencias
GO
DROP TABLE dbo.Agencias
GO
EXECUTE sp_rename N'dbo.Tmp_Agencias', N'Agencias', 'OBJECT' 
GO
ALTER TABLE dbo.Agencias ADD CONSTRAINT
	PK_Agencias PRIMARY KEY NONCLUSTERED 
	(
	Agencia
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Agencias WITH NOCHECK ADD CONSTRAINT
	FK_Agencias_Bancos FOREIGN KEY
	(
	Banco
	) REFERENCES dbo.Bancos
	(
	Banco
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasBancarias WITH NOCHECK ADD CONSTRAINT
	FK_CuentasBancarias_Agencias FOREIGN KEY
	(
	Agencia
	) REFERENCES dbo.Agencias
	(
	Agencia
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CuentasBancarias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.312', GetDate()) 