/*    Viernes, 6 de Mayo de 2.005   -   v0.00.174.sql 

	Modificamos levemente el view qListadoComprobantesRetencion 

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
SELECT     TOP 100 PERCENT dbo.Proveedores.Nombre AS NombreProveedor, dbo.Proveedores.Rif, 
                      dbo.Proveedores.Direccion + N' ' + dbo.tCiudades.Descripcion AS DireccionProveedor, dbo.Proveedores.Nit, 
                      dbo.Companias.Nombre AS NombreCiaSeleccionada, dbo.Companias.Rif AS RifCiaSeleccionada, 
                      dbo.Companias.Direccion + N' ' + dbo.Companias.Ciudad AS DireccionCiaSeleccionada, dbo.Monedas.Simbolo AS SimboloMoneda, 
                      dbo.MovimientosBancarios.Transaccion AS NumeroCheque, dbo.MovimientosBancarios.Fecha AS FechaCheque, 
                      ABS(dbo.MovimientosBancarios.Monto) AS MontoCheque, dbo.MovimientosBancarios.ProvClte, dbo.CuentasBancarias.Banco, 
                      dbo.Bancos.NombreCorto AS NombreCortoBanco, dbo.MovimientosBancarios.Cia, dbo.MovimientosBancarios.ClaveUnica, 
                      dbo.MovimientosBancarios.Tipo
FROM         dbo.Companias INNER JOIN
                      dbo.MovimientosBancarios INNER JOIN
                      dbo.Proveedores ON dbo.MovimientosBancarios.ProvClte = dbo.Proveedores.Proveedor ON 
                      dbo.Companias.Numero = dbo.MovimientosBancarios.Cia INNER JOIN
                      dbo.CuentasBancarias ON dbo.MovimientosBancarios.CuentaInterna = dbo.CuentasBancarias.CuentaInterna INNER JOIN
                      dbo.Monedas ON dbo.CuentasBancarias.Moneda = dbo.Monedas.Moneda INNER JOIN
                      dbo.Bancos ON dbo.CuentasBancarias.Banco = dbo.Bancos.Banco INNER JOIN
                      dbo.Pagos ON dbo.MovimientosBancarios.ClaveUnica = dbo.Pagos.ClaveUnicaMovimientoBancario LEFT OUTER JOIN
                      dbo.tCiudades tCiudades_1 ON dbo.Companias.Ciudad = tCiudades_1.Ciudad LEFT OUTER JOIN
                      dbo.tCiudades ON dbo.Proveedores.Ciudad = dbo.tCiudades.Ciudad
WHERE     (dbo.MovimientosBancarios.Tipo = N'CH')
ORDER BY dbo.Proveedores.Nombre

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO





--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.174', GetDate()) 

