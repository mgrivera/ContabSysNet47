/*    Jueves, 25 de Julio de 2.013 	-   v0.00.351.sql 

	Continuamos cambios (casi todos leves) a la tabla Vacaciones 
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
ALTER TABLE dbo.Vacaciones
	DROP CONSTRAINT FK_Vacaciones_tGruposEmpleados
GO
ALTER TABLE dbo.tGruposEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Vacaciones
	DROP CONSTRAINT FK_Vacaciones_tEmpleados
GO
ALTER TABLE dbo.tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Vacaciones
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	Empleado int NOT NULL,
	GrupoNomina int NOT NULL,
	AnoVacaciones int NOT NULL,
	NumeroVacaciones smallint NOT NULL,
	Salida date NULL,
	Regreso date NULL,
	DiasDisfrutados smallint NOT NULL,
	FechaReintegro date NOT NULL,
	FechaNomina date NULL,
	MontoBono money NULL,
	ObviarEnLaNominaFlag bit NULL,
	CantDiasTrabajados tinyint NULL,
	CantDiasAnticipo tinyint NULL,
	CantDiasBono smallint NULL,
	CantDiasAdicionales tinyint NULL,
	CantDiasFeriados tinyint NULL,
	CantDiasVacPendAnosAnteriores smallint NULL,
	CantDiasVacSegunTabla smallint NULL,
	CantDiasVacDisfrutadosAntes smallint NULL,
	CantDiasVacDisfrutadosAhora smallint NULL,
	CantDiasVacPendientes smallint NULL,
	BonoVacacionalFlag bit NULL,
	DesactivarNominaDesde date NULL,
	DesactivarNominaHasta date NULL,
	AplicarDeduccionesFlag bit NULL,
	PeriodoPagoDesde date NULL,
	PeriodoPagoHasta date NULL,
	PeriodoPagoDias smallint NOT NULL,
	CantDiasDeduccion smallint NULL
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
	 EXEC('INSERT INTO dbo.Tmp_Vacaciones (ClaveUnica, Empleado, GrupoNomina, AnoVacaciones, NumeroVacaciones, Salida, Regreso, DiasDisfrutados, FechaReintegro, FechaNomina, MontoBono, ObviarEnLaNominaFlag, CantDiasTrabajados, CantDiasAnticipo, CantDiasBono, CantDiasAdicionales, CantDiasFeriados, CantDiasVacPendAnosAnteriores, CantDiasVacSegunTabla, CantDiasVacDisfrutadosAntes, CantDiasVacDisfrutadosAhora, CantDiasVacPendientes, BonoVacacionalFlag, DesactivarNominaDesde, DesactivarNominaHasta, AplicarDeduccionesFlag, PeriodoPagoDesde, PeriodoPagoHasta, PeriodoPagoDias, CantDiasDeduccion)
		SELECT ClaveUnica, Empleado, GrupoNomina, AnoVacaciones, NumeroVacaciones, Salida, Regreso, DiasDisfrutados, FechaReintegro, FechaNomina, MontoBono, ObviarEnLaNominaFlag, CantDiasTrabajados, CantDiasAnticipo, CantDiasBono, CantDiasAdicionales, CantDiasFeriados, CantDiasVacPendAnosAnteriores, CantDiasVacSegunTabla, CantDiasVacDisfrutadosAntes, CantDiasVacDisfrutadosAhora, CantDiasVacPendientes, BonoVacacionalFlag, DesactivarNominaDesde, DesactivarNominaHasta, AplicarDeduccionesFlag, PeriodoPagoDesde, PeriodoPagoHasta, PeriodoPagoDias, CantDiasDeduccion FROM dbo.Vacaciones WITH (HOLDLOCK TABLOCKX)')
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
ALTER TABLE dbo.Vacaciones ADD CONSTRAINT
	FK_Vacaciones_tGruposEmpleados FOREIGN KEY
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
ALTER TABLE dbo.Vacaciones
	DROP CONSTRAINT FK_Vacaciones_tGruposEmpleados
GO
ALTER TABLE dbo.tGruposEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Vacaciones
	DROP CONSTRAINT FK_Vacaciones_tEmpleados
GO
ALTER TABLE dbo.tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Vacaciones
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	Empleado int NOT NULL,
	GrupoNomina int NOT NULL,
	AnoVacacionesDesde date NULL,
	AnoVacacionesHasta date NULL,
	AnoVacaciones int NOT NULL,
	NumeroVacaciones smallint NOT NULL,
	Salida date NULL,
	Regreso date NULL,
	DiasDisfrutados smallint NOT NULL,
	FechaReintegro date NOT NULL,
	FechaNomina date NULL,
	MontoBono money NULL,
	ObviarEnLaNominaFlag bit NULL,
	CantDiasTrabajados tinyint NULL,
	CantDiasAnticipo tinyint NULL,
	CantDiasBono smallint NULL,
	CantDiasAdicionales tinyint NULL,
	CantDiasFeriados tinyint NULL,
	CantDiasVacPendAnosAnteriores smallint NULL,
	CantDiasVacSegunTabla smallint NULL,
	CantDiasVacDisfrutadosAntes smallint NULL,
	CantDiasVacDisfrutadosAhora smallint NULL,
	CantDiasVacPendientes smallint NULL,
	BonoVacacionalFlag bit NULL,
	DesactivarNominaDesde date NULL,
	DesactivarNominaHasta date NULL,
	AplicarDeduccionesFlag bit NULL,
	PeriodoPagoDesde date NULL,
	PeriodoPagoHasta date NULL,
	PeriodoPagoDias smallint NOT NULL,
	CantDiasDeduccion smallint NULL
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
	 EXEC('INSERT INTO dbo.Tmp_Vacaciones (ClaveUnica, Empleado, GrupoNomina, AnoVacaciones, NumeroVacaciones, Salida, Regreso, DiasDisfrutados, FechaReintegro, FechaNomina, MontoBono, ObviarEnLaNominaFlag, CantDiasTrabajados, CantDiasAnticipo, CantDiasBono, CantDiasAdicionales, CantDiasFeriados, CantDiasVacPendAnosAnteriores, CantDiasVacSegunTabla, CantDiasVacDisfrutadosAntes, CantDiasVacDisfrutadosAhora, CantDiasVacPendientes, BonoVacacionalFlag, DesactivarNominaDesde, DesactivarNominaHasta, AplicarDeduccionesFlag, PeriodoPagoDesde, PeriodoPagoHasta, PeriodoPagoDias, CantDiasDeduccion)
		SELECT ClaveUnica, Empleado, GrupoNomina, AnoVacaciones, NumeroVacaciones, Salida, Regreso, DiasDisfrutados, FechaReintegro, FechaNomina, MontoBono, ObviarEnLaNominaFlag, CantDiasTrabajados, CantDiasAnticipo, CantDiasBono, CantDiasAdicionales, CantDiasFeriados, CantDiasVacPendAnosAnteriores, CantDiasVacSegunTabla, CantDiasVacDisfrutadosAntes, CantDiasVacDisfrutadosAhora, CantDiasVacPendientes, BonoVacacionalFlag, DesactivarNominaDesde, DesactivarNominaHasta, AplicarDeduccionesFlag, PeriodoPagoDesde, PeriodoPagoHasta, PeriodoPagoDias, CantDiasDeduccion FROM dbo.Vacaciones WITH (HOLDLOCK TABLOCKX)')
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
ALTER TABLE dbo.Vacaciones ADD CONSTRAINT
	FK_Vacaciones_tGruposEmpleados FOREIGN KEY
	(
	GrupoNomina
	) REFERENCES dbo.tGruposEmpleados
	(
	Grupo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.351', GetDate()) 