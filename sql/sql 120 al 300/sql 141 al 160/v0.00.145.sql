/*    Jueves 23 de Enero de 2003   -   v0.00.145.sql 

	Agregamos los cambios necesarios para implementar el "calculo de vacaciones" a la
      nómina. 

*/ 


--  -----------------------------------
--  DiasFeriados y qFormaDiasFeriados
--  -----------------------------------



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaDiasFeriados]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaDiasFeriados]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DiasFeriados]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DiasFeriados]
GO

CREATE TABLE [dbo].[DiasFeriados] (
	[ClaveUnica] [int] IDENTITY (1, 1) NOT NULL ,
	[Fecha] [smalldatetime] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DiasFeriados] WITH NOCHECK ADD 
	CONSTRAINT [PK_DiasFeriados] PRIMARY KEY  CLUSTERED 
	(
		[ClaveUnica]
	)  ON [PRIMARY] 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaDiasFeriados
AS
SELECT     ClaveUnica, Fecha
FROM         dbo.DiasFeriados

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

--  -----------------------------------------------------------------------
--  agregamos el item DiasAdicionales a las tablas VacacPorAnoGenericas y 
--  VacacPorAnoParticulares
--  -----------------------------------------------------------------------


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
ALTER TABLE dbo.VacacPorAnoGenericas ADD
	DiasAdicionales smallint NULL
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
CREATE TABLE dbo.Tmp_VacacPorAnoParticulares
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	Empleado int NOT NULL,
	Ano smallint NOT NULL,
	Dias int NOT NULL,
	DiasAdicionales smallint NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
SET IDENTITY_INSERT dbo.Tmp_VacacPorAnoParticulares ON
GO
IF EXISTS(SELECT * FROM dbo.VacacPorAnoParticulares)
	 EXEC('INSERT INTO dbo.Tmp_VacacPorAnoParticulares (ClaveUnica, Empleado, Ano, Dias, Cia)
		SELECT ClaveUnica, Empleado, Ano, Dias, Cia FROM dbo.VacacPorAnoParticulares TABLOCKX')
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


--  -----------------------------------------------------------
--  qFormaVacacPorAnoGenericas y qFormaVacacPorAnoParticulares
--  -----------------------------------------------------------


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
SELECT     ClaveUnica, Ano, Dias, DiasAdicionales
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
SELECT     ClaveUnica, Empleado, Ano, Dias, DiasAdicionales, Cia
FROM         dbo.VacacPorAnoParticulares

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

--  ------------------------------------------------------
--  ParametrosGlobalNomina y RubrosDefinicionVacaciones
--  ------------------------------------------------------



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaRubrosDefinicionVacaciones]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaRubrosDefinicionVacaciones]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaParametrosGlobalNomina]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaParametrosGlobalNomina]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ParametrosGlobalNomina]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ParametrosGlobalNomina]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RubrosDefinicionVacaciones]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[RubrosDefinicionVacaciones]
GO

