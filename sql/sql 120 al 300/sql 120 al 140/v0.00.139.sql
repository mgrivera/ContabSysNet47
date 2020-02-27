/*    Jueves 26 de septiembre de 2002   -   v0.00.139.sql 

	Hacemos cambios leves a las tablas Personas y Proveedores. 

*/ 


--  ----------------------------------------------------------------------------------------
--  Personas: agregamos los items DiaCumpleanos y MesCumpleanos. Ademas, eliminamos el item 
--  FechaNacimiento 
--  ----------------------------------------------------------------------------------------

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
ALTER TABLE dbo.Personas
	DROP CONSTRAINT FK_Personas_Titulos
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.Personas
	DROP CONSTRAINT FK_Personas_tCargos
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.Personas
	DROP CONSTRAINT FK_Personas_Proveedores
GO
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.Tmp_Personas
	(
	Persona int NOT NULL,
	Compania int NOT NULL,
	Nombre nvarchar(50) NOT NULL,
	Apellido nvarchar(50) NOT NULL,
	Cargo int NOT NULL,
	Titulo nvarchar(10) NOT NULL,
	DiaCumpleAnos tinyint NULL,
	MesCumpleAnos smallint NULL,
	Telefono nvarchar(25) NULL,
	Fax nvarchar(25) NULL,
	Celular nvarchar(25) NULL,
	email nvarchar(50) NULL,
	Notas nvarchar(250) NULL,
	Ingreso smalldatetime NOT NULL,
	UltAct smalldatetime NOT NULL,
	Usuario nvarchar(25) NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.Personas)
	 EXEC('INSERT INTO dbo.Tmp_Personas (Persona, Compania, Nombre, Apellido, Cargo, Titulo, Telefono, Fax, Celular, email, Notas, Ingreso, UltAct, Usuario)
		SELECT Persona, Compania, Nombre, Apellido, Cargo, Titulo, Telefono, Fax, Celular, email, Notas, Ingreso, UltAct, Usuario FROM dbo.Personas TABLOCKX')
GO
DROP TABLE dbo.Personas
GO
EXECUTE sp_rename N'dbo.Tmp_Personas', N'Personas', 'OBJECT'
GO
ALTER TABLE dbo.Personas ADD CONSTRAINT
	PK_Personas PRIMARY KEY CLUSTERED 
	(
	Persona
	) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_Personas ON dbo.Personas
	(
	Compania
	) ON [PRIMARY]
GO
ALTER TABLE dbo.Personas WITH NOCHECK ADD CONSTRAINT
	FK_Personas_Proveedores FOREIGN KEY
	(
	Compania
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	)
GO
ALTER TABLE dbo.Personas WITH NOCHECK ADD CONSTRAINT
	FK_Personas_tCargos FOREIGN KEY
	(
	Cargo
	) REFERENCES dbo.tCargos
	(
	Cargo
	)
GO
ALTER TABLE dbo.Personas WITH NOCHECK ADD CONSTRAINT
	FK_Personas_Titulos FOREIGN KEY
	(
	Titulo
	) REFERENCES dbo.Titulos
	(
	Titulo
	)
GO
COMMIT

--  ----------------------------------------------------------------------------------------
--  Proveedores: agregamos el item DirectorioCompaniaFlag 
--  ----------------------------------------------------------------------------------------




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
ALTER TABLE dbo.Proveedores
	DROP CONSTRAINT FK_Proveedores_TiposProveedor
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.Proveedores
	DROP CONSTRAINT FK_Proveedores_tCiudades
GO
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.Tmp_Proveedores
	(
	Proveedor int NOT NULL,
	Nombre nvarchar(50) NOT NULL,
	Tipo int NOT NULL,
	Rif nvarchar(20) NULL,
	NatJurFlag tinyint NOT NULL,
	Nit nvarchar(20) NULL,
	Beneficiario nvarchar(50) NULL,
	Concepto nvarchar(250) NULL,
	MontoCheque money NULL,
	Direccion nvarchar(255) NULL,
	Ciudad nvarchar(6) NULL,
	Telefono1 nvarchar(14) NULL,
	Telefono2 nvarchar(14) NULL,
	Fax nvarchar(14) NULL,
	Contacto1 nvarchar(50) NULL,
	Contacto2 nvarchar(50) NULL,
	NacionalExtranjeroFlag smallint NULL,
	SujetoARetencionFlag bit NULL,
	MonedaDefault int NULL,
	FormaDePagoDefault int NULL,
	ProveedorClienteFlag smallint NULL,
	PorcentajeDeRetencion real NULL,
	AplicaIvaFlag bit NULL,
	CategoriaProveedor smallint NULL,
	MontoChequeEnMonExtFlag bit NULL,
	DirectorioCompaniaFlag bit NULL,
	Ingreso datetime NOT NULL,
	UltAct datetime NOT NULL,
	Usuario nvarchar(25) NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.Proveedores)
	 EXEC('INSERT INTO dbo.Tmp_Proveedores (Proveedor, Nombre, Tipo, Rif, NatJurFlag, Nit, Beneficiario, Concepto, MontoCheque, Direccion, Ciudad, Telefono1, Telefono2, Fax, Contacto1, Contacto2, NacionalExtranjeroFlag, SujetoARetencionFlag, MonedaDefault, FormaDePagoDefault, ProveedorClienteFlag, PorcentajeDeRetencion, AplicaIvaFlag, CategoriaProveedor, MontoChequeEnMonExtFlag, Ingreso, UltAct, Usuario)
		SELECT Proveedor, Nombre, Tipo, Rif, NatJurFlag, Nit, Beneficiario, Concepto, MontoCheque, Direccion, Ciudad, Telefono1, Telefono2, Fax, Contacto1, Contacto2, NacionalExtranjeroFlag, SujetoARetencionFlag, MonedaDefault, FormaDePagoDefault, ProveedorClienteFlag, PorcentajeDeRetencion, AplicaIvaFlag, CategoriaProveedor, MontoChequeEnMonExtFlag, Ingreso, UltAct, Usuario FROM dbo.Proveedores TABLOCKX')
GO
ALTER TABLE dbo.SaldosCompanias
	DROP CONSTRAINT FK_SaldosCompanias_Proveedores
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Proveedores
GO
ALTER TABLE dbo.Facturas
	DROP CONSTRAINT FK_Facturas_Proveedores
GO
ALTER TABLE dbo.Personas
	DROP CONSTRAINT FK_Personas_Proveedores
GO
ALTER TABLE dbo.Pagos
	DROP CONSTRAINT FK_Pagos_Proveedores
GO
DROP TABLE dbo.Proveedores
GO
EXECUTE sp_rename N'dbo.Tmp_Proveedores', N'Proveedores', 'OBJECT'
GO
ALTER TABLE dbo.Proveedores ADD CONSTRAINT
	PK_Proveedores PRIMARY KEY NONCLUSTERED 
	(
	Proveedor
	) ON [PRIMARY]

GO
ALTER TABLE dbo.Proveedores WITH NOCHECK ADD CONSTRAINT
	FK_Proveedores_tCiudades FOREIGN KEY
	(
	Ciudad
	) REFERENCES dbo.tCiudades
	(
	Ciudad
	)
GO
ALTER TABLE dbo.Proveedores WITH NOCHECK ADD CONSTRAINT
	FK_Proveedores_TiposProveedor FOREIGN KEY
	(
	Tipo
	) REFERENCES dbo.TiposProveedor
	(
	Tipo
	)
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.Pagos WITH NOCHECK ADD CONSTRAINT
	FK_Pagos_Proveedores FOREIGN KEY
	(
	Proveedor
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	)
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.Personas WITH NOCHECK ADD CONSTRAINT
	FK_Personas_Proveedores FOREIGN KEY
	(
	Compania
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	)
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.Facturas WITH NOCHECK ADD CONSTRAINT
	FK_Facturas_Proveedores FOREIGN KEY
	(
	Proveedor
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	)
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.MovimientosBancarios WITH NOCHECK ADD CONSTRAINT
	FK_MovimientosBancarios_Proveedores FOREIGN KEY
	(
	ProvClte
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	)
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.SaldosCompanias WITH NOCHECK ADD CONSTRAINT
	FK_SaldosCompanias_Proveedores FOREIGN KEY
	(
	Compania
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	)
GO
COMMIT

Update Proveedores Set DirectorioCompaniaFlag = 0 

Alter Table Proveedores Alter Column DirectorioCompaniaFlag bit Not NULL


--  ------------------------
--  views relacionados 
--  ------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaPersonas]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaPersonas]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaPersonasConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaPersonasConsulta]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaProveedores]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaProveedores]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaProveedoresConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaProveedoresConsulta]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoProveedores]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoProveedores]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaProveedores
AS
SELECT     Proveedor, Nombre, Tipo, Rif, NatJurFlag, Nit, Beneficiario, Concepto, MontoCheque, Direccion, Ciudad, Telefono1, Telefono2, Fax, Contacto1, 
                      Contacto2, NacionalExtranjeroFlag, SujetoARetencionFlag, MonedaDefault, FormaDePagoDefault, ProveedorClienteFlag, PorcentajeDeRetencion, 
                      AplicaIvaFlag, CategoriaProveedor, MontoChequeEnMonExtFlag, DirectorioCompaniaFlag, Ingreso, UltAct, Usuario
