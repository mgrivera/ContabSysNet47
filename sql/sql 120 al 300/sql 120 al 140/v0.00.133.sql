/*    Miercoles, 26 de Agosto de 2002   -   v0.00.133.sql 

	Modificamos las tablas 'temporales' que se usan para obtener los listados 
	de la nómina. 

*/ 


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoNomina]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoNomina]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tTempListadoNomina]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tTempListadoNomina]
GO

CREATE TABLE [dbo].[tTempListadoNomina] (
	[ClaveUnica] [int] IDENTITY (1, 1) NOT NULL ,
	[GrupoNomina] [int] NULL ,
	[FechaNomina] [smalldatetime] NULL ,
	[Departamento] [int] NULL ,
	[NombreDepartamento] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Empleado] [int] NULL ,
	[NombreEmpleado] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Cedula] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FechaIngreso] [datetime] NULL ,
	[Rubro] [int] NULL ,
	[TipoRubro] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NombreRubro] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Asignacion] [money] NULL ,
	[Deduccion] [money] NULL ,
	[Total] [money] NULL ,
	[VacFraccionFlag] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FechaEjecucion] [datetime] NULL ,
	[NumeroUsuario] [int] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tTempListadoNomina] WITH NOCHECK ADD 
	CONSTRAINT [PK_tTempListadoNomina] PRIMARY KEY  NONCLUSTERED 
	(
		[ClaveUnica]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [IX_tTempListadoNomina] ON [dbo].[tTempListadoNomina]([NumeroUsuario]) ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoNomina
AS
SELECT     ClaveUnica, GrupoNomina, FechaNomina, Departamento, NombreDepartamento, Empleado, NombreEmpleado, Rubro, TipoRubro, NombreRubro, Asignacion, 
                      Deduccion, Total, FechaEjecucion, NumeroUsuario, Cedula, FechaIngreso, VacFraccionFlag
FROM         dbo.tTempListadoNomina

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO






if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoRecibosDePago]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoRecibosDePago]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qReportListadoAlBanco]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qReportListadoAlBanco]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tTempListadoAlBanco]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tTempListadoAlBanco]
GO

