/*    Lunes, 05 de Diciembre de 2.011  -   v0.00.298a.sql 

	Hacemos cambios en la estructura de las tablas 
	del Control de Caja Chica 
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
ALTER TABLE dbo.CajaChica_RubrosCuentasContables
	DROP CONSTRAINT FK_CajaChica_RubrosCuentasContables_CuentasContables1
GO
ALTER TABLE dbo.CuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CajaChica_RubrosCuentasContables
	DROP CONSTRAINT FK_CajaChica_RubrosCuentasContables_CajaChica_Rubros
GO
ALTER TABLE dbo.CajaChica_Rubros SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CajaChica_Usuarios
	DROP CONSTRAINT FK_CajaChica_Usuarios_CajaChica_CajasChicas
GO
ALTER TABLE dbo.CajaChica_Reposiciones
	DROP CONSTRAINT FK_CajaChica_Reposiciones_CajaChica_CajasChicas
GO
ALTER TABLE dbo.CajaChica_CajasChicas
	DROP CONSTRAINT PK_CajaChica_CajasChicas
GO
ALTER TABLE dbo.CajaChica_CajasChicas ADD CONSTRAINT
	PK_CajaChica_CajasChicas_1 PRIMARY KEY CLUSTERED 
	(
	CajaChica
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.CajaChica_CajasChicas SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.CajaChica_Reposiciones
	DROP CONSTRAINT PK_CajaChica_Reposiciones
GO
ALTER TABLE dbo.CajaChica_Reposiciones ADD CONSTRAINT
	PK_CajaChica_Reposiciones_1 PRIMARY KEY CLUSTERED 
	(
	Reposicion
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.CajaChica_Reposiciones
	DROP COLUMN CiaContab
GO
ALTER TABLE dbo.CajaChica_Reposiciones SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_CajaChica_Reposiciones_Estados
	(
	ID int NOT NULL IDENTITY (1, 1),
	Reposicion int NOT NULL,
	Fecha datetime NOT NULL,
	NombreUsuario nvarchar(256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Estado char(2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_CajaChica_Reposiciones_Estados SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_CajaChica_Reposiciones_Estados OFF
GO
IF EXISTS(SELECT * FROM dbo.CajaChica_Reposiciones_Estados)
	 EXEC('INSERT INTO dbo.Tmp_CajaChica_Reposiciones_Estados (Reposicion, Fecha, NombreUsuario, Estado)
		SELECT Reposicion, Fecha, NombreUsuario, Estado FROM dbo.CajaChica_Reposiciones_Estados WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.CajaChica_Reposiciones_Estados
GO
EXECUTE sp_rename N'dbo.Tmp_CajaChica_Reposiciones_Estados', N'CajaChica_Reposiciones_Estados', 'OBJECT' 
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Estados ADD CONSTRAINT
	PK_CajaChica_Reposiciones_Estados_1 PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos
	DROP CONSTRAINT PK_CajaChica_Reposisiones_Gastos
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos ADD CONSTRAINT
	PK_CajaChica_Reposiciones_Gastos PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos
	DROP COLUMN CajaChica, CiaContab
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_CajaChica_Usuarios
	(
	ID int NOT NULL IDENTITY (1, 1),
	CajaChica smallint NOT NULL,
	Estado char(2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	NombreUsuario nvarchar(256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_CajaChica_Usuarios SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_CajaChica_Usuarios OFF
GO
IF EXISTS(SELECT * FROM dbo.CajaChica_Usuarios)
	 EXEC('INSERT INTO dbo.Tmp_CajaChica_Usuarios (CajaChica, Estado, NombreUsuario)
		SELECT CajaChica, Estado, NombreUsuario FROM dbo.CajaChica_Usuarios WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.CajaChica_Usuarios
GO
EXECUTE sp_rename N'dbo.Tmp_CajaChica_Usuarios', N'CajaChica_Usuarios', 'OBJECT' 
GO
ALTER TABLE dbo.CajaChica_Usuarios ADD CONSTRAINT
	PK_CajaChica_Usuarios_1 PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CajaChica_RubrosCuentasContables
	DROP CONSTRAINT FK_CajaChica_RubrosCuentasContables_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_CajaChica_RubrosCuentasContables
	(
	ID int NOT NULL IDENTITY (1, 1),
	Rubro smallint NOT NULL,
	CuentaContableID int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_CajaChica_RubrosCuentasContables SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_CajaChica_RubrosCuentasContables OFF
GO
IF EXISTS(SELECT * FROM dbo.CajaChica_RubrosCuentasContables)
	 EXEC('INSERT INTO dbo.Tmp_CajaChica_RubrosCuentasContables (Rubro, CuentaContableID)
		SELECT Rubro, CuentaContableID FROM dbo.CajaChica_RubrosCuentasContables WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.CajaChica_RubrosCuentasContables
GO
EXECUTE sp_rename N'dbo.Tmp_CajaChica_RubrosCuentasContables', N'CajaChica_RubrosCuentasContables', 'OBJECT' 
GO
ALTER TABLE dbo.CajaChica_RubrosCuentasContables ADD CONSTRAINT
	PK_CajaChica_RubrosCuentasContables PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.CajaChica_RubrosCuentasContables ADD CONSTRAINT
	FK_CajaChica_RubrosCuentasContables_CajaChica_Rubros FOREIGN KEY
	(
	Rubro
	) REFERENCES dbo.CajaChica_Rubros
	(
	Rubro
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.CajaChica_RubrosCuentasContables ADD CONSTRAINT
	FK_CajaChica_RubrosCuentasContables_CuentasContables1 FOREIGN KEY
	(
	CuentaContableID
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  CASCADE 
	 ON DELETE  NO ACTION 
	
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.298a', GetDate()) 