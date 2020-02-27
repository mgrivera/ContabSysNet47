/*    Martes, 29 de Marzo de 2.011  -   v0.00.275.sql 

	Agregamos la columna AsientoTipoCierreAnualFlag
	a la tabla Asientos 
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
	DROP CONSTRAINT FK_Asientos_Monedas
GO
ALTER TABLE dbo.Asientos
	DROP CONSTRAINT FK_Asientos_Monedas1
GO
ALTER TABLE dbo.Monedas SET (LOCK_ESCALATION = TABLE)
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
CREATE TABLE dbo.Tmp_Asientos
	(
	NumeroAutomatico int NOT NULL,
	Numero smallint NOT NULL,
	Mes tinyint NOT NULL,
	Ano smallint NOT NULL,
	Tipo nvarchar(6) NOT NULL,
	Fecha datetime NOT NULL,
	Descripcion nvarchar(250) NULL,
	NumPartidas smallint NOT NULL,
	TotalDebe money NOT NULL,
	TotalHaber money NOT NULL,
	Moneda int NOT NULL,
	MonedaOriginal int NOT NULL,
	ConvertirFlag bit NULL,
	FactorDeCambio money NOT NULL,
	ProvieneDe nvarchar(25) NULL,
	Ingreso datetime NOT NULL,
	UltAct datetime NOT NULL,
	CopiableFlag bit NULL,
	AsientoTipoCierreAnualFlag bit NULL,
	MesFiscal smallint NOT NULL,
	AnoFiscal smallint NOT NULL,
	Usuario nvarchar(25) NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Asientos SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.Asientos)
	 EXEC('INSERT INTO dbo.Tmp_Asientos (NumeroAutomatico, Numero, Mes, Ano, Tipo, Fecha, Descripcion, NumPartidas, TotalDebe, TotalHaber, Moneda, MonedaOriginal, ConvertirFlag, FactorDeCambio, ProvieneDe, Ingreso, UltAct, CopiableFlag, MesFiscal, AnoFiscal, Usuario, Cia)
		SELECT NumeroAutomatico, Numero, Mes, Ano, Tipo, Fecha, Descripcion, NumPartidas, TotalDebe, TotalHaber, Moneda, MonedaOriginal, ConvertirFlag, FactorDeCambio, ProvieneDe, Ingreso, UltAct, CopiableFlag, MesFiscal, AnoFiscal, Usuario, Cia FROM dbo.Asientos WITH (HOLDLOCK TABLOCKX)')
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
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.dAsientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT






/****** Object:  View [dbo].[qFormaAsientosConsulta]    Script Date: 03/30/2011 17:34:29 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qFormaAsientosConsulta]'))
DROP VIEW [dbo].[qFormaAsientosConsulta]
GO


/****** Object:  View [dbo].[qFormaAsientosConsulta]    Script Date: 03/30/2011 17:34:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[qFormaAsientosConsulta]
AS
SELECT     dbo.Asientos.NumeroAutomatico, dbo.Asientos.Numero, dbo.Asientos.Mes, dbo.Asientos.MesFiscal, dbo.Asientos.AnoFiscal, dbo.Asientos.Ano, 
                      dbo.Asientos.Tipo, dbo.Asientos.Fecha, dbo.Asientos.Descripcion, dbo.Asientos.NumPartidas, dbo.Asientos.TotalDebe, dbo.Asientos.TotalHaber, 
                      dbo.Asientos.Ingreso, dbo.Asientos.UltAct, dbo.Asientos.Moneda, dbo.Asientos.MonedaOriginal, dbo.Monedas.Simbolo AS SimboloMonedaOriginal, 
                      dbo.Asientos.ConvertirFlag, dbo.Asientos.FactorDeCambio, dbo.Asientos.CopiableFlag, dbo.Asientos.Usuario, dbo.Asientos.Cia, 
                      dbo.Asientos.ProvieneDe, dbo.Asientos.AsientoTipoCierreAnualFlag
FROM         dbo.Asientos LEFT OUTER JOIN
                      dbo.Monedas ON dbo.Asientos.MonedaOriginal = dbo.Monedas.Moneda

GO

/****** Object:  View [dbo].[qFormaAsientos]    Script Date: 03/30/2011 17:34:22 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qFormaAsientos]'))
DROP VIEW [dbo].[qFormaAsientos]
GO

/****** Object:  View [dbo].[qFormaAsientos]    Script Date: 03/30/2011 17:34:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[qFormaAsientos]
AS
SELECT     dbo.Asientos.NumeroAutomatico, dbo.Asientos.Numero, dbo.Asientos.Mes, dbo.Asientos.MesFiscal, dbo.Asientos.AnoFiscal, dbo.Asientos.Ano, 
                      dbo.Asientos.Tipo, dbo.Asientos.Fecha, dbo.Asientos.Descripcion, dbo.Asientos.NumPartidas, dbo.Asientos.TotalDebe, dbo.Asientos.TotalHaber, 
                      dbo.Asientos.Ingreso, dbo.Asientos.UltAct, dbo.Asientos.Moneda, dbo.Asientos.MonedaOriginal, dbo.Monedas.Simbolo AS SimboloMonedaOriginal, 
                      dbo.Asientos.ConvertirFlag, dbo.Asientos.FactorDeCambio, dbo.Asientos.CopiableFlag, dbo.Asientos.Usuario, dbo.Asientos.Cia, 
                      dbo.Asientos.ProvieneDe, dbo.Asientos.AsientoTipoCierreAnualFlag
FROM         dbo.Asientos LEFT OUTER JOIN
                      dbo.Monedas ON dbo.Asientos.MonedaOriginal = dbo.Monedas.Moneda

GO



/****** Object:  View [dbo].[qListadoMayorGeneral]    Script Date: 03/31/2011 16:31:46 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qListadoMayorGeneral]'))
DROP VIEW [dbo].[qListadoMayorGeneral]
GO


/****** Object:  View [dbo].[qListadoMayorGeneral]    Script Date: 03/31/2011 16:31:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  View dbo.qListadoMayorGeneral    Script Date: 31/12/00 10:25:55 a.m. *****
***** Object:  View dbo.qListadoMayorGeneral    Script Date: 28/11/00 07:01:23 p.m. *****
***** Object:  View dbo.qListadoMayorGeneral    Script Date: 08/nov/00 9:01:18 ******/
CREATE VIEW [dbo].[qListadoMayorGeneral]
AS
SELECT     dbo.dAsientos.Moneda, dbo.Monedas.Descripcion AS NombreMoneda, dbo.dAsientos.MonedaOriginal, 
                      MonedasOriginal.Descripcion AS NombreMonedaOriginal, dbo.dAsientos.Numero, dbo.dAsientos.Mes, dbo.dAsientos.Ano, dbo.dAsientos.MesFiscal, 
                      dbo.dAsientos.AnoFiscal, dbo.dAsientos.Fecha, CONVERT(Char(4), dbo.dAsientos.Ano) + { fn REPLACE(STR(dbo.dAsientos.Mes, 2), ' ', '0') } AS AnoMes, 
                      dbo.dAsientos.Partida, dbo.dAsientos.Cuenta, dbo.dAsientos.Descripcion, dbo.dAsientos.Referencia, dbo.dAsientos.Debe, dbo.dAsientos.Haber, 
                      dbo.dAsientos.FactorDeCambio, dbo.dAsientos.CentroCosto, dbo.dAsientos.Cia, dbo.Asientos.AsientoTipoCierreAnualFlag
FROM         dbo.dAsientos INNER JOIN
                      dbo.Asientos ON dbo.dAsientos.NumeroAutomatico = dbo.Asientos.NumeroAutomatico LEFT OUTER JOIN
                      dbo.Monedas AS MonedasOriginal ON dbo.dAsientos.MonedaOriginal = MonedasOriginal.Moneda LEFT OUTER JOIN
                      dbo.Monedas ON dbo.dAsientos.Moneda = dbo.Monedas.Moneda

GO


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.275', GetDate()) 