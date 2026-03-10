/*    
	  Martes, 27 de Enero de 2.026  -   v0.00.472.sql 
	  
	  Agregamos la tabla ConciliacionBancaria

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
ALTER TABLE dbo.Monedas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.ConciliacionBancaria
	(
	Id int NOT NULL IDENTITY (1, 1),
	CuentaContableId int NOT NULL,
	MonedaId int NOT NULL,
	Desde date NOT NULL,
	Hasta date NOT NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.ConciliacionBancaria ADD CONSTRAINT
	PK_ConciliacionBancaria PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.ConciliacionBancaria ADD CONSTRAINT
	FK_ConciliacionBancaria_CuentasContables FOREIGN KEY
	(
	CuentaContableId
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.ConciliacionBancaria ADD CONSTRAINT
	FK_ConciliacionBancaria_Monedas FOREIGN KEY
	(
	MonedaId
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.ConciliacionBancaria ADD CONSTRAINT
	FK_ConciliacionBancaria_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.ConciliacionBancaria SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.472', GetDate()) 