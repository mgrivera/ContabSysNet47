/*    Miercoles, 27 de Marzo de 2.013  -   v0.00.336.sql 

	Cambiamos algunos detalles en las tablas 'Temp...' para la obtención de la 
	disponibilidad bancaria 
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
ALTER TABLE dbo.Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad
	DROP CONSTRAINT FK_Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad_CuentasBancarias
GO
ALTER TABLE dbo.CuentasBancarias SET (LOCK_ESCALATION = TABLE)
GO
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
CREATE TABLE dbo.Tmp_tTempWebReport_DisponibilidadBancos2
	(
	ID int NOT NULL IDENTITY (1, 1),
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
SET IDENTITY_INSERT dbo.Tmp_tTempWebReport_DisponibilidadBancos2 OFF
GO
IF EXISTS(SELECT * FROM dbo.tTempWebReport_DisponibilidadBancos2)
	 EXEC('INSERT INTO dbo.Tmp_tTempWebReport_DisponibilidadBancos2 (CuentaInterna, Transaccion, Tipo, Orden, Fecha, ProvClte, NombreProveedorCliente, Beneficiario, Concepto, Monto, FechaEntregado, Conciliacion_FechaEjecucion, CiaContab, NombreUsuario)
		SELECT CuentaInterna, Transaccion, Tipo, Orden, Fecha, ProvClte, NombreProveedorCliente, Beneficiario, Concepto, Monto, FechaEntregado, Conciliacion_FechaEjecucion, CiaContab, NombreUsuario FROM dbo.tTempWebReport_DisponibilidadBancos2 WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.tTempWebReport_DisponibilidadBancos2
GO
EXECUTE sp_rename N'dbo.Tmp_tTempWebReport_DisponibilidadBancos2', N'tTempWebReport_DisponibilidadBancos2', 'OBJECT' 
GO
ALTER TABLE dbo.tTempWebReport_DisponibilidadBancos2 ADD CONSTRAINT
	PK_tTempWebReport_DisponibilidadBancos2_1 PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_tTempWebReport_DisponibilidadBancos2 ON dbo.tTempWebReport_DisponibilidadBancos2
	(
	CuentaInterna,
	NombreUsuario,
	CiaContab
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad
	(
	ID int NOT NULL IDENTITY (1, 1),
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
SET IDENTITY_INSERT dbo.Tmp_Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad OFF
GO
IF EXISTS(SELECT * FROM dbo.Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad)
	 EXEC('INSERT INTO dbo.Tmp_Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad (CiaContab, CuentaBancaria, Fecha, Transaccion, ProvClte, Beneficiario, Concepto, Monto, NombreUsuario)
		SELECT CiaContab, CuentaBancaria, Fecha, Transaccion, ProvClte, Beneficiario, Concepto, Monto, NombreUsuario FROM dbo.Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad
GO
EXECUTE sp_rename N'dbo.Tmp_Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad', N'Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad', 'OBJECT' 
GO
ALTER TABLE dbo.Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad ADD CONSTRAINT
	PK_Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad_1 PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad ON dbo.Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad
	(
	NombreUsuario
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
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
COMMIT
BEGIN TRANSACTION
GO
CREATE NONCLUSTERED INDEX IX_Disponibilidad_MontosRestringidos_ConsultaDisponibilidad ON dbo.Disponibilidad_MontosRestringidos_ConsultaDisponibilidad
	(
	NombreUsuario
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.Disponibilidad_MontosRestringidos_ConsultaDisponibilidad SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.336', GetDate()) 