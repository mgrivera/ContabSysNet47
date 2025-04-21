/*    
	  Miercoles, 29 de Noviembre de 2.023  -   v0.00.454.sql 
	  
	  Agregamos el view para la consulta de cuentas contables (desde Access) 
*/


-- **********************************************************************
-- v_contab_cuentasContables_consulta 
-- **********************************************************************

-- Drop a view if it exists using OBJECT_ID
IF OBJECT_ID('dbo.v_contab_cuentasContables_consulta ', 'V') IS NOT NULL
  DROP VIEW dbo.v_contab_cuentasContables_consulta;

GO

Create View dbo.v_contab_cuentasContables_consulta  As 
  
Select cc.ID as id, cc.Cuenta as cuentaContable, cc.Descripcion as descripcion, cc.CuentaEditada as cuentaContableEditada, 
cc.Nivel1 as nivel1, cc.Nivel2 as nivel2, cc.Nivel3 as nivel3, cc.Nivel4 as nivel4, 
cc.Nivel5 as nivel5, cc.Nivel6 as nivel6, cc.Nivel7 as nivel7, cc.NumNiveles as numNiveles, 
cc.TotDet as totDet, Case cc.TotDet When 'T' Then 'Total' Else 'Detalle' End as totDetDescripcion, 
cc.ActSusp as actSusp, Case cc.actSusp When 'A' Then 'Activa' Else 'Suspendida' End as actSuspDescipcion, 
cc.Grupo as grupo, g.Descripcion as grupoDescripcion, 
cc.UltMod as ultMod, 
cc.Cia as cia, co.Nombre as companiaNombre, co.NombreCorto as companiaNombreCorto, co.Abreviatura as companiaAbreviatura  

From CuentasContables cc 
Inner Join tGruposContables g on cc.Grupo = g.Grupo 
Inner Join Companias co on cc.Cia = co.Numero 

Go


-- **********************************************************************
-- v_saldosCuentasBancarias_consulta
-- **********************************************************************

-- Drop a view if it exists using OBJECT_ID
IF OBJECT_ID('dbo.v_saldosCuentasBancarias_consulta', 'V') IS NOT NULL
  DROP VIEW dbo.v_saldosCuentasBancarias_consulta;

GO

Create View dbo.v_saldosCuentasBancarias_consulta As 
  
Select 
	s.ID as id,
	s.CuentaBancaria as cuentaBancariaId, cb.CuentaBancaria as cuentaBancaria, cb.Tipo as cuentaBancariaTipo, 
    cb.Moneda as moneda, m.Simbolo as monedaSimbolo, m.Descripcion as monedaDescripcion, 
	b.Banco as banco, b.Abreviatura as bancoAbreviatura, b.NombreCorto as bancoNombreCorto, 
	s.Ano as ano,
	s.Inicial as inicial,
	s.Mes01 as mes01,
	s.Mes02 as mes02,
	s.Mes03 as mes03,
	s.Mes04 as mes04,
	s.Mes05 as mes05,
	s.Mes06 as mes06,
	s.Mes07 as mes07,
	s.Mes08 as mes08,
	s.Mes09 as mes09,
	s.Mes10 as mes10,
	s.Mes11 as mes11,
	s.Mes12 as mes12, 
    cb.Cia as cia, co.Abreviatura as ciaAbreviatura, co.Nombre as ciaNombre 
	
    From Saldos s Inner Join CuentasBancarias cb On s.CuentaBancaria = cb.CuentaInterna 
    Inner Join Monedas m On cb.Moneda = m.Moneda 
    Inner Join Companias co On cb.Cia = co.Numero 
	Inner Join Agencias a On cb.Agencia = a.Agencia 
	Inner Join Bancos b On a.Banco = b.Banco  

Go


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.454', GetDate()) 