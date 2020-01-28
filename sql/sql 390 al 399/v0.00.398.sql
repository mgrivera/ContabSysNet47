/*    
	  Lunes, 19/Jun/2.017   -   v0.00.398.sql 
	  Personas: aumentamos la columna usuario a 125 chars ... 
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
ALTER TABLE dbo.Personas
	DROP CONSTRAINT FK_Personas_tDepartamentos
GO
ALTER TABLE dbo.tDepartamentos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Personas
	DROP CONSTRAINT FK_Personas_Atributos
GO
ALTER TABLE dbo.Atributos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Personas
	DROP CONSTRAINT FK_Personas_Titulos
GO
ALTER TABLE dbo.Titulos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Personas
	DROP CONSTRAINT FK_Personas_tCargos
GO
ALTER TABLE dbo.tCargos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Personas
	DROP CONSTRAINT FK_Personas_Proveedores
GO
ALTER TABLE dbo.Proveedores SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Personas
	(
	Persona int NOT NULL IDENTITY (1, 1),
	Compania int NOT NULL,
	Nombre nvarchar(50) NOT NULL,
	Apellido nvarchar(50) NOT NULL,
	Cargo int NOT NULL,
	Titulo nvarchar(10) NOT NULL,
	Rif nvarchar(20) NULL,
	DiaCumpleAnos tinyint NULL,
	MesCumpleAnos smallint NULL,
	Telefono nvarchar(25) NULL,
	Departamento int NULL,
	Fax nvarchar(25) NULL,
	Celular nvarchar(25) NULL,
	email nvarchar(50) NULL,
	Atributo int NULL,
	Notas nvarchar(250) NULL,
	DefaultFlag bit NULL,
	Ingreso smalldatetime NOT NULL,
	UltAct smalldatetime NOT NULL,
	Usuario nvarchar(125) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Personas SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Personas ON
GO
IF EXISTS(SELECT * FROM dbo.Personas)
	 EXEC('INSERT INTO dbo.Tmp_Personas (Persona, Compania, Nombre, Apellido, Cargo, Titulo, Rif, DiaCumpleAnos, MesCumpleAnos, Telefono, Departamento, Fax, Celular, email, Atributo, Notas, DefaultFlag, Ingreso, UltAct, Usuario)
		SELECT Persona, Compania, Nombre, Apellido, Cargo, Titulo, Rif, DiaCumpleAnos, MesCumpleAnos, Telefono, Departamento, Fax, Celular, email, Atributo, Notas, DefaultFlag, Ingreso, UltAct, Usuario FROM dbo.Personas WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Personas OFF
GO
DROP TABLE dbo.Personas
GO
EXECUTE sp_rename N'dbo.Tmp_Personas', N'Personas', 'OBJECT' 
GO
ALTER TABLE dbo.Personas ADD CONSTRAINT
	PK_Personas PRIMARY KEY CLUSTERED 
	(
	Persona
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_Personas ON dbo.Personas
	(
	Compania
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.Personas WITH NOCHECK ADD CONSTRAINT
	FK_Personas_Proveedores FOREIGN KEY
	(
	Compania
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Personas WITH NOCHECK ADD CONSTRAINT
	FK_Personas_tCargos FOREIGN KEY
	(
	Cargo
	) REFERENCES dbo.tCargos
	(
	Cargo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Personas WITH NOCHECK ADD CONSTRAINT
	FK_Personas_Titulos FOREIGN KEY
	(
	Titulo
	) REFERENCES dbo.Titulos
	(
	Titulo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Personas WITH NOCHECK ADD CONSTRAINT
	FK_Personas_Atributos FOREIGN KEY
	(
	Atributo
	) REFERENCES dbo.Atributos
	(
	Atributo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Personas ADD CONSTRAINT
	FK_Personas_tDepartamentos FOREIGN KEY
	(
	Departamento
	) REFERENCES dbo.tDepartamentos
	(
	Departamento
	) ON UPDATE  CASCADE 
	 ON DELETE  NO ACTION 
	
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.398', GetDate()) 
