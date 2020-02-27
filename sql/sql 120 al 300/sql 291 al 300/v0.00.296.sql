/*    Lunes, 05 de Diciembre de 2.011  -   v0.00.296.sql 

	Hacemos cambios a tables 'de trabajo' para Conciliación y 
	Consulta de Disponibilidad 
*/

delete from Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad
delete from ConciliacionBancaria_MovimientosBancarios
delete from ConciliacionBancaria_MovimientosAConciliar



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
ALTER TABLE dbo.Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad
	DROP CONSTRAINT FK_Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad_Proveedores
GO
ALTER TABLE dbo.Proveedores SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad
	DROP CONSTRAINT FK_Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad_CuentasBancarias
GO
ALTER TABLE dbo.CuentasBancarias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_ConciliacionBancaria_MovimientosBancarios
	(
	CuentaInterna int NOT NULL,
	CuentaBancaria nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Transaccion bigint NOT NULL,
	Tipo nvarchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Fecha datetime NOT NULL,
	Beneficiario nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	NombreProveedorCliente nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	NombreBanco nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	SimboloMoneda nvarchar(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	NombreMoneda nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Concepto nvarchar(250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Monto money NOT NULL,
	FechaEntregado datetime NULL,
	Conciliacion_FechaEjecucion smalldatetime NULL,
	Conciliacion_MovimientoBanco_Fecha smalldatetime NULL,
	Conciliacion_MovimientoBanco_Numero nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Conciliacion_MovimientoBanco_Tipo nvarchar(4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Conciliacion_MovimientoBanco_FechaProceso smalldatetime NULL,
	Conciliacion_MovimientoBanco_Monto money NULL,
	NombreUsuario nvarchar(256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_ConciliacionBancaria_MovimientosBancarios SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.ConciliacionBancaria_MovimientosBancarios)
	 EXEC('INSERT INTO dbo.Tmp_ConciliacionBancaria_MovimientosBancarios (CuentaInterna, CuentaBancaria, Transaccion, Tipo, Fecha, Beneficiario, NombreProveedorCliente, NombreBanco, SimboloMoneda, NombreMoneda, Concepto, Monto, FechaEntregado, Conciliacion_FechaEjecucion, Conciliacion_MovimientoBanco_Fecha, Conciliacion_MovimientoBanco_Numero, Conciliacion_MovimientoBanco_Tipo, Conciliacion_MovimientoBanco_FechaProceso, Conciliacion_MovimientoBanco_Monto, NombreUsuario)
		SELECT CuentaInterna, CuentaBancaria, CONVERT(bigint, Transaccion), Tipo, Fecha, Beneficiario, NombreProveedorCliente, NombreBanco, SimboloMoneda, NombreMoneda, Concepto, Monto, FechaEntregado, Conciliacion_FechaEjecucion, Conciliacion_MovimientoBanco_Fecha, Conciliacion_MovimientoBanco_Numero, Conciliacion_MovimientoBanco_Tipo, Conciliacion_MovimientoBanco_FechaProceso, Conciliacion_MovimientoBanco_Monto, NombreUsuario FROM dbo.ConciliacionBancaria_MovimientosBancarios WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.ConciliacionBancaria_MovimientosBancarios
GO
EXECUTE sp_rename N'dbo.Tmp_ConciliacionBancaria_MovimientosBancarios', N'ConciliacionBancaria_MovimientosBancarios', 'OBJECT' 
GO
ALTER TABLE dbo.ConciliacionBancaria_MovimientosBancarios ADD CONSTRAINT
	PK_ConciliacionBancaria_MovimientosBancarios PRIMARY KEY CLUSTERED 
	(
	CuentaInterna,
	Transaccion,
	Tipo,
	NombreUsuario
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_ConciliacionBancaria_MovimientosAConciliar
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	Transaccion bigint NOT NULL,
	Tipo nvarchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Fecha datetime NOT NULL,
	FechaOperacion datetime NULL,
	Concepto nvarchar(250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Monto money NOT NULL,
	ConciliadoFlag bit NOT NULL,
	NombreUsuario nvarchar(256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_ConciliacionBancaria_MovimientosAConciliar SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_ConciliacionBancaria_MovimientosAConciliar ON
GO
IF EXISTS(SELECT * FROM dbo.ConciliacionBancaria_MovimientosAConciliar)
	 EXEC('INSERT INTO dbo.Tmp_ConciliacionBancaria_MovimientosAConciliar (ClaveUnica, Transaccion, Tipo, Fecha, FechaOperacion, Concepto, Monto, ConciliadoFlag, NombreUsuario)
		SELECT ClaveUnica, CONVERT(bigint, Transaccion), Tipo, Fecha, FechaOperacion, Concepto, Monto, ConciliadoFlag, NombreUsuario FROM dbo.ConciliacionBancaria_MovimientosAConciliar WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_ConciliacionBancaria_MovimientosAConciliar OFF
GO
DROP TABLE dbo.ConciliacionBancaria_MovimientosAConciliar
GO
EXECUTE sp_rename N'dbo.Tmp_ConciliacionBancaria_MovimientosAConciliar', N'ConciliacionBancaria_MovimientosAConciliar', 'OBJECT' 
GO
ALTER TABLE dbo.ConciliacionBancaria_MovimientosAConciliar ADD CONSTRAINT
	PK_ConciliacionBancaria_MovimientosAConciliar PRIMARY KEY CLUSTERED 
	(
	ClaveUnica
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad
	(
	CiaContab int NOT NULL,
	CuentaBancaria int NOT NULL,
	Fecha datetime NOT NULL,
	Transaccion bigint NOT NULL,
	ProvClte int NULL,
	Beneficiario nvarchar(50) NULL,
	Concepto nvarchar(250) NULL,
	Monto money NOT NULL,
	NombreUsuario nvarchar(256) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad)
	 EXEC('INSERT INTO dbo.Tmp_Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad (CiaContab, CuentaBancaria, Fecha, Transaccion, ProvClte, Beneficiario, Concepto, Monto, NombreUsuario)
		SELECT CiaContab, CuentaBancaria, Fecha, CONVERT(bigint, Transaccion), ProvClte, Beneficiario, Concepto, Monto, NombreUsuario FROM dbo.Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad
GO
EXECUTE sp_rename N'dbo.Tmp_Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad', N'Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad', 'OBJECT' 
GO
ALTER TABLE dbo.Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad ADD CONSTRAINT
	PK_Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad PRIMARY KEY CLUSTERED 
	(
	CiaContab,
	CuentaBancaria,
	Transaccion,
	NombreUsuario
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad ADD CONSTRAINT
	FK_Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad_CuentasBancarias FOREIGN KEY
	(
	CuentaBancaria
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad ADD CONSTRAINT
	FK_Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad_Proveedores FOREIGN KEY
	(
	ProvClte
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT




delete from tTempWebReport_DisponibilidadBancos2

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
CREATE TABLE dbo.Tmp_tTempWebReport_DisponibilidadBancos2
	(
	CuentaInterna int NOT NULL,
	Transaccion bigint NOT NULL,
	Tipo nvarchar(2) NOT NULL,
	Orden smallint NOT NULL,
	Fecha datetime NOT NULL,
	ProvClte int NULL,
	NombreProveedorCliente nvarchar(50) NULL,
	Beneficiario nvarchar(50) NULL,
	Concepto nvarchar(250) NULL,
	Monto money NOT NULL,
	FechaEntregado datetime NULL,
	Conciliacion_FechaEjecucion smalldatetime NULL,
	CiaContab int NOT NULL,
	NombreUsuario nvarchar(256) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tTempWebReport_DisponibilidadBancos2 SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.tTempWebReport_DisponibilidadBancos2)
	 EXEC('INSERT INTO dbo.Tmp_tTempWebReport_DisponibilidadBancos2 (CuentaInterna, Transaccion, Tipo, Orden, Fecha, ProvClte, NombreProveedorCliente, Beneficiario, Concepto, Monto, FechaEntregado, Conciliacion_FechaEjecucion, CiaContab, NombreUsuario)
		SELECT CuentaInterna, CONVERT(bigint, Transaccion), Tipo, Orden, Fecha, ProvClte, NombreProveedorCliente, Beneficiario, Concepto, Monto, FechaEntregado, Conciliacion_FechaEjecucion, CiaContab, NombreUsuario FROM dbo.tTempWebReport_DisponibilidadBancos2 WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.tTempWebReport_DisponibilidadBancos2
GO
EXECUTE sp_rename N'dbo.Tmp_tTempWebReport_DisponibilidadBancos2', N'tTempWebReport_DisponibilidadBancos2', 'OBJECT' 
GO
ALTER TABLE dbo.tTempWebReport_DisponibilidadBancos2 ADD CONSTRAINT
	PK_tTempWebReport_DisponibilidadBancos2 PRIMARY KEY CLUSTERED 
	(
	CuentaInterna,
	Transaccion,
	Tipo,
	CiaContab,
	NombreUsuario
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT























Delete From ConciliacionBancaria_MovimientosBancarios

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
CREATE TABLE dbo.Tmp_ConciliacionBancaria_MovimientosBancarios
	(
	CuentaInterna int NOT NULL,
	CuentaBancaria nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Transaccion bigint NOT NULL,
	Tipo nvarchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Fecha datetime NOT NULL,
	Beneficiario nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	NombreProveedorCliente nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	NombreBanco nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	SimboloMoneda nvarchar(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	NombreMoneda nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Concepto nvarchar(250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Monto money NOT NULL,
	FechaEntregado datetime NULL,
	Conciliacion_FechaEjecucion smalldatetime NULL,
	Conciliacion_MovimientoBanco_Fecha smalldatetime NULL,
	Conciliacion_MovimientoBanco_Numero bigint NULL,
	Conciliacion_MovimientoBanco_Tipo nvarchar(4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Conciliacion_MovimientoBanco_FechaProceso smalldatetime NULL,
	Conciliacion_MovimientoBanco_Monto money NULL,
	NombreUsuario nvarchar(256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_ConciliacionBancaria_MovimientosBancarios SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.ConciliacionBancaria_MovimientosBancarios)
	 EXEC('INSERT INTO dbo.Tmp_ConciliacionBancaria_MovimientosBancarios (CuentaInterna, CuentaBancaria, Transaccion, Tipo, Fecha, Beneficiario, NombreProveedorCliente, NombreBanco, SimboloMoneda, NombreMoneda, Concepto, Monto, FechaEntregado, Conciliacion_FechaEjecucion, Conciliacion_MovimientoBanco_Fecha, Conciliacion_MovimientoBanco_Numero, Conciliacion_MovimientoBanco_Tipo, Conciliacion_MovimientoBanco_FechaProceso, Conciliacion_MovimientoBanco_Monto, NombreUsuario)
		SELECT CuentaInterna, CuentaBancaria, Transaccion, Tipo, Fecha, Beneficiario, NombreProveedorCliente, NombreBanco, SimboloMoneda, NombreMoneda, Concepto, Monto, FechaEntregado, Conciliacion_FechaEjecucion, Conciliacion_MovimientoBanco_Fecha, CONVERT(bigint, Conciliacion_MovimientoBanco_Numero), Conciliacion_MovimientoBanco_Tipo, Conciliacion_MovimientoBanco_FechaProceso, Conciliacion_MovimientoBanco_Monto, NombreUsuario FROM dbo.ConciliacionBancaria_MovimientosBancarios WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.ConciliacionBancaria_MovimientosBancarios
GO
EXECUTE sp_rename N'dbo.Tmp_ConciliacionBancaria_MovimientosBancarios', N'ConciliacionBancaria_MovimientosBancarios', 'OBJECT' 
GO
ALTER TABLE dbo.ConciliacionBancaria_MovimientosBancarios ADD CONSTRAINT
	PK_ConciliacionBancaria_MovimientosBancarios PRIMARY KEY CLUSTERED 
	(
	CuentaInterna,
	Transaccion,
	Tipo,
	NombreUsuario
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.296', GetDate()) 