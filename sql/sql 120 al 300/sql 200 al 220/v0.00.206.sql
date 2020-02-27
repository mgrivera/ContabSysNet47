/*    Martes, 22 de marzo de 2.007   -   v0.00.206.sql 

	Creamos la tabla MovimientosBancariosPagosTarjetas para registrar los depósitos de pagos con tarjeta 
	de crédito o débito

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
CREATE TABLE dbo.MovimientosBancariosPagosTarjetas
	(
	Transaccion nvarchar(20) NOT NULL,
	CuentaInterna int NOT NULL,
	Tipo nvarchar(2) NOT NULL,
	Tarjeta char(2) NOT NULL,
	MontoBase money NULL,
	PorcComision decimal(5, 2) NULL,
	Comision money NULL,
	FactorReversionImpuestos float(53) NULL,
	MontoBaseParaImpuestos money NULL,
	PorcImpuestos decimal(5, 2) NULL,
	Impuestos money NULL,
	Monto money NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.MovimientosBancariosPagosTarjetas ADD CONSTRAINT
	PK_MovimientosBancariosPagosTarjetas PRIMARY KEY CLUSTERED 
	(
	Transaccion,
	CuentaInterna,
	Tipo,
	Tarjeta
	) ON [PRIMARY]

GO
ALTER TABLE dbo.MovimientosBancariosPagosTarjetas ADD CONSTRAINT
	FK_MovimientosBancariosPagosTarjetas_MovimientosBancarios FOREIGN KEY
	(
	Transaccion,
	CuentaInterna,
	Tipo
	) REFERENCES dbo.MovimientosBancarios
	(
	Transaccion,
	CuentaInterna,
	Tipo
	) ON UPDATE CASCADE
	 ON DELETE CASCADE
	
GO
COMMIT







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
ALTER TABLE dbo.MovimientosBancariosPagosTarjetas
	DROP CONSTRAINT FK_MovimientosBancariosPagosTarjetas_MovimientosBancarios
GO
COMMIT
BEGIN TRANSACTION
COMMIT
BEGIN TRANSACTION
COMMIT





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
ALTER TABLE dbo.MovimientosBancarios
	DROP COLUMN Tarjeta, PorcComision, FactorReversionImpuestos, MontoBaseParaImpuestos, PorcImpuestos
GO
COMMIT



Update MovimientosBancarios 
Set Transaccion = rtrim(Transaccion) + '_dt' 
Where Tipo = 'DT' 


update MovimientosBancarios Set Tipo = 'DP' Where Tipo = 'DT' 


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaMovimientosBancarios]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaMovimientosBancarios]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaMovimientosBancariosConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaMovimientosBancariosConsulta]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qFormaMovimientosBancarios    Script Date: 31/12/00 10:25:58 a.m. *****
***** Object:  View dbo.qFormaMovimientosBancarios    Script Date: 28/11/00 07:01:25 p.m. *****
***** Object:  View dbo.qFormaMovimientosBancarios    Script Date: 08/nov/00 9:01:16 *****
***** Object:  View dbo.qFormaMovimientosBancarios    Script Date: 30/sep/00 1:10:03 ******/
CREATE VIEW dbo.qFormaMovimientosBancarios
AS
SELECT     Transaccion, CuentaInterna, Tipo, Fecha, Mes, Ano, ProvClte, Beneficiario, Concepto, MontoBase, Comision, Impuestos, Monto, Ingreso, UltMod, 
                      Comprobante, ClaveUnica, ClaveUnicaChequera, FechaEntregado, Cia
FROM         dbo.MovimientosBancarios

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qFormaMovimientosBancariosConsulta    Script Date: 31/12/00 10:25:58 a.m. *****
***** Object:  View dbo.qFormaMovimientosBancariosConsulta    Script Date: 28/11/00 07:01:25 p.m. *****
***** Object:  View dbo.qFormaMovimientosBancariosConsulta    Script Date: 08/nov/00 9:01:18 *****
***** Object:  View dbo.qFormaMovimientosBancariosConsulta    Script Date: 30/sep/00 1:10:03 ******/
CREATE VIEW dbo.qFormaMovimientosBancariosConsulta
AS
SELECT     dbo.Bancos.Nombre AS NombreBanco, dbo.MovimientosBancarios.Transaccion, dbo.MovimientosBancarios.CuentaInterna, 
                      dbo.MovimientosBancarios.Tipo, dbo.CuentasBancarias.CuentaBancaria, dbo.MovimientosBancarios.Fecha, dbo.MovimientosBancarios.Mes, 
                      dbo.MovimientosBancarios.Ano, dbo.MovimientosBancarios.ProvClte, dbo.Proveedores.Nombre AS NombreProveedorCliente, 
                      dbo.MovimientosBancarios.Beneficiario, dbo.MovimientosBancarios.Concepto, dbo.MovimientosBancarios.MontoBase, 
                      dbo.MovimientosBancarios.Comision, dbo.MovimientosBancarios.Impuestos, dbo.MovimientosBancarios.Monto, dbo.MovimientosBancarios.Ingreso, 
                      dbo.MovimientosBancarios.UltMod, dbo.MovimientosBancarios.Comprobante, dbo.MovimientosBancarios.ClaveUnica, 
                      dbo.MovimientosBancarios.ClaveUnicaChequera, dbo.MovimientosBancarios.FechaEntregado, dbo.MovimientosBancarios.Cia
FROM         dbo.Bancos RIGHT OUTER JOIN
                      dbo.CuentasBancarias ON dbo.Bancos.Banco = dbo.CuentasBancarias.Banco RIGHT OUTER JOIN
                      dbo.MovimientosBancarios LEFT OUTER JOIN
                      dbo.Proveedores ON dbo.MovimientosBancarios.ProvClte = dbo.Proveedores.Proveedor ON 
                      dbo.CuentasBancarias.CuentaInterna = dbo.MovimientosBancarios.CuentaInterna

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO






--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.206', GetDate()) 