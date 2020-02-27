/*    Jueves 28 de Enero de 2003   -   v0.00.146.sql 

	Agregamos los cambios necesarios para implementar el "calculo de vacaciones" (II) a la
      nómina. 

*/ 

--  ------------------------
--  tMaestraRubros
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
CREATE TABLE dbo.Tmp_tMaestraRubros
	(
	Rubro int NOT NULL,
	NombreCortoRubro nvarchar(10) NOT NULL,
	Descripcion nvarchar(250) NOT NULL,
	Tipo nvarchar(1) NOT NULL,
	VacNormalAmbasFlag char(1) NULL,
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
	BaseCalculoVariableFlag char(2) NULL,
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
	SSOFlag bit NULL,
	ISRFlag bit NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.tMaestraRubros)
	 EXEC('INSERT INTO dbo.Tmp_tMaestraRubros (Rubro, NombreCortoRubro, Descripcion, Tipo, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, Factor1, Factor2, Divisor1, Divisor2, Porcentaje, PorcentajeMas, PorcentajeMas2, LunesDelMes, Tope, Categoria, AplicaPrestacionesFlag, MostrarEnElReciboFlag, SSOFlag, ISRFlag)
		SELECT Rubro, NombreCortoRubro, Descripcion, Tipo, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, Factor1, Factor2, Divisor1, Divisor2, Porcentaje, PorcentajeMas, PorcentajeMas2, LunesDelMes, Tope, Categoria, AplicaPrestacionesFlag, MostrarEnElReciboFlag, SSOFlag, ISRFlag FROM dbo.tMaestraRubros TABLOCKX')
GO
DROP TABLE dbo.tMaestraRubros
GO
EXECUTE sp_rename N'dbo.Tmp_tMaestraRubros', N'tMaestraRubros', 'OBJECT'
GO
ALTER TABLE dbo.tMaestraRubros ADD CONSTRAINT
	PK_tMaestraRubros PRIMARY KEY NONCLUSTERED 
	(
	Rubro
	) ON [PRIMARY]

GO
COMMIT

update tMaestraRubros Set VacNormalAmbasFlag = 'N'
Alter Table tMaestraRubros Alter Column VacNormalAmbasFlag char(1) Not Null

--  ------------------------
--  tRubrosAsignados
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
	VacNormalAmbasFlag char(1) NULL,
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
	BaseCalculoVariableFlag char(2) NULL,
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
	 EXEC('INSERT INTO dbo.Tmp_tRubrosAsignados (RubroAsignado, TodaLaCia, Empleado, GrupoEmpleados, GrupoNomina, Rubro, Descripcion, SuspendidoFlag, OrdenDeAplicacion, Tipo, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, Factor1, Factor2, Divisor1, Divisor2, Porcentaje, PorcentajeMas, PorcentajeMas2, LunesDelMes, Tope, Categoria, AplicaPrestacionesFlag, MostrarEnElReciboFlag, Cia)
		SELECT RubroAsignado, TodaLaCia, Empleado, GrupoEmpleados, GrupoNomina, Rubro, Descripcion, SuspendidoFlag, OrdenDeAplicacion, Tipo, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, Factor1, Factor2, Divisor1, Divisor2, Porcentaje, PorcentajeMas, PorcentajeMas2, LunesDelMes, Tope, Categoria, AplicaPrestacionesFlag, MostrarEnElReciboFlag, Cia FROM dbo.tRubrosAsignados TABLOCKX')
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


update tRubrosAsignados Set VacNormalAmbasFlag = 'N'
Alter Table tRubrosAsignados Alter Column VacNormalAmbasFlag char(1) Not Null


--  ------------------------
--  views asociados 
--  ------------------------



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaRubrosAsignadosConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaRubrosAsignadosConsulta]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaRubrosSimplesAsignadosConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaRubrosSimplesAsignadosConsulta]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaMaestraRubros]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaMaestraRubros]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaMaestraRubrosConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaMaestraRubrosConsulta]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaRubrosAsignados]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaRubrosAsignados]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaRubrosSimplesAsignados]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaRubrosSimplesAsignados]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaMaestraRubros
AS
SELECT     Rubro, NombreCortoRubro, Descripcion, Tipo, VacNormalAmbasFlag, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, 
                      GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Porcentaje, Tope, 
                      LunesDelMes, Categoria, AplicaPrestacionesFlag, Divisor1, Divisor2, PorcentajeMas, PorcentajeMas2, MostrarEnElReciboFlag, SSOFlag, 
                      ISRFlag
