/*    Miercoles, 17 de Julio de 2002   -   v0.00.126.sql 

	Hacemos los cambios necesarios a las tablas Facturas y CuotasFacturas para 
	que la anulación de facturas sea un estado más (4). 

*/ 

Update Facturas Set Estado = 4 Where FacturaAnuladaFlag = 1 

Update CuotasFactura Set EstadoCuota = 4 From CuotasFactura Inner Join Facturas 
On CuotasFactura.ClaveUnicaFactura = Facturas.ClaveUnica 
Where Facturas.FacturaAnuladaFlag = 1 

--  -----------------------------------------------------------
--  eliminamos el item FacturaAnuladaFlag en la tabla Facturas 
--  -----------------------------------------------------------

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
ALTER TABLE dbo.Facturas
	DROP COLUMN FacturaAnuladaFlag
GO
COMMIT



--  -----------------------------------------------------------
--  actualizamos los views que corresponden a la tabla Facturas
--  -----------------------------------------------------------





if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaFacturas]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaFacturas]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaFacturasConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaFacturasConsulta]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaFacturas
AS
SELECT     ClaveUnica, Proveedor, NumeroFactura, Tipo, CondicionesDePago, FechaEmision, FechaRecepcion, Concepto, MontoFactura, IvaPorc, Iva, 
                      TotalFactura, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenido, TotalAPagar, Saldo, Estado, ImportacionFlag, Comprobante, 
                      CxCCxPFlag, Moneda, ClaveUnicaUltimoPago, FechaUltimoVencimiento, NumeroDeCuotas, DistribuirEnCondominioFlag, GrupoCondominio, 
                      CierreCondominio, CodigoInmueble, Cia
FROM         dbo.Facturas

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaFacturasConsulta
AS
SELECT     dbo.Facturas.ClaveUnica, dbo.Facturas.Proveedor, dbo.Proveedores.Nombre AS NombreProveedor, dbo.Facturas.NumeroFactura, 
                      dbo.Facturas.CondicionesDePago, dbo.Facturas.Tipo, dbo.TiposProveedor.Descripcion AS NombreTipo, 
                      dbo.FormasDePago.Descripcion AS NombreCondicionesDePago, dbo.Facturas.FechaEmision, dbo.Facturas.FechaRecepcion, dbo.Facturas.Concepto, 
                      dbo.Facturas.MontoFactura, dbo.Facturas.IvaPorc, dbo.Facturas.Iva, dbo.Facturas.TotalFactura, dbo.Facturas.MontoSujetoARetencion, 
                      dbo.Facturas.ImpuestoRetenidoPorc, dbo.Facturas.ImpuestoRetenido, dbo.Facturas.TotalAPagar, dbo.Facturas.Saldo, dbo.Facturas.Estado, 
                      dbo.Facturas.ImportacionFlag, dbo.Facturas.Comprobante, dbo.Facturas.CxCCxPFlag, dbo.Facturas.Moneda, dbo.Facturas.ClaveUnicaUltimoPago, 
                      dbo.Facturas.FechaUltimoVencimiento, dbo.Facturas.NumeroDeCuotas, dbo.Facturas.DistribuirEnCondominioFlag, dbo.Facturas.GrupoCondominio, 
                      dbo.Facturas.CierreCondominio, dbo.Facturas.CodigoInmueble, dbo.Facturas.Cia
FROM         dbo.Facturas LEFT OUTER JOIN
                      dbo.TiposProveedor ON dbo.Facturas.Tipo = dbo.TiposProveedor.Tipo LEFT OUTER JOIN
                      dbo.Proveedores ON dbo.Facturas.Proveedor = dbo.Proveedores.Proveedor LEFT OUTER JOIN
                      dbo.FormasDePago ON dbo.Facturas.CondicionesDePago = dbo.FormasDePago.FormaDePago

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



