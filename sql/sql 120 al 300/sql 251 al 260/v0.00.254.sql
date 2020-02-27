/*    Martes, 28 de Julio de 2.009  -   v0.00.254.sql 

	Hacemos modificaciones a las tablas de nómina para poder efectuar un 
	cambio en el calculo del bono vacacional     

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
ALTER TABLE dbo.tEmpleados
	DROP CONSTRAINT FK_tEmpleados_tDepartamentos
GO
ALTER TABLE dbo.tDepartamentos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tEmpleados
	(
	Empleado int NOT NULL,
	Cedula nvarchar(12) NOT NULL,
	Status nvarchar(1) NOT NULL,
	Nombre nvarchar(250) NOT NULL,
	EdoCivil nvarchar(2) NOT NULL,
	Sexo nvarchar(1) NOT NULL,
	Nacionalidad nvarchar(1) NOT NULL,
	FechaNacimiento datetime NOT NULL,
	PaisOrigen nvarchar(6) NULL,
	CiudadOrigen nvarchar(6) NULL,
	DireccionHabitacion ntext NULL,
	Telefono1 nvarchar(14) NULL,
	Telefono2 nvarchar(14) NULL,
	SituacionActual nvarchar(2) NOT NULL,
	Departamento int NOT NULL,
	Cargo int NOT NULL,
	FechaIngreso datetime NOT NULL,
	FechaRetiro datetime NULL,
	Banco int NULL,
	CuentaBancaria nvarchar(30) NULL,
	Contacto1 nvarchar(250) NULL,
	Parentesco1 int NULL,
	TelefonoCon1 nvarchar(14) NULL,
	Contacto2 nvarchar(250) NULL,
	Parentesco2 int NULL,
	TelefonoCon2 nvarchar(14) NULL,
	Contacto3 nvarchar(250) NULL,
	Parentesco3 int NULL,
	TelefonoCon3 nvarchar(14) NULL,
	TipoCuenta int NULL,
	EmpleadoObreroFlag smallint NULL,
	SueldoPromedio money NULL,
	SueldoBasico money NULL,
	MontoCestaTickets money NULL,
	BonoVacAgregarSueldoFlag bit NULL,
	BonoVacAgregarMontoCestaTicketsFlag bit NULL,
	BonoVacacionalMontoAdicional money NULL,
	BonoVacAgregarMontoAdicionalFlag bit NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.tEmpleados)
	 EXEC('INSERT INTO dbo.Tmp_tEmpleados (Empleado, Cedula, Status, Nombre, EdoCivil, Sexo, Nacionalidad, FechaNacimiento, PaisOrigen, CiudadOrigen, DireccionHabitacion, Telefono1, Telefono2, SituacionActual, Departamento, Cargo, FechaIngreso, FechaRetiro, Banco, CuentaBancaria, Contacto1, Parentesco1, TelefonoCon1, Contacto2, Parentesco2, TelefonoCon2, Contacto3, Parentesco3, TelefonoCon3, TipoCuenta, EmpleadoObreroFlag, SueldoPromedio, SueldoBasico, Cia)
		SELECT Empleado, Cedula, Status, Nombre, EdoCivil, Sexo, Nacionalidad, FechaNacimiento, PaisOrigen, CiudadOrigen, DireccionHabitacion, Telefono1, Telefono2, SituacionActual, Departamento, Cargo, FechaIngreso, FechaRetiro, Banco, CuentaBancaria, Contacto1, Parentesco1, TelefonoCon1, Contacto2, Parentesco2, TelefonoCon2, Contacto3, Parentesco3, TelefonoCon3, TipoCuenta, EmpleadoObreroFlag, SueldoPromedio, SueldoBasico, Cia FROM dbo.tEmpleados WITH (HOLDLOCK TABLOCKX)')
GO
ALTER TABLE dbo.Vacaciones
	DROP CONSTRAINT FK_Vacaciones_tEmpleados
GO
DROP TABLE dbo.tEmpleados
GO
EXECUTE sp_rename N'dbo.Tmp_tEmpleados', N'tEmpleados', 'OBJECT' 
GO
ALTER TABLE dbo.tEmpleados ADD CONSTRAINT
	PK_tEmpleados PRIMARY KEY NONCLUSTERED 
	(
	Empleado
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_tEmpleados ON dbo.tEmpleados
	(
	Departamento
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.tEmpleados WITH NOCHECK ADD CONSTRAINT
	FK_tEmpleados_tDepartamentos FOREIGN KEY
	(
	Departamento
	) REFERENCES dbo.tDepartamentos
	(
	Departamento
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
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
	AnoVacaciones smallint NOT NULL,
	NumeroVacaciones tinyint NOT NULL,
	Salida datetime NOT NULL,
	Regreso smalldatetime NOT NULL,
	DiasDisfrutados tinyint NOT NULL,
	FechaReintegro smalldatetime NOT NULL,
	FraccionAntesDesde smalldatetime NULL,
	FraccionAntesHasta smalldatetime NULL,
	CantDiasFraccionAntes tinyint NULL,
	FraccionDespuesDesde smalldatetime NULL,
	FraccionDespuesHasta smalldatetime NULL,
	FechaNomina smalldatetime NULL,
	CantDiasFraccionDespues tinyint NULL,
	MontoBaseBonoVacacional money NULL,
	MontoBono money NULL,
	FechaPagoBono smalldatetime NULL,
	ObviarEnLaNominaFlag bit NULL,
	CantDiasTrabajados tinyint NULL,
	CantDiasAnticipo tinyint NULL,
	CantDiasBono tinyint NULL,
	CantDiasAdicionales tinyint NULL,
	CantDiasFeriados tinyint NULL,
	CantDiasVacPendAnosAnteriores smallint NULL,
	CantDiasVacSegunTabla smallint NULL,
	CantDiasVacDisfrutadosAntes smallint NULL,
	CantDiasVacDisfrutadosAhora smallint NULL,
	CantDiasVacPendientes smallint NULL,
	AdelantoSueldoFlag bit NULL,
	BonoVacacionalFlag bit NULL,
	DesactivarNominaDesde smalldatetime NULL,
	DesactivarNominaHasta smalldatetime NULL,
	AplicarDeduccionesFlag bit NULL,
	AplicarNDeducciones tinyint NULL,
	DescontarSueldoFlag bit NULL,
	DescontarSueldoCantidadDias smallint NULL,
	DescontarSueldoFechaNomina smalldatetime NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Vacaciones SET (LOCK_ESCALATION = TABLE)
GO
DECLARE @v sql_variant 
SET @v = N'109'
EXECUTE sp_addextendedproperty N'MS_DisplayControl', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_Vacaciones', N'COLUMN', N'CantDiasVacSegunTabla'
SET @v = N''
EXECUTE sp_addextendedproperty N'MS_Format', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_Vacaciones', N'COLUMN', N'CantDiasVacSegunTabla'
GO
DECLARE @v sql_variant 
SET @v = N'109'
EXECUTE sp_addextendedproperty N'MS_DisplayControl', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_Vacaciones', N'COLUMN', N'CantDiasVacDisfrutadosAntes'
SET @v = N''
EXECUTE sp_addextendedproperty N'MS_Format', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_Vacaciones', N'COLUMN', N'CantDiasVacDisfrutadosAntes'
GO
DECLARE @v sql_variant 
SET @v = N'109'
EXECUTE sp_addextendedproperty N'MS_DisplayControl', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_Vacaciones', N'COLUMN', N'CantDiasVacDisfrutadosAhora'
SET @v = N''
EXECUTE sp_addextendedproperty N'MS_Format', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_Vacaciones', N'COLUMN', N'CantDiasVacDisfrutadosAhora'
GO
DECLARE @v sql_variant 
SET @v = N'109'
EXECUTE sp_addextendedproperty N'MS_DisplayControl', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_Vacaciones', N'COLUMN', N'CantDiasVacPendientes'
SET @v = N''
EXECUTE sp_addextendedproperty N'MS_Format', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_Vacaciones', N'COLUMN', N'CantDiasVacPendientes'
GO
SET IDENTITY_INSERT dbo.Tmp_Vacaciones ON
GO
IF EXISTS(SELECT * FROM dbo.Vacaciones)
	 EXEC('INSERT INTO dbo.Tmp_Vacaciones (ClaveUnica, Empleado, GrupoNomina, TipoNomina, FechaIngreso, AnosServicio, SalarioPromedio, SueldoBasico, AnoVacaciones, NumeroVacaciones, Salida, Regreso, DiasDisfrutados, FechaReintegro, FraccionAntesDesde, FraccionAntesHasta, CantDiasFraccionAntes, FraccionDespuesDesde, FraccionDespuesHasta, FechaNomina, CantDiasFraccionDespues, MontoBono, FechaPagoBono, ObviarEnLaNominaFlag, CantDiasTrabajados, CantDiasAnticipo, CantDiasBono, CantDiasAdicionales, CantDiasFeriados, CantDiasVacPendAnosAnteriores, CantDiasVacSegunTabla, CantDiasVacDisfrutadosAntes, CantDiasVacDisfrutadosAhora, CantDiasVacPendientes, AdelantoSueldoFlag, BonoVacacionalFlag, DesactivarNominaDesde, DesactivarNominaHasta, AplicarDeduccionesFlag, AplicarNDeducciones, DescontarSueldoFlag, DescontarSueldoCantidadDias, DescontarSueldoFechaNomina, Cia)
		SELECT ClaveUnica, Empleado, GrupoNomina, TipoNomina, FechaIngreso, AnosServicio, SalarioPromedio, SueldoBasico, AnoVacaciones, NumeroVacaciones, Salida, Regreso, DiasDisfrutados, FechaReintegro, FraccionAntesDesde, FraccionAntesHasta, CantDiasFraccionAntes, FraccionDespuesDesde, FraccionDespuesHasta, FechaNomina, CantDiasFraccionDespues, MontoBono, FechaPagoBono, ObviarEnLaNominaFlag, CantDiasTrabajados, CantDiasAnticipo, CantDiasBono, CantDiasAdicionales, CantDiasFeriados, CantDiasVacPendAnosAnteriores, CantDiasVacSegunTabla, CantDiasVacDisfrutadosAntes, CantDiasVacDisfrutadosAhora, CantDiasVacPendientes, AdelantoSueldoFlag, BonoVacacionalFlag, DesactivarNominaDesde, DesactivarNominaHasta, AplicarDeduccionesFlag, AplicarNDeducciones, DescontarSueldoFlag, DescontarSueldoCantidadDias, DescontarSueldoFechaNomina, Cia FROM dbo.Vacaciones WITH (HOLDLOCK TABLOCKX)')
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
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_Vacaciones ON dbo.Vacaciones
	(
	Empleado
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.Vacaciones ADD CONSTRAINT
	IX_Vacaciones_1 UNIQUE NONCLUSTERED 
	(
	Empleado,
	GrupoNomina,
	FechaNomina,
	Cia
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Vacaciones WITH NOCHECK ADD CONSTRAINT
	FK_Vacaciones_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
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
ALTER TABLE dbo.tEmpleados
	DROP CONSTRAINT FK_tEmpleados_tDepartamentos
GO
ALTER TABLE dbo.tDepartamentos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tEmpleados
	(
	Empleado int NOT NULL,
	Cedula nvarchar(12) NOT NULL,
	Status nvarchar(1) NOT NULL,
	Nombre nvarchar(250) NOT NULL,
	EdoCivil nvarchar(2) NOT NULL,
	Sexo nvarchar(1) NOT NULL,
	Nacionalidad nvarchar(1) NOT NULL,
	FechaNacimiento datetime NOT NULL,
	PaisOrigen nvarchar(6) NULL,
	CiudadOrigen nvarchar(6) NULL,
	DireccionHabitacion ntext NULL,
	Telefono1 nvarchar(14) NULL,
	Telefono2 nvarchar(14) NULL,
	SituacionActual nvarchar(2) NOT NULL,
	Departamento int NOT NULL,
	Cargo int NOT NULL,
	FechaIngreso datetime NOT NULL,
	FechaRetiro datetime NULL,
	Banco int NULL,
	CuentaBancaria nvarchar(30) NULL,
	Contacto1 nvarchar(250) NULL,
	Parentesco1 int NULL,
	TelefonoCon1 nvarchar(14) NULL,
	Contacto2 nvarchar(250) NULL,
	Parentesco2 int NULL,
	TelefonoCon2 nvarchar(14) NULL,
	Contacto3 nvarchar(250) NULL,
	Parentesco3 int NULL,
	TelefonoCon3 nvarchar(14) NULL,
	TipoCuenta int NULL,
	EmpleadoObreroFlag smallint NULL,
	SueldoPromedio money NULL,
	SueldoBasico money NULL,
	MontoCestaTickets money NULL,
	BonoVacAgregarSueldoFlag bit NULL,
	BonoVacAgregarMontoCestaTicketsFlag bit NULL,
	BonoVacacionalMontoAdicional money NULL,
	BonoVacAgregarMontoAdicionalFlag bit NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.tEmpleados)
	 EXEC('INSERT INTO dbo.Tmp_tEmpleados (Empleado, Cedula, Status, Nombre, EdoCivil, Sexo, Nacionalidad, FechaNacimiento, PaisOrigen, CiudadOrigen, DireccionHabitacion, Telefono1, Telefono2, SituacionActual, Departamento, Cargo, FechaIngreso, FechaRetiro, Banco, CuentaBancaria, Contacto1, Parentesco1, TelefonoCon1, Contacto2, Parentesco2, TelefonoCon2, Contacto3, Parentesco3, TelefonoCon3, TipoCuenta, EmpleadoObreroFlag, SueldoPromedio, SueldoBasico, Cia)
		SELECT Empleado, Cedula, Status, Nombre, EdoCivil, Sexo, Nacionalidad, FechaNacimiento, PaisOrigen, CiudadOrigen, DireccionHabitacion, Telefono1, Telefono2, SituacionActual, Departamento, Cargo, FechaIngreso, FechaRetiro, Banco, CuentaBancaria, Contacto1, Parentesco1, TelefonoCon1, Contacto2, Parentesco2, TelefonoCon2, Contacto3, Parentesco3, TelefonoCon3, TipoCuenta, EmpleadoObreroFlag, SueldoPromedio, SueldoBasico, Cia FROM dbo.tEmpleados WITH (HOLDLOCK TABLOCKX)')
GO
ALTER TABLE dbo.Vacaciones
	DROP CONSTRAINT FK_Vacaciones_tEmpleados
GO
DROP TABLE dbo.tEmpleados
GO
EXECUTE sp_rename N'dbo.Tmp_tEmpleados', N'tEmpleados', 'OBJECT' 
GO
ALTER TABLE dbo.tEmpleados ADD CONSTRAINT
	PK_tEmpleados PRIMARY KEY NONCLUSTERED 
	(
	Empleado
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_tEmpleados ON dbo.tEmpleados
	(
	Departamento
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.tEmpleados WITH NOCHECK ADD CONSTRAINT
	FK_tEmpleados_tDepartamentos FOREIGN KEY
	(
	Departamento
	) REFERENCES dbo.tDepartamentos
	(
	Departamento
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
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
	AnoVacaciones smallint NOT NULL,
	NumeroVacaciones tinyint NOT NULL,
	Salida datetime NOT NULL,
	Regreso smalldatetime NOT NULL,
	DiasDisfrutados tinyint NOT NULL,
	FechaReintegro smalldatetime NOT NULL,
	FraccionAntesDesde smalldatetime NULL,
	FraccionAntesHasta smalldatetime NULL,
	CantDiasFraccionAntes tinyint NULL,
	FraccionDespuesDesde smalldatetime NULL,
	FraccionDespuesHasta smalldatetime NULL,
	FechaNomina smalldatetime NULL,
	CantDiasFraccionDespues tinyint NULL,
	MontoBaseBonoVacacional money NULL,
	MontoBono money NULL,
	FechaPagoBono smalldatetime NULL,
	ObviarEnLaNominaFlag bit NULL,
	CantDiasTrabajados tinyint NULL,
	CantDiasAnticipo tinyint NULL,
	CantDiasBono tinyint NULL,
	CantDiasAdicionales tinyint NULL,
	CantDiasFeriados tinyint NULL,
	CantDiasVacPendAnosAnteriores smallint NULL,
	CantDiasVacSegunTabla smallint NULL,
	CantDiasVacDisfrutadosAntes smallint NULL,
	CantDiasVacDisfrutadosAhora smallint NULL,
	CantDiasVacPendientes smallint NULL,
	AdelantoSueldoFlag bit NULL,
	BonoVacacionalFlag bit NULL,
	DesactivarNominaDesde smalldatetime NULL,
	DesactivarNominaHasta smalldatetime NULL,
	AplicarDeduccionesFlag bit NULL,
	AplicarNDeducciones tinyint NULL,
	DescontarSueldoFlag bit NULL,
	DescontarSueldoCantidadDias smallint NULL,
	DescontarSueldoFechaNomina smalldatetime NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Vacaciones SET (LOCK_ESCALATION = TABLE)
GO
DECLARE @v sql_variant 
SET @v = N'109'
EXECUTE sp_addextendedproperty N'MS_DisplayControl', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_Vacaciones', N'COLUMN', N'CantDiasVacSegunTabla'
SET @v = N''
EXECUTE sp_addextendedproperty N'MS_Format', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_Vacaciones', N'COLUMN', N'CantDiasVacSegunTabla'
GO
DECLARE @v sql_variant 
SET @v = N'109'
EXECUTE sp_addextendedproperty N'MS_DisplayControl', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_Vacaciones', N'COLUMN', N'CantDiasVacDisfrutadosAntes'
SET @v = N''
EXECUTE sp_addextendedproperty N'MS_Format', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_Vacaciones', N'COLUMN', N'CantDiasVacDisfrutadosAntes'
GO
DECLARE @v sql_variant 
SET @v = N'109'
EXECUTE sp_addextendedproperty N'MS_DisplayControl', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_Vacaciones', N'COLUMN', N'CantDiasVacDisfrutadosAhora'
SET @v = N''
EXECUTE sp_addextendedproperty N'MS_Format', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_Vacaciones', N'COLUMN', N'CantDiasVacDisfrutadosAhora'
GO
DECLARE @v sql_variant 
SET @v = N'109'
EXECUTE sp_addextendedproperty N'MS_DisplayControl', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_Vacaciones', N'COLUMN', N'CantDiasVacPendientes'
SET @v = N''
EXECUTE sp_addextendedproperty N'MS_Format', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_Vacaciones', N'COLUMN', N'CantDiasVacPendientes'
GO
SET IDENTITY_INSERT dbo.Tmp_Vacaciones ON
GO
IF EXISTS(SELECT * FROM dbo.Vacaciones)
	 EXEC('INSERT INTO dbo.Tmp_Vacaciones (ClaveUnica, Empleado, GrupoNomina, TipoNomina, FechaIngreso, AnosServicio, SalarioPromedio, SueldoBasico, AnoVacaciones, NumeroVacaciones, Salida, Regreso, DiasDisfrutados, FechaReintegro, FraccionAntesDesde, FraccionAntesHasta, CantDiasFraccionAntes, FraccionDespuesDesde, FraccionDespuesHasta, FechaNomina, CantDiasFraccionDespues, MontoBono, FechaPagoBono, ObviarEnLaNominaFlag, CantDiasTrabajados, CantDiasAnticipo, CantDiasBono, CantDiasAdicionales, CantDiasFeriados, CantDiasVacPendAnosAnteriores, CantDiasVacSegunTabla, CantDiasVacDisfrutadosAntes, CantDiasVacDisfrutadosAhora, CantDiasVacPendientes, AdelantoSueldoFlag, BonoVacacionalFlag, DesactivarNominaDesde, DesactivarNominaHasta, AplicarDeduccionesFlag, AplicarNDeducciones, DescontarSueldoFlag, DescontarSueldoCantidadDias, DescontarSueldoFechaNomina, Cia)
		SELECT ClaveUnica, Empleado, GrupoNomina, TipoNomina, FechaIngreso, AnosServicio, SalarioPromedio, SueldoBasico, AnoVacaciones, NumeroVacaciones, Salida, Regreso, DiasDisfrutados, FechaReintegro, FraccionAntesDesde, FraccionAntesHasta, CantDiasFraccionAntes, FraccionDespuesDesde, FraccionDespuesHasta, FechaNomina, CantDiasFraccionDespues, MontoBono, FechaPagoBono, ObviarEnLaNominaFlag, CantDiasTrabajados, CantDiasAnticipo, CantDiasBono, CantDiasAdicionales, CantDiasFeriados, CantDiasVacPendAnosAnteriores, CantDiasVacSegunTabla, CantDiasVacDisfrutadosAntes, CantDiasVacDisfrutadosAhora, CantDiasVacPendientes, AdelantoSueldoFlag, BonoVacacionalFlag, DesactivarNominaDesde, DesactivarNominaHasta, AplicarDeduccionesFlag, AplicarNDeducciones, DescontarSueldoFlag, DescontarSueldoCantidadDias, DescontarSueldoFechaNomina, Cia FROM dbo.Vacaciones WITH (HOLDLOCK TABLOCKX)')
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
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_Vacaciones ON dbo.Vacaciones
	(
	Empleado
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.Vacaciones ADD CONSTRAINT
	IX_Vacaciones_1 UNIQUE NONCLUSTERED 
	(
	Empleado,
	GrupoNomina,
	FechaNomina,
	Cia
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Vacaciones WITH NOCHECK ADD CONSTRAINT
	FK_Vacaciones_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT




IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qFormaEmpleadosConsulta]'))
DROP VIEW [dbo].[qFormaEmpleadosConsulta]
GO

/****** Object:  View [dbo].[qFormaEmpleadosConsulta]    Script Date: 07/28/2009 16:28:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[qFormaEmpleadosConsulta]
AS
SELECT     dbo.tEmpleados.Empleado, dbo.tEmpleados.Cedula, dbo.tEmpleados.Status, dbo.tEmpleados.Nombre, dbo.tEmpleados.EdoCivil, 
                      dbo.tEmpleados.Sexo, dbo.tEmpleados.Nacionalidad, dbo.tEmpleados.FechaNacimiento, dbo.tEmpleados.PaisOrigen, 
                      dbo.tPaises.Descripcion AS NombrePais, dbo.tEmpleados.CiudadOrigen, dbo.tCiudades.Descripcion AS NombreCiudad, 
                      dbo.tEmpleados.DireccionHabitacion, dbo.tEmpleados.Telefono1, dbo.tEmpleados.Telefono2, dbo.tEmpleados.SituacionActual, 
                      dbo.tEmpleados.Departamento, dbo.tDepartamentos.Descripcion AS NombreDepartamento, dbo.tEmpleados.Cargo, 
                      dbo.tCargos.Descripcion AS NombreCargo, dbo.tEmpleados.FechaIngreso, dbo.tEmpleados.FechaRetiro, dbo.tEmpleados.Banco, 
                      dbo.Bancos.Nombre AS NombreBanco, dbo.tEmpleados.CuentaBancaria, dbo.tEmpleados.TipoCuenta, dbo.tEmpleados.Contacto1, 
                      dbo.tEmpleados.Parentesco1, tParentescosUno.Descripcion AS NombreParentescoUno, dbo.tEmpleados.TelefonoCon1, dbo.tEmpleados.Contacto2, 
                      dbo.tEmpleados.Parentesco2, tParentescosDos.Descripcion AS NombreParentescoDos, dbo.tEmpleados.TelefonoCon2, dbo.tEmpleados.Contacto3, 
                      dbo.tEmpleados.Parentesco3, tParentescosTres.Descripcion AS NombreParentescoTres, dbo.tEmpleados.TelefonoCon3, 
                      dbo.tEmpleados.EmpleadoObreroFlag, dbo.tEmpleados.SueldoPromedio, dbo.tEmpleados.SueldoBasico, dbo.tEmpleados.Cia, 
                      dbo.tEmpleados.MontoCestaTickets, dbo.tEmpleados.BonoVacAgregarSueldoFlag, dbo.tEmpleados.BonoVacAgregarMontoCestaTicketsFlag, 
                      dbo.tEmpleados.BonoVacacionalMontoAdicional, dbo.tEmpleados.BonoVacAgregarMontoAdicionalFlag
FROM         dbo.tEmpleados LEFT OUTER JOIN
                      dbo.tCargos ON dbo.tEmpleados.Cargo = dbo.tCargos.Cargo LEFT OUTER JOIN
                      dbo.tDepartamentos ON dbo.tEmpleados.Departamento = dbo.tDepartamentos.Departamento LEFT OUTER JOIN
                      dbo.tPaises ON dbo.tEmpleados.PaisOrigen = dbo.tPaises.Pais LEFT OUTER JOIN
                      dbo.tCiudades ON dbo.tEmpleados.CiudadOrigen = dbo.tCiudades.Ciudad LEFT OUTER JOIN
                      dbo.tParentescos AS tParentescosUno ON dbo.tEmpleados.Parentesco1 = tParentescosUno.Parentesco LEFT OUTER JOIN
                      dbo.tParentescos AS tParentescosDos ON dbo.tEmpleados.Parentesco2 = tParentescosDos.Parentesco LEFT OUTER JOIN
                      dbo.tParentescos AS tParentescosTres ON dbo.tEmpleados.Parentesco3 = tParentescosTres.Parentesco LEFT OUTER JOIN
                      dbo.Bancos ON dbo.tEmpleados.Banco = dbo.Bancos.Banco

GO



IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qFormaControlVacacionesConsulta]'))
DROP VIEW [dbo].[qFormaControlVacacionesConsulta]
GO

/****** Object:  View [dbo].[qFormaControlVacacionesConsulta]    Script Date: 07/28/2009 17:56:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[qFormaControlVacacionesConsulta]
AS
SELECT     dbo.Vacaciones.Empleado, dbo.Vacaciones.GrupoNomina, dbo.tGruposEmpleados.NombreGrupo, dbo.tEmpleados.Nombre AS NombreEmpleado, 
                      dbo.Vacaciones.Salida, dbo.Vacaciones.Regreso, dbo.Vacaciones.DiasDisfrutados, dbo.Vacaciones.MontoBaseBonoVacacional, 
                      dbo.Vacaciones.MontoBono, dbo.Vacaciones.FechaPagoBono, dbo.Vacaciones.ClaveUnica, dbo.Vacaciones.TipoNomina, 
                      dbo.Vacaciones.FechaIngreso, dbo.Vacaciones.AnosServicio, dbo.Vacaciones.SalarioPromedio, dbo.Vacaciones.SueldoBasico, 
                      dbo.Vacaciones.AnoVacaciones, dbo.Vacaciones.FechaReintegro, dbo.Vacaciones.FraccionAntesDesde, dbo.Vacaciones.FraccionAntesHasta, 
                      dbo.Vacaciones.CantDiasFraccionAntes, dbo.Vacaciones.FraccionDespuesDesde, dbo.Vacaciones.FraccionDespuesHasta, 
                      dbo.Vacaciones.CantDiasFraccionDespues, dbo.Vacaciones.FechaNomina, dbo.Vacaciones.ObviarEnLaNominaFlag, dbo.Vacaciones.CantDiasBono, 
                      dbo.Vacaciones.CantDiasAdicionales, dbo.Vacaciones.CantDiasFeriados, dbo.Vacaciones.NumeroVacaciones, dbo.Vacaciones.CantDiasTrabajados, 
                      dbo.Vacaciones.CantDiasAnticipo, dbo.Vacaciones.CantDiasVacPendAnosAnteriores, dbo.Vacaciones.CantDiasVacSegunTabla, 
                      dbo.Vacaciones.CantDiasVacDisfrutadosAntes, dbo.Vacaciones.CantDiasVacDisfrutadosAhora, dbo.Vacaciones.CantDiasVacPendientes, 
                      dbo.Vacaciones.AdelantoSueldoFlag, dbo.Vacaciones.BonoVacacionalFlag, dbo.Vacaciones.DesactivarNominaDesde, 
                      dbo.Vacaciones.DesactivarNominaHasta, dbo.Vacaciones.AplicarDeduccionesFlag, dbo.Vacaciones.AplicarNDeducciones, 
                      dbo.Vacaciones.DescontarSueldoFlag, dbo.Vacaciones.DescontarSueldoCantidadDias, dbo.Vacaciones.DescontarSueldoFechaNomina, 
                      dbo.Vacaciones.Cia
FROM         dbo.Vacaciones INNER JOIN
                      dbo.tGruposEmpleados ON dbo.Vacaciones.Cia = dbo.tGruposEmpleados.Cia AND 
                      dbo.Vacaciones.GrupoNomina = dbo.tGruposEmpleados.Grupo LEFT OUTER JOIN
                      dbo.tEmpleados ON dbo.Vacaciones.Empleado = dbo.tEmpleados.Empleado AND dbo.Vacaciones.Cia = dbo.tEmpleados.Cia

GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.254', GetDate()) 