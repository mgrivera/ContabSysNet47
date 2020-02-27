/*    Lunes, 17 de Julio de 2.006   -   v0.00.202.sql 

	Hacemos cambios necesarios para el procesamiento de los depósitos de pagos con tarjetas de
	crédito y débito 

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
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.BancosInfoTarjetas
	(
	Banco int NOT NULL,
	Tarjeta char(2) NOT NULL,
	PorcComision decimal(5, 2) NULL,
	PorcImpuestos decimal(5, 2) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.BancosInfoTarjetas ADD CONSTRAINT
	PK_BancosInfoTarjetas PRIMARY KEY CLUSTERED 
	(
	Banco,
	Tarjeta
	) 

GO
ALTER TABLE dbo.BancosInfoTarjetas ADD CONSTRAINT
	FK_BancosInfoTarjetas_Bancos FOREIGN KEY
	(
	Banco
	) REFERENCES dbo.Bancos
	(
	Banco
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
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
ALTER TABLE dbo.CuentasBancariasInfoTarjetas
	DROP CONSTRAINT FK_CuentasBancariasInfoTarjetas_CuentasBancarias
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_CuentasBancariasInfoTarjetas
	(
	CuentaInterna int NOT NULL,
	CuentaContableComision nvarchar(25) NULL,
	CuentaContableImpuestos nvarchar(25) NULL,
	CuentaContableCxC nvarchar(25) NULL,
	CiaContab int NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.CuentasBancariasInfoTarjetas)
	 EXEC('INSERT INTO dbo.Tmp_CuentasBancariasInfoTarjetas (CuentaInterna, CuentaContableComision, CuentaContableImpuestos)
		SELECT CuentaInterna, CuentaContableComision, CuentaContableImpuestos FROM dbo.CuentasBancariasInfoTarjetas WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.CuentasBancariasInfoTarjetas
GO
EXECUTE sp_rename N'dbo.Tmp_CuentasBancariasInfoTarjetas', N'CuentasBancariasInfoTarjetas', 'OBJECT' 
GO
ALTER TABLE dbo.CuentasBancariasInfoTarjetas ADD CONSTRAINT
	PK_CuentasBancariasInfoTarjetas_1 PRIMARY KEY CLUSTERED 
	(
	CuentaInterna,
	CiaContab
	)

GO
ALTER TABLE dbo.CuentasBancariasInfoTarjetas ADD CONSTRAINT
	FK_CuentasBancariasInfoTarjetas_CuentasBancarias FOREIGN KEY
	(
	CuentaInterna
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
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
ALTER TABLE dbo.CuentasBancarias
	DROP COLUMN CuentaContableCxC
GO
COMMIT

-- IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CuentasBancariasInfoTarjetas_CuentasBancarias]') AND parent_object_id = OBJECT_ID(N'[dbo].[CuentasBancariasCuentasContables]'))
-- ALTER TABLE [dbo].[CuentasBancariasCuentasContables] DROP CONSTRAINT [FK_CuentasBancariasInfoTarjetas_CuentasBancarias]

/****** Object:  Table [dbo].[CuentasBancariasCuentasContables]    Script Date: 02/18/2007 09:10:28 ******/
-- IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CuentasBancariasCuentasContables]') AND type in (N'U'))
-- DROP TABLE [dbo].[CuentasBancariasCuentasContables]



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CuentasBancariasCuentasContables](
	[CuentaInterna] [int] NOT NULL,
	[Tarjeta] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PorcComision] [decimal](5, 2) NULL,
	[PorcImpuestos] [decimal](5, 2) NULL,
	[CiaContab] [int] NOT NULL,
	[CuentaContableComision] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CuentaContableImpuestos] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_CuentasBancariasCuentasContables] PRIMARY KEY CLUSTERED 
