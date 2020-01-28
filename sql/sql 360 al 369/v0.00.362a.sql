/*    Jueves, 21 de Noviembre de 2.013 	-   v0.00.362a.sql 

	Cambios básicos al registro de información para la contabilización de 
	depósitos de ventas con tarjetas de crédito ... 
	
	Nota importante: este script fallará si el siguiente Select regresa registros 
	Select * From BancosInfoTarjetas Where CiaContab Not In (Select Numero From Companias) 
	
	Corresponden a registros para compañías que se han eliminado de la base de datos; eliminarlos: 
	Delete From BancosInfoTarjetas Where CiaContab Not In (Select Numero From Companias) 

	NOTA IMPORTANTE: revisar collation en tables: Tarjetas y BancosInfoTarjetas
	
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
ALTER TABLE dbo.Bancos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.BancosInfoTarjetas
	DROP CONSTRAINT FK_BancosInfoTarjetas_Tarjetas
GO
ALTER TABLE dbo.Tarjetas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_BancosInfoTarjetas
	(
	ID int NOT NULL IDENTITY (1, 1),
	Banco int NOT NULL,
	Tarjeta nvarchar(4) NOT NULL,
	CiaContab int NULL,
	PorcComision decimal(5, 2) NULL,
	PorcComision2 decimal(5, 2) NULL,
	PorcImpuestos decimal(5, 2) NULL,
	AplicarFactorReversionImpuestos bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_BancosInfoTarjetas SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_BancosInfoTarjetas OFF
GO
IF EXISTS(SELECT * FROM dbo.BancosInfoTarjetas)
	 EXEC('INSERT INTO dbo.Tmp_BancosInfoTarjetas (Banco, Tarjeta, CiaContab, PorcComision, PorcComision2, PorcImpuestos, AplicarFactorReversionImpuestos)
		SELECT Banco, Tarjeta, CiaContab, PorcComision, PorcComision2, PorcImpuestos, AplicarFactorReversionImpuestos FROM dbo.BancosInfoTarjetas WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.BancosInfoTarjetas
GO
EXECUTE sp_rename N'dbo.Tmp_BancosInfoTarjetas', N'BancosInfoTarjetas', 'OBJECT' 
GO
ALTER TABLE dbo.BancosInfoTarjetas ADD CONSTRAINT
	PK_BancosInfoTarjetas_1 PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.BancosInfoTarjetas WITH NOCHECK ADD CONSTRAINT
	FK_BancosInfoTarjetas_Tarjetas FOREIGN KEY
	(
	Tarjeta
	) REFERENCES dbo.Tarjetas
	(
	Tarjeta
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.BancosInfoTarjetas WITH NOCHECK ADD CONSTRAINT
	FK_BancosInfoTarjetas_Bancos FOREIGN KEY
	(
	Banco
	) REFERENCES dbo.Bancos
	(
	Banco
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.BancosInfoTarjetas ADD CONSTRAINT
	FK_BancosInfoTarjetas_Companias FOREIGN KEY
	(
	CiaContab
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.362a', GetDate()) 
