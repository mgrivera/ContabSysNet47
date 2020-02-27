/*    Lunes 07 de octubre de 2002   -   v0.00.140.sql 

	Agregamos la tabla de atributos de personas y agregamos este item a la tabla 
	Personas. 

*/ 


--  -------------------------------------------------------------------------
--  creamos las tablas Atributos y AtributosId. Además, los views asociados 
--  -------------------------------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaAtributos]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaAtributos]
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Personas_Atributos]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Personas] DROP CONSTRAINT FK_Personas_Atributos
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Atributos]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Atributos]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AtributosId]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AtributosId]
GO

CREATE TABLE [dbo].[Atributos] (
	[Atributo] [int] NOT NULL ,
	[Descripcion] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[AtributosId] (
	[Numero] [int] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Atributos] WITH NOCHECK ADD 
	CONSTRAINT [PK_Atributos] PRIMARY KEY  CLUSTERED 
	(
		[Atributo]
	)  ON [PRIMARY] 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaAtributos
AS
SELECT     Atributo, Descripcion
FROM         dbo.Atributos

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

--  -----------------------------------------------
--  agregamos el item Atributo a la tabla Personas 
--  -----------------------------------------------

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
	DROP CONSTRAINT FK_Personas_Proveedores
GO
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
	Atributo int NULL,
	Notas nvarchar(250) NULL,
	Ingreso smalldatetime NOT NULL,
	UltAct smalldatetime NOT NULL,
	Usuario nvarchar(25) NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.Personas)
	 EXEC('INSERT INTO dbo.Tmp_Personas (Persona, Compania, Nombre, Apellido, Cargo, Titulo, DiaCumpleAnos, MesCumpleAnos, Telefono, Fax, Celular, email, Notas, Ingreso, UltAct, Usuario)
		SELECT Persona, Compania, Nombre, Apellido, Cargo, Titulo, DiaCumpleAnos, MesCumpleAnos, Telefono, Fax, Celular, email, Notas, Ingreso, UltAct, Usuario FROM dbo.Personas TABLOCKX')
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
	FK_Personas_Atributos FOREIGN KEY
	(
	Atributo
	) REFERENCES dbo.Atributos
	(
	Atributo
	)
GO
COMMIT


--  ------------------------
--  actualizamos los views asociados
--  ------------------------


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
SELECT     Persona, Compania, Nombre, Apellido, Cargo, Titulo, Telefono, Fax, Celular, email, Atributo, Notas, DiaCumpleAnos, MesCumpleAnos, Ingreso, UltAct, 
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
                      dbo.Personas.MesCumpleAnos, dbo.Personas.Atributo, dbo.Atributos.Descripcion AS NombreAtributo, dbo.Personas.Notas, dbo.Personas.Ingreso, 
                      dbo.Personas.UltAct, dbo.Personas.Compania, dbo.Personas.Usuario
FROM         dbo.Personas INNER JOIN
                      dbo.tCargos ON dbo.Personas.Cargo = dbo.tCargos.Cargo INNER JOIN
                      dbo.Atributos ON dbo.Personas.Atributo = dbo.Atributos.Atributo

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
SELECT     dbo.Personas.Titulo + N' ' + dbo.Personas.Nombre + N' ' + dbo.Personas.Apellido AS NombrePersona, dbo.Personas.Compania, 
                      dbo.tCargos.Descripcion AS NombreCargo, dbo.Personas.Telefono, dbo.Personas.Fax, dbo.Personas.Celular, dbo.Personas.email, 
                      dbo.Personas.Atributo, dbo.Atributos.Descripcion AS NombreAtributo
FROM         dbo.Personas INNER JOIN
                      dbo.tCargos ON dbo.Personas.Cargo = dbo.tCargos.Cargo INNER JOIN
                      dbo.Atributos ON dbo.Personas.Atributo = dbo.Atributos.Atributo

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
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

CREATE VIEW dbo.qFormaPersonasConsulta
AS
SELECT     dbo.Personas.Persona, dbo.Personas.Nombre, dbo.Personas.Apellido, dbo.Personas.Cargo, dbo.tCargos.Descripcion AS NombreCargo, 
                      dbo.Personas.Titulo, dbo.Personas.Telefono, dbo.Personas.Fax, dbo.Personas.Celular, dbo.Personas.email, dbo.Personas.DiaCumpleAnos, 
                      dbo.Personas.MesCumpleAnos, dbo.Personas.Atributo, dbo.Atributos.Descripcion AS NombreAtributo, dbo.Personas.Notas, dbo.Personas.Ingreso, 
                      dbo.Personas.UltAct, dbo.Personas.Compania, dbo.Personas.Usuario
FROM         dbo.Personas INNER JOIN
                      dbo.tCargos ON dbo.Personas.Cargo = dbo.tCargos.Cargo LEFT OUTER JOIN
                      dbo.Atributos ON dbo.Personas.Atributo = dbo.Atributos.Atributo

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
SELECT     dbo.Personas.Titulo + N' ' + dbo.Personas.Nombre + N' ' + dbo.Personas.Apellido AS NombrePersona, dbo.Personas.Compania, 
                      dbo.tCargos.Descripcion AS NombreCargo, dbo.Personas.Telefono, dbo.Personas.Fax, dbo.Personas.Celular, dbo.Personas.email, 
                      dbo.Personas.Atributo, dbo.Atributos.Descripcion AS NombreAtributo
FROM         dbo.Personas INNER JOIN
                      dbo.tCargos ON dbo.Personas.Cargo = dbo.tCargos.Cargo LEFT OUTER JOIN
                      dbo.Atributos ON dbo.Personas.Atributo = dbo.Atributos.Atributo

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


--  -------------------------------
--  qFormaRubrosAsignadosConsulta
--  -------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaRubrosAsignadosConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaRubrosAsignadosConsulta]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaRubrosAsignadosConsulta
AS
SELECT     dbo.tRubrosAsignados.RubroAsignado, dbo.tRubrosAsignados.TodaLaCia, dbo.tRubrosAsignados.Empleado, 
                      dbo.tEmpleados.Nombre AS NombreEmpleado, dbo.tRubrosAsignados.GrupoEmpleados, 
                      dbo.tGruposEmpleados.NombreGrupo AS NombreGrupoEmpleados, dbo.tRubrosAsignados.GrupoNomina, 
                      tGruposEmpleados_1.NombreGrupo AS NombreGrupoNomina, dbo.tRubrosAsignados.SuspendidoFlag, dbo.tRubrosAsignados.Rubro, 
                      dbo.tMaestraRubros.NombreCortoRubro, dbo.tRubrosAsignados.Descripcion, dbo.tRubrosAsignados.Tipo, dbo.tRubrosAsignados.Periodicidad, 
                      dbo.tRubrosAsignados.Desde, dbo.tRubrosAsignados.Hasta, dbo.tRubrosAsignados.Siempre, dbo.tRubrosAsignados.MontoAAplicar, 
                      dbo.tRubrosAsignados.RubroAAplicar, tMaestraRubros_1.NombreCortoRubro AS NombreCortoRubroAAplicar, dbo.tRubrosAsignados.GrupoAAplicar, 
                      dbo.tGruposRubros.NombreGrupo AS NombreGrupoRubrosAAplicar, dbo.tRubrosAsignados.DeLaNomina, dbo.tRubrosAsignados.DeLaNominaDesde, 
                      dbo.tRubrosAsignados.DeLaNominaHasta, dbo.tRubrosAsignados.VariableAAplicar, dbo.tRubrosAsignados.Factor1, dbo.tRubrosAsignados.Factor2, 
                      dbo.tRubrosAsignados.Porcentaje, dbo.tRubrosAsignados.Tope, dbo.tRubrosAsignados.LunesDelMes, dbo.tRubrosAsignados.Divisor1, 
                      dbo.tRubrosAsignados.Divisor2, dbo.tRubrosAsignados.PorcentajeMas, dbo.tRubrosAsignados.PorcentajeMas2, 
                      dbo.tRubrosAsignados.MostrarEnElReciboFlag, dbo.tRubrosAsignados.Cia
