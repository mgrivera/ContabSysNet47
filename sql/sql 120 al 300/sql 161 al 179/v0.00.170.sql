/*    Miercoles, 11 de Marzo de 2.005   -   v0.00.170.sql 

	Eliminamos los items que corresponden al calculo de las prestaciones sociales
	(pues rediseñamos este proceso) 

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
ALTER TABLE dbo.tRubrosAsignados
	DROP COLUMN AplicaPrestacionesFlag
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.tMaestraRubros
	DROP COLUMN AplicaPrestacionesFlag
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.ParametrosNomina
	DROP COLUMN CalcularPrestacionesFlag, DiasDeIngresoParaCalcularPrestaciones, RubroPrestaciones, PagarPrestacionesCalculadasFlag, CalcularInteresesPrestacionesFlag, PagarInteresesCalculadosFlag, RubroPagarInteresesPrestaciones, RubroRetiroPrestaciones, UsarSalarioPromedioEnPrestacionesFlag, FormulaCalculoPrestaciones
GO
COMMIT


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

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaParametrosNomina]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaParametrosNomina]
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
SELECT     Rubro, NombreCortoRubro, Descripcion, Tipo, TipoNomina, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, 
                      DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Porcentaje, Tope, LunesDelMes, 
                      Categoria, Divisor1, Divisor2, PorcentajeMas, PorcentajeMas2, MostrarEnElReciboFlag, SSOFlag, ISRFlag
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
                      dbo.tMaestraRubros.Tope, dbo.tMaestraRubros.Categoria, dbo.tMaestraRubros.Divisor1, dbo.tMaestraRubros.Divisor2, 
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

CREATE VIEW dbo.qFormaParametrosNomina
AS
SELECT     LimiteProrrateoVacaciones, AgregarAsientosContables, OrganizarPartidasDelAsiento, TipoAsientoDefault, CuentaContableNomina, 
                      MonedaParaElAsiento, SumarizarPartidaAsientoContable, Cia
FROM         dbo.ParametrosNomina

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
SELECT     RubroAsignado, TodaLaCia, Empleado, GrupoEmpleados, GrupoNomina, Rubro, Descripcion, SuspendidoFlag, OrdenDeAplicacion, Tipo, TipoNomina, 
                      Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, 
                      VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Porcentaje, LunesDelMes, Tope, Categoria, Cia, Divisor1, Divisor2, PorcentajeMas, 
                      PorcentajeMas2, MostrarEnElReciboFlag
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
                      MontoAAplicar, VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Porcentaje, Cia, Divisor1, Divisor2, PorcentajeMas, PorcentajeMas2, 
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
                      dbo.tRubrosAsignados.Siempre, dbo.tRubrosAsignados.MontoAAplicar, dbo.tRubrosAsignados.VariableAAplicar, dbo.tRubrosAsignados.TipoNomina, 
                      dbo.tRubrosAsignados.Factor1, dbo.tRubrosAsignados.Factor2, dbo.tRubrosAsignados.Porcentaje, dbo.tRubrosAsignados.Cia, 
                      dbo.tRubrosAsignados.Divisor1, dbo.tRubrosAsignados.Divisor2, dbo.tRubrosAsignados.PorcentajeMas, dbo.tRubrosAsignados.PorcentajeMas2, 
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
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.170', GetDate()) 

