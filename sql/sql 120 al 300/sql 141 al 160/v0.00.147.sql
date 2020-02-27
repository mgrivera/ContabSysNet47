/*    Lunes 10 de Febrero de 2003   -   v0.00.147.sql 

	Agregamos, nuevamente, algunos cambios a la tabla Vacaciones para implementar el 
	cálculo de las vacaciones en forma automática. 

*/ 


--  ------------------------
--  Vacaciones
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
ALTER TABLE dbo.Vacaciones
	DROP CONSTRAINT FK_Vacaciones_tEmpleados
GO
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.Tmp_Vacaciones
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	Empleado int NOT NULL,
	GrupoNomina int NOT NULL,
	TipoNomina char(1) NOT NULL,
	FechaIngreso smalldatetime NOT NULL,
	AnosServicio smallmoney NOT NULL,
	SalarioPromedio money NULL,
	SueldoBasico money NULL,
	AnoVacacionesDesde smalldatetime NOT NULL,
	AnoVacacionesHasta smalldatetime NOT NULL,
	AnoVacaciones smallint NULL,
	Salida datetime NOT NULL,
	Regreso smalldatetime NOT NULL,
	DiasDisfrutados tinyint NOT NULL,
	FechaReintegro smalldatetime NOT NULL,
	FraccionAntesDesde smalldatetime NULL,
	FraccionAntesHasta smalldatetime NULL,
	CantDiasFraccionAntes tinyint NULL,
	FraccionDespuesDesde smalldatetime NULL,
	FraccionDespuesHasta smalldatetime NULL,
	FechaNomina smalldatetime NOT NULL,
	CantDiasFraccionDespues tinyint NULL,
	MontoBono money NOT NULL,
	FechaPagoBono smalldatetime NOT NULL,
	ObviarEnLaNominaFlag bit NULL,
	CantDiasHabiles tinyint NULL,
	CantDiasBono tinyint NULL,
	CantDiasAdicionales tinyint NULL,
	CantDiasFeriados tinyint NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
