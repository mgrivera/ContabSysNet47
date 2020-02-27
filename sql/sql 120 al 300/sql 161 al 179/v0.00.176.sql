/*    Miércoles, 22 de Junio de 2.005   -   v0.00.176.sql 

	Modificamos levemente la tabla PrestacionesSociales

*/ 

Delete From PrestacionesSociales

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
CREATE TABLE dbo.Tmp_PrestacionesSociales
	(
	Empleado int NOT NULL,
	Mes smallint NOT NULL,
	Ano smallint NOT NULL,
	FechaIngreso smalldatetime NOT NULL,
	AnosServicio smallint NOT NULL,
	AnosServicioPrestaciones smallint NOT NULL,
	PrimerMesPrestacionesFlag bit NOT NULL,
	CantidadDiasTrabajadosPrimerMes tinyint NULL,
	SueldoBasico money NOT NULL,
	SueldoBasicoDiario money NOT NULL,
	DiasVacaciones smallint NOT NULL,
	BonoVacacional money NOT NULL,
	BonoVacacionalDiario money NOT NULL,
	Utilidades money NOT NULL,
	UtilidadesDiarias money NOT NULL,
	SueldoDiarioAumentado money NOT NULL,
	DiasPrestaciones smallint NOT NULL,
	MontoPrestaciones money NOT NULL,
	AnoCumplidoFlag bit NOT NULL,
	CantidadDiasAdicionales tinyint NULL,
	MontoPrestacionesDiasAdicionales money NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.PrestacionesSociales)
	 EXEC('INSERT INTO dbo.Tmp_PrestacionesSociales (Empleado, Mes, Ano, FechaIngreso, AnosServicio, AnosServicioPrestaciones, SueldoBasico, SueldoBasicoDiario, DiasVacaciones, BonoVacacional, BonoVacacionalDiario, Utilidades, UtilidadesDiarias, SueldoDiarioAumentado, DiasPrestaciones, MontoPrestaciones, Cia)
		SELECT Empleado, Mes, Ano, FechaIngreso, AnosServicio, AnosServicioPrestaciones, SueldoBasico, SueldoBasicoDiario, DiasVacaciones, BonoVacacional, BonoVacacionalDiario, Utilidades, UtilidadesDiarias, SueldoDiarioAumentado, DiasPrestaciones, MontoPrestaciones, Cia FROM dbo.PrestacionesSociales TABLOCKX')
GO
DROP TABLE dbo.PrestacionesSociales
GO
EXECUTE sp_rename N'dbo.Tmp_PrestacionesSociales', N'PrestacionesSociales', 'OBJECT'
GO
ALTER TABLE dbo.PrestacionesSociales ADD CONSTRAINT
	PK_borre1 PRIMARY KEY CLUSTERED 
	(
	Empleado,
	Mes,
	Ano,
	Cia
	) ON [PRIMARY]

GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.176', GetDate()) 

