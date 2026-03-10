/*    
	  Martes, 4 de Marzo de 2.025  -   v0.00.465.sql 
	  
	  Agregamos las tablas para el flujo de caja
	  Categorías 
	  CuentasContables_config

*/

-- **********************************************************
-- FlujoCaja_Categorias
-- **********************************************************

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
CREATE TABLE dbo.FlujoCaja_Categorias
	(
	Id int NOT NULL IDENTITY (1, 1),
	Descripción nvarchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.FlujoCaja_Categorias ADD CONSTRAINT
	PK_FlujoCaja_Categorias PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.FlujoCaja_Categorias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

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
EXECUTE sp_rename N'dbo.FlujoCaja_Categorias.Descripción', N'Tmp_Descripcion', 'COLUMN' 
GO
EXECUTE sp_rename N'dbo.FlujoCaja_Categorias.Tmp_Descripcion', N'Descripcion', 'COLUMN' 
GO
ALTER TABLE dbo.FlujoCaja_Categorias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


-- **********************************************************
-- FlujoCaja_CuentasContables_Config
-- **********************************************************
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
ALTER TABLE dbo.CuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.FlujoCaja_Categorias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.FlujoCaja_CuentasContables_Config
	(
	Id int NOT NULL IDENTITY (1, 1),
	CuentaContableId int NOT NULL,
	CategoriaId int NOT NULL,
	LeerSaldo bit NULL,
	LeerMovimientos bit NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.FlujoCaja_CuentasContables_Config ADD CONSTRAINT
	PK_FlujoCaja_CuentasContables_Config PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.FlujoCaja_CuentasContables_Config ADD CONSTRAINT
	FK_FlujoCaja_CuentasContables_Config_FlujoCaja_Categorias FOREIGN KEY
	(
	CategoriaId
	) REFERENCES dbo.FlujoCaja_Categorias
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.FlujoCaja_CuentasContables_Config ADD CONSTRAINT
	FK_FlujoCaja_CuentasContables_Config_CuentasContables FOREIGN KEY
	(
	CuentaContableId
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.FlujoCaja_CuentasContables_Config ADD CONSTRAINT
	FK_FlujoCaja_CuentasContables_Config_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.FlujoCaja_CuentasContables_Config SET (LOCK_ESCALATION = TABLE)
GO
COMMIT




Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.465', GetDate()) 