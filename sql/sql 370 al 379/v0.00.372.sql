/*    Jueves, 19 de Junio de 2.014   -  v0.00.372.sql 

	Consulta disponibilidad - tTempWebReport_DisponibilidadBancos2 
	aumentamos la columna que permite registrar el nombre de la compañía 
	a 70 chars. 
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
CREATE TABLE dbo.Tmp_tTempWebReport_DisponibilidadBancos2
	(
	ID int NOT NULL IDENTITY (1, 1),
	CuentaInterna int NOT NULL,
	Transaccion bigint NOT NULL,
	Tipo nvarchar(2) NOT NULL,
	Orden smallint NOT NULL,
	Fecha datetime NOT NULL,
	ProvClte int NULL,
	NombreProveedorCliente nvarchar(70) NULL,
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
SET IDENTITY_INSERT dbo.Tmp_tTempWebReport_DisponibilidadBancos2 ON
GO
IF EXISTS(SELECT * FROM dbo.tTempWebReport_DisponibilidadBancos2)
	 EXEC('INSERT INTO dbo.Tmp_tTempWebReport_DisponibilidadBancos2 (ID, CuentaInterna, Transaccion, Tipo, Orden, Fecha, ProvClte, NombreProveedorCliente, Beneficiario, Concepto, Monto, FechaEntregado, Conciliacion_FechaEjecucion, CiaContab, NombreUsuario)
		SELECT ID, CuentaInterna, Transaccion, Tipo, Orden, Fecha, ProvClte, NombreProveedorCliente, Beneficiario, Concepto, Monto, FechaEntregado, Conciliacion_FechaEjecucion, CiaContab, NombreUsuario FROM dbo.tTempWebReport_DisponibilidadBancos2 WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tTempWebReport_DisponibilidadBancos2 OFF
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



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.372', GetDate()) 