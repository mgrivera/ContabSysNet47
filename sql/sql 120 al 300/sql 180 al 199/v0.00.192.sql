/*    Martes, 13 de Junio de 2.006   -   v0.00.192.sql 

	Agregamos las tablas tTempWebReportAgrupacionesContablesSaldos y 
	tTempWebReportAgrupacionesContablesSaldosMovimientos, para grabar el contenido 
	del reporte de Agrupaciones Contables, que se obtiene vía Web. 

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
CREATE TABLE dbo.tTempWebReportAgrupacionesContablesSaldosMovimientos
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	Cia int NOT NULL,
	Moneda int NOT NULL,
	NumeroAgrupacion nvarchar(20) NOT NULL,
	GrupoAgrupacion nvarchar(20) NOT NULL,
	CodigoAgrupacion nvarchar(20) NOT NULL,
	NumeroComprobante smallint NOT NULL,
	CuentaContable nvarchar(25) NOT NULL,
	Fecha smalldatetime NOT NULL,
	Descripcion nvarchar(50) NOT NULL,
	Debe money NOT NULL,
	Haber money NOT NULL,
	NumeroUsuario int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.tTempWebReportAgrupacionesContablesSaldosMovimientos ADD CONSTRAINT
	PK_tTempWebReportAgrupacionesContablesSaldosMovimientos PRIMARY KEY CLUSTERED 
	(
	ClaveUnica
	) 

GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.tTempWebReportAgrupacionesContablesSaldos
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	Cia int NOT NULL,
	Moneda int NOT NULL,
	NumeroAgrupacion nvarchar(20) NOT NULL,
	GrupoAgrupacion nvarchar(20) NOT NULL,
	CodigoAgrupacion nvarchar(20) NOT NULL,
	SaldoAnterior money NOT NULL,
	Debe money NOT NULL,
	Haber money NOT NULL,
	SaldoActual money NOT NULL,
	NumeroUsuario int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.tTempWebReportAgrupacionesContablesSaldos ADD CONSTRAINT
	PK_tTempWebReportAgrupacionesContablesSaldos PRIMARY KEY CLUSTERED 
	(
	ClaveUnica
	)

GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.192', GetDate()) 