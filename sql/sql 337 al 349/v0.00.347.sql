/*    Martes, 9 de Julio de 2.013 	-   v0.00.347.sql 

	Mejoramos estructura de tabla RubrosAsignados 
	
	Nota: los selects que siguen no deben regresar registros: 
	
	Select * From tRubrosAsignados Where Rubro Not In (Select Rubro From tMaestraRubros) 
	Select * From tRubrosAsignados Where Empleado Not In (Select Empleado From tEmpleados) 
	Select * From tRubrosAsignados Where Cia Not In (Select Numero From Companias) 
	
*/


BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tMaestraRubros SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
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
	Tipo nvarchar(1)  NOT NULL,
	SalarioFlag bit NULL,
	TipoNomina nvarchar(10) NOT NULL,
	Periodicidad nvarchar(2) NULL,
	Desde date NULL,
	Hasta date NULL,
	Siempre bit NULL,
	MontoAAplicar money NULL,
	RubroAAplicar int NULL,
	GrupoAAplicar int NULL,
	DeLaNomina nvarchar(2) NULL,
	DeLaNominaDesde smalldatetime NULL,
	DeLaNominaHasta smalldatetime NULL,
	VariableAAplicar tinyint NULL,
	BaseCalculoVariableFlag char(2)  NULL,
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
	MostrarEnElReciboFlag bit NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tRubrosAsignados SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.tRubrosAsignados)
	 EXEC('INSERT INTO dbo.Tmp_tRubrosAsignados (RubroAsignado, TodaLaCia, Empleado, GrupoEmpleados, GrupoNomina, Rubro, Descripcion, SuspendidoFlag, OrdenDeAplicacion, Tipo, TipoNomina, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Divisor1, Divisor2, Porcentaje, PorcentajeMas, PorcentajeMas2, LunesDelMes, Tope, Categoria, MostrarEnElReciboFlag)
		SELECT RubroAsignado, TodaLaCia, Empleado, GrupoEmpleados, GrupoNomina, Rubro, Descripcion, SuspendidoFlag, OrdenDeAplicacion, Tipo, TipoNomina, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Divisor1, Divisor2, Porcentaje, PorcentajeMas, PorcentajeMas2, LunesDelMes, Tope, Categoria, MostrarEnElReciboFlag FROM dbo.tRubrosAsignados WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.tRubrosAsignados
GO
EXECUTE sp_rename N'dbo.Tmp_tRubrosAsignados', N'tRubrosAsignados', 'OBJECT' 
GO
ALTER TABLE dbo.tRubrosAsignados ADD CONSTRAINT
	PK_tRubrosAsignados PRIMARY KEY NONCLUSTERED 
	(
	RubroAsignado
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tRubrosAsignados ADD CONSTRAINT
	FK_tRubrosAsignados_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.tRubrosAsignados ADD CONSTRAINT
	FK_tRubrosAsignados_tMaestraRubros FOREIGN KEY
	(
	Rubro
	) REFERENCES dbo.tMaestraRubros
	(
	Rubro
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT


drop table tRubrosAsignadosID 


BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tRubrosAsignados
	DROP CONSTRAINT FK_tRubrosAsignados_tMaestraRubros
GO
ALTER TABLE dbo.tMaestraRubros SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tRubrosAsignados
	DROP CONSTRAINT FK_tRubrosAsignados_tEmpleados
GO
ALTER TABLE dbo.tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tRubrosAsignados
	(
	RubroAsignado int NOT NULL IDENTITY (1, 1),
	TodaLaCia bit NULL,
	Empleado int NULL,
	GrupoEmpleados int NULL,
	GrupoNomina int NULL,
	Rubro int NOT NULL,
	Descripcion nvarchar(250) NOT NULL,
	SuspendidoFlag bit NULL,
	OrdenDeAplicacion smallint NULL,
	Tipo nvarchar(1) NOT NULL,
	SalarioFlag bit NULL,
	TipoNomina nvarchar(10) NOT NULL,
	Periodicidad nvarchar(2) NULL,
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
	MostrarEnElReciboFlag bit NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tRubrosAsignados SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tRubrosAsignados ON
GO
IF EXISTS(SELECT * FROM dbo.tRubrosAsignados)
	 EXEC('INSERT INTO dbo.Tmp_tRubrosAsignados (RubroAsignado, TodaLaCia, Empleado, GrupoEmpleados, GrupoNomina, Rubro, Descripcion, SuspendidoFlag, OrdenDeAplicacion, Tipo, SalarioFlag, TipoNomina, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Divisor1, Divisor2, Porcentaje, PorcentajeMas, PorcentajeMas2, LunesDelMes, Tope, Categoria, MostrarEnElReciboFlag)
		SELECT RubroAsignado, TodaLaCia, Empleado, GrupoEmpleados, GrupoNomina, Rubro, Descripcion, SuspendidoFlag, OrdenDeAplicacion, Tipo, SalarioFlag, TipoNomina, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Divisor1, Divisor2, Porcentaje, PorcentajeMas, PorcentajeMas2, LunesDelMes, Tope, Categoria, MostrarEnElReciboFlag FROM dbo.tRubrosAsignados WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tRubrosAsignados OFF
GO
DROP TABLE dbo.tRubrosAsignados
GO
EXECUTE sp_rename N'dbo.Tmp_tRubrosAsignados', N'tRubrosAsignados', 'OBJECT' 
GO
ALTER TABLE dbo.tRubrosAsignados ADD CONSTRAINT
	PK_tRubrosAsignados PRIMARY KEY NONCLUSTERED 
	(
	RubroAsignado
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tRubrosAsignados ADD CONSTRAINT
	FK_tRubrosAsignados_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.tRubrosAsignados ADD CONSTRAINT
	FK_tRubrosAsignados_tMaestraRubros FOREIGN KEY
	(
	Rubro
	) REFERENCES dbo.tMaestraRubros
	(
	Rubro
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.347', GetDate()) 