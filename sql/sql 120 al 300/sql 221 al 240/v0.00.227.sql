/*    Sábado, 29 de Noviembre de 2.008  -   v0.00.227.sql 

	Cambiamos el item NumeroUsuario por NombreUsuario en muchas tablas 
	'temporales' 

*/ 



/****** Object:  ForeignKey [FK_tTempWebReport_PresupuestoConsultaMensual_Presupuesto_Codigos]    Script Date: 11/29/2008 11:15:56 ******/
ALTER TABLE [dbo].[tTempWebReport_PresupuestoConsultaMensual] DROP CONSTRAINT [FK_tTempWebReport_PresupuestoConsultaMensual_Presupuesto_Codigos]
GO
/****** Object:  ForeignKey [FK_Contab_ConsultaCuentasYMovimientos_Movimientos_Contab_ConsultaCuentasYMovimientos1]    Script Date: 11/29/2008 11:16:41 ******/
ALTER TABLE [dbo].[Contab_ConsultaCuentasYMovimientos_Movimientos] DROP CONSTRAINT [FK_Contab_ConsultaCuentasYMovimientos_Movimientos_Contab_ConsultaCuentasYMovimientos1]
GO
/****** Object:  Table [dbo].[Contab_BalanceComprobacion]    Script Date: 11/29/2008 11:17:01 ******/
DROP TABLE [dbo].[Contab_BalanceComprobacion]
GO
/****** Object:  Table [dbo].[tTempWebReport_PresupuestoConsultaMensual]    Script Date: 11/29/2008 11:15:55 ******/
DROP TABLE [dbo].[tTempWebReport_PresupuestoConsultaMensual]
GO
/****** Object:  Table [dbo].[tTempWebReport_DisponibilidadBancos2]    Script Date: 11/29/2008 11:16:12 ******/
DROP TABLE [dbo].[tTempWebReport_DisponibilidadBancos2]
GO
/****** Object:  Table [dbo].[tTempWebReport_DisponibilidadBancos]    Script Date: 11/29/2008 11:16:04 ******/
DROP TABLE [dbo].[tTempWebReport_DisponibilidadBancos]
GO
/****** Object:  Table [dbo].[Disponibilidad_MontosRestringidos_ConsultaDisponibilidad]    Script Date: 11/29/2008 11:17:07 ******/
DROP TABLE [dbo].[Disponibilidad_MontosRestringidos_ConsultaDisponibilidad]
GO
/****** Object:  Table [dbo].[ConciliacionBancaria_MovimientosAConciliar]    Script Date: 11/29/2008 11:17:12 ******/
DROP TABLE [dbo].[ConciliacionBancaria_MovimientosAConciliar]
GO
/****** Object:  Table [dbo].[ConciliacionBancaria_MovimientosBancarios]    Script Date: 11/29/2008 11:17:22 ******/
DROP TABLE [dbo].[ConciliacionBancaria_MovimientosBancarios]
GO
/****** Object:  Table [dbo].[tTempWebReport_ConsultaFacturas]    Script Date: 11/29/2008 11:15:47 ******/
DROP TABLE [dbo].[tTempWebReport_ConsultaFacturas]
GO
/****** Object:  Table [dbo].[Bancos_VencimientoFacturas]    Script Date: 11/29/2008 11:16:26 ******/
DROP TABLE [dbo].[Bancos_VencimientoFacturas]
GO
/****** Object:  Table [dbo].[Contab_ConsultaCuentasYMovimientos_Movimientos]    Script Date: 11/29/2008 11:16:40 ******/
DROP TABLE [dbo].[Contab_ConsultaCuentasYMovimientos_Movimientos]
GO
/****** Object:  Table [dbo].[Contab_ConsultaCuentasYMovimientos]    Script Date: 11/29/2008 11:16:31 ******/
DROP TABLE [dbo].[Contab_ConsultaCuentasYMovimientos]
GO
/****** Object:  Table [dbo].[Contab_ConsultaComprobantesContables]    Script Date: 11/29/2008 11:16:51 ******/

ALTER TABLE [dbo].[Contab_ConsultaComprobantesContables_Partidas] DROP CONSTRAINT [FK_Contab_ConsultaComprobantesContables_Partidas_Contab_ConsultaComprobantesContables]
GO
DROP TABLE [dbo].[Contab_ConsultaComprobantesContables_Partidas]
GO

