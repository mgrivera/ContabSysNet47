/*    
	  Viernes, 2 de Agosto de 2.022  -   v0.00.437.sql 
	  
	  tTempWebReport_ConsultaFacturas: agregamos la columna Tasa, para registrar la tasa que pueda tener la factura asociada 
	  Esta tabla se usa en la consulta de facturas desde ContabSysNet y con la tasa allí podemos convertir fácilmente las 
	  cifras a la moneda local. 
*/

/*
   Tuesday, August 2, 20229:17:21 AM
   User: sa
   Server: LAPTOP-7VREH8JJ\SQLEXPRESS
   Database: dbContabSMR
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
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
	MonedaSimbolo nvarchar(6) NOT NULL,
	MonedaDescripcion nvarchar(50) NOT NULL,
	CiaContabNombre nvarchar(50) NOT NULL,
	CiaContabDireccion nvarchar(200) NULL,
	CiaContabRif nvarchar(15) NOT NULL,
	CiaContabTelefono1 nvarchar(15) NULL,
	CiaContabTelefono2 nvarchar(15) NULL,
	CiaContabFax nvarchar(15) NULL,
	CiaContabCiudad nvarchar(25) NULL,
	NombreCompania nvarchar(70) NOT NULL,
	AbreviaturaCompania nvarchar(10) NOT NULL,
	RifCompania nvarchar(20) NULL,
	NitCompania nvarchar(20) NULL,
	CompaniaDomicilio nvarchar(400) NULL,
	CompaniaTelefono nvarchar(15) NULL,
	CompaniaFax nvarchar(15) NULL,
	CompaniaCiudad nvarchar(50) NULL,
	CodigoConceptoRetencion nvarchar(20) NULL,
	ContribuyenteFlag bit NULL,
	NatJurFlag smallint NOT NULL,
	NatJurFlagDescripcion nvarchar(20) NOT NULL,
	NumeroFactura nvarchar(25) NOT NULL,
	NumeroControl nvarchar(20) NULL,
	ImportacionFlag bit NULL,
	Importacion_CompraNacional nvarchar(50) NULL,
	NumeroPlanillaImportacion nvarchar(25) NULL,
	ClaveUnicaFactura int NOT NULL,
	NcNdFlag nvarchar(2) NULL,
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
	MontoTotalFactura money NOT NULL,

	Tasa money NULL,
	ConvertidoSegunTasaFlag bit NULL,

	TipoAlicuota_Reducido nvarchar(1) NULL,
	TipoAlicuota_General nvarchar(1) NULL,
	TipoAlicuota_Adicional nvarchar(1) NULL,
	BaseImponible_Reducido money NULL,
	BaseImponible_General money NULL,
	BaseImponible_Adicional money NULL,
	TipoAlicuota char(1) NULL,
	IvaPorc decimal(6, 3) NULL,
	IvaPorc_Reducido decimal(6, 3) NULL,
	IvaPorc_General decimal(6, 3) NULL,
	IvaPorc_Adicional decimal(6, 3) NULL,
	Iva money NULL,
	Iva_Reducido money NULL,
	Iva_General money NULL,
	Iva_Adicional money NULL,
	TotalFactura money NOT NULL,
	MontoSujetoARetencion money NULL,
	ImpuestoRetenidoPorc decimal(6, 3) NULL,
	ImpuestoRetenidoISLRAntesSustraendo money NULL,
	ImpuestoRetenidoISLRSustraendo money NULL,
	ImpuestoRetenido money NULL,
	ImpuestoRetenido_Reducido money NULL,
	ImpuestoRetenido_General money NULL,
	ImpuestoRetenido_Adicional money NULL,
	FRecepcionRetencionISLR datetime NULL,
	RetencionSobreIvaPorc decimal(6, 3) NULL,
	RetencionSobreIva money NULL,
	FRecepcionRetencionIVA datetime NULL,
	ImpuestosVarios money NULL,
	RetencionesVarias money NULL,
	TotalAPagar money NOT NULL,
	Anticipo money NULL,
	Saldo money NOT NULL,
	Estado smallint NOT NULL,
	NombreEstado nchar(10) NULL,
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
	 EXEC('INSERT INTO dbo.Tmp_tTempWebReport_ConsultaFacturas (Moneda, CiaContab, Compania, MonedaSimbolo, MonedaDescripcion, CiaContabNombre, CiaContabDireccion, CiaContabRif, CiaContabTelefono1, CiaContabTelefono2, CiaContabFax, CiaContabCiudad, NombreCompania, AbreviaturaCompania, RifCompania, NitCompania, CompaniaDomicilio, CompaniaTelefono, CompaniaFax, CompaniaCiudad, CodigoConceptoRetencion, ContribuyenteFlag, NatJurFlag, NatJurFlagDescripcion, NumeroFactura, NumeroControl, ImportacionFlag, Importacion_CompraNacional, NumeroPlanillaImportacion, ClaveUnicaFactura, NcNdFlag, Compra_NotaCredito, NumeroFacturaAfectada, NumeroComprobante, NumeroOperacion, Tipo, NombreTipo, CondicionesDePago, CondicionesDePagoNombre, FechaEmision, FechaRecepcion, Concepto, NotasFactura1, NotasFactura2, NotasFactura3, MontoFacturaSinIva, MontoFacturaConIva, MontoTotalFactura, TipoAlicuota_Reducido, TipoAlicuota_General, TipoAlicuota_Adicional, BaseImponible_Reducido, BaseImponible_General, BaseImponible_Adicional, TipoAlicuota, IvaPorc, IvaPorc_Reducido, IvaPorc_General, IvaPorc_Adicional, Iva, Iva_Reducido, Iva_General, Iva_Adicional, TotalFactura, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenidoISLRAntesSustraendo, ImpuestoRetenidoISLRSustraendo, ImpuestoRetenido, ImpuestoRetenido_Reducido, ImpuestoRetenido_General, ImpuestoRetenido_Adicional, FRecepcionRetencionISLR, RetencionSobreIvaPorc, RetencionSobreIva, FRecepcionRetencionIVA, ImpuestosVarios, RetencionesVarias, TotalAPagar, Anticipo, Saldo, Estado, NombreEstado, CxCCxPFlag, NombreCxCCxPFlag, Comprobante, FechaPago, MontoPagado, NombreUsuario)
		SELECT Moneda, CiaContab, Compania, MonedaSimbolo, MonedaDescripcion, CiaContabNombre, CiaContabDireccion, CiaContabRif, CiaContabTelefono1, CiaContabTelefono2, CiaContabFax, CiaContabCiudad, NombreCompania, AbreviaturaCompania, RifCompania, NitCompania, CompaniaDomicilio, CompaniaTelefono, CompaniaFax, CompaniaCiudad, CodigoConceptoRetencion, ContribuyenteFlag, NatJurFlag, NatJurFlagDescripcion, NumeroFactura, NumeroControl, ImportacionFlag, Importacion_CompraNacional, NumeroPlanillaImportacion, ClaveUnicaFactura, NcNdFlag, Compra_NotaCredito, NumeroFacturaAfectada, NumeroComprobante, NumeroOperacion, Tipo, NombreTipo, CondicionesDePago, CondicionesDePagoNombre, FechaEmision, FechaRecepcion, Concepto, NotasFactura1, NotasFactura2, NotasFactura3, MontoFacturaSinIva, MontoFacturaConIva, MontoTotalFactura, TipoAlicuota_Reducido, TipoAlicuota_General, TipoAlicuota_Adicional, BaseImponible_Reducido, BaseImponible_General, BaseImponible_Adicional, TipoAlicuota, IvaPorc, IvaPorc_Reducido, IvaPorc_General, IvaPorc_Adicional, Iva, Iva_Reducido, Iva_General, Iva_Adicional, TotalFactura, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenidoISLRAntesSustraendo, ImpuestoRetenidoISLRSustraendo, ImpuestoRetenido, ImpuestoRetenido_Reducido, ImpuestoRetenido_General, ImpuestoRetenido_Adicional, FRecepcionRetencionISLR, RetencionSobreIvaPorc, RetencionSobreIva, FRecepcionRetencionIVA, ImpuestosVarios, RetencionesVarias, TotalAPagar, Anticipo, Saldo, Estado, NombreEstado, CxCCxPFlag, NombreCxCCxPFlag, Comprobante, FechaPago, MontoPagado, NombreUsuario FROM dbo.tTempWebReport_ConsultaFacturas WITH (HOLDLOCK TABLOCKX)')
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
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.437', GetDate()) 