(
	[CuentaInterna] ASC,
	[Tarjeta] ASC,
	[CiaContab] ASC
)
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[CuentasBancariasCuentasContables]  WITH CHECK ADD  CONSTRAINT [FK_CuentasBancariasCuentasContables_CuentasBancarias] FOREIGN KEY([CuentaInterna])
REFERENCES [dbo].[CuentasBancarias] ([CuentaInterna])
GO
ALTER TABLE [dbo].[CuentasBancariasCuentasContables] CHECK CONSTRAINT [FK_CuentasBancariasCuentasContables_CuentasBancarias]










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
ALTER TABLE dbo.CuentasBancariasCuentasContables ADD
	CuentaContableCxC nvarchar(25) NULL
GO
ALTER TABLE dbo.CuentasBancariasCuentasContables
	DROP COLUMN PorcComision, PorcImpuestos
GO
COMMIT
BEGIN TRANSACTION
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasBancarias ADD CONSTRAINT
	FK_CuentasBancarias_Bancos FOREIGN KEY
	(
	Banco
	) REFERENCES dbo.Bancos
	(
	Banco
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
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
DROP TABLE dbo.CuentasBancariasInfoTarjetas
GO
COMMIT
BEGIN TRANSACTION
GO
COMMIT







IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[qFormaCuentasBancariasConsulta]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[qFormaCuentasBancariasConsulta]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[qFormaCuentasBancariasInfoCuentasContablesConsulta]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[qFormaCuentasBancariasInfoCuentasContablesConsulta]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[qFormaMovimientosBancarios]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[qFormaMovimientosBancarios]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[qFormaMovimientosBancariosConsulta]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[qFormaMovimientosBancariosConsulta]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[qFormaCuentasBancarias]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[qFormaCuentasBancarias]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[qFormaParametrosGlobalBancos]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[qFormaParametrosGlobalBancos]








SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[qFormaCuentasBancariasInfoCuentasContablesConsulta]') AND OBJECTPROPERTY(id, N'IsView') = 1)
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[qFormaCuentasBancariasInfoCuentasContablesConsulta]
AS
SELECT     dbo.Companias.Numero, dbo.CuentasBancariasCuentasContables.CuentaInterna, dbo.CuentasBancariasCuentasContables.Tarjeta, 
                      dbo.Companias.NombreCorto, dbo.CuentasBancariasCuentasContables.CuentaContableComision, 
                      dbo.CuentasBancariasCuentasContables.CuentaContableImpuestos, dbo.CuentasBancariasCuentasContables.CuentaContableCxC
FROM         dbo.CuentasBancariasCuentasContables LEFT OUTER JOIN
                      dbo.Companias ON dbo.CuentasBancariasCuentasContables.CiaContab = dbo.Companias.Numero

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[qFormaCuentasBancariasConsulta]') AND OBJECTPROPERTY(id, N'IsView') = 1)
EXEC dbo.sp_executesql @statement = N'/****** Object:  View dbo.qFormaCuentasBancariasConsulta    Script Date: 28/11/00 07:01:24 p.m. *****
***** Object:  View dbo.qFormaCuentasBancariasConsulta    Script Date: 08/nov/00 9:01:18 *****
***** Object:  View dbo.qFormaCuentasBancariasConsulta    Script Date: 30/sep/00 1:10:01 ******/
CREATE VIEW [dbo].[qFormaCuentasBancariasConsulta]
AS
SELECT     dbo.CuentasBancarias.CuentaInterna, dbo.CuentasBancarias.Agencia, dbo.Agencias.Nombre AS NombreAgencia, 
                      dbo.CuentasBancarias.CuentaBancaria, dbo.CuentasBancarias.Tipo, dbo.CuentasBancarias.Moneda, dbo.Monedas.Simbolo AS SimboloMoneda, 
                      dbo.CuentasBancarias.LineaCredito, dbo.CuentasBancarias.Estado, dbo.CuentasBancarias.Banco, dbo.Bancos.Nombre AS NombreBanco, 
                      dbo.CuentasBancarias.CuentaContable, dbo.CuentasBancarias.CuentaContableGastosIDB, dbo.CuentasBancarias.FormatoImpresionCheque, 
                      dbo.CuentasBancarias.GenerarTransaccionesAOtraCuentaFlag, dbo.CuentasBancarias.CuentaBancariaAsociada, 
                      dbo.CuentasBancarias.NombrePlantillaWord, dbo.CuentasBancarias.Cia
FROM         dbo.CuentasBancarias INNER JOIN
                      dbo.Bancos ON dbo.CuentasBancarias.Banco = dbo.Bancos.Banco INNER JOIN
                      dbo.Agencias ON dbo.CuentasBancarias.Agencia = dbo.Agencias.Agencia INNER JOIN
                      dbo.Monedas ON dbo.CuentasBancarias.Moneda = dbo.Monedas.Moneda

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[qFormaMovimientosBancariosConsulta]') AND OBJECTPROPERTY(id, N'IsView') = 1)
EXEC dbo.sp_executesql @statement = N'/****** Object:  View dbo.qFormaMovimientosBancariosConsulta    Script Date: 31/12/00 10:25:58 a.m. *****
***** Object:  View dbo.qFormaMovimientosBancariosConsulta    Script Date: 28/11/00 07:01:25 p.m. *****
***** Object:  View dbo.qFormaMovimientosBancariosConsulta    Script Date: 08/nov/00 9:01:18 *****
***** Object:  View dbo.qFormaMovimientosBancariosConsulta    Script Date: 30/sep/00 1:10:03 ******/
CREATE VIEW [dbo].[qFormaMovimientosBancariosConsulta]
AS
SELECT     dbo.Bancos.Nombre AS NombreBanco, dbo.MovimientosBancarios.Transaccion, dbo.MovimientosBancarios.CuentaInterna, 
                      dbo.MovimientosBancarios.Tipo, dbo.CuentasBancarias.CuentaBancaria, dbo.MovimientosBancarios.Fecha, dbo.MovimientosBancarios.Mes, 
                      dbo.MovimientosBancarios.Ano, dbo.MovimientosBancarios.Tarjeta, dbo.MovimientosBancarios.ProvClte, 
                      dbo.Proveedores.Nombre AS NombreProveedorCliente, dbo.MovimientosBancarios.Beneficiario, dbo.MovimientosBancarios.Concepto, 
                      dbo.MovimientosBancarios.MontoBase, dbo.MovimientosBancarios.PorcComision, dbo.MovimientosBancarios.Comision, 
                      dbo.MovimientosBancarios.FactorReversionImpuestos, dbo.MovimientosBancarios.MontoBaseParaImpuestos, 
                      dbo.MovimientosBancarios.PorcImpuestos, dbo.MovimientosBancarios.Impuestos, dbo.MovimientosBancarios.Monto, 
                      dbo.MovimientosBancarios.Ingreso, dbo.MovimientosBancarios.UltMod, dbo.MovimientosBancarios.Comprobante, 
                      dbo.MovimientosBancarios.ClaveUnica, dbo.MovimientosBancarios.ClaveUnicaChequera, dbo.MovimientosBancarios.FechaEntregado, 
                      dbo.MovimientosBancarios.Cia
FROM         dbo.Bancos RIGHT OUTER JOIN
                      dbo.CuentasBancarias ON dbo.Bancos.Banco = dbo.CuentasBancarias.Banco RIGHT OUTER JOIN
                      dbo.MovimientosBancarios LEFT OUTER JOIN
                      dbo.Proveedores ON dbo.MovimientosBancarios.ProvClte = dbo.Proveedores.Proveedor ON 
                      dbo.CuentasBancarias.CuentaInterna = dbo.MovimientosBancarios.CuentaInterna

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[qFormaCuentasBancarias]') AND OBJECTPROPERTY(id, N'IsView') = 1)
EXEC dbo.sp_executesql @statement = N'/****** Object:  View dbo.qFormaCuentasBancarias    Script Date: 28/11/00 07:01:23 p.m. *****
***** Object:  View dbo.qFormaCuentasBancarias    Script Date: 08/nov/00 9:01:18 *****
***** Object:  View dbo.qFormaCuentasBancarias    Script Date: 30/sep/00 1:10:01 ******/
CREATE VIEW [dbo].[qFormaCuentasBancarias]
AS
SELECT     dbo.CuentasBancarias.CuentaInterna, dbo.CuentasBancarias.Agencia, dbo.CuentasBancarias.CuentaBancaria, dbo.CuentasBancarias.Tipo, 
                      dbo.CuentasBancarias.Moneda, dbo.CuentasBancarias.LineaCredito, dbo.CuentasBancarias.Estado, dbo.CuentasBancarias.Banco, 
                      dbo.Bancos.Nombre AS NombreBanco, dbo.CuentasBancarias.CuentaContable, dbo.CuentasBancarias.CuentaContableGastosIDB, 
                      dbo.CuentasBancarias.FormatoImpresionCheque, dbo.CuentasBancarias.GenerarTransaccionesAOtraCuentaFlag, 
                      dbo.CuentasBancarias.CuentaBancariaAsociada, dbo.CuentasBancarias.NombrePlantillaWord, dbo.CuentasBancarias.Cia
FROM         dbo.CuentasBancarias LEFT OUTER JOIN
                      dbo.Bancos ON dbo.CuentasBancarias.Banco = dbo.Bancos.Banco

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[qFormaParametrosGlobalBancos]') AND OBJECTPROPERTY(id, N'IsView') = 1)
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[qFormaParametrosGlobalBancos]
AS
SELECT     ClaveUnica, AgregarAsientosContables, TipoAsientoDefault, IvaPorc, CuentaContableIva, NombreCiudadParaCheque, ActivarPrefacturacionAutomatica, 
                      FormaDePagoDefaultEnFacturas, MoraPorc, ObservacionesRecibosCondominio, NotasRecibosCondominio, DecimalesRecibosCondoFlag, 
                      PrefijoFacturasCondominio, PrefijoFacturasEstacionamiento, FormaDePagoDefaultEnFacturasEstacionamiento, 
                      TipoDefaultEnFacturasEstacionamiento, AplicarIDBFlag, PorcentajeIDB, MovimientosQueGeneranIDB, ContabilizarIDBFlag, 
                      MonedasQueNoGeneranIDB, AgregarOrdenesPagoFlag, FactorReversionImpuestos
FROM         dbo.ParametrosGlobalBancos
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[qFormaMovimientosBancarios]') AND OBJECTPROPERTY(id, N'IsView') = 1)
EXEC dbo.sp_executesql @statement = N'/****** Object:  View dbo.qFormaMovimientosBancarios    Script Date: 31/12/00 10:25:58 a.m. *****
***** Object:  View dbo.qFormaMovimientosBancarios    Script Date: 28/11/00 07:01:25 p.m. *****
***** Object:  View dbo.qFormaMovimientosBancarios    Script Date: 08/nov/00 9:01:16 *****
***** Object:  View dbo.qFormaMovimientosBancarios    Script Date: 30/sep/00 1:10:03 ******/
CREATE VIEW [dbo].[qFormaMovimientosBancarios]
AS
SELECT     Transaccion, CuentaInterna, Tipo, Fecha, Mes, Ano, Tarjeta, ProvClte, Beneficiario, Concepto, MontoBase, PorcComision, Comision, 
                      FactorReversionImpuestos, MontoBaseParaImpuestos, PorcImpuestos, Impuestos, Monto, Ingreso, UltMod, Comprobante, ClaveUnica, 
                      ClaveUnicaChequera, FechaEntregado, Cia
FROM         dbo.MovimientosBancarios

' 


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.202', GetDate()) 