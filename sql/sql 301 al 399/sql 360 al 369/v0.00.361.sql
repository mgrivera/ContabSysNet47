/*    Lunes, 18 de Noviembre de 2.013 	-   v0.00.361.sql 

	Hacemos cambios para identificar cada rubro (sueldo, sso, pf, etc.) 
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
	DROP CONSTRAINT FK_ParametrosNomina_Monedas
GO
ALTER TABLE dbo.Monedas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.ParametrosNomina
	DROP CONSTRAINT FK_ParametrosNomina_CuentasContables
GO
ALTER TABLE dbo.CuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.ParametrosNomina
	DROP CONSTRAINT FK_ParametrosNomina_TiposDeAsiento
GO
ALTER TABLE dbo.TiposDeAsiento SET (LOCK_ESCALATION = TABLE)
GO
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
CREATE TABLE dbo.Tmp_tMaestraRubros
	(
	Rubro int NOT NULL IDENTITY (1, 1),
	NombreCortoRubro nvarchar(10) NOT NULL,
	Descripcion nvarchar(250) NOT NULL,
	Tipo nvarchar(1) NOT NULL,
	SueldoFlag bit NULL,
	SalarioFlag bit NULL,
	TipoRubro int NULL,
	TipoNomina nvarchar(10) NULL,
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
	 EXEC('INSERT INTO dbo.Tmp_tMaestraRubros (Rubro, NombreCortoRubro, Descripcion, Tipo, SueldoFlag, SalarioFlag, TipoNomina, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Divisor1, Divisor2, Porcentaje, PorcentajeMas, PorcentajeMas2, LunesDelMes, Tope, Categoria, MostrarEnElReciboFlag, SSOFlag, ISRFlag)
		SELECT Rubro, NombreCortoRubro, Descripcion, Tipo, SueldoFlag, SalarioFlag, TipoNomina, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Divisor1, Divisor2, Porcentaje, PorcentajeMas, PorcentajeMas2, LunesDelMes, Tope, Categoria, MostrarEnElReciboFlag, SSOFlag, ISRFlag FROM dbo.tMaestraRubros WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tMaestraRubros OFF
GO
ALTER TABLE dbo.tRubrosAsignados
	DROP CONSTRAINT FK_tRubrosAsignados_tMaestraRubros
GO
ALTER TABLE dbo.tNomina
	DROP CONSTRAINT FK_tNomina_tMaestraRubros
GO
ALTER TABLE dbo.DeduccionesISLR
	DROP CONSTRAINT FK_DeduccionesISLR_tMaestraRubros
GO
ALTER TABLE dbo.ParametrosNomina
	DROP CONSTRAINT FK_ParametrosNomina_tMaestraRubros
GO
ALTER TABLE dbo.ParametrosNomina
	DROP CONSTRAINT FK_ParametrosNomina_tMaestraRubros1
GO
ALTER TABLE dbo.ParametrosNomina
	DROP CONSTRAINT FK_ParametrosNomina_tMaestraRubros2
GO
ALTER TABLE dbo.ParametrosNomina
	DROP CONSTRAINT FK_ParametrosNomina_tMaestraRubros3
GO
ALTER TABLE dbo.SueldoAumentado_Definicion_Rubros
	DROP CONSTRAINT FK_SueldoAumentado_Definicion_Rubros_tMaestraRubros
GO
ALTER TABLE dbo.DeduccionesNomina
	DROP CONSTRAINT FK_DeduccionesNomina_tMaestraRubros
GO
ALTER TABLE dbo.tCuentasContablesPorEmpleadoYRubro
	DROP CONSTRAINT FK_tCuentasContablesPorEmpleadoYRubro_tMaestraRubros
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
ALTER TABLE dbo.tCuentasContablesPorEmpleadoYRubro ADD CONSTRAINT
	FK_tCuentasContablesPorEmpleadoYRubro_tMaestraRubros FOREIGN KEY
	(
	Rubro
	) REFERENCES dbo.tMaestraRubros
	(
	Rubro
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.tCuentasContablesPorEmpleadoYRubro SET (LOCK_ESCALATION = TABLE)
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
BEGIN TRANSACTION
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
ALTER TABLE dbo.tNomina SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
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
ALTER TABLE dbo.tRubrosAsignados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_ParametrosNomina
	(
	LimiteProrrateoVacaciones real NULL,
	AgregarAsientosContables bit NULL,
	OrganizarPartidasDelAsiento bit NULL,
	TipoAsientoDefault nvarchar(6) NULL,
	CuentaContableNomina int NULL,
	MonedaParaElAsiento int NULL,
	SumarizarPartidaAsientoContable smallint NULL,
	CodigoConceptoRetencionISLREmpleados nvarchar(6) NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_ParametrosNomina SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.ParametrosNomina)
	 EXEC('INSERT INTO dbo.Tmp_ParametrosNomina (LimiteProrrateoVacaciones, AgregarAsientosContables, OrganizarPartidasDelAsiento, TipoAsientoDefault, CuentaContableNomina, MonedaParaElAsiento, SumarizarPartidaAsientoContable, CodigoConceptoRetencionISLREmpleados, Cia)
		SELECT LimiteProrrateoVacaciones, AgregarAsientosContables, OrganizarPartidasDelAsiento, TipoAsientoDefault, CuentaContableNomina, MonedaParaElAsiento, SumarizarPartidaAsientoContable, CodigoConceptoRetencionISLREmpleados, Cia FROM dbo.ParametrosNomina WITH (HOLDLOCK TABLOCKX)')
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
	FK_ParametrosNomina_TiposDeAsiento FOREIGN KEY
	(
	TipoAsientoDefault
	) REFERENCES dbo.TiposDeAsiento
	(
	Tipo
	) ON UPDATE  SET NULL 
	 ON DELETE  SET NULL 
	
GO
ALTER TABLE dbo.ParametrosNomina ADD CONSTRAINT
	FK_ParametrosNomina_CuentasContables FOREIGN KEY
	(
	CuentaContableNomina
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  SET NULL 
	 ON DELETE  SET NULL 
	
GO
ALTER TABLE dbo.ParametrosNomina ADD CONSTRAINT
	FK_ParametrosNomina_Monedas FOREIGN KEY
	(
	MonedaParaElAsiento
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  SET NULL 
	 ON DELETE  SET NULL 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.DeduccionesNomina
	DROP COLUMN Rubro
GO
ALTER TABLE dbo.DeduccionesNomina SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.DeduccionesISLR
	DROP COLUMN Rubro
GO
ALTER TABLE dbo.DeduccionesISLR SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.tGruposEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Utilidades
	(
	ID int NOT NULL IDENTITY (1, 1),
	GrupoNomina int NOT NULL,
	FechaNomina date NOT NULL,
	Desde date NOT NULL,
	Hasta date NOT NULL,
	CantidadMesesPeriodoPago decimal(9, 6) NULL,
	CantidadDiasPeriodoPago smallint NOT NULL,
	CantidadDiasUtilidades smallint NOT NULL,
	BaseAplicacion smallint NOT NULL,
	AplicarInce bit NOT NULL,
	IncePorc decimal(9, 6) NOT NULL,
	AplicarISLR bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Utilidades ADD CONSTRAINT
	PK_Utilidades PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Utilidades ADD CONSTRAINT
	FK_Utilidades_tGruposEmpleados FOREIGN KEY
	(
	GrupoNomina
	) REFERENCES dbo.tGruposEmpleados
	(
	Grupo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Utilidades SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.Utilidades
	DROP COLUMN AplicarISLR
GO
ALTER TABLE dbo.Utilidades SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.361', GetDate()) 
