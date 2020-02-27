/*    Miercoles, 23 de 2.013  -   v0.00.328.sql 

	Modificamos las tablas que se usan en las consultas web de contabilidad 
	
	Nota: ejecutar las instrucciones en forma separada; algunos constraints pueden 
		  no existir ... (*solo* las primeras instrucciones pueden fallar; por alguna 
		  razón, algunos constraints, y hasta tablas, no existen en la base de datos). 
*/




/****** Object:  ForeignKey [FK_Contab_ConsultaCuentasYMovimientos_Movimientos_Contab_ConsultaCuentasYMovimientos]    Script Date: 01/23/2013 17:35:18 ******/
ALTER TABLE [dbo].[Contab_ConsultaCuentasYMovimientos_Movimientos] DROP CONSTRAINT [FK_Contab_ConsultaCuentasYMovimientos_Movimientos_Contab_ConsultaCuentasYMovimientos]
GO
/****** Object:  ForeignKey [FK_tTempWebReport_ConsultaComprobantesContables_Partidas_tTempWebReport_ConsultaComprobantesContables1]    Script Date: 01/23/2013 17:35:18 ******/
ALTER TABLE [dbo].[tTempWebReport_ConsultaComprobantesContables_Partidas] DROP CONSTRAINT [FK_tTempWebReport_ConsultaComprobantesContables_Partidas_tTempWebReport_ConsultaComprobantesContables1]
GO
/****** Object:  View [dbo].[vContab_ConsultaCuentasYMovimientos]    Script Date: 01/23/2013 17:35:18 ******/
DROP VIEW [dbo].[vContab_ConsultaCuentasYMovimientos]
GO
/****** Object:  Table [dbo].[tTempWebReport_ConsultaComprobantesContables_Partidas]    Script Date: 01/23/2013 17:35:18 ******/
ALTER TABLE [dbo].[tTempWebReport_ConsultaComprobantesContables_Partidas] DROP CONSTRAINT [FK_tTempWebReport_ConsultaComprobantesContables_Partidas_tTempWebReport_ConsultaComprobantesContables1]
GO
DROP TABLE [dbo].[tTempWebReport_ConsultaComprobantesContables_Partidas]
GO
/****** Object:  Table [dbo].[Contab_ConsultaCuentasYMovimientos_Movimientos]    Script Date: 01/23/2013 17:35:18 ******/
ALTER TABLE [dbo].[Contab_ConsultaCuentasYMovimientos_Movimientos] DROP CONSTRAINT [FK_Contab_ConsultaCuentasYMovimientos_Movimientos_Contab_ConsultaCuentasYMovimientos]
GO
DROP TABLE [dbo].[Contab_ConsultaCuentasYMovimientos_Movimientos]
GO
/****** Object:  Table [dbo].[tTempActivosFijos_DepreciacionMensual]    Script Date: 01/23/2013 17:35:18 ******/
DROP TABLE [dbo].[tTempActivosFijos_DepreciacionMensual]
GO
/****** Object:  Table [dbo].[tTempWebReport_ConsultaComprobantesContables]    Script Date: 01/23/2013 17:35:18 ******/
DROP TABLE [dbo].[tTempWebReport_ConsultaComprobantesContables]
GO
/****** Object:  Table [dbo].[Contab_BalanceComprobacion]    Script Date: 01/23/2013 17:35:18 ******/
DROP TABLE [dbo].[Contab_BalanceComprobacion]
GO
/****** Object:  Table [dbo].[Contab_ConsultaCuentasYMovimientos]    Script Date: 01/23/2013 17:35:18 ******/
DROP TABLE [dbo].[Contab_ConsultaCuentasYMovimientos]
GO
/****** Object:  Table [dbo].[Contab_ConsultaCuentasYMovimientos]    Script Date: 01/23/2013 17:35:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contab_ConsultaCuentasYMovimientos](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CuentaContableID] [int] NOT NULL,
	[Moneda] [int] NOT NULL,
	[CantMovtos] [smallint] NOT NULL,
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_Contab_ConsultaCuentasYMovimientos_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Contab_BalanceComprobacion]    Script Date: 01/23/2013 17:35:18 ******/
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
	[CuentaContableID] [int] NOT NULL,
	[CuentaContable] [nvarchar](25) NOT NULL,
	[CuentaContableEditada] [nvarchar](30) NULL,
	[CuentaContable_Nombre] [nvarchar](40) NULL,
	[SaldoAnterior] [money] NULL,
	[Debe] [money] NULL,
	[Haber] [money] NULL,
	[SaldoActual] [money] NULL,
	[CantidadMovimientos] [int] NULL,
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_Contab_BalanceComprobacion_1] PRIMARY KEY CLUSTERED 
(
	[CiaContab] ASC,
	[Moneda] ASC,
	[CuentaContableID] ASC,
	[NombreUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tTempWebReport_ConsultaComprobantesContables]    Script Date: 01/23/2013 17:35:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tTempWebReport_ConsultaComprobantesContables](
	[NumeroAutomatico] [int] NOT NULL,
	[Numero] [smallint] NOT NULL,
	[Tipo] [nvarchar](6) NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[Descripcion] [nvarchar](250) NULL,
	[NumPartidas] [smallint] NOT NULL,
	[TotalDebe] [money] NOT NULL,
	[TotalHaber] [money] NOT NULL,
	[Moneda] [int] NOT NULL,
	[MonedaOriginal] [int] NOT NULL,
	[FactorDeCambio] [money] NOT NULL,
	[ProvieneDe] [nvarchar](25) NULL,
	[CiaContab] [int] NOT NULL,
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_tTempWebReport_ConsultaComprobantesContables] PRIMARY KEY CLUSTERED 
(
	[NumeroAutomatico] ASC,
	[NombreUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tTempActivosFijos_DepreciacionMensual]    Script Date: 01/23/2013 17:35:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tTempActivosFijos_DepreciacionMensual](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Cia] [int] NOT NULL,
	[Departamento] [int] NOT NULL,
	[Tipo] [int] NOT NULL,
	[Producto] [nvarchar](15) NOT NULL,
	[Descripcion] [nvarchar](255) NOT NULL,
	[FechaCompra] [date] NOT NULL,
	[Proveedor] [int] NULL,
	[MontoADepreciar] [money] NOT NULL,
	[VidaUtil_Anos] [decimal](5, 2) NOT NULL,
	[MontoDepreciacionMensual] [money] NOT NULL,
 CONSTRAINT [PK_tTempInventarioActivosFijos_DepreciacionMensual] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Contab_ConsultaCuentasYMovimientos_Movimientos]    Script Date: 01/23/2013 17:35:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contab_ConsultaCuentasYMovimientos_Movimientos](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ParentID] [int] NOT NULL,
	[Secuencia] [smallint] NOT NULL,
	[AsientoID] [int] NOT NULL,
	[CuentaContableID] [int] NOT NULL,
	[Partida] [smallint] NULL,
	[Referencia] [nvarchar](20) NULL,
	[Descripcion] [nvarchar](75) NOT NULL,
	[Monto] [money] NOT NULL,
 CONSTRAINT [PK_Contab_ConsultaCuentasYMovimientos_Movimientos_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tTempWebReport_ConsultaComprobantesContables_Partidas]    Script Date: 01/23/2013 17:35:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tTempWebReport_ConsultaComprobantesContables_Partidas](
	[NumeroAutomatico] [int] NOT NULL,
	[CuentaContable] [nvarchar](25) NOT NULL,
	[Partida] [smallint] NOT NULL,
	[Descripcion] [nvarchar](75) NULL,
	[Referencia] [nvarchar](20) NULL,
	[Debe] [money] NOT NULL,
	[Haber] [money] NOT NULL,
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_tTempWebReport_ConsultaComprobantesContables_Partidas] PRIMARY KEY CLUSTERED 
(
	[NumeroAutomatico] ASC,
	[Partida] ASC,
	[NombreUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vContab_ConsultaCuentasYMovimientos]    Script Date: 01/23/2013 17:35:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vContab_ConsultaCuentasYMovimientos]
