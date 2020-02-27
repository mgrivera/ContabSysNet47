/*    Miércoles, 29 de Junio de 2.005   -   v0.00.178.sql 

	Contab - Agregamos la tabla CentrosCosto y el item correspondiente a la tabla 
	dAsientos 

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
ALTER TABLE dbo.dAsientos
	DROP CONSTRAINT FK_dAsientos_Asientos
GO
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.CentrosCosto
	(
	CentroCosto int NOT NULL IDENTITY (1, 1),
	Descripcion nvarchar(50) NOT NULL, 
	DescripcionCorta char(3) NOT NULL

	)  ON [PRIMARY]
GO
ALTER TABLE dbo.CentrosCosto ADD CONSTRAINT
	PK_CentrosCosto PRIMARY KEY CLUSTERED 
	(
	CentroCosto
	) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.Tmp_dAsientos
	(
	NumeroAutomatico int NOT NULL,
	Numero smallint NOT NULL,
	Mes tinyint NOT NULL,
	Ano smallint NOT NULL,
	Fecha datetime NOT NULL,
	Moneda int NOT NULL,
	MonedaOriginal int NOT NULL,
	ConvertirFlag bit NULL,
	FactorDeCambio money NOT NULL,
	Partida smallint NOT NULL,
	Cuenta nvarchar(25) NOT NULL,
	Descripcion nvarchar(50) NULL,
	Referencia nvarchar(20) NULL,
	Debe money NOT NULL,
	Haber money NOT NULL,
	MesFiscal smallint NOT NULL,
	AnoFiscal smallint NOT NULL,
	CentroCosto int NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.dAsientos)
	 EXEC('INSERT INTO dbo.Tmp_dAsientos (NumeroAutomatico, Numero, Mes, Ano, Fecha, Moneda, MonedaOriginal, ConvertirFlag, FactorDeCambio, Partida, Cuenta, Descripcion, Referencia, Debe, Haber, MesFiscal, AnoFiscal, Cia)
		SELECT NumeroAutomatico, Numero, Mes, Ano, Fecha, Moneda, MonedaOriginal, ConvertirFlag, FactorDeCambio, Partida, Cuenta, Descripcion, Referencia, Debe, Haber, MesFiscal, AnoFiscal, Cia FROM dbo.dAsientos TABLOCKX')
GO
DROP TABLE dbo.dAsientos
GO
EXECUTE sp_rename N'dbo.Tmp_dAsientos', N'dAsientos', 'OBJECT'
GO
ALTER TABLE dbo.dAsientos ADD CONSTRAINT
	PK_dAsientos PRIMARY KEY NONCLUSTERED 
	(
	NumeroAutomatico,
	Partida
	) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_dAsientos ON dbo.dAsientos
	(
	NumeroAutomatico
	) ON [PRIMARY]
GO
ALTER TABLE dbo.dAsientos WITH NOCHECK ADD CONSTRAINT
	FK_dAsientos_Asientos FOREIGN KEY
	(
	NumeroAutomatico
	) REFERENCES dbo.Asientos
	(
	NumeroAutomatico
	)
GO
ALTER TABLE dbo.dAsientos ADD CONSTRAINT
	FK_dAsientos_CentrosCosto FOREIGN KEY
	(
	CentroCosto
	) REFERENCES dbo.CentrosCosto
	(
	CentroCosto
	)
GO
COMMIT

--  ------------------------------------------------
--  actualizamos de views y tablas "temporales" 
--  ------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tTempListadoAsientos]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tTempListadoAsientos]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tTempListadoMayorGeneral]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tTempListadoMayorGeneral]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tTempListadoMayorGeneralAmbasMonedas]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tTempListadoMayorGeneralAmbasMonedas]
GO

CREATE TABLE [dbo].[tTempListadoAsientos] (
	[ClaveUnica] [int] IDENTITY (1, 1) NOT NULL ,
	[NumeroAutomatico] [int] NULL ,
	[Numero] [int] NULL ,
	[Fecha] [datetime] NULL ,
	[Tipo] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Moneda] [int] NULL ,
	[NombreMoneda] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SimboloMoneda] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MonedaOriginal] [int] NULL ,
	[NombreMonedaOriginal] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SimboloMonedaOriginal] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionComprobante] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NumPartidas] [smallint] NULL ,
	[Partida] [smallint] NULL ,
	[Cuenta] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Referencia] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Debe] [money] NULL ,
	[Haber] [money] NULL ,
	[NombreCuenta] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaEditada] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Mes] [smallint] NULL ,
	[Ano] [smallint] NULL ,
	[NumeroUsuario] [int] NULL ,
	[DebeDolares] [money] NULL ,
	[HaberDolares] [money] NULL ,
	[FactorDeCambio] [money] NULL ,
	[CentroCosto] [int] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[tTempListadoMayorGeneral] (
	[ClaveUnica] [int] IDENTITY (1, 1) NOT NULL ,
	[Moneda] [int] NULL ,
	[NombreMoneda] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MonedaOriginal] [int] NULL ,
	[NombreMonedaOriginal] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Numero] [smallint] NULL ,
	[Mes] [smallint] NULL ,
	[Ano] [smallint] NULL ,
	[Fecha] [datetime] NULL ,
	[AnoMes] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Partida] [smallint] NULL ,
	[Cuenta] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Descripcion] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Referencia] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Debe] [money] NULL ,
	[Haber] [money] NULL ,
	[FactorDeCambio] [money] NULL ,
	[CentroCosto] [int] NULL ,
	[NumeroUsuario] [int] NOT NULL ,
	[Cia] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tTempListadoMayorGeneralAmbasMonedas] (
	[ClaveUnica] [int] IDENTITY (1, 1) NOT NULL ,
	[Moneda] [int] NULL ,
	[NombreMoneda] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MonedaOriginal] [int] NULL ,
	[NombreMonedaOriginal] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Numero] [smallint] NULL ,
	[Mes] [smallint] NULL ,
	[Ano] [smallint] NULL ,
	[Fecha] [datetime] NULL ,
	[AnoMes] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Partida] [smallint] NULL ,
	[Cuenta] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Descripcion] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Referencia] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DebeBs] [money] NULL ,
	[HaberBs] [money] NULL ,
	[DebeDol] [money] NULL ,
	[HaberDol] [money] NULL ,
	[FactorDeCambio] [money] NULL ,
	[CentroCosto] [int] NULL ,
	[NumeroUsuario] [int] NULL ,
	[Cia] [int] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tTempListadoAsientos] ADD 
	CONSTRAINT [PK_tTempListadoAsientos] PRIMARY KEY  NONCLUSTERED 
	(
		[ClaveUnica]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [IX_tTempListadoAsientos] ON [dbo].[tTempListadoAsientos]([NumeroUsuario]) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tTempListadoMayorGeneral] ADD 
	CONSTRAINT [PK_tTempListadoMayorGeneral] PRIMARY KEY  NONCLUSTERED 
	(
		[ClaveUnica]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [IX_tTempListadoMayorGeneral] ON [dbo].[tTempListadoMayorGeneral]([NumeroUsuario]) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tTempListadoMayorGeneralAmbasMonedas] ADD 
	CONSTRAINT [PK_tTempListadoMayorGeneralAmbasMonedas] PRIMARY KEY  NONCLUSTERED 
	(
		[ClaveUnica]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [IX_tTempListadoMayorGeneralAmbasMonedas] ON [dbo].[tTempListadoMayorGeneralAmbasMonedas]([NumeroUsuario]) ON [PRIMARY]
GO





if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaAsientosSubForm]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaAsientosSubForm]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaAsientosSubFormConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaAsientosSubFormConsulta]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoAsientos]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoAsientos]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoMayorGeneral]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoMayorGeneral]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaCentrosCosto]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaCentrosCosto]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qReportListadoAsientos]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qReportListadoAsientos]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qReportMayorGeneral]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qReportMayorGeneral]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qReportMayorGeneralAmbasMonedas]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qReportMayorGeneralAmbasMonedas]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaCentrosCosto
AS
SELECT     CentroCosto, Descripcion, DescripcionCorta
FROM         dbo.CentrosCosto

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qReportListadoAsientos    Script Date: 31/12/00 10:25:55 a.m. ******/
CREATE VIEW dbo.qReportListadoAsientos
AS
SELECT     dbo.tTempListadoAsientos.Numero, dbo.tTempListadoAsientos.Fecha, dbo.tTempListadoAsientos.Tipo, dbo.tTempListadoAsientos.Moneda, 
                      dbo.tTempListadoAsientos.NombreMoneda, dbo.tTempListadoAsientos.SimboloMoneda, dbo.tTempListadoAsientos.MonedaOriginal, 
                      dbo.tTempListadoAsientos.NombreMonedaOriginal, dbo.tTempListadoAsientos.SimboloMonedaOriginal, 
                      dbo.tTempListadoAsientos.DescripcionComprobante, dbo.tTempListadoAsientos.NumPartidas, dbo.tTempListadoAsientos.Partida, 
                      dbo.tTempListadoAsientos.Cuenta, dbo.tTempListadoAsientos.DescripcionPartida, dbo.tTempListadoAsientos.Referencia, 
                      dbo.tTempListadoAsientos.Debe, dbo.tTempListadoAsientos.Haber, dbo.tTempListadoAsientos.NombreCuenta, 
                      dbo.tTempListadoAsientos.CuentaEditada, dbo.tTempListadoAsientos.Mes, dbo.tTempListadoAsientos.Ano, dbo.tTempListadoAsientos.NumeroUsuario, 
                      dbo.tTempListadoAsientos.NumeroAutomatico, dbo.tTempListadoAsientos.ClaveUnica, dbo.tTempListadoAsientos.DebeDolares, 
                      dbo.tTempListadoAsientos.HaberDolares, dbo.tTempListadoAsientos.FactorDeCambio, dbo.tTempListadoAsientos.CentroCosto, 
                      dbo.CentrosCosto.DescripcionCorta AS NombreCortoCentroCostos
