/*    Martes, 17 de Septiembre de 2.013 	-   v0.00.356b.sql 

	Mejoramos la estructura de las tablas de nómina que sirven de apoyo para agregar 
	el asiento contable de nómina a Contab 

	Nota: este script fallará si alguno de estos Selects regresa items ... 
	
	Revisar collation de las siguientes tablas: ParametrosNomina, TiposDeAsiento 

	Select * From ParametrosNomina Where TipoAsientoDefault Not In (Select Tipo From TiposDeAsiento) 
	Select * From ParametrosNomina Where CuentaContableNomina Not In (Select ID From CuentasContables) 
	Select * From ParametrosNomina Where MonedaParaElAsiento Not In (Select Moneda From Monedas) 

 
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
ALTER TABLE dbo.CuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Monedas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.TiposDeAsiento SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
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
ALTER TABLE dbo.ParametrosNomina SET (LOCK_ESCALATION = TABLE)
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
	DROP CONSTRAINT FK_ParametrosNomina_tMaestraRubros
GO
ALTER TABLE dbo.ParametrosNomina
	DROP CONSTRAINT FK_ParametrosNomina_tMaestraRubros1
GO
ALTER TABLE dbo.ParametrosNomina
	DROP CONSTRAINT FK_ParametrosNomina_tMaestraRubros2
GO
ALTER TABLE dbo.tMaestraRubros SET (LOCK_ESCALATION = TABLE)
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
CREATE TABLE dbo.Tmp_ParametrosNomina
	(
	RubroSueldo int NULL,
	LimiteProrrateoVacaciones real NULL,
	AgregarAsientosContables bit NULL,
	OrganizarPartidasDelAsiento bit NULL,
	TipoAsientoDefault nvarchar(6) NULL,
	CuentaContableNomina int NULL,
	MonedaParaElAsiento int NULL,
	SumarizarPartidaAsientoContable smallint NULL,
	RubroDescuentoDiasAnticipoVacaciones int NULL,
	CodigoConceptoRetencionISLREmpleados nvarchar(6) NULL,
	RubroPrestamos int NULL,
	RubroPrestamosIntereses int NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_ParametrosNomina SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.ParametrosNomina)
	 EXEC('INSERT INTO dbo.Tmp_ParametrosNomina (RubroSueldo, LimiteProrrateoVacaciones, AgregarAsientosContables, OrganizarPartidasDelAsiento, TipoAsientoDefault, CuentaContableNomina, MonedaParaElAsiento, SumarizarPartidaAsientoContable, RubroDescuentoDiasAnticipoVacaciones, CodigoConceptoRetencionISLREmpleados, RubroPrestamos, RubroPrestamosIntereses, Cia)
		SELECT RubroSueldo, LimiteProrrateoVacaciones, AgregarAsientosContables, OrganizarPartidasDelAsiento, TipoAsientoDefault, CuentaContableNomina, MonedaParaElAsiento, CONVERT(smallint, SumarizarPartidaAsientoContable), RubroDescuentoDiasAnticipoVacaciones, CodigoConceptoRetencionISLREmpleados, RubroPrestamos, RubroPrestamosIntereses, Cia FROM dbo.ParametrosNomina WITH (HOLDLOCK TABLOCKX)')
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
ALTER TABLE dbo.ParametrosNomina ADD CONSTRAINT
	FK_ParametrosNomina_tMaestraRubros1 FOREIGN KEY
	(
	RubroPrestamos
	) REFERENCES dbo.tMaestraRubros
	(
	Rubro
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.ParametrosNomina ADD CONSTRAINT
	FK_ParametrosNomina_tMaestraRubros2 FOREIGN KEY
	(
	RubroPrestamosIntereses
	) REFERENCES dbo.tMaestraRubros
	(
	Rubro
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
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
ALTER TABLE dbo.tCuentasContablesPorEmpleadoYRubro
	DROP CONSTRAINT FK_tCuentasContablesPorEmpleadoYRubro_CuentasContables
GO
ALTER TABLE dbo.CuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tCuentasContablesPorEmpleadoYRubro
	DROP CONSTRAINT FK_tCuentasContablesPorEmpleadoYRubro_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tCuentasContablesPorEmpleadoYRubro
	DROP CONSTRAINT FK_tCuentasContablesPorEmpleadoYRubro_tDepartamentos
GO
ALTER TABLE dbo.tDepartamentos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tCuentasContablesPorEmpleadoYRubro
	DROP CONSTRAINT FK_tCuentasContablesPorEmpleadoYRubro_tEmpleados
GO
ALTER TABLE dbo.tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tCuentasContablesPorEmpleadoYRubro
	DROP CONSTRAINT FK_tCuentasContablesPorEmpleadoYRubro_tMaestraRubros
GO
ALTER TABLE dbo.tMaestraRubros SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tCuentasContablesPorEmpleadoYRubro
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	Rubro int NOT NULL,
	Empleado int NULL,
	Departamento int NULL,
	CuentaContable int NOT NULL,
	SumarizarEnUnaPartidaFlag smallint NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tCuentasContablesPorEmpleadoYRubro SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tCuentasContablesPorEmpleadoYRubro ON
GO
IF EXISTS(SELECT * FROM dbo.tCuentasContablesPorEmpleadoYRubro)
	 EXEC('INSERT INTO dbo.Tmp_tCuentasContablesPorEmpleadoYRubro (ClaveUnica, Rubro, Empleado, Departamento, CuentaContable, SumarizarEnUnaPartidaFlag, Cia)
		SELECT ClaveUnica, Rubro, Empleado, Departamento, CuentaContable, CONVERT(smallint, SumarizarEnUnaPartidaFlag), Cia FROM dbo.tCuentasContablesPorEmpleadoYRubro WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tCuentasContablesPorEmpleadoYRubro OFF
GO
DROP TABLE dbo.tCuentasContablesPorEmpleadoYRubro
GO
EXECUTE sp_rename N'dbo.Tmp_tCuentasContablesPorEmpleadoYRubro', N'tCuentasContablesPorEmpleadoYRubro', 'OBJECT' 
GO
ALTER TABLE dbo.tCuentasContablesPorEmpleadoYRubro ADD CONSTRAINT
	PK_tCuentasContablesPorEmpleadoYRubro PRIMARY KEY NONCLUSTERED 
	(
	ClaveUnica
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

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
ALTER TABLE dbo.tCuentasContablesPorEmpleadoYRubro ADD CONSTRAINT
	FK_tCuentasContablesPorEmpleadoYRubro_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.tCuentasContablesPorEmpleadoYRubro ADD CONSTRAINT
	FK_tCuentasContablesPorEmpleadoYRubro_tDepartamentos FOREIGN KEY
	(
	Departamento
	) REFERENCES dbo.tDepartamentos
	(
	Departamento
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.tCuentasContablesPorEmpleadoYRubro ADD CONSTRAINT
	FK_tCuentasContablesPorEmpleadoYRubro_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.tCuentasContablesPorEmpleadoYRubro ADD CONSTRAINT
	FK_tCuentasContablesPorEmpleadoYRubro_CuentasContables FOREIGN KEY
	(
	CuentaContable
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
COMMIT

Update tCuentasContablesPorEmpleadoYRubro Set SumarizarEnUnaPartidaFlag = Null Where SumarizarEnUnaPartidaFlag = 0 


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.356b', GetDate()) 
