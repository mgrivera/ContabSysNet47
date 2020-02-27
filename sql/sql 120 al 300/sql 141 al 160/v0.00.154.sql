/*    Viernes, 4 de Julio del 2003   -   v0.00.154.sql 

	agregamos el view qListadoComprobantesRetencion. Además, modificamos levemente la tabla
	tTempPrintChequesContinuos. 

*/ 

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoComprobantesRetencion]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoComprobantesRetencion]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoComprobantesRetencion2]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoComprobantesRetencion2]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoComprobantesRetencion
AS
SELECT     TOP 100 PERCENT dbo.Proveedores.Nombre AS NombreProveedor, dbo.Proveedores.Rif, dbo.Proveedores.Nit, 
                      dbo.Companias.Nombre AS NombreCiaSeleccionada, dbo.Companias.Rif AS RifCiaSeleccionada, dbo.Monedas.Simbolo AS SimboloMoneda, 
                      dbo.MovimientosBancarios.Transaccion AS NumeroCheque, dbo.MovimientosBancarios.Fecha AS FechaCheque, 
                      ABS(dbo.MovimientosBancarios.Monto) AS MontoCheque, dbo.MovimientosBancarios.ProvClte, dbo.CuentasBancarias.Banco, 
                      dbo.Bancos.NombreCorto AS NombreCortoBanco, dbo.MovimientosBancarios.Cia, dbo.MovimientosBancarios.ClaveUnica, 
                      dbo.MovimientosBancarios.Tipo
FROM         dbo.Companias INNER JOIN
                      dbo.MovimientosBancarios INNER JOIN
                      dbo.Proveedores ON dbo.MovimientosBancarios.ProvClte = dbo.Proveedores.Proveedor ON 
                      dbo.Companias.Numero = dbo.MovimientosBancarios.Cia INNER JOIN
                      dbo.CuentasBancarias ON dbo.MovimientosBancarios.CuentaInterna = dbo.CuentasBancarias.CuentaInterna INNER JOIN
                      dbo.Monedas ON dbo.CuentasBancarias.Moneda = dbo.Monedas.Moneda INNER JOIN
                      dbo.Bancos ON dbo.CuentasBancarias.Banco = dbo.Bancos.Banco INNER JOIN
                      dbo.Pagos ON dbo.MovimientosBancarios.ClaveUnica = dbo.Pagos.ClaveUnicaMovimientoBancario
WHERE     (dbo.MovimientosBancarios.Tipo = N'CH')
ORDER BY dbo.Proveedores.Nombre

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoComprobantesRetencion2
AS
SELECT     TOP 100 PERCENT dbo.Facturas.NumeroFactura, dbo.Facturas.FechaEmision, dbo.Facturas.FechaRecepcion, 
                      dbo.Monedas.Simbolo AS SimboloMoneda, dbo.Facturas.MontoFactura, dbo.Facturas.MontoSujetoARetencion, dbo.Facturas.ImpuestoRetenidoPorc, 
                      dbo.Facturas.ImpuestoRetenido, dbo.Facturas.Proveedor, dbo.Pagos.ClaveUnicaMovimientoBancario
FROM         dbo.dPagos RIGHT OUTER JOIN
                      dbo.Facturas LEFT OUTER JOIN
                      dbo.Monedas ON dbo.Facturas.Moneda = dbo.Monedas.Moneda ON dbo.dPagos.ClaveUnicaFactura = dbo.Facturas.ClaveUnica LEFT OUTER JOIN
                      dbo.Pagos ON dbo.dPagos.ClaveUnicaPago = dbo.Pagos.ClaveUnica
WHERE     (dbo.Facturas.ImpuestoRetenido IS NOT NULL) AND (dbo.Pagos.ClaveUnicaMovimientoBancario IS NOT NULL)
ORDER BY dbo.Facturas.FechaEmision, dbo.Facturas.NumeroFactura

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

--  ---------------------------
--  tTempPrintChequesContinuos
--  ---------------------------



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tTempPrintChequesContinuos]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tTempPrintChequesContinuos]
GO

CREATE TABLE [dbo].[tTempPrintChequesContinuos] (
	[ClaveUnica] [int] IDENTITY (1, 1) NOT NULL ,
	[Beneficiario] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sFechaEscrita] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Fecha] [datetime] NULL ,
	[Ano] [smallint] NULL ,
	[NombreCompania] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NumeroComprobante] [int] NULL ,
	[NumeroCheque] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaBancaria] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SimboloMoneda] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NombreCiudad] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EndosableFlag] [bit] NULL ,
	[ClaveUnicaComprobante] [int] NULL ,
	[NombreBanco] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sMonto] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ElaboradoPor] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RevisadoPor] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AprovadoPor] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContabilizadoPor] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable1] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber1] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable2] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber2] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable3] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida3] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber3] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable4] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida4] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber4] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable5] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida5] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber5] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable6] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida6] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber6] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable7] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida7] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber7] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable8] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida8] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber8] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable9] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida9] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber9] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable10] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida10] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber10] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable11] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida11] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber11] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable12] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida12] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber12] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable13] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida13] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber13] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable14] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida14] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber14] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable15] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida15] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber15] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tTempPrintChequesContinuos] ADD 
	CONSTRAINT [PK_tTempPrintChequesContinuos] PRIMARY KEY  NONCLUSTERED 
	(
		[ClaveUnica]
	)  ON [PRIMARY] 
GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.154', GetDate()) 