FROM         dbo.tTempListadoAsientos LEFT OUTER JOIN
                      dbo.CentrosCosto ON dbo.tTempListadoAsientos.CentroCosto = dbo.CentrosCosto.CentroCosto

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qReportMayorGeneral
AS
SELECT     dbo.tTempListadoMayorGeneral.ClaveUnica, dbo.tTempListadoMayorGeneral.Moneda, dbo.tTempListadoMayorGeneral.NombreMoneda, 
                      dbo.tTempListadoMayorGeneral.MonedaOriginal, dbo.tTempListadoMayorGeneral.NombreMonedaOriginal, dbo.tTempListadoMayorGeneral.Numero, 
                      dbo.tTempListadoMayorGeneral.Mes, dbo.tTempListadoMayorGeneral.Ano, dbo.tTempListadoMayorGeneral.Fecha, 
                      dbo.tTempListadoMayorGeneral.AnoMes, dbo.tTempListadoMayorGeneral.Partida, dbo.tTempListadoMayorGeneral.Cuenta, 
                      dbo.tTempListadoMayorGeneral.Descripcion, dbo.tTempListadoMayorGeneral.Referencia, dbo.tTempListadoMayorGeneral.Debe, 
                      dbo.tTempListadoMayorGeneral.Haber, dbo.tTempListadoMayorGeneral.FactorDeCambio, dbo.tTempListadoMayorGeneral.CentroCosto, 
                      dbo.CentrosCosto.DescripcionCorta AS NombreCortoCentroCostos, dbo.tTempListadoMayorGeneral.NumeroUsuario, 
                      dbo.tTempListadoMayorGeneral.Cia
