/*    
	  Lunes, 21 de Septiembre de 2.020  -   v0.00.428.sql 
	  
	  Asientos / partidas: aumentamos la descripción desde 75 a 300 
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
ALTER TABLE dbo.dAsientos
	DROP CONSTRAINT FK_dAsientos_MovimientosDesdeBancos
GO
ALTER TABLE dbo.MovimientosDesdeBancos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.dAsientos
	DROP CONSTRAINT FK_dAsientos_CentrosCosto
GO
ALTER TABLE dbo.CentrosCosto SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.dAsientos
	DROP CONSTRAINT FK_dAsientos_Asientos
GO
ALTER TABLE dbo.Asientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.dAsientos
	DROP CONSTRAINT FK_dAsientos_CuentasContables1
GO
ALTER TABLE dbo.CuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_dAsientos
	(
	NumeroAutomatico int NOT NULL,
	Partida smallint NOT NULL,
	CuentaContableID int NOT NULL,
	Descripcion nvarchar(300) NOT NULL,
	Referencia nvarchar(20) NULL,
	Debe money NOT NULL,
	Haber money NOT NULL,
	CentroCosto int NULL,
	ConciliacionMovimientoID int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_dAsientos SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.dAsientos)
	 EXEC('INSERT INTO dbo.Tmp_dAsientos (NumeroAutomatico, Partida, CuentaContableID, Descripcion, Referencia, Debe, Haber, CentroCosto, ConciliacionMovimientoID)
		SELECT NumeroAutomatico, Partida, CuentaContableID, Descripcion, Referencia, Debe, Haber, CentroCosto, ConciliacionMovimientoID FROM dbo.dAsientos WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.dAsientos
GO
EXECUTE sp_rename N'dbo.Tmp_dAsientos', N'dAsientos', 'OBJECT' 
GO
ALTER TABLE dbo.dAsientos ADD CONSTRAINT
	PK_dAsientos PRIMARY KEY CLUSTERED 
	(
	NumeroAutomatico,
	Partida
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_dAsientos ON dbo.dAsientos
	(
	NumeroAutomatico
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.dAsientos ADD CONSTRAINT
	FK_dAsientos_CuentasContables1 FOREIGN KEY
	(
	CuentaContableID
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  CASCADE 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.dAsientos WITH NOCHECK ADD CONSTRAINT
	FK_dAsientos_Asientos FOREIGN KEY
	(
	NumeroAutomatico
	) REFERENCES dbo.Asientos
	(
	NumeroAutomatico
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.dAsientos ADD CONSTRAINT
	FK_dAsientos_CentrosCosto FOREIGN KEY
	(
	CentroCosto
	) REFERENCES dbo.CentrosCosto
	(
	CentroCosto
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.dAsientos ADD CONSTRAINT
	FK_dAsientos_MovimientosDesdeBancos FOREIGN KEY
	(
	ConciliacionMovimientoID
	) REFERENCES dbo.MovimientosDesdeBancos
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT









--  ------------------------------------------------------------------------------------------------
--  hacemos el mismo cambio pero en la tabla Contab_ConsultaCuentasYMovimientos 
--  ------------------------------------------------------------------------------------------------

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
ALTER TABLE dbo.Contab_ConsultaCuentasYMovimientos_Movimientos
	DROP CONSTRAINT FK_Contab_ConsultaCuentasYMovimientos_Movimientos_Contab_ConsultaCuentasYMovimientos
GO
ALTER TABLE dbo.Contab_ConsultaCuentasYMovimientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Contab_ConsultaCuentasYMovimientos_Movimientos
	(
	ID int NOT NULL IDENTITY (1, 1),
	ParentID int NOT NULL,
	Secuencia smallint NOT NULL,
	AsientoID int NOT NULL,
	CuentaContableID int NOT NULL,
	Partida smallint NULL,
	Referencia nvarchar(20) NULL,
	Descripcion nvarchar(300) NOT NULL,
	Monto money NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Contab_ConsultaCuentasYMovimientos_Movimientos SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Contab_ConsultaCuentasYMovimientos_Movimientos ON
GO
IF EXISTS(SELECT * FROM dbo.Contab_ConsultaCuentasYMovimientos_Movimientos)
	 EXEC('INSERT INTO dbo.Tmp_Contab_ConsultaCuentasYMovimientos_Movimientos (ID, ParentID, Secuencia, AsientoID, CuentaContableID, Partida, Referencia, Descripcion, Monto)
		SELECT ID, ParentID, Secuencia, AsientoID, CuentaContableID, Partida, Referencia, Descripcion, Monto FROM dbo.Contab_ConsultaCuentasYMovimientos_Movimientos WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Contab_ConsultaCuentasYMovimientos_Movimientos OFF
GO
DROP TABLE dbo.Contab_ConsultaCuentasYMovimientos_Movimientos
GO
EXECUTE sp_rename N'dbo.Tmp_Contab_ConsultaCuentasYMovimientos_Movimientos', N'Contab_ConsultaCuentasYMovimientos_Movimientos', 'OBJECT' 
GO
ALTER TABLE dbo.Contab_ConsultaCuentasYMovimientos_Movimientos ADD CONSTRAINT
	PK_Contab_ConsultaCuentasYMovimientos_Movimientos_1 PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Contab_ConsultaCuentasYMovimientos_Movimientos ADD CONSTRAINT
	FK_Contab_ConsultaCuentasYMovimientos_Movimientos_Contab_ConsultaCuentasYMovimientos FOREIGN KEY
	(
	ParentID
	) REFERENCES dbo.Contab_ConsultaCuentasYMovimientos
	(
	ID
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.428', GetDate()) 