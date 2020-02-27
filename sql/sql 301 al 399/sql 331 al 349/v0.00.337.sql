/*    Viernes, 19 de Abril de 2.013 	-   v0.00.337.sql 

	Agregamos las tablas y los cambios en general necesarios para 
	la ejecución del proceso de conciliación bancaria 
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
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasBancarias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.ConciliacionesBancarias
	(
	ID int NOT NULL IDENTITY (1, 1),
	Descripcion nvarchar(250) NOT NULL,
	Desde date NOT NULL,
	Hasta date NOT NULL,
	CiaContab int NOT NULL,
	CuentaBancaria int NOT NULL,
	CuentaContable int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.ConciliacionesBancarias ADD CONSTRAINT
	PK_ConciliacionesBancarias PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.ConciliacionesBancarias ADD CONSTRAINT
	FK_ConciliacionesBancarias_Companias FOREIGN KEY
	(
	CiaContab
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.ConciliacionesBancarias ADD CONSTRAINT
	FK_ConciliacionesBancarias_CuentasBancarias FOREIGN KEY
	(
	CuentaBancaria
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.ConciliacionesBancarias ADD CONSTRAINT
	FK_ConciliacionesBancarias_CuentasContables FOREIGN KEY
	(
	CuentaContable
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.ConciliacionesBancarias SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.ConciliacionesBancarias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.MovimientosDesdeBancos
	(
	ID int NOT NULL IDENTITY (1, 1),
	ConciliacionBancariaID int NOT NULL,
	Fecha date NOT NULL,
	Referencia nvarchar(50) NULL,
	Descripcion nvarchar(500) NULL,
	Monto money NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.MovimientosDesdeBancos ADD CONSTRAINT
	PK_MovimientosDesdeBancos PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.MovimientosDesdeBancos ADD CONSTRAINT
	FK_MovimientosDesdeBancos_ConciliacionesBancarias FOREIGN KEY
	(
	ConciliacionBancariaID
	) REFERENCES dbo.ConciliacionesBancarias
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.MovimientosDesdeBancos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT





--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.337', GetDate()) 