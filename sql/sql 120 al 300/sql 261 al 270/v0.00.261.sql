/*    Martes, 8 de Diciembre de 2.009  -   v0.00.261.sql 

	Agregamos los items: Codigo1erNivel, 2do, 3er, ... 
	a la tabla tTempWebReport_PresupuestoConsultaAnual 

*/


Delete from tTempWebReport_PresupuestoConsultaAnual


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
CREATE TABLE dbo.Tmp_tTempWebReport_PresupuestoConsultaAnual
	(
	CiaContab int NOT NULL,
	Moneda int NOT NULL,
	AnoFiscal smallint NOT NULL,
	CodigoPresupuesto nvarchar(70) NOT NULL,
	Codigo1erNivel nvarchar(70) NOT NULL,
	Codigo2doNivel nvarchar(70) NULL,
	Codigo3erNivel nvarchar(70) NULL,
	Codigo4toNivel nvarchar(70) NULL,
	Codigo5toNivel nvarchar(70) NULL,
	Codigo6toNivel nvarchar(70) NULL,
	Mes01_Eje money NULL,
	Mes01_Eje_Porc real NULL,
	Mes02_Eje money NULL,
	Mes02_Eje_Porc real NULL,
	Mes03_Eje money NULL,
	Mes03_Eje_Porc real NULL,
	Mes04_Eje money NULL,
	Mes04_Eje_Porc real NULL,
	Mes05_Eje money NULL,
	Mes05_Eje_Porc real NULL,
	Mes06_Eje money NULL,
	Mes06_Eje_Porc real NULL,
	Mes07_Eje money NULL,
	Mes07_Eje_Porc real NULL,
	Mes08_Eje money NULL,
	Mes08_Eje_Porc real NULL,
	Mes09_Eje money NULL,
	Mes09_Eje_Porc real NULL,
	Mes10_Eje money NULL,
	Mes10_Eje_Porc real NULL,
	Mes11_Eje money NULL,
	Mes11_Eje_Porc real NULL,
	Mes12_Eje money NULL,
	Mes12_Eje_Porc real NULL,
	TotalEjecutado money NULL,
	TotalPresupuestado money NULL,
	Variacion real NULL,
	NombreUsuario nvarchar(256) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tTempWebReport_PresupuestoConsultaAnual SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.tTempWebReport_PresupuestoConsultaAnual)
	 EXEC('INSERT INTO dbo.Tmp_tTempWebReport_PresupuestoConsultaAnual (CiaContab, Moneda, AnoFiscal, CodigoPresupuesto, Mes01_Eje, Mes01_Eje_Porc, Mes02_Eje, Mes02_Eje_Porc, Mes03_Eje, Mes03_Eje_Porc, Mes04_Eje, Mes04_Eje_Porc, Mes05_Eje, Mes05_Eje_Porc, Mes06_Eje, Mes06_Eje_Porc, Mes07_Eje, Mes07_Eje_Porc, Mes08_Eje, Mes08_Eje_Porc, Mes09_Eje, Mes09_Eje_Porc, Mes10_Eje, Mes10_Eje_Porc, Mes11_Eje, Mes11_Eje_Porc, Mes12_Eje, Mes12_Eje_Porc, TotalEjecutado, TotalPresupuestado, Variacion, NombreUsuario)
		SELECT CiaContab, Moneda, AnoFiscal, CodigoPresupuesto, Mes01_Eje, Mes01_Eje_Porc, Mes02_Eje, Mes02_Eje_Porc, Mes03_Eje, Mes03_Eje_Porc, Mes04_Eje, Mes04_Eje_Porc, Mes05_Eje, Mes05_Eje_Porc, Mes06_Eje, Mes06_Eje_Porc, Mes07_Eje, Mes07_Eje_Porc, Mes08_Eje, Mes08_Eje_Porc, Mes09_Eje, Mes09_Eje_Porc, Mes10_Eje, Mes10_Eje_Porc, Mes11_Eje, Mes11_Eje_Porc, Mes12_Eje, Mes12_Eje_Porc, TotalEjecutado, TotalPresupuestado, Variacion, NombreUsuario FROM dbo.tTempWebReport_PresupuestoConsultaAnual WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.tTempWebReport_PresupuestoConsultaAnual
GO
EXECUTE sp_rename N'dbo.Tmp_tTempWebReport_PresupuestoConsultaAnual', N'tTempWebReport_PresupuestoConsultaAnual', 'OBJECT' 
GO
ALTER TABLE dbo.tTempWebReport_PresupuestoConsultaAnual ADD CONSTRAINT
	PK_tTempWebReport_PresupuestoConsultaAnual PRIMARY KEY CLUSTERED 
	(
	CiaContab,
	Moneda,
	AnoFiscal,
	CodigoPresupuesto,
	NombreUsuario
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.261', GetDate()) 