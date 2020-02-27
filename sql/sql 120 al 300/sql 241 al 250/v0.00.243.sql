/*    Lunes, 30 de Marzo de 2.009  -   v0.00.243.sql 

	Modificamos levemente la tabla Contab_ConsultaCuentasYMovimientos_Movimientos 
	para agregar el item CentroCosto 

*/ 



IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Contab_ConsultaCuentasYMovimientos_Movimientos_Contab_ConsultaCuentasYMovimientos1]') AND parent_object_id = OBJECT_ID(N'[dbo].[Contab_ConsultaCuentasYMovimientos_Movimientos]'))
ALTER TABLE [dbo].[Contab_ConsultaCuentasYMovimientos_Movimientos] DROP CONSTRAINT [FK_Contab_ConsultaCuentasYMovimientos_Movimientos_Contab_ConsultaCuentasYMovimientos1]
GO


/****** Object:  Table [dbo].[Contab_ConsultaCuentasYMovimientos_Movimientos]    Script Date: 03/31/2009 08:51:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Contab_ConsultaCuentasYMovimientos_Movimientos]') AND type in (N'U'))
DROP TABLE [dbo].[Contab_ConsultaCuentasYMovimientos_Movimientos]
GO


/****** Object:  Table [dbo].[Contab_ConsultaCuentasYMovimientos]    Script Date: 03/31/2009 08:51:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Contab_ConsultaCuentasYMovimientos]') AND type in (N'U'))
DROP TABLE [dbo].[Contab_ConsultaCuentasYMovimientos]
GO


/****** Object:  Table [dbo].[Contab_ConsultaCuentasYMovimientos]    Script Date: 03/31/2009 08:51:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Contab_ConsultaCuentasYMovimientos](
	[CuentaContable] [nvarchar](25) NOT NULL,
	[Moneda] [int] NOT NULL,
	[CiaContab] [int] NOT NULL,
	[CantidadMovimientos] [smallint] NOT NULL,
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



/****** Object:  Table [dbo].[Contab_ConsultaCuentasYMovimientos_Movimientos]    Script Date: 03/31/2009 08:51:27 ******/
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
	[MonedaOriginal] [int] NULL,
	[CentroCosto] [int] NULL,
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
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.243', GetDate()) 