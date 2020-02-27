/*    Martes, 28 de Junio de 2.005   -   v0.00.177.sql 

	Agregamos los views que corresponden a procesos de Prestaciones Sociales 

*/ 


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaPrestacionesSocialesConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaPrestacionesSocialesConsulta]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoPrestacionesSociales]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoPrestacionesSociales]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaPrestacionesSociales]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaPrestacionesSociales]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qFormaPrestacionesSociales    Script Date: 28/11/00 07:01:16 p.m. ******/
CREATE VIEW dbo.qFormaPrestacionesSociales
AS
SELECT     Empleado, Mes, Ano, FechaIngreso, AnosServicio, AnosServicioPrestaciones, PrimerMesPrestacionesFlag, CantidadDiasTrabajadosPrimerMes, 
                      SueldoBasico, SueldoBasicoDiario, DiasVacaciones, BonoVacacional, BonoVacacionalDiario, Utilidades, UtilidadesDiarias, SueldoDiarioAumentado, 
                      DiasPrestaciones, MontoPrestaciones, AnoCumplidoFlag, CantidadDiasAdicionales, MontoPrestacionesDiasAdicionales, Cia
FROM         dbo.PrestacionesSociales

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaPrestacionesSocialesConsulta
AS
SELECT     dbo.PrestacionesSociales.Empleado, dbo.tEmpleados.Nombre AS NombreEmpleado, dbo.PrestacionesSociales.Mes, dbo.PrestacionesSociales.Ano, 
                      dbo.PrestacionesSociales.FechaIngreso, dbo.PrestacionesSociales.AnosServicio, dbo.PrestacionesSociales.AnosServicioPrestaciones, 
                      dbo.PrestacionesSociales.PrimerMesPrestacionesFlag, dbo.PrestacionesSociales.CantidadDiasTrabajadosPrimerMes, 
                      dbo.PrestacionesSociales.SueldoBasico, dbo.PrestacionesSociales.SueldoBasicoDiario, dbo.PrestacionesSociales.DiasVacaciones, 
                      dbo.PrestacionesSociales.BonoVacacional, dbo.PrestacionesSociales.BonoVacacionalDiario, dbo.PrestacionesSociales.Utilidades, 
                      dbo.PrestacionesSociales.UtilidadesDiarias, dbo.PrestacionesSociales.SueldoDiarioAumentado, dbo.PrestacionesSociales.DiasPrestaciones, 
                      dbo.PrestacionesSociales.MontoPrestaciones, dbo.PrestacionesSociales.AnoCumplidoFlag, dbo.PrestacionesSociales.CantidadDiasAdicionales, 
                      dbo.PrestacionesSociales.MontoPrestacionesDiasAdicionales, dbo.PrestacionesSociales.Cia
FROM         dbo.PrestacionesSociales INNER JOIN
                      dbo.tEmpleados ON dbo.PrestacionesSociales.Empleado = dbo.tEmpleados.Empleado AND dbo.PrestacionesSociales.Cia = dbo.tEmpleados.Cia

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoPrestacionesSociales
AS
SELECT     dbo.PrestacionesSociales.Empleado, dbo.tEmpleados.Nombre AS NombreEmpleado, dbo.PrestacionesSociales.Mes, dbo.PrestacionesSociales.Ano, 
                      dbo.PrestacionesSociales.FechaIngreso, dbo.PrestacionesSociales.AnosServicio, dbo.PrestacionesSociales.AnosServicioPrestaciones, 
                      dbo.PrestacionesSociales.PrimerMesPrestacionesFlag, dbo.PrestacionesSociales.CantidadDiasTrabajadosPrimerMes, 
                      dbo.PrestacionesSociales.SueldoBasico, dbo.PrestacionesSociales.SueldoBasicoDiario, dbo.PrestacionesSociales.DiasVacaciones, 
                      dbo.PrestacionesSociales.BonoVacacional, dbo.PrestacionesSociales.BonoVacacionalDiario, dbo.PrestacionesSociales.Utilidades, 
                      dbo.PrestacionesSociales.UtilidadesDiarias, dbo.PrestacionesSociales.SueldoDiarioAumentado, dbo.PrestacionesSociales.DiasPrestaciones, 
                      dbo.PrestacionesSociales.MontoPrestaciones, dbo.PrestacionesSociales.AnoCumplidoFlag, dbo.PrestacionesSociales.CantidadDiasAdicionales, 
                      dbo.PrestacionesSociales.MontoPrestacionesDiasAdicionales, 
                      dbo.PrestacionesSociales.MontoPrestaciones + ISNULL(dbo.PrestacionesSociales.MontoPrestacionesDiasAdicionales, 0) AS TotalPrestaciones, 
                      dbo.PrestacionesSociales.Cia
FROM         dbo.tEmpleados INNER JOIN
                      dbo.PrestacionesSociales ON dbo.tEmpleados.Empleado = dbo.PrestacionesSociales.Empleado

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.177', GetDate()) 

