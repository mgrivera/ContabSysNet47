/*    
	  Viernes, 25 de Agosto de 2.023  -   v0.00.447.sql 
	  
	  Agregamos el view para la consulta de movimientos bancarios en contab_access 
*/


-- **********************************************************************
-- v_movimientosBancarios_consulta
-- **********************************************************************

-- Drop a view if it exists using OBJECT_ID
IF OBJECT_ID('dbo.v_movimientosBancarios_consulta', 'V') IS NOT NULL
  DROP VIEW dbo.v_movimientosBancarios_consulta;


GO

  Create View dbo.v_movimientosBancarios_consulta As 
  
Select m.ClaveUnica as claveUnica, m.Transaccion as numero, 
	m.Tipo as tipo, m.Fecha as fecha, b.Nombre as bancoNombre, b.NombreCorto as bancoNombreCorto, b.Abreviatura as bancoAbreviatura, 
	cb.CuentaBancaria as cuentaBancaria, 
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
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.447', GetDate()) 