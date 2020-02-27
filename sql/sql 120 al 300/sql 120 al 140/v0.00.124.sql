/*    Viernes, 12 de Julio de 2002   -   v0.00.124.sql 

	Agregamos la tabla de categorías de retención (de impuestos de proveedores). Además, 
 	actualizamos los views que corresponden al listado que se genera en relación a las 
	retenciones de impuestos. 

*/ 


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaProveedoresConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaProveedoresConsulta]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoProveedores]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoProveedores]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaCategoriasRetencion]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaCategoriasRetencion]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qReportListadoImpuestosRetenidos]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qReportListadoImpuestosRetenidos]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CategoriasRetencion]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CategoriasRetencion]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CategoriasRetencionId]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CategoriasRetencionId]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tTempListadoImpuestosRetenidos]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tTempListadoImpuestosRetenidos]
GO

CREATE TABLE [dbo].[CategoriasRetencion] (
	[Categoria] [int] NOT NULL ,
	[Descripcion] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CategoriasRetencionId] (
	[Numero] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tTempListadoImpuestosRetenidos] (
	[ClaveUnica] [int] IDENTITY (1, 1) NOT NULL ,
	[Proveedor] [int] NULL ,
	[NombreProveedor] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Rif] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Cedula] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Ano] [smallint] NULL ,
	[Mes] [tinyint] NULL ,
	[NatJurFlag] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CategoriaRetencion] [int] NULL ,
	[NombreCategoriaRetencion] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Moneda] [int] NULL ,
	[NombreMoneda] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NumeroFactura] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FechaRecepcion] [datetime] NULL ,
	[MontoFactura] [money] NULL ,
	[MontoSujetoARetencion] [money] NULL ,
	[ImpuestoRetenidoPorc] [real] NULL ,
	[ImpuestoRetenido] [money] NULL ,
	[NumeroUsuario] [int] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CategoriasRetencion] WITH NOCHECK ADD 
	CONSTRAINT [PK__CategoriasRetenc__0B679CE2] PRIMARY KEY  CLUSTERED 
	(
		[Categoria]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tTempListadoImpuestosRetenidos] WITH NOCHECK ADD 
	CONSTRAINT [PK_tTempListadoImpuestosRetenidos] PRIMARY KEY  NONCLUSTERED 
	(
		[ClaveUnica]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [IX_tTempListadoImpuestosRetenidos] ON [dbo].[tTempListadoImpuestosRetenidos]([NumeroUsuario]) ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaCategoriasRetencion
AS
SELECT     Categoria, Descripcion
FROM         dbo.CategoriasRetencion

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qReportListadoImpuestosRetenidos    Script Date: 15-May-01 12:13:55 PM *****
***** Object:  View dbo.qReportListadoImpuestosRetenidos    Script Date: 28/11/00 07:01:20 p.m. *****
***** Object:  View dbo.qReportListadoImpuestosRetenidos    Script Date: 08/nov/00 9:01:17 *****
***** Object:  View dbo.qReportListadoImpuestosRetenidos    Script Date: 30/sep/00 1:10:03 ******/
CREATE VIEW dbo.qReportListadoImpuestosRetenidos
AS
SELECT     ClaveUnica, Proveedor, NombreProveedor, NatJurFlag, CategoriaRetencion, NombreCategoriaRetencion, Moneda, NombreMoneda, NumeroFactura, 
                      FechaRecepcion, MontoFactura, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenido, NumeroUsuario, Rif, Cedula, Ano, Mes
FROM         dbo.tTempListadoImpuestosRetenidos

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
                      dbo.Proveedores.Usuario, dbo.CategoriasRetencion.Descripcion AS NombreCategoriaRetencion
FROM         dbo.Proveedores LEFT OUTER JOIN
                      dbo.CategoriasRetencion ON dbo.Proveedores.CategoriaProveedor = dbo.CategoriasRetencion.Categoria LEFT OUTER JOIN
                      dbo.FormasDePago ON dbo.Proveedores.FormaDePagoDefault = dbo.FormasDePago.FormaDePago LEFT OUTER JOIN
                      dbo.tCiudades ON dbo.Proveedores.Ciudad = dbo.tCiudades.Ciudad LEFT OUTER JOIN
                      dbo.Monedas ON dbo.Proveedores.MonedaDefault = dbo.Monedas.Moneda LEFT OUTER JOIN
                      dbo.TiposProveedor ON dbo.Proveedores.Tipo = dbo.TiposProveedor.Tipo

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qListadoProveedores    Script Date: 28/11/00 07:01:24 p.m. *****
***** Object:  View dbo.qListadoProveedores    Script Date: 08/nov/00 9:01:18 ******/
CREATE VIEW dbo.qListadoProveedores
AS
SELECT     dbo.tCiudades.Descripcion AS NombreCiudad, dbo.Proveedores.Proveedor, dbo.Proveedores.Nombre, 
                      dbo.TiposProveedor.Descripcion AS NombreTipoProveedor, dbo.Proveedores.Tipo, dbo.Proveedores.Rif, 
                      dbo.Proveedores.NatJurFlag AS NaturalJuridico, dbo.Proveedores.Nit, dbo.Proveedores.Direccion, dbo.Proveedores.Ciudad, 
                      dbo.Proveedores.Telefono1, dbo.Proveedores.Telefono2, dbo.Proveedores.Fax, dbo.Proveedores.Contacto1, 
                      dbo.Proveedores.CategoriaProveedor
FROM         dbo.Proveedores LEFT OUTER JOIN
                      dbo.TiposProveedor ON dbo.Proveedores.Tipo = dbo.TiposProveedor.Tipo LEFT OUTER JOIN
                      dbo.tCiudades ON dbo.Proveedores.Ciudad = dbo.tCiudades.Ciudad

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

--  -------------------------------------------------------------------------
--  agregamos unos registros iniciales a la tabla que acabamos de agregar 
--  -------------------------------------------------------------------------


Delete From CategoriasRetencion 
Delete From CategoriasRetencionId 

Insert Into CategoriasRetencion (Categoria, Descripcion) Values (1, 'Sueldos') 
Insert Into CategoriasRetencion (Categoria, Descripcion) Values (2, 'Honoraios') 
Insert Into CategoriasRetencion (Categoria, Descripcion) Values (3, 'Alquileres') 
Insert Into CategoriasRetencion (Categoria, Descripcion) Values (4, 'Retenciones varias') 
Insert Into CategoriasRetencion (Categoria, Descripcion) Values (5, 'Publicidad') 
Insert Into CategoriasRetencion (Categoria, Descripcion) Values (6, 'Agente aduanal') 

Insert Into CategoriasRetencionId (Numero) Values (7) 

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.124', GetDate()) 
