/*    Martes, 20 de Agosto de 2002   -   v0.00.131.sql 

	Cambiamos la tabla de grupos de empleados para agregar el item GrupoNominaFlag. 

*/ 



--  ------------------------
--  tGruposEmpleados
--  ------------------------

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
CREATE TABLE dbo.Tmp_tGruposEmpleados
	(
	Grupo int NOT NULL,
	NombreGrupo nvarchar(10) NOT NULL,
	Descripcion ntext NOT NULL,
	GrupoNominaFlag bit NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.tGruposEmpleados)
	 EXEC('INSERT INTO dbo.Tmp_tGruposEmpleados (Grupo, NombreGrupo, Descripcion, Cia)
		SELECT Grupo, NombreGrupo, Descripcion, Cia FROM dbo.tGruposEmpleados TABLOCKX')
GO
DROP TABLE dbo.tGruposEmpleados
GO
EXECUTE sp_rename N'dbo.Tmp_tGruposEmpleados', N'tGruposEmpleados', 'OBJECT'
GO
ALTER TABLE dbo.tGruposEmpleados ADD CONSTRAINT
	PK_tGruposEmpleados PRIMARY KEY NONCLUSTERED 
	(
	Grupo
	) ON [PRIMARY]

GO
COMMIT


--  ------------------------
--  tdGruposEmpleados
--  ------------------------


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
CREATE TABLE dbo.Tmp_tdGruposEmpleados
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	Grupo int NOT NULL,
	Empleado int NOT NULL,
	SuspendidoFlag bit NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
SET IDENTITY_INSERT dbo.Tmp_tdGruposEmpleados ON
GO
IF EXISTS(SELECT * FROM dbo.tdGruposEmpleados)
	 EXEC('INSERT INTO dbo.Tmp_tdGruposEmpleados (ClaveUnica, Grupo, Empleado, Cia)
		SELECT ClaveUnica, Grupo, Empleado, Cia FROM dbo.tdGruposEmpleados TABLOCKX')
GO
SET IDENTITY_INSERT dbo.Tmp_tdGruposEmpleados OFF
GO
DROP TABLE dbo.tdGruposEmpleados
GO
EXECUTE sp_rename N'dbo.Tmp_tdGruposEmpleados', N'tdGruposEmpleados', 'OBJECT'
GO
ALTER TABLE dbo.tdGruposEmpleados ADD CONSTRAINT
	PK_tdGruposEmpleados PRIMARY KEY NONCLUSTERED 
	(
	ClaveUnica
	) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_tdGruposEmpleados ON dbo.tdGruposEmpleados
	(
	Cia
	) ON [PRIMARY]
GO
COMMIT

--  ----------------------------------------------------
--  cambiamos los nuevos items para que sean not null 
--  ----------------------------------------------------

Update tGruposEmpleados Set GrupoNominaFlag = 0 
Update tdGruposEmpleados Set SuspendidoFlag = 0 

Alter Table tGruposEmpleados Alter Column GrupoNominaFlag bit not null 
Alter Table tdGruposEmpleados Alter Column SuspendidoFlag bit not null 



--  -----------------------------------------------------------
--  actualizamos los views que corresponden a las dos tablas 
--  -----------------------------------------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaGruposEmpleados]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaGruposEmpleados]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaGruposEmpleadosSubForm]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaGruposEmpleadosSubForm]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaGruposEmpleados
AS
SELECT     Grupo, NombreGrupo, Descripcion, GrupoNominaFlag, Cia
FROM         dbo.tGruposEmpleados

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qFormaGruposEmpleadosSubForm    Script Date: 15-May-01 12:13:56 PM *****
***** Object:  View dbo.qFormaGruposEmpleadosSubForm    Script Date: 28/11/00 07:01:15 p.m. ******/
CREATE VIEW dbo.qFormaGruposEmpleadosSubForm
AS
SELECT     ClaveUnica, Grupo, Empleado, SuspendidoFlag, Cia
FROM         dbo.tdGruposEmpleados

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

--  -----------------------------------------------------------
--  agregamos el item SueldoBasico a la tabla tEmpleados
--  -----------------------------------------------------------

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
ALTER TABLE dbo.tEmpleados
	DROP CONSTRAINT FK_tEmpleados_tDepartamentos
