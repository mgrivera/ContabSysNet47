/*    Lunes, 25 de Junio de 2.013 	-   v0.00.344.sql 

	Pagos: agregamos la columna AnticipoFlag 
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
ALTER TABLE dbo.ParametrosNomina
	DROP CONSTRAINT FK_ParametrosNomina_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tMaestraRubros SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_ParametrosNomina
	(
	RubroSueldo int NULL,
	LimiteProrrateoVacaciones real NULL,
	AgregarAsientosContables bit NULL,
	OrganizarPartidasDelAsiento bit NULL,
	TipoAsientoDefault nvarchar(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CuentaContableNomina int NULL,
	MonedaParaElAsiento int NULL,
	SumarizarPartidaAsientoContable tinyint NULL,
	RubroDescuentoDiasAnticipoVacaciones int NULL,
	CodigoConceptoRetencionISLREmpleados nvarchar(6) NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_ParametrosNomina SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.ParametrosNomina)
	 EXEC('INSERT INTO dbo.Tmp_ParametrosNomina (LimiteProrrateoVacaciones, AgregarAsientosContables, OrganizarPartidasDelAsiento, TipoAsientoDefault, CuentaContableNomina, MonedaParaElAsiento, SumarizarPartidaAsientoContable, RubroDescuentoDiasAnticipoVacaciones, CodigoConceptoRetencionISLREmpleados, Cia)
		SELECT LimiteProrrateoVacaciones, AgregarAsientosContables, OrganizarPartidasDelAsiento, TipoAsientoDefault, CuentaContableNomina, MonedaParaElAsiento, SumarizarPartidaAsientoContable, RubroDescuentoDiasAnticipoVacaciones, CodigoConceptoRetencionISLREmpleados, Cia FROM dbo.ParametrosNomina WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.ParametrosNomina
GO
EXECUTE sp_rename N'dbo.Tmp_ParametrosNomina', N'ParametrosNomina', 'OBJECT' 
GO
ALTER TABLE dbo.ParametrosNomina ADD CONSTRAINT
	PK_tParametrosNomina PRIMARY KEY NONCLUSTERED 
	(
	Cia
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.ParametrosNomina ADD CONSTRAINT
	FK_ParametrosNomina_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.ParametrosNomina ADD CONSTRAINT
	FK_ParametrosNomina_tMaestraRubros FOREIGN KEY
	(
	RubroSueldo
	) REFERENCES dbo.tMaestraRubros
	(
	Rubro
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
ALTER TABLE dbo.tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Empleados_Faltas
	(
	ID int NOT NULL IDENTITY (1, 1),
	Empleado int NOT NULL,
	Desde date NOT NULL,
	Hasta date NOT NULL,
	CantDias smallint NOT NULL,
	Descontar bit NOT NULL,
	Observaciones text NULL,
	DescripcionRubroNomina nvarchar(250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Empleados_Faltas ADD CONSTRAINT
	PK_Empleados_Faltas PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Empleados_Faltas ADD CONSTRAINT
	FK_Empleados_Faltas_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Empleados_Faltas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Empleados_Sueldo
	(
	ID int NOT NULL IDENTITY (1, 1),
	Empleado int NOT NULL,
	Desde date NOT NULL,
	Sueldo money NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Empleados_Sueldo ADD CONSTRAINT
	PK_Empleados_Sueldo PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Empleados_Sueldo ADD CONSTRAINT
	FK_Empleados_Sueldo_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Empleados_Sueldo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

/* intentamos actualizar la nueva tabla de sueldos, para registrar el sueldo 'actual' de cada empleado */ 

Insert Into Empleados_Sueldo (Empleado, Desde, Sueldo) 
	Select Empleado, '2013-6-1', SueldoBasico From tEmpleados 
	Where SueldoBasico Is Not Null
	
	
	
	
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
CREATE TABLE dbo.Tmp_tMaestraRubros
	(
	Rubro int NOT NULL IDENTITY (1, 1),
	NombreCortoRubro nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Descripcion nvarchar(250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Tipo nvarchar(1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	SueldoFlag bit NULL,
	SalarioFlag bit NULL,
	TipoNomina nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Periodicidad nvarchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Desde datetime NULL,
	Hasta datetime NULL,
	Siempre bit NULL,
	MontoAAplicar money NULL,
	RubroAAplicar int NULL,
	GrupoAAplicar int NULL,
	DeLaNomina nvarchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DeLaNominaDesde smalldatetime NULL,
	DeLaNominaHasta smalldatetime NULL,
	VariableAAplicar tinyint NULL,
	BaseCalculoVariableFlag char(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
	MostrarEnElReciboFlag bit NULL,
	SSOFlag bit NULL,
	ISRFlag bit NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tMaestraRubros SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tMaestraRubros ON
GO
IF EXISTS(SELECT * FROM dbo.tMaestraRubros)
	 EXEC('INSERT INTO dbo.Tmp_tMaestraRubros (Rubro, NombreCortoRubro, Descripcion, Tipo, SalarioFlag, TipoNomina, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Divisor1, Divisor2, Porcentaje, PorcentajeMas, PorcentajeMas2, LunesDelMes, Tope, Categoria, MostrarEnElReciboFlag, SSOFlag, ISRFlag)
		SELECT Rubro, NombreCortoRubro, Descripcion, Tipo, SalarioFlag, TipoNomina, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Divisor1, Divisor2, Porcentaje, PorcentajeMas, PorcentajeMas2, LunesDelMes, Tope, Categoria, MostrarEnElReciboFlag, SSOFlag, ISRFlag FROM dbo.tMaestraRubros WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tMaestraRubros OFF
GO
ALTER TABLE dbo.SueldoAumentado_Definicion_Rubros
	DROP CONSTRAINT FK_SueldoAumentado_Definicion_Rubros_tMaestraRubros
GO
ALTER TABLE dbo.ParametrosNomina
	DROP CONSTRAINT FK_ParametrosNomina_tMaestraRubros
GO
DROP TABLE dbo.tMaestraRubros
GO
EXECUTE sp_rename N'dbo.Tmp_tMaestraRubros', N'tMaestraRubros', 'OBJECT' 
GO
ALTER TABLE dbo.tMaestraRubros ADD CONSTRAINT
	PK_tMaestraRubros PRIMARY KEY NONCLUSTERED 
	(
	Rubro
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.ParametrosNomina ADD CONSTRAINT
	FK_ParametrosNomina_tMaestraRubros FOREIGN KEY
	(
	RubroSueldo
	) REFERENCES dbo.tMaestraRubros
	(
	Rubro
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.ParametrosNomina SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.SueldoAumentado_Definicion_Rubros ADD CONSTRAINT
	FK_SueldoAumentado_Definicion_Rubros_tMaestraRubros FOREIGN KEY
	(
	Rubro
	) REFERENCES dbo.tMaestraRubros
	(
	Rubro
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.SueldoAumentado_Definicion_Rubros SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.344', GetDate()) 