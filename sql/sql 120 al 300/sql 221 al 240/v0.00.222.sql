/*    Miércoles, 15 de Octubre de 2.008   -   v0.00.222.sql 

	Agregamos las tablas que conforman el Control Presupuestario 
	NOTA: estas tablas pueden cambiar pues ahora estamos completando este proceso 

	NOTA IMPORTANTE: las instrucciones primeras van a fallar si no se han creado 
	estas tablas antes !! 

*/ 

/****** Object:  ForeignKey [FK_Presupuesto_AsociacionCodigosCuentas_CuentasContables]    Script Date: 10/28/2008 11:41:51 ******/
ALTER TABLE [dbo].[Presupuesto_AsociacionCodigosCuentas] DROP CONSTRAINT [FK_Presupuesto_AsociacionCodigosCuentas_CuentasContables]
GO
/****** Object:  ForeignKey [FK_Presupuesto_AsociacionCodigosCuentas_Presupuesto_Codigos]    Script Date: 10/28/2008 11:41:52 ******/
ALTER TABLE [dbo].[Presupuesto_AsociacionCodigosCuentas] DROP CONSTRAINT [FK_Presupuesto_AsociacionCodigosCuentas_Presupuesto_Codigos]
GO
/****** Object:  ForeignKey [FK_Presupuesto_Codigos_Companias]    Script Date: 10/28/2008 11:41:56 ******/
ALTER TABLE [dbo].[Presupuesto_Codigos] DROP CONSTRAINT [FK_Presupuesto_Codigos_Companias]
GO
/****** Object:  ForeignKey [FK_Presupuesto_Montos_Monedas]    Script Date: 10/28/2008 11:42:11 ******/
ALTER TABLE [dbo].[Presupuesto_Montos] DROP CONSTRAINT [FK_Presupuesto_Montos_Monedas]
GO
/****** Object:  ForeignKey [FK_Presupuesto_Montos_Presupuesto_Codigos]    Script Date: 10/28/2008 11:42:11 ******/
ALTER TABLE [dbo].[Presupuesto_Montos] DROP CONSTRAINT [FK_Presupuesto_Montos_Presupuesto_Codigos]
GO
/****** Object:  ForeignKey [FK_Presupuesto_UltimoMesCerrado_Companias]    Script Date: 10/28/2008 11:42:15 ******/
ALTER TABLE [dbo].[Presupuesto_UltimoMesCerrado] DROP CONSTRAINT [FK_Presupuesto_UltimoMesCerrado_Companias]
GO
/****** Object:  Table [dbo].[Presupuesto_AsociacionCodigosCuentas]    Script Date: 10/28/2008 11:41:51 ******/
DROP TABLE [dbo].[Presupuesto_AsociacionCodigosCuentas]
GO
/****** Object:  Table [dbo].[Presupuesto_Montos]    Script Date: 10/28/2008 11:42:10 ******/
DROP TABLE [dbo].[Presupuesto_Montos]
GO
/****** Object:  Table [dbo].[Presupuesto_UltimoMesCerrado]    Script Date: 10/28/2008 11:42:14 ******/
DROP TABLE [dbo].[Presupuesto_UltimoMesCerrado]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tTempWebReport_PresupuestoConsultaMensual_Presupuesto_Codigos]') AND parent_object_id = OBJECT_ID(N'[dbo].[tTempWebReport_PresupuestoConsultaMensual]'))
ALTER TABLE [dbo].[tTempWebReport_PresupuestoConsultaMensual] DROP CONSTRAINT [FK_tTempWebReport_PresupuestoConsultaMensual_Presupuesto_Codigos]
GO
/***
*** Object:  Table [dbo].[tTempWebReport_PresupuestoConsultaMensual]    Script Date: 10/31/2008 11:36:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tTempWebReport_PresupuestoConsultaMensual]') AND type in (N'U'))
DROP TABLE [dbo].[tTempWebReport_PresupuestoConsultaMensual]
GO

/****** Object:  Table [dbo].[Presupuesto_Codigos]    Script Date: 10/28/2008 11:41:56 ******/
DROP TABLE [dbo].[Presupuesto_Codigos]
GO
/****** Object:  Table [dbo].[Presupuesto_Montos]    Script Date: 10/28/2008 11:42:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Presupuesto_Montos](
	[CodigoPresupuesto] [nvarchar](70) NOT NULL,
	[CiaContab] [int] NOT NULL,
	[Moneda] [int] NOT NULL,
	[Ano] [smallint] NOT NULL,
	[Mes01_Est] [money] NULL,
	[Mes01_Eje] [money] NULL,
	[Mes02_Est] [money] NULL,
	[Mes02_Eje] [money] NULL,
	[Mes03_Est] [money] NULL,
	[Mes03_Eje] [money] NULL,
	[Mes04_Est] [money] NULL,
	[Mes04_Eje] [money] NULL,
	[Mes05_Est] [money] NULL,
	[Mes05_Eje] [money] NULL,
	[Mes06_Est] [money] NULL,
	[Mes06_Eje] [money] NULL,
	[Mes07_Est] [money] NULL,
	[Mes07_Eje] [money] NULL,
	[Mes08_Est] [money] NULL,
	[Mes08_Eje] [money] NULL,
	[Mes09_Est] [money] NULL,
	[Mes09_Eje] [money] NULL,
	[Mes10_Est] [money] NULL,
	[Mes10_Eje] [money] NULL,
	[Mes11_Est] [money] NULL,
	[Mes11_Eje] [money] NULL,
	[Mes12_Est] [money] NULL,
	[Mes12_Eje] [money] NULL,
 CONSTRAINT [PK_Presupuesto_Montos] PRIMARY KEY CLUSTERED 
(
	[CodigoPresupuesto] ASC,
	[CiaContab] ASC,
	[Moneda] ASC,
	[Ano] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Presupuesto_AsociacionCodigosCuentas]    Script Date: 10/28/2008 11:41:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Presupuesto_AsociacionCodigosCuentas](
	[CodigoPresupuesto] [nvarchar](70) NOT NULL,
	[CuentaContable] [nvarchar](25) NOT NULL,
	[CiaContab] [int] NOT NULL,
 CONSTRAINT [PK_Presupuesto_AsociacionCodigosCuentas] PRIMARY KEY CLUSTERED 
(
	[CodigoPresupuesto] ASC,
	[CuentaContable] ASC,
	[CiaContab] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Presupuesto_Codigos]    Script Date: 10/28/2008 11:41:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Presupuesto_Codigos](
	[Codigo] [nvarchar](70) NOT NULL,
	[Descripcion] [nvarchar](100) NOT NULL,
	[CantNiveles] [smallint] NOT NULL,
	[GrupoFlag] [bit] NOT NULL,
	[SuspendidoFlag] [bit] NOT NULL,
	[CiaContab] [int] NOT NULL,
 CONSTRAINT [PK_Presupuesto_Codigos] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC,
	[CiaContab] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Presupuesto_UltimoMesCerrado]    Script Date: 10/28/2008 11:42:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Presupuesto_UltimoMesCerrado](
	[Mes] [smallint] NOT NULL,
	[Ano] [smallint] NOT NULL,
	[CiaContab] [int] NOT NULL,
	[NombreUsuario] [nvarchar](25) NOT NULL,
	[FechaEjecucion] [datetime] NOT NULL,
 CONSTRAINT [PK_Presupuesto_UltimoMesCerrado_1] PRIMARY KEY CLUSTERED 
(
	[CiaContab] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  ForeignKey [FK_Presupuesto_AsociacionCodigosCuentas_CuentasContables]    Script Date: 10/28/2008 11:41:51 ******/
