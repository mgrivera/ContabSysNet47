/*    Viernes, 12 de Julio de 2.013 	-   v0.00.348.sql 

	Mejoramos la estructura de las tablas relacionadas al proceso Prestamos 	
	
	Nota: los selects que siguen no deben regresar rows 
	
	Select * From tPrestamos Where Empleado not in (Select Empleado From tEmpleados) 
	(eliminarlos si encontramos algunos ...) 
	Delete From tPrestamos Where Empleado not in (Select Empleado From tEmpleados) 
	
	Select * From tPrestamos Where Tipo not in (Select Tipo From tTiposDePrestamo) 
	
	Select * From tCuotasPrestamos Where Prestamo Not In (Select Numero From tPrestamos) 
	Eliminar estos rows pues corresponden a prestamos que se han eliminado ... 
	Delete From tCuotasPrestamos Where Prestamo Not In (Select Numero From tPrestamos) 
	
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
DROP TABLE dbo.tTiposDePrestamoId
GO
COMMIT
BEGIN TRANSACTION
GO
DROP TABLE dbo.tPrestamosId
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
ALTER TABLE dbo.ParametrosNomina
	DROP CONSTRAINT FK_ParametrosNomina_tMaestraRubros
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
	RubroPrestamos int NULL,
	RubroPrestamosIntereses int NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_ParametrosNomina SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.ParametrosNomina)
	 EXEC('INSERT INTO dbo.Tmp_ParametrosNomina (RubroSueldo, LimiteProrrateoVacaciones, AgregarAsientosContables, OrganizarPartidasDelAsiento, TipoAsientoDefault, CuentaContableNomina, MonedaParaElAsiento, SumarizarPartidaAsientoContable, RubroDescuentoDiasAnticipoVacaciones, CodigoConceptoRetencionISLREmpleados, Cia)
		SELECT RubroSueldo, LimiteProrrateoVacaciones, AgregarAsientosContables, OrganizarPartidasDelAsiento, TipoAsientoDefault, CuentaContableNomina, MonedaParaElAsiento, SumarizarPartidaAsientoContable, RubroDescuentoDiasAnticipoVacaciones, CodigoConceptoRetencionISLREmpleados, Cia FROM dbo.ParametrosNomina WITH (HOLDLOCK TABLOCKX)')
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
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tTiposDePrestamo
	(
	Tipo int NOT NULL IDENTITY (1, 1),
	Descripcion nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tTiposDePrestamo SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tTiposDePrestamo ON
GO
IF EXISTS(SELECT * FROM dbo.tTiposDePrestamo)
	 EXEC('INSERT INTO dbo.Tmp_tTiposDePrestamo (Tipo, Descripcion)
		SELECT Tipo, Descripcion FROM dbo.tTiposDePrestamo WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tTiposDePrestamo OFF
GO
DROP TABLE dbo.tTiposDePrestamo
GO
EXECUTE sp_rename N'dbo.Tmp_tTiposDePrestamo', N'tTiposDePrestamo', 'OBJECT' 
GO
ALTER TABLE dbo.tTiposDePrestamo ADD CONSTRAINT
	PK_tTiposDePrestamo PRIMARY KEY CLUSTERED 
	(
	Tipo
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tPrestamos
	(
	Numero int NOT NULL IDENTITY (1, 1),
	Categoria char(3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Tipo int NOT NULL,
	Empleado int NOT NULL,
	Situacion nvarchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	FechaSolicitado datetime NOT NULL,
	FechaOtorgado datetime NULL,
	FechaCancelado datetime NULL,
	FechaAnulado datetime NULL,
	MontoSolicitado money NOT NULL,
	MontoOtorgado money NULL,
	PorcIntereses money NULL,
	TotalAPagar money NOT NULL,
	NumeroDeCuotas smallint NOT NULL,
	MontoCuota money NULL,
	MontoCancelado money NULL,
	Saldo money NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tPrestamos SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tPrestamos ON
GO
IF EXISTS(SELECT * FROM dbo.tPrestamos)
	 EXEC('INSERT INTO dbo.Tmp_tPrestamos (Numero, Categoria, Tipo, Empleado, Situacion, FechaSolicitado, FechaOtorgado, FechaCancelado, FechaAnulado, MontoSolicitado, PorcIntereses, TotalAPagar, NumeroDeCuotas, MontoCuota, MontoCancelado, Saldo)
		SELECT Numero, Categoria, Tipo, Empleado, Situacion, FechaSolicitado, FechaOtorgado, FechaCancelado, FechaAnulado, MontoSolicitado, PorcIntereses, TotalAPagar, NumeroDeCuotas, MontoCuota, MontoCancelado, Saldo FROM dbo.tPrestamos WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tPrestamos OFF
GO
DROP TABLE dbo.tPrestamos
GO
EXECUTE sp_rename N'dbo.Tmp_tPrestamos', N'tPrestamos', 'OBJECT' 
GO
ALTER TABLE dbo.tPrestamos ADD CONSTRAINT
	PK_tPrestamos PRIMARY KEY NONCLUSTERED 
	(
	Numero
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tPrestamos ADD CONSTRAINT
	FK_tPrestamos_tTiposDePrestamo FOREIGN KEY
	(
	Tipo
	) REFERENCES dbo.tTiposDePrestamo
	(
	Tipo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tPrestamos ADD CONSTRAINT
	FK_tPrestamos_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tCuotasPrestamos ADD
	TipoNomina nvarchar(10) NULL
GO
ALTER TABLE dbo.tCuotasPrestamos ADD CONSTRAINT
	FK_tCuotasPrestamos_tPrestamos FOREIGN KEY
	(
	Prestamo
	) REFERENCES dbo.tPrestamos
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.tCuotasPrestamos
	DROP COLUMN EspecialFlag, Cia
GO
ALTER TABLE dbo.tCuotasPrestamos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

Update tCuotasPrestamos Set TipoNomina = 'N' 
Update tPrestamos Set MontoOtorgado = 0 

ALTER TABLE dbo.tCuotasPrestamos Alter Column TipoNomina nvarchar(10) Not NULL
ALTER TABLE dbo.tPrestamos Alter Column MontoOtorgado money Not NULL
--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.348', GetDate()) 