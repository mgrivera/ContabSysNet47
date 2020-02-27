/*    Sabado, 10 de Octubre de 2.011  -   v0.00.287a.sql 

	Agregamos cambios a Views y Tablas 'temporales' (de uso temporal)
*/


drop view qFormaCuentasContables


/****** Object:  View [dbo].[qFormaAsientosSubFormConsulta]    Script Date: 10/10/2011 18:15:44 ******/
DROP VIEW [dbo].[qFormaAsientosSubFormConsulta]
GO
/****** Object:  View [dbo].[qListadoAsientos]    Script Date: 10/10/2011 18:15:44 ******/
DROP VIEW [dbo].[qListadoAsientos]
GO
/****** Object:  View [dbo].[qListadoMayorGeneral]    Script Date: 10/10/2011 18:15:44 ******/
DROP VIEW [dbo].[qListadoMayorGeneral]
GO
/****** Object:  View [dbo].[qFormaCuentasBancariasConsulta]    Script Date: 10/10/2011 18:15:44 ******/
DROP VIEW [dbo].[qFormaCuentasBancariasConsulta]
GO
/****** Object:  View [dbo].[qConsultaSaldosCuentasContables]    Script Date: 10/10/2011 18:15:44 ******/
DROP VIEW [dbo].[qConsultaSaldosCuentasContables]
GO
/****** Object:  View [dbo].[qReportListadoAsientos]    Script Date: 10/10/2011 18:15:44 ******/
DROP VIEW [dbo].[qReportListadoAsientos]
GO
/****** Object:  View [dbo].[qReportMayorGeneral]    Script Date: 10/10/2011 18:15:44 ******/
DROP VIEW [dbo].[qReportMayorGeneral]
GO
/****** Object:  View [dbo].[qReportMayorGeneralAmbasMonedas]    Script Date: 10/10/2011 18:15:44 ******/
DROP VIEW [dbo].[qReportMayorGeneralAmbasMonedas]
GO
/****** Object:  Table [dbo].[tTempListadoAsientos]    Script Date: 10/10/2011 18:15:43 ******/
DROP TABLE [dbo].[tTempListadoAsientos]
GO
/****** Object:  Table [dbo].[tTempListadoBalanceComprobacion]    Script Date: 10/10/2011 18:15:43 ******/
DROP TABLE [dbo].[tTempListadoBalanceComprobacion]
GO
/****** Object:  Table [dbo].[tTempListadoBalanceGeneral]    Script Date: 10/10/2011 18:15:43 ******/
DROP TABLE [dbo].[tTempListadoBalanceGeneral]
GO
/****** Object:  Table [dbo].[tTempListadoBalanceGeneralCero]    Script Date: 10/10/2011 18:15:43 ******/
DROP TABLE [dbo].[tTempListadoBalanceGeneralCero]
GO
/****** Object:  Table [dbo].[tTempListadoMayorGeneral]    Script Date: 10/10/2011 18:15:43 ******/
DROP TABLE [dbo].[tTempListadoMayorGeneral]
GO
/****** Object:  Table [dbo].[tTempListadoMayorGeneralAmbasMonedas]    Script Date: 10/10/2011 18:15:43 ******/
DROP TABLE [dbo].[tTempListadoMayorGeneralAmbasMonedas]
GO
/****** Object:  Table [dbo].[dAsientosTemp]    Script Date: 10/10/2011 18:15:43 ******/
DROP TABLE [dbo].[dAsientosTemp]
GO
/****** Object:  Table [dbo].[dAsientosTemp]    Script Date: 10/10/2011 18:15:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dAsientosTemp](
	[ClaveUnica] [int] IDENTITY(1,1) NOT NULL,
	[NumeroAutomatico] [int] NOT NULL,
	[Partida] [smallint] NOT NULL,
	[CuentaContableID] [int] NOT NULL,
	[Descripcion] [nvarchar](50) NULL,
	[Referencia] [nvarchar](20) NULL,
	[Debe] [money] NOT NULL,
	[Haber] [money] NOT NULL,
	[CentroCosto] [int] NULL,
	[NumeroUsuario] [int] NULL,
 CONSTRAINT [PK_dAsientosTemp] PRIMARY KEY CLUSTERED 
(
	[ClaveUnica] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_dAsientosTemp] ON [dbo].[dAsientosTemp] 
(
	[NumeroUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tTempListadoMayorGeneralAmbasMonedas]    Script Date: 10/10/2011 18:15:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tTempListadoMayorGeneralAmbasMonedas](
	[ClaveUnica] [int] IDENTITY(1,1) NOT NULL,
	[Moneda] [int] NULL,
	[NombreMoneda] [nvarchar](50) NULL,
	[MonedaOriginal] [int] NULL,
	[NombreMonedaOriginal] [nvarchar](50) NULL,
	[Numero] [smallint] NULL,
	[Mes] [smallint] NULL,
	[Ano] [smallint] NULL,
	[Fecha] [datetime] NULL,
	[AnoMes] [nvarchar](6) NULL,
	[Partida] [smallint] NULL,
	[CuentaContableID] [int] NULL,
	[Cuenta] [nvarchar](50) NULL,
	[Descripcion] [nvarchar](50) NULL,
	[Referencia] [nvarchar](20) NULL,
	[DebeBs] [money] NULL,
	[HaberBs] [money] NULL,
	[DebeDol] [money] NULL,
	[HaberDol] [money] NULL,
	[FactorDeCambio] [money] NULL,
	[CentroCosto] [int] NULL,
	[NumeroUsuario] [int] NULL,
	[Cia] [int] NOT NULL,
 CONSTRAINT [PK_tTempListadoMayorGeneralAmbasMonedas] PRIMARY KEY NONCLUSTERED 
(
	[ClaveUnica] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tTempListadoMayorGeneralAmbasMonedas] ON [dbo].[tTempListadoMayorGeneralAmbasMonedas] 
(
	[NumeroUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tTempListadoMayorGeneral]    Script Date: 10/10/2011 18:15:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tTempListadoMayorGeneral](
	[ClaveUnica] [int] IDENTITY(1,1) NOT NULL,
	[Moneda] [int] NULL,
	[NombreMoneda] [nvarchar](50) NULL,
	[MonedaOriginal] [int] NULL,
	[NombreMonedaOriginal] [nvarchar](50) NULL,
	[Numero] [smallint] NULL,
	[Mes] [smallint] NULL,
	[Ano] [smallint] NULL,
	[Fecha] [datetime] NULL,
	[AnoMes] [nvarchar](6) NULL,
	[Partida] [smallint] NULL,
	[CuentaContableID] [int] NULL,
	[Cuenta] [nvarchar](50) NULL,
	[Descripcion] [nvarchar](50) NULL,
	[Referencia] [nvarchar](20) NULL,
	[Debe] [money] NULL,
	[Haber] [money] NULL,
	[FactorDeCambio] [money] NULL,
	[CentroCosto] [int] NULL,
	[NumeroUsuario] [int] NOT NULL,
	[Cia] [int] NOT NULL,
 CONSTRAINT [PK_tTempListadoMayorGeneral] PRIMARY KEY NONCLUSTERED 
(
	[ClaveUnica] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tTempListadoMayorGeneral] ON [dbo].[tTempListadoMayorGeneral] 
(
	[NumeroUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tTempListadoBalanceGeneralCero]    Script Date: 10/10/2011 18:15:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tTempListadoBalanceGeneralCero](
	[ClaveUnica] [int] IDENTITY(1,1) NOT NULL,
	[Moneda] [int] NULL,
	[MonedaOriginal] [int] NULL,
	[CuentaContableID] [int] NULL,
	[Cuenta] [nvarchar](25) NULL,
	[SaldoInicial] [money] NULL,
	[SaldoActual] [money] NULL,
	[NumeroUsuario] [int] NULL,
 CONSTRAINT [PK_tTempListadoBalanceGeneralCero] PRIMARY KEY NONCLUSTERED 
(
	[ClaveUnica] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tTempListadoBalanceGeneralCero] ON [dbo].[tTempListadoBalanceGeneralCero] 
(
	[NumeroUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tTempListadoBalanceGeneral]    Script Date: 10/10/2011 18:15:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tTempListadoBalanceGeneral](
	[ClaveUnica] [int] IDENTITY(1,1) NOT NULL,
	[Moneda] [int] NULL,
	[MonedaOriginal] [int] NULL,
	[CuentaContableID] [int] NULL,
	[Cuenta] [nvarchar](25) NULL,
	[CuentaEditada] [nvarchar](30) NULL,
	[Descripcion] [nvarchar](40) NULL,
	[Estructura] [int] NULL,
	[TotDet] [nvarchar](1) NULL,
	[SaldoInicial] [money] NULL,
	[SaldoActual] [money] NULL,
	[Debe] [money] NULL,
	[Haber] [money] NULL,
	[SumOfSaldoInicial] [money] NULL,
	[SumOfSaldoActual] [money] NULL,
	[SumOfDebe] [money] NULL,
	[SumOfHaber] [money] NULL,
	[SumOfSaldoInicialAct] [money] NULL,
	[SumOfSaldoActualAct] [money] NULL,
	[SumOfDebeAct] [money] NULL,
	[SumOfHaberAct] [money] NULL,
	[SumOfSaldoInicialPasYCap] [money] NULL,
	[SumOfSaldoActualPasYCap] [money] NULL,
	[SumOfDebePasYCap] [money] NULL,
	[SumOfHaberPasYCap] [money] NULL,
	[Nivel1] [smallint] NULL,
	[Nivel2] [smallint] NULL,
	[Nivel3] [smallint] NULL,
	[Nivel4] [smallint] NULL,
	[Nivel5] [smallint] NULL,
	[Nivel6] [smallint] NULL,
	[Nivel7] [smallint] NULL,
	[NumNiveles] [tinyint] NULL,
	[Grupo] [int] NULL,
	[OrdenBalanceGeneral] [smallint] NULL,
	[NumeroUsuario] [int] NULL,
 CONSTRAINT [PK_tTempListadoBalanceGeneral] PRIMARY KEY NONCLUSTERED 
(
	[ClaveUnica] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tTempListadoBalanceGeneral] ON [dbo].[tTempListadoBalanceGeneral] 
(
	[NumeroUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tTempListadoBalanceComprobacion]    Script Date: 10/10/2011 18:15:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tTempListadoBalanceComprobacion](
	[ClaveUnica] [int] IDENTITY(1,1) NOT NULL,
	[CuentaContableID] [int] NULL,
	[Cuenta] [nvarchar](25) NULL,
	[Nivel1] [nvarchar](10) NULL,
	[NombreNivel1] [nvarchar](50) NULL,
	[Nivel2] [nvarchar](10) NULL,
	[NombreNivel2] [nvarchar](50) NULL,
	[Nivel3] [nvarchar](10) NULL,
	[NombreNivel3] [nvarchar](50) NULL,
	[Nivel4] [nvarchar](10) NULL,
	[NombreNivel4] [nvarchar](50) NULL,
	[Nivel5] [nvarchar](10) NULL,
	[NombreNivel5] [nvarchar](50) NULL,
	[Nivel6] [nvarchar](10) NULL,
	[NombreNivel6] [nvarchar](50) NULL,
	[CuentaEditada] [nvarchar](30) NULL,
	[Descripcion] [nvarchar](40) NULL,
	[Moneda] [smallint] NULL,
	[NombreMoneda] [nvarchar](50) NULL,
	[SimboloMoneda] [nvarchar](6) NULL,
	[MonedaOriginal] [int] NULL,
	[NombreMonedaOriginal] [nvarchar](50) NULL,
	[SimboloMonedaOriginal] [nvarchar](6) NULL,
	[SaldoInicial] [float] NULL,
	[Debe] [money] NULL,
	[Haber] [money] NULL,
	[SaldoActual] [money] NULL,
	[SinAsientosFlag] [bit] NULL,
	[NumeroUsuario] [int] NULL,
 CONSTRAINT [PK_tTempListadoBalanceComprobacion] PRIMARY KEY NONCLUSTERED 
(
	[ClaveUnica] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tTempListadoBalanceComprobacion] ON [dbo].[tTempListadoBalanceComprobacion] 
(
	[NumeroUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tTempListadoAsientos]    Script Date: 10/10/2011 18:15:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tTempListadoAsientos](
	[ClaveUnica] [int] IDENTITY(1,1) NOT NULL,
	[NumeroAutomatico] [int] NULL,
	[Numero] [int] NULL,
	[Fecha] [datetime] NULL,
	[Tipo] [nvarchar](6) NULL,
	[Moneda] [int] NULL,
	[NombreMoneda] [nvarchar](50) NULL,
	[SimboloMoneda] [nvarchar](6) NULL,
	[MonedaOriginal] [int] NULL,
	[NombreMonedaOriginal] [nvarchar](50) NULL,
	[SimboloMonedaOriginal] [nvarchar](6) NULL,
	[DescripcionComprobante] [ntext] NULL,
	[NumPartidas] [smallint] NULL,
	[Partida] [smallint] NULL,
	[CuentaContableID] [int] NULL,
	[CuentaContable] [nvarchar](25) NULL,
	[DescripcionPartida] [nvarchar](50) NULL,
	[Referencia] [nvarchar](20) NULL,
	[Debe] [money] NULL,
	[Haber] [money] NULL,
	[NombreCuenta] [nvarchar](40) NULL,
	[CuentaEditada] [nvarchar](30) NULL,
	[Mes] [smallint] NULL,
	[Ano] [smallint] NULL,
	[NumeroUsuario] [int] NULL,
	[DebeDolares] [money] NULL,
	[HaberDolares] [money] NULL,
	[FactorDeCambio] [money] NULL,
	[CentroCosto] [int] NULL,
 CONSTRAINT [PK_tTempListadoAsientos] PRIMARY KEY NONCLUSTERED 
(
	[ClaveUnica] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tTempListadoAsientos] ON [dbo].[tTempListadoAsientos] 
(
	[NumeroUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  View [dbo].[qReportMayorGeneralAmbasMonedas]    Script Date: 10/10/2011 18:15:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qReportMayorGeneralAmbasMonedas]
AS
SELECT     dbo.tTempListadoMayorGeneralAmbasMonedas.ClaveUnica, dbo.tTempListadoMayorGeneralAmbasMonedas.Moneda, 
                      dbo.tTempListadoMayorGeneralAmbasMonedas.NombreMoneda, dbo.tTempListadoMayorGeneralAmbasMonedas.MonedaOriginal, 
                      dbo.tTempListadoMayorGeneralAmbasMonedas.NombreMonedaOriginal, dbo.tTempListadoMayorGeneralAmbasMonedas.Numero, 
                      dbo.tTempListadoMayorGeneralAmbasMonedas.Mes, dbo.tTempListadoMayorGeneralAmbasMonedas.Ano, 
                      dbo.tTempListadoMayorGeneralAmbasMonedas.Fecha, dbo.tTempListadoMayorGeneralAmbasMonedas.AnoMes, 
                      dbo.tTempListadoMayorGeneralAmbasMonedas.Partida, dbo.tTempListadoMayorGeneralAmbasMonedas.CuentaContableID, 
                      dbo.tTempListadoMayorGeneralAmbasMonedas.Cuenta, dbo.tTempListadoMayorGeneralAmbasMonedas.Descripcion, 
                      dbo.tTempListadoMayorGeneralAmbasMonedas.Referencia, dbo.tTempListadoMayorGeneralAmbasMonedas.DebeBs, 
                      dbo.tTempListadoMayorGeneralAmbasMonedas.HaberBs, dbo.tTempListadoMayorGeneralAmbasMonedas.DebeDol, 
                      dbo.tTempListadoMayorGeneralAmbasMonedas.HaberDol, dbo.tTempListadoMayorGeneralAmbasMonedas.FactorDeCambio, 
                      dbo.tTempListadoMayorGeneralAmbasMonedas.CentroCosto, dbo.CentrosCosto.DescripcionCorta AS NombreCortoCentroCostos, 
                      dbo.tTempListadoMayorGeneralAmbasMonedas.NumeroUsuario, dbo.tTempListadoMayorGeneralAmbasMonedas.Cia
FROM         dbo.tTempListadoMayorGeneralAmbasMonedas LEFT OUTER JOIN
                      dbo.CentrosCosto ON dbo.tTempListadoMayorGeneralAmbasMonedas.CentroCosto = dbo.CentrosCosto.CentroCosto
GO
/****** Object:  View [dbo].[qReportMayorGeneral]    Script Date: 10/10/2011 18:15:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qReportMayorGeneral]
AS
SELECT     dbo.tTempListadoMayorGeneral.ClaveUnica, dbo.tTempListadoMayorGeneral.Moneda, dbo.tTempListadoMayorGeneral.NombreMoneda, 
                      dbo.tTempListadoMayorGeneral.MonedaOriginal, dbo.tTempListadoMayorGeneral.NombreMonedaOriginal, dbo.tTempListadoMayorGeneral.Numero, 
                      dbo.tTempListadoMayorGeneral.Mes, dbo.tTempListadoMayorGeneral.Ano, dbo.tTempListadoMayorGeneral.Fecha, 
                      dbo.tTempListadoMayorGeneral.AnoMes, dbo.tTempListadoMayorGeneral.Partida, dbo.tTempListadoMayorGeneral.CuentaContableID, 
                      dbo.tTempListadoMayorGeneral.Cuenta, dbo.tTempListadoMayorGeneral.Descripcion, dbo.tTempListadoMayorGeneral.Referencia, 
                      dbo.tTempListadoMayorGeneral.Debe, dbo.tTempListadoMayorGeneral.Haber, dbo.tTempListadoMayorGeneral.FactorDeCambio, 
                      dbo.tTempListadoMayorGeneral.CentroCosto, dbo.CentrosCosto.DescripcionCorta AS NombreCortoCentroCostos, 
                      dbo.tTempListadoMayorGeneral.NumeroUsuario, dbo.tTempListadoMayorGeneral.Cia
FROM         dbo.tTempListadoMayorGeneral LEFT OUTER JOIN
                      dbo.CentrosCosto ON dbo.tTempListadoMayorGeneral.CentroCosto = dbo.CentrosCosto.CentroCosto
GO
/****** Object:  View [dbo].[qReportListadoAsientos]    Script Date: 10/10/2011 18:15:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View dbo.qReportListadoAsientos    Script Date: 31/12/00 10:25:55 a.m. ******/
CREATE VIEW [dbo].[qReportListadoAsientos]
AS
SELECT     dbo.tTempListadoAsientos.Numero, dbo.tTempListadoAsientos.Fecha, dbo.tTempListadoAsientos.Tipo, dbo.tTempListadoAsientos.Moneda, 
                      dbo.tTempListadoAsientos.NombreMoneda, dbo.tTempListadoAsientos.SimboloMoneda, dbo.tTempListadoAsientos.MonedaOriginal, 
                      dbo.tTempListadoAsientos.NombreMonedaOriginal, dbo.tTempListadoAsientos.SimboloMonedaOriginal, 
                      dbo.tTempListadoAsientos.DescripcionComprobante, dbo.tTempListadoAsientos.NumPartidas, dbo.tTempListadoAsientos.Partida, 
                      dbo.tTempListadoAsientos.CuentaContable, dbo.tTempListadoAsientos.DescripcionPartida, dbo.tTempListadoAsientos.Referencia, 
                      dbo.tTempListadoAsientos.Debe, dbo.tTempListadoAsientos.Haber, dbo.tTempListadoAsientos.NombreCuenta, 
                      dbo.tTempListadoAsientos.CuentaEditada, dbo.tTempListadoAsientos.Mes, dbo.tTempListadoAsientos.Ano, dbo.tTempListadoAsientos.NumeroUsuario, 
                      dbo.tTempListadoAsientos.NumeroAutomatico, dbo.tTempListadoAsientos.ClaveUnica, dbo.tTempListadoAsientos.DebeDolares, 
                      dbo.tTempListadoAsientos.HaberDolares, dbo.tTempListadoAsientos.FactorDeCambio, dbo.tTempListadoAsientos.CentroCosto, 
                      dbo.CentrosCosto.DescripcionCorta AS NombreCortoCentroCostos
