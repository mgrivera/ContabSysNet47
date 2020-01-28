/*    
	  Lunes 14 de Marzo de 2.016	-   v0.00.379a.sql 

	  agrandamos significativamente la column Usuario en MovimientosBancarios 
	  y Asientos 
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
	DROP CONSTRAINT FK_MovimientosBancarios_Chequeras
GO
ALTER TABLE dbo.Chequeras SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_MovimientosDesdeBancos
GO
ALTER TABLE dbo.MovimientosDesdeBancos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Asientos
	DROP CONSTRAINT FK_Asientos_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Asientos
	DROP CONSTRAINT FK_Asientos_TiposDeAsiento
GO
ALTER TABLE dbo.TiposDeAsiento SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Asientos
	DROP CONSTRAINT FK_Asientos_Monedas1
GO
ALTER TABLE dbo.Asientos
	DROP CONSTRAINT FK_Asientos_Monedas
GO
ALTER TABLE dbo.Monedas SET (LOCK_ESCALATION = TABLE)
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
	Signo bit NULL,
	MontoBase money NULL,
	Comision money NULL,
	Impuestos money NULL,
	Monto money NOT NULL,
	Ingreso datetime2(7) NOT NULL,
	UltMod datetime2(7) NOT NULL,
	Usuario nvarchar(125) NOT NULL,
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	ClaveUnicaChequera int NOT NULL,
	FechaEntregado date NULL,
	Conciliacion_FechaEjecucion smalldatetime NULL,
	Conciliacion_MovimientoBanco_Fecha smalldatetime NULL,
	Conciliacion_MovimientoBanco_Numero bigint NULL,
	Conciliacion_MovimientoBanco_Tipo nvarchar(4) NULL,
	Conciliacion_MovimientoBanco_FechaProceso smalldatetime NULL,
	Conciliacion_MovimientoBanco_Monto money NULL,
	PagoID int NULL,
	ConciliacionMovimientoID int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_MovimientosBancarios SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_MovimientosBancarios ON
GO
IF EXISTS(SELECT * FROM dbo.MovimientosBancarios)
	 EXEC('INSERT INTO dbo.Tmp_MovimientosBancarios (Transaccion, Tipo, Fecha, ProvClte, Beneficiario, Concepto, Signo, MontoBase, Comision, Impuestos, Monto, Ingreso, UltMod, Usuario, ClaveUnica, ClaveUnicaChequera, FechaEntregado, Conciliacion_FechaEjecucion, Conciliacion_MovimientoBanco_Fecha, Conciliacion_MovimientoBanco_Numero, Conciliacion_MovimientoBanco_Tipo, Conciliacion_MovimientoBanco_FechaProceso, Conciliacion_MovimientoBanco_Monto, PagoID, ConciliacionMovimientoID)
		SELECT Transaccion, Tipo, Fecha, ProvClte, Beneficiario, Concepto, Signo, MontoBase, Comision, Impuestos, Monto, Ingreso, UltMod, Usuario, ClaveUnica, ClaveUnicaChequera, FechaEntregado, Conciliacion_FechaEjecucion, Conciliacion_MovimientoBanco_Fecha, Conciliacion_MovimientoBanco_Numero, Conciliacion_MovimientoBanco_Tipo, Conciliacion_MovimientoBanco_FechaProceso, Conciliacion_MovimientoBanco_Monto, PagoID, ConciliacionMovimientoID FROM dbo.MovimientosBancarios WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_MovimientosBancarios OFF
GO
ALTER TABLE dbo.MovimientosBancariosPagosTarjetas
	DROP CONSTRAINT FK_MovimientosBancariosPagosTarjetas_MovimientosBancarios
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
	FK_MovimientosBancarios_MovimientosDesdeBancos FOREIGN KEY
	(
	ConciliacionMovimientoID
	) REFERENCES dbo.MovimientosDesdeBancos
	(
	ID
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
GO
ALTER TABLE dbo.MovimientosBancariosPagosTarjetas ADD CONSTRAINT
	FK_MovimientosBancariosPagosTarjetas_MovimientosBancarios FOREIGN KEY
	(
	MovimientoBancarioID
	) REFERENCES dbo.MovimientosBancarios
	(
	ClaveUnica
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.MovimientosBancariosPagosTarjetas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Asientos
	(
	NumeroAutomatico int NOT NULL IDENTITY (1, 1),
	Numero smallint NOT NULL,
	Mes tinyint NOT NULL,
	Ano smallint NOT NULL,
	Tipo nvarchar(6) NOT NULL,
	Fecha date NOT NULL,
	Descripcion nvarchar(250) NULL,
	Moneda int NOT NULL,
	MonedaOriginal int NOT NULL,
	ConvertirFlag bit NULL,
	FactorDeCambio money NOT NULL,
	ProvieneDe nvarchar(25) NULL,
	ProvieneDe_ID int NULL,
	Ingreso datetime2(7) NOT NULL,
	UltAct datetime2(7) NOT NULL,
	CopiableFlag bit NULL,
	AsientoTipoCierreAnualFlag bit NULL,
	MesFiscal smallint NOT NULL,
	AnoFiscal smallint NOT NULL,
	Usuario nvarchar(125) NOT NULL,
	Lote nvarchar(150) NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Asientos SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Asientos ON
GO
IF EXISTS(SELECT * FROM dbo.Asientos)
	 EXEC('INSERT INTO dbo.Tmp_Asientos (NumeroAutomatico, Numero, Mes, Ano, Tipo, Fecha, Descripcion, Moneda, MonedaOriginal, ConvertirFlag, FactorDeCambio, ProvieneDe, ProvieneDe_ID, Ingreso, UltAct, CopiableFlag, AsientoTipoCierreAnualFlag, MesFiscal, AnoFiscal, Usuario, Lote, Cia)
		SELECT NumeroAutomatico, Numero, Mes, Ano, Tipo, Fecha, Descripcion, Moneda, MonedaOriginal, ConvertirFlag, FactorDeCambio, ProvieneDe, ProvieneDe_ID, Ingreso, UltAct, CopiableFlag, AsientoTipoCierreAnualFlag, MesFiscal, AnoFiscal, Usuario, Lote, Cia FROM dbo.Asientos WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Asientos OFF
GO
ALTER TABLE dbo.tTempWebReport_ConsultaComprobantesContables
	DROP CONSTRAINT FK_tTempWebReport_ConsultaComprobantesContables_Asientos
GO
ALTER TABLE dbo.dAsientos
	DROP CONSTRAINT FK_dAsientos_Asientos
GO
ALTER TABLE dbo.tNominaHeaders
	DROP CONSTRAINT FK_tNominaHeaders_Asientos
GO
DROP TABLE dbo.Asientos
GO
EXECUTE sp_rename N'dbo.Tmp_Asientos', N'Asientos', 'OBJECT' 
GO
ALTER TABLE dbo.Asientos ADD CONSTRAINT
	PK_Asientos PRIMARY KEY NONCLUSTERED 
	(
	NumeroAutomatico
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Asientos ADD CONSTRAINT
	IX_Asientos UNIQUE NONCLUSTERED 
	(
	Numero,
	Mes,
	Ano,
	Moneda,
	Cia
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Asientos ADD CONSTRAINT
	FK_Asientos_Monedas1 FOREIGN KEY
	(
	MonedaOriginal
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Asientos ADD CONSTRAINT
	FK_Asientos_TiposDeAsiento FOREIGN KEY
	(
	Tipo
	) REFERENCES dbo.TiposDeAsiento
	(
	Tipo
	) ON UPDATE  CASCADE 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Asientos ADD CONSTRAINT
	FK_Asientos_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Asientos ADD CONSTRAINT
	FK_Asientos_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
/*    Miércoles, 8 de Abril de 2.015 	-  v0.00.374a.sql 

	Asientos: agregamos tabla Asientos_Log, para agregar item cuando el usuario modifica 
	agrega un asiento; agregamos 'trigger' para que se registre este item en esta tabla, 
	cuando el usuario modifica un asiento 
*/


