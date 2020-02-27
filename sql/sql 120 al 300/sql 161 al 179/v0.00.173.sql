/*    Domingo, 13 de Marzo de 2.005   -   v0.00.173.sql 

	Agregamos el item DiasBono a las tablas de cantidad de días por vacaciones 
	(el item que ahora existe lo usamos como dias de disfrute!) 

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
CREATE TABLE dbo.Tmp_VacacPorAnoParticulares
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	Empleado int NOT NULL,
	Ano smallint NOT NULL,
	Dias int NOT NULL,
	DiasAdicionales smallint NULL,
	DiasBono smallint NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
SET IDENTITY_INSERT dbo.Tmp_VacacPorAnoParticulares ON
GO
IF EXISTS(SELECT * FROM dbo.VacacPorAnoParticulares)
	 EXEC('INSERT INTO dbo.Tmp_VacacPorAnoParticulares (ClaveUnica, Empleado, Ano, Dias, DiasAdicionales, Cia)
		SELECT ClaveUnica, Empleado, Ano, Dias, DiasAdicionales, Cia FROM dbo.VacacPorAnoParticulares TABLOCKX')
GO
SET IDENTITY_INSERT dbo.Tmp_VacacPorAnoParticulares OFF
GO
DROP TABLE dbo.VacacPorAnoParticulares
GO
EXECUTE sp_rename N'dbo.Tmp_VacacPorAnoParticulares', N'VacacPorAnoParticulares', 'OBJECT'
GO
ALTER TABLE dbo.VacacPorAnoParticulares ADD CONSTRAINT
	PK_VacacPorAnoParticulares PRIMARY KEY NONCLUSTERED 
	(
	ClaveUnica
	) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.VacacPorAnoGenericas ADD
	DiasBono smallint NULL
GO
COMMIT


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaVacacPorAnoGenericas]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaVacacPorAnoGenericas]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaVacacPorAnoParticulares]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaVacacPorAnoParticulares]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qFormaVacacPorAnoGenericas    Script Date: 31/12/00 10:25:54 a.m. *****
***** Object:  View dbo.qFormaVacacPorAnoGenericas    Script Date: 28/11/00 07:01:18 p.m. ******/
CREATE VIEW dbo.qFormaVacacPorAnoGenericas
AS
SELECT     ClaveUnica, Ano, Dias, DiasAdicionales, DiasBono
FROM         dbo.VacacPorAnoGenericas

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qFormaVacacPorAnoParticulares    Script Date: 31/12/00 10:25:54 a.m. *****
***** Object:  View dbo.qFormaVacacPorAnoParticulares    Script Date: 28/11/00 07:01:18 p.m. ******/
CREATE VIEW dbo.qFormaVacacPorAnoParticulares
AS
SELECT     ClaveUnica, Empleado, Ano, Dias, DiasAdicionales, DiasBono, Cia
FROM         dbo.VacacPorAnoParticulares

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO




if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoPrestacionesSociales]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoPrestacionesSociales]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoPrestacionesSociales
AS
SELECT     dbo.PrestacionesSociales.Empleado, dbo.tEmpleados.Nombre AS NombreEmpleado, dbo.PrestacionesSociales.Mes, dbo.PrestacionesSociales.Ano, 
                      dbo.PrestacionesSociales.FechaIngreso, dbo.PrestacionesSociales.AnosServicio, dbo.PrestacionesSociales.AnosServicioPrestaciones, 
                      dbo.PrestacionesSociales.Prorrata, dbo.PrestacionesSociales.SueldoBasico, dbo.PrestacionesSociales.SueldoBasicoDiario, 
                      dbo.PrestacionesSociales.DiasVacaciones, dbo.PrestacionesSociales.BonoVacacional, dbo.PrestacionesSociales.BonoVacacionalDiario, 
                      dbo.PrestacionesSociales.Utilidades, dbo.PrestacionesSociales.UtilidadesDiarias, dbo.PrestacionesSociales.SueldoDiarioAumentado, 
                      dbo.PrestacionesSociales.DiasPrestaciones, dbo.PrestacionesSociales.MontoPrestaciones, dbo.PrestacionesSociales.Cia
FROM         dbo.tEmpleados INNER JOIN
                      dbo.PrestacionesSociales ON dbo.tEmpleados.Empleado = dbo.PrestacionesSociales.Empleado

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO






--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.173', GetDate()) 