GO
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.Tmp_tEmpleados
	(
	Empleado int NOT NULL,
	Cedula nvarchar(12) NOT NULL,
	Status nvarchar(1) NOT NULL,
	Nombre nvarchar(250) NOT NULL,
	EdoCivil nvarchar(2) NOT NULL,
	Sexo nvarchar(1) NOT NULL,
	Nacionalidad nvarchar(1) NOT NULL,
	FechaNacimiento datetime NOT NULL,
	PaisOrigen nvarchar(6) NULL,
	CiudadOrigen nvarchar(6) NULL,
	DireccionHabitacion ntext NULL,
	Telefono1 nvarchar(14) NULL,
	Telefono2 nvarchar(14) NULL,
	SituacionActual nvarchar(2) NOT NULL,
	Departamento int NOT NULL,
	Cargo int NOT NULL,
	FechaIngreso datetime NOT NULL,
	FechaRetiro datetime NULL,
	Banco int NULL,
	CuentaBancaria nvarchar(30) NULL,
	Contacto1 nvarchar(250) NULL,
	Parentesco1 int NULL,
	TelefonoCon1 nvarchar(14) NULL,
	Contacto2 nvarchar(250) NULL,
	Parentesco2 int NULL,
	TelefonoCon2 nvarchar(14) NULL,
	Contacto3 nvarchar(250) NULL,
	Parentesco3 int NULL,
	TelefonoCon3 nvarchar(14) NULL,
	TipoCuenta int NULL,
	EmpleadoObreroFlag smallint NULL,
	SueldoPromedio money NULL,
	SueldoBasico money NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.tEmpleados)
	 EXEC('INSERT INTO dbo.Tmp_tEmpleados (Empleado, Cedula, Status, Nombre, EdoCivil, Sexo, Nacionalidad, FechaNacimiento, PaisOrigen, CiudadOrigen, DireccionHabitacion, Telefono1, Telefono2, SituacionActual, Departamento, Cargo, FechaIngreso, FechaRetiro, Banco, CuentaBancaria, Contacto1, Parentesco1, TelefonoCon1, Contacto2, Parentesco2, TelefonoCon2, Contacto3, Parentesco3, TelefonoCon3, TipoCuenta, EmpleadoObreroFlag, SueldoPromedio, Cia)
		SELECT Empleado, Cedula, Status, Nombre, EdoCivil, Sexo, Nacionalidad, FechaNacimiento, PaisOrigen, CiudadOrigen, DireccionHabitacion, Telefono1, Telefono2, SituacionActual, Departamento, Cargo, FechaIngreso, FechaRetiro, Banco, CuentaBancaria, Contacto1, Parentesco1, TelefonoCon1, Contacto2, Parentesco2, TelefonoCon2, Contacto3, Parentesco3, TelefonoCon3, TipoCuenta, EmpleadoObreroFlag, SueldoPromedio, Cia FROM dbo.tEmpleados TABLOCKX')
GO
ALTER TABLE dbo.Vacaciones
	DROP CONSTRAINT FK_Vacaciones_tEmpleados
GO
DROP TABLE dbo.tEmpleados
GO
EXECUTE sp_rename N'dbo.Tmp_tEmpleados', N'tEmpleados', 'OBJECT'
GO
ALTER TABLE dbo.tEmpleados ADD CONSTRAINT
	PK_tEmpleados PRIMARY KEY NONCLUSTERED 
	(
	Empleado
	) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_tEmpleados ON dbo.tEmpleados
	(
	Departamento
	) ON [PRIMARY]
GO
ALTER TABLE dbo.tEmpleados WITH NOCHECK ADD CONSTRAINT
	FK_tEmpleados_tDepartamentos FOREIGN KEY
	(
	Departamento
	) REFERENCES dbo.tDepartamentos
	(
	Departamento
	)
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.Vacaciones WITH NOCHECK ADD CONSTRAINT
	FK_Vacaciones_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	)
GO
COMMIT