--  Insert trigger en Asientos

CREATE TRIGGER Asientos_Insert
   ON  dbo.Asientos
   AFTER Insert
AS 
BEGIN
	
	SET NOCOUNT ON;
	Insert Into Asientos_Log (NumeroAutomatico, NumeroAsiento, FechaAsiento, Usuario, FechaOperacion, DescripcionOperacion) 
	Select NumeroAutomatico, Numero, Fecha, Usuario, GetDate(), 'creado' From inserted; 
    
END
GO
--  Update trigger en Asientos

CREATE TRIGGER Asientos_Update
   ON  dbo.Asientos
   AFTER Update
AS 
BEGIN
	
	SET NOCOUNT ON;
	Insert Into Asientos_Log (NumeroAutomatico, NumeroAsiento, FechaAsiento, Usuario, FechaOperacion, DescripcionOperacion) 
	Select NumeroAutomatico, Numero, Fecha, Usuario, GetDate(), 'modificado' From inserted; 
    
END
GO
--  Delete trigger en Asientos

CREATE TRIGGER Asientos_Delete
   ON  dbo.Asientos
   AFTER Delete
AS 
BEGIN
	
	SET NOCOUNT ON;
	Insert Into Asientos_Log (NumeroAutomatico, NumeroAsiento, FechaAsiento, Usuario, FechaOperacion, DescripcionOperacion) 
	Select NumeroAutomatico, Numero, Fecha, Usuario, GetDate(), 'eliminado' From deleted; 
    
