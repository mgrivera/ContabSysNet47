/*    Lunes, 29 de Agosto de 2.005   -   v0.00.180a.sql 

	Cambios proceso Vacaciones: agregamos el item: NumeroVacaciones y eliminamos 
	los items: AnoVacacionesDesde, AnoVacacionesHasta 

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
	NumeroVacaciones tinyint NULL,
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


Update Vacaciones Set AnoVacaciones = DatePart(year, AnoVacacionesDesde) 
	Where AnoVacacionesDesde Is Not Null 

Update Vacaciones Set AnoVacaciones = 1990 
	Where AnoVacacionesDesde Is Null 

Update Vacaciones Set NumeroVacaciones = 1




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.180a', GetDate()) 