/*    Sábado, 28 de Septiembre de 2.013 	-   v0.00.357.sql 

	 Nómina: Agregamos las tablas para la definición de anticipos 
	 
	 NOTA IMPORTANTE: 
	 
	 vamos a inicializar como Sueldo el rubro que corresponde al adelanto de sueldo 
	 en la 1ra. quincena ... 
	 
	 (en Lockton) 
	 
	 (para saber cual es el rubro - 21 en Lockton) 
	 Select * From tMaestraRubros Where NombreCortoRubro = 'ADELS' 
	 
	 (para actualizar el rubro )
	 Update n Set n.SueldoFlag = 1
	 From tNomina n Inner Join tNominaHeaders h On n.HeaderID = h.ID
	 Where h.FechaNomina >= '20130101' and n.Rubro = 21 
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
ALTER TABLE dbo.tGruposEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Nomina_DefinicionAnticipos
	(
	ID int NOT NULL IDENTITY (1, 1),
	GrupoNomina int NOT NULL,
	Desde date NOT NULL,
	Suspendido bit NOT NULL,
	PrimQuincPorc decimal(5, 2) NULL,
	SegQuincPorc decimal(5, 2) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Nomina_DefinicionAnticipos ADD CONSTRAINT
	PK_Nomina_DefinicionAnticipos PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Nomina_DefinicionAnticipos ADD CONSTRAINT
	FK_Nomina_DefinicionAnticipos_tGruposEmpleados FOREIGN KEY
	(
	GrupoNomina
	) REFERENCES dbo.tGruposEmpleados
	(
	Grupo
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Nomina_DefinicionAnticipos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Nomina_DefinicionAnticipos_Empleados
	(
	ID int NOT NULL IDENTITY (1, 1),
	DefinicionAnticiposID int NOT NULL,
	Empleado int NOT NULL,
	Suspendido bit NOT NULL,
	PrimQuincPorc decimal(5, 2) NULL,
	SegQuincPorc decimal(5, 2) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Nomina_DefinicionAnticipos_Empleados ADD CONSTRAINT
	PK_Nomina_DefinicionAnticipos_Empleados PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Nomina_DefinicionAnticipos_Empleados ADD CONSTRAINT
	FK_Nomina_DefinicionAnticipos_Empleados_Nomina_DefinicionAnticipos FOREIGN KEY
	(
	DefinicionAnticiposID
	) REFERENCES dbo.Nomina_DefinicionAnticipos
	(
	ID
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Nomina_DefinicionAnticipos_Empleados ADD CONSTRAINT
	FK_Nomina_DefinicionAnticipos_Empleados_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Nomina_DefinicionAnticipos_Empleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT




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
ALTER TABLE dbo.Nomina_DefinicionAnticipos
	DROP COLUMN SegQuincPorc
GO
ALTER TABLE dbo.Nomina_DefinicionAnticipos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Nomina_DefinicionAnticipos_Empleados
	DROP COLUMN SegQuincPorc
GO
ALTER TABLE dbo.Nomina_DefinicionAnticipos_Empleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT













/* desde aquí para Lockton ... (agregamos Factor a la tabla tNomina) */ 

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
ALTER TABLE dbo.tNomina
	DROP CONSTRAINT FK_tNomina_tNominaHeaders
GO
ALTER TABLE dbo.tNominaHeaders SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tNomina
	DROP CONSTRAINT FK_tNomina_tMaestraRubros
GO
ALTER TABLE dbo.tMaestraRubros SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tNomina
	DROP CONSTRAINT FK_tNomina_tEmpleados
