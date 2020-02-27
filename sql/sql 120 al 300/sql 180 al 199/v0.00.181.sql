/*    Miercoles, 31 de Agosto de 2.005   -   v0.00.181.sql 

	Views que corresponden al Control de Vacaciones. 

*/ 


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
SELECT     ClaveUnica, Empleado, GrupoNomina, TipoNomina, FechaIngreso, AnosServicio, SalarioPromedio, SueldoBasico, AnoVacaciones, NumeroVacaciones, 
                      Salida, Regreso, DiasDisfrutados, FechaReintegro, FraccionAntesDesde, FraccionAntesHasta, CantDiasFraccionAntes, FraccionDespuesDesde, 
                      FraccionDespuesHasta, CantDiasFraccionDespues, FechaNomina, MontoBono, FechaPagoBono, ObviarEnLaNominaFlag, CantDiasTrabajados, 
                      CantDiasAnticipo, CantDiasBono, CantDiasAdicionales, CantDiasFeriados, CantDiasVacSegunTabla, CantDiasVacDisfrutadosAntes, 
                      CantDiasVacDisfrutadosAhora, CantDiasVacPendientes, AdelantoSueldoFlag, BonoVacacionalFlag, DesactivarNominaDesde, DesactivarNominaHasta, 
                      Cia
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
SELECT     dbo.Vacaciones.Empleado, dbo.Vacaciones.GrupoNomina, dbo.tGruposEmpleados.NombreGrupo, dbo.tEmpleados.Nombre AS NombreEmpleado, 
                      dbo.Vacaciones.Salida, dbo.Vacaciones.Regreso, dbo.Vacaciones.DiasDisfrutados, dbo.Vacaciones.MontoBono, dbo.Vacaciones.FechaPagoBono, 
                      dbo.Vacaciones.ClaveUnica, dbo.Vacaciones.TipoNomina, dbo.Vacaciones.FechaIngreso, dbo.Vacaciones.AnosServicio, 
                      dbo.Vacaciones.SalarioPromedio, dbo.Vacaciones.SueldoBasico, dbo.Vacaciones.AnoVacaciones, dbo.Vacaciones.FechaReintegro, 
                      dbo.Vacaciones.FraccionAntesDesde, dbo.Vacaciones.FraccionAntesHasta, dbo.Vacaciones.CantDiasFraccionAntes, 
                      dbo.Vacaciones.FraccionDespuesDesde, dbo.Vacaciones.FraccionDespuesHasta, dbo.Vacaciones.CantDiasFraccionDespues, 
                      dbo.Vacaciones.FechaNomina, dbo.Vacaciones.ObviarEnLaNominaFlag, dbo.Vacaciones.CantDiasBono, dbo.Vacaciones.CantDiasAdicionales, 
                      dbo.Vacaciones.CantDiasFeriados, dbo.Vacaciones.Cia, dbo.Vacaciones.NumeroVacaciones, dbo.Vacaciones.CantDiasTrabajados, 
                      dbo.Vacaciones.CantDiasAnticipo, dbo.Vacaciones.CantDiasVacSegunTabla, dbo.Vacaciones.CantDiasVacDisfrutadosAntes, 
                      dbo.Vacaciones.CantDiasVacDisfrutadosAhora, dbo.Vacaciones.CantDiasVacPendientes, dbo.Vacaciones.AdelantoSueldoFlag, 
                      dbo.Vacaciones.BonoVacacionalFlag, dbo.Vacaciones.DesactivarNominaDesde, dbo.Vacaciones.DesactivarNominaHasta
FROM         dbo.Vacaciones INNER JOIN
                      dbo.tGruposEmpleados ON dbo.Vacaciones.Cia = dbo.tGruposEmpleados.Cia AND 
                      dbo.Vacaciones.GrupoNomina = dbo.tGruposEmpleados.Grupo LEFT OUTER JOIN
                      dbo.tEmpleados ON dbo.Vacaciones.Empleado = dbo.tEmpleados.Empleado AND dbo.Vacaciones.Cia = dbo.tEmpleados.Cia

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.181', GetDate()) 