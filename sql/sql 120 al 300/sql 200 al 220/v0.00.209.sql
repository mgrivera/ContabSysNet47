/*    Lunes, 27 de Agosto de 2.007   -   v0.00.209.sql 

	Agregamos la tabla Tarjetas, para registrar las tarjetas de crédito/débito

*/ 


BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.Tarjetas
	(
	Tarjeta nvarchar(4) NOT NULL,
	Nombre nvarchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tarjetas ADD CONSTRAINT
	PK_Tarjetas PRIMARY KEY CLUSTERED 
	(
	Tarjeta
	) ON [PRIMARY]

GO
COMMIT

Insert Into Tarjetas (Tarjeta, Nombre) Values ('VI', 'Visa') 
Insert Into Tarjetas (Tarjeta, Nombre) Values ('MC', 'Master') 
Insert Into Tarjetas (Tarjeta, Nombre) Values ('MA', 'Maestro') 
Insert Into Tarjetas (Tarjeta, Nombre) Values ('AM', 'American') 

BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.CuentasBancariasCuentasContables
	DROP CONSTRAINT FK_CuentasBancariasCuentasContables_CuentasBancarias
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.BancosInfoTarjetas
	DROP CONSTRAINT FK_BancosInfoTarjetas_Bancos
GO
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.Tmp_CuentasBancariasCuentasContables
	(
	CuentaInterna int NOT NULL,
	Tarjeta nvarchar(4) NOT NULL,
	CiaContab int NOT NULL,
	CuentaContableComision nvarchar(25) NULL,
	CuentaContableImpuestos nvarchar(25) NULL,
	CuentaContableCxC nvarchar(25) NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.CuentasBancariasCuentasContables)
	 EXEC('INSERT INTO dbo.Tmp_CuentasBancariasCuentasContables (CuentaInterna, Tarjeta, CiaContab, CuentaContableComision, CuentaContableImpuestos, CuentaContableCxC)
		SELECT CuentaInterna, CONVERT(nvarchar(4), Tarjeta), CiaContab, CuentaContableComision, CuentaContableImpuestos, CuentaContableCxC FROM dbo.CuentasBancariasCuentasContables TABLOCKX')
GO
DROP TABLE dbo.CuentasBancariasCuentasContables
GO
EXECUTE sp_rename N'dbo.Tmp_CuentasBancariasCuentasContables', N'CuentasBancariasCuentasContables', 'OBJECT'
GO
ALTER TABLE dbo.CuentasBancariasCuentasContables ADD CONSTRAINT
	PK_CuentasBancariasCuentasContables PRIMARY KEY CLUSTERED 
	(
	CuentaInterna,
	Tarjeta,
	CiaContab
	) ON [PRIMARY]

GO
ALTER TABLE dbo.CuentasBancariasCuentasContables WITH NOCHECK ADD CONSTRAINT
	FK_CuentasBancariasCuentasContables_CuentasBancarias FOREIGN KEY
	(
	CuentaInterna
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	)
GO
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.Tmp_MovimientosBancariosPagosTarjetas
	(
	Transaccion nvarchar(20) NOT NULL,
	CuentaInterna int NOT NULL,
	Tipo nvarchar(2) NOT NULL,
	Tarjeta nvarchar(4) NOT NULL,
	MontoBase money NULL,
	PorcComision decimal(5, 2) NULL,
	Comision money NULL,
	FactorReversionImpuestos float(53) NULL,
	MontoBaseParaImpuestos money NULL,
	PorcImpuestos decimal(5, 2) NULL,
	Impuestos money NULL,
	Monto money NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.MovimientosBancariosPagosTarjetas)
	 EXEC('INSERT INTO dbo.Tmp_MovimientosBancariosPagosTarjetas (Transaccion, CuentaInterna, Tipo, Tarjeta, MontoBase, PorcComision, Comision, FactorReversionImpuestos, MontoBaseParaImpuestos, PorcImpuestos, Impuestos, Monto)
		SELECT Transaccion, CuentaInterna, Tipo, CONVERT(nvarchar(4), Tarjeta), MontoBase, PorcComision, Comision, FactorReversionImpuestos, MontoBaseParaImpuestos, PorcImpuestos, Impuestos, Monto FROM dbo.MovimientosBancariosPagosTarjetas TABLOCKX')
GO
DROP TABLE dbo.MovimientosBancariosPagosTarjetas
GO
EXECUTE sp_rename N'dbo.Tmp_MovimientosBancariosPagosTarjetas', N'MovimientosBancariosPagosTarjetas', 'OBJECT'
GO
ALTER TABLE dbo.MovimientosBancariosPagosTarjetas ADD CONSTRAINT
	PK_MovimientosBancariosPagosTarjetas PRIMARY KEY CLUSTERED 
	(
	Transaccion,
	CuentaInterna,
	Tipo,
	Tarjeta
	) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.Tmp_BancosInfoTarjetas
	(
	Banco int NOT NULL,
	Tarjeta nvarchar(4) NOT NULL,
	CiaContab int NOT NULL,
	PorcComision decimal(5, 2) NULL,
	PorcImpuestos decimal(5, 2) NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.BancosInfoTarjetas)
	 EXEC('INSERT INTO dbo.Tmp_BancosInfoTarjetas (Banco, Tarjeta, CiaContab, PorcComision, PorcImpuestos)
		SELECT Banco, CONVERT(nvarchar(4), Tarjeta), CiaContab, PorcComision, PorcImpuestos FROM dbo.BancosInfoTarjetas TABLOCKX')
GO
DROP TABLE dbo.BancosInfoTarjetas
GO
EXECUTE sp_rename N'dbo.Tmp_BancosInfoTarjetas', N'BancosInfoTarjetas', 'OBJECT'
GO
ALTER TABLE dbo.BancosInfoTarjetas ADD CONSTRAINT
	PK_BancosInfoTarjetas PRIMARY KEY CLUSTERED 
	(
	Banco,
	Tarjeta,
	CiaContab
	) ON [PRIMARY]

GO
ALTER TABLE dbo.BancosInfoTarjetas WITH NOCHECK ADD CONSTRAINT
	FK_BancosInfoTarjetas_Bancos FOREIGN KEY
	(
	Banco
	) REFERENCES dbo.Bancos
	(
	Banco
	)
GO
COMMIT








BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.CuentasBancariasCuentasContables ADD CONSTRAINT
	FK_CuentasBancariasCuentasContables_Tarjetas FOREIGN KEY
	(
	Tarjeta
	) REFERENCES dbo.Tarjetas
	(
	Tarjeta
	) ON UPDATE CASCADE
	 ON DELETE CASCADE
	
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.MovimientosBancariosPagosTarjetas ADD CONSTRAINT
	FK_MovimientosBancariosPagosTarjetas_Tarjetas FOREIGN KEY
	(
	Tarjeta
	) REFERENCES dbo.Tarjetas
	(
	Tarjeta
	) ON UPDATE CASCADE
	 ON DELETE CASCADE
	
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.BancosInfoTarjetas ADD CONSTRAINT
	FK_BancosInfoTarjetas_Tarjetas FOREIGN KEY
	(
	Tarjeta
	) REFERENCES dbo.Tarjetas
	(
	Tarjeta
	) ON UPDATE CASCADE
	 ON DELETE CASCADE
	
GO
COMMIT




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.209', GetDate()) 