CREATE TABLE [dbo].[tTempListadoAlBanco] (
	[ClaveUnica] [int] IDENTITY (1, 1) NOT NULL ,
	[GrupoNomina] [int] NULL ,
	[FechaNomina] [smalldatetime] NULL ,
	[Empleado] [int] NOT NULL ,
	[NombreEmpleado] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Cedula] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Banco] [int] NULL ,
	[CuentaBancaria] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NombreBanco] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TipoCuentaBancaria] [int] NULL ,
	[NombreTipoCuentaBancaria] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Monto] [money] NOT NULL ,
	[Cia] [int] NOT NULL ,
	[NumeroUsuario] [int] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tTempListadoAlBanco] WITH NOCHECK ADD 
	CONSTRAINT [PK_tTempListadoAlBanco] PRIMARY KEY  NONCLUSTERED 
	(
		[ClaveUnica]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [IX_tTempListadoAlBanco] ON [dbo].[tTempListadoAlBanco]([NumeroUsuario]) ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qReportListadoAlBanco
AS
SELECT     ClaveUnica, GrupoNomina, FechaNomina, Empleado, NombreEmpleado, Cedula, Banco, CuentaBancaria, NombreBanco, TipoCuentaBancaria, 
                      NombreTipoCuentaBancaria, Monto, Cia, NumeroUsuario
FROM         dbo.tTempListadoAlBanco

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoRecibosDePago
AS
SELECT     tNomina.NumeroUnico, tNomina.GrupoNomina, tNomina.FechaNomina, tNomina.Empleado, tEmpleados.Nombre AS NombreEmpleado, 
                      tEmpleados.SueldoPromedio, tEmpleados.SueldoBasico, tEmpleados.SituacionActual, tEmpleados.Cedula, tEmpleados.Departamento, 
                      tDepartamentos.Descripcion AS NombreDepartamento, tEmpleados.Banco, Bancos.Nombre AS NombreBanco, tEmpleados.CuentaBancaria, 
                      tNomina.Rubro, tNomina.Descripcion AS NombreRubro, tNomina.Tipo, tNomina.Monto, Monto AS Asignacion, 0 AS Deduccion, tNomina.Monto AS Total, 
                      1 AS Signo, tNomina.VacFraccionFlag, tNomina.Cia
FROM         ((tNomina LEFT JOIN
                      tEmpleados ON tNomina.Empleado = tEmpleados.Empleado) LEFT JOIN
                      tDepartamentos ON tEmpleados.Departamento = tDepartamentos.Departamento) LEFT JOIN
                      Bancos ON tEmpleados.Banco = Bancos.Banco
WHERE     Tipo = 'A' AND tNomina.MostrarEnElReciboFlag = 1
UNION
SELECT     tNomina.NumeroUnico, tNomina.GrupoNomina, tNomina.FechaNomina, tNomina.Empleado, tEmpleados.Nombre AS NombreEmpleado, 
                      tEmpleados.SueldoPromedio, tEmpleados.SueldoBasico, tEmpleados.SituacionActual, tEmpleados.Cedula, tEmpleados.Departamento, 
                      tDepartamentos.Descripcion AS NombreDepartamento, tEmpleados.Banco, Bancos.Nombre AS NombreBanco, tEmpleados.CuentaBancaria, 
                      tNomina.Rubro, tNomina.Descripcion AS NombreRubro, tNomina.Tipo, tNomina.Monto, 0 AS Asignacion, Monto * - 1 AS Deduccion, 
                      tNomina.Monto AS Total, 2 AS Signo, tNomina.VacFraccionFlag, tNomina.Cia
FROM         ((tNomina LEFT JOIN
                      tEmpleados ON tNomina.Empleado = tEmpleados.Empleado) LEFT JOIN
                      tDepartamentos ON tEmpleados.Departamento = tDepartamentos.Departamento) LEFT JOIN
                      Bancos ON tEmpleados.Banco = Bancos.Banco
WHERE     Tipo = 'D' AND tNomina.MostrarEnElReciboFlag = 1

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


--  ----------------------------------------------------------------------------------
--  modificamos levemente la tabla tPrestamos para que el listado de recibos pueda 
--  tratarla como siempre
--  ----------------------------------------------------------------------------------


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
CREATE TABLE dbo.Tmp_tPrestamos
	(
	Numero int NOT NULL,
	Tipo int NOT NULL,
	Empleado int NOT NULL,
	Rubro int NOT NULL,
	Periodicidad nvarchar(2) NOT NULL,
	NumeroDeCuotas smallint NOT NULL,
	FechaPrimeraCuota smalldatetime NOT NULL,
	Situacion nvarchar(2) NOT NULL,
	FechaSolicitado datetime NOT NULL,
	FechaOtorgado datetime NULL,
	FechaCancelado datetime NULL,
	FechaAnulado datetime NULL,
	MontoSolicitado money NOT NULL,
	PorcIntereses money NULL,
	TotalAPagar money NOT NULL,
	MontoCancelado money NULL,
	Saldo money NULL,
	ImprimirRecibo bit NULL,
	FechaNominaActual smalldatetime NULL,
	MontoCuotasOrdinarias money NULL,
	MontoCuotasEspeciales money NULL,
	NumeroCuotasEspeciales smallint NULL,
	RubroIntereses int NULL,
	MontoCuota money NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.tPrestamos)
	 EXEC('INSERT INTO dbo.Tmp_tPrestamos (Numero, Tipo, Empleado, Rubro, Periodicidad, NumeroDeCuotas, FechaPrimeraCuota, Situacion, FechaSolicitado, FechaOtorgado, FechaCancelado, FechaAnulado, MontoSolicitado, PorcIntereses, TotalAPagar, MontoCancelado, Saldo, ImprimirRecibo, MontoCuotasOrdinarias, MontoCuotasEspeciales, NumeroCuotasEspeciales, RubroIntereses, MontoCuota, Cia)
		SELECT Numero, Tipo, Empleado, Rubro, Periodicidad, NumeroDeCuotas, FechaPrimeraCuota, Situacion, FechaSolicitado, FechaOtorgado, FechaCancelado, FechaAnulado, MontoSolicitado, PorcIntereses, TotalAPagar, MontoCancelado, Saldo, ImprimirRecibo, MontoCuotasOrdinarias, MontoCuotasEspeciales, NumeroCuotasEspeciales, RubroIntereses, MontoCuota, Cia FROM dbo.tPrestamos TABLOCKX')
GO
DROP TABLE dbo.tPrestamos
GO
EXECUTE sp_rename N'dbo.Tmp_tPrestamos', N'tPrestamos', 'OBJECT'
GO
ALTER TABLE dbo.tPrestamos ADD CONSTRAINT
	PK_tPrestamos PRIMARY KEY NONCLUSTERED 
	(
	Numero
	) ON [PRIMARY]

GO
COMMIT






if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoSubReportRecibosDePago]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoSubReportRecibosDePago]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qListadoSubReportRecibosDePago    Script Date: 15-May-01 12:13:57 PM *****
***** Object:  View dbo.qListadoSubReportRecibosDePago    Script Date: 28/11/00 07:01:19 p.m. *****

*/
CREATE VIEW dbo.qListadoSubReportRecibosDePago
AS
SELECT     dbo.tPrestamos.Empleado, dbo.tPrestamos.Numero, dbo.tPrestamos.TotalAPagar, dbo.tCuotasPrestamos.Monto AS CuotaPagada, 
                      dbo.tPrestamos.MontoCancelado AS TotalPagado, dbo.tPrestamos.Saldo
