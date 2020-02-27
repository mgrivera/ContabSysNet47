/*    Sábado 19 de Septiembre de 2.009  -   v0.00.258.sql 

	Agregamos la tabla FactoresConversionAnoMes_Aplicados

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
CREATE TABLE dbo.FactoresConversionAnoMes_Aplicados
	(
	MesCalendario tinyint NOT NULL,
	AnoCalendario smallint NOT NULL,
	NombreMes	nvarchar(20) NOT NULL,
	MesFiscal tinyint NOT NULL,
	AnoFiscal smallint NOT NULL,
	FactorConversion smallmoney NOT NULL,
	NombreUsuario nvarchar(256) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.FactoresConversionAnoMes_Aplicados ADD CONSTRAINT
	PK_FactoresConversionAnoMes_Aplicados PRIMARY KEY CLUSTERED 
	(
	MesCalendario,
	AnoCalendario,
	NombreUsuario
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.FactoresConversionAnoMes_Aplicados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.258', GetDate()) 