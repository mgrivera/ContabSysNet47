/*    Jueves, 5 de Febrero de 2.009  -   v0.00.238.sql 

	Agregamos el item CuentaPuenteCajaChica a la tabla ParametrosContab 

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
CREATE TABLE dbo.Tmp_ParametrosContab
	(
	Activo1 nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Activo2 nvarchar(10)  NULL,
	Activo3 nvarchar(10)  NULL,
	Activo4 nvarchar(10)  NULL,
	Activo5 nvarchar(10)  NULL,
	Activo6 nvarchar(10)  NULL,
	Pasivo1 nvarchar(10)  NULL,
	Pasivo2 nvarchar(10)  NULL,
	Pasivo3 nvarchar(10)  NULL,
	Pasivo4 nvarchar(10)  NULL,
	Pasivo5 nvarchar(10)  NULL,
	Pasivo6 nvarchar(10)  NULL,
	Capital1 nvarchar(10)  NULL,
	Capital2 nvarchar(10)  NULL,
	Capital3 nvarchar(10)  NULL,
	Capital4 nvarchar(10)  NULL,
	Capital5 nvarchar(10)  NULL,
	Capital6 nvarchar(10)  NULL,
	Ingresos1 nvarchar(10)  NULL,
	Ingresos2 nvarchar(10)  NULL,
	Ingresos3 nvarchar(10)  NULL,
	Ingresos4 nvarchar(10)  NULL,
	Ingresos5 nvarchar(10)  NULL,
	Ingresos6 nvarchar(10)  NULL,
	Egresos1 nvarchar(10)  NULL,
	Egresos2 nvarchar(10)  NULL,
	Egresos3 nvarchar(10)  NULL,
	Egresos4 nvarchar(10)  NULL,
	Egresos5 nvarchar(10)  NULL,
	Egresos6 nvarchar(10)  NULL,
	CuentaGyP nvarchar(25)  NULL,
	MultiMoneda bit NULL,
	Moneda1 int NULL,
	Moneda2 int NULL,
	Moneda3 int NULL,
	Moneda4 int NULL,
	Moneda5 int NULL,
	CambiarFactorAlAgregarFlag bit NULL,
	CambiarFactorAlModFlag bit NULL,
	NumeracionAsientosSeparadaFlag bit NULL,
	OrganizarPartidasDelAsiento bit NULL,
	CargarAsientosConNumeroNegativoFlag bit NULL,
	DirectorioAsientosOtrasAplicaciones nvarchar(250)  NULL,
	CuentaPuenteCajaChica nvarchar(25) NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_ParametrosContab SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.ParametrosContab)
	 EXEC('INSERT INTO dbo.Tmp_ParametrosContab (Activo1, Activo2, Activo3, Activo4, Activo5, Activo6, Pasivo1, Pasivo2, Pasivo3, Pasivo4, Pasivo5, Pasivo6, Capital1, Capital2, Capital3, Capital4, Capital5, Capital6, Ingresos1, Ingresos2, Ingresos3, Ingresos4, Ingresos5, Ingresos6, Egresos1, Egresos2, Egresos3, Egresos4, Egresos5, Egresos6, CuentaGyP, MultiMoneda, Moneda1, Moneda2, Moneda3, Moneda4, Moneda5, CambiarFactorAlAgregarFlag, CambiarFactorAlModFlag, NumeracionAsientosSeparadaFlag, OrganizarPartidasDelAsiento, CargarAsientosConNumeroNegativoFlag, DirectorioAsientosOtrasAplicaciones, Cia)
		SELECT Activo1, Activo2, Activo3, Activo4, Activo5, Activo6, Pasivo1, Pasivo2, Pasivo3, Pasivo4, Pasivo5, Pasivo6, Capital1, Capital2, Capital3, Capital4, Capital5, Capital6, Ingresos1, Ingresos2, Ingresos3, Ingresos4, Ingresos5, Ingresos6, Egresos1, Egresos2, Egresos3, Egresos4, Egresos5, Egresos6, CuentaGyP, MultiMoneda, Moneda1, Moneda2, Moneda3, Moneda4, Moneda5, CambiarFactorAlAgregarFlag, CambiarFactorAlModFlag, NumeracionAsientosSeparadaFlag, OrganizarPartidasDelAsiento, CargarAsientosConNumeroNegativoFlag, DirectorioAsientosOtrasAplicaciones, Cia FROM dbo.ParametrosContab WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.ParametrosContab
GO
EXECUTE sp_rename N'dbo.Tmp_ParametrosContab', N'ParametrosContab', 'OBJECT' 
GO
ALTER TABLE dbo.ParametrosContab ADD CONSTRAINT
	PK_ParametrosContab PRIMARY KEY NONCLUSTERED 
	(
	Cia
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT

DROP VIEW qFormaParametrosContab


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.238', GetDate()) 