/*    Lunes, 17 de Julio de 2.006   -   v0.00.200.sql 

	Agregamos algunos items a la tabla MovimientosBancarios para permitir al usaurio calcular comision e 
	impuestos para los depósitos bancarios 

*/ 


--  ------------------------
--  table CuentasBancarias 
--  ------------------------

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
ALTER TABLE dbo.CuentasBancarias
	DROP CONSTRAINT FK_CuentasBancarias_Monedas
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasBancarias
	DROP CONSTRAINT FK_CuentasBancarias_Agencias
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasBancarias
	DROP CONSTRAINT FK_CuentasBancarias_Companias
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_CuentasBancarias
	(
	CuentaInterna int NOT NULL,
	Agencia int NOT NULL,
	CuentaBancaria nvarchar(50) NOT NULL,
	Tipo nvarchar(2) NOT NULL,
	Moneda int NOT NULL,
	LineaCredito money NULL,
	Banco int NULL,
	Estado char(2) NOT NULL,
	CuentaContable nvarchar(25) NULL,
	CuentaContableGastosIDB nvarchar(25) NULL,
	FormatoImpresionCheque smallint NULL,
	GenerarTransaccionesAOtraCuentaFlag bit NULL,
	CuentaBancariaAsociada int NULL,
	NombrePlantillaWord nvarchar(100) NULL,
	PorcComisionPagoTC decimal(5, 2) NULL,
	PorcImpuestosPagoTC decimal(5, 2) NULL,
	PorcComisionPagoTD decimal(5, 2) NULL,
	PorcImpuestosPagoTD decimal(5, 2) NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.CuentasBancarias)
	 EXEC('INSERT INTO dbo.Tmp_CuentasBancarias (CuentaInterna, Agencia, CuentaBancaria, Tipo, Moneda, LineaCredito, Banco, Estado, CuentaContable, CuentaContableGastosIDB, FormatoImpresionCheque, GenerarTransaccionesAOtraCuentaFlag, CuentaBancariaAsociada, NombrePlantillaWord, Cia)
		SELECT CuentaInterna, Agencia, CuentaBancaria, Tipo, Moneda, LineaCredito, Banco, Estado, CuentaContable, CuentaContableGastosIDB, FormatoImpresionCheque, GenerarTransaccionesAOtraCuentaFlag, CuentaBancariaAsociada, NombrePlantillaWord, Cia FROM dbo.CuentasBancarias WITH (HOLDLOCK TABLOCKX)')
GO
ALTER TABLE dbo.Chequeras
	DROP CONSTRAINT FK_Chequeras_CuentasBancarias
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_CuentasBancarias
GO
ALTER TABLE dbo.Saldos
	DROP CONSTRAINT FK_Saldos_CuentasBancarias
GO
DROP TABLE dbo.CuentasBancarias
GO
EXECUTE sp_rename N'dbo.Tmp_CuentasBancarias', N'CuentasBancarias', 'OBJECT' 
GO
ALTER TABLE dbo.CuentasBancarias ADD CONSTRAINT
	PK_CuentasBancarias PRIMARY KEY NONCLUSTERED 
	(
	CuentaInterna
	) ON [PRIMARY]

GO
ALTER TABLE dbo.CuentasBancarias WITH NOCHECK ADD CONSTRAINT
	FK_CuentasBancarias_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	)
GO
ALTER TABLE dbo.CuentasBancarias WITH NOCHECK ADD CONSTRAINT
	FK_CuentasBancarias_Agencias FOREIGN KEY
	(
	Agencia
	) REFERENCES dbo.Agencias
	(
	Agencia
	)
GO
ALTER TABLE dbo.CuentasBancarias WITH NOCHECK ADD CONSTRAINT
	FK_CuentasBancarias_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Saldos WITH NOCHECK ADD CONSTRAINT
	FK_Saldos_CuentasBancarias FOREIGN KEY
	(
	CuentaBancaria
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.MovimientosBancarios WITH NOCHECK ADD CONSTRAINT
	FK_MovimientosBancarios_CuentasBancarias FOREIGN KEY
	(
	CuentaInterna
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Chequeras WITH NOCHECK ADD CONSTRAINT
	FK_Chequeras_CuentasBancarias FOREIGN KEY
	(
	NumeroCuenta
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	)
GO
COMMIT

--  -----------------------------
--  table ParametrosGlobalBancos 
--  -----------------------------

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
ALTER TABLE dbo.ParametrosGlobalBancos ADD
	FactorReversionImpuestos float(53) NULL
GO
COMMIT


--  -----------------------------
--  table MovimientosBancarios
--  -----------------------------


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
	DROP CONSTRAINT FK_MovimientosBancarios_Companias
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Proveedores
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_CuentasBancarias
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_MovimientosBancarios
	(
	Transaccion nvarchar(20) NOT NULL,
	CuentaInterna int NOT NULL,
	Tipo nvarchar(2) NOT NULL,
	Fecha datetime NOT NULL,
	Mes smallint NOT NULL,
	Ano smallint NOT NULL,
	ProvClte int NULL,
	Beneficiario nvarchar(50) NULL,
	Concepto nvarchar(250) NULL,
	MontoBase money NULL,
	PorcComision decimal(5, 2) NULL,
	Comision money NULL,
	FactorReversionImpuestos float(53) NULL,
	MontoBaseParaImpuestos money NULL,
	PorcImpuestos decimal(5, 2) NULL,
	Impuestos money NULL,
	Monto money NOT NULL,
	Ingreso datetime NULL,
	UltMod datetime NULL,
	Comprobante int NULL,
	ClaveUnica int NOT NULL,
	ClaveUnicaChequera int NULL,
	FechaEntregado datetime NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.MovimientosBancarios)
	 EXEC('INSERT INTO dbo.Tmp_MovimientosBancarios (Transaccion, CuentaInterna, Tipo, Fecha, Mes, Ano, ProvClte, Beneficiario, Concepto, Comision, Monto, Ingreso, UltMod, Comprobante, ClaveUnica, ClaveUnicaChequera, FechaEntregado, Cia)
		SELECT Transaccion, CuentaInterna, Tipo, Fecha, Mes, Ano, ProvClte, Beneficiario, Concepto, Comision, Monto, Ingreso, UltMod, Comprobante, ClaveUnica, ClaveUnicaChequera, FechaEntregado, Cia FROM dbo.MovimientosBancarios WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.MovimientosBancarios
GO
EXECUTE sp_rename N'dbo.Tmp_MovimientosBancarios', N'MovimientosBancarios', 'OBJECT' 
GO
ALTER TABLE dbo.MovimientosBancarios ADD CONSTRAINT
	PK_MovimientosBancarios PRIMARY KEY NONCLUSTERED 
	(
	Transaccion,
	CuentaInterna,
	Tipo
	) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_MovimientosBancarios ON dbo.MovimientosBancarios
	(
	CuentaInterna
	) ON [PRIMARY]
GO
ALTER TABLE dbo.MovimientosBancarios WITH NOCHECK ADD CONSTRAINT
	FK_MovimientosBancarios_CuentasBancarias FOREIGN KEY
	(
	CuentaInterna
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	)
GO
ALTER TABLE dbo.MovimientosBancarios WITH NOCHECK ADD CONSTRAINT
	FK_MovimientosBancarios_Proveedores FOREIGN KEY
	(
	ProvClte
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	)
GO
ALTER TABLE dbo.MovimientosBancarios WITH NOCHECK ADD CONSTRAINT
	FK_MovimientosBancarios_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	)
GO
COMMIT






--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.200', GetDate()) 