CREATE TABLE [dbo].[ParametrosGlobalNomina] (
	[ClaveUnica] [int] IDENTITY (1, 1) NOT NULL ,
	[UsarSalarioPromedioSueldoBasicoFlag] [smallint] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[RubrosDefinicionVacaciones] (
	[ClaveUnica] [int] IDENTITY (1, 1) NOT NULL ,
	[Rubro] [int] NOT NULL ,
	[Descripcion] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Concepto] [smallint] NOT NULL ,
	[BaseCalculoDeduccionesFlag] [bit] NOT NULL ,
	[CantidadDias] [smallint] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ParametrosGlobalNomina] WITH NOCHECK ADD 
	CONSTRAINT [PK_ParametrizacionVacaciones] PRIMARY KEY  CLUSTERED 
	(
		[ClaveUnica]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[RubrosDefinicionVacaciones] WITH NOCHECK ADD 
	CONSTRAINT [PK_RubrosDefinicionVacaciones] PRIMARY KEY  CLUSTERED 
	(
		[ClaveUnica]
	)  ON [PRIMARY] 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaParametrosGlobalNomina
AS
SELECT     ClaveUnica, UsarSalarioPromedioSueldoBasicoFlag
FROM         dbo.ParametrosGlobalNomina

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaRubrosDefinicionVacaciones
AS
SELECT     dbo.RubrosDefinicionVacaciones.ClaveUnica, dbo.RubrosDefinicionVacaciones.Rubro, dbo.RubrosDefinicionVacaciones.Descripcion, 
                      dbo.RubrosDefinicionVacaciones.Concepto, dbo.RubrosDefinicionVacaciones.BaseCalculoDeduccionesFlag, 
                      dbo.RubrosDefinicionVacaciones.CantidadDias, dbo.tMaestraRubros.Tipo
FROM         dbo.RubrosDefinicionVacaciones INNER JOIN
                      dbo.tMaestraRubros ON dbo.RubrosDefinicionVacaciones.Rubro = dbo.tMaestraRubros.Rubro

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

--  -------------------------------------------------
--  agregamos algunos items a la tabla Vacaciones 
--  -------------------------------------------------


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
ALTER TABLE dbo.Vacaciones
	DROP CONSTRAINT FK_Vacaciones_tEmpleados
GO
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.Tmp_Vacaciones
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	Empleado int NOT NULL,
	GrupoNomina int NULL, 
	TipoNomina char(1) NOT NULL,
	FechaIngreso smalldatetime NOT NULL,
	AnosServicio smallmoney NOT NULL,
	SalarioPromedio money NULL,
	SueldoBasico money NULL,
	UsarSalarioPromedioSueldoBasicoFlag smallint NULL,
	AnoVacacionesDesde smalldatetime NOT NULL,
	AnoVacacionesHasta smalldatetime NOT NULL,
	AnoVacaciones smallint NULL,
	Salida datetime NOT NULL,
	Regreso smalldatetime NOT NULL,
	DiasDisfrutados tinyint NOT NULL,
	FechaReintegro smalldatetime NOT NULL,
	FraccionAntesDesde smalldatetime NULL,
	FraccionAntesHasta smalldatetime NULL,
	CantDiasFraccionAntes tinyint NULL,
	FraccionDespuesDesde smalldatetime NULL,
	FraccionDespuesHasta smalldatetime NULL,
	FechaNomina smalldatetime NULL,
	CantDiasFraccionDespues tinyint NULL,
	MontoBono money NOT NULL,
	FechaPagoBono smalldatetime NOT NULL,
	ObviarEnLaNominaFlag bit NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
SET IDENTITY_INSERT dbo.Tmp_Vacaciones ON
GO
IF EXISTS(SELECT * FROM dbo.Vacaciones)
	 EXEC('INSERT INTO dbo.Tmp_Vacaciones (ClaveUnica, Empleado, TipoNomina, FechaIngreso, AnosServicio, SalarioPromedio, AnoVacacionesDesde, AnoVacacionesHasta, AnoVacaciones, Salida, Regreso, DiasDisfrutados, FechaReintegro, FraccionAntesDesde, FraccionAntesHasta, CantDiasFraccionAntes, FraccionDespuesDesde, FraccionDespuesHasta, CantDiasFraccionDespues, MontoBono, FechaPagoBono, ObviarEnLaNominaFlag, Cia)
		SELECT ClaveUnica, Empleado, TipoNomina, FechaIngreso, AnosServicio, SueldoPromedio, AnoVacacionesDesde, AnoVacacionesHasta, AnoVacaciones, Salida, Regreso, DiasDisfrutados, FechaReintegro, FraccionAntesDesde, FraccionAntesHasta, CantDiasFraccionAntes, FraccionDespuesDesde, FraccionDespuesHasta, CantDiasFraccionDespues, MontoBono, FechaPagoBono, ObviarEnLaNominaFlag, Cia FROM dbo.Vacaciones TABLOCKX')
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
	) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_Vacaciones ON dbo.Vacaciones
	(
	Empleado
	) ON [PRIMARY]
GO
ALTER TABLE dbo.Vacaciones WITH NOCHECK ADD CONSTRAINT
	FK_Vacaciones_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	)
