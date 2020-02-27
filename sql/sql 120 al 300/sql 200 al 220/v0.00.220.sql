/*    Miércoles, 10 de Septiembre de 2.008   -   v0.00.220.sql 

	Agregamos las tablas 'temporales' para el proceso de conciliación, 
	Disponibilidad, Vencimiento de Facturas, ...  

*/ 


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConciliacionBancaria_MovimientosBancarios](
	[CuentaInterna] [int] NOT NULL,
	[CuentaBancaria] [nvarchar](50) NOT NULL,
	[Transaccion] [nvarchar](20) NOT NULL,
	[Tipo] [nvarchar](2) NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[Beneficiario] [nvarchar](50) NULL,
	[NombreProveedorCliente] [nvarchar](50) NULL,
	[NombreBanco] [nvarchar](10) NULL,
	[SimboloMoneda] [nvarchar](6) NULL,
	[NombreMoneda] [nvarchar](50) NULL,
	[Concepto] [nvarchar](250) NULL,
	[Monto] [money] NOT NULL,
	[FechaEntregado] [datetime] NULL,
	[Conciliacion_FechaEjecucion] [smalldatetime] NULL,
	[Conciliacion_MovimientoBanco_Fecha] [smalldatetime] NULL,
	[Conciliacion_MovimientoBanco_Numero] [nvarchar](50) NULL,
	[Conciliacion_MovimientoBanco_Tipo] [nvarchar](4) NULL,
	[Conciliacion_MovimientoBanco_FechaProceso] [smalldatetime] NULL,
	[Conciliacion_MovimientoBanco_Monto] [money] NULL,
	[NumeroUsuario] [int] NOT NULL,
 CONSTRAINT [PK_ConciliacionBancaria_MovimientosBancarios] PRIMARY KEY CLUSTERED 
(
	[CuentaInterna] ASC,
	[Transaccion] ASC,
	[Tipo] ASC,
	[NumeroUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConciliacionBancaria_MovimientosAConciliar](
	[ClaveUnica] [int] IDENTITY(1,1) NOT NULL,
	[Transaccion] [nvarchar](20) NOT NULL,
	[Tipo] [nvarchar](2) NULL,
	[Fecha] [datetime] NOT NULL,
	[FechaOperacion] [datetime] NULL,
	[Concepto] [nvarchar](250) NULL,
	[Monto] [money] NOT NULL,
	[ConciliadoFlag] [bit] NOT NULL,
	[NumeroUsuario] [int] NOT NULL,
 CONSTRAINT [PK_ConciliacionBancaria_MovimientosAConciliar] PRIMARY KEY CLUSTERED 
(
	[ClaveUnica] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]




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
	[NombreCompania] [nvarchar](50) NOT NULL,
	[NumeroFactura] [nvarchar](25) NOT NULL,
	[NumeroCuota] [smallint] NOT NULL,
	[FechaEmision] [datetime] NOT NULL,
	[FechaRecepcion] [datetime] NOT NULL,
	[FechaVencimiento] [datetime] NOT NULL,
	[DiasVencimiento] [smallint] NOT NULL,
	[TotalCuota] [money] NOT NULL,
	[Anticipo] [money] NULL,
	[TotalAPagar] [money] NOT NULL,
	[MontoYaPagado] [money] NULL,
	[DiasPorVencerOVencidos] [int] NULL,
	[SaldoPendiente] [money] NULL,
	[SaldoPendiente_0] [money] NULL,
	[SaldoPendiente_1] [money] NULL,
	[SaldoPendiente_2] [money] NULL,
	[SaldoPendiente_3] [money] NULL,
	[SaldoPendiente_4] [money] NULL,
	[NumeroUsuario] [int] NOT NULL,
 CONSTRAINT [PK_Bancos_VencimientoFacturas] PRIMARY KEY CLUSTERED 
(
	[CxCCxPFlag] ASC,
	[Compania] ASC,
	[NumeroFactura] ASC,
	[NumeroCuota] ASC,
	[NumeroUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tTempWebReport_DisponibilidadBancos2](
	[CuentaInterna] [int] NOT NULL,
	[Transaccion] [nvarchar](20) NOT NULL,
	[Tipo] [nvarchar](2) NOT NULL,
	[Orden] [smallint] NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[ProvClte] [int] NULL,
	[NombreProveedorCliente] [nvarchar](50) NULL,
	[Beneficiario] [nvarchar](50) NULL,
	[Concepto] [nvarchar](250) NULL,
	[Monto] [money] NOT NULL,
	[FechaEntregado] [datetime] NULL,
	[Conciliacion_FechaEjecucion] [smalldatetime] NULL,
	[CiaContab] [int] NOT NULL,
	[NumeroUsuario] [int] NOT NULL,
 CONSTRAINT [PK_tTempWebReport_DisponibilidadBancos2] PRIMARY KEY CLUSTERED 
(
	[CuentaInterna] ASC,
	[Transaccion] ASC,
	[Tipo] ASC,
	[CiaContab] ASC,
	[NumeroUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tTempWebReport_DisponibilidadBancos](
	[CuentaInterna] [int] NOT NULL,
	[NombreCiaContab] [nvarchar](25) NOT NULL,
	[NombreBanco] [nvarchar](50) NOT NULL,
	[CuentaBancaria] [nvarchar](50) NOT NULL,
	[NombreMoneda] [nvarchar](50) NOT NULL,
	[SimboloMoneda] [nvarchar](6) NOT NULL,
	[FechaSaldoAnterior] [smalldatetime] NOT NULL,
	[SaldoAnterior] [money] NOT NULL,
	[Debitos] [money] NOT NULL,
	[Creditos] [money] NOT NULL,
	[SaldoActual] [money] NOT NULL,
	[FechaSaldoActual] [smalldatetime] NOT NULL,
	[CiaContab] [int] NOT NULL,
	[NumeroUsuario] [int] NOT NULL,
 CONSTRAINT [PK_tTempWebReport_DisponibilidadBancos] PRIMARY KEY CLUSTERED 
(
	[CuentaInterna] ASC,
	[NumeroUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.220', GetDate()) 