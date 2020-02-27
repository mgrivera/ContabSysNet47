/*    Miercoles, 21 de Agosto de 2002   -   v0.00.132.sql 

	Cambiamos la tabla UltimaNominaProcesada. 

*/ 


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaUltimaNominaProcesada]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaUltimaNominaProcesada]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[UltimaNominaProcesada]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[UltimaNominaProcesada]
GO

CREATE TABLE [dbo].[UltimaNominaProcesada] (
	[GrupoNomina] [int] NOT NULL ,
	[TipoNomina] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[FechaUltimaNominaProcesada] [smalldatetime] NOT NULL ,
	[CalcularPrestacionesFlag] [bit] NOT NULL ,
	[PrestacionesLeerNominaDelMesFlag] [bit] NOT NULL ,
	[PrestacionesDesde] [smalldatetime] NULL ,
	[PrestacionesHasta] [smalldatetime] NULL ,
	[Cia] [int] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UltimaNominaProcesada] WITH NOCHECK ADD 
	CONSTRAINT [PK_UltimaNominaProcesada] PRIMARY KEY  NONCLUSTERED 
	(
		[GrupoNomina],
		[Cia]
	)  ON [PRIMARY] 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qFormaUltimaNominaProcesada    Script Date: 15-May-01 12:13:57 PM *****
***** Object:  View dbo.qFormaUltimaNominaProcesada    Script Date: 28/11/00 07:01:18 p.m. ******/
CREATE VIEW dbo.qFormaUltimaNominaProcesada
AS
SELECT     GrupoNomina, TipoNomina, FechaUltimaNominaProcesada, CalcularPrestacionesFlag, PrestacionesLeerNominaDelMesFlag, PrestacionesDesde, 
                      PrestacionesHasta, Cia
FROM         dbo.UltimaNominaProcesada

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



--  -----------------------------------------------------------------------------------------
--  agregamos el item GrupoNomina a la tabla tNomina. Notese como, para asignarle un valor, 
--  agregamos el grupo de empleados (sin empleados) -1 a la tabla tGruposEmpleados 
--  -----------------------------------------------------------------------------------------


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
CREATE TABLE dbo.Tmp_tNomina
	(
	NumeroUnico int NOT NULL IDENTITY (1, 1),
	GrupoNomina int NULL,
	Empleado int NOT NULL,
	FechaNomina smalldatetime NOT NULL,
	Nomina nvarchar(4) NOT NULL,
	Mes smallint NOT NULL,
	Ano smallint NOT NULL,
	Rubro int NOT NULL,
	Tipo char(1) NOT NULL,
	Descripcion nvarchar(250) NOT NULL,
	Monto money NOT NULL,
	FechaEjecucion datetime NOT NULL,
	AplicaPrestacionesFlag bit NULL,
	TipoNomina nvarchar(2) NOT NULL,
	MostrarEnElReciboFlag bit NULL,
	CantDiasBase tinyint NULL,
	CantDias tinyint NULL,
	VacFraccionFlag char(1) NULL,
	FraccionarFlag bit NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
SET IDENTITY_INSERT dbo.Tmp_tNomina ON
GO
IF EXISTS(SELECT * FROM dbo.tNomina)
	 EXEC('INSERT INTO dbo.Tmp_tNomina (NumeroUnico, Empleado, FechaNomina, Nomina, Mes, Ano, Rubro, Tipo, Descripcion, Monto, FechaEjecucion, AplicaPrestacionesFlag, TipoNomina, MostrarEnElReciboFlag, CantDiasBase, CantDias, VacFraccionFlag, FraccionarFlag, Cia)
		SELECT NumeroUnico, Empleado, FechaNomina, Nomina, Mes, Ano, Rubro, Tipo, Descripcion, Monto, FechaEjecucion, AplicaPrestacionesFlag, TipoNomina, MostrarEnElReciboFlag, CantDiasBase, CantDias, VacFraccionFlag, FraccionarFlag, Cia FROM dbo.tNomina TABLOCKX')
GO
SET IDENTITY_INSERT dbo.Tmp_tNomina OFF
GO
DROP TABLE dbo.tNomina
GO
EXECUTE sp_rename N'dbo.Tmp_tNomina', N'tNomina', 'OBJECT'
GO
ALTER TABLE dbo.tNomina ADD CONSTRAINT
	PK_tNomina PRIMARY KEY NONCLUSTERED 
	(
	NumeroUnico
	) ON [PRIMARY]

GO
COMMIT


--  ---------------------------------------------------------------------
--  agregamos el grupo -1 por cada compañia a la tabla tGruposEmpleados 
--  (notese como lo primero que hacemos es cambiar el PK en tGruposEmpleados de Grupo
--   a Grupo y Cia). 
--  ---------------------------------------------------------------------

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
ALTER TABLE dbo.tGruposEmpleados
	DROP CONSTRAINT PK_tGruposEmpleados
GO
ALTER TABLE dbo.tGruposEmpleados ADD CONSTRAINT
	PK_tGruposEmpleados PRIMARY KEY NONCLUSTERED 
	(
	Grupo,
	Cia
	) ON [PRIMARY]

GO
COMMIT


DECLARE @NumeroCia Int 
Declare CiasCursor Cursor For Select Numero From Companias

Open CiasCursor

Fetch Next From CiasCursor Into @NumeroCia 

While @@Fetch_status = 0 

	Begin 

		Insert Into tGruposEmpleados (Grupo, NombreGrupo, Descripcion, GrupoNominaFlag, Cia) 
					Values (-1, 'INICIAL', 'Grupo inicial de nómina', 1, @NumeroCia)

		Fetch Next From CiasCursor Into @NumeroCia 			

	End 

Close CiasCursor
Deallocate CiasCursor

--  ---------------------------------------------------------------------
--  actualizamos el nuevo item GrupoNomina en tNomina al grupo -1. Además, 
--  hacemos este item Not Null y creamos una relación con tGruposNomina 
--  ---------------------------------------------------------------------

Update tNomina Set GrupoNomina = -1 

Alter Table tNomina Alter Column GrupoNomina Int Not Null 

--  ---------------------------------------------------------------------
--  creamos una relación entre tGruposNomina y tNomina. La relación es 
--  por los items: GrupoNomina y Cia
--  ---------------------------------------------------------------------

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
CREATE NONCLUSTERED INDEX IX_tNomina ON dbo.tNomina
	(
	GrupoNomina,
	Cia
	) ON [PRIMARY]
GO
ALTER TABLE dbo.tNomina ADD CONSTRAINT
	FK_tNomina_tGruposEmpleados FOREIGN KEY
	(
	GrupoNomina,
	Cia
	) REFERENCES dbo.tGruposEmpleados
	(
	Grupo,
	Cia
	)
GO
COMMIT



--  ----------------------------------------------------
--  por último actualizamos el view qFormaConsultaNomina
--  ----------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaConsultaNomina]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaConsultaNomina]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaConsultaNomina
AS
SELECT     dbo.tNomina.GrupoNomina, dbo.tGruposEmpleados.NombreGrupo AS NombreGrupoNomina, dbo.tNomina.Empleado, 
                      dbo.tEmpleados.Nombre AS NombreEmpleado, dbo.tNomina.FechaNomina, dbo.tNomina.Nomina, dbo.tNomina.Mes, dbo.tNomina.Ano, 
                      dbo.tNomina.Nomina + ' ' + CONVERT(Char(2), dbo.tNomina.Mes) + ' ' + CONVERT(Char(4), dbo.tNomina.Ano) AS NominaEditada, dbo.tNomina.Rubro, 
                      dbo.tMaestraRubros.NombreCortoRubro, dbo.tNomina.Tipo, dbo.tNomina.Descripcion, 
                      dbo.tMaestraRubros.NombreCortoRubro + ' - ' + dbo.tNomina.Descripcion AS NombreYDescripcion, dbo.tNomina.Monto, dbo.tNomina.FechaEjecucion, 
                      dbo.tNomina.TipoNomina, dbo.tNomina.AplicaPrestacionesFlag, dbo.tNomina.Cia, dbo.tNomina.MostrarEnElReciboFlag, dbo.tNomina.CantDiasBase, 
                      dbo.tNomina.CantDias, dbo.tNomina.VacFraccionFlag
