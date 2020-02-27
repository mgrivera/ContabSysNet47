/*    Miércoles, 10 de Septiembre de 2.008   -   v0.00.221.sql 

	Agregamos las tablas 'temporales' para el proceso de Balance de Comprobación, 
	Consulta de Comprobantes y Consulta de Cuentas y sus Movimientos.  

*/ 


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
	[NumeroUsuario] [int] NOT NULL,
 CONSTRAINT [PK_Contab_BalanceComprobacion] PRIMARY KEY CLUSTERED 
(
	[CiaContab] ASC,
	[Moneda] ASC,
	[CuentaContable] ASC,
	[NumeroUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]



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
	[NumeroUsuario] [int] NOT NULL,
 CONSTRAINT [PK_Contab_ConsultaComprobantesContables] PRIMARY KEY CLUSTERED 
(
	[NumeroAutomatico] ASC,
	[CiaContab] ASC,
	[NumeroUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]



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
	[NumeroUsuario] [int] NOT NULL,
 CONSTRAINT [PK_Contab_ConsultaComprobantesContables_Partidas] PRIMARY KEY CLUSTERED 
(
	[NumeroAutomatico] ASC,
	[Partida] ASC,
	[CiaContab] ASC,
	[NumeroUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Contab_ConsultaComprobantesContables_Partidas]  WITH CHECK ADD  CONSTRAINT [FK_Contab_ConsultaComprobantesContables_Partidas_Contab_ConsultaComprobantesContables1] FOREIGN KEY([NumeroAutomatico], [CiaContab], [NumeroUsuario])
REFERENCES [dbo].[Contab_ConsultaComprobantesContables] ([NumeroAutomatico], [CiaContab], [NumeroUsuario])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Contab_ConsultaComprobantesContables_Partidas] CHECK CONSTRAINT [FK_Contab_ConsultaComprobantesContables_Partidas_Contab_ConsultaComprobantesContables1]



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
	[NumeroUsuario] [int] NOT NULL,
 CONSTRAINT [PK_Contab_ConsultaCuentasYMovimientos] PRIMARY KEY CLUSTERED 
(
	[CuentaContable] ASC,
	[Moneda] ASC,
	[CiaContab] ASC,
	[NumeroUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]



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
	[NumeroUsuario] [int] NOT NULL,
 CONSTRAINT [PK_Contab_ConsultaCuentasYMovimientos_Movimientos] PRIMARY KEY CLUSTERED 
(
	[Secuencia] ASC,
	[CuentaContable] ASC,
	[Moneda] ASC,
	[CiaContab] ASC,
	[NumeroUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Contab_ConsultaCuentasYMovimientos_Movimientos]  WITH CHECK ADD  CONSTRAINT [FK_Contab_ConsultaCuentasYMovimientos_Movimientos_Contab_ConsultaCuentasYMovimientos1] FOREIGN KEY([CuentaContable], [Moneda], [CiaContab], [NumeroUsuario])
REFERENCES [dbo].[Contab_ConsultaCuentasYMovimientos] ([CuentaContable], [Moneda], [CiaContab], [NumeroUsuario])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Contab_ConsultaCuentasYMovimientos_Movimientos] CHECK CONSTRAINT [FK_Contab_ConsultaCuentasYMovimientos_Movimientos_Contab_ConsultaCuentasYMovimientos1]




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.221', GetDate()) 