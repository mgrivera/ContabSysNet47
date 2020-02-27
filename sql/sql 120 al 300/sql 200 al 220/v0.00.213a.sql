/*    Jueves, 27 de Marzo de 2.008   -   v0.00.213a.sql 

	Agregamos algunos items a la tabla MovimientosBancarios para efectuar la conciliación automática 

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
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Companias
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Proveedores
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_CuentasBancarias
GO
COMMIT
BEGIN TRANSACTION
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
	Comision money NULL,
	Impuestos money NULL,
	Monto money NOT NULL,
	Ingreso datetime NULL,
	UltMod datetime NULL,
	Comprobante int NULL,
	ClaveUnica int NOT NULL,
	ClaveUnicaChequera int NULL,
	FechaEntregado datetime NULL,
	Conciliacion_FechaEjecucion smalldatetime NULL,
	Conciliacion_MovimientoBanco_Fecha smalldatetime NULL,
	Conciliacion_MovimientoBanco_Numero nvarchar(50) NULL,
	Conciliacion_MovimientoBanco_Tipo nvarchar(4) NULL,
	Conciliacion_MovimientoBanco_FechaProceso smalldatetime NULL,
	Conciliacion_MovimientoBanco_Monto money NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.MovimientosBancarios)
	 EXEC('INSERT INTO dbo.Tmp_MovimientosBancarios (Transaccion, CuentaInterna, Tipo, Fecha, Mes, Ano, ProvClte, Beneficiario, Concepto, MontoBase, Comision, Impuestos, Monto, Ingreso, UltMod, Comprobante, ClaveUnica, ClaveUnicaChequera, FechaEntregado, Cia)
		SELECT Transaccion, CuentaInterna, Tipo, Fecha, Mes, Ano, ProvClte, Beneficiario, Concepto, MontoBase, Comision, Impuestos, Monto, Ingreso, UltMod, Comprobante, ClaveUnica, ClaveUnicaChequera, FechaEntregado, Cia FROM dbo.MovimientosBancarios TABLOCKX')
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
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.213', GetDate()) 