AS
SELECT     dbo.Companias.Nombre AS NombreCiaContab, Monedas_1.Descripcion AS NombreMoneda, Monedas_1.Simbolo AS SimboloMoneda, 
                      dbo.CuentasContables.CuentaEditada AS CuentaContableEditada, dbo.CuentasContables.Descripcion AS NombreCuentaContable, 
                      dbo.Asientos.Numero AS NumeroComprobante, dbo.Asientos.Fecha, dbo.Monedas.Simbolo AS SimboloMonedaOriginal, 
                      dbo.Contab_ConsultaCuentasYMovimientos_Movimientos.Secuencia, dbo.Contab_ConsultaCuentasYMovimientos_Movimientos.Partida, 
                      dbo.Contab_ConsultaCuentasYMovimientos_Movimientos.Descripcion, dbo.Contab_ConsultaCuentasYMovimientos_Movimientos.Referencia, 
                      CASE WHEN dbo.Contab_ConsultaCuentasYMovimientos_Movimientos.Monto > 0 THEN dbo.Contab_ConsultaCuentasYMovimientos_Movimientos.Monto ELSE 0 END
                       AS Debe, 
                      CASE WHEN dbo.Contab_ConsultaCuentasYMovimientos_Movimientos.Monto < 0 THEN (dbo.Contab_ConsultaCuentasYMovimientos_Movimientos.Monto * - 1) 
                      ELSE 0 END AS Haber, dbo.Contab_ConsultaCuentasYMovimientos_Movimientos.Monto AS Total, dbo.Contab_ConsultaCuentasYMovimientos.NombreUsuario