FROM         dbo.tRubrosAsignados LEFT OUTER JOIN
                      dbo.tEmpleados ON dbo.tRubrosAsignados.Empleado = dbo.tEmpleados.Empleado AND 
                      dbo.tRubrosAsignados.Cia = dbo.tEmpleados.Cia LEFT OUTER JOIN
                      dbo.tGruposEmpleados ON dbo.tRubrosAsignados.GrupoEmpleados = dbo.tGruposEmpleados.Grupo AND 
                      dbo.tRubrosAsignados.Cia = dbo.tGruposEmpleados.Cia INNER JOIN
                      dbo.tMaestraRubros ON dbo.tRubrosAsignados.Rubro = dbo.tMaestraRubros.Rubro LEFT OUTER JOIN
                      dbo.tGruposEmpleados tGruposEmpleados_1 ON dbo.tRubrosAsignados.GrupoNomina = tGruposEmpleados_1.Grupo AND 
                      dbo.tRubrosAsignados.Cia = tGruposEmpleados_1.Cia LEFT OUTER JOIN
                      dbo.tMaestraRubros tMaestraRubros_1 ON dbo.tRubrosAsignados.RubroAAplicar = tMaestraRubros_1.Rubro LEFT OUTER JOIN
                      dbo.tGruposRubros ON dbo.tRubrosAsignados.GrupoAAplicar = dbo.tGruposRubros.Grupo

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


--  -------------------------------
--  qFormaConsultaNomina
--  -------------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaConsultaNomina]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaConsultaNomina]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaConsultaNomina
AS
SELECT     TOP 100 PERCENT dbo.tNomina.GrupoNomina, dbo.tGruposEmpleados.NombreGrupo AS NombreGrupoNomina, dbo.tNomina.Empleado, 
                      dbo.tEmpleados.Nombre AS NombreEmpleado, dbo.tNomina.FechaNomina, dbo.tNomina.Rubro, dbo.tMaestraRubros.NombreCortoRubro, 
                      dbo.tNomina.Tipo, dbo.tNomina.Descripcion, dbo.tMaestraRubros.NombreCortoRubro + ' - ' + dbo.tNomina.Descripcion AS NombreYDescripcion, 
                      dbo.tNomina.Monto, dbo.tNomina.FechaEjecucion, dbo.tNomina.TipoNomina, dbo.tNomina.AplicaPrestacionesFlag, dbo.tNomina.Cia, 
                      dbo.tNomina.MostrarEnElReciboFlag, dbo.tNomina.CantDiasBase, dbo.tNomina.CantDias, dbo.tNomina.VacFraccionFlag
FROM         dbo.tNomina INNER JOIN
                      dbo.tGruposEmpleados ON dbo.tNomina.GrupoNomina = dbo.tGruposEmpleados.Grupo AND 
                      dbo.tNomina.Cia = dbo.tGruposEmpleados.Cia LEFT OUTER JOIN
                      dbo.tMaestraRubros ON dbo.tNomina.Rubro = dbo.tMaestraRubros.Rubro LEFT OUTER JOIN
                      dbo.tEmpleados ON dbo.tNomina.Empleado = dbo.tEmpleados.Empleado
ORDER BY dbo.tEmpleados.Nombre

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.140', GetDate()) 

