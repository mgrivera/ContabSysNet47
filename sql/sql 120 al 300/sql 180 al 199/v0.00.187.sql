/*    Lunes 19 de Diciembre de 2.005   -   v0.00.187.sql 

	Agregamos las tablas que corresponden al manejo de las 
	Agrupaciones Contables 

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
CREATE TABLE dbo.AgrupacionesContablesCodigos
	(
	CodigoAgrupacion nvarchar(20) NOT NULL,
	Descripcion nvarchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.AgrupacionesContablesCodigos ADD CONSTRAINT
	PK_AgrupacionesContablesCodigos PRIMARY KEY CLUSTERED 
	(
	CodigoAgrupacion
	) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.AgrupacionesContablesGrupos
	(
	NumeroGrupo nvarchar(20) NOT NULL,
	Descripcion nvarchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.AgrupacionesContablesGrupos ADD CONSTRAINT
	PK_AgrupacionesContablesGrupos PRIMARY KEY CLUSTERED 
	(
	NumeroGrupo
	) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.AgrupacionesContables
	(
	NumeroAgrupacion nvarchar(20) NOT NULL,
	Descripcion nvarchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.AgrupacionesContables ADD CONSTRAINT
	PK_AgrupacionesContables PRIMARY KEY CLUSTERED 
	(
	NumeroAgrupacion
	) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.AgrupacionesContables_Grupos
	(
	NumeroAgrupacion nvarchar(20) NOT NULL,
	NumeroGrupo nvarchar(20) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.AgrupacionesContables_Grupos ADD CONSTRAINT
	PK_AgrupacionesContables_Grupos PRIMARY KEY CLUSTERED 
	(
	NumeroAgrupacion,
	NumeroGrupo
	) ON [PRIMARY]

GO
ALTER TABLE dbo.AgrupacionesContables_Grupos ADD CONSTRAINT
	FK_AgrupacionesContables_Grupos_AgrupacionesContables FOREIGN KEY
	(
	NumeroAgrupacion
	) REFERENCES dbo.AgrupacionesContables
	(
	NumeroAgrupacion
	) ON UPDATE CASCADE
	 ON DELETE CASCADE
	
GO
ALTER TABLE dbo.AgrupacionesContables_Grupos ADD CONSTRAINT
	FK_AgrupacionesContables_Grupos_AgrupacionesContablesGrupos FOREIGN KEY
	(
	NumeroGrupo
	) REFERENCES dbo.AgrupacionesContablesGrupos
	(
	NumeroGrupo
	) ON UPDATE CASCADE
	 ON DELETE CASCADE
	
GO
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.AgrupacionesContables_Grupos_Codigos
	(
	NumeroAgrupacion nvarchar(20) NOT NULL,
	NumeroGrupo nvarchar(20) NOT NULL,
	CodigoAgrupacion nvarchar(20) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.AgrupacionesContables_Grupos_Codigos ADD CONSTRAINT
	PK_AgrupacionesContables_Grupos_Codigos PRIMARY KEY CLUSTERED 
	(
	NumeroAgrupacion,
	NumeroGrupo,
	CodigoAgrupacion
	) ON [PRIMARY]

GO
ALTER TABLE dbo.AgrupacionesContables_Grupos_Codigos ADD CONSTRAINT
	FK_AgrupacionesContables_Grupos_Codigos_AgrupacionesContables_Grupos FOREIGN KEY
	(
	NumeroAgrupacion,
	NumeroGrupo
	) REFERENCES dbo.AgrupacionesContables_Grupos
	(
	NumeroAgrupacion,
	NumeroGrupo
	) ON UPDATE CASCADE
	 ON DELETE CASCADE
	
GO
ALTER TABLE dbo.AgrupacionesContables_Grupos_Codigos ADD CONSTRAINT
	FK_AgrupacionesContables_Grupos_Codigos_AgrupacionesContablesCodigos FOREIGN KEY
	(
	CodigoAgrupacion
	) REFERENCES dbo.AgrupacionesContablesCodigos
	(
	CodigoAgrupacion
	) ON UPDATE CASCADE
	 ON DELETE CASCADE
	
GO
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.AgrupacionesContables_Grupos_Codigos_Cuentas
	(
	NumeroAgrupacion nvarchar(20) NOT NULL,
	NumeroGrupo nvarchar(20) NOT NULL,
	CodigoAgrupacion nvarchar(20) NOT NULL,
	CuentaContable nvarchar(25) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.AgrupacionesContables_Grupos_Codigos_Cuentas ADD CONSTRAINT
	PK_AgrupacionesContables_Grupos_Codigos_Cuentas PRIMARY KEY CLUSTERED 
	(
	NumeroAgrupacion,
	NumeroGrupo,
	CodigoAgrupacion,
	CuentaContable
	) ON [PRIMARY]

GO
ALTER TABLE dbo.AgrupacionesContables_Grupos_Codigos_Cuentas ADD CONSTRAINT
	FK_AgrupacionesContables_Grupos_Codigos_Cuentas_AgrupacionesContables_Grupos_Codigos FOREIGN KEY
	(
	NumeroAgrupacion,
	NumeroGrupo,
	CodigoAgrupacion
	) REFERENCES dbo.AgrupacionesContables_Grupos_Codigos
	(
	NumeroAgrupacion,
	NumeroGrupo,
	CodigoAgrupacion
	) ON UPDATE CASCADE
	 ON DELETE CASCADE
	
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.187', GetDate()) 