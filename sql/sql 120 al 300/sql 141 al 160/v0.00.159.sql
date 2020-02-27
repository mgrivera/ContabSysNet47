/*    Viernes, 9 de Julio de 2.004   -   v0.00.159.sql 

	Agregamos las tablas y views que corresponden al nuevo proceso Flujo de Caja. 

*/ 


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_FlujoCajaCuentasBancarias_FlujoCaja]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[FlujoCajaCuentasBancarias] DROP CONSTRAINT FK_FlujoCajaCuentasBancarias_FlujoCaja
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_FlujoCajaFacturas_FlujoCaja]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[FlujoCajaFacturas] DROP CONSTRAINT FK_FlujoCajaFacturas_FlujoCaja
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoFlujoCaja]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoFlujoCaja]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FlujoCaja]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[FlujoCaja]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FlujoCajaCuentasBancarias]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[FlujoCajaCuentasBancarias]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FlujoCajaFacturas]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[FlujoCajaFacturas]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FlujoCajaId]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[FlujoCajaId]
GO

CREATE TABLE [dbo].[FlujoCaja] (
	[NumeroFlujoCaja] [int] NOT NULL ,
	[FechaSaldoBanco] [datetime] NULL ,
	[Ingreso] [datetime] NOT NULL ,
	[UltAct] [datetime] NOT NULL ,
	[Usuario] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Cia] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[FlujoCajaCuentasBancarias] (
	[NumeroFlujoCaja] [int] NOT NULL ,
	[CuentaBancaria] [int] NOT NULL ,
	[Moneda] [int] NOT NULL ,
	[Saldo] [money] NOT NULL ,
	[Cia] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[FlujoCajaFacturas] (
	[NumeroFlujoCaja] [int] NOT NULL ,
	[NumeroOrden] [smallint] NOT NULL ,
	[NumeroFactura] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[NumeroCuota] [smallint] NOT NULL ,
	[Proveedor] [int] NOT NULL ,
	[Moneda] [int] NOT NULL ,
	[MontoCuota] [money] NOT NULL ,
	[Iva] [money] NOT NULL ,
	[TotalCuota] [money] NOT NULL ,
	[CuentaBancaria] [int] NULL ,
	[SaldoInicialBanco] [money] NULL ,
	[SaldoBanco] [money] NULL ,
	[Cia] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[FlujoCajaId] (
	[Numero] [int] NOT NULL ,
	[Cia] [char] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[FlujoCaja] WITH NOCHECK ADD 
	CONSTRAINT [PK_FlujoCaja] PRIMARY KEY  CLUSTERED 
	(
		[NumeroFlujoCaja],
		[Cia]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[FlujoCajaCuentasBancarias] WITH NOCHECK ADD 
	CONSTRAINT [PK_FlujoCajaCuentasBancarias] PRIMARY KEY  CLUSTERED 
	(
		[NumeroFlujoCaja],
		[CuentaBancaria],
		[Cia]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[FlujoCajaFacturas] WITH NOCHECK ADD 
	CONSTRAINT [PK_FlujoCajaFacturas] PRIMARY KEY  CLUSTERED 
	(
		[NumeroFlujoCaja],
		[NumeroFactura],
		[Proveedor],
		[Cia]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[FlujoCajaId] WITH NOCHECK ADD 
	CONSTRAINT [PK_FlujoCajaId] PRIMARY KEY  CLUSTERED 
	(
		[Numero],
		[Cia]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [IX_FlujoCajaCuentasBancarias] ON [dbo].[FlujoCajaCuentasBancarias]([NumeroFlujoCaja], [Cia]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_FlujoCajaFacturas] ON [dbo].[FlujoCajaFacturas]([NumeroFlujoCaja], [Cia]) ON [PRIMARY]
GO

ALTER TABLE [dbo].[FlujoCajaCuentasBancarias] ADD 
	CONSTRAINT [FK_FlujoCajaCuentasBancarias_FlujoCaja] FOREIGN KEY 
	(
		[NumeroFlujoCaja],
		[Cia]
	) REFERENCES [dbo].[FlujoCaja] (
		[NumeroFlujoCaja],
		[Cia]
	) ON DELETE CASCADE 
GO

ALTER TABLE [dbo].[FlujoCajaFacturas] ADD 
	CONSTRAINT [FK_FlujoCajaFacturas_FlujoCaja] FOREIGN KEY 
	(
		[NumeroFlujoCaja],
		[Cia]
	) REFERENCES [dbo].[FlujoCaja] (
		[NumeroFlujoCaja],
		[Cia]
	) ON DELETE CASCADE 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoFlujoCaja
AS
SELECT     dbo.FlujoCajaFacturas.NumeroFlujoCaja, dbo.FlujoCajaFacturas.NumeroOrden, dbo.FlujoCajaFacturas.NumeroFactura, 
                      dbo.FlujoCajaFacturas.NumeroCuota, dbo.FlujoCajaFacturas.Proveedor, dbo.Proveedores.Nombre AS NombreProveedor, 
                      dbo.CuotasFactura.FechaRecepcion, dbo.CuotasFactura.FechaVencimiento, dbo.FlujoCajaFacturas.Moneda, dbo.Monedas.Simbolo AS SimboloMoneda, 
                      dbo.FlujoCajaFacturas.MontoCuota, dbo.FlujoCajaFacturas.Iva, dbo.FlujoCajaFacturas.TotalCuota, dbo.FlujoCajaFacturas.CuentaBancaria, 
                      dbo.CuentasBancarias.CuentaBancaria AS NombreCuentaBancaria, dbo.Bancos.Nombre AS NombreBanco, dbo.FlujoCajaFacturas.SaldoInicialBanco, 
                      dbo.FlujoCaja.FechaSaldoBanco, dbo.FlujoCajaFacturas.SaldoBanco, dbo.FlujoCajaFacturas.Cia
FROM         dbo.FlujoCajaFacturas INNER JOIN
                      dbo.FlujoCaja ON dbo.FlujoCajaFacturas.NumeroFlujoCaja = dbo.FlujoCaja.NumeroFlujoCaja AND 
                      dbo.FlujoCajaFacturas.Cia = dbo.FlujoCaja.Cia LEFT OUTER JOIN
                      dbo.CuotasFactura ON dbo.FlujoCajaFacturas.NumeroFactura = dbo.CuotasFactura.NumeroFactura AND 
                      dbo.FlujoCajaFacturas.NumeroCuota = dbo.CuotasFactura.NumeroCuota AND dbo.FlujoCajaFacturas.Proveedor = dbo.CuotasFactura.Proveedor AND 
                      dbo.FlujoCajaFacturas.Cia = dbo.CuotasFactura.Cia LEFT OUTER JOIN
                      dbo.CuentasBancarias ON dbo.FlujoCajaFacturas.CuentaBancaria = dbo.CuentasBancarias.CuentaInterna LEFT OUTER JOIN
                      dbo.Monedas ON dbo.FlujoCajaFacturas.Moneda = dbo.Monedas.Moneda LEFT OUTER JOIN
                      dbo.Proveedores ON dbo.FlujoCajaFacturas.Proveedor = dbo.Proveedores.Proveedor LEFT OUTER JOIN
                      dbo.Bancos ON dbo.CuentasBancarias.Banco = dbo.Bancos.Banco

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.159', GetDate()) 

