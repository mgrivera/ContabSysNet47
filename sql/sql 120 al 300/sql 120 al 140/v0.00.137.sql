/*    Jueves 19 de septiembre de 2002   -   v0.00.137.sql 

	Hacemos algunos cambios a la tabla ParametrosNomina, para alterar levemente el 
	cálculo de las préstaciones sociales. 

*/ 


/*    Lunes, 23 de Septiembre de 2002 08:58:14 a.m.    User:     Server: DELLPC    Database: dbContabHeath    Application: MS SQLEM - Data Tools */  

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
CREATE TABLE dbo.Tmp_ParametrosNomina
	(
	LimiteProrrateoVacaciones real NULL,
	AgregarAsientosContables bit NULL,
	OrganizarPartidasDelAsiento bit NULL,
	TipoAsientoDefault nvarchar(6) NULL,
	CuentaContableNomina nvarchar(25) NULL,
	MonedaParaElAsiento int NULL,
	SumarizarPartidaAsientoContable tinyint NULL,
	CalcularPrestacionesFlag bit NULL,
	DiasDeIngresoParaCalcularPrestaciones smallint NULL,
	RubroPrestaciones int NULL,
	PagarPrestacionesCalculadasFlag bit NULL,
	CalcularInteresesPrestacionesFlag bit NULL,
	PagarInteresesCalculadosFlag bit NULL,
	RubroPagarInteresesPrestaciones int NULL,
	RubroRetiroPrestaciones int NULL,
	UsarSalarioPromedioEnPrestacionesFlag bit NULL,
	FormulaCalculoPrestaciones tinyint NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.ParametrosNomina)
	 EXEC('INSERT INTO dbo.Tmp_ParametrosNomina (LimiteProrrateoVacaciones, AgregarAsientosContables, OrganizarPartidasDelAsiento, TipoAsientoDefault, CuentaContableNomina, MonedaParaElAsiento, SumarizarPartidaAsientoContable, CalcularPrestacionesFlag, DiasDeIngresoParaCalcularPrestaciones, RubroPrestaciones, PagarPrestacionesCalculadasFlag, CalcularInteresesPrestacionesFlag, PagarInteresesCalculadosFlag, RubroPagarInteresesPrestaciones, RubroRetiroPrestaciones, Cia)
		SELECT LimiteProrrateoVacaciones, AgregarAsientosContables, OrganizarPartidasDelAsiento, TipoAsientoDefault, CuentaContableNomina, MonedaParaElAsiento, SumarizarPartidaAsientoContable, CalcularPrestacionesFlag, DiasDeIngresoParaCalcularPrestaciones, RubroPrestaciones, PagarPrestacionesCalculadasFlag, CalcularInteresesPrestacionesFlag, PagarInteresesCalculadosFlag, RubroPagarInteresesPrestaciones, RubroRetiroPrestaciones, Cia FROM dbo.ParametrosNomina TABLOCKX')
GO
DROP TABLE dbo.ParametrosNomina
GO
EXECUTE sp_rename N'dbo.Tmp_ParametrosNomina', N'ParametrosNomina', 'OBJECT'
GO
ALTER TABLE dbo.ParametrosNomina ADD CONSTRAINT
	PK_tParametrosNomina PRIMARY KEY NONCLUSTERED 
	(
	Cia
	) ON [PRIMARY]

GO
COMMIT



--  -------------------------------------------------------------------
--  agregamos defaults a los nuevos items, si ahora existe un registro
--  -------------------------------------------------------------------


Update ParametrosNomina Set UsarSalarioPromedioEnPrestacionesFlag = 0,
	FormulaCalculoPrestaciones = 1

--  -------------------------------------------------------------------
--  hacemos los nuevos items not null 
--  -------------------------------------------------------------------

Alter TABLE ParametrosNomina Alter Column UsarSalarioPromedioEnPrestacionesFlag bit NOT NULL	
Alter TABLE ParametrosNomina Alter Column FormulaCalculoPrestaciones tinyint NOT NULL


--  ------------------------
--  qFormaParametrosNomina
--  ------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaParametrosNomina]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaParametrosNomina]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaParametrosNomina
AS
SELECT     LimiteProrrateoVacaciones, AgregarAsientosContables, OrganizarPartidasDelAsiento, TipoAsientoDefault, CuentaContableNomina, 
                      MonedaParaElAsiento, SumarizarPartidaAsientoContable, CalcularPrestacionesFlag, CalcularInteresesPrestacionesFlag, 
                      PagarInteresesCalculadosFlag, RubroPagarInteresesPrestaciones, RubroRetiroPrestaciones, PagarPrestacionesCalculadasFlag, RubroPrestaciones, 
                      DiasDeIngresoParaCalcularPrestaciones, UsarSalarioPromedioEnPrestacionesFlag, FormulaCalculoPrestaciones, Cia
