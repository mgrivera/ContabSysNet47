/*    Viernes, 09 de Julio de 2.010    -   v0.00.266.sql 

	Hacemos una corrección leve al view qFormaProveedoresConsulta 

*/


/****** Object:  View [dbo].[qFormaProveedoresConsulta]    Script Date: 07/27/2010 16:07:38 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qFormaProveedoresConsulta]'))
DROP VIEW [dbo].[qFormaProveedoresConsulta]
GO


/****** Object:  View [dbo].[qFormaProveedoresConsulta]    Script Date: 07/27/2010 16:07:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[qFormaProveedoresConsulta]
AS
SELECT     dbo.Proveedores.Proveedor, dbo.Proveedores.Nombre, dbo.Proveedores.Tipo, dbo.TiposProveedor.Descripcion AS NombreTipoProveedor, 
                      dbo.Proveedores.Rif, dbo.Proveedores.NatJurFlag, dbo.Proveedores.Nit, dbo.Proveedores.ContribuyenteEspecialFlag, 
                      dbo.Proveedores.RetencionSobreIvaPorc, dbo.Proveedores.NuestraRetencionSobreIvaPorc, dbo.Proveedores.AfectaLibroComprasFlag, 
                      dbo.Proveedores.Beneficiario, dbo.Proveedores.Concepto, dbo.Proveedores.MontoCheque, dbo.Proveedores.Direccion, dbo.Proveedores.Ciudad, 
                      dbo.tCiudades.Descripcion AS NombreCiudad, dbo.Proveedores.Telefono1, dbo.Proveedores.Telefono2, dbo.Proveedores.Fax, 
                      dbo.Proveedores.Contacto1, dbo.Proveedores.Contacto2, dbo.Proveedores.NacionalExtranjeroFlag, dbo.Proveedores.SujetoARetencionFlag, 
                      dbo.Proveedores.MonedaDefault, dbo.Monedas.Simbolo AS SimboloMoneda, dbo.Proveedores.FormaDePagoDefault, 
                      dbo.FormasDePago.Descripcion AS NombreFormaDePago, dbo.Proveedores.ProveedorClienteFlag, dbo.Proveedores.PorcentajeDeRetencion, 
                      dbo.Proveedores.CodigoConceptoRetencion, dbo.Proveedores.RetencionISLRSustraendo, dbo.Proveedores.AplicaIvaFlag, 
                      dbo.Proveedores.CategoriaProveedor, dbo.Proveedores.MontoChequeEnMonExtFlag,
                      dbo.Proveedores.Ingreso, dbo.Proveedores.UltAct, dbo.Proveedores.Usuario, 
                      dbo.CategoriasRetencion.Descripcion AS NombreCategoriaRetencion
FROM         dbo.Proveedores LEFT OUTER JOIN
                      dbo.CategoriasRetencion ON dbo.Proveedores.CategoriaProveedor = dbo.CategoriasRetencion.Categoria LEFT OUTER JOIN
                      dbo.FormasDePago ON dbo.Proveedores.FormaDePagoDefault = dbo.FormasDePago.FormaDePago LEFT OUTER JOIN
                      dbo.tCiudades ON dbo.Proveedores.Ciudad = dbo.tCiudades.Ciudad LEFT OUTER JOIN
                      dbo.Monedas ON dbo.Proveedores.MonedaDefault = dbo.Monedas.Moneda LEFT OUTER JOIN
                      dbo.TiposProveedor ON dbo.Proveedores.Tipo = dbo.TiposProveedor.Tipo


GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.266', GetDate()) 