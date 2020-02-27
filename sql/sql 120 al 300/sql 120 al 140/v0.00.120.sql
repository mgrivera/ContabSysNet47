/*    Jueves, 18 de Abril de 2002   -   v0.00.120.sql 

	Agregamos el item MonedasQueNoGeneranIDB a la tabla ParametrosGlobalBancos. 

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
CREATE TABLE dbo.Tmp_ParametrosGlobalBancos
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	AgregarAsientosContables bit NULL,
	TipoAsientoDefault nvarchar(6) NULL,
	IvaPorc real NULL,
	CuentaContableIva nvarchar(25) NULL,
	NombreCiudadParaCheque nvarchar(25) NULL,
	ActivarPrefacturacionAutomatica bit NULL,
	FormaDePagoDefaultEnFacturas int NULL,
	MoraPorc real NULL,
	ObservacionesRecibosCondominio nvarchar(1900) NULL,
	NotasRecibosCondominio nvarchar(1900) NULL,
	DecimalesRecibosCondoFlag tinyint NULL,
	PrefijoFacturasCondominio nvarchar(10) NULL,
	PrefijoFacturasEstacionamiento nvarchar(10) NULL,
	FormaDePagoDefaultEnFacturasEstacionamiento int NULL,
	TipoDefaultEnFacturasEstacionamiento int NULL,
	AplicarIDBFlag bit NULL,
	PorcentajeIDB decimal(5, 3) NULL,
	MovimientosQueGeneranIDB nvarchar(50) NULL,
	MonedasQueNoGeneranIDB nvarchar(20) NULL,
	ContabilizarIDBFlag bit NULL
	)  ON [PRIMARY]
GO
SET IDENTITY_INSERT dbo.Tmp_ParametrosGlobalBancos ON
GO
IF EXISTS(SELECT * FROM dbo.ParametrosGlobalBancos)
	 EXEC('INSERT INTO dbo.Tmp_ParametrosGlobalBancos (ClaveUnica, AgregarAsientosContables, TipoAsientoDefault, IvaPorc, CuentaContableIva, NombreCiudadParaCheque, ActivarPrefacturacionAutomatica, FormaDePagoDefaultEnFacturas, MoraPorc, ObservacionesRecibosCondominio, NotasRecibosCondominio, DecimalesRecibosCondoFlag, PrefijoFacturasCondominio, PrefijoFacturasEstacionamiento, FormaDePagoDefaultEnFacturasEstacionamiento, TipoDefaultEnFacturasEstacionamiento, AplicarIDBFlag, PorcentajeIDB, MovimientosQueGeneranIDB, ContabilizarIDBFlag)
		SELECT ClaveUnica, AgregarAsientosContables, TipoAsientoDefault, IvaPorc, CuentaContableIva, NombreCiudadParaCheque, ActivarPrefacturacionAutomatica, FormaDePagoDefaultEnFacturas, MoraPorc, ObservacionesRecibosCondominio, NotasRecibosCondominio, DecimalesRecibosCondoFlag, PrefijoFacturasCondominio, PrefijoFacturasEstacionamiento, FormaDePagoDefaultEnFacturasEstacionamiento, TipoDefaultEnFacturasEstacionamiento, AplicarIDBFlag, PorcentajeIDB, MovimientosQueGeneranIDB, ContabilizarIDBFlag FROM dbo.ParametrosGlobalBancos TABLOCKX')
GO
SET IDENTITY_INSERT dbo.Tmp_ParametrosGlobalBancos OFF
GO
DROP TABLE dbo.ParametrosGlobalBancos
GO
EXECUTE sp_rename N'dbo.Tmp_ParametrosGlobalBancos', N'ParametrosGlobalBancos', 'OBJECT'
GO
ALTER TABLE dbo.ParametrosGlobalBancos ADD CONSTRAINT
	PK_tParametrosGlobal PRIMARY KEY NONCLUSTERED 
	(
	ClaveUnica
	) ON [PRIMARY]

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
                      MonedasQueNoGeneranIDB
FROM         dbo.ParametrosGlobalBancos

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.120', GetDate()) 