FROM         dbo.tMaestraRubros

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaMaestraRubrosConsulta
AS
SELECT     dbo.tMaestraRubros.Rubro, dbo.tMaestraRubros.NombreCortoRubro, dbo.tMaestraRubros.Descripcion, dbo.tMaestraRubros.Tipo, 
                      dbo.tMaestraRubros.VacNormalAmbasFlag, dbo.tMaestraRubros.Periodicidad, dbo.tMaestraRubros.Desde, dbo.tMaestraRubros.Hasta, 
                      dbo.tMaestraRubros.Siempre, dbo.tMaestraRubros.MontoAAplicar, dbo.tMaestraRubros.RubroAAplicar, 
                      tMaestraRubros_1.NombreCortoRubro AS NombreCortoRubroAAplicar, dbo.tMaestraRubros.GrupoAAplicar, 
                      dbo.tGruposRubros.NombreGrupo AS NombreGrupoRubrosAAplicar, dbo.tMaestraRubros.DeLaNomina, dbo.tMaestraRubros.DeLaNominaDesde, 
                      dbo.tMaestraRubros.DeLaNominaHasta, dbo.tMaestraRubros.VariableAAplicar, dbo.tMaestraRubros.BaseCalculoVariableFlag, 
                      dbo.tMaestraRubros.Factor1, dbo.tMaestraRubros.Factor2, dbo.tMaestraRubros.Porcentaje, dbo.tMaestraRubros.LunesDelMes, 
                      dbo.tMaestraRubros.Tope, dbo.tMaestraRubros.Categoria, dbo.tMaestraRubros.AplicaPrestacionesFlag, dbo.tMaestraRubros.Divisor1, 
                      dbo.tMaestraRubros.Divisor2, dbo.tMaestraRubros.PorcentajeMas, dbo.tMaestraRubros.PorcentajeMas2, 
                      dbo.tMaestraRubros.MostrarEnElReciboFlag, dbo.tMaestraRubros.SSOFlag, dbo.tMaestraRubros.ISRFlag
FROM         dbo.tMaestraRubros LEFT OUTER JOIN
                      dbo.tMaestraRubros tMaestraRubros_1 ON dbo.tMaestraRubros.RubroAAplicar = tMaestraRubros_1.Rubro LEFT OUTER JOIN
                      dbo.tGruposRubros ON dbo.tMaestraRubros.GrupoAAplicar = dbo.tGruposRubros.Grupo

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaRubrosAsignados
AS
SELECT     RubroAsignado, TodaLaCia, Empleado, GrupoEmpleados, GrupoNomina, Rubro, Descripcion, SuspendidoFlag, OrdenDeAplicacion, Tipo, 
                      VacNormalAmbasFlag, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, 
                      DeLaNominaHasta, VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Porcentaje, LunesDelMes, Tope, Categoria, AplicaPrestacionesFlag, 
                      Cia, Divisor1, Divisor2, PorcentajeMas, PorcentajeMas2, MostrarEnElReciboFlag
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

CREATE VIEW dbo.qFormaRubrosSimplesAsignados
AS
SELECT     RubroAsignado, GrupoNomina, Empleado, Rubro, Descripcion, SuspendidoFlag, Tipo, VacNormalAmbasFlag, Periodicidad, Desde, Hasta, Siempre, 
                      MontoAAplicar, VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Porcentaje, AplicaPrestacionesFlag, Cia, Divisor1, Divisor2, 
                      PorcentajeMas, PorcentajeMas2, MostrarEnElReciboFlag
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