FROM         dbo.Proveedores

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaProveedoresConsulta
AS
SELECT     dbo.Proveedores.Proveedor, dbo.Proveedores.Nombre, dbo.Proveedores.Tipo, dbo.TiposProveedor.Descripcion AS NombreTipoProveedor, 
                      dbo.Proveedores.Rif, dbo.Proveedores.NatJurFlag, dbo.Proveedores.Nit, dbo.Proveedores.Beneficiario, dbo.Proveedores.Concepto, 
                      dbo.Proveedores.MontoCheque, dbo.Proveedores.Direccion, dbo.Proveedores.Ciudad, dbo.tCiudades.Descripcion AS NombreCiudad, 
                      dbo.Proveedores.Telefono1, dbo.Proveedores.Telefono2, dbo.Proveedores.Fax, dbo.Proveedores.Contacto1, dbo.Proveedores.Contacto2, 
                      dbo.Proveedores.NacionalExtranjeroFlag, dbo.Proveedores.SujetoARetencionFlag, dbo.Proveedores.MonedaDefault, 
                      dbo.Monedas.Simbolo AS SimboloMoneda, dbo.Proveedores.FormaDePagoDefault, dbo.FormasDePago.Descripcion AS NombreFormaDePago, 
                      dbo.Proveedores.ProveedorClienteFlag, dbo.Proveedores.PorcentajeDeRetencion, dbo.Proveedores.AplicaIvaFlag, 
                      dbo.Proveedores.CategoriaProveedor, dbo.Proveedores.MontoChequeEnMonExtFlag, dbo.Proveedores.DirectorioCompaniaFlag, 
                      dbo.Proveedores.Ingreso, dbo.Proveedores.UltAct, dbo.Proveedores.Usuario, 
                      dbo.CategoriasRetencion.Descripcion AS NombreCategoriaRetencion