DROP TABLE [dbo].[Contab_ConsultaComprobantesContables]
GO
/****** Object:  Table [dbo].[tTempWebReport_ConsultaFacturas]    Script Date: 11/29/2008 11:15:47 ******/
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
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_tTempWebReport_ConsultaFacturas] PRIMARY KEY CLUSTERED 
(
	[Moneda] ASC,
	[CiaContab] ASC,
	[Compania] ASC,
	[NumeroFactura] ASC,
	[NombreUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Bancos_VencimientoFacturas]    Script Date: 11/29/2008 11:16:26 ******/
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
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_Bancos_VencimientoFacturas] PRIMARY KEY CLUSTERED 
(
	[CxCCxPFlag] ASC,
	[Compania] ASC,
	[NumeroFactura] ASC,
	[NumeroCuota] ASC,
	[NombreUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Contab_ConsultaCuentasYMovimientos]    Script Date: 11/29/2008 11:16:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contab_ConsultaCuentasYMovimientos](
	[CuentaContable] [nvarchar](25) NOT NULL,
	[Descripcion] [nvarchar](40) NOT NULL,
	[CuentaContableEditada] [nvarchar](30) NOT NULL,
	[Moneda] [int] NOT NULL,
	[NombreMoneda] [nvarchar](50) NOT NULL,
	[SimboloMoneda] [nvarchar](6) NOT NULL,
	[CiaContab] [int] NOT NULL,
	[NombreCiaContab] [nvarchar](25) NOT NULL,
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_Contab_ConsultaCuentasYMovimientos] PRIMARY KEY CLUSTERED 
(
	[CuentaContable] ASC,
	[Moneda] ASC,
	[CiaContab] ASC,
	[NombreUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tTempWebReport_DisponibilidadBancos2]    Script Date: 11/29/2008 11:16:12 ******/
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
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_tTempWebReport_DisponibilidadBancos2] PRIMARY KEY CLUSTERED 
(
	[CuentaInterna] ASC,
	[Transaccion] ASC,
	[Tipo] ASC,
	[CiaContab] ASC,
	[NombreUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tTempWebReport_DisponibilidadBancos]    Script Date: 11/29/2008 11:16:04 ******/
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
	[MontoRestringido] [money] NOT NULL,
	[SaldoActual2] [money] NOT NULL,
	[FechaSaldoActual] [smalldatetime] NOT NULL,
	[CiaContab] [int] NOT NULL,
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_tTempWebReport_DisponibilidadBancos] PRIMARY KEY CLUSTERED 
(
	[CuentaInterna] ASC,
	[NombreUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Disponibilidad_MontosRestringidos_ConsultaDisponibilidad]    Script Date: 11/29/2008 11:17:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Disponibilidad_MontosRestringidos_ConsultaDisponibilidad](
	[ID] [int] NOT NULL,
	[CiaContab] [int] NOT NULL,
	[Moneda] [int] NOT NULL,
	[CuentaBancaria] [int] NOT NULL,
	[Fecha] [smalldatetime] NOT NULL,
	[Monto] [money] NOT NULL,
	[Comentarios] [ntext] NOT NULL,
	[DesactivarEl] [smalldatetime] NULL,
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_Disponibilidad_MontosRestringidos_ConsultaDisponibilidad] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[CiaContab] ASC,
	[Moneda] ASC,
	[CuentaBancaria] ASC,
	[NombreUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConciliacionBancaria_MovimientosAConciliar]    Script Date: 11/29/2008 11:17:12 ******/
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
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_ConciliacionBancaria_MovimientosAConciliar] PRIMARY KEY CLUSTERED 
(
	[ClaveUnica] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConciliacionBancaria_MovimientosBancarios]    Script Date: 11/29/2008 11:17:22 ******/
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
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_ConciliacionBancaria_MovimientosBancarios] PRIMARY KEY CLUSTERED 
(
	[CuentaInterna] ASC,
	[Transaccion] ASC,
	[Tipo] ASC,
	[NombreUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Contab_ConsultaComprobantesContables]    Script Date: 11/29/2008 11:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contab_ConsultaComprobantesContables](
	[NumeroAutomatico] [int] NOT NULL,
	[Numero] [smallint] NOT NULL,
	[Tipo] [nvarchar](6) NOT NULL,
	[NombreTipo] [nvarchar](50) NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[Descripcion] [nvarchar](250) NULL,
	[NumPartidas] [smallint] NOT NULL,
	[TotalDebe] [money] NOT NULL,
	[TotalHaber] [money] NOT NULL,
	[Moneda] [int] NOT NULL,
	[NombreMoneda] [nvarchar](50) NOT NULL,
	[SimboloMoneda] [nvarchar](6) NOT NULL,
	[MonedaOriginal] [int] NOT NULL,
	[NombreMonedaOriginal] [nvarchar](50) NOT NULL,
	[SimboloMonedaOriginal] [nvarchar](6) NOT NULL,
	[FactorDeCambio] [money] NOT NULL,
	[ProvieneDe] [nvarchar](25) NULL,
	[CiaContab] [int] NOT NULL,
	[NombreCiaContab] [nvarchar](25) NOT NULL,
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_Contab_ConsultaComprobantesContables] PRIMARY KEY CLUSTERED 
(
	[NumeroAutomatico] ASC,
	[CiaContab] ASC,
	[NombreUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


/****** Object:  Table [dbo].[Contab_ConsultaComprobantesContables_Partidas]    Script Date: 11/29/2008 11:23:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contab_ConsultaComprobantesContables_Partidas](
	[NumeroAutomatico] [int] NOT NULL,
	[CuentaContable] [nvarchar](25) NOT NULL,
	[CuentaContableEditada] [nvarchar](30) NOT NULL,
	[NombreCuentaContable] [nvarchar](40) NOT NULL,
	[Partida] [smallint] NOT NULL,
	[Descripcion] [nvarchar](50) NULL,
	[Referencia] [nvarchar](20) NULL,
	[Debe] [money] NOT NULL,
	[Haber] [money] NOT NULL,
	[CiaContab] [int] NOT NULL,
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_Contab_ConsultaComprobantesContables_Partidas] PRIMARY KEY CLUSTERED 
(
	[NumeroAutomatico] ASC,
	[Partida] ASC,
	[CiaContab] ASC,
	[NombreUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Contab_ConsultaComprobantesContables_Partidas]  WITH CHECK ADD  CONSTRAINT [FK_Contab_ConsultaComprobantesContables_Partidas_Contab_ConsultaComprobantesContables] FOREIGN KEY([NumeroAutomatico], [CiaContab], [NombreUsuario])
REFERENCES [dbo].[Contab_ConsultaComprobantesContables] ([NumeroAutomatico], [CiaContab], [NombreUsuario])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Contab_ConsultaComprobantesContables_Partidas] CHECK CONSTRAINT [FK_Contab_ConsultaComprobantesContables_Partidas_Contab_ConsultaComprobantesContables]



/****** Object:  Table [dbo].[Contab_BalanceComprobacion]    Script Date: 11/29/2008 11:17:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contab_BalanceComprobacion](
	[CiaContab] [int] NOT NULL,
	[NombreCiaContab] [nvarchar](25) NULL,
	[GrupoContable] [int] NOT NULL,
	[NombreGrupoContable] [nvarchar](50) NULL,
	[OrdenGrupoContable] [nchar](10) NULL,
	[Moneda] [int] NOT NULL,
	[NombreMoneda] [nvarchar](50) NULL,
	[SimboloMoneda] [nvarchar](6) NULL,
	[CuentaContable_NivelPrevio] [nvarchar](25) NULL,
	[CuentaContable_NivelPrevio_Descripcion] [nvarchar](40) NULL,
	[CuentaContable] [nvarchar](25) NOT NULL,
	[CuentaContableEditada] [nvarchar](30) NULL,
	[CuentaContable_Nombre] [nvarchar](40) NULL,
	[SaldoAnterior] [money] NULL,
	[Debe] [money] NULL,
	[Haber] [money] NULL,
	[SaldoActual] [money] NULL,
	[CantidadMovimientos] [int] NULL,
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_Contab_BalanceComprobacion] PRIMARY KEY CLUSTERED 
(
	[CiaContab] ASC,
	[Moneda] ASC,
	[CuentaContable] ASC,
	[NombreUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Contab_ConsultaCuentasYMovimientos_Movimientos]    Script Date: 11/29/2008 11:16:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contab_ConsultaCuentasYMovimientos_Movimientos](
	[Secuencia] [smallint] NOT NULL,
	[CuentaContable] [nvarchar](25) NOT NULL,
	[NumeroComprobante] [smallint] NULL,
	[NumeroAutomatico] [int] NULL,
	[Mes] [tinyint] NOT NULL,
	[Ano] [smallint] NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[Moneda] [int] NOT NULL,
	[SimboloMoneda] [nvarchar](6) NOT NULL,
	[MonedaOriginal] [int] NULL,
	[SimboloMonedaOriginal] [nvarchar](6) NULL,
	[Descripcion] [nvarchar](50) NULL,
	[Referencia] [nvarchar](20) NULL,
	[Monto] [money] NOT NULL,
	[CiaContab] [int] NOT NULL,
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_Contab_ConsultaCuentasYMovimientos_Movimientos] PRIMARY KEY CLUSTERED 
(
	[Secuencia] ASC,
	[CuentaContable] ASC,
	[Moneda] ASC,
	[CiaContab] ASC,
	[NombreUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tTempWebReport_PresupuestoConsultaMensual]    Script Date: 11/29/2008 11:15:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tTempWebReport_PresupuestoConsultaMensual](
	[CiaContab] [int] NOT NULL,
	[Moneda] [int] NOT NULL,
	[AnoFiscal] [smallint] NOT NULL,
	[MesCalendario] [smallint] NOT NULL,
	[NombreMes] [nvarchar](20) NOT NULL,
	[CodigoPresupuesto] [nvarchar](70) NOT NULL,
	[MontoEstimado] [money] NOT NULL,
	[MontoEjecutado] [money] NOT NULL,
	[Variacion] [real] NOT NULL,
	[MontoEstimadoAcum] [money] NOT NULL,
	[MontoEjecutadoAcum] [money] NOT NULL,
	[VariacionAcum] [real] NOT NULL,
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_tTempWebReport_PresupuestoConsultaMensual] PRIMARY KEY CLUSTERED 
(
	[CiaContab] ASC,
	[Moneda] ASC,
	[AnoFiscal] ASC,
	[MesCalendario] ASC,
	[CodigoPresupuesto] ASC,
	[NombreUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  ForeignKey [FK_tTempWebReport_PresupuestoConsultaMensual_Presupuesto_Codigos]    Script Date: 11/29/2008 11:15:56 ******/
ALTER TABLE [dbo].[tTempWebReport_PresupuestoConsultaMensual]  WITH CHECK ADD  CONSTRAINT [FK_tTempWebReport_PresupuestoConsultaMensual_Presupuesto_Codigos] FOREIGN KEY([CodigoPresupuesto], [CiaContab])
REFERENCES [dbo].[Presupuesto_Codigos] ([Codigo], [CiaContab])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tTempWebReport_PresupuestoConsultaMensual] CHECK CONSTRAINT [FK_tTempWebReport_PresupuestoConsultaMensual_Presupuesto_Codigos]
GO
/****** Object:  ForeignKey [FK_Contab_ConsultaCuentasYMovimientos_Movimientos_Contab_ConsultaCuentasYMovimientos1]    Script Date: 11/29/2008 11:16:41 ******/
ALTER TABLE [dbo].[Contab_ConsultaCuentasYMovimientos_Movimientos]  WITH CHECK ADD  CONSTRAINT [FK_Contab_ConsultaCuentasYMovimientos_Movimientos_Contab_ConsultaCuentasYMovimientos1] FOREIGN KEY([CuentaContable], [Moneda], [CiaContab], [NombreUsuario])
REFERENCES [dbo].[Contab_ConsultaCuentasYMovimientos] ([CuentaContable], [Moneda], [CiaContab], [NombreUsuario])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Contab_ConsultaCuentasYMovimientos_Movimientos] CHECK CONSTRAINT [FK_Contab_ConsultaCuentasYMovimientos_Movimientos_Contab_ConsultaCuentasYMovimientos1]
GO


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.227', GetDate()) 