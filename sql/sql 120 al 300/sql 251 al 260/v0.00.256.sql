/*    Sabado 23 de Agosto de 2.009  -   v0.00.256.sql 

	Agregamos la tabla FactoresConversionPorMes

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
CREATE TABLE dbo.FactoresConversionAnoMes
	(
	Mes tinyint NOT NULL,
	Ano smallint NOT NULL,
	FactorConversion smallmoney NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.FactoresConversionAnoMes ADD CONSTRAINT
	PK_FactoresConversionAnoMes PRIMARY KEY CLUSTERED 
	(
	Mes,
	Ano
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.FactoresConversionAnoMes SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.256', GetDate()) 