CREATE VIEW dbo.qFormaRubrosAsignadosConsulta
AS
SELECT     dbo.tRubrosAsignados.RubroAsignado, dbo.tRubrosAsignados.TodaLaCia, dbo.tRubrosAsignados.Empleado, 
                      dbo.tEmpleados.Nombre AS NombreEmpleado, dbo.tRubrosAsignados.GrupoEmpleados, 
                      dbo.tGruposEmpleados.NombreGrupo AS NombreGrupoEmpleados, dbo.tRubrosAsignados.GrupoNomina, 
                      tGruposEmpleados_1.NombreGrupo AS NombreGrupoNomina, dbo.tRubrosAsignados.SuspendidoFlag, dbo.tRubrosAsignados.Rubro, 
                      dbo.tMaestraRubros.NombreCortoRubro, dbo.tRubrosAsignados.Descripcion, dbo.tRubrosAsignados.Tipo, 
                      dbo.tRubrosAsignados.VacNormalAmbasFlag, dbo.tRubrosAsignados.Periodicidad, dbo.tRubrosAsignados.Desde, dbo.tRubrosAsignados.Hasta, 
                      dbo.tRubrosAsignados.Siempre, dbo.tRubrosAsignados.MontoAAplicar, dbo.tRubrosAsignados.RubroAAplicar, 
                      tMaestraRubros_1.NombreCortoRubro AS NombreCortoRubroAAplicar, dbo.tRubrosAsignados.GrupoAAplicar, 
                      dbo.tGruposRubros.NombreGrupo AS NombreGrupoRubrosAAplicar, dbo.tRubrosAsignados.DeLaNomina, dbo.tRubrosAsignados.DeLaNominaDesde, 
                      dbo.tRubrosAsignados.DeLaNominaHasta, dbo.tRubrosAsignados.VariableAAplicar, dbo.tRubrosAsignados.BaseCalculoVariableFlag, 
                      dbo.tRubrosAsignados.Factor1, dbo.tRubrosAsignados.Factor2, dbo.tRubrosAsignados.Porcentaje, dbo.tRubrosAsignados.Tope, 
                      dbo.tRubrosAsignados.LunesDelMes, dbo.tRubrosAsignados.Divisor1, dbo.tRubrosAsignados.Divisor2, dbo.tRubrosAsignados.PorcentajeMas, 
                      dbo.tRubrosAsignados.PorcentajeMas2, dbo.tRubrosAsignados.MostrarEnElReciboFlag, dbo.tRubrosAsignados.Cia
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

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaRubrosSimplesAsignadosConsulta
AS
SELECT     dbo.tRubrosAsignados.RubroAsignado, dbo.tRubrosAsignados.GrupoNomina, dbo.tGruposEmpleados.NombreGrupo AS NombreGrupoNomina, 
                      dbo.tRubrosAsignados.Empleado, dbo.tEmpleados.Nombre AS NombreEmpleado, dbo.tRubrosAsignados.Rubro, 
                      dbo.tMaestraRubros.NombreCortoRubro, dbo.tRubrosAsignados.SuspendidoFlag, dbo.tRubrosAsignados.Descripcion, dbo.tRubrosAsignados.Tipo, 
                      dbo.tRubrosAsignados.BaseCalculoVariableFlag, dbo.tRubrosAsignados.Periodicidad, dbo.tRubrosAsignados.Desde, dbo.tRubrosAsignados.Hasta, 
                      dbo.tRubrosAsignados.Siempre, dbo.tRubrosAsignados.MontoAAplicar, dbo.tRubrosAsignados.VariableAAplicar, 
                      dbo.tRubrosAsignados.VacNormalAmbasFlag, dbo.tRubrosAsignados.Factor1, dbo.tRubrosAsignados.Factor2, dbo.tRubrosAsignados.Porcentaje, 
                      dbo.tRubrosAsignados.AplicaPrestacionesFlag, dbo.tRubrosAsignados.Cia, dbo.tRubrosAsignados.Divisor1, dbo.tRubrosAsignados.Divisor2, 
                      dbo.tRubrosAsignados.PorcentajeMas, dbo.tRubrosAsignados.PorcentajeMas2, dbo.tRubrosAsignados.MostrarEnElReciboFlag
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


