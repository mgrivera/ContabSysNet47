/*    Viernes, 21 de Junio de 2002   -   v0.00.123.sql 

	Hacemos algunas modificaciones a la tabla de Proveedores y agregamos la 
	tabla Personas. 

*/ 



BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION

ALTER TABLE dbo.Proveedores ADD
	Ingreso datetime NULL,
	UltAct datetime NULL, 
	Usuario nvarchar(25)  NULL

GO
COMMIT

Update Proveedores Set Ingreso = '1/1/1980', UltAct = '1/1/1980', Usuario = 'sin usuario'

ALTER TABLE dbo.Proveedores Alter Column Ingreso datetime NOT NULL
ALTER TABLE dbo.Proveedores Alter Column UltAct datetime NOT NULL
ALTER TABLE dbo.Proveedores Alter Column Usuario nvarchar(25) NOT NULL
	








if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Personas_Titulos]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Personas] DROP CONSTRAINT FK_Personas_Titulos
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaPersonas]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaPersonas]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaPersonasConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaPersonasConsulta]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaTitulos]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaTitulos]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Personas]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Personas]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PersonasId]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PersonasId]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Titulos]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Titulos]
GO

CREATE TABLE [dbo].[Personas] (
	[Persona] [int] NOT NULL ,
	[Compania] [int] NOT NULL ,
	[Nombre] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Apellido] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Cargo] [int] NOT NULL ,
	[Titulo] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Telefono] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Fax] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Celular] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[email] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Notas] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Ingreso] [smalldatetime] NOT NULL ,
	[UltAct] [smalldatetime] NOT NULL , 
	[Usuario] [nvarchar] (25)  COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PersonasId] (
	[Numero] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Titulos] (
	[Titulo] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Personas] WITH NOCHECK ADD 
	CONSTRAINT [PK_Personas] PRIMARY KEY  CLUSTERED 
	(
		[Persona]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Titulos] WITH NOCHECK ADD 
	CONSTRAINT [PK_Titulos] PRIMARY KEY  CLUSTERED 
	(
		[Titulo]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [IX_Personas] ON [dbo].[Personas]([Compania]) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Personas] ADD 
	CONSTRAINT [FK_Personas_Proveedores] FOREIGN KEY 
	(
		[Compania]
	) REFERENCES [dbo].[Proveedores] (
		[Proveedor]
	),
	CONSTRAINT [FK_Personas_tCargos] FOREIGN KEY 
	(
		[Cargo]
	) REFERENCES [dbo].[tCargos] (
		[Cargo]
	),
	CONSTRAINT [FK_Personas_Titulos] FOREIGN KEY 
	(
		[Titulo]
	) REFERENCES [dbo].[Titulos] (
		[Titulo]
	)
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaTitulos
AS
SELECT     Titulo
FROM         dbo.Titulos

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaPersonas
AS
SELECT     Persona, Compania, Nombre, Apellido, Cargo, Titulo, Telefono, Fax, Celular, Notas, email, Ingreso, UltAct, Usuario
FROM         dbo.Personas

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaPersonasConsulta
AS
SELECT     dbo.Personas.Persona, dbo.Personas.Nombre, dbo.Personas.Apellido, dbo.Personas.Cargo, dbo.tCargos.Descripcion AS NombreCargo, 
                      dbo.Personas.Titulo, dbo.Personas.Telefono, dbo.Personas.Fax, dbo.Personas.Celular, dbo.Personas.email, dbo.Personas.Notas, 
                      dbo.Personas.Ingreso, dbo.Personas.UltAct, dbo.Personas.Compania,  dbo.Personas.Usuario

FROM         dbo.Personas INNER JOIN
                      dbo.tCargos ON dbo.Personas.Cargo = dbo.tCargos.Cargo

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaProveedores]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaProveedores]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaProveedoresConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaProveedoresConsulta]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaProveedores
AS
SELECT     Proveedor, Nombre, Tipo, Rif, NatJurFlag, Nit, Beneficiario, Concepto, MontoCheque, Direccion, Ciudad, Telefono1, Telefono2, Fax, Contacto1, 
                      Contacto2, NacionalExtranjeroFlag, SujetoARetencionFlag, MonedaDefault, FormaDePagoDefault, ProveedorClienteFlag, PorcentajeDeRetencion, 
                      AplicaIvaFlag, CategoriaProveedor, MontoChequeEnMonExtFlag, Ingreso, UltAct, Usuario
FROM         dbo.Proveedores

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaProveedoresConsulta
AS
SELECT     dbo.Proveedores.Proveedor, dbo.Proveedores.Nombre, dbo.Proveedores.Tipo, dbo.TiposProveedor.Descripcion AS NombreTipoProveedor, 
                      dbo.Proveedores.Rif, dbo.Proveedores.NatJurFlag, dbo.Proveedores.Nit, dbo.Proveedores.Beneficiario, dbo.Proveedores.Concepto, 
                      dbo.Proveedores.MontoCheque, dbo.Proveedores.Direccion, dbo.Proveedores.Ciudad, dbo.tCiudades.Descripcion AS NombreCiudad, 
                      dbo.Proveedores.Telefono1, dbo.Proveedores.Telefono2, dbo.Proveedores.Fax, dbo.Proveedores.Contacto1, dbo.Proveedores.Contacto2, 
                      dbo.Proveedores.NacionalExtranjeroFlag, dbo.Proveedores.SujetoARetencionFlag, dbo.Proveedores.MonedaDefault, 
                      dbo.Monedas.Simbolo AS SimboloMoneda, dbo.Proveedores.FormaDePagoDefault, dbo.FormasDePago.Descripcion AS NombreFormaDePago, 
                      dbo.Proveedores.ProveedorClienteFlag, dbo.Proveedores.PorcentajeDeRetencion, dbo.Proveedores.AplicaIvaFlag, 
                      dbo.Proveedores.CategoriaProveedor, dbo.Proveedores.MontoChequeEnMonExtFlag, dbo.Proveedores.Ingreso, dbo.Proveedores.UltAct, 
                      dbo.Proveedores.Usuario
FROM         dbo.Proveedores LEFT OUTER JOIN
                      dbo.FormasDePago ON dbo.Proveedores.FormaDePagoDefault = dbo.FormasDePago.FormaDePago LEFT OUTER JOIN
                      dbo.tCiudades ON dbo.Proveedores.Ciudad = dbo.tCiudades.Ciudad LEFT OUTER JOIN
                      dbo.Monedas ON dbo.Proveedores.MonedaDefault = dbo.Monedas.Moneda LEFT OUTER JOIN
                      dbo.TiposProveedor ON dbo.Proveedores.Tipo = dbo.TiposProveedor.Tipo

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.123', GetDate()) 