FROM         dbo.tTempListadoAsientos LEFT OUTER JOIN
                      dbo.CentrosCosto ON dbo.tTempListadoAsientos.CentroCosto = dbo.CentrosCosto.CentroCosto
GO
/****** Object:  View [dbo].[qConsultaSaldosCuentasContables]    Script Date: 10/10/2011 18:15:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View dbo.qConsultaSaldosCuentasContables    Script Date: 31/12/00 10:25:57 a.m. *****
***** Object:  View dbo.qConsultaSaldosCuentasContables    Script Date: 28/11/00 07:01:23 p.m. *****
***** Object:  View dbo.qConsultaSaldosCuentasContables    Script Date: 08/nov/00 9:01:18 ******/
CREATE VIEW [dbo].[qConsultaSaldosCuentasContables]
AS
SELECT     dbo.CuentasContables.Cuenta, dbo.CuentasContables.CuentaEditada, dbo.CuentasContables.Descripcion, dbo.CuentasContables.NumNiveles, 
                      dbo.CuentasContables.TotDet, dbo.CuentasContables.ActSusp, dbo.SaldosContables.Ano, dbo.SaldosContables.Moneda, 
                      dbo.Monedas.Simbolo AS SimboloMoneda, dbo.Monedas.Descripcion AS NombreMoneda, dbo.SaldosContables.MonedaOriginal, 
                      MonedasOriginal.Descripcion AS NombreMonedaOriginal, MonedasOriginal.Simbolo AS SimboloMonedaOriginal, dbo.SaldosContables.Inicial, 
                      dbo.SaldosContables.Mes01, dbo.SaldosContables.Mes02, dbo.SaldosContables.Mes03, dbo.SaldosContables.Mes04, dbo.SaldosContables.Mes05, 
                      dbo.SaldosContables.Mes06, dbo.SaldosContables.Mes07, dbo.SaldosContables.Mes08, dbo.SaldosContables.Mes09, dbo.SaldosContables.Mes10, 
                      dbo.SaldosContables.Mes11, dbo.SaldosContables.Mes12, dbo.SaldosContables.Anual, dbo.SaldosContables.Cia
