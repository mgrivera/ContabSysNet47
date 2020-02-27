/*    Miercoles, 18 de Febrero de 2.009  -   v0.00.241.sql 

	Modificamos levemente la tabla tTempWebReport_ConsultaFacturas 

*/ 



BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tTempWebReport_ConsultaFacturas
	(
	Moneda int NOT NULL,
	CiaContab int NOT NULL,
	Compania int NOT NULL,
	NombreCompania nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	RifCompania nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CodigoConceptoRetencion nvarchar(6) NULL,
	NumeroFactura nvarchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	NumeroControl nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ClaveUnicaFactura int NOT NULL,
	NcNdFlag char(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	NumeroFacturaAfectada nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	NumeroComprobante char(14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	NumeroOperacion smallint NULL,
	Tipo int NOT NULL,
	NombreTipo nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CondicionesDePago int NOT NULL,
	FechaEmision datetime NOT NULL,
	FechaRecepcion datetime NOT NULL,
	Concepto ntext COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	MontoFacturaSinIva money NULL,
	MontoFacturaConIva money NULL,
	IvaPorc real NULL,
	Iva money NULL,
	TotalFactura money NOT NULL,
	MontoSujetoARetencion money NULL,
	ImpuestoRetenidoPorc real NULL,
	ImpuestoRetenido money NULL,
	RetencionSobreIvaPorc real NULL,
	RetencionSobreIva money NULL,
	TotalAPagar money NOT NULL,
	Anticipo money NULL,
	Saldo money NOT NULL,
	Estado smallint NOT NULL,
	NombreEstado nchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	NumeroDeCuotas smallint NULL,
	FechaUltimoVencimiento datetime NULL,
	CxCCxPFlag smallint NOT NULL,
	NombreCxCCxPFlag char(4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Comprobante int NULL,
	FechaPago datetime NULL,
	MontoPagado money NULL,
	NombreUsuario nvarchar(256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tTempWebReport_ConsultaFacturas SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.tTempWebReport_ConsultaFacturas)
	 EXEC('INSERT INTO dbo.Tmp_tTempWebReport_ConsultaFacturas (Moneda, CiaContab, Compania, NombreCompania, NumeroFactura, NumeroControl, ClaveUnicaFactura, NcNdFlag, NumeroFacturaAfectada, NumeroComprobante, NumeroOperacion, Tipo, NombreTipo, CondicionesDePago, FechaEmision, FechaRecepcion, Concepto, MontoFacturaSinIva, MontoFacturaConIva, IvaPorc, Iva, TotalFactura, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenido, RetencionSobreIvaPorc, RetencionSobreIva, TotalAPagar, Anticipo, Saldo, Estado, NombreEstado, NumeroDeCuotas, FechaUltimoVencimiento, CxCCxPFlag, NombreCxCCxPFlag, Comprobante, FechaPago, MontoPagado, NombreUsuario)
		SELECT Moneda, CiaContab, Compania, NombreCompania, NumeroFactura, NumeroControl, ClaveUnicaFactura, NcNdFlag, NumeroFacturaAfectada, NumeroComprobante, NumeroOperacion, Tipo, NombreTipo, CondicionesDePago, FechaEmision, FechaRecepcion, Concepto, MontoFacturaSinIva, MontoFacturaConIva, IvaPorc, Iva, TotalFactura, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenido, RetencionSobreIvaPorc, RetencionSobreIva, TotalAPagar, Anticipo, Saldo, Estado, NombreEstado, NumeroDeCuotas, FechaUltimoVencimiento, CxCCxPFlag, NombreCxCCxPFlag, Comprobante, FechaPago, MontoPagado, NombreUsuario FROM dbo.tTempWebReport_ConsultaFacturas WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.tTempWebReport_ConsultaFacturas
GO
EXECUTE sp_rename N'dbo.Tmp_tTempWebReport_ConsultaFacturas', N'tTempWebReport_ConsultaFacturas', 'OBJECT' 
GO
ALTER TABLE dbo.tTempWebReport_ConsultaFacturas ADD CONSTRAINT
	PK_tTempWebReport_ConsultaFacturas PRIMARY KEY CLUSTERED 
	(
	Moneda,
	CiaContab,
	Compania,
	NumeroFactura,
	NombreUsuario
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.241', GetDate()) 