FROM         dbo.tTempListadoMayorGeneral LEFT OUTER JOIN
                      dbo.CentrosCosto ON dbo.tTempListadoMayorGeneral.CentroCosto = dbo.CentrosCosto.CentroCosto

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qReportMayorGeneralAmbasMonedas
AS
SELECT     dbo.tTempListadoMayorGeneralAmbasMonedas.ClaveUnica, dbo.tTempListadoMayorGeneralAmbasMonedas.Moneda, 
                      dbo.tTempListadoMayorGeneralAmbasMonedas.NombreMoneda, dbo.tTempListadoMayorGeneralAmbasMonedas.MonedaOriginal, 
                      dbo.tTempListadoMayorGeneralAmbasMonedas.NombreMonedaOriginal, dbo.tTempListadoMayorGeneralAmbasMonedas.Numero, 
                      dbo.tTempListadoMayorGeneralAmbasMonedas.Mes, dbo.tTempListadoMayorGeneralAmbasMonedas.Ano, 
                      dbo.tTempListadoMayorGeneralAmbasMonedas.Fecha, dbo.tTempListadoMayorGeneralAmbasMonedas.AnoMes, 
                      dbo.tTempListadoMayorGeneralAmbasMonedas.Partida, dbo.tTempListadoMayorGeneralAmbasMonedas.Cuenta, 
                      dbo.tTempListadoMayorGeneralAmbasMonedas.Descripcion, dbo.tTempListadoMayorGeneralAmbasMonedas.Referencia, 
                      dbo.tTempListadoMayorGeneralAmbasMonedas.DebeBs, dbo.tTempListadoMayorGeneralAmbasMonedas.HaberBs, 
                      dbo.tTempListadoMayorGeneralAmbasMonedas.DebeDol, dbo.tTempListadoMayorGeneralAmbasMonedas.HaberDol, 
                      dbo.tTempListadoMayorGeneralAmbasMonedas.FactorDeCambio, dbo.tTempListadoMayorGeneralAmbasMonedas.CentroCosto, 
                      dbo.CentrosCosto.DescripcionCorta AS NombreCortoCentroCostos, dbo.tTempListadoMayorGeneralAmbasMonedas.NumeroUsuario, 
                      dbo.tTempListadoMayorGeneralAmbasMonedas.Cia