FROM         dbo.Asientos INNER JOIN
                      dbo.Monedas ON dbo.Asientos.MonedaOriginal = dbo.Monedas.Moneda RIGHT OUTER JOIN
                      dbo.CuentasContables INNER JOIN
                      dbo.Companias ON dbo.CuentasContables.Cia = dbo.Companias.Numero INNER JOIN
                      dbo.Monedas AS Monedas_1 INNER JOIN
                      dbo.Contab_ConsultaCuentasYMovimientos INNER JOIN
                      dbo.Contab_ConsultaCuentasYMovimientos_Movimientos ON 
                      dbo.Contab_ConsultaCuentasYMovimientos.ID = dbo.Contab_ConsultaCuentasYMovimientos_Movimientos.ParentID ON 
                      Monedas_1.Moneda = dbo.Contab_ConsultaCuentasYMovimientos.Moneda ON 
                      dbo.CuentasContables.ID = dbo.Contab_ConsultaCuentasYMovimientos.CuentaContableID ON 
                      dbo.Asientos.NumeroAutomatico = dbo.Contab_ConsultaCuentasYMovimientos_Movimientos.AsientoID
GO
/****** Object:  ForeignKey [FK_Contab_ConsultaCuentasYMovimientos_Movimientos_Contab_ConsultaCuentasYMovimientos]    Script Date: 01/23/2013 17:35:18 ******/
ALTER TABLE [dbo].[Contab_ConsultaCuentasYMovimientos_Movimientos]  WITH CHECK ADD  CONSTRAINT [FK_Contab_ConsultaCuentasYMovimientos_Movimientos_Contab_ConsultaCuentasYMovimientos] FOREIGN KEY([ParentID])
REFERENCES [dbo].[Contab_ConsultaCuentasYMovimientos] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Contab_ConsultaCuentasYMovimientos_Movimientos] CHECK CONSTRAINT [FK_Contab_ConsultaCuentasYMovimientos_Movimientos_Contab_ConsultaCuentasYMovimientos]
GO
/****** Object:  ForeignKey [FK_tTempWebReport_ConsultaComprobantesContables_Partidas_tTempWebReport_ConsultaComprobantesContables1]    Script Date: 01/23/2013 17:35:18 ******/
ALTER TABLE [dbo].[tTempWebReport_ConsultaComprobantesContables_Partidas]  WITH CHECK ADD  CONSTRAINT [FK_tTempWebReport_ConsultaComprobantesContables_Partidas_tTempWebReport_ConsultaComprobantesContables1] FOREIGN KEY([NumeroAutomatico], [NombreUsuario])
REFERENCES [dbo].[tTempWebReport_ConsultaComprobantesContables] ([NumeroAutomatico], [NombreUsuario])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tTempWebReport_ConsultaComprobantesContables_Partidas] CHECK CONSTRAINT [FK_tTempWebReport_ConsultaComprobantesContables_Partidas_tTempWebReport_ConsultaComprobantesContables1]
GO


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.328', GetDate()) 