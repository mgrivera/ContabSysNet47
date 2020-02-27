/*    Miercoles, 11 de Febrero de 2.009  -   v0.00.239.sql 

	Agregamos las tabla tTemp_AsientosContables y tTemp_AsientosContables_Partidas 

*/ 


/****** Object:  Table [dbo].[tTemp_AsientosContables_Partidas]    Script Date: 02/11/2009 09:29:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tTemp_AsientosContables_Partidas]') AND type in (N'U'))
DROP TABLE [dbo].[tTemp_AsientosContables_Partidas]
GO

/****** Object:  Table [dbo].[tTemp_AsientosContables_Partidas]    Script Date: 02/11/2009 09:29:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tTemp_AsientosContables_Partidas](
	[Partida] [smallint] NOT NULL,
	[Cuenta] [nvarchar](25) NOT NULL,
	[Descripcion] [nvarchar](50) NOT NULL,
	[Referencia] [nvarchar](20) NULL,
	[Debe] [money] NOT NULL,
	[Haber] [money] NOT NULL,
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_tTemp_AsientosContables_Partidas] PRIMARY KEY CLUSTERED 
(
	[Partida] ASC,
	[NombreUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[tTemp_AsientosContables]    Script Date: 02/11/2009 09:29:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tTemp_AsientosContables]') AND type in (N'U'))
DROP TABLE [dbo].[tTemp_AsientosContables]
GO

/****** Object:  Table [dbo].[tTemp_AsientosContables]    Script Date: 02/11/2009 09:29:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tTemp_AsientosContables](
	[Numero] [smallint] NULL,
	[Tipo] [nvarchar](6) NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[Descripcion] [nvarchar](250) NOT NULL,
	[Moneda] [int] NOT NULL,
	[FactorDeCambio] [money] NOT NULL,
	[CiaContab] [int] NOT NULL,
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_tTemp_AsientosContables] PRIMARY KEY CLUSTERED 
(
	[NombreUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.239', GetDate()) 