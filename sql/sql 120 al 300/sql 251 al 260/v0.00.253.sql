/*    Lunes, 27 de Julio de 2.009  -   v0.00.253.sql 

	Agregamos la tabla tTempWebReport... para la consulta de montos estimados 
	en el presupuesto 

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
CREATE TABLE dbo.tTempWebReport_PresupuestoConsultaMontosEstimados
	(
	Moneda int NOT NULL,
	CiaContab int NOT NULL,
	AnoFiscal smallint NOT NULL,
	CodigoPresupuesto nvarchar(70) NOT NULL,
	Mes01_Est money NULL,
	Mes02_Est money NULL,
	Mes03_Est money NULL,
	Mes04_Est money NULL,
	Mes05_Est money NULL,
	Mes06_Est money NULL,
	Mes07_Est money NULL,
	Mes08_Est money NULL,
	Mes09_Est money NULL,
	Mes10_Est money NULL,
	Mes11_Est money NULL,
	Mes12_Est money NULL,
	NombreUsuario nvarchar(256) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.tTempWebReport_PresupuestoConsultaMontosEstimados ADD CONSTRAINT
	PK_tTempWebReport_PresupuestoConsultaMontosEstimados PRIMARY KEY CLUSTERED 
	(
	Moneda,
	CiaContab,
	AnoFiscal,
	CodigoPresupuesto,
	NombreUsuario
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tTempWebReport_PresupuestoConsultaMontosEstimados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.253', GetDate()) 