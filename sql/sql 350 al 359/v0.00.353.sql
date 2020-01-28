/*    Miercoles, 14 de Agosto de 2.013 	-   v0.00.353.sql 

	Cambios leves a la tabla DeducionesNomina 
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
ALTER TABLE dbo.DeduccionesNomina ADD
	SuspendidoFlag bit NULL
GO
ALTER TABLE dbo.DeduccionesNomina SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

Update DeduccionesNomina Set SuspendidoFlag = 0

ALTER TABLE dbo.DeduccionesNomina Alter Column SuspendidoFlag bit Not NULL

ALTER TABLE dbo.DeduccionesNomina Alter Column AporteEmpleado decimal(9, 6) NOT NULL
ALTER TABLE dbo.DeduccionesNomina Alter Column AporteEmpresa decimal(9, 6) NOT NULL


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
ALTER TABLE dbo.tGruposEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tMaestraRubros SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.DeduccionesISLR
	(
	ID int NOT NULL IDENTITY (1, 1),
	Rubro int NOT NULL,
	GrupoNomina int NULL,
	Empleado int NULL,
	Desde date NOT NULL,
	TipoNomina nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Porcentaje decimal(9, 6) NOT NULL,
	Base nvarchar(10) NOT NULL,
	SuspendidoFlag bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.DeduccionesISLR ADD CONSTRAINT
	PK_DeduccionesISLR PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.DeduccionesISLR ADD CONSTRAINT
	FK_DeduccionesISLR_tMaestraRubros FOREIGN KEY
	(
	Rubro
	) REFERENCES dbo.tMaestraRubros
	(
	Rubro
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.DeduccionesISLR ADD CONSTRAINT
	FK_DeduccionesISLR_tGruposEmpleados FOREIGN KEY
	(
	GrupoNomina
	) REFERENCES dbo.tGruposEmpleados
	(
	Grupo
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.DeduccionesISLR ADD CONSTRAINT
	FK_DeduccionesISLR_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.DeduccionesISLR SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


Update tRubrosAsignados Set SuspendidoFlag = 0 Where SuspendidoFlag Is Null 
Alter Table tRubrosAsignados Alter Column SuspendidoFlag bit not null 

/****** Object:  View [dbo].[vVacaciones_DatosEmpleado]    Script Date: 08/17/2013 10:46:01 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vVacaciones_DatosEmpleado]'))
DROP VIEW [dbo].[vVacaciones_DatosEmpleado]
GO

/****** Object:  View [dbo].[vVacaciones_DatosEmpleado]    Script Date: 08/17/2013 10:46:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vVacaciones_DatosEmpleado]
AS
SELECT     Empleado, FechaIngreso
FROM         dbo.tEmpleados

GO

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.353', GetDate()) 
