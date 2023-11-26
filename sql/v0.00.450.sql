/*    
	  Martes, 24 de Octubre de 2.023  -   v0.00.450.sql 
	  
	  Agregamos el view para la consulta de cuentas bancarias desde contab_access 
*/


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

Go

IF OBJECT_ID('dbo.v_movimientosBancarios_consulta', 'V') IS NOT NULL
  DROP VIEW dbo.v_movimientosBancarios_consulta;

GO

Create View dbo.v_movimientosBancarios_consulta As 

Select m.ClaveUnica as claveUnica, m.Transaccion as numero, 
	m.Tipo as tipo, m.Fecha as fecha, b.Nombre as bancoNombre, b.NombreCorto as bancoNombreCorto, b.Abreviatura as bancoAbreviatura, 
	cb.CuentaInterna as cuentaBancariaId, cb.CuentaBancaria as cuentaBancaria, 
	mo.Descripcion as monedaDescripcion, mo.Simbolo as monedaSimbolo, 
	p.Nombre as companiaNombre, p.Abreviatura as companiaAbreviatura, 
	m.Beneficiario as beneficiario, m.Concepto as concepto, m.MontoBase as montoBase, 
	m.Comision as comision, m.ComisionPorc as comisionPorc, m.Impuestos as impuesto, m.Monto as monto, 
	m.FechaEntregado as fechaEntrega, cb.Cia as cia, comp.Abreviatura as ciaContabAbreviatura, comp.Nombre as ciaContabNombre  
	From MovimientosBancarios m 
	Inner Join Chequeras ch On m.ClaveUnicaChequera = ch.NumeroChequera 
	Inner Join CuentasBancarias cb On ch.NumeroCuenta = cb.CuentaInterna 
	Inner Join Monedas mo On cb.Moneda = mo.Moneda 
	Inner Join Agencias a On cb.Agencia = a.Agencia 
	Inner Join Bancos b On a.Banco = b.Banco 
	Left outer Join Proveedores p on m.ProvClte = p.Proveedor 
	Inner Join Companias comp On cb.Cia = comp.Numero
	
Go

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.450', GetDate()) 