FROM         dbo.SaldosContables LEFT OUTER JOIN
                      dbo.CuentasContables ON dbo.SaldosContables.CuentaContableID = dbo.CuentasContables.ID LEFT OUTER JOIN
                      dbo.Monedas ON dbo.SaldosContables.Moneda = dbo.Monedas.Moneda LEFT OUTER JOIN
                      dbo.Monedas AS MonedasOriginal ON dbo.SaldosContables.MonedaOriginal = MonedasOriginal.Moneda
GO
/****** Object:  View [dbo].[qFormaCuentasBancariasConsulta]    Script Date: 10/10/2011 18:15:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View dbo.qFormaCuentasBancariasConsulta    Script Date: 28/11/00 07:01:24 p.m. *****
***** Object:  View dbo.qFormaCuentasBancariasConsulta    Script Date: 08/nov/00 9:01:18 *****
***** Object:  View dbo.qFormaCuentasBancariasConsulta    Script Date: 30/sep/00 1:10:01 ******/
CREATE VIEW [dbo].[qFormaCuentasBancariasConsulta]
AS
SELECT     dbo.CuentasBancarias.CuentaInterna, dbo.CuentasBancarias.Agencia, dbo.Agencias.Nombre AS NombreAgencia, 
                      dbo.CuentasBancarias.CuentaBancaria, dbo.CuentasBancarias.Tipo, dbo.CuentasBancarias.Moneda, dbo.Monedas.Simbolo AS SimboloMoneda, 
                      dbo.CuentasBancarias.LineaCredito, dbo.CuentasBancarias.Estado, dbo.CuentasBancarias.Banco, dbo.Bancos.Nombre AS NombreBanco, 
                      dbo.CuentasContables.Cuenta AS CuentaContable, CuentasContables_1.Cuenta AS CuentaContableGastosIDB, 
                      dbo.CuentasBancarias.FormatoImpresionCheque, dbo.CuentasBancarias.GenerarTransaccionesAOtraCuentaFlag, 
                      dbo.CuentasBancarias.CuentaBancariaAsociada, dbo.CuentasBancarias.NombrePlantillaWord, dbo.CuentasBancarias.Cia
