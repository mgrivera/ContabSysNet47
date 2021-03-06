/*    Viernes, 30 de Diciembre de 2.011  -   v0.00.300.sql 

	Agregamos la columna ProvieneDe_ID a la tabla Asientos Contables 
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
	Fecha datetime NOT NULL,
	Descripcion nvarchar(250) NULL,
	Moneda int NOT NULL,
	MonedaOriginal int NOT NULL,
	ConvertirFlag bit NULL,
	FactorDeCambio money NOT NULL,
	ProvieneDe nvarchar(25) NULL,
	ProvieneDe_ID int NULL,
	Ingreso datetime NOT NULL,
	UltAct datetime NOT NULL,
	CopiableFlag bit NULL,
	AsientoTipoCierreAnualFlag bit NULL,
	MesFiscal smallint NOT NULL,
	AnoFiscal smallint NOT NULL,
	Usuario nvarchar(25) NOT NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Asientos SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Asientos ON
GO
IF EXISTS(SELECT * FROM dbo.Asientos)
	 EXEC('INSERT INTO dbo.Tmp_Asientos (NumeroAutomatico, Numero, Mes, Ano, Tipo, Fecha, Descripcion, Moneda, MonedaOriginal, ConvertirFlag, FactorDeCambio, ProvieneDe, Ingreso, UltAct, CopiableFlag, AsientoTipoCierreAnualFlag, MesFiscal, AnoFiscal, Usuario, Cia)
		SELECT NumeroAutomatico, Numero, Mes, Ano, Tipo, Fecha, Descripcion, Moneda, MonedaOriginal, ConvertirFlag, FactorDeCambio, ProvieneDe, Ingreso, UltAct, CopiableFlag, AsientoTipoCierreAnualFlag, MesFiscal, AnoFiscal, Usuario, Cia FROM dbo.Asientos WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Asientos OFF
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Asientos
GO
ALTER TABLE dbo.dAsientos
	DROP CONSTRAINT FK_dAsientos_Asientos
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



/* actualizamos el nuevo item en Asientos con el n�mero del MovBancario cuando 
   exista una relaci�n */ 

Update a Set a.ProvieneDe_ID = b.ClaveUnica 
	From Asientos a Inner Join MovimientosBancarios b 
	On a.NumeroAutomatico = b.Comprobante 
	Where b.Comprobante Is Not Null 




BEGIN TRANSACTION
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP COLUMN Comprobante
GO
ALTER TABLE dbo.MovimientosBancarios SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
 



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.300', GetDate()) 