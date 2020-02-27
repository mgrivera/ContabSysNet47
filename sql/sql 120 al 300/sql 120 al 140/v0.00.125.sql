/*    Miercoles, 17 de Julio de 2002   -   v0.00.125.sql 

	Hacemos unas modificaciones leves a las tablas: tMaestraRubros y tRubrosAsignados 
	para agregar algunos items que ayudan al usuario en la definición de los rubros 
	(DeLaNominaDesde, DeLaNominaHasta, PorcentajeMas2, Divisor2). 

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
	SSOFlag bit NULL,
	ISRFlag bit NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.tMaestraRubros)
	 EXEC('INSERT INTO dbo.Tmp_tMaestraRubros (Rubro, NombreCortoRubro, Descripcion, Tipo, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, VariableAAplicar, Factor1, Factor2, Divisor1, Porcentaje, PorcentajeMas, LunesDelMes, Tope, Categoria, AplicaPrestacionesFlag, MostrarEnElReciboFlag, SSOFlag, ISRFlag)
		SELECT Rubro, NombreCortoRubro, Descripcion, Tipo, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, VariableAAplicar, Factor1, Factor2, Divisor1, Porcentaje, PorcentajeMas, LunesDelMes, Tope, Categoria, AplicaPrestacionesFlag, MostrarEnElReciboFlag, SSOFlag, ISRFlag FROM dbo.tMaestraRubros TABLOCKX')
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
	 EXEC('INSERT INTO dbo.Tmp_tRubrosAsignados (RubroAsignado, TodaLaCia, Empleado, GrupoEmpleados, Rubro, Descripcion, SuspendidoFlag, OrdenDeAplicacion, Tipo, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, VariableAAplicar, Factor1, Factor2, Divisor1, Porcentaje, PorcentajeMas, LunesDelMes, Tope, Categoria, AplicaPrestacionesFlag, MostrarEnElReciboFlag, Cia)
		SELECT RubroAsignado, TodaLaCia, Empleado, GrupoEmpleados, Rubro, Descripcion, SuspendidoFlag, OrdenDeAplicacion, Tipo, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, VariableAAplicar, Factor1, Factor2, Divisor1, Porcentaje, PorcentajeMas, LunesDelMes, Tope, Categoria, AplicaPrestacionesFlag, MostrarEnElReciboFlag, Cia FROM dbo.tRubrosAsignados TABLOCKX')
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

--  --------------------------------------------------
--  views que corresponden a las tablas actualizadas 
--  --------------------------------------------------

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
SELECT     Rubro, NombreCortoRubro, Descripcion, Tipo, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, 
                      DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, Factor1, Factor2, Porcentaje, Tope, LunesDelMes, Categoria, AplicaPrestacionesFlag, 
                      Divisor1, Divisor2, PorcentajeMas, PorcentajeMas2, MostrarEnElReciboFlag, SSOFlag, ISRFlag
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
                      dbo.tMaestraRubros.Periodicidad, dbo.tMaestraRubros.Desde, dbo.tMaestraRubros.Hasta, dbo.tMaestraRubros.Siempre, 
                      dbo.tMaestraRubros.MontoAAplicar, dbo.tMaestraRubros.RubroAAplicar, tMaestraRubros_1.NombreCortoRubro AS NombreCortoRubroAAplicar, 
                      dbo.tMaestraRubros.GrupoAAplicar, dbo.tGruposRubros.NombreGrupo AS NombreGrupoRubrosAAplicar, dbo.tMaestraRubros.DeLaNomina, 
                      dbo.tMaestraRubros.DeLaNominaDesde, dbo.tMaestraRubros.DeLaNominaHasta, dbo.tMaestraRubros.VariableAAplicar, dbo.tMaestraRubros.Factor1, 
                      dbo.tMaestraRubros.Factor2, dbo.tMaestraRubros.Porcentaje, dbo.tMaestraRubros.LunesDelMes, dbo.tMaestraRubros.Tope, 
                      dbo.tMaestraRubros.Categoria, dbo.tMaestraRubros.AplicaPrestacionesFlag, dbo.tMaestraRubros.Divisor1, dbo.tMaestraRubros.Divisor2, 
                      dbo.tMaestraRubros.PorcentajeMas, dbo.tMaestraRubros.PorcentajeMas2, dbo.tMaestraRubros.MostrarEnElReciboFlag, 
                      dbo.tMaestraRubros.SSOFlag, dbo.tMaestraRubros.ISRFlag
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
SELECT     RubroAsignado, TodaLaCia, Empleado, GrupoEmpleados, Rubro, Descripcion, SuspendidoFlag, OrdenDeAplicacion, Tipo, Periodicidad, Desde, Hasta, 
                      Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, Factor1, Factor2, 
                      Porcentaje, LunesDelMes, Tope, Categoria, AplicaPrestacionesFlag, Cia, Divisor1, Divisor2, PorcentajeMas, PorcentajeMas2, 
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

CREATE VIEW dbo.qFormaRubrosSimplesAsignados
AS
SELECT     RubroAsignado, Empleado, Rubro, Descripcion, SuspendidoFlag, Tipo, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, VariableAAplicar, Factor1, Factor2, 
                      Porcentaje, AplicaPrestacionesFlag, Cia, Divisor1, Divisor2, PorcentajeMas, PorcentajeMas2, MostrarEnElReciboFlag
FROM         dbo.tRubrosAsignados
WHERE          (dbo.tRubrosAsignados.Empleado IS NOT NULL) AND (dbo.tRubrosAsignados.MontoAAplicar IS NOT NULL) OR
                      (dbo.tRubrosAsignados.Empleado IS NOT NULL) AND (dbo.tRubrosAsignados.VariableAAplicar IS NOT NULL)

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
                      dbo.tGruposEmpleados.NombreGrupo AS NombreGrupoEmpleados, dbo.tRubrosAsignados.SuspendidoFlag, dbo.tRubrosAsignados.Rubro, 
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
SELECT     dbo.tRubrosAsignados.RubroAsignado, dbo.tRubrosAsignados.Empleado, dbo.tEmpleados.Nombre AS NombreEmpleado, 
                      dbo.tRubrosAsignados.Rubro, dbo.tMaestraRubros.NombreCortoRubro, dbo.tRubrosAsignados.SuspendidoFlag, dbo.tRubrosAsignados.Descripcion, 
                      dbo.tRubrosAsignados.Tipo, dbo.tRubrosAsignados.Periodicidad, dbo.tRubrosAsignados.Desde, dbo.tRubrosAsignados.Hasta, 
                      dbo.tRubrosAsignados.Siempre, dbo.tRubrosAsignados.MontoAAplicar, dbo.tRubrosAsignados.VariableAAplicar, dbo.tRubrosAsignados.Factor1, dbo.tRubrosAsignados.Factor2, 
                      dbo.tRubrosAsignados.Porcentaje, dbo.tRubrosAsignados.AplicaPrestacionesFlag, dbo.tRubrosAsignados.Cia, dbo.tRubrosAsignados.Divisor1, 
                      dbo.tRubrosAsignados.Divisor2, dbo.tRubrosAsignados.PorcentajeMas, dbo.tRubrosAsignados.PorcentajeMas2, 
                      dbo.tRubrosAsignados.MostrarEnElReciboFlag
FROM         dbo.tRubrosAsignados INNER JOIN
                      dbo.tEmpleados ON dbo.tRubrosAsignados.Empleado = dbo.tEmpleados.Empleado INNER JOIN
                      dbo.tMaestraRubros ON dbo.tMaestraRubros.Rubro = dbo.tRubrosAsignados.Rubro
WHERE          (dbo.tRubrosAsignados.Empleado IS NOT NULL) AND (dbo.tRubrosAsignados.MontoAAplicar IS NOT NULL) OR
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
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.125', GetDate()) 