--  -------------------------------------------------------------
--  eliminamos elgunas tablas y views que habiamos creado antes 
--  -------------------------------------------------------------



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaParametrosGlobalNomina]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaParametrosGlobalNomina]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaRubrosDefinicionVacaciones]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaRubrosDefinicionVacaciones]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaControlVacaciones]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaRubrosControlVacaciones]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaControlVacacionesConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaRubrosControlVacacionesConsulta]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ParametrosGlobalNomina]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ParametrosGlobalNomina]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RubrosDefinicionVacaciones]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[RubrosDefinicionVacaciones]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RubrosControlVacaciones]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[RubrosControlVacaciones]
GO


--  -----------------------------------------------------------------------------
--  eliminamos el item UsarSalarioPromedioSueldoBasicoFlag a la tabla Vacaciones
--  -----------------------------------------------------------------------------


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
ALTER TABLE dbo.Vacaciones
	DROP COLUMN UsarSalarioPromedioSueldoBasicoFlag
GO
COMMIT


--  -----------------------------------------------------------------------------
--  qFormaControlVacaciones y qFormaControlVacacionesConsulta
--  -----------------------------------------------------------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaControlVacaciones]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaControlVacaciones]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaControlVacacionesConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaControlVacacionesConsulta]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaControlVacaciones
AS
SELECT     ClaveUnica, Empleado, GrupoNomina, TipoNomina, FechaIngreso, AnosServicio, SalarioPromedio, SueldoBasico, AnoVacacionesDesde, 
                      AnoVacacionesHasta, AnoVacaciones, Salida, Regreso, DiasDisfrutados, FechaReintegro, FraccionAntesDesde, FraccionAntesHasta, 
                      CantDiasFraccionAntes, FraccionDespuesDesde, FraccionDespuesHasta, FechaNomina, CantDiasFraccionDespues, MontoBono, FechaPagoBono, 
                      ObviarEnLaNominaFlag, Cia
FROM         dbo.Vacaciones

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaControlVacacionesConsulta
AS
SELECT     dbo.Vacaciones.ClaveUnica, dbo.Vacaciones.Empleado, dbo.Vacaciones.GrupoNomina, dbo.Vacaciones.TipoNomina, dbo.Vacaciones.FechaIngreso, 
                      dbo.Vacaciones.AnosServicio, dbo.Vacaciones.SalarioPromedio, dbo.Vacaciones.SueldoBasico, dbo.Vacaciones.AnoVacacionesDesde, 
                      dbo.Vacaciones.AnoVacacionesHasta, dbo.Vacaciones.AnoVacaciones, dbo.Vacaciones.Salida, dbo.Vacaciones.Regreso, 
                      dbo.Vacaciones.DiasDisfrutados, dbo.Vacaciones.FechaReintegro, dbo.Vacaciones.FraccionAntesDesde, dbo.Vacaciones.FraccionAntesHasta, 
                      dbo.Vacaciones.CantDiasFraccionAntes, dbo.Vacaciones.FraccionDespuesDesde, dbo.Vacaciones.FraccionDespuesHasta, 
                      dbo.Vacaciones.FechaNomina, dbo.Vacaciones.CantDiasFraccionDespues, dbo.Vacaciones.MontoBono, dbo.Vacaciones.FechaPagoBono, 
                      dbo.Vacaciones.ObviarEnLaNominaFlag, dbo.Vacaciones.Cia, dbo.tEmpleados.Nombre AS NombreEmpleado, 
                      dbo.tGruposEmpleados.NombreGrupo
