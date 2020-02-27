/*    Lunes, 19 de Noviembre de 2.012  -   v0.00.323.sql 

	Agregamos una tabla Temp... para la obtención del nuevo 
	reporte de facturas ... también el view que corresponde ... 
	Además, modificamos muy levemente el view Facturas_NumericNumeroFactura
*/

/****** Object:  Table [dbo].[Temp_Bancos_ConsultaFacturas]    Script Date: 11/19/2012 09:31:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Temp_Bancos_ConsultaFacturas](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ClaveUnicaFactura] [int] NOT NULL,
	[Cia] [int] NOT NULL,
	[Compania] [int] NOT NULL,
	[NumeroDocumento] [nvarchar](25) NOT NULL,
	[NumeroControl] [nvarchar](20) NULL,
	[FechaEmision] [date] NOT NULL,
	[FechaRecepcion] [date] NOT NULL,
	[Moneda] [int] NOT NULL,
	[CxCCxPFlag] [smallint] NOT NULL,
	[NcNdFlag] [char](2) NULL,
	[CondicionesDePago] [int] NOT NULL,
	[Tipo] [int] NOT NULL,
	[NumeroFacturaAfectada] [nvarchar](20) NULL,
	[Seniat_NumeroComprobante] [char](14) NULL,
	[Seniat_NumeroOperacion] [smallint] NULL,
	[Concepto] [ntext] NULL,
	[MontoNoImponible] [money] NULL,
	[MontoImponible] [money] NULL,
	[IvaPorc] [decimal](6, 3) NULL,
	[Iva] [money] NULL,
	[TotalFactura] [money] NOT NULL,
	[Anticipo] [money] NULL,
	[Saldo] [money] NOT NULL,
	[Estado] [smallint] NOT NULL,
	[RetISLR_CodigoConceptoRetencion] [nvarchar](6) NULL,
	[RetISLR_MontoSujetoARetencion] [money] NULL,
	[RetISLR_ImpuestoRetenidoPorc] [decimal](6, 3) NULL,
	[RetISLR_ImpuestoRetenidoAntesSustraendo] [money] NULL,
	[RetISLR_Sustraendo] [money] NULL,
	[RetISLR_ImpuestoRetenido] [money] NULL,
	[RetISLR_FRecepcionRetencionISLR] [date] NULL,
	[RetIVA_RetencionSobreIvaPorc] [decimal](6, 3) NULL,
	[RetIVA_RetencionSobreIva] [money] NULL,
	[RetIVA_FRecepcionRetencionIVA] [date] NULL,
	[Usuario] [nvarchar](25) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

/****** Object:  View [dbo].[vTemp_Bancos_ConsultaFacturas]    Script Date: 11/19/2012 09:32:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vTemp_Bancos_ConsultaFacturas]
AS
SELECT     dbo.Temp_Bancos_ConsultaFacturas.ClaveUnicaFactura, dbo.Temp_Bancos_ConsultaFacturas.NumeroDocumento, 
                      dbo.Temp_Bancos_ConsultaFacturas.NumeroControl, dbo.Temp_Bancos_ConsultaFacturas.FechaEmision, dbo.Temp_Bancos_ConsultaFacturas.FechaRecepcion, 
                      dbo.Monedas.Simbolo AS SimboloMoneda, dbo.Proveedores.Abreviatura AS AbreviaturaCompania, dbo.Proveedores.Nombre AS NombreCompania, 
                      CASE dbo.Temp_Bancos_ConsultaFacturas.CxCCxPFlag WHEN 1 THEN 'CxP' WHEN 2 THEN 'CxC' END AS CxCCxPFlag, 
                      dbo.Temp_Bancos_ConsultaFacturas.NcNdFlag, dbo.FormasDePago.Descripcion AS NombreFormaPago, dbo.TiposProveedor.Descripcion AS NombreTipoServicio, 
                      dbo.Temp_Bancos_ConsultaFacturas.Seniat_NumeroComprobante, dbo.Temp_Bancos_ConsultaFacturas.Seniat_NumeroOperacion, 
                      dbo.Temp_Bancos_ConsultaFacturas.Concepto, dbo.Temp_Bancos_ConsultaFacturas.MontoNoImponible, dbo.Temp_Bancos_ConsultaFacturas.MontoImponible, 
                      dbo.Temp_Bancos_ConsultaFacturas.IvaPorc, dbo.Temp_Bancos_ConsultaFacturas.Iva, dbo.Temp_Bancos_ConsultaFacturas.TotalFactura, 
                      dbo.Temp_Bancos_ConsultaFacturas.RetISLR_ImpuestoRetenido, dbo.Temp_Bancos_ConsultaFacturas.RetIVA_RetencionSobreIva, 
                      dbo.Temp_Bancos_ConsultaFacturas.Anticipo, dbo.Temp_Bancos_ConsultaFacturas.Saldo, 
                      CASE dbo.Temp_Bancos_ConsultaFacturas.Estado WHEN 1 THEN 'Pendiente' WHEN 2 THEN 'Parcial' WHEN 3 THEN 'Pagada' WHEN 4 THEN 'Anulada' END AS Estado,
                       dbo.Companias.Abreviatura AS AbreviaturaCia, dbo.Companias.Nombre AS NombreCia, dbo.Temp_Bancos_ConsultaFacturas.Usuario
FROM         dbo.Companias INNER JOIN
                      dbo.Temp_Bancos_ConsultaFacturas ON dbo.Companias.Numero = dbo.Temp_Bancos_ConsultaFacturas.Cia INNER JOIN
                      dbo.FormasDePago ON dbo.Temp_Bancos_ConsultaFacturas.CondicionesDePago = dbo.FormasDePago.FormaDePago INNER JOIN
                      dbo.TiposProveedor ON dbo.Temp_Bancos_ConsultaFacturas.Tipo = dbo.TiposProveedor.Tipo INNER JOIN
                      dbo.Proveedores ON dbo.Temp_Bancos_ConsultaFacturas.Compania = dbo.Proveedores.Proveedor LEFT OUTER JOIN
                      dbo.Monedas ON dbo.Temp_Bancos_ConsultaFacturas.Moneda = dbo.Monedas.Moneda

GO


/****** Object:  View [dbo].[Facturas_NumericNumeroFactura]    Script Date: 11/19/2012 09:32:24 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Facturas_NumericNumeroFactura]'))
DROP VIEW [dbo].[Facturas_NumericNumeroFactura]
GO


/****** Object:  View [dbo].[Facturas_NumericNumeroFactura]    Script Date: 11/19/2012 09:32:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Facturas_NumericNumeroFactura]
AS
SELECT     NumeroFactura, NumeroControl, CONVERT(bigint, NumeroFactura) AS NumericNumeroFactura, CxCCxPFlag, NcNdFlag, FechaEmision, FechaRecepcion, 
                      Proveedor AS Compania, Cia
FROM         dbo.Facturas
WHERE     (IsNumeric(NumeroFactura) = 1)

GO


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.323', GetDate()) 