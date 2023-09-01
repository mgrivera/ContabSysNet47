/*    
	  Viernes, 5 de Agosto de 2.023  -   v0.00.446.sql 
	  
	  Agregamos los objetos necesarios para la nueva consulta de factura
*/


-- **********************************************************************
-- v_facturas_consulta
-- **********************************************************************

-- Drop a view if it exists using OBJECT_ID
IF OBJECT_ID('dbo.v_facturas_consulta', 'V') IS NOT NULL
  DROP VIEW dbo.v_facturas_consulta;


GO

  Create View dbo.v_facturas_consulta As 
  Select f.claveUnica as claveUnica, 
  	f.NumeroFactura as numero, f.NumeroControl as control, f.FechaEmision as fEmision, f.FechaRecepcion as fRecepcion, 
	f.Moneda as moneda, m.Descripcion as monedaNombre, m.Simbolo as monedaSimbolo, 
	f.Proveedor as compania, p.Nombre as companiaNombre, p.Abreviatura as companiaAbreviatura, 
	f.Concepto as concepto, 
	CASE f.NcNdFlag When 'NC' THEN 'NC' When 'ND' THEN 'ND' ELSE 'Fac' END AS tipo1, 
	Case f.CxCCxPFlag When 1 Then 'CxP' When 2 Then 'CxC' Else 'Indef' End As tipo2,
	f.NumeroComprobante as comprobante, f.NumeroOperacion as comprobanteOperacion, 
	f.CondicionesDePago, fp.Descripcion as formaPagoNombre, 
	f.Tipo as tipo, t.Descripcion as nombreTipo, 
	f.MontoFacturaSinIva as montoNoImp, f.MontoFacturaConIva as montoImp, f.Tasa as tasa, 
	f.Iva as iva, f.OtrosImpuestos as otrosImpuestos, f.TotalFactura as total, 
	f.RetencionSobreIva as retIva, f.ImpuestoRetenido as retIslr, f.OtrasRetenciones as otrasReteciones, f.Anticipo as anticipo, 
	f.TotalAPagar as totalAPagar, f.Saldo as saldo, f.Lote as numeroLote, 
	Case f.Estado When 1 Then 'Pend' When 2 Then 'Parcial' When 3 Then 'Pag' When 4 Then 'Anul' Else 'Indef' End As estado, 
	f.Ingreso as ingreso, f.UltAct as ultAct, f.Usuario as usuario, 
	f.Cia as cia, c.Nombre as nombreCompania

	From Facturas f Inner Join Monedas m On f.Moneda = m.Moneda
	Inner Join Proveedores p On f.Proveedor = p.Proveedor 
	Inner Join Companias c On f.Cia = c.Numero 
	Inner Join TiposProveedor t On f.Tipo = t.Tipo 
	Inner Join FormasDePago fp On f.CondicionesDePago = fp.FormaDePago

  Go

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.446', GetDate()) 