/*    Sábado, 15 de Diciembre de 2.008   -   v0.00.225.sql 

	Agregamos las tablas que corresonden a la Disponibilidad Bancaria 

*/ 


/****** Object:  ForeignKey [FK_Disponibilidad_MontosRestringidos_Companias]    Script Date: 11/15/2008 08:53:55 ******/
ALTER TABLE [dbo].[Disponibilidad_MontosRestringidos] DROP CONSTRAINT [FK_Disponibilidad_MontosRestringidos_Companias]
GO
/****** Object:  ForeignKey [FK_Disponibilidad_MontosRestringidos_CuentasBancarias]    Script Date: 11/15/2008 08:53:55 ******/
ALTER TABLE [dbo].[Disponibilidad_MontosRestringidos] DROP CONSTRAINT [FK_Disponibilidad_MontosRestringidos_CuentasBancarias]
GO
/****** Object:  ForeignKey [FK_Disponibilidad_MontosRestringidos_Monedas]    Script Date: 11/15/2008 08:53:55 ******/
ALTER TABLE [dbo].[Disponibilidad_MontosRestringidos] DROP CONSTRAINT [FK_Disponibilidad_MontosRestringidos_Monedas]
GO
/****** Object:  Table [dbo].[Disponibilidad_MontosRestringidos]    Script Date: 11/15/2008 08:53:54 ******/
DROP TABLE [dbo].[Disponibilidad_MontosRestringidos]
GO
/****** Object:  Table [dbo].[tTempWebReport_DisponibilidadBancos2]    Script Date: 11/15/2008 08:54:22 ******/
DROP TABLE [dbo].[tTempWebReport_DisponibilidadBancos2]
GO
/****** Object:  Table [dbo].[tTempWebReport_DisponibilidadBancos]    Script Date: 11/15/2008 08:54:12 ******/
DROP TABLE [dbo].[tTempWebReport_DisponibilidadBancos]
GO
/****** Object:  Table [dbo].[Disponibilidad_MontosRestringidos_ConsultaDisponibilidad]    Script Date: 11/15/2008 08:54:02 ******/
DROP TABLE [dbo].[Disponibilidad_MontosRestringidos_ConsultaDisponibilidad]
GO
/****** Object:  Table [dbo].[tTempWebReport_DisponibilidadBancos2]    Script Date: 11/15/2008 08:54:22 ******/
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
GO
/****** Object:  Table [dbo].[tTempWebReport_DisponibilidadBancos]    Script Date: 11/15/2008 08:54:12 ******/
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
	[NumeroUsuario] [int] NOT NULL,
 CONSTRAINT [PK_tTempWebReport_DisponibilidadBancos] PRIMARY KEY CLUSTERED 
(
	[CuentaInterna] ASC,
	[NumeroUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Disponibilidad_MontosRestringidos_ConsultaDisponibilidad]    Script Date: 11/15/2008 08:54:02 ******/
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
	[NumeroUsuario] [int] NOT NULL,
 CONSTRAINT [PK_Disponibilidad_MontosRestringidos_ConsultaDisponibilidad] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[CiaContab] ASC,
	[Moneda] ASC,
	[CuentaBancaria] ASC,
	[NumeroUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Disponibilidad_MontosRestringidos]    Script Date: 11/15/2008 08:53:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Disponibilidad_MontosRestringidos](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CiaContab] [int] NOT NULL,
	[Moneda] [int] NOT NULL,
	[CuentaBancaria] [int] NOT NULL,
	[Fecha] [smalldatetime] NOT NULL,
	[Monto] [money] NOT NULL,
	[Comentarios] [ntext] NOT NULL,
	[SuspendidoFlag] [bit] NOT NULL,
	[DesactivarEl] [smalldatetime] NULL,
	[Registro_Fecha] [smalldatetime] NOT NULL,
	[Registro_Usuario] [nvarchar](25) NOT NULL,
	[UltAct_Fecha] [smalldatetime] NOT NULL,
	[UltAct_Usuario] [nvarchar](25) NOT NULL,
 CONSTRAINT [PK_Disponibilidad_MontosRestringidos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[CiaContab] ASC,
	[Moneda] ASC,
	[CuentaBancaria] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  ForeignKey [FK_Disponibilidad_MontosRestringidos_Companias]    Script Date: 11/15/2008 08:53:55 ******/
ALTER TABLE [dbo].[Disponibilidad_MontosRestringidos]  WITH CHECK ADD  CONSTRAINT [FK_Disponibilidad_MontosRestringidos_Companias] FOREIGN KEY([CiaContab])
REFERENCES [dbo].[Companias] ([Numero])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Disponibilidad_MontosRestringidos] CHECK CONSTRAINT [FK_Disponibilidad_MontosRestringidos_Companias]
GO
/****** Object:  ForeignKey [FK_Disponibilidad_MontosRestringidos_CuentasBancarias]    Script Date: 11/15/2008 08:53:55 ******/
ALTER TABLE [dbo].[Disponibilidad_MontosRestringidos]  WITH CHECK ADD  CONSTRAINT [FK_Disponibilidad_MontosRestringidos_CuentasBancarias] FOREIGN KEY([CuentaBancaria])
REFERENCES [dbo].[CuentasBancarias] ([CuentaInterna])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Disponibilidad_MontosRestringidos] CHECK CONSTRAINT [FK_Disponibilidad_MontosRestringidos_CuentasBancarias]
GO
/****** Object:  ForeignKey [FK_Disponibilidad_MontosRestringidos_Monedas]    Script Date: 11/15/2008 08:53:55 ******/
ALTER TABLE [dbo].[Disponibilidad_MontosRestringidos]  WITH CHECK ADD  CONSTRAINT [FK_Disponibilidad_MontosRestringidos_Monedas] FOREIGN KEY([Moneda])
REFERENCES [dbo].[Monedas] ([Moneda])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Disponibilidad_MontosRestringidos] CHECK CONSTRAINT [FK_Disponibilidad_MontosRestringidos_Monedas]
GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.225', GetDate()) 