--  -----------------------------------------------------------
--  views relacionados a la tabla tEmpleados
--  -----------------------------------------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaEmpleados]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaEmpleados]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaEmpleadosConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaEmpleadosConsulta]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaEmpleados
AS
SELECT     Empleado, Cedula, Status, Nombre, EdoCivil, Sexo, Nacionalidad, FechaNacimiento, PaisOrigen, CiudadOrigen, DireccionHabitacion, Telefono1, 
                      Telefono2, SituacionActual, Departamento, Cargo, FechaIngreso, FechaRetiro, Banco, CuentaBancaria, Contacto1, Parentesco1, TelefonoCon1, 
                      Contacto2, Parentesco2, TelefonoCon2, Contacto3, Parentesco3, TelefonoCon3, TipoCuenta, EmpleadoObreroFlag, SueldoPromedio, SueldoBasico, 
                      Cia
FROM         dbo.tEmpleados

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaEmpleadosConsulta
AS
SELECT     dbo.tEmpleados.Empleado, dbo.tEmpleados.Cedula, dbo.tEmpleados.Status, dbo.tEmpleados.Nombre, dbo.tEmpleados.EdoCivil, 
                      dbo.tEmpleados.Sexo, dbo.tEmpleados.Nacionalidad, dbo.tEmpleados.FechaNacimiento, dbo.tEmpleados.PaisOrigen, 
                      dbo.tPaises.Descripcion AS NombrePais, dbo.tEmpleados.CiudadOrigen, dbo.tCiudades.Descripcion AS NombreCiudad, 
                      dbo.tEmpleados.DireccionHabitacion, dbo.tEmpleados.Telefono1, dbo.tEmpleados.Telefono2, dbo.tEmpleados.SituacionActual, 
                      dbo.tEmpleados.Departamento, dbo.tDepartamentos.Descripcion AS NombreDepartamento, dbo.tEmpleados.Cargo, 
                      dbo.tCargos.Descripcion AS NombreCargo, dbo.tEmpleados.FechaIngreso, dbo.tEmpleados.FechaRetiro, dbo.tEmpleados.Banco, 
                      dbo.Bancos.Nombre AS NombreBanco, dbo.tEmpleados.CuentaBancaria, dbo.tEmpleados.TipoCuenta, dbo.tEmpleados.Contacto1, 
                      dbo.tEmpleados.Parentesco1, tParentescosUno.Descripcion AS NombreParentescoUno, dbo.tEmpleados.TelefonoCon1, dbo.tEmpleados.Contacto2, 
                      dbo.tEmpleados.Parentesco2, tParentescosDos.Descripcion AS NombreParentescoDos, dbo.tEmpleados.TelefonoCon2, dbo.tEmpleados.Contacto3, 
                      dbo.tEmpleados.Parentesco3, tParentescosTres.Descripcion AS NombreParentescoTres, dbo.tEmpleados.TelefonoCon3, 
                      dbo.tEmpleados.EmpleadoObreroFlag, dbo.tEmpleados.SueldoPromedio, dbo.tEmpleados.SueldoBasico, dbo.tEmpleados.Cia
FROM         dbo.tEmpleados LEFT OUTER JOIN
                      dbo.tCargos ON dbo.tEmpleados.Cargo = dbo.tCargos.Cargo LEFT OUTER JOIN
                      dbo.tDepartamentos ON dbo.tEmpleados.Departamento = dbo.tDepartamentos.Departamento LEFT OUTER JOIN
                      dbo.tPaises ON dbo.tEmpleados.PaisOrigen = dbo.tPaises.Pais LEFT OUTER JOIN
                      dbo.tCiudades ON dbo.tEmpleados.CiudadOrigen = dbo.tCiudades.Ciudad LEFT OUTER JOIN
                      dbo.tParentescos tParentescosUno ON dbo.tEmpleados.Parentesco1 = tParentescosUno.Parentesco LEFT OUTER JOIN
                      dbo.tParentescos tParentescosDos ON dbo.tEmpleados.Parentesco2 = tParentescosDos.Parentesco LEFT OUTER JOIN
                      dbo.tParentescos tParentescosTres ON dbo.tEmpleados.Parentesco3 = tParentescosTres.Parentesco LEFT OUTER JOIN
                      dbo.Bancos ON dbo.tEmpleados.Banco = dbo.Bancos.Banco

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

