/*    
	  Jueves, 28 de Noviembre de 2.019  -   v0.00.420.sql 
	  
	  Modificamos el view vtTempActivosFijos_ConsultaDepreciacion, que es usado 
	  para obtener la consulta de activos fijos (depreciación) 
*/


/****** Object:  View [dbo].[vtTempActivosFijos_ConsultaDepreciacion]    Script Date: 11/28/19 5:15:36 PM ******/
DROP VIEW [dbo].[vtTempActivosFijos_ConsultaDepreciacion]
GO

/****** Object:  View [dbo].[vtTempActivosFijos_ConsultaDepreciacion]    Script Date: 11/28/19 5:15:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vtTempActivosFijos_ConsultaDepreciacion]
AS

SELECT     dbo.Companias.Nombre AS NombreCiaContab, dbo.Companias.Abreviatura AS AbreviaturaCiaContab, dbo.tDepartamentos.Descripcion AS NombreDepartamento, 
			dbo.Monedas.Moneda AS Moneda, dbo.Monedas.Descripcion AS DescripcionMoneda, dbo.Monedas.Simbolo AS SimboloMoneda, 
                      dbo.TiposDeProducto.Descripcion AS NombreTipoProducto, dbo.InventarioActivosFijos.Producto, dbo.InventarioActivosFijos.Descripcion AS DescripcionProducto, 
                      dbo.InventarioActivosFijos.FechaCompra, dbo.InventarioActivosFijos.FechaDesincorporacion, CAST(dbo.InventarioActivosFijos.DepreciarDesdeMes AS nVarChar) 
                      + N'/' + SUBSTRING(CAST(dbo.InventarioActivosFijos.DepreciarDesdeAno AS nVarChar), 3, 2) AS DepreciarDesde, dbo.InventarioActivosFijos.DepreciarDesdeMes, 
                      dbo.InventarioActivosFijos.DepreciarDesdeAno, CAST(dbo.tTempActivosFijos_ConsultaDepreciacion.DepreciarHastaMes AS nVarChar) 
                      + N'/' + SUBSTRING(CAST(dbo.tTempActivosFijos_ConsultaDepreciacion.DepreciarHastaAno AS nVarChar), 3, 2) AS DepreciarHasta, 
                      dbo.tTempActivosFijos_ConsultaDepreciacion.DepreciarHastaMes, dbo.tTempActivosFijos_ConsultaDepreciacion.DepreciarHastaAno, 
                      dbo.tTempActivosFijos_ConsultaDepreciacion.CantidadMesesADepreciar, dbo.tTempActivosFijos_ConsultaDepreciacion.DepAcum_CantMeses, 
                      dbo.tTempActivosFijos_ConsultaDepreciacion.DepAcum_CantMeses_AnoActual, 
                      dbo.tTempActivosFijos_ConsultaDepreciacion.CantidadMesesADepreciar - dbo.tTempActivosFijos_ConsultaDepreciacion.DepAcum_CantMeses AS RestaPorDepreciar_Meses,
                       InventarioActivosFijos.CostoTotal, 
				 dbo.tTempActivosFijos_ConsultaDepreciacion.MontoADepreciar, dbo.tTempActivosFijos_ConsultaDepreciacion.DepreciacionMensual, 
                      dbo.tTempActivosFijos_ConsultaDepreciacion.DepAcum_AnoActual, dbo.tTempActivosFijos_ConsultaDepreciacion.DepAcum_Total, 
                      dbo.tTempActivosFijos_ConsultaDepreciacion.MontoADepreciar - dbo.tTempActivosFijos_ConsultaDepreciacion.DepAcum_Total AS RestaPorDepreciar, 
                      dbo.tTempActivosFijos_ConsultaDepreciacion.NombreUsuario
FROM         dbo.Companias INNER JOIN
                      dbo.InventarioActivosFijos ON dbo.Companias.Numero = dbo.InventarioActivosFijos.Cia INNER JOIN
                      dbo.tDepartamentos ON dbo.InventarioActivosFijos.Departamento = dbo.tDepartamentos.Departamento INNER JOIN
                      dbo.TiposDeProducto ON dbo.InventarioActivosFijos.Tipo = dbo.TiposDeProducto.Tipo INNER JOIN
                      dbo.tTempActivosFijos_ConsultaDepreciacion ON dbo.InventarioActivosFijos.ClaveUnica = dbo.tTempActivosFijos_ConsultaDepreciacion.ActivoFijoID
					  INNER JOIN
                      dbo.Monedas ON dbo.Monedas.Moneda = dbo.InventarioActivosFijos.Moneda

                      


GO


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.420', GetDate()) 


