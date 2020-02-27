/*    Viernes, 9 de Agosto de 2.008   -   v0.00.219.sql 

	Agregamos la tabla tTempWebReport_ConsultaFacturas 

*/ 


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
	[NombreCompania] [nvarchar](50) NOT NULL,
	[NumeroFactura] [nvarchar](25) NOT NULL,
	[NumeroControl] [nvarchar](20) NULL,
	[ClaveUnicaFactura] [int] NOT NULL,
	[NcNdFlag] [char](2) NULL,
	[NumeroFacturaAfectada] [nvarchar](20) NULL,
	[NumeroComprobante] [char](14) NULL,
	[NumeroOperacion] [smallint] NULL,
	[Tipo] [int] NOT NULL,
	[NombreTipo] [nvarchar](50) NOT NULL,
	[CondicionesDePago] [int] NOT NULL,
	[FechaEmision] [datetime] NOT NULL,
	[FechaRecepcion] [datetime] NOT NULL,
	[Concepto] [ntext] NULL,
	[MontoFacturaSinIva] [money] NULL,
	[MontoFacturaConIva] [money] NULL,
	[IvaPorc] [real] NULL,
	[Iva] [money] NULL,
	[TotalFactura] [money] NOT NULL,
	[MontoSujetoARetencion] [money] NULL,
	[ImpuestoRetenidoPorc] [real] NULL,
	[ImpuestoRetenido] [money] NULL,
	[RetencionSobreIvaPorc] [real] NULL,
	[RetencionSobreIva] [money] NULL,
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
	[NumeroUsuario] [int] NOT NULL,
 CONSTRAINT [PK_tTempWebReport_ConsultaFacturas] PRIMARY KEY CLUSTERED 
(
	[Moneda] ASC,
	[CiaContab] ASC,
	[Compania] ASC,
	[NumeroFactura] ASC,
	[NumeroUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.219', GetDate()) 