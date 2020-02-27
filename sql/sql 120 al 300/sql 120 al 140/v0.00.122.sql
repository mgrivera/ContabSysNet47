/*    Miercoles, 5 de Junio de 2002   -   v0.00.122.sql 

	Agregamos integridad referencial a la tabla de Vacaciones (vs. tEmpleados) y a la tabla
	tEmpleados (vs. Departamentos) 

*/ 



Delete From Vacaciones Where Empleado Not In (Select Empleado From tEmpleados) 


BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
COMMIT
BEGIN TRANSACTION
CREATE NONCLUSTERED INDEX IX_Vacaciones ON dbo.Vacaciones
	(
	Empleado
	) ON [PRIMARY]
GO
ALTER TABLE dbo.Vacaciones ADD CONSTRAINT
	FK_Vacaciones_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	)
GO
COMMIT


BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
COMMIT
BEGIN TRANSACTION
CREATE NONCLUSTERED INDEX IX_tEmpleados ON dbo.tEmpleados
	(
	Departamento
	) ON [PRIMARY]
GO
ALTER TABLE dbo.tEmpleados ADD CONSTRAINT
	FK_tEmpleados_tDepartamentos FOREIGN KEY
	(
	Departamento
	) REFERENCES dbo.tDepartamentos
	(
	Departamento
	)
GO
COMMIT


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoVacaciones]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoVacaciones]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qListadoVacaciones    Script Date: 31/12/00 10:25:55 a.m. *****
***** Object:  View dbo.qListadoVacaciones    Script Date: 28/11/00 07:01:20 p.m. *****
*/
CREATE VIEW dbo.qListadoVacaciones
AS
SELECT     dbo.Vacaciones.Empleado, dbo.tEmpleados.Nombre AS NombreEmpleado, dbo.tEmpleados.Departamento, 
                      dbo.tDepartamentos.Descripcion AS NombreDepartamento, dbo.tEmpleados.FechaIngreso, dbo.tEmpleados.FechaRetiro, 
                      dbo.Vacaciones.DiasDisfrutados, dbo.Vacaciones.Salida, dbo.Vacaciones.Regreso, dbo.Vacaciones.MontoBono, dbo.Vacaciones.FechaPagoBono, 
                      dbo.Vacaciones.Cia
FROM         dbo.Vacaciones INNER JOIN
                      dbo.tEmpleados ON dbo.Vacaciones.Empleado = dbo.tEmpleados.Empleado INNER JOIN
                      dbo.tDepartamentos ON dbo.tEmpleados.Departamento = dbo.tDepartamentos.Departamento

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO





--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.122', GetDate()) 
