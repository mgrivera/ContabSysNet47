/*    Miercoles 9 de Septiembre de 2.009  -   v0.00.257.sql 

	Agregamos el item FactorConversion a la tabla 
	tTempWebReport_PresupuestoConsultaMensual 

*/

Delete From tTempWebReport_PresupuestoConsultaMensual 

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
ALTER TABLE dbo.tTempWebReport_PresupuestoConsultaMensual
	DROP CONSTRAINT FK_tTempWebReport_PresupuestoConsultaMensual_Presupuesto_Codigos
GO
ALTER TABLE dbo.Presupuesto_Codigos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tTempWebReport_PresupuestoConsultaMensual
	(
	CiaContab int NOT NULL,
	Moneda int NOT NULL,
	AnoFiscal smallint NOT NULL,
	MesFiscal smallint NOT NULL,
	MesCalendario smallint NOT NULL,
	NombreMes nvarchar(20) NOT NULL,
	CodigoPresupuesto nvarchar(70) NOT NULL,
	FactorConversion smallmoney NOT NULL,
	MontoEstimado money NOT NULL,
	MontoEjecutado money NOT NULL,
	Variacion real NOT NULL,
	MontoEstimadoAcum money NOT NULL,
	MontoEjecutadoAcum money NOT NULL,
	VariacionAcum real NOT NULL,
	NombreUsuario nvarchar(256) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tTempWebReport_PresupuestoConsultaMensual SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.tTempWebReport_PresupuestoConsultaMensual)
	 EXEC('INSERT INTO dbo.Tmp_tTempWebReport_PresupuestoConsultaMensual (CiaContab, Moneda, AnoFiscal, MesFiscal, MesCalendario, NombreMes, CodigoPresupuesto, MontoEstimado, MontoEjecutado, Variacion, MontoEstimadoAcum, MontoEjecutadoAcum, VariacionAcum, NombreUsuario)
		SELECT CiaContab, Moneda, AnoFiscal, MesFiscal, MesCalendario, NombreMes, CodigoPresupuesto, MontoEstimado, MontoEjecutado, Variacion, MontoEstimadoAcum, MontoEjecutadoAcum, VariacionAcum, NombreUsuario FROM dbo.tTempWebReport_PresupuestoConsultaMensual WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.tTempWebReport_PresupuestoConsultaMensual
GO
EXECUTE sp_rename N'dbo.Tmp_tTempWebReport_PresupuestoConsultaMensual', N'tTempWebReport_PresupuestoConsultaMensual', 'OBJECT' 
GO
ALTER TABLE dbo.tTempWebReport_PresupuestoConsultaMensual ADD CONSTRAINT
	PK_tTempWebReport_PresupuestoConsultaMensual PRIMARY KEY CLUSTERED 
	(
	CiaContab,
	Moneda,
	AnoFiscal,
	MesCalendario,
	CodigoPresupuesto,
	NombreUsuario
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tTempWebReport_PresupuestoConsultaMensual ADD CONSTRAINT
	FK_tTempWebReport_PresupuestoConsultaMensual_Presupuesto_Codigos FOREIGN KEY
	(
	CodigoPresupuesto,
	CiaContab
	) REFERENCES dbo.Presupuesto_Codigos
	(
	Codigo,
	CiaContab
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.257', GetDate()) 