FROM         dbo.ParametrosNomina

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


--  -------------------------------------------------------------------
--  cambios a la tabla UltimaNominaProcesada
--  -------------------------------------------------------------------


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
CREATE TABLE dbo.Tmp_UltimaNominaProcesada
	(
	GrupoNomina int NOT NULL,
	TipoNomina nvarchar(2) NOT NULL,
	FechaUltimaNominaProcesada smalldatetime NOT NULL,
	CalcularPrestacionesFlag bit NOT NULL,
	PrestacionesUsarSalarioPromedioFlag bit NULL,
	PrestacionesLeerNominaDelMesFlag bit NOT NULL,
	PrestacionesDesde smalldatetime NULL,
	PrestacionesHasta smalldatetime NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.UltimaNominaProcesada)
	 EXEC('INSERT INTO dbo.Tmp_UltimaNominaProcesada (GrupoNomina, TipoNomina, FechaUltimaNominaProcesada, CalcularPrestacionesFlag, PrestacionesLeerNominaDelMesFlag, PrestacionesDesde, PrestacionesHasta, Cia)
		SELECT GrupoNomina, TipoNomina, FechaUltimaNominaProcesada, CalcularPrestacionesFlag, PrestacionesLeerNominaDelMesFlag, PrestacionesDesde, PrestacionesHasta, Cia FROM dbo.UltimaNominaProcesada TABLOCKX')
GO
DROP TABLE dbo.UltimaNominaProcesada
GO
EXECUTE sp_rename N'dbo.Tmp_UltimaNominaProcesada', N'UltimaNominaProcesada', 'OBJECT'
GO
ALTER TABLE dbo.UltimaNominaProcesada ADD CONSTRAINT
	PK_UltimaNominaProcesada PRIMARY KEY NONCLUSTERED 
	(
	GrupoNomina,
	Cia
	) ON [PRIMARY]

GO
COMMIT


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaUltimaNominaProcesada]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaUltimaNominaProcesada]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qFormaUltimaNominaProcesada    Script Date: 15-May-01 12:13:57 PM *****
***** Object:  View dbo.qFormaUltimaNominaProcesada    Script Date: 28/11/00 07:01:18 p.m. ******/
CREATE VIEW dbo.qFormaUltimaNominaProcesada
AS
SELECT     GrupoNomina, TipoNomina, FechaUltimaNominaProcesada, CalcularPrestacionesFlag, PrestacionesUsarSalarioPromedioFlag, 
                      PrestacionesLeerNominaDelMesFlag, PrestacionesDesde, PrestacionesHasta, Cia
FROM         dbo.UltimaNominaProcesada

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

--  -------------------------------------------------------------------
--  agregamos el item FechaNacimiento a la tabla Personas 
--  -------------------------------------------------------------------

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
	FechaNacimiento smalldatetime NULL,
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


--  --------------------------------------------
--  views que corresponden a la tabla Personas 
--  --------------------------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaPersonas]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaPersonas]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaPersonasConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaPersonasConsulta]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoSubReportPersonas]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoSubReportPersonas]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaPersonas
AS
SELECT     Persona, Compania, Nombre, Apellido, Cargo, Titulo, FechaNacimiento, Telefono, Fax, Celular, Notas, email, Ingreso, UltAct, Usuario
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
                      dbo.Personas.Titulo, dbo.Personas.FechaNacimiento, dbo.Personas.Telefono, dbo.Personas.Fax, dbo.Personas.Celular, dbo.Personas.email, 
                      dbo.Personas.Notas, dbo.Personas.Ingreso, dbo.Personas.UltAct, dbo.Personas.Compania, dbo.Personas.Usuario
FROM         dbo.Personas INNER JOIN
                      dbo.tCargos ON dbo.Personas.Cargo = dbo.tCargos.Cargo

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoSubReportPersonas
AS
SELECT     dbo.Personas.Titulo + N' ' + dbo.Personas.Nombre + N' ' + dbo.Personas.Apellido AS NombrePersona, dbo.Personas.FechaNacimiento, 
                      dbo.Personas.Compania, dbo.tCargos.Descripcion AS NombreCargo, dbo.Personas.Telefono, dbo.Personas.Fax, dbo.Personas.Celular, 
                      dbo.Personas.email
FROM         dbo.Personas INNER JOIN
                      dbo.tCargos ON dbo.Personas.Cargo = dbo.tCargos.Cargo

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.137', GetDate()) 

