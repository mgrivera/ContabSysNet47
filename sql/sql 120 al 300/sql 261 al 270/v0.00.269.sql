/*    Lunes, 6 de Septiembre de 2.010   -   v0.00.269.sql 

	Agregamos algunas nuevas columnas a la tabla tTempWebReport_ConsultaFacturas 

*/


/****** Object:  Table [dbo].[tTempWebReport_ConsultaFacturas]    Script Date: 09/06/2010 18:09:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tTempWebReport_ConsultaFacturas]') AND type in (N'U'))
DROP TABLE [dbo].[tTempWebReport_ConsultaFacturas]
GO


/****** Object:  Table [dbo].[tTempWebReport_ConsultaFacturas]    Script Date: 09/07/2010 14:46:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tTempWebReport_ConsultaFacturas](
	[Moneda] [int] NOT NULL,
	[CiaContab] [int] NOT NULL,
	[Compania] [int] NOT NULL,
	[CiaContabNombre] [nvarchar](50) NOT NULL,
	[CiaContabDireccion] [nvarchar](150) NULL,
	[CiaContabRif] [nvarchar](15) NOT NULL,
	[CiaContabTelefono1] [nvarchar](15) NULL,
	[CiaContabTelefono2] [nvarchar](15) NULL,
	[CiaContabFax] [nvarchar](15) NULL,
	[NombreCompania] [nvarchar](50) NOT NULL,
	[RifCompania] [nvarchar](20) NULL,
	[CompaniaDomicilio] [nvarchar](255) NULL,
	[CompaniaTelefono] [nvarchar](15) NULL,
	[CompaniaFax] [nvarchar](15) NULL,
	[CodigoConceptoRetencion] [nvarchar](6) NULL,
	[NumeroFactura] [nvarchar](25) NOT NULL,
	[NumeroControl] [nvarchar](20) NULL,
	[ImportacionFlag] [bit] NULL,
	[Importacion_CompraNacional] [nvarchar](50) NULL,
	[ClaveUnicaFactura] [int] NOT NULL,
	[NcNdFlag] [char](2) NULL,
	[Compra_NotaCredito] [nvarchar](50) NULL,
	[NumeroFacturaAfectada] [nvarchar](20) NULL,
	[NumeroComprobante] [char](14) NULL,
	[NumeroOperacion] [smallint] NULL,
	[Tipo] [int] NOT NULL,
	[NombreTipo] [nvarchar](50) NOT NULL,
	[CondicionesDePago] [int] NOT NULL,
	[CondicionesDePagoNombre] [nvarchar](30) NULL,
	[FechaEmision] [datetime] NOT NULL,
	[FechaRecepcion] [datetime] NOT NULL,
	[Concepto] [ntext] NULL,
	[NotasFactura1] [nvarchar](100) NULL,
	[NotasFactura2] [nvarchar](100) NULL,
	[NotasFactura3] [nvarchar](100) NULL,
	[MontoFacturaSinIva] [money] NULL,
	[MontoFacturaConIva] [money] NULL,
	[BaseImponible_Reducido] [money] NULL,
	[BaseImponible_General] [money] NULL,
	[BaseImponible_Adicional] [money] NULL,
	[TipoAlicuota] [char](1) NULL,
	[IvaPorc] [real] NULL,
	[IvaPorc_Reducido] [real] NULL,
	[IvaPorc_General] [real] NULL,
	[IvaPorc_Adicional] [real] NULL,
	[Iva] [money] NULL,
	[Iva_Reducido] [money] NULL,
	[Iva_General] [money] NULL,
	[Iva_Adicional] [money] NULL,
	[TotalFactura] [money] NOT NULL,
	[MontoSujetoARetencion] [money] NULL,
	[ImpuestoRetenidoPorc] [real] NULL,
	[ImpuestoRetenidoISLRAntesSustraendo] [money] NULL,
	[ImpuestoRetenidoISLRSustraendo] [money] NULL,
	[ImpuestoRetenido] [money] NULL,
	[ImpuestoRetenido_Reducido] [money] NULL,
	[ImpuestoRetenido_General] [money] NULL,
	[ImpuestoRetenido_Adicional] [money] NULL,
	[FRecepcionRetencionISLR] [datetime] NULL,
	[RetencionSobreIvaPorc] [real] NULL,
	[RetencionSobreIva] [money] NULL,
	[FRecepcionRetencionIVA] [datetime] NULL,
	[TotalAPagar] [money] NOT NULL,
	[Anticipo] [money] NULL,
	[Saldo] [money] NOT NULL,
	[Estado] [smallint] NOT NULL,
	[NombreEstado] [nchar](10) NULL,
	[NumeroDeCuotas] [smallint] NULL,
	[FechaUltimoVencimiento] [datetime] NULL,
	[CxCCxPFlag] [smallint] NOT NULL,
	[NombreCxCCxPFlag] [char](4) NOT NULL,
	[Comprobante] [int] NULL,
	[FechaPago] [datetime] NULL,
	[MontoPagado] [money] NULL,
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_tTempWebReport_ConsultaFacturas] PRIMARY KEY CLUSTERED 
(
	[Moneda] ASC,
	[CiaContab] ASC,
	[Compania] ASC,
	[NumeroFactura] ASC,
	[NombreUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.269', GetDate()) 