SET IDENTITY_INSERT dbo.Tmp_Vacaciones ON
GO
IF EXISTS(SELECT * FROM dbo.Vacaciones)
	 EXEC('INSERT INTO dbo.Tmp_Vacaciones (ClaveUnica, Empleado, GrupoNomina, TipoNomina, FechaIngreso, AnosServicio, SalarioPromedio, SueldoBasico, AnoVacacionesDesde, AnoVacacionesHasta, AnoVacaciones, Salida, Regreso, DiasDisfrutados, FechaReintegro, FraccionAntesDesde, FraccionAntesHasta, CantDiasFraccionAntes, FraccionDespuesDesde, FraccionDespuesHasta, FechaNomina, CantDiasFraccionDespues, MontoBono, FechaPagoBono, ObviarEnLaNominaFlag, Cia)
		SELECT ClaveUnica, Empleado, GrupoNomina, TipoNomina, FechaIngreso, AnosServicio, SalarioPromedio, SueldoBasico, AnoVacacionesDesde, AnoVacacionesHasta, AnoVacaciones, Salida, Regreso, DiasDisfrutados, FechaReintegro, FraccionAntesDesde, FraccionAntesHasta, CantDiasFraccionAntes, FraccionDespuesDesde, FraccionDespuesHasta, FechaNomina, CantDiasFraccionDespues, MontoBono, FechaPagoBono, ObviarEnLaNominaFlag, Cia FROM dbo.Vacaciones TABLOCKX')
GO
SET IDENTITY_INSERT dbo.Tmp_Vacaciones OFF
GO
DROP TABLE dbo.Vacaciones
GO
EXECUTE sp_rename N'dbo.Tmp_Vacaciones', N'Vacaciones', 'OBJECT'
GO
ALTER TABLE dbo.Vacaciones ADD CONSTRAINT
	PK_Vacaciones PRIMARY KEY NONCLUSTERED 
	(
	ClaveUnica
	) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_Vacaciones ON dbo.Vacaciones
	(
	Empleado
	) ON [PRIMARY]
GO
ALTER TABLE dbo.Vacaciones ADD CONSTRAINT
	IX_Vacaciones_1 UNIQUE NONCLUSTERED 
	(
	Empleado,
	GrupoNomina,
	FechaNomina,
	Cia
	) ON [PRIMARY]

GO
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
--  qFormaControlVacaciones y qFormaControlVacacionesConsulta
--  -----------------------------------------------------------


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
SELECT     ClaveUnica, Empleado, GrupoNomina, TipoNomina, FechaIngreso, AnosServicio, SalarioPromedio, SueldoBasico, 
                      AnoVacacionesDesde, AnoVacacionesHasta, AnoVacaciones, Salida, Regreso, DiasDisfrutados, 
                      FechaReintegro, FraccionAntesDesde, FraccionAntesHasta, CantDiasFraccionAntes, FraccionDespuesDesde, FraccionDespuesHasta, 
                      CantDiasFraccionDespues, FechaNomina, MontoBono, FechaPagoBono, ObviarEnLaNominaFlag, CantDiasHabiles, CantDiasBono, 
                      CantDiasAdicionales, CantDiasFeriados, Cia
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
                      dbo.Vacaciones.SalarioPromedio, dbo.Vacaciones.SueldoBasico,
                      dbo.Vacaciones.AnoVacacionesDesde, dbo.Vacaciones.AnoVacacionesHasta, dbo.Vacaciones.AnoVacaciones, dbo.Vacaciones.FechaReintegro, 
                      dbo.Vacaciones.FraccionAntesDesde, dbo.Vacaciones.FraccionAntesHasta, dbo.Vacaciones.CantDiasFraccionAntes, 
                      dbo.Vacaciones.FraccionDespuesDesde, dbo.Vacaciones.FraccionDespuesHasta, dbo.Vacaciones.CantDiasFraccionDespues, 
                      dbo.Vacaciones.FechaNomina, dbo.Vacaciones.ObviarEnLaNominaFlag, dbo.Vacaciones.CantDiasHabiles, dbo.Vacaciones.CantDiasBono, 
                      dbo.Vacaciones.CantDiasAdicionales, dbo.Vacaciones.CantDiasFeriados, dbo.Vacaciones.Cia
FROM         dbo.Vacaciones INNER JOIN
                      dbo.tGruposEmpleados ON dbo.Vacaciones.Cia = dbo.tGruposEmpleados.Cia AND 
                      dbo.Vacaciones.GrupoNomina = dbo.tGruposEmpleados.Grupo LEFT OUTER JOIN
                      dbo.tEmpleados ON dbo.Vacaciones.Empleado = dbo.tEmpleados.Empleado AND dbo.Vacaciones.Cia = dbo.tEmpleados.Cia

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

--  --------------------------------------------------------------------
--  Vacaciones: ahora los items FechaPagoBono y MontoBono pueden ser Nulls
--  --------------------------------------------------------------------


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
	DROP CONSTRAINT FK_Vacaciones_tEmpleados
GO
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.Tmp_Vacaciones
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	Empleado int NOT NULL,
	GrupoNomina int NOT NULL,
	TipoNomina char(1) NOT NULL,
	FechaIngreso smalldatetime NOT NULL,
	AnosServicio smallmoney NOT NULL,
	SalarioPromedio money NULL,
	SueldoBasico money NULL,
	AnoVacacionesDesde smalldatetime NOT NULL,
	AnoVacacionesHasta smalldatetime NOT NULL,
	AnoVacaciones smallint NULL,
	Salida datetime NOT NULL,
	Regreso smalldatetime NOT NULL,
	DiasDisfrutados tinyint NOT NULL,
	FechaReintegro smalldatetime NOT NULL,
	FraccionAntesDesde smalldatetime NULL,
	FraccionAntesHasta smalldatetime NULL,
	CantDiasFraccionAntes tinyint NULL,
	FraccionDespuesDesde smalldatetime NULL,
	FraccionDespuesHasta smalldatetime NULL,
	FechaNomina smalldatetime NOT NULL,
	CantDiasFraccionDespues tinyint NULL,
	MontoBono money NULL,
	FechaPagoBono smalldatetime NULL,
	ObviarEnLaNominaFlag bit NULL,
	CantDiasHabiles tinyint NULL,
	CantDiasBono tinyint NULL,
	CantDiasAdicionales tinyint NULL,
	CantDiasFeriados tinyint NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
SET IDENTITY_INSERT dbo.Tmp_Vacaciones ON
GO
IF EXISTS(SELECT * FROM dbo.Vacaciones)
	 EXEC('INSERT INTO dbo.Tmp_Vacaciones (ClaveUnica, Empleado, GrupoNomina, TipoNomina, FechaIngreso, AnosServicio, SalarioPromedio, SueldoBasico, AnoVacacionesDesde, AnoVacacionesHasta, AnoVacaciones, Salida, Regreso, DiasDisfrutados, FechaReintegro, FraccionAntesDesde, FraccionAntesHasta, CantDiasFraccionAntes, FraccionDespuesDesde, FraccionDespuesHasta, FechaNomina, CantDiasFraccionDespues, MontoBono, FechaPagoBono, ObviarEnLaNominaFlag, CantDiasHabiles, CantDiasBono, CantDiasAdicionales, CantDiasFeriados, Cia)
		SELECT ClaveUnica, Empleado, GrupoNomina, TipoNomina, FechaIngreso, AnosServicio, SalarioPromedio, SueldoBasico, AnoVacacionesDesde, AnoVacacionesHasta, AnoVacaciones, Salida, Regreso, DiasDisfrutados, FechaReintegro, FraccionAntesDesde, FraccionAntesHasta, CantDiasFraccionAntes, FraccionDespuesDesde, FraccionDespuesHasta, FechaNomina, CantDiasFraccionDespues, MontoBono, FechaPagoBono, ObviarEnLaNominaFlag, CantDiasHabiles, CantDiasBono, CantDiasAdicionales, CantDiasFeriados, Cia FROM dbo.Vacaciones TABLOCKX')
GO
SET IDENTITY_INSERT dbo.Tmp_Vacaciones OFF
GO
DROP TABLE dbo.Vacaciones
GO
EXECUTE sp_rename N'dbo.Tmp_Vacaciones', N'Vacaciones', 'OBJECT'
GO
ALTER TABLE dbo.Vacaciones ADD CONSTRAINT
	PK_Vacaciones PRIMARY KEY NONCLUSTERED 
	(
	ClaveUnica
	) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_Vacaciones ON dbo.Vacaciones
	(
	Empleado
	) ON [PRIMARY]
GO
ALTER TABLE dbo.Vacaciones ADD CONSTRAINT
	IX_Vacaciones_1 UNIQUE NONCLUSTERED 
	(
	Empleado,
	GrupoNomina,
	FechaNomina,
	Cia
	) ON [PRIMARY]

GO
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



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.147', GetDate()) 

