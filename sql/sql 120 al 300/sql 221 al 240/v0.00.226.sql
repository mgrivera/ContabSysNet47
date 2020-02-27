/*    Miércoles, 26 de Noviembre de 2.008  -   v0.00.226.sql 

	Hacemos modificaciones a las tablas del Control de Caja Chica 
	para adaptarlas a los cambios que hicimos en el proceso de 
	membership en la aplicación 

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
ALTER TABLE dbo.CajaChica_Usuarios
	DROP CONSTRAINT FK_CajaChica_Usuarios_CajaChica_CajasChicas
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos
	DROP CONSTRAINT FK_CajaChica_Reposisiones_Gastos_CajaChica_Rubros
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Estados
	DROP CONSTRAINT FK_CajaChica_Reposiciones_Estados_CajaChica_Reposiciones
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos
	DROP CONSTRAINT FK_CajaChica_Reposisiones_Gastos_CajaChica_Reposiciones
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CajaChica_Usuarios
	DROP CONSTRAINT FK_CajaChica_Usuarios_Usuarios
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_CajaChica_Usuarios
	(
	CiaContab int NOT NULL,
	CajaChica smallint NOT NULL,
	Estado char(2) NOT NULL,
	NombreUsuario nvarchar(256) NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.CajaChica_Usuarios)
	 EXEC('INSERT INTO dbo.Tmp_CajaChica_Usuarios (CiaContab, CajaChica, Estado, NombreUsuario)
		SELECT CiaContab, CajaChica, Estado, CONVERT(nvarchar(256), Usuario) FROM dbo.CajaChica_Usuarios WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.CajaChica_Usuarios
GO
EXECUTE sp_rename N'dbo.Tmp_CajaChica_Usuarios', N'CajaChica_Usuarios', 'OBJECT' 
GO
ALTER TABLE dbo.CajaChica_Usuarios ADD CONSTRAINT
	PK_CajaChica_Usuarios PRIMARY KEY CLUSTERED 
	(
	CiaContab,
	CajaChica,
	Estado,
	NombreUsuario
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.CajaChica_Usuarios ADD CONSTRAINT
	FK_CajaChica_Usuarios_CajaChica_CajasChicas FOREIGN KEY
	(
	CajaChica,
	CiaContab
	) REFERENCES dbo.CajaChica_CajasChicas
	(
	CajaChica,
	CiaContab
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_CajaChica_Reposiciones_Estados
	(
	Reposicion int NOT NULL,
	CajaChica smallint NOT NULL,
	Fecha smalldatetime NOT NULL,
	CiaContab int NOT NULL,
	NombreUsuario nvarchar(256) NOT NULL,
	Estado char(2) NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.CajaChica_Reposiciones_Estados)
	 EXEC('INSERT INTO dbo.Tmp_CajaChica_Reposiciones_Estados (Reposicion, CajaChica, Fecha, CiaContab, NombreUsuario, Estado)
		SELECT Reposicion, CajaChica, Fecha, CiaContab, CONVERT(nvarchar(256), Usuario), Estado FROM dbo.CajaChica_Reposiciones_Estados WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.CajaChica_Reposiciones_Estados
GO
EXECUTE sp_rename N'dbo.Tmp_CajaChica_Reposiciones_Estados', N'CajaChica_Reposiciones_Estados', 'OBJECT' 
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Estados ADD CONSTRAINT
	PK_CajaChica_Reposiciones_Estados PRIMARY KEY CLUSTERED 
	(
	Reposicion,
	CajaChica,
	CiaContab,
	Estado
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.CajaChica_Reposiciones_Estados ADD CONSTRAINT
	FK_CajaChica_Reposiciones_Estados_CajaChica_Reposiciones FOREIGN KEY
	(
	Reposicion,
	CajaChica,
	CiaContab
	) REFERENCES dbo.CajaChica_Reposiciones
	(
	Reposicion,
	CajaChica,
	CiaContab
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_CajaChica_Reposiciones_Gastos
	(
	ID int NOT NULL IDENTITY (1, 1),
	Reposicion int NOT NULL,
	CajaChica smallint NOT NULL,
	CiaContab int NOT NULL,
	Fecha smalldatetime NOT NULL,
	Rubro smallint NOT NULL,
	Descripcion nvarchar(150) NOT NULL,
	Monto money NOT NULL,
	NombreUsuario nvarchar(256) NOT NULL
	)  ON [PRIMARY]
GO
SET IDENTITY_INSERT dbo.Tmp_CajaChica_Reposiciones_Gastos ON
GO
IF EXISTS(SELECT * FROM dbo.CajaChica_Reposiciones_Gastos)
	 EXEC('INSERT INTO dbo.Tmp_CajaChica_Reposiciones_Gastos (ID, Reposicion, CajaChica, CiaContab, Fecha, Rubro, Descripcion, Monto, NombreUsuario)
		SELECT ID, Reposicion, CajaChica, CiaContab, Fecha, Rubro, Descripcion, Monto, CONVERT(nvarchar(256), Usuario) FROM dbo.CajaChica_Reposiciones_Gastos WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_CajaChica_Reposiciones_Gastos OFF
GO
DROP TABLE dbo.CajaChica_Reposiciones_Gastos
GO
EXECUTE sp_rename N'dbo.Tmp_CajaChica_Reposiciones_Gastos', N'CajaChica_Reposiciones_Gastos', 'OBJECT' 
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos ADD CONSTRAINT
	PK_CajaChica_Reposisiones_Gastos PRIMARY KEY CLUSTERED 
	(
	ID,
	Reposicion,
	CajaChica,
	CiaContab
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos ADD CONSTRAINT
	FK_CajaChica_Reposisiones_Gastos_CajaChica_Reposiciones FOREIGN KEY
	(
	Reposicion,
	CajaChica,
	CiaContab
	) REFERENCES dbo.CajaChica_Reposiciones
	(
	Reposicion,
	CajaChica,
	CiaContab
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos ADD CONSTRAINT
	FK_CajaChica_Reposisiones_Gastos_CajaChica_Rubros FOREIGN KEY
	(
	Rubro
	) REFERENCES dbo.CajaChica_Rubros
	(
	Rubro
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.226', GetDate()) 