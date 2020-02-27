/*    Miercoles, 15 de Agosto de 2002   -   v0.00.130.sql 

	Cambiamos la tabla Semanas para que se llame Fechas. Además, modificamos su 
	estructura para que solo tenga los items: Fecha, Ano, Tipo. 

*/ 


sp_rename Semanas, FechasNomina 
Drop View qFormaSemanas 



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
CREATE TABLE dbo.Tmp_FechasNomina
	(
	FechaNomina smalldatetime NOT NULL,
	Tipo char(1) NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.FechasNomina)
	 EXEC('INSERT INTO dbo.Tmp_FechasNomina (FechaNomina)
		SELECT CONVERT(smalldatetime, Hasta) FROM dbo.FechasNomina TABLOCKX')
GO
DROP TABLE dbo.FechasNomina
GO
EXECUTE sp_rename N'dbo.Tmp_FechasNomina', N'FechasNomina', 'OBJECT'
GO

Update FechasNomina Set Tipo = 'S' 
GO

Alter Table FechasNomina Alter Column Tipo Char(1) Not Null 
GO
COMMIT

BEGIN TRANSACTION
ALTER TABLE dbo.FechasNomina ADD CONSTRAINT
	PK_FechasNomina PRIMARY KEY CLUSTERED 
	(
	FechaNomina, Tipo
	) ON [PRIMARY]

GO
COMMIT


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaFechasNomina]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaFechasNomina]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaFechasNomina
AS
SELECT     FechaNomina, Tipo
FROM         dbo.FechasNomina

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


--  -----------------------------------------------------------------------
--  cambiamos levemente la tabla tListadoPrestamos y sus views asociados 
--  -----------------------------------------------------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tListadoPrestamos]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tListadoPrestamos]
GO

CREATE TABLE [dbo].[tListadoPrestamos] (
	[ClaveUnica] [int] IDENTITY (1, 1) NOT NULL ,
	[Departamento] [int] NULL ,
	[NombreDepartamento] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Empleado] [int] NULL ,
	[NombreEmpleado] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NumeroPrestamo] [int] NULL ,
	[Periodicidad] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FechaPrimeraCuota] [smalldatetime] NULL ,
	[NumeroDeCuotas] [smallint] NULL ,
	[EstadoActual] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[TotalAPagar] [money] NULL ,
	[MontoCancelado] [money] NULL ,
	[Saldo] [money] NULL ,
	[PorcIntereses] [real] NULL ,
	[NumeroUsuario] [int] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tListadoPrestamos] WITH NOCHECK ADD 
	CONSTRAINT [PK_tListadoPrestamos] PRIMARY KEY  NONCLUSTERED 
	(
		[ClaveUnica]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [IX_tListadoPrestamos] ON [dbo].[tListadoPrestamos]([NumeroUsuario]) ON [PRIMARY]
GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoPrestamos]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoPrestamos]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoPrestamosDos]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoPrestamosDos]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoPrestamosSubReport]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoPrestamosSubReport]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qListadoPrestamosDos    Script Date: 15-May-01 12:13:57 PM *****
***** Object:  View dbo.qListadoPrestamosDos    Script Date: 28/11/00 07:01:19 p.m. *****
*/
CREATE VIEW dbo.qListadoPrestamosDos
AS
SELECT     ClaveUnica, Departamento, NombreDepartamento, Empleado, NombreEmpleado, NumeroPrestamo, Periodicidad, FechaPrimeraCuota, 
                      NumeroDeCuotas, EstadoActual, TotalAPagar, MontoCancelado, Saldo, PorcIntereses, NumeroUsuario
FROM         dbo.tListadoPrestamos

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoPrestamosSubReport
AS
SELECT     ClavePrincipal, Prestamo, FechaCuota, Monto, MontoIntereses, TotalCuota, Cancelada, PagarPorNominaFlag
FROM         dbo.tCuotasPrestamos

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qListadoPrestamos    Script Date: 15-May-01 12:13:57 PM *****
***** Object:  View dbo.qListadoPrestamos    Script Date: 28/11/00 07:01:19 p.m. *****
*/
CREATE VIEW dbo.qListadoPrestamos
AS
SELECT     dbo.tPrestamos.Numero, dbo.tEmpleados.Departamento, dbo.tDepartamentos.Descripcion AS NombreDepartamento, dbo.tPrestamos.Empleado, 
                      dbo.tEmpleados.Nombre AS NombreEmpleado, dbo.tPrestamos.Numero AS NumeroPrestamo, dbo.tPrestamos.Periodicidad, 
                      dbo.tPrestamos.FechaPrimeraCuota, dbo.tPrestamos.NumeroDeCuotas, dbo.tPrestamos.Situacion, dbo.tPrestamos.TotalAPagar, 
                      dbo.tPrestamos.MontoCancelado, dbo.tPrestamos.Saldo, dbo.tPrestamos.Tipo, dbo.tPrestamos.Rubro, dbo.tPrestamos.FechaSolicitado, 
                      dbo.tPrestamos.FechaOtorgado, dbo.tPrestamos.FechaCancelado, dbo.tPrestamos.FechaAnulado, dbo.tPrestamos.MontoSolicitado, 
                      dbo.tPrestamos.PorcIntereses, dbo.tPrestamos.Cia
FROM         dbo.tPrestamos LEFT OUTER JOIN
                      dbo.tEmpleados ON dbo.tPrestamos.Empleado = dbo.tEmpleados.Empleado LEFT OUTER JOIN
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
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.130', GetDate()) 