GO
COMMIT

Update Vacaciones Set GrupoNomina = 1, FechaNomina = FechaPagoBono

--  ------------------------------------------------------------
--  con las siguientes instrucciones Transact Sql inicializamos el nuevo item 
--  FechaNomina en un valor no único. 
--  ------------------------------------------------------------


declare @dFechaNomina DateTime, @nClaveUnica Integer 

declare vacaciones_cursor cursor for 
	Select ClaveUnica From Vacaciones 

Open vacaciones_cursor 

Set @dFechaNomina = '1-1-1990' 

Fetch Next From vacaciones_cursor Into @nClaveUnica 

While @@FETCH_STATUS = 0 
	
	BEGIN 

		Update Vacaciones Set FechaNomina = @dFechaNomina Where 
                	ClaveUnica = @nClaveUnica   

		Set @dFechaNomina = DateAdd(day, 1, @dFechaNomina)

		Fetch Next From vacaciones_cursor Into @nClaveUnica 

	END 

Close vacaciones_cursor
Deallocate vacaciones_cursor 
Go 


--  ------------------------------------------------------------
--  qFormaControlVacaciones y qFormaControlVacacionesConsulta 
--  ------------------------------------------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaControlVacaciones]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaControlVacaciones]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaControlVacacionesConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaControlVacacionesConsulta]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaControlVacaciones
AS
SELECT     ClaveUnica, Empleado, GrupoNomina, TipoNomina, FechaIngreso, AnosServicio, SalarioPromedio, SueldoBasico, UsarSalarioPromedioSueldoBasicoFlag, 
                      AnoVacacionesDesde, AnoVacacionesHasta, AnoVacaciones, Salida, Regreso, DiasDisfrutados, FechaReintegro, FraccionAntesDesde, 
                      FraccionAntesHasta, CantDiasFraccionAntes, FraccionDespuesDesde, FraccionDespuesHasta, CantDiasFraccionDespues, FechaNomina, MontoBono, 
                      FechaPagoBono, ObviarEnLaNominaFlag, Cia
FROM         dbo.Vacaciones

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaControlVacacionesConsulta
AS
SELECT     dbo.Vacaciones.Empleado, dbo.Vacaciones.GrupoNomina, dbo.tEmpleados.Nombre AS NombreEmpleado, dbo.Vacaciones.Salida, dbo.Vacaciones.Regreso, 
                      dbo.Vacaciones.DiasDisfrutados, dbo.Vacaciones.MontoBono, dbo.Vacaciones.FechaPagoBono, dbo.Vacaciones.Cia, dbo.Vacaciones.ClaveUnica, 
                      dbo.Vacaciones.TipoNomina, dbo.Vacaciones.FechaIngreso, dbo.Vacaciones.AnosServicio, dbo.Vacaciones.SalarioPromedio, 
                      dbo.Vacaciones.SueldoBasico, dbo.Vacaciones.UsarSalarioPromedioSueldoBasicoFlag, dbo.Vacaciones.AnoVacacionesDesde, 
                      dbo.Vacaciones.AnoVacacionesHasta, dbo.Vacaciones.AnoVacaciones, dbo.Vacaciones.FechaReintegro, dbo.Vacaciones.FraccionAntesDesde, 
                      dbo.Vacaciones.FraccionAntesHasta, dbo.Vacaciones.CantDiasFraccionAntes, dbo.Vacaciones.FraccionDespuesDesde, 
                      dbo.Vacaciones.FraccionDespuesHasta, dbo.Vacaciones.CantDiasFraccionDespues, dbo.Vacaciones.FechaNomina, 
                      dbo.Vacaciones.ObviarEnLaNominaFlag
FROM         dbo.Vacaciones LEFT OUTER JOIN
                      dbo.tEmpleados ON dbo.Vacaciones.Empleado = dbo.tEmpleados.Empleado AND dbo.Vacaciones.Cia = dbo.tEmpleados.Cia

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