FROM         dbo.tTempListadoMayorGeneralAmbasMonedas LEFT OUTER JOIN
                      dbo.CentrosCosto ON dbo.tTempListadoMayorGeneralAmbasMonedas.CentroCosto = dbo.CentrosCosto.CentroCosto

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qFormaAsientosSubForm    Script Date: 31/12/00 10:25:52 a.m. *****
***** Object:  View dbo.qFormaAsientosSubForm    Script Date: 28/11/00 07:01:21 p.m. *****
***** Object:  View dbo.qFormaAsientosSubForm    Script Date: 08/nov/00 9:01:17 ******/
CREATE VIEW dbo.qFormaAsientosSubForm
AS
SELECT     NumeroAutomatico, Numero, Mes, Ano, Fecha, Moneda, MonedaOriginal, ConvertirFlag, FactorDeCambio, Partida, Cuenta, Descripcion, Referencia, 
                      Debe, Haber, MesFiscal, AnoFiscal, CentroCosto, Cia
FROM         dbo.dAsientos

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qFormaAsientosSubFormConsulta    Script Date: 31/12/00 10:25:56 a.m. *****
***** Object:  View dbo.qFormaAsientosSubFormConsulta    Script Date: 28/11/00 07:01:21 p.m. *****
***** Object:  View dbo.qFormaAsientosSubFormConsulta    Script Date: 08/nov/00 9:01:17 ******/
CREATE VIEW dbo.qFormaAsientosSubFormConsulta
AS
SELECT     dbo.dAsientos.NumeroAutomatico, dbo.dAsientos.Numero, dbo.dAsientos.Mes, dbo.dAsientos.Ano, dbo.dAsientos.Fecha, dbo.dAsientos.Moneda, 
                      dbo.dAsientos.MonedaOriginal, dbo.dAsientos.ConvertirFlag, dbo.dAsientos.FactorDeCambio, dbo.dAsientos.Partida, dbo.dAsientos.Cuenta, 
                      dbo.dAsientos.Descripcion, dbo.dAsientos.Referencia, dbo.dAsientos.Debe, dbo.dAsientos.Haber, dbo.dAsientos.MesFiscal, dbo.dAsientos.AnoFiscal, 
                      dbo.CuentasContables.Descripcion AS NombreCuentaContable, dbo.CuentasContables.CuentaEditada, 
                      dbo.CentrosCosto.DescripcionCorta AS NombreCortoCentroCosto, dbo.dAsientos.CentroCosto, dbo.dAsientos.Cia
FROM         dbo.dAsientos LEFT OUTER JOIN
                      dbo.CentrosCosto ON dbo.dAsientos.CentroCosto = dbo.CentrosCosto.CentroCosto LEFT OUTER JOIN
                      dbo.CuentasContables ON dbo.dAsientos.Cuenta = dbo.CuentasContables.Cuenta AND dbo.dAsientos.Cia = dbo.CuentasContables.Cia

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoAsientos
AS
SELECT     dbo.dAsientos.Partida, dbo.dAsientos.Cuenta, dbo.dAsientos.Descripcion AS DescripcionPartida, dbo.dAsientos.Referencia, dbo.dAsientos.Debe, 
                      dbo.dAsientos.Haber, dbo.dAsientos.NumeroAutomatico, dbo.dAsientos.Numero, dbo.dAsientos.Mes, dbo.dAsientos.Ano, dbo.dAsientos.Fecha, 
                      dbo.dAsientos.Moneda, dbo.dAsientos.MonedaOriginal, dbo.dAsientos.ConvertirFlag, dbo.dAsientos.FactorDeCambio, dbo.dAsientos.MesFiscal, 
                      dbo.dAsientos.AnoFiscal, dbo.dAsientos.Cia, dbo.Asientos.Tipo, dbo.Asientos.TotalDebe, dbo.Asientos.TotalHaber, dbo.Asientos.Descripcion, 
                      dbo.Asientos.Ingreso, dbo.Asientos.UltAct, dbo.Asientos.CopiableFlag, dbo.Asientos.ProvieneDe, dbo.dAsientos.CentroCosto
