/*    
	  Viernes, 28/Dic/2.018  -   v0.00.408.sql 
	  
	  Actualizamos (drop/create) la tabla (temp) bancos_vencimientoFacturas 
*/


/****** Object:  Table [dbo].[Bancos_VencimientoFacturas]    Script Date: 12/28/18 5:23:22 PM ******/
DROP TABLE [dbo].[Bancos_VencimientoFacturas]
GO

/****** Object:  Table [dbo].[Bancos_VencimientoFacturas]    Script Date: 12/28/18 5:23:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Bancos_VencimientoFacturas](
	[CxCCxPFlag] [smallint] NOT NULL,
	[CxCCxPFlag_Descripcion] [char](3) NOT NULL,
	[Moneda] [int] NOT NULL,
	[NombreMoneda] [nvarchar](50) NULL,
	[SimboloMoneda] [nvarchar](6) NULL,
	[CiaContab] [int] NOT NULL,
	[NombreCiaContab] [nvarchar](25) NULL,
	[Compania] [int] NOT NULL,
	[NombreCompania] [nvarchar](70) NOT NULL,
	[NombreCompaniaAbreviatura] [nvarchar](10) NOT NULL,
	[NumeroFactura] [nvarchar](25) NOT NULL,
	[NumeroCuota] [smallint] NOT NULL,
	[FechaEmision] [datetime] NOT NULL,
	[FechaRecepcion] [datetime] NOT NULL,
	[FechaVencimiento] [datetime] NOT NULL,
	[DiasVencimiento] [smallint] NOT NULL,
	[MontoCuota] [money] NOT NULL,
	[Iva] [money] NULL,
	[MontoCuotaDespuesIva] [money] NOT NULL,
	[RetencionSobreISLR] [money] NULL,
	[FRecepcionRetencionISLR] [date] NULL,
	[RetencionSobreISLRAplica] [bit] NULL,
	[RetencionSobreIva] [money] NULL,
	[FRecepcionRetencionIva] [date] NULL,
	[RetencionSobreIvaAplica] [bit] NULL,
	[TotalAntesAnticipo] [money] NOT NULL,
	[Anticipo] [money] NULL,
	[Total] [money] NOT NULL,
	[MontoPagado] [money] NULL,
	[SaldoPendiente] [money] NOT NULL,
	[DiasPorVencerOVencidos] [int] NULL,
	[SaldoPendiente_0] [money] NULL,
	[SaldoPendiente_1] [money] NULL,
	[SaldoPendiente_2] [money] NULL,
	[SaldoPendiente_3] [money] NULL,
	[SaldoPendiente_4] [money] NULL,
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_Bancos_VencimientoFacturas] PRIMARY KEY CLUSTERED 
(
	[CxCCxPFlag] ASC,
	[Compania] ASC,
	[NumeroFactura] ASC,
	[NumeroCuota] ASC,
	[NombreUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.408', GetDate()) 