FROM         dbo.tNomina INNER JOIN
                      dbo.tGruposEmpleados ON dbo.tNomina.GrupoNomina = dbo.tGruposEmpleados.Grupo AND 
                      dbo.tNomina.Cia = dbo.tGruposEmpleados.Cia LEFT OUTER JOIN
                      dbo.tMaestraRubros ON dbo.tNomina.Rubro = dbo.tMaestraRubros.Rubro LEFT OUTER JOIN
                      dbo.tEmpleados ON dbo.tNomina.Empleado = dbo.tEmpleados.Empleado

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

--  ---------------------------------------------------------
--  quitamos los items Nomina, Mes y Año a la tabla tNomina 
--  ---------------------------------------------------------


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
ALTER TABLE dbo.tNomina
	DROP COLUMN Nomina, Mes, Ano
GO
COMMIT



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaConsultaNomina]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaConsultaNomina]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaConsultaNomina
AS
SELECT     dbo.tNomina.GrupoNomina, dbo.tGruposEmpleados.NombreGrupo AS NombreGrupoNomina, dbo.tNomina.Empleado, 
                      dbo.tEmpleados.Nombre AS NombreEmpleado, dbo.tNomina.FechaNomina, dbo.tNomina.Rubro, dbo.tMaestraRubros.NombreCortoRubro, 
                      dbo.tNomina.Tipo, dbo.tNomina.Descripcion, dbo.tMaestraRubros.NombreCortoRubro + ' - ' + dbo.tNomina.Descripcion AS NombreYDescripcion, 
                      dbo.tNomina.Monto, dbo.tNomina.FechaEjecucion, dbo.tNomina.TipoNomina, dbo.tNomina.AplicaPrestacionesFlag, dbo.tNomina.Cia, 
                      dbo.tNomina.MostrarEnElReciboFlag, dbo.tNomina.CantDiasBase, dbo.tNomina.CantDias, dbo.tNomina.VacFraccionFlag
FROM         dbo.tNomina INNER JOIN
                      dbo.tGruposEmpleados ON dbo.tNomina.GrupoNomina = dbo.tGruposEmpleados.Grupo AND 
                      dbo.tNomina.Cia = dbo.tGruposEmpleados.Cia LEFT OUTER JOIN
                      dbo.tMaestraRubros ON dbo.tNomina.Rubro = dbo.tMaestraRubros.Rubro LEFT OUTER JOIN
                      dbo.tEmpleados ON dbo.tNomina.Empleado = dbo.tEmpleados.Empleado

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.132', GetDate()) 
