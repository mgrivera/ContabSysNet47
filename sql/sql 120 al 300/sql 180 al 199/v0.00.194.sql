/*    Jueves, 29 de Junio de 2.006   -   v0.00.194.sql 

	Con las tablas y otras modificaciones que agregamos en este cambio, 
	permitimos al usuario, al crear Agrupaciones Contables, indicar compañías y
	monedas, para que los códigos de agrupación se generen solo para éstas; además, 
	agregamos la posibilidad, también para los códigos de agrupación, de ser 
	obtenidos solo para asientos contables efectuados en 'moneda original'; ésto 
	impide que se generen cifras para el listado en 'monedas convertidas' (claro que 
	ésto solo tiene sentido para contabilidades 'multimoneda').  

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
ALTER TABLE dbo.AgrupacionesContables_Grupos_Codigos ADD
	SoloMonedaOriginalFlag bit NULL
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.AgrupacionesContables_Grupos_Codigos_Monedas
	(
	NumeroAgrupacion nvarchar(20) NOT NULL,
	NumeroGrupo nvarchar(20) NOT NULL,
	CodigoAgrupacion nvarchar(20) NOT NULL,
	Moneda int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.AgrupacionesContables_Grupos_Codigos_Monedas ADD CONSTRAINT
	PK_AgrupacionesContables_Grupos_Codigos_Monedas PRIMARY KEY CLUSTERED 
	(
	NumeroAgrupacion,
	NumeroGrupo,
	CodigoAgrupacion,
	Moneda
	) ON [PRIMARY]

GO
ALTER TABLE dbo.AgrupacionesContables_Grupos_Codigos_Monedas ADD CONSTRAINT
	FK_AgrupacionesContables_Grupos_Codigos_Monedas_AgrupacionesContables_Grupos_Codigos FOREIGN KEY
	(
	NumeroAgrupacion,
	NumeroGrupo,
	CodigoAgrupacion
	) REFERENCES dbo.AgrupacionesContables_Grupos_Codigos
	(
	NumeroAgrupacion,
	NumeroGrupo,
	CodigoAgrupacion
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.AgrupacionesContables_Grupos_Codigos_Companias
	(
	NumeroAgrupacion nvarchar(20) NOT NULL,
	NumeroGrupo nvarchar(20) NOT NULL,
	CodigoAgrupacion nvarchar(20) NOT NULL,
	Compania int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.AgrupacionesContables_Grupos_Codigos_Companias ADD CONSTRAINT
	PK_AgrupacionesContables_Grupos_Codigos_Companias PRIMARY KEY CLUSTERED 
	(
	NumeroAgrupacion,
	NumeroGrupo,
	CodigoAgrupacion,
	Compania
	)  ON [PRIMARY]

GO
ALTER TABLE dbo.AgrupacionesContables_Grupos_Codigos_Companias ADD CONSTRAINT
	FK_AgrupacionesContables_Grupos_Codigos_Companias_AgrupacionesContables_Grupos_Codigos FOREIGN KEY
	(
	NumeroAgrupacion,
	NumeroGrupo,
	CodigoAgrupacion
	) REFERENCES dbo.AgrupacionesContables_Grupos_Codigos
	(
	NumeroAgrupacion,
	NumeroGrupo,
	CodigoAgrupacion
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT


Update AgrupacionesContables_Grupos_Codigos Set SoloMonedaOriginalFlag = 0 


ALTER TABLE dbo.AgrupacionesContables_Grupos_Codigos Alter Column 
	SoloMonedaOriginalFlag bit Not NULL


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.194', GetDate()) 