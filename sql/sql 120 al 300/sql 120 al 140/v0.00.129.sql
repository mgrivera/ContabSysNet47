/*    Miercoles, 15 de Agosto de 2002   -   v0.00.129.sql 

	Agregamos el item FechaPrimeraCuota a la tabla tPrestamos. Además, agregamos el 
	item FechaCuota a la tabla tCuotasPrestamos. 

*/ 


--  ----------------------------------------------------------------
--  Cambiamos el nombre de algunas columnas pues comienzan con 1
--  ----------------------------------------------------------------


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
EXECUTE sp_rename N'dbo.tPrestamos.[1raCuotaNomina]', N'Tmp_PrimeraCuotaNomina_3', 'COLUMN'
GO
EXECUTE sp_rename N'dbo.tPrestamos.[1raCuotaMes]', N'Tmp_PrimeraCuotaMes_4', 'COLUMN'
GO
EXECUTE sp_rename N'dbo.tPrestamos.[1raCuotaAno]', N'Tmp_PrimeraCuotaAno_5', 'COLUMN'
GO
EXECUTE sp_rename N'dbo.tPrestamos.Tmp_PrimeraCuotaNomina_3', N'PrimeraCuotaNomina', 'COLUMN'
GO
EXECUTE sp_rename N'dbo.tPrestamos.Tmp_PrimeraCuotaMes_4', N'PrimeraCuotaMes', 'COLUMN'
GO
EXECUTE sp_rename N'dbo.tPrestamos.Tmp_PrimeraCuotaAno_5', N'PrimeraCuotaAno', 'COLUMN'
GO
COMMIT













