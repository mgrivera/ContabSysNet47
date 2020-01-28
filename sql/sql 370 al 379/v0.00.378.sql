/*    
	  Lunes 1ro de Febrero de 2.016	-   v0.00.378.sql 

	  Agregamos columnas a la tabla ('temp') Contab_BalanceComprobacion para 
	  registrar los niveles previos de cada cuenta contable.
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
ALTER TABLE dbo.Contab_BalanceComprobacion
	DROP CONSTRAINT FK_Contab_BalanceComprobacion_CuentasContables
GO
ALTER TABLE dbo.CuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Contab_BalanceComprobacion
	DROP CONSTRAINT FK_Contab_BalanceComprobacion_Monedas
GO
ALTER TABLE dbo.Monedas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Contab_BalanceComprobacion
	(
	ID int NOT NULL IDENTITY (1, 1),
	Moneda int NOT NULL,
	CuentaContable_NivelPrevio nvarchar(25) NULL,
	CuentaContable_NivelPrevio_Descripcion nvarchar(40) NULL,
	nivel1 nvarchar(100) NULL,
	nivel2 nvarchar(100) NULL,
	nivel3 nvarchar(100) NULL,
	nivel4 nvarchar(100) NULL,
	nivel5 nvarchar(100) NULL,
	nivel6 nvarchar(100) NULL,
	CuentaContableID int NOT NULL,
	SaldoAnterior money NULL,
	Debe money NULL,
	Haber money NULL,
	SaldoActual money NULL,
	CantidadMovimientos int NULL,
	NombreUsuario nvarchar(256) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Contab_BalanceComprobacion SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Contab_BalanceComprobacion ON
GO
IF EXISTS(SELECT * FROM dbo.Contab_BalanceComprobacion)
	 EXEC('INSERT INTO dbo.Tmp_Contab_BalanceComprobacion (ID, Moneda, CuentaContable_NivelPrevio, CuentaContable_NivelPrevio_Descripcion, CuentaContableID, SaldoAnterior, Debe, Haber, SaldoActual, CantidadMovimientos, NombreUsuario)
		SELECT ID, Moneda, CuentaContable_NivelPrevio, CuentaContable_NivelPrevio_Descripcion, CuentaContableID, SaldoAnterior, Debe, Haber, SaldoActual, CantidadMovimientos, NombreUsuario FROM dbo.Contab_BalanceComprobacion WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Contab_BalanceComprobacion OFF
GO
DROP TABLE dbo.Contab_BalanceComprobacion
GO
EXECUTE sp_rename N'dbo.Tmp_Contab_BalanceComprobacion', N'Contab_BalanceComprobacion', 'OBJECT' 
GO
ALTER TABLE dbo.Contab_BalanceComprobacion ADD CONSTRAINT
	PK_Contab_BalanceComprobacion PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Contab_BalanceComprobacion ADD CONSTRAINT
	FK_Contab_BalanceComprobacion_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Contab_BalanceComprobacion ADD CONSTRAINT
	FK_Contab_BalanceComprobacion_CuentasContables FOREIGN KEY
	(
	CuentaContableID
	) REFERENCES dbo.CuentasContables
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
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.378', GetDate()) 
