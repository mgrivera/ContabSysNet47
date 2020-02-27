/*    Miercoles, 25 de Junio del 2003   -   v0.00.153.sql 

	agregamos el view qListadoComprobantesRetencion. 

*/ 

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoComprobantesRetencion]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoComprobantesRetencion]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoComprobantesRetencion
AS
SELECT     dbo.Proveedores.Nombre AS NombreProveedor, dbo.Facturas.NumeroFactura, dbo.Proveedores.Rif, dbo.Proveedores.Nit, 
                      dbo.Facturas.MontoSujetoARetencion, dbo.Facturas.ImpuestoRetenidoPorc, dbo.Facturas.ImpuestoRetenido, 
                      dbo.Companias.Nombre AS NombreCiaSeleccionada, dbo.Companias.Rif AS RifCiaSeleccionada, dbo.Facturas.Proveedor, dbo.Facturas.FechaEmision, 
                      dbo.Facturas.FechaRecepcion, dbo.Facturas.Cia, dbo.Monedas.Simbolo AS SimboloMoneda
FROM         dbo.Facturas INNER JOIN
                      dbo.Proveedores ON dbo.Facturas.Proveedor = dbo.Proveedores.Proveedor INNER JOIN
                      dbo.Companias ON dbo.Facturas.Cia = dbo.Companias.Numero INNER JOIN
                      dbo.Monedas ON dbo.Facturas.Moneda = dbo.Monedas.Moneda
WHERE     (dbo.Facturas.ImpuestoRetenido IS NOT NULL) AND (dbo.Facturas.ImpuestoRetenido <> 0)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.153', GetDate()) 

