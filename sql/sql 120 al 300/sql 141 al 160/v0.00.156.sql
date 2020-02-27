/*    Viernes, 1 de Mayo de 2.004   -   v0.00.156.sql 

	Agregamos la tabla OrdenesPago y hacemos cambios relacionados a otras tablas. 

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
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.OrdenesPagoId
	(
	Numero int NOT NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.OrdenesPagoId ADD CONSTRAINT
	PK_OrdenesPagoId PRIMARY KEY CLUSTERED 
	(
	Numero,
	Cia
	) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.OrdenesPago
	(
	Numero int NOT NULL,
	Fecha smalldatetime NOT NULL,
	Proveedor int NULL,
	Moneda int NOT NULL,
	Monto money NOT NULL,
	Prioridad tinyint NOT NULL,
	IndicadorDetalles tinyint NOT NULL,
	Status tinyint NOT NULL,
	RealizadoPor nvarchar(25) NOT NULL,
	RecibidoPor nvarchar(25) NULL,
	RecibidoEl smalldatetime NULL,
	AutorizadoPor nvarchar(25) NULL,
	AutorizadoEl smalldatetime NULL,
	AnuladaPor nvarchar(25) NULL,
	AnuladaEl smalldatetime NULL,
	Concepto nvarchar(500) NOT NULL,
	Observaciones nvarchar(500) NULL,
	Ingreso smalldatetime NOT NULL,
	UltAct smalldatetime NOT NULL,
	Usuario nvarchar(25) NOT NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.OrdenesPago ADD CONSTRAINT
	PK_OrdenesPago PRIMARY KEY CLUSTERED 
	(
	Numero,
	Cia
	) ON [PRIMARY]

GO
ALTER TABLE dbo.OrdenesPago ADD CONSTRAINT
	FK_OrdenesPago_Proveedores FOREIGN KEY
	(
	Proveedor
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	)
GO
ALTER TABLE dbo.OrdenesPago ADD CONSTRAINT
	FK_OrdenesPago_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	)
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.Pagos ADD CONSTRAINT
	FK_Pagos_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	)
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.Facturas ADD CONSTRAINT
	FK_Facturas_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	)
GO
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.OrdenesPagoFacturas
	(
	NumeroOrdenPago int NOT NULL,
	ClaveUnicaFactura int NOT NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.OrdenesPagoFacturas ADD CONSTRAINT
	PK_OrdenesPagoFacturas PRIMARY KEY CLUSTERED 
	(
	NumeroOrdenPago,
	ClaveUnicaFactura,
	Cia
	) ON [PRIMARY]

GO
ALTER TABLE dbo.OrdenesPagoFacturas ADD CONSTRAINT
	FK_OrdenesPagoFacturas_OrdenesPago FOREIGN KEY
	(
	NumeroOrdenPago,
	Cia
	) REFERENCES dbo.OrdenesPago
	(
	Numero,
	Cia
	)
GO
ALTER TABLE dbo.OrdenesPagoFacturas ADD CONSTRAINT
	FK_OrdenesPagoFacturas_Facturas FOREIGN KEY
	(
	ClaveUnicaFactura
	) REFERENCES dbo.Facturas
	(
	ClaveUnica
	)
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.dPagos ADD CONSTRAINT
	FK_dPagos_Pagos FOREIGN KEY
	(
	ClaveUnicaPago
	) REFERENCES dbo.Pagos
	(
	ClaveUnica
	)
GO
ALTER TABLE dbo.dPagos ADD CONSTRAINT
	FK_dPagos_Facturas FOREIGN KEY
	(
	ClaveUnicaFactura
	) REFERENCES dbo.Facturas
	(
	ClaveUnica
	)
GO
ALTER TABLE dbo.dPagos ADD CONSTRAINT
	FK_dPagos_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	)
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.CuotasFactura ADD CONSTRAINT
	FK_CuotasFactura_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	)
GO
COMMIT



--  -----------------------------------------------------------------
--  Hacemos algunos cambios a la tabla tTempPrintChequesContinuos. 
--  -----------------------------------------------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tTempPrintChequesContinuos]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tTempPrintChequesContinuos]
GO

CREATE TABLE [dbo].[tTempPrintChequesContinuos] (
	[ClaveUnica] [int] IDENTITY (1, 1) NOT NULL ,
	[Beneficiario] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NombreBeneficiario] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ConceptoCheque] [nvarchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
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
	[sDebeOHaber15] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NumeroUsuario] [int] NOT NULL 
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
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.156', GetDate()) 