--  ----------------------------------------------------------------------------------------
--  hacemos GrupoNomina y FechaNomina not null. Además, creamos el constraint (unique) por: 
--  empleado, gruponomina, fechanomina y cia. 
--  ----------------------------------------------------------------------------------------



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
ALTER TABLE dbo.Vacaciones
	DROP CONSTRAINT FK_Vacaciones_tEmpleados
GO
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.Tmp_Vacaciones
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	Empleado int NOT NULL,
	GrupoNomina int NOT NULL,
	TipoNomina char(1) NOT NULL,
	FechaIngreso smalldatetime NOT NULL,
	AnosServicio smallmoney NOT NULL,
	SalarioPromedio money NULL,
	SueldoBasico money NULL,
	UsarSalarioPromedioSueldoBasicoFlag smallint NULL,
	AnoVacacionesDesde smalldatetime NOT NULL,
	AnoVacacionesHasta smalldatetime NOT NULL,
	AnoVacaciones smallint NULL,
	Salida datetime NOT NULL,
	Regreso smalldatetime NOT NULL,
	DiasDisfrutados tinyint NOT NULL,
	FechaReintegro smalldatetime NOT NULL,
	FraccionAntesDesde smalldatetime NULL,
	FraccionAntesHasta smalldatetime NULL,
	CantDiasFraccionAntes tinyint NULL,
	FraccionDespuesDesde smalldatetime NULL,
	FraccionDespuesHasta smalldatetime NULL,
	FechaNomina smalldatetime NOT NULL,
	CantDiasFraccionDespues tinyint NULL,
	MontoBono money NOT NULL,
	FechaPagoBono smalldatetime NOT NULL,
	ObviarEnLaNominaFlag bit NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
SET IDENTITY_INSERT dbo.Tmp_Vacaciones ON
GO
IF EXISTS(SELECT * FROM dbo.Vacaciones)
	 EXEC('INSERT INTO dbo.Tmp_Vacaciones (ClaveUnica, Empleado, GrupoNomina, TipoNomina, FechaIngreso, AnosServicio, SalarioPromedio, SueldoBasico, UsarSalarioPromedioSueldoBasicoFlag, AnoVacacionesDesde, AnoVacacionesHasta, AnoVacaciones, Salida, Regreso, DiasDisfrutados, FechaReintegro, FraccionAntesDesde, FraccionAntesHasta, CantDiasFraccionAntes, FraccionDespuesDesde, FraccionDespuesHasta, FechaNomina, CantDiasFraccionDespues, MontoBono, FechaPagoBono, ObviarEnLaNominaFlag, Cia)
		SELECT ClaveUnica, Empleado, GrupoNomina, TipoNomina, FechaIngreso, AnosServicio, SalarioPromedio, SueldoBasico, UsarSalarioPromedioSueldoBasicoFlag, AnoVacacionesDesde, AnoVacacionesHasta, AnoVacaciones, Salida, Regreso, DiasDisfrutados, FechaReintegro, FraccionAntesDesde, FraccionAntesHasta, CantDiasFraccionAntes, FraccionDespuesDesde, FraccionDespuesHasta, FechaNomina, CantDiasFraccionDespues, MontoBono, FechaPagoBono, ObviarEnLaNominaFlag, Cia FROM dbo.Vacaciones TABLOCKX')
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
	) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_Vacaciones ON dbo.Vacaciones
	(
	Empleado
	) ON [PRIMARY]
GO
ALTER TABLE dbo.Vacaciones ADD CONSTRAINT
	IX_Vacaciones_1 UNIQUE NONCLUSTERED 
	(
	Empleado,
	GrupoNomina,
	FechaNomina,
	Cia
	) ON [PRIMARY]

GO
ALTER TABLE dbo.Vacaciones WITH NOCHECK ADD CONSTRAINT
	FK_Vacaciones_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	)
GO
COMMIT


