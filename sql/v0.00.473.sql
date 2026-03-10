/*    
	  Jueves, 30 de Enero de 2.026  -   v0.00.473.sql 
	  
	  Agregamos las tablas que contendrán los movimientos de la conciliación

*/

/* eliminamos las tablas antes si existen (no worries, they are brand new) */ 
DROP TABLE IF EXISTS dbo.ConciliacionBancaria_Bancos;
DROP TABLE IF EXISTS dbo.ConciliacionBancaria_Contab;
DROP TABLE IF EXISTS dbo.ConciliacionBancaria_Resultado;

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
ALTER TABLE dbo.ConciliacionBancaria SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.ConciliacionBancaria_Bancos
	(
	Id int NOT NULL IDENTITY (1, 1),
	ConciliacionId int NOT NULL,
	MovimientoContabId int NULL,
	Fecha date NOT NULL,
	Tipo nvarchar(16) NULL,
	Referencia nvarchar(20) NULL,
	Descripcion nvarchar(300) NULL,
	Monto money NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.ConciliacionBancaria_Bancos ADD CONSTRAINT
	PK_ConciliacionBancaria_Bancos PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_ConciliacionBancaria_Bancos ON dbo.ConciliacionBancaria_Bancos
	(
	ConciliacionId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.ConciliacionBancaria_Bancos ADD CONSTRAINT
	FK_ConciliacionBancaria_Bancos_ConciliacionBancaria FOREIGN KEY
	(
	ConciliacionId
	) REFERENCES dbo.ConciliacionBancaria
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.ConciliacionBancaria_Bancos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.ConciliacionBancaria_Contab
	(
	Id int NOT NULL IDENTITY (1, 1),
	ConciliacionId int NOT NULL,
	MovimientoBancosId int NULL,
	Fecha date NOT NULL,
	Comprobante smallint NOT NULL,
	Partida smallint NOT NULL,
	MonSimbolo nvarchar(6) NOT NULL,
	MonOrigSimbolo nvarchar(6) NOT NULL,
	Descripcion nvarchar(300) NOT NULL,
	Referencia nvarchar(20) NULL,
	Monto money NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.ConciliacionBancaria_Contab ADD CONSTRAINT
	PK_ConciliacionBancaria_Contab PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_ConciliacionBancaria_Contab ON dbo.ConciliacionBancaria_Contab
	(
	ConciliacionId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.ConciliacionBancaria_Contab ADD CONSTRAINT
	FK_ConciliacionBancaria_Contab_ConciliacionBancaria FOREIGN KEY
	(
	ConciliacionId
	) REFERENCES dbo.ConciliacionBancaria
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.ConciliacionBancaria_Contab SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.ConciliacionBancaria SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.ConciliacionBancaria_Resultado
	(
	Id int NOT NULL IDENTITY (1, 1),
	ConciliacionId int NOT NULL,
	Contab_Fecha date NULL,
	Contab_Comprobante smallint NULL,
	Contab_Partida smallint NULL,
	Contab_MonSimbolo nvarchar(6) NULL,
	Contab_MonOrigSimbolo nvarchar(6) NULL,
	Contab_Descripcion nvarchar(300) NULL,
	Contab_Referencia nvarchar(20) NULL,
	Contab_Monto money NULL,
	Bancos_Fecha date NULL,
	Bancos_Tipo nvarchar(16) NULL,
	Bancos_Referencia nvarchar(20) NULL,
	Bancos_Descripcion nvarchar(300) NULL,
	Bancos_Monto money NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.ConciliacionBancaria_Resultado ADD CONSTRAINT
	PK_ConciliacionBancaria_Resultado PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.ConciliacionBancaria_Resultado ADD CONSTRAINT
	FK_ConciliacionBancaria_Resultado_ConciliacionBancaria FOREIGN KEY
	(
	ConciliacionId
	) REFERENCES dbo.ConciliacionBancaria
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.ConciliacionBancaria_Resultado SET (LOCK_ESCALATION = TABLE)
GO
COMMIT




















Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.473', GetDate()) 