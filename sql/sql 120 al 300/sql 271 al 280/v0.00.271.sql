/*    Jueves, 30 de Septiembre de 2.010  -   v0.00.271.sql 

	Hacemos cambios muy leves a la tabla tTempWebReport_ConsultaFacturas 
	para mostrar las ciudades en las direcciones ... 

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
	CiaContabNombre nvarchar(50) NOT NULL,
	CiaContabDireccion nvarchar(200) NULL,
	CiaContabRif nvarchar(15) NOT NULL,
	CiaContabTelefono1 nvarchar(15) NULL,
	CiaContabTelefono2 nvarchar(15) NULL,
	CiaContabFax nvarchar(15) NULL,
	NombreCompania nvarchar(50) NOT NULL,
	RifCompania nvarchar(20) NULL,
	CompaniaDomicilio nvarchar(400) NULL,
	CompaniaTelefono nvarchar(15) NULL,
	CompaniaFax nvarchar(15) NULL,
	CodigoConceptoRetencion nvarchar(6) NULL,
	NumeroFactura nvarchar(25) NOT NULL,
	NumeroControl nvarchar(20) NULL,
	ImportacionFlag bit NULL,
	Importacion_CompraNacional nvarchar(50) NULL,
	ClaveUnicaFactura int NOT NULL,
	NcNdFlag char(2) NULL,
	Compra_NotaCredito nvarchar(50) NULL,
	NumeroFacturaAfectada nvarchar(20) NULL,
	NumeroComprobante char(14) NULL,
	NumeroOperacion smallint NULL,
	Tipo int NOT NULL,
	NombreTipo nvarchar(50) NOT NULL,
	CondicionesDePago int NOT NULL,
	CondicionesDePagoNombre nvarchar(30) NULL,
	FechaEmision datetime NOT NULL,
	FechaRecepcion datetime NOT NULL,
	Concepto ntext NULL,
	NotasFactura1 nvarchar(100) NULL,
	NotasFactura2 nvarchar(100) NULL,
	NotasFactura3 nvarchar(100) NULL,
	MontoFacturaSinIva money NULL,
	MontoFacturaConIva money NULL,
	BaseImponible_Reducido money NULL,
	BaseImponible_General money NULL,
	BaseImponible_Adicional money NULL,
	TipoAlicuota char(1) NULL,
	IvaPorc real NULL,
	IvaPorc_Reducido real NULL,
	IvaPorc_General real NULL,
	IvaPorc_Adicional real NULL,
	Iva money NULL,
	Iva_Reducido money NULL,
	Iva_General money NULL,
	Iva_Adicional money NULL,
	TotalFactura money NOT NULL,
	MontoSujetoARetencion money NULL,
	ImpuestoRetenidoPorc real NULL,
	ImpuestoRetenidoISLRAntesSustraendo money NULL,
	ImpuestoRetenidoISLRSustraendo money NULL,
	ImpuestoRetenido money NULL,
	ImpuestoRetenido_Reducido money NULL,
	ImpuestoRetenido_General money NULL,
	ImpuestoRetenido_Adicional money NULL,
	FRecepcionRetencionISLR datetime NULL,
	RetencionSobreIvaPorc real NULL,
	RetencionSobreIva money NULL,
	FRecepcionRetencionIVA datetime NULL,
	TotalAPagar money NOT NULL,
	Anticipo money NULL,
	Saldo money NOT NULL,
	Estado smallint NOT NULL,
	NombreEstado nchar(10) NULL,
	NumeroDeCuotas smallint NULL,
	FechaUltimoVencimiento datetime NULL,
	CxCCxPFlag smallint NOT NULL,
	NombreCxCCxPFlag char(4) NOT NULL,
	Comprobante int NULL,
	FechaPago datetime NULL,
	MontoPagado money NULL,
	NombreUsuario nvarchar(256) NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tTempWebReport_ConsultaFacturas SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.tTempWebReport_ConsultaFacturas)
	 EXEC('INSERT INTO dbo.Tmp_tTempWebReport_ConsultaFacturas (Moneda, CiaContab, Compania, CiaContabNombre, CiaContabDireccion, CiaContabRif, CiaContabTelefono1, CiaContabTelefono2, CiaContabFax, NombreCompania, RifCompania, CompaniaDomicilio, CompaniaTelefono, CompaniaFax, CodigoConceptoRetencion, NumeroFactura, NumeroControl, ImportacionFlag, Importacion_CompraNacional, ClaveUnicaFactura, NcNdFlag, Compra_NotaCredito, NumeroFacturaAfectada, NumeroComprobante, NumeroOperacion, Tipo, NombreTipo, CondicionesDePago, CondicionesDePagoNombre, FechaEmision, FechaRecepcion, Concepto, NotasFactura1, NotasFactura2, NotasFactura3, MontoFacturaSinIva, MontoFacturaConIva, BaseImponible_Reducido, BaseImponible_General, BaseImponible_Adicional, TipoAlicuota, IvaPorc, IvaPorc_Reducido, IvaPorc_General, IvaPorc_Adicional, Iva, Iva_Reducido, Iva_General, Iva_Adicional, TotalFactura, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenidoISLRAntesSustraendo, ImpuestoRetenidoISLRSustraendo, ImpuestoRetenido, ImpuestoRetenido_Reducido, ImpuestoRetenido_General, ImpuestoRetenido_Adicional, FRecepcionRetencionISLR, RetencionSobreIvaPorc, RetencionSobreIva, FRecepcionRetencionIVA, TotalAPagar, Anticipo, Saldo, Estado, NombreEstado, NumeroDeCuotas, FechaUltimoVencimiento, CxCCxPFlag, NombreCxCCxPFlag, Comprobante, FechaPago, MontoPagado, NombreUsuario)
		SELECT Moneda, CiaContab, Compania, CiaContabNombre, CiaContabDireccion, CiaContabRif, CiaContabTelefono1, CiaContabTelefono2, CiaContabFax, NombreCompania, RifCompania, CompaniaDomicilio, CompaniaTelefono, CompaniaFax, CodigoConceptoRetencion, NumeroFactura, NumeroControl, ImportacionFlag, Importacion_CompraNacional, ClaveUnicaFactura, NcNdFlag, Compra_NotaCredito, NumeroFacturaAfectada, NumeroComprobante, NumeroOperacion, Tipo, NombreTipo, CondicionesDePago, CondicionesDePagoNombre, FechaEmision, FechaRecepcion, Concepto, NotasFactura1, NotasFactura2, NotasFactura3, MontoFacturaSinIva, MontoFacturaConIva, BaseImponible_Reducido, BaseImponible_General, BaseImponible_Adicional, TipoAlicuota, IvaPorc, IvaPorc_Reducido, IvaPorc_General, IvaPorc_Adicional, Iva, Iva_Reducido, Iva_General, Iva_Adicional, TotalFactura, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenidoISLRAntesSustraendo, ImpuestoRetenidoISLRSustraendo, ImpuestoRetenido, ImpuestoRetenido_Reducido, ImpuestoRetenido_General, ImpuestoRetenido_Adicional, FRecepcionRetencionISLR, RetencionSobreIvaPorc, RetencionSobreIva, FRecepcionRetencionIVA, TotalAPagar, Anticipo, Saldo, Estado, NombreEstado, NumeroDeCuotas, FechaUltimoVencimiento, CxCCxPFlag, NombreCxCCxPFlag, Comprobante, FechaPago, MontoPagado, NombreUsuario FROM dbo.tTempWebReport_ConsultaFacturas WITH (HOLDLOCK TABLOCKX)')
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
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.271', GetDate()) 