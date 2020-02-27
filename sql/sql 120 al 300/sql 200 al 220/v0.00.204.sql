/*    Martes, 6 de marzo de 2.007   -   v0.00.204.sql 

	Modificamos levemente el query (view) que usa el proceso que genera el listado 
	de montos estimados presupuestados 

*/ 


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  View [dbo].[qListadoMontosEstimados]    Script Date: 03/06/2007 17:44:51 ******/

DROP VIEW [dbo].[qListadoMontosEstimados]

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[qListadoMontosEstimados]') AND OBJECTPROPERTY(id, N'IsView') = 1)
EXEC dbo.sp_executesql @statement = N'/****** Object:  View dbo.qListadoMontosEstimados    Script Date: 31/12/00 10:25:57 a.m. *****
***** Object:  View dbo.qListadoMontosEstimados    Script Date: 28/11/00 07:01:24 p.m. *****
***** Object:  View dbo.qListadoMontosEstimados    Script Date: 08/nov/00 9:01:18 ******/
CREATE VIEW [dbo].[qListadoMontosEstimados]
AS
SELECT     dbo.CuentasContables.Grupo, dbo.tGruposContables.Descripcion AS NombreGrupo, dbo.Presupuesto.CuentaContable, 
                      dbo.CuentasContables.Descripcion AS NombreCuenta, dbo.Monedas.Descripcion AS NombreMoneda, dbo.Monedas.Simbolo AS SimboloMoneda, 
                      dbo.CuentasContables.TotDet, dbo.CuentasContables.CuentaEditada, dbo.Presupuesto.Moneda, dbo.Presupuesto.Ano, dbo.Presupuesto.Mes01Est, 
                      dbo.Presupuesto.Mes02Est, dbo.Presupuesto.Mes03Est, dbo.Presupuesto.Mes04Est, dbo.Presupuesto.Mes05Est, dbo.Presupuesto.Mes06Est, 
                      dbo.Presupuesto.Mes07Est, dbo.Presupuesto.Mes08Est, dbo.Presupuesto.Mes09Est, dbo.Presupuesto.Mes10Est, dbo.Presupuesto.Mes11Est, 
                      dbo.Presupuesto.Mes12Est, 
                      dbo.Presupuesto.Mes01Est + dbo.Presupuesto.Mes02Est + dbo.Presupuesto.Mes03Est + dbo.Presupuesto.Mes04Est + dbo.Presupuesto.Mes05Est + dbo.Presupuesto.Mes06Est
                       + dbo.Presupuesto.Mes07Est + dbo.Presupuesto.Mes08Est + dbo.Presupuesto.Mes09Est + dbo.Presupuesto.Mes10Est + dbo.Presupuesto.Mes11Est +
                       dbo.Presupuesto.Mes12Est AS TotalMontosEstimados, dbo.Presupuesto.Cia
FROM         dbo.Presupuesto LEFT OUTER JOIN
                      dbo.CuentasContables ON dbo.Presupuesto.CuentaContable = dbo.CuentasContables.Cuenta AND 
                      dbo.Presupuesto.Cia = dbo.CuentasContables.Cia LEFT OUTER JOIN
                      dbo.Monedas ON dbo.Presupuesto.Moneda = dbo.Monedas.Moneda LEFT OUTER JOIN
                      dbo.tGruposContables ON dbo.CuentasContables.Grupo = dbo.tGruposContables.Grupo
' 


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.204', GetDate()) 