/*    Lunes, 25 de Febrero de 2.005   -   v0.00.168.sql 

	Agregamos la tabla ParametrosProcesoLPHNomina. 

*/ 


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ParametrosProcesoLPHNomina]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ParametrosProcesoLPHNomina]
GO

CREATE TABLE [dbo].[ParametrosProcesoLPHNomina] (
	[ClavePrimaria] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[PorcentajeAporteEmpleados] [float] NOT NULL ,
	[PorcentajeAporteEmpresa] [float] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ParametrosProcesoLPHNomina] WITH NOCHECK ADD 
	CONSTRAINT [PK_ParametrosProcesoLPHNomina] PRIMARY KEY  CLUSTERED 
	(
		[ClavePrimaria]
	)  ON [PRIMARY] 
GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoLeyPoliticaHabitacional]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoLeyPoliticaHabitacional]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoLeyPoliticaHabitacional
AS
SELECT     Nombre, Status, SituacionActual, Cedula, FechaNacimiento, Sexo, SueldoBasico, Cia
FROM         dbo.tEmpleados

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.168', GetDate()) 

