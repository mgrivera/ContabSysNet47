/*    Lunes, 27 de Enero de 2.012  -   v0.00.304.sql 

	Tablas 'temporales' para la obtención del Mayor General 
	agrandamos la columna descripción a 75 chars. 
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
CREATE TABLE dbo.Tmp_tTempListadoMayorGeneralAmbasMonedas
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	Moneda int NULL,
	NombreMoneda nvarchar(50) NULL,
	MonedaOriginal int NULL,
	NombreMonedaOriginal nvarchar(50) NULL,
	Numero smallint NULL,
	Mes smallint NULL,
	Ano smallint NULL,
	Fecha datetime NULL,
	AnoMes nvarchar(6) NULL,
	Partida smallint NULL,
	CuentaContableID int NULL,
	Cuenta nvarchar(50) NULL,
	Descripcion nvarchar(75) NULL,
	Referencia nvarchar(20) NULL,
	DebeBs money NULL,
	HaberBs money NULL,
	DebeDol money NULL,
	HaberDol money NULL,
	FactorDeCambio money NULL,
	CentroCosto int NULL,
	NumeroUsuario int NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tTempListadoMayorGeneralAmbasMonedas SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tTempListadoMayorGeneralAmbasMonedas ON
GO
IF EXISTS(SELECT * FROM dbo.tTempListadoMayorGeneralAmbasMonedas)
	 EXEC('INSERT INTO dbo.Tmp_tTempListadoMayorGeneralAmbasMonedas (ClaveUnica, Moneda, NombreMoneda, MonedaOriginal, NombreMonedaOriginal, Numero, Mes, Ano, Fecha, AnoMes, Partida, CuentaContableID, Cuenta, Descripcion, Referencia, DebeBs, HaberBs, DebeDol, HaberDol, FactorDeCambio, CentroCosto, NumeroUsuario, Cia)
		SELECT ClaveUnica, Moneda, NombreMoneda, MonedaOriginal, NombreMonedaOriginal, Numero, Mes, Ano, Fecha, AnoMes, Partida, CuentaContableID, Cuenta, Descripcion, Referencia, DebeBs, HaberBs, DebeDol, HaberDol, FactorDeCambio, CentroCosto, NumeroUsuario, Cia FROM dbo.tTempListadoMayorGeneralAmbasMonedas WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tTempListadoMayorGeneralAmbasMonedas OFF
GO
DROP TABLE dbo.tTempListadoMayorGeneralAmbasMonedas
GO
EXECUTE sp_rename N'dbo.Tmp_tTempListadoMayorGeneralAmbasMonedas', N'tTempListadoMayorGeneralAmbasMonedas', 'OBJECT' 
GO
ALTER TABLE dbo.tTempListadoMayorGeneralAmbasMonedas ADD CONSTRAINT
	PK_tTempListadoMayorGeneralAmbasMonedas PRIMARY KEY NONCLUSTERED 
	(
	ClaveUnica
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_tTempListadoMayorGeneralAmbasMonedas ON dbo.tTempListadoMayorGeneralAmbasMonedas
	(
	NumeroUsuario
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tTempListadoMayorGeneral
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	Moneda int NULL,
	NombreMoneda nvarchar(50) NULL,
	MonedaOriginal int NULL,
	NombreMonedaOriginal nvarchar(50) NULL,
	Numero smallint NULL,
	Mes smallint NULL,
	Ano smallint NULL,
	Fecha datetime NULL,
	AnoMes nvarchar(6) NULL,
	Partida smallint NULL,
	CuentaContableID int NULL,
	Cuenta nvarchar(50) NULL,
	Descripcion nvarchar(75) NULL,
	Referencia nvarchar(20) NULL,
	Debe money NULL,
	Haber money NULL,
	FactorDeCambio money NULL,
	CentroCosto int NULL,
	NumeroUsuario int NOT NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tTempListadoMayorGeneral SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tTempListadoMayorGeneral ON
GO
IF EXISTS(SELECT * FROM dbo.tTempListadoMayorGeneral)
	 EXEC('INSERT INTO dbo.Tmp_tTempListadoMayorGeneral (ClaveUnica, Moneda, NombreMoneda, MonedaOriginal, NombreMonedaOriginal, Numero, Mes, Ano, Fecha, AnoMes, Partida, CuentaContableID, Cuenta, Descripcion, Referencia, Debe, Haber, FactorDeCambio, CentroCosto, NumeroUsuario, Cia)
		SELECT ClaveUnica, Moneda, NombreMoneda, MonedaOriginal, NombreMonedaOriginal, Numero, Mes, Ano, Fecha, AnoMes, Partida, CuentaContableID, Cuenta, Descripcion, Referencia, Debe, Haber, FactorDeCambio, CentroCosto, NumeroUsuario, Cia FROM dbo.tTempListadoMayorGeneral WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tTempListadoMayorGeneral OFF
GO
DROP TABLE dbo.tTempListadoMayorGeneral
GO
EXECUTE sp_rename N'dbo.Tmp_tTempListadoMayorGeneral', N'tTempListadoMayorGeneral', 'OBJECT' 
GO
ALTER TABLE dbo.tTempListadoMayorGeneral ADD CONSTRAINT
	PK_tTempListadoMayorGeneral PRIMARY KEY NONCLUSTERED 
	(
	ClaveUnica
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_tTempListadoMayorGeneral ON dbo.tTempListadoMayorGeneral
	(
	NumeroUsuario
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.304', GetDate()) 