--  ------------------------
--  Table tPrestamos
--  ------------------------


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
	PrimeraCuotaNomina nvarchar(10) NOT NULL,
	PrimeraCuotaMes smallint NULL,
	PrimeraCuotaAno smallint NOT NULL,
	FechaPrimeraCuota smalldatetime NULL,
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
	NominaActual nvarchar(4) NULL,
	MesActual smallint NULL,
	AnoActual smallint NULL,
	MontoCuotasOrdinarias money NULL,
	MontoCuotasEspeciales money NULL,
	NumeroCuotasEspeciales smallint NULL,
	RubroIntereses int NULL,
	MontoCuota money NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.tPrestamos)
	 EXEC('INSERT INTO dbo.Tmp_tPrestamos (Numero, Tipo, Empleado, Rubro, Periodicidad, NumeroDeCuotas, PrimeraCuotaNomina, PrimeraCuotaMes, PrimeraCuotaAno, Situacion, FechaSolicitado, FechaOtorgado, FechaCancelado, FechaAnulado, MontoSolicitado, PorcIntereses, TotalAPagar, MontoCancelado, Saldo, ImprimirRecibo, NominaActual, MesActual, AnoActual, MontoCuotasOrdinarias, MontoCuotasEspeciales, NumeroCuotasEspeciales, RubroIntereses, MontoCuota, Cia)
		SELECT Numero, Tipo, Empleado, Rubro, Periodicidad, NumeroDeCuotas, PrimeraCuotaNomina, PrimeraCuotaMes, PrimeraCuotaAno, Situacion, FechaSolicitado, FechaOtorgado, FechaCancelado, FechaAnulado, MontoSolicitado, PorcIntereses, TotalAPagar, MontoCancelado, Saldo, ImprimirRecibo, NominaActual, MesActual, AnoActual, MontoCuotasOrdinarias, MontoCuotasEspeciales, NumeroCuotasEspeciales, RubroIntereses, MontoCuota, Cia FROM dbo.tPrestamos TABLOCKX')
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


--  ------------------------
--  Table tCuotasPrestamos
--  ------------------------


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
CREATE TABLE dbo.Tmp_tCuotasPrestamos
	(
	ClavePrincipal int NOT NULL IDENTITY (1, 1),
	Prestamo int NOT NULL,
	FechaCuota smalldatetime NULL,
	Nomina nvarchar(4) NOT NULL,
	Mes smallint NULL,
	Ano smallint NOT NULL,
	Monto money NOT NULL,
	Cancelada bit NULL,
	EspecialFlag bit NULL,
	MontoIntereses money NULL,
	TotalCuota money NOT NULL,
	PagarPorNominaFlag bit NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
SET IDENTITY_INSERT dbo.Tmp_tCuotasPrestamos ON
GO
IF EXISTS(SELECT * FROM dbo.tCuotasPrestamos)
	 EXEC('INSERT INTO dbo.Tmp_tCuotasPrestamos (ClavePrincipal, Prestamo, Nomina, Mes, Ano, Monto, Cancelada, EspecialFlag, MontoIntereses, TotalCuota, PagarPorNominaFlag, Cia)
		SELECT ClavePrincipal, Prestamo, Nomina, Mes, Ano, Monto, Cancelada, EspecialFlag, MontoIntereses, TotalCuota, PagarPorNominaFlag, Cia FROM dbo.tCuotasPrestamos TABLOCKX')
GO
SET IDENTITY_INSERT dbo.Tmp_tCuotasPrestamos OFF
GO
DROP TABLE dbo.tCuotasPrestamos
GO
EXECUTE sp_rename N'dbo.Tmp_tCuotasPrestamos', N'tCuotasPrestamos', 'OBJECT'
GO
ALTER TABLE dbo.tCuotasPrestamos ADD CONSTRAINT
	PK_tCuotasPrestamos PRIMARY KEY NONCLUSTERED 
	(
	ClavePrincipal
	) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_tCuotasPrestamos ON dbo.tCuotasPrestamos
	(
	Prestamo
	) ON [PRIMARY]
GO
COMMIT









/*
	-----------------------------------------------------------------------------
   	con estas instrucciones Sql actualizamos el item FechaPrimeraCuota en la tabla 
	tPrestamos 
	-----------------------------------------------------------------------------
*/

/*
   	primero actualizamos las nominas de 1Q y 1E 
*/

update tPrestamos Set FechaPrimeraCuota = 
Convert(nVarChar(2), PrimeraCuotaMes)  + '-15-' + Convert(Char(4), PrimeraCuotaAno) 
Where PrimeraCuotaNomina = '1Q' Or PrimeraCuotaNomina = '1E' 

/*
   	ahora actualizamos las nominas de 2Q y 2E 
	Notese como hacemos un Update para cada mes del año 
*/

/*
   	meses con 31 días 
*/

update tPrestamos Set FechaPrimeraCuota = 
Convert(nVarChar(2), PrimeraCuotaMes)  + '-31-' + Convert(Char(4), PrimeraCuotaAno) 
Where (PrimeraCuotaNomina = '2Q' Or PrimeraCuotaNomina = '2E') And PrimeraCuotaMes In (1, 3, 5, 7, 8, 10, 12) 

/*
   	meses con 30 días 
*/

update tPrestamos Set FechaPrimeraCuota = 
Convert(nVarChar(2), PrimeraCuotaMes)  + '-30-' + Convert(Char(4), PrimeraCuotaAno) 
Where (PrimeraCuotaNomina = '2Q' Or PrimeraCuotaNomina = '2E') And PrimeraCuotaMes In (4, 6, 9, 11) 

/*
   	febrero
*/

update tPrestamos Set FechaPrimeraCuota = 
Convert(nVarChar(2), PrimeraCuotaMes)  + '-28-' + Convert(Char(4), PrimeraCuotaAno) 
Where (PrimeraCuotaNomina = '2Q' Or PrimeraCuotaNomina = '2E') And PrimeraCuotaMes In (2) 

/*
   	ahora actualizamos las nominas semanales. Notese como, en este caso, la fecha 
	de la nomina es la fecha 'hasta' en la semana que corresponde en la tabla 
	Semanas. 
*/

update tPrestamos Set FechaPrimeraCuota = b.Hasta From 
tPrestamos a Inner Join Semanas b On Replace(a.PrimeraCuotaNomina, 'S', '') = b.Semana And 
a.PrimeraCuotaAno = b.Ano 
Where right(PrimeraCuotaNomina, 1) = 'S' 

/*
	-----------------------------------------------------------------------------
	-----------------------------------------------------------------------------
*/












/*
	-----------------------------------------------------------------------------
   	con estas instrucciones Sql actualizamos el item FechaCuota la tabla 
	tCuotasPrestamos 
	-----------------------------------------------------------------------------
*/

/*
   	primero actualizamos las nominas de 1Q y 1E 
*/

update tCuotasPrestamos Set FechaCuota = 
Convert(nVarChar(2), Mes)  + '-15-' + Convert(Char(4), Ano) 
Where Nomina = '1Q' Or Nomina = '1E' 

/*
   	ahora actualizamos las nominas de 2Q y 2E 
	Notese como hacemos un Update para cada mes del año 
*/

/*
   	meses con 31 días 
*/

update tCuotasPrestamos Set FechaCuota = 
Convert(nVarChar(2), Mes)  + '-31-' + Convert(Char(4), Ano) 
Where (Nomina = '2Q' Or Nomina = '2E') And Mes In (1, 3, 5, 7, 8, 10, 12) 

/*
   	meses con 30 días 
*/

update tCuotasPrestamos Set FechaCuota = 
Convert(nVarChar(2), Mes)  + '-30-' + Convert(Char(4), Ano) 
Where (Nomina = '2Q' Or Nomina = '2E') And Mes In (4, 6, 9, 11) 

/*
   	febrero
*/

update tCuotasPrestamos Set FechaCuota = 
Convert(nVarChar(2), Mes)  + '-28-' + Convert(Char(4), Ano) 
Where (Nomina = '2Q' Or Nomina = '2E') And Mes In (2) 

/*
   	ahora actualizamos las nominas semanales. Notese como, en este caso, la fecha 
	de la nomina es la fecha 'hasta' en la semana que corresponde en la tabla 
	Semanas. 
*/

update tCuotasPrestamos Set FechaCuota = b.Hasta From 
tCuotasPrestamos a Inner Join Semanas b On Replace(a.Nomina, 'S', '') = b.Semana And 
a.Ano = b.Ano 
Where right(Nomina, 1) = 'S' 

/*
	-----------------------------------------------------------------------------
	-----------------------------------------------------------------------------
*/



/*
	-----------------------------------------------------------------------------
   	ahora que los nuevos items tienen un valor, los convertimos a not null 
	-----------------------------------------------------------------------------
*/

update tPrestamos Set FechaPrimeraCuota = '1/1/1990' where FechaPrimeraCuota Is null 

alter table tCuotasPrestamos Alter Column FechaCuota smalldatetime not null 
alter table tPrestamos Alter Column FechaPrimeraCuota smalldatetime not null 


/*
	-----------------------------------------------------------------------------
   	eliminamos los items originales en ambas tablas 
	-----------------------------------------------------------------------------
*/



alter table tPrestamos drop column PrimeraCuotaNomina, PrimeraCuotaMes, PrimeraCuotaAno
alter table tCuotasPrestamos drop column Nomina, Mes, Ano




--  ---------------------------------------------------------------
--  actualizamos los views que corresponden a la tabla tPrestamos 
--  ---------------------------------------------------------------



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaPrestamosConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaPrestamosConsulta]
GO

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
                      FechaAnulado, MontoSolicitado, PorcIntereses, TotalAPagar, Saldo, MontoCancelado, ImprimirRecibo, NominaActual, MesActual, AnoActual, 
                      MontoCuotasOrdinarias, MontoCuotasEspeciales, NumeroCuotasEspeciales, RubroIntereses, MontoCuota, Cia
FROM         dbo.tPrestamos

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qFormaPrestamosConsulta    Script Date: 15-May-01 12:13:56 PM *****
***** Object:  View dbo.qFormaPrestamosConsulta    Script Date: 28/11/00 07:01:17 p.m. *****
*/
CREATE VIEW dbo.qFormaPrestamosConsulta
AS
SELECT     dbo.tPrestamos.Numero, dbo.tPrestamos.Tipo, dbo.tTiposDePrestamo.Descripcion AS NombreTipo, dbo.tPrestamos.Empleado, 
                      dbo.tEmpleados.Nombre AS NombreEmpleado, dbo.tPrestamos.Rubro, dbo.tMaestraRubros.NombreCortoRubro AS NombreRubro, 
                      dbo.tPrestamos.RubroIntereses, tMaestraRubros_1.NombreCortoRubro AS NombreRubroIntereses, dbo.tPrestamos.FechaPrimeraCuota, 
                      dbo.tPrestamos.Periodicidad, dbo.tPrestamos.NumeroDeCuotas, dbo.tPrestamos.MontoCuota, dbo.tPrestamos.Situacion, 
                      dbo.tPrestamos.FechaSolicitado, dbo.tPrestamos.FechaOtorgado, dbo.tPrestamos.FechaCancelado, dbo.tPrestamos.FechaAnulado, 
                      dbo.tPrestamos.MontoSolicitado, dbo.tPrestamos.MontoCuotasOrdinarias, dbo.tPrestamos.MontoCuotasEspeciales, 
                      dbo.tPrestamos.NumeroCuotasEspeciales, dbo.tPrestamos.PorcIntereses, dbo.tPrestamos.TotalAPagar, dbo.tPrestamos.MontoCancelado, 
                      dbo.tPrestamos.Saldo, dbo.tPrestamos.Cia
FROM         dbo.tPrestamos LEFT OUTER JOIN
                      dbo.tTiposDePrestamo ON dbo.tPrestamos.Tipo = dbo.tTiposDePrestamo.Tipo LEFT OUTER JOIN
                      dbo.tEmpleados ON dbo.tPrestamos.Empleado = dbo.tEmpleados.Empleado LEFT OUTER JOIN
                      dbo.tMaestraRubros ON dbo.tPrestamos.Rubro = dbo.tMaestraRubros.Rubro LEFT OUTER JOIN
                      dbo.tMaestraRubros tMaestraRubros_1 ON dbo.tPrestamos.RubroIntereses = tMaestraRubros_1.Rubro

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.129', GetDate()) 