FROM         dbo.Proveedores LEFT OUTER JOIN
                      dbo.CategoriasRetencion ON dbo.Proveedores.CategoriaProveedor = dbo.CategoriasRetencion.Categoria LEFT OUTER JOIN
                      dbo.FormasDePago ON dbo.Proveedores.FormaDePagoDefault = dbo.FormasDePago.FormaDePago LEFT OUTER JOIN
                      dbo.tCiudades ON dbo.Proveedores.Ciudad = dbo.tCiudades.Ciudad LEFT OUTER JOIN
                      dbo.Monedas ON dbo.Proveedores.MonedaDefault = dbo.Monedas.Moneda LEFT OUTER JOIN
                      dbo.TiposProveedor ON dbo.Proveedores.Tipo = dbo.TiposProveedor.Tipo

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qListadoProveedores    Script Date: 28/11/00 07:01:24 p.m. *****
***** Object:  View dbo.qListadoProveedores    Script Date: 08/nov/00 9:01:18 ******/
CREATE VIEW dbo.qListadoProveedores
AS
SELECT     dbo.tCiudades.Descripcion AS NombreCiudad, dbo.Proveedores.Proveedor, dbo.Proveedores.Nombre, 
                      dbo.TiposProveedor.Descripcion AS NombreTipoProveedor, dbo.Proveedores.Tipo, dbo.Proveedores.Rif, 
                      dbo.Proveedores.NatJurFlag AS NaturalJuridico, dbo.Proveedores.Nit, dbo.Proveedores.Direccion, dbo.Proveedores.Ciudad, 
                      dbo.Proveedores.Telefono1, dbo.Proveedores.Telefono2, dbo.Proveedores.Fax, dbo.Proveedores.Contacto1, dbo.Proveedores.CategoriaProveedor, 
                      dbo.Proveedores.NacionalExtranjeroFlag, dbo.Proveedores.SujetoARetencionFlag, dbo.Proveedores.ProveedorClienteFlag, 
                      dbo.Proveedores.AplicaIvaFlag, dbo.Proveedores.DirectorioCompaniaFlag
