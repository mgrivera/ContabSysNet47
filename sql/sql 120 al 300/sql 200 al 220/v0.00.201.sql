/*    Lunes, 17 de Julio de 2.006   -   v0.00.201.sql 

	Agregamos items para agregar movimientos bancarios de pagos de tarjetas. Además, agregamos la tabla 
	CuentasBancariasInfoTarjetas para parametrizar la información de estas transacciones y su contabilización 

*/ 


--  ------------------------
--  tabla CuentasBancarias 
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
	CuentaContableCxC nvarchar(25) NULL,
	FormatoImpresionCheque smallint NULL,
	GenerarTransaccionesAOtraCuentaFlag bit NULL,
	CuentaBancariaAsociada int NULL,
	NombrePlantillaWord nvarchar(100) NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.CuentasBancarias)
	 EXEC('INSERT INTO dbo.Tmp_CuentasBancarias (CuentaInterna, Agencia, CuentaBancaria, Tipo, Moneda, LineaCredito, Banco, Estado, CuentaContable, CuentaContableGastosIDB, FormatoImpresionCheque, GenerarTransaccionesAOtraCuentaFlag, CuentaBancariaAsociada, NombrePlantillaWord, Cia)
		SELECT CuentaInterna, Agencia, CuentaBancaria, Tipo, Moneda, LineaCredito, Banco, Estado, CuentaContable, CuentaContableGastosIDB, FormatoImpresionCheque, GenerarTransaccionesAOtraCuentaFlag, CuentaBancariaAsociada, NombrePlantillaWord, Cia FROM dbo.CuentasBancarias WITH (HOLDLOCK TABLOCKX)')
GO
ALTER TABLE dbo.Saldos
	DROP CONSTRAINT FK_Saldos_CuentasBancarias
GO
ALTER TABLE dbo.Chequeras
	DROP CONSTRAINT FK_Chequeras_CuentasBancarias
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_CuentasBancarias
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

--  ----------------------------
--  tabla MovimientosBancarios
--  ----------------------------


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
	Tarjeta char(2) NULL,
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
	 EXEC('INSERT INTO dbo.Tmp_MovimientosBancarios (Transaccion, CuentaInterna, Tipo, Fecha, Mes, Ano, ProvClte, Beneficiario, Concepto, MontoBase, PorcComision, Comision, FactorReversionImpuestos, MontoBaseParaImpuestos, PorcImpuestos, Impuestos, Monto, Ingreso, UltMod, Comprobante, ClaveUnica, ClaveUnicaChequera, FechaEntregado, Cia)
		SELECT Transaccion, CuentaInterna, Tipo, Fecha, Mes, Ano, ProvClte, Beneficiario, Concepto, MontoBase, PorcComision, Comision, FactorReversionImpuestos, MontoBaseParaImpuestos, PorcImpuestos, Impuestos, Monto, Ingreso, UltMod, Comprobante, ClaveUnica, ClaveUnicaChequera, FechaEntregado, Cia FROM dbo.MovimientosBancarios WITH (HOLDLOCK TABLOCKX)')
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


--  ---------------------------------------
--  Nueva tabla CuentasBancariasInfoTarjetas
--  ---------------------------------------


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[CuentasBancariasInfoTarjetas]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[CuentasBancariasInfoTarjetas]


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CuentasBancariasInfoTarjetas](
	[CuentaInterna] [int] NOT NULL,
	[Tarjeta] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PorcComision] [decimal](5, 2) NULL,
	[PorcImpuestos] [decimal](5, 2) NULL,
	[CiaContab] [int] NOT NULL,
	[CuentaContableComision] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CuentaContableImpuestos] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_CuentasBancariasInfoTarjetas] PRIMARY KEY CLUSTERED 
(
	[CuentaInterna] ASC,
	[Tarjeta] ASC,
	[CiaContab] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

--  ------------------------------------------------------------------------------
--  Relación entre CuentasBancarias y CuentasBancariasInfoTarjetas
--  ------------------------------------------------------------------------------

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
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasBancariasInfoTarjetas ADD CONSTRAINT
	FK_CuentasBancariasInfoTarjetas_CuentasBancarias FOREIGN KEY
	(
	CuentaInterna
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	)
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.201', GetDate()) 