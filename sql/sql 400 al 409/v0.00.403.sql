/*    
	  Miércoles, 14/Mar/2.018   -   v0.00.403.sql 
	  
	  Aumentamos la longitud de la columna Usuario en la tabla Pagos. 
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
ALTER TABLE dbo.Pagos
	DROP CONSTRAINT FK_Pagos_Monedas
GO
ALTER TABLE dbo.Monedas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Pagos
	DROP CONSTRAINT FK_Pagos_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Pagos
	DROP CONSTRAINT FK_Pagos_Proveedores
GO
ALTER TABLE dbo.Proveedores SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Pagos
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	Proveedor int NOT NULL,
	Moneda int NOT NULL,
	NumeroPago nvarchar(25) NULL,
	AnticipoFlag bit NOT NULL,
	Fecha date NOT NULL,
	Monto money NULL,
	Concepto nvarchar(250) NOT NULL,
	MiSuFlag smallint NOT NULL,
	Ingreso datetime2(7) NOT NULL,
	UltAct datetime2(7) NOT NULL,
	Usuario nvarchar(125) NOT NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Pagos SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Pagos ON
GO
IF EXISTS(SELECT * FROM dbo.Pagos)
	 EXEC('INSERT INTO dbo.Tmp_Pagos (ClaveUnica, Proveedor, Moneda, NumeroPago, AnticipoFlag, Fecha, Monto, Concepto, MiSuFlag, Ingreso, UltAct, Usuario, Cia)
		SELECT ClaveUnica, Proveedor, Moneda, NumeroPago, AnticipoFlag, Fecha, Monto, Concepto, MiSuFlag, Ingreso, UltAct, Usuario, Cia FROM dbo.Pagos WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Pagos OFF
GO
ALTER TABLE dbo.dPagos
	DROP CONSTRAINT FK_dPagos_Pagos
GO
DROP TABLE dbo.Pagos
GO
EXECUTE sp_rename N'dbo.Tmp_Pagos', N'Pagos', 'OBJECT' 
GO
ALTER TABLE dbo.Pagos ADD CONSTRAINT
	PK_Pagos PRIMARY KEY NONCLUSTERED 
	(
	ClaveUnica
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_Pagos ON dbo.Pagos
	(
	Moneda,
	Proveedor,
	Fecha,
	MiSuFlag,
	Cia
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.Pagos WITH NOCHECK ADD CONSTRAINT
	FK_Pagos_Proveedores FOREIGN KEY
	(
	Proveedor
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Pagos WITH NOCHECK ADD CONSTRAINT
	FK_Pagos_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Pagos ADD CONSTRAINT
	FK_Pagos_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.dPagos ADD CONSTRAINT
	FK_dPagos_Pagos FOREIGN KEY
	(
	ClaveUnicaPago
	) REFERENCES dbo.Pagos
	(
	ClaveUnica
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.dPagos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.403', GetDate()) 
