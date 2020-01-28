/*    Martes, 17 de Septiembre de 2.013 	-   v0.00.356a.sql 

	Mejoramos la estructura de las tablas de nómina que sirven de apoyo para agregar 
	el asiento contable de nómina a Contab 
	
	Revisar collation en: tCuentasContablesPorEmpleadoYRubro y CuentasContables 

	Nota: este script fallará si alguno de estos Selects regresa items ... 
	
	Select * From tCuentasContablesPorEmpleadoYRubro Where Rubro Is Null 

	Select * From tCuentasContablesPorEmpleadoYRubro Where Rubro Not In (Select Rubro From tMaestraRubros) 
	
	Select * From tCuentasContablesPorEmpleadoYRubro Where Empleado Not In (Select Empleado From tEmpleados) 
	para eliminar las cuentas con empleados que no existan ... 
	Delete From tCuentasContablesPorEmpleadoYRubro Where Empleado Not In (Select Empleado From tEmpleados) 
	
	Select * From tCuentasContablesPorEmpleadoYRubro Where Departamento Not In (Select Departamento From tDepartamentos) 
	
	Select * From tCuentasContablesPorEmpleadoYRubro Where Cia Not In (Select Numero From Companias) 
	
	
	
	comparar counts en estos selects ... 

	Select CuentaContable + '-' + Convert(nvarchar(5), Cia) From tCuentasContablesPorEmpleadoYRubro 


	Select CuentaContable + '-' + Convert(nvarchar(5), Cia) From tCuentasContablesPorEmpleadoYRubro 
	Where CuentaContable + '-' + Convert(nvarchar(5), Cia) Not In 
	(Select Cuenta + '-' + Convert(nvarchar(5), Cia) From CuentasContables) 
	
	eliminar con ... 
	
	delete From tCuentasContablesPorEmpleadoYRubro 
	Where CuentaContable + '-' + Convert(nvarchar(5), Cia) Not In 
	(Select Cuenta + '-' + Convert(nvarchar(5), Cia) From CuentasContables) 

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
DROP TABLE dbo.tCuentasContablesPorEmpleadoyRubroId
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tMaestraRubros SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tDepartamentos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
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
	CuentaContable nvarchar(25) NOT NULL,
	SumarizarEnUnaPartidaFlag bit NOT NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tCuentasContablesPorEmpleadoYRubro SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tCuentasContablesPorEmpleadoYRubro ON
GO
IF EXISTS(SELECT * FROM dbo.tCuentasContablesPorEmpleadoYRubro)
	 EXEC('INSERT INTO dbo.Tmp_tCuentasContablesPorEmpleadoYRubro (ClaveUnica, Rubro, Empleado, Departamento, CuentaContable, SumarizarEnUnaPartidaFlag, Cia)
		SELECT ClaveUnica, Rubro, Empleado, Departamento, CuentaContable, SumarizarEnUnaPartidaFlag, Cia FROM dbo.tCuentasContablesPorEmpleadoYRubro WITH (HOLDLOCK TABLOCKX)')
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
COMMIT


/* esta instrucción sirve para poner el ID de cada cuenta contable en la cuenta que ahora existe en 
   tCuentasContalesPorEmpleadoYRubro; ésto hará que no perdamos la cuenta asociada que ahora existe ... */ 
   
Update p 
Set p.CuentaContable = c.ID 
From tCuentasContablesPorEmpleadoYRubro p Inner Join CuentasContables c 
On p.CuentaContable = c.Cuenta And p.Cia = c.Cia 




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
ALTER TABLE dbo.CuentasContables SET (LOCK_ESCALATION = TABLE)
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
	SumarizarEnUnaPartidaFlag bit NOT NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tCuentasContablesPorEmpleadoYRubro SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tCuentasContablesPorEmpleadoYRubro ON
GO
IF EXISTS(SELECT * FROM dbo.tCuentasContablesPorEmpleadoYRubro)
	 EXEC('INSERT INTO dbo.Tmp_tCuentasContablesPorEmpleadoYRubro (ClaveUnica, Rubro, Empleado, Departamento, CuentaContable, SumarizarEnUnaPartidaFlag, Cia)
		SELECT ClaveUnica, Rubro, Empleado, Departamento, CONVERT(int, CuentaContable), SumarizarEnUnaPartidaFlag, Cia FROM dbo.tCuentasContablesPorEmpleadoYRubro WITH (HOLDLOCK TABLOCKX)')
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


		
--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.356a', GetDate()) 
