/*    Miércoles, 18 de Diciembre de 2.013 	-   v0.00.364b.sql 

	Facturas: Otros impuestos y retenciones - cambios para implementar ésto 
	
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
CREATE TABLE dbo.Tmp_Temp_Bancos_ConsultaFacturas
	(
	ID int NOT NULL IDENTITY (1, 1),
	ClaveUnicaFactura int NOT NULL,
	Cia int NOT NULL,
	Compania int NOT NULL,
	NumeroDocumento nvarchar(25) NOT NULL,
	NumeroControl nvarchar(20) NULL,
	FechaEmision date NOT NULL,
	FechaRecepcion date NOT NULL,
	Moneda int NOT NULL,
	CxCCxPFlag smallint NOT NULL,
	NcNdFlag char(2) NULL,
	CondicionesDePago int NOT NULL,
	Tipo int NOT NULL,
	NumeroFacturaAfectada nvarchar(20) NULL,
	Seniat_NumeroComprobante char(14) NULL,
	Seniat_NumeroOperacion smallint NULL,
	Concepto ntext NULL,
	MontoNoImponible money NULL,
	MontoImponible money NULL,
	IvaPorc decimal(6, 3) NULL,
	Iva money NULL,
	TotalFactura money NOT NULL,
	Anticipo money NULL,
	Saldo money NOT NULL,
	Estado smallint NOT NULL,
	RetISLR_CodigoConceptoRetencion nvarchar(6) NULL,
	RetISLR_MontoSujetoARetencion money NULL,
	RetISLR_ImpuestoRetenidoPorc decimal(6, 3) NULL,
	RetISLR_ImpuestoRetenidoAntesSustraendo money NULL,
	RetISLR_Sustraendo money NULL,
	RetISLR_ImpuestoRetenido money NULL,
	RetISLR_FRecepcionRetencionISLR date NULL,
	RetIVA_RetencionSobreIvaPorc decimal(6, 3) NULL,
	RetIVA_RetencionSobreIva money NULL,
	RetIVA_FRecepcionRetencionIVA date NULL,
	ImpuestosRetencionesVarios money NULL,
	Usuario nvarchar(25) NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Temp_Bancos_ConsultaFacturas SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Temp_Bancos_ConsultaFacturas ON
GO
IF EXISTS(SELECT * FROM dbo.Temp_Bancos_ConsultaFacturas)
	 EXEC('INSERT INTO dbo.Tmp_Temp_Bancos_ConsultaFacturas (ID, ClaveUnicaFactura, Cia, Compania, NumeroDocumento, NumeroControl, FechaEmision, FechaRecepcion, Moneda, CxCCxPFlag, NcNdFlag, CondicionesDePago, Tipo, NumeroFacturaAfectada, Seniat_NumeroComprobante, Seniat_NumeroOperacion, Concepto, MontoNoImponible, MontoImponible, IvaPorc, Iva, TotalFactura, Anticipo, Saldo, Estado, RetISLR_CodigoConceptoRetencion, RetISLR_MontoSujetoARetencion, RetISLR_ImpuestoRetenidoPorc, RetISLR_ImpuestoRetenidoAntesSustraendo, RetISLR_Sustraendo, RetISLR_ImpuestoRetenido, RetISLR_FRecepcionRetencionISLR, RetIVA_RetencionSobreIvaPorc, RetIVA_RetencionSobreIva, RetIVA_FRecepcionRetencionIVA, Usuario)
		SELECT ID, ClaveUnicaFactura, Cia, Compania, NumeroDocumento, NumeroControl, FechaEmision, FechaRecepcion, Moneda, CxCCxPFlag, NcNdFlag, CondicionesDePago, Tipo, NumeroFacturaAfectada, Seniat_NumeroComprobante, Seniat_NumeroOperacion, Concepto, MontoNoImponible, MontoImponible, IvaPorc, Iva, TotalFactura, Anticipo, Saldo, Estado, RetISLR_CodigoConceptoRetencion, RetISLR_MontoSujetoARetencion, RetISLR_ImpuestoRetenidoPorc, RetISLR_ImpuestoRetenidoAntesSustraendo, RetISLR_Sustraendo, RetISLR_ImpuestoRetenido, RetISLR_FRecepcionRetencionISLR, RetIVA_RetencionSobreIvaPorc, RetIVA_RetencionSobreIva, RetIVA_FRecepcionRetencionIVA, Usuario FROM dbo.Temp_Bancos_ConsultaFacturas WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Temp_Bancos_ConsultaFacturas OFF
GO
DROP TABLE dbo.Temp_Bancos_ConsultaFacturas
GO
EXECUTE sp_rename N'dbo.Tmp_Temp_Bancos_ConsultaFacturas', N'Temp_Bancos_ConsultaFacturas', 'OBJECT' 
GO
COMMIT



/****** Object:  View [dbo].[vTemp_Bancos_ConsultaFacturas]    Script Date: 12/18/2013 11:18:44 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vTemp_Bancos_ConsultaFacturas]'))
DROP VIEW [dbo].[vTemp_Bancos_ConsultaFacturas]
GO

/****** Object:  View [dbo].[vTemp_Bancos_ConsultaFacturas]    Script Date: 12/18/2013 11:18:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vTemp_Bancos_ConsultaFacturas]
AS
SELECT     dbo.Temp_Bancos_ConsultaFacturas.ClaveUnicaFactura, dbo.Temp_Bancos_ConsultaFacturas.NumeroDocumento, 
                      dbo.Temp_Bancos_ConsultaFacturas.NumeroControl, dbo.Temp_Bancos_ConsultaFacturas.FechaEmision, dbo.Temp_Bancos_ConsultaFacturas.FechaRecepcion, 
                      dbo.Monedas.Simbolo AS SimboloMoneda, dbo.Proveedores.Abreviatura AS AbreviaturaCompania, dbo.Proveedores.Nombre AS NombreCompania, 
                      CASE dbo.Temp_Bancos_ConsultaFacturas.CxCCxPFlag WHEN 1 THEN 'CxP' WHEN 2 THEN 'CxC' END AS CxCCxPFlag, 
                      dbo.Temp_Bancos_ConsultaFacturas.NcNdFlag, dbo.FormasDePago.Descripcion AS NombreFormaPago, dbo.TiposProveedor.Descripcion AS NombreTipoServicio, 
                      dbo.Temp_Bancos_ConsultaFacturas.Seniat_NumeroComprobante, dbo.Temp_Bancos_ConsultaFacturas.Seniat_NumeroOperacion, 
                      dbo.Temp_Bancos_ConsultaFacturas.Concepto, dbo.Temp_Bancos_ConsultaFacturas.MontoNoImponible, dbo.Temp_Bancos_ConsultaFacturas.MontoImponible, 
                      dbo.Temp_Bancos_ConsultaFacturas.IvaPorc, dbo.Temp_Bancos_ConsultaFacturas.Iva, dbo.Temp_Bancos_ConsultaFacturas.TotalFactura, 
                      dbo.Temp_Bancos_ConsultaFacturas.RetISLR_ImpuestoRetenido, dbo.Temp_Bancos_ConsultaFacturas.RetIVA_RetencionSobreIva, 
                      dbo.Temp_Bancos_ConsultaFacturas.ImpuestosRetencionesVarios, dbo.Temp_Bancos_ConsultaFacturas.Anticipo, dbo.Temp_Bancos_ConsultaFacturas.Saldo, 
                      CASE dbo.Temp_Bancos_ConsultaFacturas.Estado WHEN 1 THEN 'Pendiente' WHEN 2 THEN 'Parcial' WHEN 3 THEN 'Pagada' WHEN 4 THEN 'Anulada' END AS Estado,
                       dbo.Companias.Abreviatura AS AbreviaturaCia, dbo.Companias.Nombre AS NombreCia, dbo.Temp_Bancos_ConsultaFacturas.Usuario
FROM         dbo.Companias INNER JOIN
                      dbo.Temp_Bancos_ConsultaFacturas ON dbo.Companias.Numero = dbo.Temp_Bancos_ConsultaFacturas.Cia INNER JOIN
                      dbo.FormasDePago ON dbo.Temp_Bancos_ConsultaFacturas.CondicionesDePago = dbo.FormasDePago.FormaDePago INNER JOIN
                      dbo.TiposProveedor ON dbo.Temp_Bancos_ConsultaFacturas.Tipo = dbo.TiposProveedor.Tipo INNER JOIN
                      dbo.Proveedores ON dbo.Temp_Bancos_ConsultaFacturas.Compania = dbo.Proveedores.Proveedor LEFT OUTER JOIN
                      dbo.Monedas ON dbo.Temp_Bancos_ConsultaFacturas.Moneda = dbo.Monedas.Moneda

GO



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
	CodigoConceptoRetencion nvarchar(6) NULL,
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
	ImpuestosRetencionesVarias money NULL,
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
	 EXEC('INSERT INTO dbo.Tmp_tTempWebReport_ConsultaFacturas (Moneda, CiaContab, Compania, MonedaSimbolo, MonedaDescripcion, CiaContabNombre, CiaContabDireccion, CiaContabRif, CiaContabTelefono1, CiaContabTelefono2, CiaContabFax, CiaContabCiudad, NombreCompania, AbreviaturaCompania, RifCompania, NitCompania, CompaniaDomicilio, CompaniaTelefono, CompaniaFax, CompaniaCiudad, CodigoConceptoRetencion, NumeroFactura, NumeroControl, ImportacionFlag, Importacion_CompraNacional, NumeroPlanillaImportacion, ClaveUnicaFactura, NcNdFlag, Compra_NotaCredito, NumeroFacturaAfectada, NumeroComprobante, NumeroOperacion, Tipo, NombreTipo, CondicionesDePago, CondicionesDePagoNombre, FechaEmision, FechaRecepcion, Concepto, NotasFactura1, NotasFactura2, NotasFactura3, MontoFacturaSinIva, MontoFacturaConIva, BaseImponible_Reducido, BaseImponible_General, BaseImponible_Adicional, TipoAlicuota, IvaPorc, IvaPorc_Reducido, IvaPorc_General, IvaPorc_Adicional, Iva, Iva_Reducido, Iva_General, Iva_Adicional, TotalFactura, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenidoISLRAntesSustraendo, ImpuestoRetenidoISLRSustraendo, ImpuestoRetenido, ImpuestoRetenido_Reducido, ImpuestoRetenido_General, ImpuestoRetenido_Adicional, FRecepcionRetencionISLR, RetencionSobreIvaPorc, RetencionSobreIva, FRecepcionRetencionIVA, TotalAPagar, Anticipo, Saldo, Estado, NombreEstado, CxCCxPFlag, NombreCxCCxPFlag, Comprobante, FechaPago, MontoPagado, NombreUsuario)
		SELECT Moneda, CiaContab, Compania, MonedaSimbolo, MonedaDescripcion, CiaContabNombre, CiaContabDireccion, CiaContabRif, CiaContabTelefono1, CiaContabTelefono2, CiaContabFax, CiaContabCiudad, NombreCompania, AbreviaturaCompania, RifCompania, NitCompania, CompaniaDomicilio, CompaniaTelefono, CompaniaFax, CompaniaCiudad, CodigoConceptoRetencion, NumeroFactura, NumeroControl, ImportacionFlag, Importacion_CompraNacional, NumeroPlanillaImportacion, ClaveUnicaFactura, NcNdFlag, Compra_NotaCredito, NumeroFacturaAfectada, NumeroComprobante, NumeroOperacion, Tipo, NombreTipo, CondicionesDePago, CondicionesDePagoNombre, FechaEmision, FechaRecepcion, Concepto, NotasFactura1, NotasFactura2, NotasFactura3, MontoFacturaSinIva, MontoFacturaConIva, BaseImponible_Reducido, BaseImponible_General, BaseImponible_Adicional, TipoAlicuota, IvaPorc, IvaPorc_Reducido, IvaPorc_General, IvaPorc_Adicional, Iva, Iva_Reducido, Iva_General, Iva_Adicional, TotalFactura, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenidoISLRAntesSustraendo, ImpuestoRetenidoISLRSustraendo, ImpuestoRetenido, ImpuestoRetenido_Reducido, ImpuestoRetenido_General, ImpuestoRetenido_Adicional, FRecepcionRetencionISLR, RetencionSobreIvaPorc, RetencionSobreIva, FRecepcionRetencionIVA, TotalAPagar, Anticipo, Saldo, Estado, NombreEstado, CxCCxPFlag, NombreCxCCxPFlag, Comprobante, FechaPago, MontoPagado, NombreUsuario FROM dbo.tTempWebReport_ConsultaFacturas WITH (HOLDLOCK TABLOCKX)')
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
CREATE TABLE dbo.Tmp_ImpuestosRetencionesDefinicion
	(
	ID int NOT NULL IDENTITY (1, 1),
	ImpuestoRetencion smallint NULL,
	Descripcion nvarchar(50) NOT NULL,
	Base smallint NULL,
	Porcentaje decimal(5, 3) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_ImpuestosRetencionesDefinicion SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_ImpuestosRetencionesDefinicion ON
GO
IF EXISTS(SELECT * FROM dbo.ImpuestosRetencionesDefinicion)
	 EXEC('INSERT INTO dbo.Tmp_ImpuestosRetencionesDefinicion (ID, Descripcion, Base, Porcentaje)
		SELECT ID, Descripcion, Base, Porcentaje FROM dbo.ImpuestosRetencionesDefinicion WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_ImpuestosRetencionesDefinicion OFF
GO
ALTER TABLE dbo.Facturas_Impuestos
	DROP CONSTRAINT FK_Facturas_Impuestos_ImpuestosRetencionesDefinicion
GO
DROP TABLE dbo.ImpuestosRetencionesDefinicion
GO
EXECUTE sp_rename N'dbo.Tmp_ImpuestosRetencionesDefinicion', N'ImpuestosRetencionesDefinicion', 'OBJECT' 
GO
ALTER TABLE dbo.ImpuestosRetencionesDefinicion ADD CONSTRAINT
	PK_ImpuestosRetencionesDefinicion PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Facturas_Impuestos ADD CONSTRAINT
	FK_Facturas_Impuestos_ImpuestosRetencionesDefinicion FOREIGN KEY
	(
	ImpRetID
	) REFERENCES dbo.ImpuestosRetencionesDefinicion
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Facturas_Impuestos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


Update ImpuestosRetencionesDefinicion Set ImpuestoRetencion = 1
Alter TABLE ImpuestosRetencionesDefinicion Alter Column ImpuestoRetencion smallint Not NULL


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.364b', GetDate()) 
