/*    Martes, 8 de Abril del 2003   -   v0.00.149.sql 

	Cambiamos el tipo del item CantidadCheques en la tabla Chequeras, de 
	SmallInt a Int. 

*/ 


BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.Chequeras
	DROP CONSTRAINT FK_Chequeras_Companias
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.Chequeras
	DROP CONSTRAINT FK_Chequeras_CuentasBancarias
GO
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.Tmp_Chequeras
	(
	NumeroChequera int NOT NULL,
	NumeroCuenta int NOT NULL,
	FechaAsignacion datetime NOT NULL,
	Desde int NOT NULL,
	Hasta int NOT NULL,
	AsignadaA nvarchar(50) NULL,
	AgotadaFlag bit NULL,
	CantidadDeChequesUsados smallint NULL,
	UltimoChequeUsado nvarchar(20) NULL,
	CantidadDeCheques int NULL,
	Ingreso datetime NULL,
	UltAct datetime NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.Chequeras)
	 EXEC('INSERT INTO dbo.Tmp_Chequeras (NumeroChequera, NumeroCuenta, FechaAsignacion, Desde, Hasta, AsignadaA, AgotadaFlag, CantidadDeChequesUsados, UltimoChequeUsado, CantidadDeCheques, Ingreso, UltAct, Cia)
		SELECT NumeroChequera, NumeroCuenta, FechaAsignacion, Desde, Hasta, AsignadaA, AgotadaFlag, CantidadDeChequesUsados, UltimoChequeUsado, CONVERT(int, CantidadDeCheques), Ingreso, UltAct, Cia FROM dbo.Chequeras TABLOCKX')
GO
DROP TABLE dbo.Chequeras
GO
EXECUTE sp_rename N'dbo.Tmp_Chequeras', N'Chequeras', 'OBJECT'
GO
ALTER TABLE dbo.Chequeras ADD CONSTRAINT
	PK_Chequeras PRIMARY KEY NONCLUSTERED 
	(
	NumeroChequera
	) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_Chequeras ON dbo.Chequeras
	(
	NumeroCuenta
	) ON [PRIMARY]
GO
ALTER TABLE dbo.Chequeras WITH NOCHECK ADD CONSTRAINT
	FK_Chequeras_CuentasBancarias FOREIGN KEY
	(
	NumeroCuenta
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	)
GO
ALTER TABLE dbo.Chequeras WITH NOCHECK ADD CONSTRAINT
	FK_Chequeras_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	)
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.149', GetDate()) 

