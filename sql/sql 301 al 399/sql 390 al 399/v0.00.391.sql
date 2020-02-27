/*    
	  Viernes, 20/Ene/2017   -   v0.00.391.sql 

	  rubros asignados: eliminamos muchas columnas que ahora no se usan 
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
ALTER TABLE dbo.tRubrosAsignados
	DROP COLUMN TodaLaCia, GrupoEmpleados, GrupoNomina, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Divisor1, Divisor2, Porcentaje, PorcentajeMas, PorcentajeMas2, LunesDelMes, Tope, Categoria, MostrarEnElReciboFlag
GO
ALTER TABLE dbo.tRubrosAsignados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


-- eliminamos rubros asignados sin un empleado asociado; también rubros asignados sin monto; nota: antes ésto tenía algún sentido, ahora no! 
Delete From tRubrosAsignados Where Empleado Is Null 
Delete From tRubrosAsignados Where MontoAAplicar Is Null 

-- la columna TipoNomina no debe contener N; antes lo hacía ... 
Update tRubrosAsignados Set TipoNomina = Replace(TipoNomina, 'N', 'M') Where TipoNomina Like '%N%' 


-- ahora las columnas empleado y monto pueden (y deben!) ser not null 
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
	Empleado int NOT NULL,
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
	MontoAAplicar money NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tRubrosAsignados SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tRubrosAsignados ON
GO
IF EXISTS(SELECT * FROM dbo.tRubrosAsignados)
	 EXEC('INSERT INTO dbo.Tmp_tRubrosAsignados (RubroAsignado, Empleado, Rubro, Descripcion, SuspendidoFlag, OrdenDeAplicacion, Tipo, SalarioFlag, TipoNomina, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar)
		SELECT RubroAsignado, Empleado, Rubro, Descripcion, SuspendidoFlag, OrdenDeAplicacion, Tipo, SalarioFlag, TipoNomina, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar FROM dbo.tRubrosAsignados WITH (HOLDLOCK TABLOCKX)')
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
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.391', GetDate()) 