FROM         dbo.tPrestamos INNER JOIN
                      dbo.tCuotasPrestamos ON dbo.tPrestamos.Numero = dbo.tCuotasPrestamos.Prestamo AND 
                      dbo.tPrestamos.FechaNominaActual = dbo.tCuotasPrestamos.FechaCuota AND dbo.tPrestamos.Cia = dbo.tCuotasPrestamos.Cia
WHERE     (dbo.tPrestamos.ImprimirRecibo = 1)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

--  -----------------------------------------------------
--  agregamos un PK a la tabla TiposDeCuentaBancaria
--  -----------------------------------------------------


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
ALTER TABLE dbo.TiposDeCuentaBancaria ADD CONSTRAINT
	PK_TiposDeCuentaBancaria PRIMARY KEY CLUSTERED 
	(
	TipoCuenta
	) ON [PRIMARY]

GO
COMMIT



--  ----------------------------------
--  redefinimos qListadoRecibosDePago
--  ----------------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoRecibosDePago]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoRecibosDePago]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoRecibosDePago
AS
SELECT     tNomina.NumeroUnico, tNomina.GrupoNomina, tNomina.FechaNomina, tNomina.TipoNomina, tNomina.Empleado, 
                      tEmpleados.Nombre AS NombreEmpleado, tEmpleados.SueldoPromedio, tEmpleados.SueldoBasico, tEmpleados.SituacionActual, tEmpleados.Cedula, 
                      tEmpleados.Departamento, tDepartamentos.Descripcion AS NombreDepartamento, tEmpleados.Banco, Bancos.Nombre AS NombreBanco, 
                      tEmpleados.CuentaBancaria, tNomina.Rubro, tNomina.Descripcion AS NombreRubro, tNomina.Tipo, tNomina.Monto, Monto AS Asignacion, 
                      0 AS Deduccion, tNomina.Monto AS Total, 1 AS Signo, tNomina.VacFraccionFlag, tNomina.Cia
FROM         ((tNomina LEFT JOIN
                      tEmpleados ON tNomina.Empleado = tEmpleados.Empleado) LEFT JOIN
                      tDepartamentos ON tEmpleados.Departamento = tDepartamentos.Departamento) LEFT JOIN
                      Bancos ON tEmpleados.Banco = Bancos.Banco
WHERE     Tipo = 'A' AND tNomina.MostrarEnElReciboFlag = 1
UNION
SELECT     tNomina.NumeroUnico, tNomina.GrupoNomina, tNomina.FechaNomina, tNomina.TipoNomina, tNomina.Empleado, 
                      tEmpleados.Nombre AS NombreEmpleado, tEmpleados.SueldoPromedio, tEmpleados.SueldoBasico, tEmpleados.SituacionActual, tEmpleados.Cedula, 
                      tEmpleados.Departamento, tDepartamentos.Descripcion AS NombreDepartamento, tEmpleados.Banco, Bancos.Nombre AS NombreBanco, 
                      tEmpleados.CuentaBancaria, tNomina.Rubro, tNomina.Descripcion AS NombreRubro, tNomina.Tipo, tNomina.Monto, 0 AS Asignacion, 
                      Monto * - 1 AS Deduccion, tNomina.Monto AS Total, 2 AS Signo, tNomina.VacFraccionFlag, tNomina.Cia
FROM         ((tNomina LEFT JOIN
                      tEmpleados ON tNomina.Empleado = tEmpleados.Empleado) LEFT JOIN
                      tDepartamentos ON tEmpleados.Departamento = tDepartamentos.Departamento) LEFT JOIN
                      Bancos ON tEmpleados.Banco = Bancos.Banco
WHERE     Tipo = 'D' AND tNomina.MostrarEnElReciboFlag = 1

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

--  ------------------------
--  qFormaPrestamos
--  ------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaPrestamos]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaPrestamos]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qFormaPrestamos    Script Date: 15-May-01 12:13:56 PM *****
***** Object:  View dbo.qFormaPrestamos    Script Date: 28/11/00 07:01:17 p.m. *****

*/
CREATE VIEW dbo.qFormaPrestamos
AS
SELECT     Numero, Tipo, Empleado, Rubro, FechaPrimeraCuota, Periodicidad, NumeroDeCuotas, Situacion, FechaSolicitado, FechaOtorgado, FechaCancelado, 
                      FechaAnulado, MontoSolicitado, PorcIntereses, TotalAPagar, Saldo, MontoCancelado, ImprimirRecibo, FechaNominaActual, MontoCuotasOrdinarias, 
                      MontoCuotasEspeciales, NumeroCuotasEspeciales, RubroIntereses, MontoCuota, Cia
FROM         dbo.tPrestamos

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.133', GetDate()) 

