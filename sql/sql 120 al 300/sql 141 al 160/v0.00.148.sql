/*    Lunes, 24 de Marzo de 2003   -   v0.00.148.sql 

	Hacemos un pequeño cambio a view qListadoBalanceGeneral para implementar la 
	posibilidad de obtener el balance general y el estado de GyP en Excel. 

*/ 


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoBalanceGeneral]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoBalanceGeneral]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qListadoBalanceGeneral    Script Date: 31/12/00 10:25:54 a.m. *****
***** Object:  View dbo.qListadoBalanceGeneral    Script Date: 28/11/00 07:01:18 p.m. *****
***** Object:  View dbo.qListadoBalanceGeneral    Script Date: 08/nov/00 9:01:17 ******/
CREATE VIEW dbo.qListadoBalanceGeneral
AS
SELECT     dbo.tTempListadoBalanceGeneral.Moneda, dbo.Monedas.Descripcion AS NombreMoneda, dbo.Monedas.Simbolo AS SimboloMoneda, 
                      dbo.tTempListadoBalanceGeneral.MonedaOriginal, MonedasOriginal.Descripcion AS NombreMonedaOriginal, 
                      MonedasOriginal.Simbolo AS SimboloMonedaOriginal, dbo.tTempListadoBalanceGeneral.Cuenta, dbo.tTempListadoBalanceGeneral.CuentaEditada, 
                      dbo.tTempListadoBalanceGeneral.Descripcion, dbo.tTempListadoBalanceGeneral.Estructura, dbo.tTempListadoBalanceGeneral.TotDet, 
                      dbo.tTempListadoBalanceGeneral.SaldoInicial, dbo.tTempListadoBalanceGeneral.SaldoActual, 
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
                      dbo.tTempListadoBalanceGeneral.Grupo, dbo.tTempListadoBalanceGeneral.OrdenBalanceGeneral, 
                      dbo.tTempListadoBalanceGeneral.NumeroUsuario
FROM         dbo.tTempListadoBalanceGeneral LEFT OUTER JOIN
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
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.148', GetDate()) 