--  -----------------------------------------------------------
--  agregamos el item GrupoNomina a la tabla tRubrosAsignados
--  -----------------------------------------------------------



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
CREATE TABLE dbo.Tmp_tRubrosAsignados
	(
	RubroAsignado int NOT NULL,
	TodaLaCia bit NULL,
	Empleado int NULL,
	GrupoEmpleados int NULL,
	GrupoNomina int NULL,
	Rubro int NOT NULL,
	Descripcion nvarchar(250) NOT NULL,
	SuspendidoFlag bit NULL,
	OrdenDeAplicacion smallint NULL,
	Tipo nvarchar(1) NOT NULL,
	Periodicidad nvarchar(2) NOT NULL,
	Desde datetime NULL,
	Hasta datetime NULL,
	Siempre bit NULL,
	MontoAAplicar money NULL,
	RubroAAplicar int NULL,
	GrupoAAplicar int NULL,
	DeLaNomina nvarchar(2) NULL,
	DeLaNominaDesde smalldatetime NULL,
	DeLaNominaHasta smalldatetime NULL,
	VariableAAplicar tinyint NULL,
	Factor1 float(53) NULL,
	Factor2 float(53) NULL,
	Divisor1 float(53) NULL,
	Divisor2 float(53) NULL,
	Porcentaje float(53) NULL,
	PorcentajeMas float(53) NULL,
	PorcentajeMas2 float(53) NULL,
	LunesDelMes bit NULL,
	Tope money NULL,
	Categoria smallint NULL,
	AplicaPrestacionesFlag bit NULL,
	MostrarEnElReciboFlag bit NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.tRubrosAsignados)
	 EXEC('INSERT INTO dbo.Tmp_tRubrosAsignados (RubroAsignado, TodaLaCia, Empleado, GrupoEmpleados, Rubro, Descripcion, SuspendidoFlag, OrdenDeAplicacion, Tipo, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, Factor1, Factor2, Divisor1, Divisor2, Porcentaje, PorcentajeMas, PorcentajeMas2, LunesDelMes, Tope, Categoria, AplicaPrestacionesFlag, MostrarEnElReciboFlag, Cia)
		SELECT RubroAsignado, TodaLaCia, Empleado, GrupoEmpleados, Rubro, Descripcion, SuspendidoFlag, OrdenDeAplicacion, Tipo, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, Factor1, Factor2, Divisor1, Divisor2, Porcentaje, PorcentajeMas, PorcentajeMas2, LunesDelMes, Tope, Categoria, AplicaPrestacionesFlag, MostrarEnElReciboFlag, Cia FROM dbo.tRubrosAsignados TABLOCKX')
GO
DROP TABLE dbo.tRubrosAsignados
GO
EXECUTE sp_rename N'dbo.Tmp_tRubrosAsignados', N'tRubrosAsignados', 'OBJECT'
GO
ALTER TABLE dbo.tRubrosAsignados ADD CONSTRAINT
	PK_tRubrosAsignados PRIMARY KEY NONCLUSTERED 
	(
	RubroAsignado
	) ON [PRIMARY]

GO
COMMIT

--  ----------------------------------------------------------------------
--  actualizamos los views que corresponden a la tabla tRubrosAsignados
--  ----------------------------------------------------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaRubrosAsignadosConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaRubrosAsignadosConsulta]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaRubrosAsignados]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaRubrosAsignados]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaRubrosAsignados
AS
SELECT     RubroAsignado, TodaLaCia, Empleado, GrupoEmpleados, GrupoNomina, Rubro, Descripcion, SuspendidoFlag, OrdenDeAplicacion, Tipo, Periodicidad, 
                      Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, Factor1, 
                      Factor2, Porcentaje, LunesDelMes, Tope, Categoria, AplicaPrestacionesFlag, Cia, Divisor1, Divisor2, PorcentajeMas, PorcentajeMas2, 
                      MostrarEnElReciboFlag
FROM         dbo.tRubrosAsignados

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
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
                      dbo.tRubrosAsignados.Porcentaje, dbo.tRubrosAsignados.Tope, dbo.tRubrosAsignados.LunesDelMes, dbo.tRubrosAsignados.Cia, 
                      dbo.tRubrosAsignados.Divisor1, dbo.tRubrosAsignados.Divisor2, dbo.tRubrosAsignados.PorcentajeMas, dbo.tRubrosAsignados.PorcentajeMas2, 
                      dbo.tRubrosAsignados.MostrarEnElReciboFlag