FROM         dbo.Proveedores LEFT OUTER JOIN
                      dbo.TiposProveedor ON dbo.Proveedores.Tipo = dbo.TiposProveedor.Tipo LEFT OUTER JOIN
                      dbo.tCiudades ON dbo.Proveedores.Ciudad = dbo.tCiudades.Ciudad

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaPersonas
AS
SELECT     Persona, Compania, Nombre, Apellido, Cargo, Titulo, Telefono, Fax, Celular, Notas, email, DiaCumpleAnos, MesCumpleAnos, Ingreso, UltAct, 
                      Usuario
FROM         dbo.Personas

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaPersonasConsulta
AS
SELECT     dbo.Personas.Persona, dbo.Personas.Nombre, dbo.Personas.Apellido, dbo.Personas.Cargo, dbo.tCargos.Descripcion AS NombreCargo, 
                      dbo.Personas.Titulo, dbo.Personas.Telefono, dbo.Personas.Fax, dbo.Personas.Celular, dbo.Personas.email, dbo.Personas.DiaCumpleAnos, 
                      dbo.Personas.MesCumpleAnos, dbo.Personas.Notas, dbo.Personas.Ingreso, dbo.Personas.UltAct, dbo.Personas.Compania, 
                      dbo.Personas.Usuario
FROM         dbo.Personas INNER JOIN
                      dbo.tCargos ON dbo.Personas.Cargo = dbo.tCargos.Cargo

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoSubReportPersonas]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoSubReportPersonas]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoSubReportPersonas
AS
SELECT     dbo.Personas.Titulo + N' ' + dbo.Personas.Nombre + N' ' + dbo.Personas.Apellido AS NombrePersona, dbo.Personas.Compania, 
                      dbo.tCargos.Descripcion AS NombreCargo, dbo.Personas.Telefono, dbo.Personas.Fax, dbo.Personas.Celular, dbo.Personas.email
FROM         dbo.Personas INNER JOIN
                      dbo.tCargos ON dbo.Personas.Cargo = dbo.tCargos.Cargo

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


--  ------------------------
--  qListadoAsientos
--  ------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoAsientos]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoAsientos]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoAsientos
AS
SELECT     dbo.dAsientos.Partida, dbo.dAsientos.Cuenta, dbo.dAsientos.Descripcion AS DescripcionPartida, dbo.dAsientos.Referencia, dbo.dAsientos.Debe, 
                      dbo.dAsientos.Haber, dbo.dAsientos.NumeroAutomatico, dbo.dAsientos.Numero, dbo.dAsientos.Mes, dbo.dAsientos.Ano, dbo.dAsientos.Fecha, 
                      dbo.dAsientos.Moneda, dbo.dAsientos.MonedaOriginal, dbo.dAsientos.ConvertirFlag, dbo.dAsientos.FactorDeCambio, dbo.dAsientos.MesFiscal, 
                      dbo.dAsientos.AnoFiscal, dbo.dAsientos.Cia, dbo.Asientos.Tipo, dbo.Asientos.TotalDebe, dbo.Asientos.TotalHaber, dbo.Asientos.Descripcion, 
                      dbo.Asientos.Ingreso, dbo.Asientos.UltAct, dbo.Asientos.CopiableFlag, dbo.Asientos.ProvieneDe
FROM         dbo.dAsientos INNER JOIN
                      dbo.Asientos ON dbo.dAsientos.NumeroAutomatico = dbo.Asientos.NumeroAutomatico

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.139', GetDate()) 

