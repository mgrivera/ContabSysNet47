/*    Viernes, 11 de Febrero de 2.005   -   v0.00.166.sql 

	Hacemos unos cambios menores a la tabla tTempListadoBalanceGeneral. 

*/ 


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoBalanceGeneral]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoBalanceGeneral]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tTempListadoBalanceGeneral]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tTempListadoBalanceGeneral]
GO

CREATE TABLE [dbo].[tTempListadoBalanceGeneral] (
	[ClaveUnica] [int] IDENTITY (1, 1) NOT NULL ,
	[Moneda] [int] NULL ,
	[MonedaOriginal] [int] NULL ,
	[Cuenta] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaEditada] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Descripcion] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Estructura] [int] NULL ,
	[TotDet] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SaldoInicial] [money] NULL ,
	[SaldoActual] [money] NULL ,
	[Debe] [money] NULL ,
	[Haber] [money] NULL ,
	[SumOfSaldoInicial] [money] NULL ,
	[SumOfSaldoActual] [money] NULL ,
	[SumOfDebe] [money] NULL ,
	[SumOfHaber] [money] NULL ,
	[SumOfSaldoInicialAct] [money] NULL ,
	[SumOfSaldoActualAct] [money] NULL ,
	[SumOfDebeAct] [money] NULL ,
	[SumOfHaberAct] [money] NULL ,
	[SumOfSaldoInicialPasYCap] [money] NULL ,
	[SumOfSaldoActualPasYCap] [money] NULL ,
	[SumOfDebePasYCap] [money] NULL ,
	[SumOfHaberPasYCap] [money] NULL ,
	[Nivel1] [smallint] NULL ,
	[Nivel2] [smallint] NULL ,
	[Nivel3] [smallint] NULL ,
	[Nivel4] [smallint] NULL ,
	[Nivel5] [smallint] NULL ,
	[Nivel6] [smallint] NULL ,
	[Nivel7] [smallint] NULL ,
	[NumNiveles] [tinyint] NULL ,
	[Grupo] [int] NULL ,
	[OrdenBalanceGeneral] [smallint] NULL ,
	[NumeroUsuario] [int] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tTempListadoBalanceGeneral] ADD 
	CONSTRAINT [PK_tTempListadoBalanceGeneral] PRIMARY KEY  NONCLUSTERED 
	(
		[ClaveUnica]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [IX_tTempListadoBalanceGeneral] ON [dbo].[tTempListadoBalanceGeneral]([NumeroUsuario]) ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qListadoBalanceGeneral    Script Date: 31/12/00 10:25:54 a.m. *****
***** Object:  View dbo.qListadoBalanceGeneral    Script Date: 28/11/00 07:01:18 p.m. *****
***** Object:  View dbo.qListadoBalanceGeneral    Script Date: 08/nov/00 9:01:17 *****
*/
CREATE VIEW dbo.qListadoBalanceGeneral
AS
SELECT     dbo.tTempListadoBalanceGeneral.Moneda, ISNULL(dbo.Monedas.Descripcion, 'null value') AS NombreMoneda, 
                      dbo.Monedas.Simbolo AS SimboloMoneda, dbo.tTempListadoBalanceGeneral.MonedaOriginal, ISNULL(MonedasOriginal.Descripcion, 'null value') 
                      AS NombreMonedaOriginal, MonedasOriginal.Simbolo AS SimboloMonedaOriginal, dbo.tTempListadoBalanceGeneral.OrdenBalanceGeneral, 
                      dbo.tTempListadoBalanceGeneral.Grupo, dbo.tGruposContables.Descripcion AS NombreGrupoContable, dbo.tTempListadoBalanceGeneral.Cuenta, 
                      dbo.tTempListadoBalanceGeneral.CuentaEditada, dbo.tTempListadoBalanceGeneral.Descripcion, dbo.tTempListadoBalanceGeneral.Estructura, 
                      dbo.tTempListadoBalanceGeneral.TotDet, dbo.tTempListadoBalanceGeneral.SaldoInicial, dbo.tTempListadoBalanceGeneral.SaldoActual, 
                      dbo.tTempListadoBalanceGeneral.SaldoActual - dbo.tTempListadoBalanceGeneral.SaldoInicial AS MovimientoDelMes, 
                      dbo.tTempListadoBalanceGeneral.Debe, dbo.tTempListadoBalanceGeneral.Haber, dbo.tTempListadoBalanceGeneral.Nivel1, 
                      dbo.tTempListadoBalanceGeneral.Nivel2, dbo.tTempListadoBalanceGeneral.Nivel3, dbo.tTempListadoBalanceGeneral.Nivel4, 
                      dbo.tTempListadoBalanceGeneral.Nivel5, dbo.tTempListadoBalanceGeneral.Nivel6, dbo.tTempListadoBalanceGeneral.Nivel7, 
                      dbo.tTempListadoBalanceGeneral.NumNiveles, dbo.tTempListadoBalanceGeneral.SumOfSaldoInicial, 
                      dbo.tTempListadoBalanceGeneral.SumOfSaldoActual, dbo.tTempListadoBalanceGeneral.SumOfDebe, dbo.tTempListadoBalanceGeneral.SumOfHaber, 
                      dbo.tTempListadoBalanceGeneral.SumOfSaldoInicialAct, dbo.tTempListadoBalanceGeneral.SumOfSaldoActualAct, 
                      dbo.tTempListadoBalanceGeneral.SumOfDebeAct, dbo.tTempListadoBalanceGeneral.SumOfHaberAct, 
                      dbo.tTempListadoBalanceGeneral.SumOfSaldoInicialPasYCap, dbo.tTempListadoBalanceGeneral.SumOfSaldoActualPasYCap, 
                      dbo.tTempListadoBalanceGeneral.SumOfDebePasYCap, dbo.tTempListadoBalanceGeneral.SumOfHaberPasYCap, 
                      dbo.tTempListadoBalanceGeneral.NumeroUsuario
FROM         dbo.tTempListadoBalanceGeneral INNER JOIN
                      dbo.tGruposContables ON dbo.tTempListadoBalanceGeneral.Grupo = dbo.tGruposContables.Grupo LEFT OUTER JOIN
                      dbo.Monedas ON dbo.tTempListadoBalanceGeneral.Moneda = dbo.Monedas.Moneda LEFT OUTER JOIN
                      dbo.Monedas MonedasOriginal ON dbo.tTempListadoBalanceGeneral.MonedaOriginal = MonedasOriginal.Moneda

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.166', GetDate()) 

