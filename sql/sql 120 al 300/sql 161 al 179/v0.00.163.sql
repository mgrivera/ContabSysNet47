/*    Martes, 13 de Julio de 2.004   -   v0.00.163.sql 

	Corregimos algunas estructuras como resultado de los cambios en la tabla Facturas. 

*/ 


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoFacturas]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoFacturas]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoFacturas
AS
SELECT     dbo.Facturas.Moneda, dbo.Monedas.Descripcion AS NombreMoneda, dbo.Facturas.Proveedor, dbo.Proveedores.Nombre AS NombreProveedor, 
                      dbo.Facturas.NumeroFactura, dbo.Facturas.FechaEmision, dbo.Facturas.FechaRecepcion, dbo.Facturas.FechaUltimoVencimiento, dbo.Facturas.Iva, 
                      dbo.Facturas.TotalFactura, dbo.Facturas.ImpuestoRetenido, dbo.Facturas.TotalAPagar, dbo.Facturas.Saldo, dbo.Facturas.Concepto, 
                      dbo.Facturas.CondicionesDePago, dbo.Facturas.MontoFacturaSinIva, dbo.Facturas.MontoFacturaConIva, dbo.Facturas.IvaPorc, 
                      dbo.Facturas.MontoSujetoARetencion, dbo.Facturas.ImpuestoRetenidoPorc, dbo.Facturas.Estado, dbo.Facturas.CxCCxPFlag, 
                      dbo.Facturas.ImportacionFlag, dbo.Facturas.DistribuirEnCondominioFlag, dbo.Facturas.CierreCondominio, dbo.Facturas.CodigoInmueble, 
                      dbo.Facturas.Cia
FROM         dbo.Facturas LEFT OUTER JOIN
                      dbo.Proveedores ON dbo.Facturas.Proveedor = dbo.Proveedores.Proveedor LEFT OUTER JOIN
                      dbo.Monedas ON dbo.Facturas.Moneda = dbo.Monedas.Moneda

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.163', GetDate()) 