FROM         dbo.Vacaciones INNER JOIN
                      dbo.tEmpleados ON dbo.Vacaciones.Empleado = dbo.tEmpleados.Empleado AND dbo.Vacaciones.Cia = dbo.tEmpleados.Cia INNER JOIN
                      dbo.tGruposEmpleados ON dbo.Vacaciones.Cia = dbo.tGruposEmpleados.Cia AND dbo.Vacaciones.GrupoNomina = dbo.tGruposEmpleados.Grupo

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


--  -------------------------------------------------------------------
--  Cambiamos el item VacNormalAmbasFlag char(1) a TipoNomina nvarchar(10) 
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
CREATE TABLE dbo.Tmp_tMaestraRubros
	(
	Rubro int NOT NULL,
	NombreCortoRubro nvarchar(10) NOT NULL,
	Descripcion nvarchar(250) NOT NULL,
	Tipo nvarchar(1) NOT NULL,
	TipoNomina nvarchar(10) NOT NULL,
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
	BaseCalculoVariableFlag char(2) NULL,
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
	SSOFlag bit NULL,
	ISRFlag bit NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.tMaestraRubros)
	 EXEC('INSERT INTO dbo.Tmp_tMaestraRubros (Rubro, NombreCortoRubro, Descripcion, Tipo, TipoNomina, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Divisor1, Divisor2, Porcentaje, PorcentajeMas, PorcentajeMas2, LunesDelMes, Tope, Categoria, AplicaPrestacionesFlag, MostrarEnElReciboFlag, SSOFlag, ISRFlag)
		SELECT Rubro, NombreCortoRubro, Descripcion, Tipo, VacNormalAmbasFlag, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Divisor1, Divisor2, Porcentaje, PorcentajeMas, PorcentajeMas2, LunesDelMes, Tope, Categoria, AplicaPrestacionesFlag, MostrarEnElReciboFlag, SSOFlag, ISRFlag FROM dbo.tMaestraRubros TABLOCKX')
GO
DROP TABLE dbo.tMaestraRubros
GO
EXECUTE sp_rename N'dbo.Tmp_tMaestraRubros', N'tMaestraRubros', 'OBJECT'
GO
ALTER TABLE dbo.tMaestraRubros ADD CONSTRAINT
	PK_tMaestraRubros PRIMARY KEY NONCLUSTERED 
	(
	Rubro
	) ON [PRIMARY]

GO
COMMIT


--  -------------------------------------------------------------------
--  Cambiamos el item VacNormalAmbasFlag char(1) a TipoNomina nvarchar(10) 
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
	TipoNomina nvarchar(10) NOT NULL,
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
	BaseCalculoVariableFlag char(2) NULL,
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
	 EXEC('INSERT INTO dbo.Tmp_tRubrosAsignados (RubroAsignado, TodaLaCia, Empleado, GrupoEmpleados, GrupoNomina, Rubro, Descripcion, SuspendidoFlag, OrdenDeAplicacion, Tipo, TipoNomina, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Divisor1, Divisor2, Porcentaje, PorcentajeMas, PorcentajeMas2, LunesDelMes, Tope, Categoria, AplicaPrestacionesFlag, MostrarEnElReciboFlag, Cia)
		SELECT RubroAsignado, TodaLaCia, Empleado, GrupoEmpleados, GrupoNomina, Rubro, Descripcion, SuspendidoFlag, OrdenDeAplicacion, Tipo, VacNormalAmbasFlag, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Divisor1, Divisor2, Porcentaje, PorcentajeMas, PorcentajeMas2, LunesDelMes, Tope, Categoria, AplicaPrestacionesFlag, MostrarEnElReciboFlag, Cia FROM dbo.tRubrosAsignados TABLOCKX')
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

--  -----------------------------------------------------
--  views asociados a tMaestraRubros y tRubrosAsignados
--  -----------------------------------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaRubrosAsignadosConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaRubrosAsignadosConsulta]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaRubrosSimplesAsignadosConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaRubrosSimplesAsignadosConsulta]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaMaestraRubros]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaMaestraRubros]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaMaestraRubrosConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaMaestraRubrosConsulta]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaRubrosAsignados]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaRubrosAsignados]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaRubrosSimplesAsignados]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaRubrosSimplesAsignados]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaMaestraRubros
AS
SELECT     Rubro, NombreCortoRubro, Descripcion, Tipo, TipoNomina, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, 
                      GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Porcentaje, Tope, 
                      LunesDelMes, Categoria, AplicaPrestacionesFlag, Divisor1, Divisor2, PorcentajeMas, PorcentajeMas2, MostrarEnElReciboFlag, SSOFlag, 
                      ISRFlag