FROM         dbo.tRubrosAsignados LEFT OUTER JOIN
                      dbo.tEmpleados ON dbo.tRubrosAsignados.Empleado = dbo.tEmpleados.Empleado LEFT OUTER JOIN
                      dbo.tGruposEmpleados ON dbo.tRubrosAsignados.GrupoEmpleados = dbo.tGruposEmpleados.Grupo INNER JOIN
                      dbo.tMaestraRubros ON dbo.tRubrosAsignados.Rubro = dbo.tMaestraRubros.Rubro LEFT OUTER JOIN
                      dbo.tGruposEmpleados tGruposEmpleados_1 ON dbo.tRubrosAsignados.GrupoNomina = tGruposEmpleados_1.Grupo LEFT OUTER JOIN
                      dbo.tMaestraRubros tMaestraRubros_1 ON dbo.tRubrosAsignados.RubroAAplicar = tMaestraRubros_1.Rubro LEFT OUTER JOIN
                      dbo.tGruposRubros ON dbo.tRubrosAsignados.GrupoAAplicar = dbo.tGruposRubros.Grupo

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaRubrosSimplesAsignadosConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaRubrosSimplesAsignadosConsulta]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaRubrosSimplesAsignados]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaRubrosSimplesAsignados]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaRubrosSimplesAsignados
AS
SELECT     RubroAsignado, GrupoNomina, Empleado, Rubro, Descripcion, SuspendidoFlag, Tipo, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, 
                      VariableAAplicar, Factor1, Factor2, Porcentaje, AplicaPrestacionesFlag, Cia, Divisor1, Divisor2, PorcentajeMas, PorcentajeMas2, 
                      MostrarEnElReciboFlag
FROM         dbo.tRubrosAsignados
WHERE     (Empleado IS NOT NULL) AND (MontoAAplicar IS NOT NULL) OR
                      (Empleado IS NOT NULL) AND (VariableAAplicar IS NOT NULL)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaRubrosSimplesAsignadosConsulta
AS
SELECT     dbo.tRubrosAsignados.RubroAsignado, dbo.tRubrosAsignados.GrupoNomina, dbo.tGruposEmpleados.NombreGrupo AS NombreGrupoNomina, 
                      dbo.tRubrosAsignados.Empleado, dbo.tEmpleados.Nombre AS NombreEmpleado, dbo.tRubrosAsignados.Rubro, 
                      dbo.tMaestraRubros.NombreCortoRubro, dbo.tRubrosAsignados.SuspendidoFlag, dbo.tRubrosAsignados.Descripcion, dbo.tRubrosAsignados.Tipo, 
                      dbo.tRubrosAsignados.Periodicidad, dbo.tRubrosAsignados.Desde, dbo.tRubrosAsignados.Hasta, dbo.tRubrosAsignados.Siempre, 
                      dbo.tRubrosAsignados.MontoAAplicar, dbo.tRubrosAsignados.VariableAAplicar, dbo.tRubrosAsignados.Factor1, dbo.tRubrosAsignados.Factor2, 
                      dbo.tRubrosAsignados.Porcentaje, dbo.tRubrosAsignados.AplicaPrestacionesFlag, dbo.tRubrosAsignados.Cia, dbo.tRubrosAsignados.Divisor1, 
                      dbo.tRubrosAsignados.Divisor2, dbo.tRubrosAsignados.PorcentajeMas, dbo.tRubrosAsignados.PorcentajeMas2, 
                      dbo.tRubrosAsignados.MostrarEnElReciboFlag
FROM         dbo.tRubrosAsignados INNER JOIN
                      dbo.tEmpleados ON dbo.tRubrosAsignados.Empleado = dbo.tEmpleados.Empleado INNER JOIN
                      dbo.tMaestraRubros ON dbo.tMaestraRubros.Rubro = dbo.tRubrosAsignados.Rubro LEFT OUTER JOIN
                      dbo.tGruposEmpleados ON dbo.tRubrosAsignados.GrupoNomina = dbo.tGruposEmpleados.Grupo
WHERE     (dbo.tRubrosAsignados.Empleado IS NOT NULL) AND (dbo.tRubrosAsignados.MontoAAplicar IS NOT NULL) OR
                      (dbo.tRubrosAsignados.Empleado IS NOT NULL) AND (dbo.tRubrosAsignados.VariableAAplicar IS NOT NULL)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.131', GetDate()) 