FROM         dbo.CuentasBancarias INNER JOIN
                      dbo.Bancos ON dbo.CuentasBancarias.Banco = dbo.Bancos.Banco INNER JOIN
                      dbo.Agencias ON dbo.CuentasBancarias.Agencia = dbo.Agencias.Agencia INNER JOIN
                      dbo.Monedas ON dbo.CuentasBancarias.Moneda = dbo.Monedas.Moneda LEFT OUTER JOIN
                      dbo.CuentasContables AS CuentasContables_1 ON dbo.CuentasBancarias.CuentaContableGastosIDB = CuentasContables_1.ID LEFT OUTER JOIN
                      dbo.CuentasContables ON dbo.CuentasBancarias.CuentaContable = dbo.CuentasContables.ID
GO
/****** Object:  View [dbo].[qListadoMayorGeneral]    Script Date: 10/10/2011 18:15:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View dbo.qListadoMayorGeneral    Script Date: 31/12/00 10:25:55 a.m. *****
***** Object:  View dbo.qListadoMayorGeneral    Script Date: 28/11/00 07:01:23 p.m. *****
***** Object:  View dbo.qListadoMayorGeneral    Script Date: 08/nov/00 9:01:18 ******/
CREATE VIEW [dbo].[qListadoMayorGeneral]
AS
SELECT     dbo.Asientos.Moneda, dbo.Monedas.Descripcion AS NombreMoneda, dbo.Asientos.MonedaOriginal, 
                      MonedasOriginal.Descripcion AS NombreMonedaOriginal, dbo.Asientos.Numero, dbo.Asientos.Mes, dbo.Asientos.Ano, dbo.Asientos.MesFiscal, 
                      dbo.Asientos.AnoFiscal, dbo.Asientos.Fecha, CONVERT(Char(4), dbo.Asientos.Ano) + { fn REPLACE(STR(dbo.Asientos.Mes, 2), ' ', '0') } AS AnoMes, 
                      dbo.dAsientos.Partida, dbo.dAsientos.CuentaContableID, dbo.CuentasContables.Cuenta, dbo.dAsientos.Descripcion, dbo.dAsientos.Referencia, 
                      dbo.dAsientos.Debe, dbo.dAsientos.Haber, dbo.Asientos.FactorDeCambio, dbo.dAsientos.CentroCosto, dbo.Asientos.Cia, 
                      dbo.Asientos.AsientoTipoCierreAnualFlag