FROM         dbo.tMaestraRubros

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaMaestraRubrosConsulta
AS
SELECT     dbo.tMaestraRubros.Rubro, dbo.tMaestraRubros.NombreCortoRubro, dbo.tMaestraRubros.Descripcion, dbo.tMaestraRubros.Tipo, 
                      dbo.tMaestraRubros.TipoNomina, dbo.tMaestraRubros.Periodicidad, dbo.tMaestraRubros.Desde, dbo.tMaestraRubros.Hasta, 
                      dbo.tMaestraRubros.Siempre, dbo.tMaestraRubros.MontoAAplicar, dbo.tMaestraRubros.RubroAAplicar, 
                      tMaestraRubros_1.NombreCortoRubro AS NombreCortoRubroAAplicar, dbo.tMaestraRubros.GrupoAAplicar, 
                      dbo.tGruposRubros.NombreGrupo AS NombreGrupoRubrosAAplicar, dbo.tMaestraRubros.DeLaNomina, dbo.tMaestraRubros.DeLaNominaDesde, 
                      dbo.tMaestraRubros.DeLaNominaHasta, dbo.tMaestraRubros.VariableAAplicar, dbo.tMaestraRubros.BaseCalculoVariableFlag, 
                      dbo.tMaestraRubros.Factor1, dbo.tMaestraRubros.Factor2, dbo.tMaestraRubros.Porcentaje, dbo.tMaestraRubros.LunesDelMes, 
                      dbo.tMaestraRubros.Tope, dbo.tMaestraRubros.Categoria, dbo.tMaestraRubros.AplicaPrestacionesFlag, dbo.tMaestraRubros.Divisor1, 
                      dbo.tMaestraRubros.Divisor2, dbo.tMaestraRubros.PorcentajeMas, dbo.tMaestraRubros.PorcentajeMas2, 
                      dbo.tMaestraRubros.MostrarEnElReciboFlag, dbo.tMaestraRubros.SSOFlag, dbo.tMaestraRubros.ISRFlag
FROM         dbo.tMaestraRubros LEFT OUTER JOIN
                      dbo.tMaestraRubros tMaestraRubros_1 ON dbo.tMaestraRubros.RubroAAplicar = tMaestraRubros_1.Rubro LEFT OUTER JOIN
                      dbo.tGruposRubros ON dbo.tMaestraRubros.GrupoAAplicar = dbo.tGruposRubros.Grupo

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaRubrosAsignados
AS
SELECT     RubroAsignado, TodaLaCia, Empleado, GrupoEmpleados, GrupoNomina, Rubro, Descripcion, SuspendidoFlag, OrdenDeAplicacion, Tipo, 
                      TipoNomina, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, 
                      DeLaNominaHasta, VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Porcentaje, LunesDelMes, Tope, Categoria, AplicaPrestacionesFlag, 
                      Cia, Divisor1, Divisor2, PorcentajeMas, PorcentajeMas2, MostrarEnElReciboFlag
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

CREATE VIEW dbo.qFormaRubrosSimplesAsignados
AS
SELECT     RubroAsignado, GrupoNomina, Empleado, Rubro, Descripcion, SuspendidoFlag, Tipo, TipoNomina, Periodicidad, Desde, Hasta, Siempre, 
                      MontoAAplicar, VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Porcentaje, AplicaPrestacionesFlag, Cia, Divisor1, Divisor2, 
                      PorcentajeMas, PorcentajeMas2, MostrarEnElReciboFlag
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

