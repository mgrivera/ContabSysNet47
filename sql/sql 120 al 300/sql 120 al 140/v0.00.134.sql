/*    Martes, 27 de Agosto de 2002   -   v0.00.134.sql 

	Eliminamos los items Mes y Año a la tabla PrestacionesSociales. 

*/ 


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
ALTER TABLE dbo.PrestacionesSociales
	DROP COLUMN Mes, Ano
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
ALTER TABLE dbo.tTempListadoPrestacionesSociales
	DROP COLUMN Mes, Ano
GO
COMMIT

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaPrestacionesSocialesConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaPrestacionesSocialesConsulta]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoPrestacionesSociales]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoPrestacionesSociales]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaPrestacionesSociales]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaPrestacionesSociales]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qFormaPrestacionesSociales    Script Date: 28/11/00 07:01:16 p.m. ******/
CREATE VIEW dbo.qFormaPrestacionesSociales
AS
SELECT     ClaveUnica, Empleado, Fecha, ManualAutoFlag, Concepto, Motivo, Monto, Cia
FROM         dbo.PrestacionesSociales

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qFormaPrestacionesSocialesConsulta    Script Date: 28/11/00 07:01:17 p.m. ******/
CREATE VIEW dbo.qFormaPrestacionesSocialesConsulta
AS
SELECT     dbo.PrestacionesSociales.ClaveUnica, dbo.PrestacionesSociales.Empleado, dbo.tEmpleados.Nombre AS NombreEmpleado, 
                      dbo.PrestacionesSociales.Fecha, dbo.PrestacionesSociales.ManualAutoFlag, dbo.PrestacionesSociales.Concepto, dbo.PrestacionesSociales.Motivo, 
                      dbo.PrestacionesSociales.Monto, dbo.PrestacionesSociales.Cia
FROM         dbo.PrestacionesSociales LEFT OUTER JOIN
                      dbo.tEmpleados ON dbo.PrestacionesSociales.Empleado = dbo.tEmpleados.Empleado

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoPrestacionesSociales
AS
SELECT     dbo.tTempListadoPrestacionesSociales.Empleado, dbo.tEmpleados.Nombre AS NombreEmpleado, dbo.tTempListadoPrestacionesSociales.Fecha, 
                      dbo.tTempListadoPrestacionesSociales.ManualAutoFlag, dbo.tTempListadoPrestacionesSociales.Concepto, 
                      dbo.tTempListadoPrestacionesSociales.NombreConcepto, dbo.tTempListadoPrestacionesSociales.NombreMotivo, 
                      dbo.tTempListadoPrestacionesSociales.SaldoAnterior, dbo.tTempListadoPrestacionesSociales.Monto, dbo.tTempListadoPrestacionesSociales.Saldo, 
                      dbo.tTempListadoPrestacionesSociales.NumeroUsuario
FROM         dbo.tTempListadoPrestacionesSociales LEFT OUTER JOIN
                      dbo.tEmpleados ON dbo.tTempListadoPrestacionesSociales.Empleado = dbo.tEmpleados.Empleado

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.134', GetDate()) 