FROM         dbo.dAsientos INNER JOIN
                      dbo.Asientos ON dbo.dAsientos.NumeroAutomatico = dbo.Asientos.NumeroAutomatico INNER JOIN
                      dbo.CuentasContables ON dbo.dAsientos.CuentaContableID = dbo.CuentasContables.ID LEFT OUTER JOIN
                      dbo.Monedas AS MonedasOriginal ON dbo.Asientos.MonedaOriginal = MonedasOriginal.Moneda LEFT OUTER JOIN
                      dbo.Monedas ON dbo.Asientos.Moneda = dbo.Monedas.Moneda
GO
/****** Object:  View [dbo].[qListadoAsientos]    Script Date: 10/10/2011 18:15:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qListadoAsientos]
AS
SELECT     dbo.dAsientos.Partida, dbo.dAsientos.CuentaContableID, dbo.CuentasContables.Cuenta, dbo.CuentasContables.CuentaEditada, 
                      dbo.dAsientos.Descripcion AS DescripcionPartida, dbo.dAsientos.Referencia, dbo.dAsientos.Debe, dbo.dAsientos.Haber, 
                      dbo.dAsientos.NumeroAutomatico, dbo.Asientos.Numero, dbo.Asientos.Mes, dbo.Asientos.Ano, dbo.Asientos.Fecha, dbo.Asientos.Moneda, 
                      dbo.Asientos.MonedaOriginal, dbo.Asientos.ConvertirFlag, dbo.Asientos.FactorDeCambio, dbo.Asientos.MesFiscal, dbo.Asientos.AnoFiscal, 
                      dbo.Asientos.Cia, dbo.Asientos.Tipo, dbo.Asientos.Descripcion, dbo.Asientos.Ingreso, dbo.Asientos.UltAct, dbo.Asientos.CopiableFlag, 
                      dbo.Asientos.ProvieneDe, dbo.dAsientos.CentroCosto, dbo.Asientos.Usuario
FROM         dbo.dAsientos INNER JOIN
                      dbo.Asientos ON dbo.dAsientos.NumeroAutomatico = dbo.Asientos.NumeroAutomatico INNER JOIN
                      dbo.CuentasContables ON dbo.dAsientos.CuentaContableID = dbo.CuentasContables.ID
GO
/****** Object:  View [dbo].[qFormaAsientosSubFormConsulta]    Script Date: 10/10/2011 18:15:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View dbo.qFormaAsientosSubFormConsulta    Script Date: 31/12/00 10:25:56 a.m. *****
***** Object:  View dbo.qFormaAsientosSubFormConsulta    Script Date: 28/11/00 07:01:21 p.m. *****
***** Object:  View dbo.qFormaAsientosSubFormConsulta    Script Date: 08/nov/00 9:01:17 ******/
CREATE VIEW [dbo].[qFormaAsientosSubFormConsulta]
AS
SELECT     dbo.dAsientos.NumeroAutomatico, dbo.dAsientos.Partida, dbo.CuentasContables.Cuenta, dbo.dAsientos.Descripcion, dbo.dAsientos.Referencia, 
                      dbo.dAsientos.Debe, dbo.dAsientos.Haber, dbo.CuentasContables.Descripcion AS NombreCuentaContable, dbo.CuentasContables.CuentaEditada, 
                      dbo.CentrosCosto.DescripcionCorta AS NombreCortoCentroCosto, dbo.dAsientos.CentroCosto, dbo.CuentasContables.Cia
FROM         dbo.dAsientos LEFT OUTER JOIN
                      dbo.CentrosCosto ON dbo.dAsientos.CentroCosto = dbo.CentrosCosto.CentroCosto LEFT OUTER JOIN
                      dbo.CuentasContables ON dbo.dAsientos.CuentaContableID = dbo.CuentasContables.ID
GO




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion
Insert Into tVersion(VersionActual, Fecha) Values('v0.00.287', GetDate()) 