CREATE VIEW dbo.qFormaRubrosAsignadosConsulta
AS
SELECT     dbo.tRubrosAsignados.RubroAsignado, dbo.tRubrosAsignados.TodaLaCia, dbo.tRubrosAsignados.Empleado, 
                      dbo.tEmpleados.Nombre AS NombreEmpleado, dbo.tRubrosAsignados.GrupoEmpleados, 
                      dbo.tGruposEmpleados.NombreGrupo AS NombreGrupoEmpleados, dbo.tRubrosAsignados.GrupoNomina, 
                      tGruposEmpleados_1.NombreGrupo AS NombreGrupoNomina, dbo.tRubrosAsignados.SuspendidoFlag, dbo.tRubrosAsignados.Rubro, 
                      dbo.tMaestraRubros.NombreCortoRubro, dbo.tRubrosAsignados.Descripcion, dbo.tRubrosAsignados.Tipo, 
                      dbo.tRubrosAsignados.TipoNomina, dbo.tRubrosAsignados.Periodicidad, dbo.tRubrosAsignados.Desde, dbo.tRubrosAsignados.Hasta, 
                      dbo.tRubrosAsignados.Siempre, dbo.tRubrosAsignados.MontoAAplicar, dbo.tRubrosAsignados.RubroAAplicar, 
                      tMaestraRubros_1.NombreCortoRubro AS NombreCortoRubroAAplicar, dbo.tRubrosAsignados.GrupoAAplicar, 
                      dbo.tGruposRubros.NombreGrupo AS NombreGrupoRubrosAAplicar, dbo.tRubrosAsignados.DeLaNomina, dbo.tRubrosAsignados.DeLaNominaDesde, 
                      dbo.tRubrosAsignados.DeLaNominaHasta, dbo.tRubrosAsignados.VariableAAplicar, dbo.tRubrosAsignados.BaseCalculoVariableFlag, 
                      dbo.tRubrosAsignados.Factor1, dbo.tRubrosAsignados.Factor2, dbo.tRubrosAsignados.Porcentaje, dbo.tRubrosAsignados.Tope, 
                      dbo.tRubrosAsignados.LunesDelMes, dbo.tRubrosAsignados.Divisor1, dbo.tRubrosAsignados.Divisor2, dbo.tRubrosAsignados.PorcentajeMas, 
                      dbo.tRubrosAsignados.PorcentajeMas2, dbo.tRubrosAsignados.MostrarEnElReciboFlag, dbo.tRubrosAsignados.Cia
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

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaRubrosSimplesAsignadosConsulta
AS
SELECT     dbo.tRubrosAsignados.RubroAsignado, dbo.tRubrosAsignados.GrupoNomina, dbo.tGruposEmpleados.NombreGrupo AS NombreGrupoNomina, 
                      dbo.tRubrosAsignados.Empleado, dbo.tEmpleados.Nombre AS NombreEmpleado, dbo.tRubrosAsignados.Rubro, 
                      dbo.tMaestraRubros.NombreCortoRubro, dbo.tRubrosAsignados.SuspendidoFlag, dbo.tRubrosAsignados.Descripcion, dbo.tRubrosAsignados.Tipo, 
                      dbo.tRubrosAsignados.BaseCalculoVariableFlag, dbo.tRubrosAsignados.Periodicidad, dbo.tRubrosAsignados.Desde, dbo.tRubrosAsignados.Hasta, 
                      dbo.tRubrosAsignados.Siempre, dbo.tRubrosAsignados.MontoAAplicar, dbo.tRubrosAsignados.VariableAAplicar, 
                      dbo.tRubrosAsignados.TipoNomina, dbo.tRubrosAsignados.Factor1, dbo.tRubrosAsignados.Factor2, dbo.tRubrosAsignados.Porcentaje, 
                      dbo.tRubrosAsignados.AplicaPrestacionesFlag, dbo.tRubrosAsignados.Cia, dbo.tRubrosAsignados.Divisor1, dbo.tRubrosAsignados.Divisor2, 
                      dbo.tRubrosAsignados.PorcentajeMas, dbo.tRubrosAsignados.PorcentajeMas2, dbo.tRubrosAsignados.MostrarEnElReciboFlag
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



