/*    
	  Martes, 20/Dic/2016   -   v0.00.385.sql 

	  Chequeras: el usuario es ahora de 125 chars. 
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
CREATE TABLE dbo.Tmp_Chequeras
	(
	NumeroChequera int NOT NULL IDENTITY (1, 1),
	NumeroCuenta int NOT NULL,
	Activa bit NOT NULL,
	Generica bit NOT NULL,
	FechaAsignacion date NOT NULL,
	Desde int NULL,
	Hasta int NULL,
	AsignadaA nvarchar(50) NULL,
	AgotadaFlag bit NULL,
	CantidadDeChequesUsados smallint NULL,
	UltimoChequeUsado bigint NULL,
	CantidadDeCheques int NULL,
	Usuario nvarchar(125) NOT NULL,
	Ingreso datetime NOT NULL,
	UltAct datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Chequeras SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Chequeras ON
GO
IF EXISTS(SELECT * FROM dbo.Chequeras)
	 EXEC('INSERT INTO dbo.Tmp_Chequeras (NumeroChequera, NumeroCuenta, Activa, Generica, FechaAsignacion, Desde, Hasta, AsignadaA, AgotadaFlag, CantidadDeChequesUsados, UltimoChequeUsado, CantidadDeCheques, Usuario, Ingreso, UltAct)
		SELECT NumeroChequera, NumeroCuenta, Activa, Generica, FechaAsignacion, Desde, Hasta, AsignadaA, AgotadaFlag, CantidadDeChequesUsados, UltimoChequeUsado, CantidadDeCheques, Usuario, Ingreso, UltAct FROM dbo.Chequeras WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Chequeras OFF
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Chequeras
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
BEGIN TRANSACTION
GO
ALTER TABLE dbo.MovimientosBancarios ADD CONSTRAINT
	FK_MovimientosBancarios_Chequeras FOREIGN KEY
	(
	ClaveUnicaChequera
	) REFERENCES dbo.Chequeras
	(
	NumeroChequera
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.MovimientosBancarios SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.385', GetDate()) 
