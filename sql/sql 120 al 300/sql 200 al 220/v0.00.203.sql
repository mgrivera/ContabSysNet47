/*    Martes, 6 de marzo de 2.007   -   v0.00.203.sql 

	Agregamos el item CiaContab a la tabla BancosInfoTarjetas

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
ALTER TABLE dbo.BancosInfoTarjetas
	DROP CONSTRAINT FK_BancosInfoTarjetas_Bancos
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_BancosInfoTarjetas
	(
	Banco int NOT NULL,
	Tarjeta char(2) NOT NULL,
	CiaContab int NOT NULL,
	PorcComision decimal(5, 2) NULL,
	PorcImpuestos decimal(5, 2) NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.BancosInfoTarjetas)
	 EXEC('INSERT INTO dbo.Tmp_BancosInfoTarjetas (Banco, Tarjeta, CiaContab, PorcComision, PorcImpuestos)
		SELECT Banco, Tarjeta, 35, PorcComision, PorcImpuestos FROM dbo.BancosInfoTarjetas WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.BancosInfoTarjetas
GO
EXECUTE sp_rename N'dbo.Tmp_BancosInfoTarjetas', N'BancosInfoTarjetas', 'OBJECT' 
GO

ALTER TABLE dbo.BancosInfoTarjetas ADD CONSTRAINT
	PK_BancosInfoTarjetas PRIMARY KEY CLUSTERED 
	(
	Banco,
	Tarjeta,
	CiaContab
	) 

GO
ALTER TABLE dbo.BancosInfoTarjetas ADD CONSTRAINT
	FK_BancosInfoTarjetas_Bancos FOREIGN KEY
	(
	Banco
	) REFERENCES dbo.Bancos
	(
	Banco
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.203', GetDate()) 