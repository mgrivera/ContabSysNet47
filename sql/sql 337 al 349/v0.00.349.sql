/*    Jueves, 18 de Julio de 2.013 	-   v0.00.349.sql 

	Mejoramos la estructura de las tablas relacionadas al proceso Prestamos 	
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
ALTER TABLE dbo.tPrestamos
	DROP CONSTRAINT FK_tPrestamos_tEmpleados
GO
ALTER TABLE dbo.tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tPrestamos
	DROP CONSTRAINT FK_tPrestamos_tTiposDePrestamo
GO
ALTER TABLE dbo.tTiposDePrestamo SET (LOCK_ESCALATION = TABLE)
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
	FechaSolicitado date NOT NULL,
	FechaOtorgado date NULL,
	FechaCancelado date NULL,
	FechaAnulado date NULL,
	MontoSolicitado money NOT NULL,
	MontoOtorgado money NOT NULL,
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
	 EXEC('INSERT INTO dbo.Tmp_tPrestamos (Numero, Categoria, Tipo, Empleado, Situacion, FechaSolicitado, FechaOtorgado, FechaCancelado, FechaAnulado, MontoSolicitado, MontoOtorgado, PorcIntereses, TotalAPagar, NumeroDeCuotas, MontoCuota, MontoCancelado, Saldo)
		SELECT Numero, Categoria, Tipo, Empleado, Situacion, CONVERT(date, FechaSolicitado), CONVERT(date, FechaOtorgado), CONVERT(date, FechaCancelado), CONVERT(date, FechaAnulado), MontoSolicitado, MontoOtorgado, PorcIntereses, TotalAPagar, NumeroDeCuotas, MontoCuota, MontoCancelado, Saldo FROM dbo.tPrestamos WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tPrestamos OFF
GO
ALTER TABLE dbo.tCuotasPrestamos
	DROP CONSTRAINT FK_tCuotasPrestamos_tPrestamos
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
ALTER TABLE dbo.tCuotasPrestamos SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.tCuotasPrestamos
	DROP CONSTRAINT FK_tCuotasPrestamos_tPrestamos
GO
ALTER TABLE dbo.tPrestamos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tCuotasPrestamos
	(
	ClavePrincipal int NOT NULL IDENTITY (1, 1),
	Prestamo int NOT NULL,
	FechaCuota date NOT NULL,
	Monto money NOT NULL,
	Cancelada bit NULL,
	MontoIntereses money NULL,
	TotalCuota money NOT NULL,
	PagarPorNominaFlag bit NULL,
	TipoNomina nvarchar(10) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tCuotasPrestamos SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tCuotasPrestamos ON
GO
IF EXISTS(SELECT * FROM dbo.tCuotasPrestamos)
	 EXEC('INSERT INTO dbo.Tmp_tCuotasPrestamos (ClavePrincipal, Prestamo, FechaCuota, Monto, Cancelada, MontoIntereses, TotalCuota, PagarPorNominaFlag, TipoNomina)
		SELECT ClavePrincipal, Prestamo, CONVERT(date, FechaCuota), Monto, Cancelada, MontoIntereses, TotalCuota, PagarPorNominaFlag, TipoNomina FROM dbo.tCuotasPrestamos WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tCuotasPrestamos OFF
GO
DROP TABLE dbo.tCuotasPrestamos
GO
EXECUTE sp_rename N'dbo.Tmp_tCuotasPrestamos', N'tCuotasPrestamos', 'OBJECT' 
GO
ALTER TABLE dbo.tCuotasPrestamos ADD CONSTRAINT
	PK_tCuotasPrestamos PRIMARY KEY NONCLUSTERED 
	(
	ClavePrincipal
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_tCuotasPrestamos ON dbo.tCuotasPrestamos
	(
	Prestamo
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
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
CREATE TABLE dbo.Tmp_DiasFiestaNacional
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	Fecha date NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_DiasFiestaNacional SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_DiasFiestaNacional ON
GO
IF EXISTS(SELECT * FROM dbo.DiasFiestaNacional)
	 EXEC('INSERT INTO dbo.Tmp_DiasFiestaNacional (ClaveUnica, Fecha)
		SELECT ClaveUnica, CONVERT(date, Fecha) FROM dbo.DiasFiestaNacional WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_DiasFiestaNacional OFF
GO
DROP TABLE dbo.DiasFiestaNacional
GO
EXECUTE sp_rename N'dbo.Tmp_DiasFiestaNacional', N'DiasFiestaNacional', 'OBJECT' 
GO
ALTER TABLE dbo.DiasFiestaNacional ADD CONSTRAINT
	PK_DiasFiestaNacional PRIMARY KEY CLUSTERED 
	(
	ClaveUnica
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_DiasFeriados
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	Fecha date NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_DiasFeriados SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_DiasFeriados ON
GO
IF EXISTS(SELECT * FROM dbo.DiasFeriados)
	 EXEC('INSERT INTO dbo.Tmp_DiasFeriados (ClaveUnica, Fecha)
		SELECT ClaveUnica, CONVERT(date, Fecha) FROM dbo.DiasFeriados WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_DiasFeriados OFF
GO
DROP TABLE dbo.DiasFeriados
GO
EXECUTE sp_rename N'dbo.Tmp_DiasFeriados', N'DiasFeriados', 'OBJECT' 
GO
ALTER TABLE dbo.DiasFeriados ADD CONSTRAINT
	PK_DiasFeriados PRIMARY KEY CLUSTERED 
	(
	ClaveUnica
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.349', GetDate()) 