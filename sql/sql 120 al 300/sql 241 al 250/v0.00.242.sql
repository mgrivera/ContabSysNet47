/*    Sabado, 28 de Febrero de 2.009  -   v0.00.242.sql 

	Modificamos levemente la tabla tCuentasContablesPorEmpleadoYRubro

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

Update tCuentasContablesPorEmpleadoYRubro 
	Set SumarizarEnUnaPartidaFlag = 0 
	Where SumarizarEnUnaPartidaFlag Is Null 

CREATE TABLE dbo.Tmp_tCuentasContablesPorEmpleadoYRubro
	(
	ClaveUnica int NOT NULL,
	Rubro int NULL,
	Empleado int NULL,
	Departamento int NULL,
	CuentaContable nvarchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	SumarizarEnUnaPartidaFlag bit NOT NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tCuentasContablesPorEmpleadoYRubro SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.tCuentasContablesPorEmpleadoYRubro)
	 EXEC('INSERT INTO dbo.Tmp_tCuentasContablesPorEmpleadoYRubro (ClaveUnica, Rubro, Empleado, Departamento, CuentaContable, SumarizarEnUnaPartidaFlag, Cia)
		SELECT ClaveUnica, Rubro, Empleado, Departamento, CuentaContable, SumarizarEnUnaPartidaFlag, Cia FROM dbo.tCuentasContablesPorEmpleadoYRubro WITH (HOLDLOCK TABLOCKX)')
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
COMMIT

Drop View qFormaCuentasContablesPorEmpleadoYRubro


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.242', GetDate()) 