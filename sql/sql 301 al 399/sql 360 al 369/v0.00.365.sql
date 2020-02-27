/*    Lunes, 30 de Diciembre de 2.013 	-   v0.00.365.sql 

	Hacemos algunos cambios leves a la tabla Contab_ConsultaCuentasYMovimientos 
	para mejorar la consulta de cuentas contables y sus movimientos (mayor general) 

	Lo anterior también para Contab_BalanceComprobacion 
	Idem para tTempWebReport_ConsultaComprobantesContables (eliminamos el child table 
	tTempWebReport_ConsultaComprobantesContables_Partidas, pues, aparentemente, dejó de 
	ser usada en algún momento) 
*/


delete from Contab_ConsultaCuentasYMovimientos 


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
ALTER TABLE dbo.Monedas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Contab_ConsultaCuentasYMovimientos ADD CONSTRAINT
	FK_Contab_ConsultaCuentasYMovimientos_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Contab_ConsultaCuentasYMovimientos ADD CONSTRAINT
	FK_Contab_ConsultaCuentasYMovimientos_CuentasContables FOREIGN KEY
	(
	CuentaContableID
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Contab_ConsultaCuentasYMovimientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

delete from Contab_BalanceComprobacion

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
ALTER TABLE dbo.Monedas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasContables SET (LOCK_ESCALATION = TABLE)
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
SET IDENTITY_INSERT dbo.Tmp_Contab_BalanceComprobacion OFF
GO
IF EXISTS(SELECT * FROM dbo.Contab_BalanceComprobacion)
	 EXEC('INSERT INTO dbo.Tmp_Contab_BalanceComprobacion (Moneda, CuentaContable_NivelPrevio, CuentaContable_NivelPrevio_Descripcion, CuentaContableID, SaldoAnterior, Debe, Haber, SaldoActual, CantidadMovimientos, NombreUsuario)
		SELECT Moneda, CuentaContable_NivelPrevio, CuentaContable_NivelPrevio_Descripcion, CuentaContableID, SaldoAnterior, Debe, Haber, SaldoActual, CantidadMovimientos, NombreUsuario FROM dbo.Contab_BalanceComprobacion WITH (HOLDLOCK TABLOCKX)')
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
delete from tTempWebReport_ConsultaComprobantesContables
DROP TABLE dbo.tTempWebReport_ConsultaComprobantesContables_Partidas
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Asientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tTempWebReport_ConsultaComprobantesContables
	(
	ID int NOT NULL IDENTITY (1, 1),
	NumeroAutomatico int NOT NULL,
	NumPartidas smallint NOT NULL,
	TotalDebe money NOT NULL,
	TotalHaber money NOT NULL,
	NombreUsuario nvarchar(256) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tTempWebReport_ConsultaComprobantesContables SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tTempWebReport_ConsultaComprobantesContables OFF
GO
IF EXISTS(SELECT * FROM dbo.tTempWebReport_ConsultaComprobantesContables)
	 EXEC('INSERT INTO dbo.Tmp_tTempWebReport_ConsultaComprobantesContables (NumeroAutomatico, NumPartidas, TotalDebe, TotalHaber, NombreUsuario)
		SELECT NumeroAutomatico, NumPartidas, TotalDebe, TotalHaber, NombreUsuario FROM dbo.tTempWebReport_ConsultaComprobantesContables WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.tTempWebReport_ConsultaComprobantesContables
GO
EXECUTE sp_rename N'dbo.Tmp_tTempWebReport_ConsultaComprobantesContables', N'tTempWebReport_ConsultaComprobantesContables', 'OBJECT' 
GO
ALTER TABLE dbo.tTempWebReport_ConsultaComprobantesContables ADD CONSTRAINT
	PK_tTempWebReport_ConsultaComprobantesContables PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tTempWebReport_ConsultaComprobantesContables ADD CONSTRAINT
	FK_tTempWebReport_ConsultaComprobantesContables_Asientos FOREIGN KEY
	(
	NumeroAutomatico
	) REFERENCES dbo.Asientos
	(
	NumeroAutomatico
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.365', GetDate()) 
