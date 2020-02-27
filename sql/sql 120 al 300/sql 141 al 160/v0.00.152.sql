/*    Miercoles, 18 de Junio del 2003   -   v0.00.152.sql 

	Alteramos muy levemente el sotored procedure spRenumerarPartidasEnAsiento 
	(para 'darle la vuelta' a un bug que ahora presenta Access cuando ejecuta stored 
	procedures que usan Fetch sin Into). 

*/ 

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[spRenumerarPartidasEnAsientos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[spRenumerarPartidasEnAsientos]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


/****** Object:  Stored Procedure dbo.spRenumerarPartidasEnAsientos    Script Date: 28/11/00 07:01:26 p.m. ******/

/****** Object:  Stored Procedure dbo.spRenumerarPartidasEnAsientos    Script Date: 08/nov/00 9:01:19 ******/
CREATE Procedure spRenumerarPartidasEnAsientos (@nNumeroAutomatico int)
/*

 este stored procedure renumera las partidas en un asiento determinado. Para hacerlo, las lee y 
actualiza de 10 en 10. 

*/
As
		
Set NoCount On

Declare @nPartida As smallint
Declare @nFiller As smallint

Declare Partidas Cursor 
	For Select Partida From dAsientos Where NumeroAutomatico = @nNumeroAutomatico 
		Order By Partida
		For Update Of Partida

Open Partidas

Fetch Next From Partidas Into @nFiller 

Select @nPartida = 10 

While @@fetch_status = 0 
Begin 

	Update dAsientos Set Partida = @nPartida Where Current Of Partidas 
	Select @nPartida = @nPartida + 10 

	Fetch Next From Partidas Into @nFiller 
End 

Deallocate Partidas

Set NoCount Off

return 




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

--  -----------------------------
--  qFormaDuplicarPresupuesto01
--  -----------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaDuplicarPresupuesto01]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaDuplicarPresupuesto01]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qFormaDuplicarPresupuesto01    Script Date: 28/11/00 07:01:24 p.m. *****
***** Object:  View dbo.qFormaDuplicarPresupuesto01    Script Date: 08/nov/00 9:01:18 ******/
CREATE VIEW dbo.qFormaDuplicarPresupuesto01
AS
SELECT     dbo.Presupuesto.CuentaContable, dbo.CuentasContables.Descripcion, dbo.Monedas.Simbolo, dbo.CuentasContables.TotDet, 
                      dbo.CuentasContables.CuentaEditada, dbo.Presupuesto.Moneda, dbo.Presupuesto.Ano, dbo.Presupuesto.Mes01Est, dbo.Presupuesto.Mes02Est, 
                      dbo.Presupuesto.Mes03Est, dbo.Presupuesto.Mes04Est, dbo.Presupuesto.Mes05Est, dbo.Presupuesto.Mes06Est, dbo.Presupuesto.Mes07Est, 
                      dbo.Presupuesto.Mes08Est, dbo.Presupuesto.Mes09Est, dbo.Presupuesto.Mes10Est, dbo.Presupuesto.Mes11Est, dbo.Presupuesto.Mes12Est, 
                      dbo.Presupuesto.Mes01Eje, dbo.Presupuesto.Mes02Eje, dbo.Presupuesto.Mes03Eje, dbo.Presupuesto.Mes04Eje, dbo.Presupuesto.Mes05Eje, 
                      dbo.Presupuesto.Mes06Eje, dbo.Presupuesto.Mes07Eje, dbo.Presupuesto.Mes08Eje, dbo.Presupuesto.Mes09Eje, dbo.Presupuesto.Mes10Eje, 
                      dbo.Presupuesto.Mes11Eje, dbo.Presupuesto.Mes12Eje, dbo.Presupuesto.Cia
FROM         dbo.Presupuesto LEFT OUTER JOIN
                      dbo.CuentasContables ON dbo.Presupuesto.CuentaContable = dbo.CuentasContables.Cuenta AND 
                      dbo.Presupuesto.Cia = dbo.CuentasContables.Cia LEFT OUTER JOIN
                      dbo.Monedas ON dbo.Presupuesto.Moneda = dbo.Monedas.Moneda

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.152', GetDate()) 

