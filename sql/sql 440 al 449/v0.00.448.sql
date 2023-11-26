/*    
	  Jueves, 31 de Agosto de 2.023  -   v0.00.448.sql 
	  
	  Agregamos el view para la consulta de pagos en contab_access 
*/


-- **********************************************************************
-- v_pagos_consulta
-- **********************************************************************

-- Drop a view if it exists using OBJECT_ID
IF OBJECT_ID('dbo.v_pagos_consulta', 'V') IS NOT NULL
  DROP VIEW dbo.v_pagos_consulta;


GO

  Create View dbo.v_pagos_consulta As 
  
Select p.ClaveUnica as claveUnica, p.Fecha as fecha, p.Moneda as monedaId, m.Simbolo as monedaSimbolo, m.Descripcion as monedaNombre, 
p.Proveedor as proveedorId, pr.Abreviatura as proveedorAbreviatura, pr.Nombre as proveedorNombre, 
p.MiSuFlag as miSuFlag, Case p.MiSuFlag When 1 Then 'Mi' When 2 Then 'Su' End as miSuFlagEditado, 
p.NumeroPago as numeroPago, 
p.AnticipoFlag as anticipoFlag, Case p.AnticipoFlag When 1 Then 'Si' Else '' End as anticipoFlagEditado, 
p.Concepto as concepto, p.Monto as monto, 
p.Cia as ciaContab, c.Abreviatura as ciaContabAbreviatura, c.Nombre as ciaContabNombre, 
p.Ingreso as ingreso, p.UltAct as ultAct, p.Usuario as usuario  

From Pagos p Inner Join Proveedores pr On p.Proveedor = pr.Proveedor 
Inner Join Monedas m On p.Moneda = m.Moneda 
Inner Join Companias c On p.Cia = c.Numero 

  Go

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.448', GetDate()) 