--  ---------------------------------------
--  actualizamos el view qListadoFacturas 
--  ---------------------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoFacturas]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoFacturas]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoFacturas
AS
SELECT     dbo.Facturas.Moneda, dbo.Monedas.Descripcion AS NombreMoneda, dbo.Facturas.Proveedor, dbo.Proveedores.Nombre AS NombreProveedor, 
                      dbo.Facturas.NumeroFactura, dbo.Facturas.FechaEmision, dbo.Facturas.FechaRecepcion, dbo.Facturas.FechaUltimoVencimiento, 
                      dbo.Facturas.MontoFactura, dbo.Facturas.Iva, dbo.Facturas.TotalFactura, dbo.Facturas.ImpuestoRetenido, dbo.Facturas.TotalAPagar, 
                      dbo.Facturas.Saldo, dbo.Facturas.Concepto, dbo.Facturas.CondicionesDePago, dbo.Facturas.IvaPorc, dbo.Facturas.MontoSujetoARetencion, 
                      dbo.Facturas.ImpuestoRetenidoPorc, dbo.Facturas.Estado, dbo.Facturas.CxCCxPFlag, dbo.Facturas.ImportacionFlag, 
                      dbo.Facturas.DistribuirEnCondominioFlag, dbo.Facturas.CierreCondominio, dbo.Facturas.CodigoInmueble, dbo.Facturas.Cia
FROM         dbo.Facturas LEFT OUTER JOIN
                      dbo.Proveedores ON dbo.Facturas.Proveedor = dbo.Proveedores.Proveedor LEFT OUTER JOIN
                      dbo.Monedas ON dbo.Facturas.Moneda = dbo.Monedas.Moneda

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


--  -----------------------------------------------------------------
--  agregamos el item MontoTotal a la tabla tTempListadoAntiguedad 
--  -----------------------------------------------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tTempListadoAntiguedad]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tTempListadoAntiguedad]
GO

CREATE TABLE [dbo].[tTempListadoAntiguedad] (
	[ClaveUnica] [int] IDENTITY (1, 1) NOT NULL ,
	[Compania] [int] NULL ,
	[NombreCompania] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Moneda] [int] NULL ,
	[NombreMoneda] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CxCCxPFlag] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FechaEmision] [datetime] NULL ,
	[FechaRecepcion] [datetime] NULL ,
	[NumeroFactura] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NumeroFacturaEditado] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NumeroCuota] [smallint] NULL ,
	[DiasVencimiento] [smallint] NULL ,
	[FechaVencimiento] [datetime] NULL ,
	[TotalCuota] [money] NULL ,
	[MontoPagado] [money] NULL ,
	[SaldoCuota] [money] NULL ,
	[DiasPorVencer] [smallint] NULL ,
	[MontoVencidoOPorVencer] [money] NULL ,
	[Monto1a30] [money] NULL ,
	[Monto31a60] [money] NULL ,
	[Monto61a90] [money] NULL ,
	[MontoMasDe90] [money] NULL ,
	[MontoTotal] [money] NULL ,
	[NumeroUsuario] [int] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tTempListadoAntiguedad] WITH NOCHECK ADD 
	CONSTRAINT [DF_tTempListadoAntiguedad_MontoVencidoOPorVencer] DEFAULT (0) FOR [MontoVencidoOPorVencer],
	CONSTRAINT [DF_tTempListadoAntiguedad_Monto1a30] DEFAULT (0) FOR [Monto1a30],
	CONSTRAINT [DF_tTempListadoAntiguedad_Monto31a60] DEFAULT (0) FOR [Monto31a60],
	CONSTRAINT [DF_tTempListadoAntiguedad_Monto61a90] DEFAULT (0) FOR [Monto61a90],
	CONSTRAINT [DF_tTempListadoAntiguedad_MontoMasDe90] DEFAULT (0) FOR [MontoMasDe90],
	CONSTRAINT [DF_tTempListadoAntiguedad_MontoTotal] DEFAULT (0) FOR [MontoTotal],
	CONSTRAINT [PK_tTempListadoAntiguedad] PRIMARY KEY  NONCLUSTERED 
	(
		[ClaveUnica]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [IX_tTempListadoAntiguedad] ON [dbo].[tTempListadoAntiguedad]([NumeroUsuario]) ON [PRIMARY]
GO


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.126', GetDate()) 
