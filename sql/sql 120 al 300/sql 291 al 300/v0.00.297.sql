/*    Lunes, 05 de Diciembre de 2.011  -   v0.00.297.sql 

	Hacemos cambios a tables 'de trabajo' para Conciliación y 
	Consulta de Disponibilidad 
*/



Update MovimientosBancarios Set Conciliacion_MovimientoBanco_Numero  = null 



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
	DROP CONSTRAINT FK_MovimientosBancarios_Chequeras
GO
ALTER TABLE dbo.Chequeras SET (LOCK_ESCALATION = TABLE)
GO
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
CREATE TABLE dbo.Tmp_MovimientosBancarios
	(
	Transaccion bigint NOT NULL,
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
	Conciliacion_MovimientoBanco_Numero bigint NULL,
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
		SELECT Transaccion, Tipo, Fecha, ProvClte, Beneficiario, Concepto, MontoBase, Comision, Impuestos, Monto, Ingreso, UltMod, Usuario, Comprobante, ClaveUnica, ClaveUnicaChequera, FechaEntregado, Conciliacion_FechaEjecucion, Conciliacion_MovimientoBanco_Fecha, CONVERT(bigint, Conciliacion_MovimientoBanco_Numero), Conciliacion_MovimientoBanco_Tipo, Conciliacion_MovimientoBanco_FechaProceso, Conciliacion_MovimientoBanco_Monto FROM dbo.MovimientosBancarios WITH (HOLDLOCK TABLOCKX)')
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
COMMIT





--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.297', GetDate()) 