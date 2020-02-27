/*    Lunes, 24 de Octubre de 2.011  -   v0.00.290.sql 

	Cambiamos la columna FechaEntregado de DateTime a Date 
	en MovimientosBancarios; además, eliminamos los items 
	Mes y Ano en MovimientosBancarios 
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
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Proveedores
GO
ALTER TABLE dbo.Proveedores SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Asientos
GO
ALTER TABLE dbo.Asientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Chequeras
GO
ALTER TABLE dbo.Chequeras SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_MovimientosBancarios
	(
	Transaccion nvarchar(20) NOT NULL,
	Tipo nvarchar(2) NOT NULL,
	Fecha date NOT NULL,
	Mes smallint NOT NULL,
	Ano smallint NOT NULL,
	ProvClte int NULL,
	Beneficiario nvarchar(50) NULL,
	Concepto nvarchar(250) NULL,
	MontoBase money NULL,
	Comision money NULL,
	Impuestos money NULL,
	Monto money NOT NULL,
	Ingreso datetime NULL,
	UltMod datetime NULL,
	Usuario nvarchar(25) NOT NULL,
	Comprobante int NULL,
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	ClaveUnicaChequera int NOT NULL,
	FechaEntregado date NULL,
	Conciliacion_FechaEjecucion smalldatetime NULL,
	Conciliacion_MovimientoBanco_Fecha smalldatetime NULL,
	Conciliacion_MovimientoBanco_Numero nvarchar(50) NULL,
	Conciliacion_MovimientoBanco_Tipo nvarchar(4) NULL,
	Conciliacion_MovimientoBanco_FechaProceso smalldatetime NULL,
	Conciliacion_MovimientoBanco_Monto money NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_MovimientosBancarios SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_MovimientosBancarios ON
GO
IF EXISTS(SELECT * FROM dbo.MovimientosBancarios)
	 EXEC('INSERT INTO dbo.Tmp_MovimientosBancarios (Transaccion, Tipo, Fecha, Mes, Ano, ProvClte, Beneficiario, Concepto, MontoBase, Comision, Impuestos, Monto, Ingreso, UltMod, Usuario, Comprobante, ClaveUnica, ClaveUnicaChequera, FechaEntregado, Conciliacion_FechaEjecucion, Conciliacion_MovimientoBanco_Fecha, Conciliacion_MovimientoBanco_Numero, Conciliacion_MovimientoBanco_Tipo, Conciliacion_MovimientoBanco_FechaProceso, Conciliacion_MovimientoBanco_Monto)
		SELECT Transaccion, Tipo, Fecha, Mes, Ano, ProvClte, Beneficiario, Concepto, MontoBase, Comision, Impuestos, Monto, Ingreso, UltMod, Usuario, Comprobante, ClaveUnica, ClaveUnicaChequera, CONVERT(date, FechaEntregado), Conciliacion_FechaEjecucion, Conciliacion_MovimientoBanco_Fecha, Conciliacion_MovimientoBanco_Numero, Conciliacion_MovimientoBanco_Tipo, Conciliacion_MovimientoBanco_FechaProceso, Conciliacion_MovimientoBanco_Monto FROM dbo.MovimientosBancarios WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_MovimientosBancarios OFF
GO
DROP TABLE dbo.MovimientosBancarios
GO
EXECUTE sp_rename N'dbo.Tmp_MovimientosBancarios', N'MovimientosBancarios', 'OBJECT' 
GO
ALTER TABLE dbo.MovimientosBancarios ADD CONSTRAINT
	PK_MovimientosBancarios PRIMARY KEY CLUSTERED 
	(
	ClaveUnica
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.MovimientosBancarios ADD CONSTRAINT
	FK_MovimientosBancarios_Chequeras FOREIGN KEY
	(
	ClaveUnicaChequera
	) REFERENCES dbo.Chequeras
	(
	NumeroChequera
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.MovimientosBancarios ADD CONSTRAINT
	FK_MovimientosBancarios_Asientos FOREIGN KEY
	(
	Comprobante
	) REFERENCES dbo.Asientos
	(
	NumeroAutomatico
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.MovimientosBancarios WITH NOCHECK ADD CONSTRAINT
	FK_MovimientosBancarios_Proveedores FOREIGN KEY
	(
	ProvClte
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
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
ALTER TABLE dbo.MovimientosBancarios
	DROP COLUMN Mes, Ano
GO
ALTER TABLE dbo.MovimientosBancarios SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


Update MovimientosBancarios 
Set Beneficiario = 'Indefinido' 
Where LTrim(Rtrim(Beneficiario)) = '' Or Beneficiario Is Null

Update MovimientosBancarios 
Set Concepto = 'Indefinido' 
Where LTrim(Rtrim(Concepto)) = '' Or Concepto Is Null

Update MovimientosBancarios 
Set Ingreso = '1990-01-01'  
Where Ingreso Is Null

Update MovimientosBancarios 
Set UltMod = '1990-01-01'  
Where UltMod Is Null

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
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Proveedores
GO
ALTER TABLE dbo.Proveedores SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Asientos
GO
ALTER TABLE dbo.Asientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Chequeras
GO
ALTER TABLE dbo.Chequeras SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_MovimientosBancarios
	(
	Transaccion nvarchar(20) NOT NULL,
	Tipo nvarchar(2) NOT NULL,
	Fecha date NOT NULL,
	ProvClte int NULL,
	Beneficiario nvarchar(50) NOT NULL,
	Concepto nvarchar(250) NOT NULL,
	MontoBase money NULL,
	Comision money NULL,
	Impuestos money NULL,
	Monto money NOT NULL,
	Ingreso datetime NOT NULL,
	UltMod datetime NOT NULL,
	Usuario nvarchar(25) NOT NULL,
	Comprobante int NULL,
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	ClaveUnicaChequera int NOT NULL,
	FechaEntregado date NULL,
	Conciliacion_FechaEjecucion smalldatetime NULL,
	Conciliacion_MovimientoBanco_Fecha smalldatetime NULL,
	Conciliacion_MovimientoBanco_Numero nvarchar(50) NULL,
	Conciliacion_MovimientoBanco_Tipo nvarchar(4) NULL,
	Conciliacion_MovimientoBanco_FechaProceso smalldatetime NULL,
	Conciliacion_MovimientoBanco_Monto money NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_MovimientosBancarios SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_MovimientosBancarios ON
GO
IF EXISTS(SELECT * FROM dbo.MovimientosBancarios)
	 EXEC('INSERT INTO dbo.Tmp_MovimientosBancarios (Transaccion, Tipo, Fecha, ProvClte, Beneficiario, Concepto, MontoBase, Comision, Impuestos, Monto, Ingreso, UltMod, Usuario, Comprobante, ClaveUnica, ClaveUnicaChequera, FechaEntregado, Conciliacion_FechaEjecucion, Conciliacion_MovimientoBanco_Fecha, Conciliacion_MovimientoBanco_Numero, Conciliacion_MovimientoBanco_Tipo, Conciliacion_MovimientoBanco_FechaProceso, Conciliacion_MovimientoBanco_Monto)
		SELECT Transaccion, Tipo, Fecha, ProvClte, Beneficiario, Concepto, MontoBase, Comision, Impuestos, Monto, Ingreso, UltMod, Usuario, Comprobante, ClaveUnica, ClaveUnicaChequera, FechaEntregado, Conciliacion_FechaEjecucion, Conciliacion_MovimientoBanco_Fecha, Conciliacion_MovimientoBanco_Numero, Conciliacion_MovimientoBanco_Tipo, Conciliacion_MovimientoBanco_FechaProceso, Conciliacion_MovimientoBanco_Monto FROM dbo.MovimientosBancarios WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_MovimientosBancarios OFF
GO
DROP TABLE dbo.MovimientosBancarios
GO
EXECUTE sp_rename N'dbo.Tmp_MovimientosBancarios', N'MovimientosBancarios', 'OBJECT' 
GO
ALTER TABLE dbo.MovimientosBancarios ADD CONSTRAINT
	PK_MovimientosBancarios PRIMARY KEY CLUSTERED 
	(
	ClaveUnica
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.MovimientosBancarios ADD CONSTRAINT
	FK_MovimientosBancarios_Chequeras FOREIGN KEY
	(
	ClaveUnicaChequera
	) REFERENCES dbo.Chequeras
	(
	NumeroChequera
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.MovimientosBancarios ADD CONSTRAINT
	FK_MovimientosBancarios_Asientos FOREIGN KEY
	(
	Comprobante
	) REFERENCES dbo.Asientos
	(
	NumeroAutomatico
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.MovimientosBancarios WITH NOCHECK ADD CONSTRAINT
	FK_MovimientosBancarios_Proveedores FOREIGN KEY
	(
	ProvClte
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT




Update Chequeras Set Ingreso = '1990-01-01' Where Ingreso Is Null 
Update Chequeras Set UltAct = '1990-01-01' Where UltAct Is Null 
Update Chequeras Set AgotadaFlag = 0 Where AgotadaFlag Is Null 
Update Chequeras Set Generica = 0 Where Generica Is Null 

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
ALTER TABLE dbo.Chequeras
	DROP CONSTRAINT FK_Chequeras_CuentasBancarias
GO
ALTER TABLE dbo.CuentasBancarias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Chequeras
	(
	NumeroChequera int NOT NULL IDENTITY (1, 1),
	NumeroCuenta int NOT NULL,
	Generica bit NOT NULL,
	FechaAsignacion datetime NOT NULL,
	Desde int NOT NULL,
	Hasta int NOT NULL,
	AsignadaA nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	AgotadaFlag bit NOT NULL,
	CantidadDeChequesUsados smallint NULL,
	UltimoChequeUsado nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CantidadDeCheques int NULL,
	Usuario nvarchar(25) NOT NULL,
	Ingreso datetime NOT NULL,
	UltAct datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Chequeras SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Chequeras ON
GO
IF EXISTS(SELECT * FROM dbo.Chequeras)
	 EXEC('INSERT INTO dbo.Tmp_Chequeras (NumeroChequera, NumeroCuenta, Generica, FechaAsignacion, Desde, Hasta, AsignadaA, AgotadaFlag, CantidadDeChequesUsados, UltimoChequeUsado, CantidadDeCheques, Usuario, Ingreso, UltAct)
		SELECT NumeroChequera, NumeroCuenta, Generica, FechaAsignacion, Desde, Hasta, AsignadaA, AgotadaFlag, CantidadDeChequesUsados, UltimoChequeUsado, CantidadDeCheques, Usuario, Ingreso, UltAct FROM dbo.Chequeras WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Chequeras OFF
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Chequeras
GO
DROP TABLE dbo.Chequeras
GO
EXECUTE sp_rename N'dbo.Tmp_Chequeras', N'Chequeras', 'OBJECT' 
GO
ALTER TABLE dbo.Chequeras ADD CONSTRAINT
	PK_Chequeras PRIMARY KEY NONCLUSTERED 
	(
	NumeroChequera
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_Chequeras ON dbo.Chequeras
	(
	NumeroCuenta
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.Chequeras WITH NOCHECK ADD CONSTRAINT
	FK_Chequeras_CuentasBancarias FOREIGN KEY
	(
	NumeroCuenta
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.MovimientosBancarios ADD CONSTRAINT
	FK_MovimientosBancarios_Chequeras FOREIGN KEY
	(
	ClaveUnicaChequera
	) REFERENCES dbo.Chequeras
	(
	NumeroChequera
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.MovimientosBancarios SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.Chequeras
	DROP CONSTRAINT FK_Chequeras_CuentasBancarias
GO
ALTER TABLE dbo.CuentasBancarias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Chequeras
	(
	NumeroChequera int NOT NULL IDENTITY (1, 1),
	NumeroCuenta int NOT NULL,
	Activa bit NULL,
	Generica bit NOT NULL,
	FechaAsignacion datetime NOT NULL,
	Desde int NOT NULL,
	Hasta int NOT NULL,
	AsignadaA nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	AgotadaFlag bit NOT NULL,
	CantidadDeChequesUsados smallint NULL,
	UltimoChequeUsado nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CantidadDeCheques int NULL,
	Usuario nvarchar(25) NOT NULL,
	Ingreso datetime NOT NULL,
	UltAct datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Chequeras SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Chequeras ON
GO
IF EXISTS(SELECT * FROM dbo.Chequeras)
	 EXEC('INSERT INTO dbo.Tmp_Chequeras (NumeroChequera, NumeroCuenta, Generica, FechaAsignacion, Desde, Hasta, AsignadaA, AgotadaFlag, CantidadDeChequesUsados, UltimoChequeUsado, CantidadDeCheques, Usuario, Ingreso, UltAct)
		SELECT NumeroChequera, NumeroCuenta, Generica, FechaAsignacion, Desde, Hasta, AsignadaA, AgotadaFlag, CantidadDeChequesUsados, UltimoChequeUsado, CantidadDeCheques, Usuario, Ingreso, UltAct FROM dbo.Chequeras WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Chequeras OFF
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Chequeras
GO
DROP TABLE dbo.Chequeras
GO
EXECUTE sp_rename N'dbo.Tmp_Chequeras', N'Chequeras', 'OBJECT' 
GO
ALTER TABLE dbo.Chequeras ADD CONSTRAINT
	PK_Chequeras PRIMARY KEY NONCLUSTERED 
	(
	NumeroChequera
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_Chequeras ON dbo.Chequeras
	(
	NumeroCuenta
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.Chequeras WITH NOCHECK ADD CONSTRAINT
	FK_Chequeras_CuentasBancarias FOREIGN KEY
	(
	NumeroCuenta
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.MovimientosBancarios ADD CONSTRAINT
	FK_MovimientosBancarios_Chequeras FOREIGN KEY
	(
	ClaveUnicaChequera
	) REFERENCES dbo.Chequeras
	(
	NumeroChequera
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.MovimientosBancarios SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


Update Chequeras Set Activa = 1 
Alter Table Chequeras Alter Column Activa bit Not Null 



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
ALTER TABLE dbo.Chequeras
	DROP CONSTRAINT FK_Chequeras_CuentasBancarias
GO
ALTER TABLE dbo.CuentasBancarias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Chequeras
	(
	NumeroChequera int NOT NULL IDENTITY (1, 1),
	NumeroCuenta int NOT NULL,
	Activa bit NOT NULL,
	Generica bit NOT NULL,
	FechaAsignacion date NOT NULL,
	Desde int NOT NULL,
	Hasta int NOT NULL,
	AsignadaA nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	AgotadaFlag bit NOT NULL,
	CantidadDeChequesUsados smallint NULL,
	UltimoChequeUsado nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CantidadDeCheques int NULL,
	Usuario nvarchar(25) NOT NULL,
	Ingreso datetime NOT NULL,
	UltAct datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Chequeras SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Chequeras ON
GO
IF EXISTS(SELECT * FROM dbo.Chequeras)
	 EXEC('INSERT INTO dbo.Tmp_Chequeras (NumeroChequera, NumeroCuenta, Activa, Generica, FechaAsignacion, Desde, Hasta, AsignadaA, AgotadaFlag, CantidadDeChequesUsados, UltimoChequeUsado, CantidadDeCheques, Usuario, Ingreso, UltAct)
		SELECT NumeroChequera, NumeroCuenta, Activa, Generica, CONVERT(date, FechaAsignacion), Desde, Hasta, AsignadaA, AgotadaFlag, CantidadDeChequesUsados, UltimoChequeUsado, CantidadDeCheques, Usuario, Ingreso, UltAct FROM dbo.Chequeras WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Chequeras OFF
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Chequeras
GO
DROP TABLE dbo.Chequeras
GO
EXECUTE sp_rename N'dbo.Tmp_Chequeras', N'Chequeras', 'OBJECT' 
GO
ALTER TABLE dbo.Chequeras ADD CONSTRAINT
	PK_Chequeras PRIMARY KEY NONCLUSTERED 
	(
	NumeroChequera
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_Chequeras ON dbo.Chequeras
	(
	NumeroCuenta
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.Chequeras WITH NOCHECK ADD CONSTRAINT
	FK_Chequeras_CuentasBancarias FOREIGN KEY
	(
	NumeroCuenta
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.MovimientosBancarios ADD CONSTRAINT
	FK_MovimientosBancarios_Chequeras FOREIGN KEY
	(
	ClaveUnicaChequera
	) REFERENCES dbo.Chequeras
	(
	NumeroChequera
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.MovimientosBancarios SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.Chequeras
	DROP CONSTRAINT FK_Chequeras_CuentasBancarias
GO
ALTER TABLE dbo.CuentasBancarias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Chequeras
	(
	NumeroChequera int NOT NULL IDENTITY (1, 1),
	NumeroCuenta int NOT NULL,
	Activa bit NOT NULL,
	Generica bit NOT NULL,
	FechaAsignacion date NOT NULL,
	Desde int NULL,
	Hasta int NULL,
	AsignadaA nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	AgotadaFlag bit NOT NULL,
	CantidadDeChequesUsados smallint NULL,
	UltimoChequeUsado nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CantidadDeCheques int NULL,
	Usuario nvarchar(25) NOT NULL,
	Ingreso datetime NOT NULL,
	UltAct datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Chequeras SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Chequeras ON
GO
IF EXISTS(SELECT * FROM dbo.Chequeras)
	 EXEC('INSERT INTO dbo.Tmp_Chequeras (NumeroChequera, NumeroCuenta, Activa, Generica, FechaAsignacion, Desde, Hasta, AsignadaA, AgotadaFlag, CantidadDeChequesUsados, UltimoChequeUsado, CantidadDeCheques, Usuario, Ingreso, UltAct)
		SELECT NumeroChequera, NumeroCuenta, Activa, Generica, FechaAsignacion, Desde, Hasta, AsignadaA, AgotadaFlag, CantidadDeChequesUsados, UltimoChequeUsado, CantidadDeCheques, Usuario, Ingreso, UltAct FROM dbo.Chequeras WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Chequeras OFF
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Chequeras
GO
DROP TABLE dbo.Chequeras
GO
EXECUTE sp_rename N'dbo.Tmp_Chequeras', N'Chequeras', 'OBJECT' 
GO
ALTER TABLE dbo.Chequeras ADD CONSTRAINT
	PK_Chequeras PRIMARY KEY NONCLUSTERED 
	(
	NumeroChequera
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_Chequeras ON dbo.Chequeras
	(
	NumeroCuenta
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.Chequeras WITH NOCHECK ADD CONSTRAINT
	FK_Chequeras_CuentasBancarias FOREIGN KEY
	(
	NumeroCuenta
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.MovimientosBancarios ADD CONSTRAINT
	FK_MovimientosBancarios_Chequeras FOREIGN KEY
	(
	ClaveUnicaChequera
	) REFERENCES dbo.Chequeras
	(
	NumeroChequera
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.MovimientosBancarios SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.Chequeras
	DROP CONSTRAINT FK_Chequeras_CuentasBancarias
GO
ALTER TABLE dbo.CuentasBancarias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Chequeras
	(
	NumeroChequera int NOT NULL IDENTITY (1, 1),
	NumeroCuenta int NOT NULL,
	Activa bit NOT NULL,
	Generica bit NOT NULL,
	FechaAsignacion date NOT NULL,
	Desde int NULL,
	Hasta int NULL,
	AsignadaA nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	AgotadaFlag bit NULL,
	CantidadDeChequesUsados smallint NULL,
	UltimoChequeUsado nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CantidadDeCheques int NULL,
	Usuario nvarchar(25) NOT NULL,
	Ingreso datetime NOT NULL,
	UltAct datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Chequeras SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Chequeras ON
GO
IF EXISTS(SELECT * FROM dbo.Chequeras)
	 EXEC('INSERT INTO dbo.Tmp_Chequeras (NumeroChequera, NumeroCuenta, Activa, Generica, FechaAsignacion, Desde, Hasta, AsignadaA, AgotadaFlag, CantidadDeChequesUsados, UltimoChequeUsado, CantidadDeCheques, Usuario, Ingreso, UltAct)
		SELECT NumeroChequera, NumeroCuenta, Activa, Generica, FechaAsignacion, Desde, Hasta, AsignadaA, AgotadaFlag, CantidadDeChequesUsados, UltimoChequeUsado, CantidadDeCheques, Usuario, Ingreso, UltAct FROM dbo.Chequeras WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Chequeras OFF
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Chequeras
GO
DROP TABLE dbo.Chequeras
GO
EXECUTE sp_rename N'dbo.Tmp_Chequeras', N'Chequeras', 'OBJECT' 
GO
ALTER TABLE dbo.Chequeras ADD CONSTRAINT
	PK_Chequeras PRIMARY KEY NONCLUSTERED 
	(
	NumeroChequera
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_Chequeras ON dbo.Chequeras
	(
	NumeroCuenta
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.Chequeras WITH NOCHECK ADD CONSTRAINT
	FK_Chequeras_CuentasBancarias FOREIGN KEY
	(
	NumeroCuenta
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.MovimientosBancarios ADD CONSTRAINT
	FK_MovimientosBancarios_Chequeras FOREIGN KEY
	(
	ClaveUnicaChequera
	) REFERENCES dbo.Chequeras
	(
	NumeroChequera
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.MovimientosBancarios SET (LOCK_ESCALATION = TABLE)
GO
COMMIT




Update Chequeras Set CantidadDeCheques = null, 
					 Desde = null, 
					 Hasta = null, 
					 UltimoChequeUsado = null, 
					 AsignadaA = null, 
					 CantidadDeChequesUsados = null, 
					 AgotadaFlag = null
Where Generica = 1 














/****** Object:  View [dbo].[qFormaMovimientosBancariosConsulta]    Script Date: 11/07/2011 10:18:25 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qFormaMovimientosBancariosConsulta]'))
DROP VIEW [dbo].[qFormaMovimientosBancariosConsulta]
GO

/****** Object:  View [dbo].[qFormaMovimientosBancariosConsulta]    Script Date: 11/07/2011 10:18:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[qFormaMovimientosBancariosConsulta]
AS
SELECT     dbo.Bancos.Nombre AS NombreBanco, dbo.MovimientosBancarios.Transaccion, dbo.MovimientosBancarios.Tipo, 
                      dbo.CuentasBancarias.CuentaBancaria, dbo.MovimientosBancarios.Fecha, dbo.MovimientosBancarios.ProvClte, 
                      dbo.Proveedores.Nombre AS NombreProveedorCliente, dbo.MovimientosBancarios.Beneficiario, dbo.MovimientosBancarios.Concepto, 
                      dbo.MovimientosBancarios.MontoBase, dbo.MovimientosBancarios.Comision, dbo.MovimientosBancarios.Impuestos, 
                      dbo.MovimientosBancarios.Monto, dbo.MovimientosBancarios.Ingreso, dbo.MovimientosBancarios.UltMod, dbo.MovimientosBancarios.Comprobante, 
                      dbo.MovimientosBancarios.ClaveUnica, dbo.MovimientosBancarios.ClaveUnicaChequera, dbo.MovimientosBancarios.FechaEntregado, 
                      dbo.CuentasBancarias.Cia
FROM         dbo.Bancos INNER JOIN
                      dbo.CuentasBancarias ON dbo.Bancos.Banco = dbo.CuentasBancarias.Banco INNER JOIN
                      dbo.Chequeras ON dbo.CuentasBancarias.CuentaInterna = dbo.Chequeras.NumeroCuenta INNER JOIN
                      dbo.MovimientosBancarios ON dbo.Chequeras.NumeroChequera = dbo.MovimientosBancarios.ClaveUnicaChequera LEFT OUTER JOIN
                      dbo.Proveedores ON dbo.MovimientosBancarios.ProvClte = dbo.Proveedores.Proveedor

GO




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion
Insert Into tVersion(VersionActual, Fecha) Values('v0.00.290', GetDate()) 