END
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tNominaHeaders ADD CONSTRAINT
	FK_tNominaHeaders_Asientos FOREIGN KEY
	(
	AsientoContableID
	) REFERENCES dbo.Asientos
	(
	NumeroAutomatico
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tNominaHeaders SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.dAsientos WITH NOCHECK ADD CONSTRAINT
	FK_dAsientos_Asientos FOREIGN KEY
	(
	NumeroAutomatico
	) REFERENCES dbo.Asientos
	(
	NumeroAutomatico
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.dAsientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tTempWebReport_ConsultaComprobantesContables ADD CONSTRAINT
	FK_tTempWebReport_ConsultaComprobantesContables_Asientos FOREIGN KEY
	(
	NumeroAutomatico
	) REFERENCES dbo.Asientos
	(
	NumeroAutomatico
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.tTempWebReport_ConsultaComprobantesContables SET (LOCK_ESCALATION = TABLE)
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
CREATE TABLE dbo.Tmp_Asientos_Log
	(
	ID bigint NOT NULL IDENTITY (1, 1),
	NumeroAutomatico int NOT NULL,
	NumeroAsiento smallint NOT NULL,
	FechaAsiento date NOT NULL,
	Usuario nvarchar(125) NOT NULL,
	FechaOperacion datetime2(7) NOT NULL,
	DescripcionOperacion nvarchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Asientos_Log SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Asientos_Log ON
GO
IF EXISTS(SELECT * FROM dbo.Asientos_Log)
	 EXEC('INSERT INTO dbo.Tmp_Asientos_Log (ID, NumeroAutomatico, NumeroAsiento, FechaAsiento, Usuario, FechaOperacion, DescripcionOperacion)
		SELECT ID, NumeroAutomatico, NumeroAsiento, FechaAsiento, Usuario, FechaOperacion, DescripcionOperacion FROM dbo.Asientos_Log WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Asientos_Log OFF
GO
DROP TABLE dbo.Asientos_Log
GO
EXECUTE sp_rename N'dbo.Tmp_Asientos_Log', N'Asientos_Log', 'OBJECT' 
GO
ALTER TABLE dbo.Asientos_Log ADD CONSTRAINT
	PK_Asientos_Log PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.379a', GetDate()) 
