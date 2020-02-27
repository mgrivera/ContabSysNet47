/*    Martes, 11 de Noviembre de 2.008   -   v0.00.224.sql 

	Agregamos las tablas del Control de Caja Chica

	NOTA: eliminar toda la primera parte de este script si las tablas no existen en la 
	base de datos.  

*/ 


/****** Object:  ForeignKey [FK_CajaChica_CajasChicas_Companias]    Script Date: 11/11/2008 10:19:55 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CajaChica_CajasChicas_Companias]') AND parent_object_id = OBJECT_ID(N'[dbo].[CajaChica_CajasChicas]'))
ALTER TABLE [dbo].[CajaChica_CajasChicas] DROP CONSTRAINT [FK_CajaChica_CajasChicas_Companias]
GO
/****** Object:  ForeignKey [FK_CajaChica_Reposiciones_CajaChica_CajasChicas]    Script Date: 11/11/2008 10:19:59 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CajaChica_Reposiciones_CajaChica_CajasChicas]') AND parent_object_id = OBJECT_ID(N'[dbo].[CajaChica_Reposiciones]'))
ALTER TABLE [dbo].[CajaChica_Reposiciones] DROP CONSTRAINT [FK_CajaChica_Reposiciones_CajaChica_CajasChicas]
GO
/****** Object:  ForeignKey [FK_CajaChica_Reposiciones_Estados_CajaChica_Reposiciones]    Script Date: 11/11/2008 10:20:03 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CajaChica_Reposiciones_Estados_CajaChica_Reposiciones]') AND parent_object_id = OBJECT_ID(N'[dbo].[CajaChica_Reposiciones_Estados]'))
ALTER TABLE [dbo].[CajaChica_Reposiciones_Estados] DROP CONSTRAINT [FK_CajaChica_Reposiciones_Estados_CajaChica_Reposiciones]
GO
/****** Object:  ForeignKey [FK_CajaChica_Reposisiones_Gastos_CajaChica_Reposiciones]    Script Date: 11/11/2008 10:20:09 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CajaChica_Reposisiones_Gastos_CajaChica_Reposiciones]') AND parent_object_id = OBJECT_ID(N'[dbo].[CajaChica_Reposiciones_Gastos]'))
ALTER TABLE [dbo].[CajaChica_Reposiciones_Gastos] DROP CONSTRAINT [FK_CajaChica_Reposisiones_Gastos_CajaChica_Reposiciones]
GO
/****** Object:  ForeignKey [FK_CajaChica_Reposisiones_Gastos_CajaChica_Rubros]    Script Date: 11/11/2008 10:20:09 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CajaChica_Reposisiones_Gastos_CajaChica_Rubros]') AND parent_object_id = OBJECT_ID(N'[dbo].[CajaChica_Reposiciones_Gastos]'))
ALTER TABLE [dbo].[CajaChica_Reposiciones_Gastos] DROP CONSTRAINT [FK_CajaChica_Reposisiones_Gastos_CajaChica_Rubros]
GO
/****** Object:  ForeignKey [FK_CajaChica_RubrosCuentasContables_CajaChica_Rubros]    Script Date: 11/11/2008 10:20:13 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CajaChica_RubrosCuentasContables_CajaChica_Rubros]') AND parent_object_id = OBJECT_ID(N'[dbo].[CajaChica_RubrosCuentasContables]'))
ALTER TABLE [dbo].[CajaChica_RubrosCuentasContables] DROP CONSTRAINT [FK_CajaChica_RubrosCuentasContables_CajaChica_Rubros]
GO
/****** Object:  ForeignKey [FK_CajaChica_RubrosCuentasContables_Companias]    Script Date: 11/11/2008 10:20:14 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CajaChica_RubrosCuentasContables_Companias]') AND parent_object_id = OBJECT_ID(N'[dbo].[CajaChica_RubrosCuentasContables]'))
ALTER TABLE [dbo].[CajaChica_RubrosCuentasContables] DROP CONSTRAINT [FK_CajaChica_RubrosCuentasContables_Companias]
GO
/****** Object:  ForeignKey [FK_CajaChica_RubrosCuentasContables_CuentasContables]    Script Date: 11/11/2008 10:20:14 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CajaChica_RubrosCuentasContables_CuentasContables]') AND parent_object_id = OBJECT_ID(N'[dbo].[CajaChica_RubrosCuentasContables]'))
ALTER TABLE [dbo].[CajaChica_RubrosCuentasContables] DROP CONSTRAINT [FK_CajaChica_RubrosCuentasContables_CuentasContables]
GO
/****** Object:  ForeignKey [FK_CajaChica_Usuarios_CajaChica_CajasChicas]    Script Date: 11/11/2008 10:20:17 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CajaChica_Usuarios_CajaChica_CajasChicas]') AND parent_object_id = OBJECT_ID(N'[dbo].[CajaChica_Usuarios]'))
ALTER TABLE [dbo].[CajaChica_Usuarios] DROP CONSTRAINT [FK_CajaChica_Usuarios_CajaChica_CajasChicas]
GO
/****** Object:  ForeignKey [FK_CajaChica_Usuarios_Usuarios]    Script Date: 11/11/2008 10:20:17 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CajaChica_Usuarios_Usuarios]') AND parent_object_id = OBJECT_ID(N'[dbo].[CajaChica_Usuarios]'))
ALTER TABLE [dbo].[CajaChica_Usuarios] DROP CONSTRAINT [FK_CajaChica_Usuarios_Usuarios]
GO
/****** Object:  Table [dbo].[CajaChica_RubrosCuentasContables]    Script Date: 11/11/2008 10:20:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CajaChica_RubrosCuentasContables]') AND type in (N'U'))
DROP TABLE [dbo].[CajaChica_RubrosCuentasContables]
GO
/****** Object:  Table [dbo].[CajaChica_Usuarios]    Script Date: 11/11/2008 10:20:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CajaChica_Usuarios]') AND type in (N'U'))
DROP TABLE [dbo].[CajaChica_Usuarios]
GO
/****** Object:  Table [dbo].[CajaChica_Reposiciones_Estados]    Script Date: 11/11/2008 10:20:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CajaChica_Reposiciones_Estados]') AND type in (N'U'))
DROP TABLE [dbo].[CajaChica_Reposiciones_Estados]
GO
/****** Object:  Table [dbo].[CajaChica_Reposiciones_Gastos]    Script Date: 11/11/2008 10:20:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CajaChica_Reposiciones_Gastos]') AND type in (N'U'))
DROP TABLE [dbo].[CajaChica_Reposiciones_Gastos]
GO
/****** Object:  Table [dbo].[CajaChica_CajasChicas]    Script Date: 11/11/2008 10:19:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CajaChica_CajasChicas]') AND type in (N'U'))
DROP TABLE [dbo].[CajaChica_CajasChicas]
GO
/****** Object:  Table [dbo].[CajaChica_Rubros]    Script Date: 11/11/2008 10:20:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CajaChica_Rubros]') AND type in (N'U'))
DROP TABLE [dbo].[CajaChica_Rubros]
GO
/****** Object:  Table [dbo].[CajaChica_Reposiciones]    Script Date: 11/11/2008 10:19:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CajaChica_Reposiciones]') AND type in (N'U'))
DROP TABLE [dbo].[CajaChica_Reposiciones]
GO
/****** Object:  Table [dbo].[CajaChica_Rubros]    Script Date: 11/11/2008 10:20:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CajaChica_Rubros]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CajaChica_Rubros](
	[Rubro] [smallint] IDENTITY(1,1) NOT NULL,
	[Descripcion] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_CajaChica_Rubros] PRIMARY KEY CLUSTERED 
(
	[Rubro] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[CajaChica_Reposiciones_Estados]    Script Date: 11/11/2008 10:20:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CajaChica_Reposiciones_Estados]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CajaChica_Reposiciones_Estados](
	[Reposicion] [int] NOT NULL,
	[CajaChica] [smallint] NOT NULL,
	[Fecha] [smalldatetime] NOT NULL,
	[CiaContab] [int] NOT NULL,
	[Usuario] [int] NOT NULL,
	[Estado] [char](2) NOT NULL,
 CONSTRAINT [PK_CajaChica_Reposiciones_Estados] PRIMARY KEY CLUSTERED 
(
	[Reposicion] ASC,
	[CajaChica] ASC,
	[CiaContab] ASC,
	[Estado] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CajaChica_Reposiciones_Gastos]    Script Date: 11/11/2008 10:20:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CajaChica_Reposiciones_Gastos]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CajaChica_Reposiciones_Gastos](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Reposicion] [int] NOT NULL,
	[CajaChica] [smallint] NOT NULL,
	[CiaContab] [int] NOT NULL,
	[Fecha] [smalldatetime] NOT NULL,
	[Rubro] [smallint] NOT NULL,
	[Descripcion] [nvarchar](150) NOT NULL,
	[Monto] [money] NOT NULL,
	[Usuario] [int] NOT NULL,
 CONSTRAINT [PK_CajaChica_Reposisiones_Gastos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[Reposicion] ASC,
	[CajaChica] ASC,
	[CiaContab] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[CajaChica_Usuarios]    Script Date: 11/11/2008 10:20:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CajaChica_Usuarios]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CajaChica_Usuarios](
	[CiaContab] [int] NOT NULL,
	[CajaChica] [smallint] NOT NULL,
	[Estado] [char](2) NOT NULL,
	[Usuario] [int] NOT NULL,
 CONSTRAINT [PK_CajaChica_Usuarios] PRIMARY KEY CLUSTERED 
(
	[CiaContab] ASC,
	[CajaChica] ASC,
	[Estado] ASC,
	[Usuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CajaChica_RubrosCuentasContables]    Script Date: 11/11/2008 10:20:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CajaChica_RubrosCuentasContables]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CajaChica_RubrosCuentasContables](
	[Rubro] [smallint] NOT NULL,
	[CiaContab] [int] NOT NULL,
	[CuentaContable] [nvarchar](25) NOT NULL,
 CONSTRAINT [PK_CajaChica_RubrosCuentasContables] PRIMARY KEY CLUSTERED 
(
	[Rubro] ASC,
	[CiaContab] ASC,
	[CuentaContable] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[CajaChica_Reposiciones]    Script Date: 11/11/2008 10:19:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CajaChica_Reposiciones]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CajaChica_Reposiciones](
	[Reposicion] [int] IDENTITY(1,1) NOT NULL,
	[Fecha] [smalldatetime] NOT NULL,
	[CajaChica] [smallint] NOT NULL,
	[Observaciones] [nvarchar](250) NULL,
	[EstadoActual] [char](2) NOT NULL,
	[CiaContab] [int] NOT NULL,
 CONSTRAINT [PK_CajaChica_Reposiciones] PRIMARY KEY CLUSTERED 
(
	[Reposicion] ASC,
	[CajaChica] ASC,
	[CiaContab] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CajaChica_CajasChicas]    Script Date: 11/11/2008 10:19:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CajaChica_CajasChicas]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CajaChica_CajasChicas](
	[CajaChica] [smallint] IDENTITY(1,1) NOT NULL,
	[Descripcion] [nvarchar](50) NOT NULL,
	[CiaContab] [int] NOT NULL,
 CONSTRAINT [PK_CajaChica_CajasChicas] PRIMARY KEY CLUSTERED 
(
	[CajaChica] ASC,
	[CiaContab] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  ForeignKey [FK_CajaChica_CajasChicas_Companias]    Script Date: 11/11/2008 10:19:55 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CajaChica_CajasChicas_Companias]') AND parent_object_id = OBJECT_ID(N'[dbo].[CajaChica_CajasChicas]'))
ALTER TABLE [dbo].[CajaChica_CajasChicas]  WITH CHECK ADD  CONSTRAINT [FK_CajaChica_CajasChicas_Companias] FOREIGN KEY([CiaContab])
REFERENCES [dbo].[Companias] ([Numero])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CajaChica_CajasChicas] CHECK CONSTRAINT [FK_CajaChica_CajasChicas_Companias]
GO
/****** Object:  ForeignKey [FK_CajaChica_Reposiciones_CajaChica_CajasChicas]    Script Date: 11/11/2008 10:19:59 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CajaChica_Reposiciones_CajaChica_CajasChicas]') AND parent_object_id = OBJECT_ID(N'[dbo].[CajaChica_Reposiciones]'))
ALTER TABLE [dbo].[CajaChica_Reposiciones]  WITH CHECK ADD  CONSTRAINT [FK_CajaChica_Reposiciones_CajaChica_CajasChicas] FOREIGN KEY([CajaChica], [CiaContab])
REFERENCES [dbo].[CajaChica_CajasChicas] ([CajaChica], [CiaContab])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CajaChica_Reposiciones] CHECK CONSTRAINT [FK_CajaChica_Reposiciones_CajaChica_CajasChicas]
GO
/****** Object:  ForeignKey [FK_CajaChica_Reposiciones_Estados_CajaChica_Reposiciones]    Script Date: 11/11/2008 10:20:03 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CajaChica_Reposiciones_Estados_CajaChica_Reposiciones]') AND parent_object_id = OBJECT_ID(N'[dbo].[CajaChica_Reposiciones_Estados]'))
ALTER TABLE [dbo].[CajaChica_Reposiciones_Estados]  WITH CHECK ADD  CONSTRAINT [FK_CajaChica_Reposiciones_Estados_CajaChica_Reposiciones] FOREIGN KEY([Reposicion], [CajaChica], [CiaContab])
REFERENCES [dbo].[CajaChica_Reposiciones] ([Reposicion], [CajaChica], [CiaContab])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CajaChica_Reposiciones_Estados] CHECK CONSTRAINT [FK_CajaChica_Reposiciones_Estados_CajaChica_Reposiciones]
GO
/****** Object:  ForeignKey [FK_CajaChica_Reposisiones_Gastos_CajaChica_Reposiciones]    Script Date: 11/11/2008 10:20:09 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CajaChica_Reposisiones_Gastos_CajaChica_Reposiciones]') AND parent_object_id = OBJECT_ID(N'[dbo].[CajaChica_Reposiciones_Gastos]'))
ALTER TABLE [dbo].[CajaChica_Reposiciones_Gastos]  WITH CHECK ADD  CONSTRAINT [FK_CajaChica_Reposisiones_Gastos_CajaChica_Reposiciones] FOREIGN KEY([Reposicion], [CajaChica], [CiaContab])
REFERENCES [dbo].[CajaChica_Reposiciones] ([Reposicion], [CajaChica], [CiaContab])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CajaChica_Reposiciones_Gastos] CHECK CONSTRAINT [FK_CajaChica_Reposisiones_Gastos_CajaChica_Reposiciones]
GO
/****** Object:  ForeignKey [FK_CajaChica_Reposisiones_Gastos_CajaChica_Rubros]    Script Date: 11/11/2008 10:20:09 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CajaChica_Reposisiones_Gastos_CajaChica_Rubros]') AND parent_object_id = OBJECT_ID(N'[dbo].[CajaChica_Reposiciones_Gastos]'))
ALTER TABLE [dbo].[CajaChica_Reposiciones_Gastos]  WITH CHECK ADD  CONSTRAINT [FK_CajaChica_Reposisiones_Gastos_CajaChica_Rubros] FOREIGN KEY([Rubro])
REFERENCES [dbo].[CajaChica_Rubros] ([Rubro])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CajaChica_Reposiciones_Gastos] CHECK CONSTRAINT [FK_CajaChica_Reposisiones_Gastos_CajaChica_Rubros]
GO
/****** Object:  ForeignKey [FK_CajaChica_RubrosCuentasContables_CajaChica_Rubros]    Script Date: 11/11/2008 10:20:13 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CajaChica_RubrosCuentasContables_CajaChica_Rubros]') AND parent_object_id = OBJECT_ID(N'[dbo].[CajaChica_RubrosCuentasContables]'))
ALTER TABLE [dbo].[CajaChica_RubrosCuentasContables]  WITH CHECK ADD  CONSTRAINT [FK_CajaChica_RubrosCuentasContables_CajaChica_Rubros] FOREIGN KEY([Rubro])
REFERENCES [dbo].[CajaChica_Rubros] ([Rubro])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CajaChica_RubrosCuentasContables] CHECK CONSTRAINT [FK_CajaChica_RubrosCuentasContables_CajaChica_Rubros]
GO
/****** Object:  ForeignKey [FK_CajaChica_RubrosCuentasContables_Companias]    Script Date: 11/11/2008 10:20:14 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CajaChica_RubrosCuentasContables_Companias]') AND parent_object_id = OBJECT_ID(N'[dbo].[CajaChica_RubrosCuentasContables]'))
ALTER TABLE [dbo].[CajaChica_RubrosCuentasContables]  WITH CHECK ADD  CONSTRAINT [FK_CajaChica_RubrosCuentasContables_Companias] FOREIGN KEY([CiaContab])
REFERENCES [dbo].[Companias] ([Numero])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CajaChica_RubrosCuentasContables] CHECK CONSTRAINT [FK_CajaChica_RubrosCuentasContables_Companias]
GO
/****** Object:  ForeignKey [FK_CajaChica_RubrosCuentasContables_CuentasContables]    Script Date: 11/11/2008 10:20:14 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CajaChica_RubrosCuentasContables_CuentasContables]') AND parent_object_id = OBJECT_ID(N'[dbo].[CajaChica_RubrosCuentasContables]'))
ALTER TABLE [dbo].[CajaChica_RubrosCuentasContables]  WITH CHECK ADD  CONSTRAINT [FK_CajaChica_RubrosCuentasContables_CuentasContables] FOREIGN KEY([CuentaContable], [CiaContab])
REFERENCES [dbo].[CuentasContables] ([Cuenta], [Cia])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CajaChica_RubrosCuentasContables] CHECK CONSTRAINT [FK_CajaChica_RubrosCuentasContables_CuentasContables]
GO
/****** Object:  ForeignKey [FK_CajaChica_Usuarios_CajaChica_CajasChicas]    Script Date: 11/11/2008 10:20:17 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CajaChica_Usuarios_CajaChica_CajasChicas]') AND parent_object_id = OBJECT_ID(N'[dbo].[CajaChica_Usuarios]'))
ALTER TABLE [dbo].[CajaChica_Usuarios]  WITH CHECK ADD  CONSTRAINT [FK_CajaChica_Usuarios_CajaChica_CajasChicas] FOREIGN KEY([CajaChica], [CiaContab])
REFERENCES [dbo].[CajaChica_CajasChicas] ([CajaChica], [CiaContab])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CajaChica_Usuarios] CHECK CONSTRAINT [FK_CajaChica_Usuarios_CajaChica_CajasChicas]
GO
/****** Object:  ForeignKey [FK_CajaChica_Usuarios_Usuarios]    Script Date: 11/11/2008 10:20:17 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CajaChica_Usuarios_Usuarios]') AND parent_object_id = OBJECT_ID(N'[dbo].[CajaChica_Usuarios]'))
ALTER TABLE [dbo].[CajaChica_Usuarios]  WITH CHECK ADD  CONSTRAINT [FK_CajaChica_Usuarios_Usuarios] FOREIGN KEY([Usuario])
REFERENCES [dbo].[Usuarios] ([Usuario])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CajaChica_Usuarios] CHECK CONSTRAINT [FK_CajaChica_Usuarios_Usuarios]
GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.224', GetDate()) 