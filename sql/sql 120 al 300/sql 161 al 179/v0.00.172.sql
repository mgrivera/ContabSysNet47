/*    Domingo, 13 de Marzo de 2.005   -   v0.00.172.sql 

	Agregamos las tablas y consultas que corresponden a la forma de mantenimineto 
	de las prestaciones sociales 

*/ 


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaPrestacionesSocialesConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaPrestacionesSocialesConsulta]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaPrestacionesSociales]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaPrestacionesSociales]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PrestacionesSociales]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PrestacionesSociales]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tParametrosPrestacionesSociales]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tParametrosPrestacionesSociales]
GO

CREATE TABLE [dbo].[PrestacionesSociales] (
	[Empleado] [int] NOT NULL ,
	[Mes] [smallint] NOT NULL ,
	[Ano] [smallint] NOT NULL ,
	[FechaIngreso] [smalldatetime] NOT NULL ,
	[AnosServicio] [smallint] NOT NULL ,
	[AnosServicioPrestaciones] [smallint] NOT NULL ,
	[Prorrata] [float] NOT NULL ,
	[SueldoBasico] [money] NOT NULL ,
	[SueldoBasicoDiario] [money] NOT NULL ,
	[DiasVacaciones] [smallint] NOT NULL ,
	[BonoVacacional] [money] NOT NULL ,
	[BonoVacacionalDiario] [money] NOT NULL ,
	[Utilidades] [money] NOT NULL ,
	[UtilidadesDiarias] [money] NOT NULL ,
	[SueldoDiarioAumentado] [money] NOT NULL ,
	[DiasPrestaciones] [smallint] NOT NULL ,
	[MontoPrestaciones] [money] NOT NULL ,
	[Cia] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tParametrosPrestacionesSociales] (
	[ClavePrimaria] [int] IDENTITY (1, 1) NOT NULL ,
	[RubroSueldoBasico1] [int] NULL ,
	[RubroSueldoBasico2] [int] NULL ,
	[RubroSueldoBasico3] [int] NULL ,
	[UsarSueldoEnMaestraEmpleadosFlag] [bit] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PrestacionesSociales] WITH NOCHECK ADD 
	CONSTRAINT [PK_borre1] PRIMARY KEY  CLUSTERED 
	(
		[Empleado],
		[Mes],
		[Ano],
		[Cia]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tParametrosPrestacionesSociales] WITH NOCHECK ADD 
	CONSTRAINT [PK_tParametrosPrestacionesSociales] PRIMARY KEY  CLUSTERED 
	(
		[ClavePrimaria]
	)  ON [PRIMARY] 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qFormaPrestacionesSociales    Script Date: 28/11/00 07:01:16 p.m. ******/
CREATE VIEW dbo.qFormaPrestacionesSociales
AS
SELECT     Empleado, Mes, Ano, FechaIngreso, AnosServicio, AnosServicioPrestaciones, Prorrata, SueldoBasico, SueldoBasicoDiario, DiasVacaciones, 
                      BonoVacacional, BonoVacacionalDiario, Utilidades, UtilidadesDiarias, SueldoDiarioAumentado, DiasPrestaciones, MontoPrestaciones, Cia
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
                      dbo.PrestacionesSociales.Prorrata, dbo.PrestacionesSociales.SueldoBasico, dbo.PrestacionesSociales.SueldoBasicoDiario, 
                      dbo.PrestacionesSociales.DiasVacaciones, dbo.PrestacionesSociales.BonoVacacional, dbo.PrestacionesSociales.BonoVacacionalDiario, 
                      dbo.PrestacionesSociales.Utilidades, dbo.PrestacionesSociales.UtilidadesDiarias, dbo.PrestacionesSociales.SueldoDiarioAumentado, 
                      dbo.PrestacionesSociales.DiasPrestaciones, dbo.PrestacionesSociales.MontoPrestaciones, dbo.PrestacionesSociales.Cia
FROM         dbo.PrestacionesSociales INNER JOIN
                      dbo.tEmpleados ON dbo.PrestacionesSociales.Empleado = dbo.tEmpleados.Empleado AND dbo.PrestacionesSociales.Cia = dbo.tEmpleados.Cia

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.172', GetDate()) 

