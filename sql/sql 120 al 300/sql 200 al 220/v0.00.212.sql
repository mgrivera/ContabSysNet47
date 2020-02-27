/*    Viernes, 28 de Enero de 2.008   -   v0.00.212.sql 

	Hacemos cambios a las tablas de depósitos con tarjetas para incluír un 2do. descuento 

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
ALTER TABLE dbo.MovimientosBancariosPagosTarjetas
	DROP CONSTRAINT FK_MovimientosBancariosPagosTarjetas_Tarjetas
GO
ALTER TABLE dbo.BancosInfoTarjetas
	DROP CONSTRAINT FK_BancosInfoTarjetas_Tarjetas
GO
ALTER TABLE dbo.CuentasBancariasCuentasContables
	DROP CONSTRAINT FK_CuentasBancariasCuentasContables_Tarjetas
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
	PorcComision2 decimal(5, 2) NULL,
	Comision2 money NULL,
	FactorReversionImpuestos float(53) NULL,
	MontoBaseParaImpuestos money NULL,
	PorcImpuestos decimal(5, 2) NULL,
	Impuestos money NULL,
	Monto money NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.MovimientosBancariosPagosTarjetas)
	 EXEC('INSERT INTO dbo.Tmp_MovimientosBancariosPagosTarjetas (Transaccion, CuentaInterna, Tipo, Tarjeta, MontoBase, PorcComision, Comision, FactorReversionImpuestos, MontoBaseParaImpuestos, PorcImpuestos, Impuestos, Monto)
		SELECT Transaccion, CuentaInterna, Tipo, Tarjeta, MontoBase, PorcComision, Comision, FactorReversionImpuestos, MontoBaseParaImpuestos, PorcImpuestos, Impuestos, Monto FROM dbo.MovimientosBancariosPagosTarjetas TABLOCKX')
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
ALTER TABLE dbo.MovimientosBancariosPagosTarjetas WITH NOCHECK ADD CONSTRAINT
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
CREATE TABLE dbo.Tmp_CuentasBancariasCuentasContables
	(
	CuentaInterna int NOT NULL,
	Tarjeta nvarchar(4) NOT NULL,
	CiaContab int NOT NULL,
	CuentaContableComision nvarchar(25) NULL,
	CuentaContableComision2 nvarchar(25) NULL,
	CuentaContableImpuestos nvarchar(25) NULL,
	CuentaContableCxC nvarchar(25) NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.CuentasBancariasCuentasContables)
	 EXEC('INSERT INTO dbo.Tmp_CuentasBancariasCuentasContables (CuentaInterna, Tarjeta, CiaContab, CuentaContableComision, CuentaContableImpuestos, CuentaContableCxC)
		SELECT CuentaInterna, Tarjeta, CiaContab, CuentaContableComision, CuentaContableImpuestos, CuentaContableCxC FROM dbo.CuentasBancariasCuentasContables TABLOCKX')
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
ALTER TABLE dbo.CuentasBancariasCuentasContables WITH NOCHECK ADD CONSTRAINT
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
CREATE TABLE dbo.Tmp_BancosInfoTarjetas
	(
	Banco int NOT NULL,
	Tarjeta nvarchar(4) NOT NULL,
	CiaContab int NOT NULL,
	PorcComision decimal(5, 2) NULL,
	PorcComision2 decimal(5, 2) NULL,
	PorcImpuestos decimal(5, 2) NULL,
	AplicarFactorReversionImpuestos bit NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.BancosInfoTarjetas)
	 EXEC('INSERT INTO dbo.Tmp_BancosInfoTarjetas (Banco, Tarjeta, CiaContab, PorcComision, PorcImpuestos, AplicarFactorReversionImpuestos)
		SELECT Banco, Tarjeta, CiaContab, PorcComision, PorcImpuestos, AplicarFactorReversionImpuestos FROM dbo.BancosInfoTarjetas TABLOCKX')
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
	FK_BancosInfoTarjetas_Tarjetas FOREIGN KEY
	(
	Tarjeta
	) REFERENCES dbo.Tarjetas
	(
	Tarjeta
	) ON UPDATE CASCADE
	 ON DELETE CASCADE
	
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






if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaCuentasBancariasInfoCuentasContablesConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaCuentasBancariasInfoCuentasContablesConsulta]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaCuentasBancariasInfoCuentasContablesConsulta
AS
SELECT     dbo.Companias.Numero, dbo.CuentasBancariasCuentasContables.CuentaInterna, dbo.CuentasBancariasCuentasContables.Tarjeta, 
                      dbo.Companias.NombreCorto, dbo.CuentasBancariasCuentasContables.CuentaContableComision, 
                      dbo.CuentasBancariasCuentasContables.CuentaContableComision2, dbo.CuentasBancariasCuentasContables.CuentaContableImpuestos, 
                      dbo.CuentasBancariasCuentasContables.CuentaContableCxC
FROM         dbo.CuentasBancariasCuentasContables LEFT OUTER JOIN
                      dbo.Companias ON dbo.CuentasBancariasCuentasContables.CiaContab = dbo.Companias.Numero

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.212', GetDate()) 