ALTER TABLE [dbo].[Presupuesto_AsociacionCodigosCuentas]  WITH CHECK ADD  CONSTRAINT [FK_Presupuesto_AsociacionCodigosCuentas_CuentasContables] FOREIGN KEY([CuentaContable], [CiaContab])
REFERENCES [dbo].[CuentasContables] ([Cuenta], [Cia])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Presupuesto_AsociacionCodigosCuentas] CHECK CONSTRAINT [FK_Presupuesto_AsociacionCodigosCuentas_CuentasContables]
GO
/****** Object:  ForeignKey [FK_Presupuesto_AsociacionCodigosCuentas_Presupuesto_Codigos]    Script Date: 10/28/2008 11:41:52 ******/
ALTER TABLE [dbo].[Presupuesto_AsociacionCodigosCuentas]  WITH CHECK ADD  CONSTRAINT [FK_Presupuesto_AsociacionCodigosCuentas_Presupuesto_Codigos] FOREIGN KEY([CodigoPresupuesto], [CiaContab])
REFERENCES [dbo].[Presupuesto_Codigos] ([Codigo], [CiaContab])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Presupuesto_AsociacionCodigosCuentas] CHECK CONSTRAINT [FK_Presupuesto_AsociacionCodigosCuentas_Presupuesto_Codigos]
GO
/****** Object:  ForeignKey [FK_Presupuesto_Codigos_Companias]    Script Date: 10/28/2008 11:41:56 ******/
ALTER TABLE [dbo].[Presupuesto_Codigos]  WITH CHECK ADD  CONSTRAINT [FK_Presupuesto_Codigos_Companias] FOREIGN KEY([CiaContab])
REFERENCES [dbo].[Companias] ([Numero])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Presupuesto_Codigos] CHECK CONSTRAINT [FK_Presupuesto_Codigos_Companias]
GO
/****** Object:  ForeignKey [FK_Presupuesto_Montos_Monedas]    Script Date: 10/28/2008 11:42:11 ******/
ALTER TABLE [dbo].[Presupuesto_Montos]  WITH CHECK ADD  CONSTRAINT [FK_Presupuesto_Montos_Monedas] FOREIGN KEY([Moneda])
REFERENCES [dbo].[Monedas] ([Moneda])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Presupuesto_Montos] CHECK CONSTRAINT [FK_Presupuesto_Montos_Monedas]
GO
/****** Object:  ForeignKey [FK_Presupuesto_Montos_Presupuesto_Codigos]    Script Date: 10/28/2008 11:42:11 ******/
ALTER TABLE [dbo].[Presupuesto_Montos]  WITH CHECK ADD  CONSTRAINT [FK_Presupuesto_Montos_Presupuesto_Codigos] FOREIGN KEY([CodigoPresupuesto], [CiaContab])
REFERENCES [dbo].[Presupuesto_Codigos] ([Codigo], [CiaContab])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Presupuesto_Montos] CHECK CONSTRAINT [FK_Presupuesto_Montos_Presupuesto_Codigos]
GO
/****** Object:  ForeignKey [FK_Presupuesto_UltimoMesCerrado_Companias]    Script Date: 10/28/2008 11:42:15 ******/
ALTER TABLE [dbo].[Presupuesto_UltimoMesCerrado]  WITH CHECK ADD  CONSTRAINT [FK_Presupuesto_UltimoMesCerrado_Companias] FOREIGN KEY([CiaContab])
REFERENCES [dbo].[Companias] ([Numero])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Presupuesto_UltimoMesCerrado] CHECK CONSTRAINT [FK_Presupuesto_UltimoMesCerrado_Companias]
GO

/****** Object:  Table [dbo].[tTempWebReport_PresupuestoConsultaMensual]    Script Date: 10/31/2008 11:37:24 ******/
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
	[NumeroUsuario] [int] NOT NULL,
 CONSTRAINT [PK_tTempWebReport_PresupuestoConsultaMensual] PRIMARY KEY CLUSTERED 
(
	[CiaContab] ASC,
	[Moneda] ASC,
	[AnoFiscal] ASC,
	[MesCalendario] ASC,
	[CodigoPresupuesto] ASC,
	[NumeroUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[tTempWebReport_PresupuestoConsultaMensual]  WITH CHECK ADD  CONSTRAINT [FK_tTempWebReport_PresupuestoConsultaMensual_Presupuesto_Codigos] FOREIGN KEY([CodigoPresupuesto], [CiaContab])
REFERENCES [dbo].[Presupuesto_Codigos] ([Codigo], [CiaContab])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tTempWebReport_PresupuestoConsultaMensual] CHECK CONSTRAINT [FK_tTempWebReport_PresupuestoConsultaMensual_Presupuesto_Codigos]




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.222', GetDate()) 