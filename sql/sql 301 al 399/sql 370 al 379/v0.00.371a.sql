/*    Viernes, 18 de Julio de 2.014   -  v0.00.371a.sql 

	Agregamos la columna Lote a la tabla Asientos; ésto nos 
	permite agrupar registros cargados en forma masiva ... 

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
	Usuario nvarchar(25) NOT NULL,
	Lote nvarchar(50) NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Asientos SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Asientos ON
GO
IF EXISTS(SELECT * FROM dbo.Asientos)
	 EXEC('INSERT INTO dbo.Tmp_Asientos (NumeroAutomatico, Numero, Mes, Ano, Tipo, Fecha, Descripcion, Moneda, MonedaOriginal, ConvertirFlag, FactorDeCambio, ProvieneDe, ProvieneDe_ID, Ingreso, UltAct, CopiableFlag, AsientoTipoCierreAnualFlag, MesFiscal, AnoFiscal, Usuario, Cia)
		SELECT NumeroAutomatico, Numero, Mes, Ano, Tipo, Fecha, Descripcion, Moneda, MonedaOriginal, ConvertirFlag, FactorDeCambio, ProvieneDe, ProvieneDe_ID, Ingreso, UltAct, CopiableFlag, AsientoTipoCierreAnualFlag, MesFiscal, AnoFiscal, Usuario, Cia FROM dbo.Asientos WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Asientos OFF
GO
ALTER TABLE dbo.tNominaHeaders
	DROP CONSTRAINT FK_tNominaHeaders_Asientos
GO
ALTER TABLE dbo.dAsientos
	DROP CONSTRAINT FK_dAsientos_Asientos
GO
ALTER TABLE dbo.tTempWebReport_ConsultaComprobantesContables
	DROP CONSTRAINT FK_tTempWebReport_ConsultaComprobantesContables_Asientos
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
ALTER TABLE dbo.tTempWebReport_ConsultaComprobantesContables ADD
	Lote nvarchar(50) NULL
GO
ALTER TABLE dbo.tTempWebReport_ConsultaComprobantesContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.371a', GetDate()) 