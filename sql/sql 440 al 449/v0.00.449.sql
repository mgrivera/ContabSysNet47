/*    
	  Martes, 5 de Septiembre de 2.023  -   v0.00.449.sql 
	  
	  Agregamos el view para la consulta de asientos contables en contab_access 
*/


-- **********************************************************************
-- v_asientosContables_consulta
-- **********************************************************************

-- Drop a view if it exists using OBJECT_ID
IF OBJECT_ID('dbo.v_asientosContables_consulta', 'V') IS NOT NULL
  DROP VIEW dbo.v_asientosContables_consulta;

IF OBJECT_ID('dbo.v_asientosContables_partidas_consulta', 'V') IS NOT NULL
  DROP VIEW dbo.v_asientosContables_partidas_consulta;


GO

Create View dbo.v_asientosContables_consulta As 
  
Select a.NumeroAutomatico as asientoId, a.Numero as numero, a.Fecha as fecha, 
        a.Moneda as moneda, m.Simbolo as monedaSimbolo, m.Descripcion as monedaDescripcion,  
        a.MonedaOriginal as monedaOriginal, mo.Simbolo as monedaOriginalSimbolo, mo.Descripcion as monedaOriginalDescripcion,  
        a.Tipo as tipo, t.Descripcion as tipoDescripcion, 
        a.Descripcion as descripcion, a.ProvieneDe as provieneDe, a.FactorDeCambio as tasa, 
        a.AsientoTipoCierreAnualFlag as cierreAnual, 
        Case a.AsientoTipoCierreAnualFlag When 1 Then 'Ok' Else '' End as cierreAnualEditado, 
        a.Ingreso as ingreso, a.UltAct as ultAct, a.Usuario as usuario, 
        a.Cia as cia, c.Abreviatura as ciaAbreviatura, c.Nombre as ciaNombre, 
        Count(*) as partidasCount, Sum(d.Debe) as partidasSumOfDebe, Sum(d.Haber) as partidasSumOfHaber  

        From Asientos a Inner Join TiposDeAsiento t On a.Tipo = t.Tipo  
        Inner Join Monedas m On a.Moneda = m.Moneda 
        Inner Join Monedas mo On a.MonedaOriginal = mo.Moneda
        Inner Join Companias c On a.Cia = c.Numero  
        Left Outer Join dAsientos d On a.NumeroAutomatico = d.NumeroAutomatico 

        Group by a.NumeroAutomatico, a.Numero, a.Fecha, 
        a.Moneda, m.Simbolo, m.Descripcion,  
        a.MonedaOriginal, mo.Simbolo, mo.Descripcion,  
        a.Tipo, t.Descripcion, 
        a.Descripcion, a.ProvieneDe, a.FactorDeCambio, 
        a.AsientoTipoCierreAnualFlag, 
        a.Ingreso, a.UltAct, a.Usuario, 
        a.Cia, c.Abreviatura, c.Nombre

Go

Create View dbo.v_asientosContables_partidas_consulta As 
  
Select d.NumeroAutomatico as asientoId, d.Partida as numero, d.CuentaContableID as cuentaContableId, 
        c.Cuenta as cuentaContable, c.CuentaEditada as cuentaEditada, c.Descripcion as cuentaContableDescripcion, 
        d.Descripcion as descripcion, d.Referencia as referencia, 
        d.CentroCosto as centroCosto, cc.Descripcion as centroCostoDescripcion, cc.DescripcionCorta as centroCostoDescripcionCorta, 
        d.Debe as debe, d.Haber as haber 

        From dAsientos d Inner Join CuentasContables c On d.CuentaContableID = c.ID 
        Left Outer Join CentrosCosto cc On d.CentroCosto = cc.CentroCosto 

Go

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.449', GetDate()) 