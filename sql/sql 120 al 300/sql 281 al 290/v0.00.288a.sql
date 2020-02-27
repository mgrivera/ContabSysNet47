/*    Jueves, 20 de Octubre de 2.011  -   v0.00.288a.sql 

	Hacemos cambios importantes a las tablas que corresponden a 
	Movimientos Bancarios 
	
	Cambios a Chequeras ... 
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
ALTER TABLE dbo.Chequeras
	DROP CONSTRAINT FK_Chequeras_CuentasBancarias
GO
ALTER TABLE dbo.CuentasBancarias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Chequeras
	DROP CONSTRAINT FK_Chequeras_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Chequeras
	(
	NumeroChequera int NOT NULL,
	NumeroCuenta int NOT NULL,
	Generica bit NULL,
	FechaAsignacion datetime NOT NULL,
	Desde int NOT NULL,
	Hasta int NOT NULL,
	AsignadaA nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	AgotadaFlag bit NULL,
	CantidadDeChequesUsados smallint NULL,
	UltimoChequeUsado nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CantidadDeCheques int NULL,
	Usuario nvarchar(25) NULL,
	Ingreso datetime NULL,
	UltAct datetime NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Chequeras SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.Chequeras)
	 EXEC('INSERT INTO dbo.Tmp_Chequeras (NumeroChequera, NumeroCuenta, FechaAsignacion, Desde, Hasta, AsignadaA, AgotadaFlag, CantidadDeChequesUsados, UltimoChequeUsado, CantidadDeCheques, Ingreso, UltAct, Cia)
		SELECT NumeroChequera, NumeroCuenta, FechaAsignacion, Desde, Hasta, AsignadaA, AgotadaFlag, CantidadDeChequesUsados, UltimoChequeUsado, CantidadDeCheques, Ingreso, UltAct, Cia FROM dbo.Chequeras WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.Chequeras
GO
EXECUTE sp_rename N'dbo.Tmp_Chequeras', N'Chequeras', 'OBJECT' 
GO
ALTER TABLE dbo.Chequeras ADD CONSTRAINT
	PK_Chequeras PRIMARY KEY NONCLUSTERED 
	(
	NumeroChequera
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_Chequeras ON dbo.Chequeras
	(
	NumeroCuenta
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.Chequeras WITH NOCHECK ADD CONSTRAINT
	FK_Chequeras_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Chequeras WITH NOCHECK ADD CONSTRAINT
	FK_Chequeras_CuentasBancarias FOREIGN KEY
	(
	NumeroCuenta
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT


Update Chequeras Set Usuario = 'no user' 

Alter Table Chequeras Alter Column Usuario nvarchar(25) NOT NULL




















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
ALTER TABLE dbo.Chequeras
	DROP CONSTRAINT FK_Chequeras_CuentasBancarias
GO
ALTER TABLE dbo.CuentasBancarias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Chequeras
	DROP CONSTRAINT FK_Chequeras_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Chequeras
	(
	NumeroChequera int NOT NULL IDENTITY (1, 1),
	NumeroCuenta int NOT NULL,
	Generica bit NULL,
	FechaAsignacion datetime NOT NULL,
	Desde int NOT NULL,
	Hasta int NOT NULL,
	AsignadaA nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	AgotadaFlag bit NULL,
	CantidadDeChequesUsados smallint NULL,
	UltimoChequeUsado nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CantidadDeCheques int NULL,
	Usuario nvarchar(25) NOT NULL,
	Ingreso datetime NULL,
	UltAct datetime NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Chequeras SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Chequeras ON
GO
IF EXISTS(SELECT * FROM dbo.Chequeras)
	 EXEC('INSERT INTO dbo.Tmp_Chequeras (NumeroChequera, NumeroCuenta, Generica, FechaAsignacion, Desde, Hasta, AsignadaA, AgotadaFlag, CantidadDeChequesUsados, UltimoChequeUsado, CantidadDeCheques, Usuario, Ingreso, UltAct, Cia)
		SELECT NumeroChequera, NumeroCuenta, Generica, FechaAsignacion, Desde, Hasta, AsignadaA, AgotadaFlag, CantidadDeChequesUsados, UltimoChequeUsado, CantidadDeCheques, Usuario, Ingreso, UltAct, Cia FROM dbo.Chequeras WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Chequeras OFF
GO
DROP TABLE dbo.Chequeras
GO
EXECUTE sp_rename N'dbo.Tmp_Chequeras', N'Chequeras', 'OBJECT' 
GO
ALTER TABLE dbo.Chequeras ADD CONSTRAINT
	PK_Chequeras PRIMARY KEY NONCLUSTERED 
	(
	NumeroChequera
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_Chequeras ON dbo.Chequeras
	(
	NumeroCuenta
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.Chequeras WITH NOCHECK ADD CONSTRAINT
	FK_Chequeras_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Chequeras WITH NOCHECK ADD CONSTRAINT
	FK_Chequeras_CuentasBancarias FOREIGN KEY
	(
	NumeroCuenta
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion
Insert Into tVersion(VersionActual, Fecha) Values('v0.00.288a', GetDate()) 