GO
ALTER TABLE dbo.tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tNomina
	(
	NumeroUnico int NOT NULL IDENTITY (1, 1),
	HeaderID int NOT NULL,
	Empleado int NOT NULL,
	Rubro int NOT NULL,
	Tipo nvarchar(1) NOT NULL,
	Descripcion nvarchar(250) NOT NULL,
	Monto money NOT NULL,
	AplicaPrestacionesFlag bit NULL,
	MostrarEnElReciboFlag bit NULL,
	MontoBase money NULL,
	CantDias tinyint NULL,
	Fraccion decimal(6, 3) NULL,
	SueldoFlag bit NOT NULL,
	SalarioFlag bit NOT NULL,
	VacFraccionFlag char(1) NULL,
	FraccionarFlag bit NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tNomina SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tNomina ON
GO
IF EXISTS(SELECT * FROM dbo.tNomina)
	 EXEC('INSERT INTO dbo.Tmp_tNomina (NumeroUnico, HeaderID, Empleado, Rubro, Tipo, Descripcion, Monto, AplicaPrestacionesFlag, MostrarEnElReciboFlag, MontoBase, CantDias, SueldoFlag, SalarioFlag, VacFraccionFlag, FraccionarFlag)
		SELECT NumeroUnico, HeaderID, Empleado, Rubro, Tipo, Descripcion, Monto, AplicaPrestacionesFlag, MostrarEnElReciboFlag, MontoBase, CantDias, SueldoFlag, SalarioFlag, VacFraccionFlag, FraccionarFlag FROM dbo.tNomina WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tNomina OFF
GO
DROP TABLE dbo.tNomina
GO
EXECUTE sp_rename N'dbo.Tmp_tNomina', N'tNomina', 'OBJECT' 
GO
ALTER TABLE dbo.tNomina ADD CONSTRAINT
	PK_tNomina PRIMARY KEY NONCLUSTERED 
	(
	NumeroUnico
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tNomina ADD CONSTRAINT
	FK_tNomina_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tNomina ADD CONSTRAINT
	FK_tNomina_tMaestraRubros FOREIGN KEY
	(
	Rubro
	) REFERENCES dbo.tMaestraRubros
	(
	Rubro
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tNomina ADD CONSTRAINT
	FK_tNomina_tNominaHeaders FOREIGN KEY
	(
	HeaderID
	) REFERENCES dbo.tNominaHeaders
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
COMMIT


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
ALTER TABLE dbo.tNomina
	DROP CONSTRAINT FK_tNomina_tNominaHeaders
GO
ALTER TABLE dbo.tNominaHeaders SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tNomina
	DROP CONSTRAINT FK_tNomina_tMaestraRubros
GO
ALTER TABLE dbo.tRubrosAsignados
	DROP CONSTRAINT FK_tRubrosAsignados_tMaestraRubros
GO
ALTER TABLE dbo.tMaestraRubros SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tNomina
	DROP CONSTRAINT FK_tNomina_tEmpleados
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
	SuspendidoFlag bit NOT NULL,
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
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tNomina
	(
	NumeroUnico int NOT NULL IDENTITY (1, 1),
	HeaderID int NOT NULL,
	Empleado int NOT NULL,
	Rubro int NOT NULL,
	Tipo nvarchar(2) NOT NULL,
	Descripcion nvarchar(250) NOT NULL,
	Monto money NOT NULL,
	AplicaPrestacionesFlag bit NULL,
	MostrarEnElReciboFlag bit NULL,
	MontoBase money NULL,
	CantDias tinyint NULL,
	Fraccion decimal(6, 3) NULL,
	SueldoFlag bit NOT NULL,
	SalarioFlag bit NOT NULL,
	VacFraccionFlag char(1) NULL,
	FraccionarFlag bit NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tNomina SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tNomina ON
GO
IF EXISTS(SELECT * FROM dbo.tNomina)
	 EXEC('INSERT INTO dbo.Tmp_tNomina (NumeroUnico, HeaderID, Empleado, Rubro, Tipo, Descripcion, Monto, AplicaPrestacionesFlag, MostrarEnElReciboFlag, MontoBase, CantDias, Fraccion, SueldoFlag, SalarioFlag, VacFraccionFlag, FraccionarFlag)
		SELECT NumeroUnico, HeaderID, Empleado, Rubro, Tipo, Descripcion, Monto, AplicaPrestacionesFlag, MostrarEnElReciboFlag, MontoBase, CantDias, Fraccion, SueldoFlag, SalarioFlag, VacFraccionFlag, FraccionarFlag FROM dbo.tNomina WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tNomina OFF
GO
DROP TABLE dbo.tNomina
GO
EXECUTE sp_rename N'dbo.Tmp_tNomina', N'tNomina', 'OBJECT' 
GO
ALTER TABLE dbo.tNomina ADD CONSTRAINT
	PK_tNomina PRIMARY KEY NONCLUSTERED 
	(
	NumeroUnico
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tNomina ADD CONSTRAINT
	FK_tNomina_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tNomina ADD CONSTRAINT
	FK_tNomina_tMaestraRubros FOREIGN KEY
	(
	Rubro
	) REFERENCES dbo.tMaestraRubros
	(
	Rubro
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tNomina ADD CONSTRAINT
	FK_tNomina_tNominaHeaders FOREIGN KEY
	(
	HeaderID
	) REFERENCES dbo.tNominaHeaders
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
COMMIT

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
ALTER TABLE dbo.tNominaHeaders
	DROP CONSTRAINT FK_tNominaHeaders_tGruposEmpleados
GO
ALTER TABLE dbo.tGruposEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tNomina
	DROP CONSTRAINT FK_tNomina_tMaestraRubros
GO
ALTER TABLE dbo.tMaestraRubros SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tNomina
	DROP CONSTRAINT FK_tNomina_tEmpleados
GO
ALTER TABLE dbo.tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tNominaHeaders
	(
	ID int NOT NULL IDENTITY (1, 1),
	FechaNomina date NOT NULL,
	FechaEjecucion datetime2(7) NOT NULL,
	GrupoNomina int NOT NULL,
	Desde date NULL,
	Hasta date NULL,
	CantidadDias smallint NULL,
	Tipo nvarchar(2) NOT NULL,
	AgregarSueldo bit NOT NULL,
	AgregarDeduccionesObligatorias bit NOT NULL,
	ProvieneDe nvarchar(50) NULL,
	ProvieneDe_ID int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tNominaHeaders SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tNominaHeaders ON
GO
IF EXISTS(SELECT * FROM dbo.tNominaHeaders)
	 EXEC('INSERT INTO dbo.Tmp_tNominaHeaders (ID, FechaNomina, FechaEjecucion, GrupoNomina, Desde, Hasta, CantidadDias, Tipo, AgregarSueldo, AgregarDeduccionesObligatorias, ProvieneDe, ProvieneDe_ID)
		SELECT ID, FechaNomina, FechaEjecucion, GrupoNomina, Desde, Hasta, CantidadDias, Tipo, AgregarSueldo, AgregarDeduccionesObligatorias, ProvieneDe, ProvieneDe_ID FROM dbo.tNominaHeaders WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tNominaHeaders OFF
GO
ALTER TABLE dbo.tNomina
	DROP CONSTRAINT FK_tNomina_tNominaHeaders
GO
DROP TABLE dbo.tNominaHeaders
GO
EXECUTE sp_rename N'dbo.Tmp_tNominaHeaders', N'tNominaHeaders', 'OBJECT' 
GO
ALTER TABLE dbo.tNominaHeaders ADD CONSTRAINT
	PK_tNominaHeaders PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tNominaHeaders ADD CONSTRAINT
	FK_tNominaHeaders_tGruposEmpleados FOREIGN KEY
	(
	GrupoNomina
	) REFERENCES dbo.tGruposEmpleados
	(
	Grupo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tNomina
	(
	NumeroUnico int NOT NULL IDENTITY (1, 1),
	HeaderID int NOT NULL,
	Empleado int NOT NULL,
	Rubro int NOT NULL,
	Tipo nvarchar(1) NOT NULL,
	Descripcion nvarchar(250) NOT NULL,
	Monto money NOT NULL,
	AplicaPrestacionesFlag bit NULL,
	MostrarEnElReciboFlag bit NULL,
	MontoBase money NULL,
	CantDias tinyint NULL,
	Fraccion decimal(6, 3) NULL,
	SueldoFlag bit NOT NULL,
	SalarioFlag bit NOT NULL,
	VacFraccionFlag char(1) NULL,
	FraccionarFlag bit NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tNomina SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tNomina ON
GO
IF EXISTS(SELECT * FROM dbo.tNomina)
	 EXEC('INSERT INTO dbo.Tmp_tNomina (NumeroUnico, HeaderID, Empleado, Rubro, Tipo, Descripcion, Monto, AplicaPrestacionesFlag, MostrarEnElReciboFlag, MontoBase, CantDias, Fraccion, SueldoFlag, SalarioFlag, VacFraccionFlag, FraccionarFlag)
		SELECT NumeroUnico, HeaderID, Empleado, Rubro, CONVERT(nvarchar(1), Tipo), Descripcion, Monto, AplicaPrestacionesFlag, MostrarEnElReciboFlag, MontoBase, CantDias, Fraccion, SueldoFlag, SalarioFlag, VacFraccionFlag, FraccionarFlag FROM dbo.tNomina WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tNomina OFF
GO
DROP TABLE dbo.tNomina
GO
EXECUTE sp_rename N'dbo.Tmp_tNomina', N'tNomina', 'OBJECT' 
GO
ALTER TABLE dbo.tNomina ADD CONSTRAINT
	PK_tNomina PRIMARY KEY NONCLUSTERED 
	(
	NumeroUnico
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tNomina ADD CONSTRAINT
	FK_tNomina_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tNomina ADD CONSTRAINT
	FK_tNomina_tMaestraRubros FOREIGN KEY
	(
	Rubro
	) REFERENCES dbo.tMaestraRubros
	(
	Rubro
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tNomina ADD CONSTRAINT
	FK_tNomina_tNominaHeaders FOREIGN KEY
	(
	HeaderID
	) REFERENCES dbo.tNominaHeaders
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.357', GetDate()) 
