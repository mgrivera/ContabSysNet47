/*    Martes, 11 de Mayo de 2.004   -   v0.00.158.sql 

	Hacemos cambios a las tablas que tienen relación con las Ordenes de pago. 

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
ALTER TABLE dbo.OrdenesPagoFacturas
	DROP CONSTRAINT FK_OrdenesPagoFacturas_Facturas
GO
COMMIT
BEGIN TRANSACTION
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.OrdenesPagoFacturas
	DROP CONSTRAINT FK_OrdenesPagoFacturas_OrdenesPago
GO
ALTER TABLE dbo.OrdenesPago ADD CONSTRAINT
	FK_OrdenesPago_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	)
GO
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.Tmp_OrdenesPagoFacturas
	(
	NumeroOrdenPago int NOT NULL,
	NumeroFactura nvarchar(25) NOT NULL,
	Proveedor int NOT NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.OrdenesPagoFacturas)
	 EXEC('INSERT INTO dbo.Tmp_OrdenesPagoFacturas (NumeroOrdenPago, Cia)
		SELECT NumeroOrdenPago, Cia FROM dbo.OrdenesPagoFacturas TABLOCKX')
GO
DROP TABLE dbo.OrdenesPagoFacturas
GO
EXECUTE sp_rename N'dbo.Tmp_OrdenesPagoFacturas', N'OrdenesPagoFacturas', 'OBJECT'
GO
ALTER TABLE dbo.OrdenesPagoFacturas ADD CONSTRAINT
	PK_OrdenesPagoFacturas PRIMARY KEY CLUSTERED 
	(
	NumeroOrdenPago,
	NumeroFactura,
	Proveedor,
	Cia
	) ON [PRIMARY]

GO
ALTER TABLE dbo.OrdenesPagoFacturas WITH NOCHECK ADD CONSTRAINT
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
	FK_OrdenesPagoFacturas_Facturas1 FOREIGN KEY
	(
	Proveedor,
	NumeroFactura,
	Cia
	) REFERENCES dbo.Facturas
	(
	Proveedor,
	NumeroFactura,
	Cia
	)
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
ALTER TABLE dbo.OrdenesPagoFacturas
	DROP CONSTRAINT FK_OrdenesPagoFacturas_OrdenesPago
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.OrdenesPagoFacturas WITH NOCHECK ADD CONSTRAINT
	FK_OrdenesPagoFacturas_OrdenesPago FOREIGN KEY
	(
	NumeroOrdenPago,
	Cia
	) REFERENCES dbo.OrdenesPago
	(
	Numero,
	Cia
	) ON DELETE CASCADE
	
GO
COMMIT

--  ---------------------------------------------------------------------------
--  agregamos el item AgregarOrdenesPagoFlag a la tabla ParametrosGlobalBancos 
--  ---------------------------------------------------------------------------

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
ALTER TABLE dbo.ParametrosGlobalBancos ADD
	AgregarOrdenesPagoFlag bit NULL
GO
COMMIT


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaParametrosGlobalBancos]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaParametrosGlobalBancos]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaParametrosGlobalBancos
AS
SELECT     ClaveUnica, AgregarAsientosContables, TipoAsientoDefault, IvaPorc, CuentaContableIva, NombreCiudadParaCheque, ActivarPrefacturacionAutomatica, 
                      FormaDePagoDefaultEnFacturas, MoraPorc, ObservacionesRecibosCondominio, NotasRecibosCondominio, DecimalesRecibosCondoFlag, 
                      PrefijoFacturasCondominio, PrefijoFacturasEstacionamiento, FormaDePagoDefaultEnFacturasEstacionamiento, 
                      TipoDefaultEnFacturasEstacionamiento, AplicarIDBFlag, PorcentajeIDB, MovimientosQueGeneranIDB, ContabilizarIDBFlag, 
                      MonedasQueNoGeneranIDB, AgregarOrdenesPagoFlag
FROM         dbo.ParametrosGlobalBancos

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaOrdenesPago]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaOrdenesPago]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaOrdenesPagoConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaOrdenesPagoConsulta]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoOrdenesPago]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoOrdenesPago]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoUnaOrdenPago]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoUnaOrdenPago]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaOrdenesPago
AS
SELECT     Numero, Fecha, Proveedor, Moneda, Monto, Prioridad, IndicadorDetalles, Status, RealizadoPor, RecibidoPor, RecibidoEl, AutorizadoPor, AutorizadoEl, 
                      AnuladaPor, AnuladaEl, Concepto, Observaciones, Ingreso, UltAct, Usuario, Cia
FROM         dbo.OrdenesPago

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaOrdenesPagoConsulta
AS
SELECT     dbo.OrdenesPago.Numero, dbo.OrdenesPago.Fecha, dbo.OrdenesPago.Proveedor, dbo.Proveedores.Nombre AS NombreProveedor, 
                      dbo.OrdenesPago.Moneda, dbo.Monedas.Descripcion AS NombreMoneda, dbo.OrdenesPago.Monto, dbo.OrdenesPago.Prioridad, 
                      CASE Prioridad WHEN 1 THEN 'Baja' WHEN 2 THEN 'Regular' WHEN 3 THEN 'Alta' WHEN 4 THEN 'Urgente' END AS DescripcionPrioridad, 
                      dbo.OrdenesPago.IndicadorDetalles, 
                      CASE IndicadorDetalles WHEN 1 THEN 'Se anexa carta o factura' WHEN 2 THEN 'Gasto  presupuestado' WHEN 3 THEN 'Centro de costo' WHEN 4 THEN
                       'Gasto no presupuestado' WHEN 5 THEN 'Otro' END AS DescripcionDetalles, dbo.OrdenesPago.Status, 
                      CASE Status WHEN 1 THEN 'Pendiente' WHEN 2 THEN 'Parc Pagada' WHEN 3 THEN 'Pagada' WHEN 4 THEN 'Anulada' END AS DescripcionStatus, 
                      dbo.OrdenesPago.RealizadoPor, dbo.OrdenesPago.RecibidoPor, dbo.OrdenesPago.RecibidoEl, dbo.OrdenesPago.AutorizadoPor, 
                      dbo.OrdenesPago.AutorizadoEl, dbo.OrdenesPago.AnuladaPor, dbo.OrdenesPago.AnuladaEl, dbo.OrdenesPago.Concepto, 
                      dbo.OrdenesPago.Observaciones, dbo.OrdenesPago.Ingreso, dbo.OrdenesPago.UltAct, dbo.OrdenesPago.Usuario, dbo.OrdenesPago.Cia
FROM         dbo.OrdenesPago INNER JOIN
                      dbo.Monedas ON dbo.OrdenesPago.Moneda = dbo.Monedas.Moneda INNER JOIN
                      dbo.Proveedores ON dbo.OrdenesPago.Proveedor = dbo.Proveedores.Proveedor

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoOrdenesPago
AS
SELECT     dbo.OrdenesPago.Numero, dbo.OrdenesPago.Fecha, dbo.OrdenesPago.Proveedor, dbo.Proveedores.Nombre AS NombreProveedor, 
                      dbo.OrdenesPago.Moneda, dbo.Monedas.Descripcion AS NombreMoneda, dbo.OrdenesPago.Monto, dbo.OrdenesPago.Prioridad, 
                      CASE Prioridad WHEN 1 THEN 'Baja' WHEN 2 THEN 'Regular' WHEN 3 THEN 'Alta' WHEN 4 THEN 'Urgente' END AS DescripcionPrioridad, 
                      dbo.OrdenesPago.IndicadorDetalles, 
                      CASE IndicadorDetalles WHEN 1 THEN 'Se anexa carta o factura' WHEN 2 THEN 'Gasto  presupuestado' WHEN 3 THEN 'Centro de costo' WHEN 4 THEN
                       'Gasto no presupuestado' WHEN 5 THEN 'Otro' END AS DescripcionDetalles, dbo.OrdenesPago.Status, 
                      CASE Status WHEN 1 THEN 'Pendiente' WHEN 2 THEN 'Parc Pagada' WHEN 3 THEN 'Pagada' WHEN 4 THEN 'Anulada' END AS DescripcionStatus, 
                      dbo.OrdenesPago.RealizadoPor, dbo.OrdenesPago.RecibidoPor, dbo.OrdenesPago.RecibidoEl, dbo.OrdenesPago.AutorizadoPor, 
                      dbo.OrdenesPago.AutorizadoEl, dbo.OrdenesPago.AnuladaPor, dbo.OrdenesPago.AnuladaEl, dbo.OrdenesPago.Concepto, 
                      dbo.OrdenesPago.Observaciones, dbo.OrdenesPago.Cia
FROM         dbo.OrdenesPago INNER JOIN
                      dbo.Monedas ON dbo.OrdenesPago.Moneda = dbo.Monedas.Moneda INNER JOIN
                      dbo.Proveedores ON dbo.OrdenesPago.Proveedor = dbo.Proveedores.Proveedor

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoUnaOrdenPago
AS
SELECT     dbo.OrdenesPago.Numero, dbo.OrdenesPago.Fecha, dbo.OrdenesPago.Proveedor, dbo.Proveedores.Nombre AS NombreProveedor, 
                      dbo.OrdenesPago.Moneda, dbo.Monedas.Descripcion AS NombreMoneda, dbo.Monedas.Simbolo AS SimboloMoneda, dbo.OrdenesPago.Monto, 
                      dbo.OrdenesPago.Prioridad, 
                      CASE Prioridad WHEN 1 THEN 'Baja' WHEN 2 THEN 'Regular' WHEN 3 THEN 'Alta' WHEN 4 THEN 'Urgente' END AS DescripcionPrioridad, 
                      dbo.OrdenesPago.IndicadorDetalles, 
                      CASE IndicadorDetalles WHEN 1 THEN 'Se anexa carta o factura' WHEN 2 THEN 'Gasto  presupuestado' WHEN 3 THEN 'Centro de costo' WHEN 4 THEN
                       'Gasto no presupuestado' WHEN 5 THEN 'Otro' END AS DescripcionDetalles, dbo.OrdenesPago.Status, 
                      CASE Status WHEN 1 THEN 'Pendiente' WHEN 2 THEN 'Parc Pagada' WHEN 3 THEN 'Pagada' WHEN 4 THEN 'Anulada' END AS DescripcionStatus, 
                      dbo.OrdenesPago.RealizadoPor, dbo.OrdenesPago.RecibidoPor, dbo.OrdenesPago.RecibidoEl, dbo.OrdenesPago.AutorizadoPor, 
                      dbo.OrdenesPago.AutorizadoEl, dbo.OrdenesPago.AnuladaPor, dbo.OrdenesPago.AnuladaEl, dbo.OrdenesPago.Concepto, 
                      dbo.OrdenesPago.Observaciones, dbo.OrdenesPago.Cia
FROM         dbo.OrdenesPago INNER JOIN
                      dbo.Monedas ON dbo.OrdenesPago.Moneda = dbo.Monedas.Moneda INNER JOIN
                      dbo.Proveedores ON dbo.OrdenesPago.Proveedor = dbo.Proveedores.Proveedor

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO





--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.158', GetDate()) 