--  ---------------------------------------------------------------------------------------
--  si acaso hay rubros con periodicidad Especial, cambiamos ésta al TipoNomina y ponemos
--  Periodicidad Siempre 
--  ---------------------------------------------------------------------------------------

Update tRubrosAsignados Set Periodicidad = 'S', TipoNomina = 'E' Where Periodicidad = 'E'













--  ---------------------------------------------------------------------------------------
--  tNomina: cambiamos CantDiasBase por MontoBase (money)
--  ---------------------------------------------------------------------------------------



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
ALTER TABLE dbo.tNomina
	DROP CONSTRAINT FK_tNomina_tGruposEmpleados
GO
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.Tmp_tNomina
	(
	NumeroUnico int NOT NULL IDENTITY (1, 1),
	GrupoNomina int NOT NULL,
	Empleado int NOT NULL,
	FechaNomina smalldatetime NOT NULL,
	Rubro int NOT NULL,
	Tipo nvarchar(1) NOT NULL,
	Descripcion nvarchar(250) NOT NULL,
	Monto money NOT NULL,
	FechaEjecucion datetime NOT NULL,
	AplicaPrestacionesFlag bit NULL,
	TipoNomina nvarchar(2) NOT NULL,
	MostrarEnElReciboFlag bit NULL,
	MontoBase money NULL,
	CantDias tinyint NULL,
	VacFraccionFlag char(1) NULL,
	FraccionarFlag bit NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
SET IDENTITY_INSERT dbo.Tmp_tNomina ON
GO
IF EXISTS(SELECT * FROM dbo.tNomina)
	 EXEC('INSERT INTO dbo.Tmp_tNomina (NumeroUnico, GrupoNomina, Empleado, FechaNomina, Rubro, Tipo, Descripcion, Monto, FechaEjecucion, AplicaPrestacionesFlag, TipoNomina, MostrarEnElReciboFlag, MontoBase, CantDias, VacFraccionFlag, FraccionarFlag, Cia)
		SELECT NumeroUnico, GrupoNomina, Empleado, FechaNomina, Rubro, Tipo, Descripcion, Monto, FechaEjecucion, AplicaPrestacionesFlag, TipoNomina, MostrarEnElReciboFlag, CONVERT(money, CantDiasBase), CantDias, VacFraccionFlag, FraccionarFlag, Cia FROM dbo.tNomina TABLOCKX')
GO
SET IDENTITY_INSERT dbo.Tmp_tNomina OFF
GO
DROP TABLE dbo.tNomina
GO
EXECUTE sp_rename N'dbo.Tmp_tNomina', N'tNomina', 'OBJECT'
GO
ALTER TABLE dbo.tNomina ADD CONSTRAINT
	PK_tNomina PRIMARY KEY NONCLUSTERED 
	(
	NumeroUnico
	) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_tNomina ON dbo.tNomina
	(
	GrupoNomina,
	Cia
	) ON [PRIMARY]
GO
ALTER TABLE dbo.tNomina WITH NOCHECK ADD CONSTRAINT
	FK_tNomina_tGruposEmpleados FOREIGN KEY
	(
	GrupoNomina,
	Cia
	) REFERENCES dbo.tGruposEmpleados
	(
	Grupo,
	Cia
	)
GO
COMMIT

--  ------------------------
--  qFormaConsultaNomina
--  ------------------------


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
                      dbo.tNomina.Monto, dbo.tNomina.FechaEjecucion, dbo.tNomina.TipoNomina, dbo.tNomina.AplicaPrestacionesFlag, dbo.tNomina.MontoBase, 
                      dbo.tNomina.MostrarEnElReciboFlag, dbo.tNomina.CantDias, dbo.tNomina.VacFraccionFlag, dbo.tNomina.Cia
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
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.146', GetDate()) 