--  ---------------------------------------------------
--  RubrosControlVacaciones (y views que corresponden) 
--  ---------------------------------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaControlVacacionesConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaControlVacacionesConsulta]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaRubrosControlVacaciones]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaRubrosControlVacaciones]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaRubrosControlVacacionesConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaRubrosControlVacacionesConsulta]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RubrosControlVacaciones]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[RubrosControlVacaciones]
GO

CREATE TABLE [dbo].[RubrosControlVacaciones] (
	[ClaveUnica] [int] IDENTITY (1, 1) NOT NULL ,
	[Empleado] [int] NOT NULL ,
	[GrupoNomina] [int] NOT NULL ,
	[FechaNomina] [smalldatetime] NOT NULL ,
	[Rubro] [int] NOT NULL ,
	[Descripcion] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Tipo] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[CantidadDias] [smallint] NULL ,
	[MontoBase] [money] NULL ,
	[Monto] [money] NOT NULL ,
	[Cia] [int] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[RubrosControlVacaciones] WITH NOCHECK ADD 
	CONSTRAINT [PK_RubrosControlVacaciones] PRIMARY KEY  CLUSTERED 
	(
		[ClaveUnica]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [IX_RubrosControlVacaciones] ON [dbo].[RubrosControlVacaciones]([Empleado], [GrupoNomina], [FechaNomina], [Cia]) ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaRubrosControlVacaciones
AS
SELECT     ClaveUnica, Empleado, GrupoNomina, FechaNomina, Rubro, Descripcion, Tipo, CantidadDias, MontoBase, Monto, Cia
FROM         dbo.RubrosControlVacaciones

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaRubrosControlVacacionesConsulta
AS
SELECT     ClaveUnica, Empleado, GrupoNomina, FechaNomina, Rubro, Descripcion, Tipo, CantidadDias, MontoBase, Monto, Cia
FROM         dbo.RubrosControlVacaciones

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaControlVacacionesConsulta
AS
SELECT     dbo.Vacaciones.Empleado, dbo.Vacaciones.GrupoNomina, dbo.tGruposEmpleados.NombreGrupo, dbo.tEmpleados.Nombre AS NombreEmpleado, 
                      dbo.Vacaciones.Salida, dbo.Vacaciones.Regreso, dbo.Vacaciones.DiasDisfrutados, dbo.Vacaciones.MontoBono, dbo.Vacaciones.FechaPagoBono, 
                      dbo.Vacaciones.Cia, dbo.Vacaciones.ClaveUnica, dbo.Vacaciones.TipoNomina, dbo.Vacaciones.FechaIngreso, dbo.Vacaciones.AnosServicio, 
                      dbo.Vacaciones.SalarioPromedio, dbo.Vacaciones.SueldoBasico, dbo.Vacaciones.UsarSalarioPromedioSueldoBasicoFlag, 
                      dbo.Vacaciones.AnoVacacionesDesde, dbo.Vacaciones.AnoVacacionesHasta, dbo.Vacaciones.AnoVacaciones, dbo.Vacaciones.FechaReintegro, 
                      dbo.Vacaciones.FraccionAntesDesde, dbo.Vacaciones.FraccionAntesHasta, dbo.Vacaciones.CantDiasFraccionAntes, 
                      dbo.Vacaciones.FraccionDespuesDesde, dbo.Vacaciones.FraccionDespuesHasta, dbo.Vacaciones.CantDiasFraccionDespues, 
                      dbo.Vacaciones.FechaNomina, dbo.Vacaciones.ObviarEnLaNominaFlag
FROM         dbo.Vacaciones INNER JOIN
                      dbo.tGruposEmpleados ON dbo.Vacaciones.Cia = dbo.tGruposEmpleados.Cia AND 
                      dbo.Vacaciones.GrupoNomina = dbo.tGruposEmpleados.Grupo LEFT OUTER JOIN
                      dbo.tEmpleados ON dbo.Vacaciones.Empleado = dbo.tEmpleados.Empleado AND dbo.Vacaciones.Cia = dbo.tEmpleados.Cia

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.145', GetDate()) 

