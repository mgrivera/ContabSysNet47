/*    Miércoles, 11 de 2.012  -   v0.00.309.sql 

	Hacemos cambios leves a las tablas CuotasFacturas y 
	dFormasPago 
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
ALTER TABLE dbo.CuotasFactura
	DROP CONSTRAINT FK_CuotasFactura_Facturas
GO
ALTER TABLE dbo.Facturas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.dFormasDePago
	DROP CONSTRAINT FK_dFormasDePago_FormasDePago
GO
ALTER TABLE dbo.FormasDePago SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_CuotasFactura
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	ClaveUnicaFactura int NOT NULL,
	NumeroCuota smallint NOT NULL,
	DiasVencimiento smallint NOT NULL,
	FechaVencimiento date NOT NULL,
	ProporcionCuota decimal(6, 3) NOT NULL,
	MontoCuota money NOT NULL,
	Iva money NOT NULL,
	RetencionSobreIva money NULL,
	TotalCuota money NOT NULL,
	Anticipo money NULL,
	SaldoCuota money NOT NULL,
	EstadoCuota smallint NOT NULL,
	ProporcionIva decimal(6, 3) NOT NULL,
	ClaveUnicaUltimoPago int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_CuotasFactura SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_CuotasFactura ON
GO
IF EXISTS(SELECT * FROM dbo.CuotasFactura)
	 EXEC('INSERT INTO dbo.Tmp_CuotasFactura (ClaveUnica, ClaveUnicaFactura, NumeroCuota, DiasVencimiento, FechaVencimiento, ProporcionCuota, MontoCuota, Iva, RetencionSobreIva, TotalCuota, Anticipo, SaldoCuota, EstadoCuota, ProporcionIva, ClaveUnicaUltimoPago)
		SELECT ClaveUnica, ClaveUnicaFactura, NumeroCuota, DiasVencimiento, FechaVencimiento, ProporcionCuota, MontoCuota, Iva, RetencionSobreIva, TotalCuota, Anticipo, SaldoCuota, EstadoCuota, CONVERT(decimal(6, 3), ProporcionIva), ClaveUnicaUltimoPago FROM dbo.CuotasFactura WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_CuotasFactura OFF
GO
DROP TABLE dbo.CuotasFactura
GO
EXECUTE sp_rename N'dbo.Tmp_CuotasFactura', N'CuotasFactura', 'OBJECT' 
GO
ALTER TABLE dbo.CuotasFactura ADD CONSTRAINT
	PK_CuotasFactura PRIMARY KEY NONCLUSTERED 
	(
	ClaveUnica
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.CuotasFactura WITH NOCHECK ADD CONSTRAINT
	FK_CuotasFactura_Facturas FOREIGN KEY
	(
	ClaveUnicaFactura
	) REFERENCES dbo.Facturas
	(
	ClaveUnica
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_dFormasDePago
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	FormaDePago int NOT NULL,
	NumeroDeCuota smallint NOT NULL,
	DiasDeVencimiento smallint NOT NULL,
	Proporcion decimal(6, 3) NOT NULL,
	ProporcionIva decimal(6, 3) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_dFormasDePago SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_dFormasDePago ON
GO
IF EXISTS(SELECT * FROM dbo.dFormasDePago)
	 EXEC('INSERT INTO dbo.Tmp_dFormasDePago (ClaveUnica, FormaDePago, NumeroDeCuota, DiasDeVencimiento, Proporcion, ProporcionIva)
		SELECT ClaveUnica, FormaDePago, NumeroDeCuota, DiasDeVencimiento, CONVERT(decimal(6, 3), Proporcion), CONVERT(decimal(6, 3), ProporcionIva) FROM dbo.dFormasDePago WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_dFormasDePago OFF
GO
DROP TABLE dbo.dFormasDePago
GO
EXECUTE sp_rename N'dbo.Tmp_dFormasDePago', N'dFormasDePago', 'OBJECT' 
GO
ALTER TABLE dbo.dFormasDePago ADD CONSTRAINT
	PK_dFormasDePago PRIMARY KEY NONCLUSTERED 
	(
	ClaveUnica
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.dFormasDePago ADD CONSTRAINT
	FK_dFormasDePago_FormasDePago FOREIGN KEY
	(
	FormaDePago
	) REFERENCES dbo.FormasDePago
	(
	FormaDePago
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.309', GetDate()) 