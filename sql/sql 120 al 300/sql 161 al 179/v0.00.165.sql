/*    Viernes, 15 de Octubre de 2.004   -   v0.00.165.sql 

	Ajustamos el View qListadoComprobantesRetencion2. 

*/ 



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoComprobantesRetencion2]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoComprobantesRetencion2]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoComprobantesRetencion2
AS
SELECT     TOP 100 PERCENT dbo.Facturas.NumeroFactura, dbo.Facturas.FechaEmision, dbo.Facturas.FechaRecepcion, 
                      dbo.Monedas.Simbolo AS SimboloMoneda, ISNULL(dbo.Facturas.MontoFacturaConIva, 0) + ISNULL(dbo.Facturas.MontoFacturaSinIva, 0) 
                      AS MontoFactura, dbo.Facturas.MontoSujetoARetencion, dbo.Facturas.ImpuestoRetenidoPorc, dbo.Facturas.ImpuestoRetenido, 
                      dbo.Facturas.Proveedor, dbo.Pagos.ClaveUnicaMovimientoBancario
FROM         dbo.dPagos RIGHT OUTER JOIN
                      dbo.Facturas LEFT OUTER JOIN
                      dbo.Monedas ON dbo.Facturas.Moneda = dbo.Monedas.Moneda ON dbo.dPagos.ClaveUnicaFactura = dbo.Facturas.ClaveUnica LEFT OUTER JOIN
                      dbo.Pagos ON dbo.dPagos.ClaveUnicaPago = dbo.Pagos.ClaveUnica
WHERE     (dbo.Facturas.ImpuestoRetenido IS NOT NULL) AND (dbo.Pagos.ClaveUnicaMovimientoBancario IS NOT NULL)
ORDER BY dbo.Facturas.FechaEmision, dbo.Facturas.NumeroFactura

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.165', GetDate()) 