FROM         dbo.dAsientos INNER JOIN
                      dbo.Asientos ON dbo.dAsientos.NumeroAutomatico = dbo.Asientos.NumeroAutomatico

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qListadoMayorGeneral    Script Date: 31/12/00 10:25:55 a.m. *****
***** Object:  View dbo.qListadoMayorGeneral    Script Date: 28/11/00 07:01:23 p.m. *****
***** Object:  View dbo.qListadoMayorGeneral    Script Date: 08/nov/00 9:01:18 ******/
CREATE VIEW dbo.qListadoMayorGeneral
AS
SELECT     dbo.dAsientos.Moneda, dbo.Monedas.Descripcion AS NombreMoneda, dbo.dAsientos.MonedaOriginal, 
                      MonedasOriginal.Descripcion AS NombreMonedaOriginal, dbo.dAsientos.Numero, dbo.dAsientos.Mes, dbo.dAsientos.Ano, dbo.dAsientos.MesFiscal, 
                      dbo.dAsientos.AnoFiscal, dbo.dAsientos.Fecha, CONVERT(Char(4), dbo.dAsientos.Ano) + { fn REPLACE(STR(dbo.dAsientos.Mes, 2), ' ', '0') } AS AnoMes, 
                      dbo.dAsientos.Partida, dbo.dAsientos.Cuenta, dbo.dAsientos.Descripcion, dbo.dAsientos.Referencia, dbo.dAsientos.Debe, dbo.dAsientos.Haber, 
                      dbo.dAsientos.FactorDeCambio, dbo.dAsientos.CentroCosto, dbo.dAsientos.Cia
FROM         dbo.dAsientos LEFT OUTER JOIN
                      dbo.Monedas ON dbo.dAsientos.Moneda = dbo.Monedas.Moneda LEFT OUTER JOIN
                      dbo.Monedas MonedasOriginal ON dbo.dAsientos.MonedaOriginal = MonedasOriginal.Moneda

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO





if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[dAsientosTemp]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[dAsientosTemp]
GO

CREATE TABLE [dbo].[dAsientosTemp] (
	[ClaveUnica] [int] IDENTITY (1, 1) NOT NULL ,
	[NumeroAutomatico] [int] NOT NULL ,
	[Numero] [smallint] NOT NULL ,
	[Mes] [tinyint] NOT NULL ,
	[Ano] [smallint] NOT NULL ,
	[Fecha] [datetime] NOT NULL ,
	[Moneda] [int] NOT NULL ,
	[MonedaOriginal] [int] NOT NULL ,
	[ConvertirFlag] [bit] NULL ,
	[FactorDeCambio] [money] NULL ,
	[Partida] [smallint] NOT NULL ,
	[Cuenta] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Descripcion] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Referencia] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Debe] [money] NOT NULL ,
	[Haber] [money] NOT NULL ,
	[MesFiscal] [smallint] NOT NULL ,
	[AnoFiscal] [smallint] NOT NULL ,
       CentroCosto int NULL,
	[Cia] [int] NOT NULL ,
	[NumeroUsuario] [int] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[dAsientosTemp] WITH NOCHECK ADD 
	CONSTRAINT [PK_dAsientosTemp] PRIMARY KEY  CLUSTERED 
	(
		[ClaveUnica]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [IX_dAsientosTemp] ON [dbo].[dAsientosTemp]([NumeroUsuario]) ON [PRIMARY]
GO




if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoDePagosSubReport]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoDePagosSubReport]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoDePagosSubReport
AS
SELECT     dbo.dPagos.ClaveUnicaPago, dbo.dPagos.MontoPagado, dbo.Facturas.NumeroFactura, dbo.Facturas.FechaEmision, dbo.Facturas.FechaRecepcion, 
                      dbo.Facturas.Concepto, dbo.Facturas.Iva, dbo.Facturas.TotalFactura
FROM         dbo.dPagos LEFT OUTER JOIN
                      dbo.Facturas ON dbo.dPagos.ClaveUnicaFactura = dbo.Facturas.ClaveUnica

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.178', GetDate()) 