/*    Lunes, 24 de Marzo de 2.008   -   v0.00.213.sql 

	Agregamos un item a la tabla ParametrosContab para registrar el directorio en el cual se 
	mantienen los asientos generados por otras aplicaciones 

*/ 



BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.Tmp_ParametrosContab
	(
	Activo1 nvarchar(10) NULL,
	Activo2 nvarchar(10) NULL,
	Activo3 nvarchar(10) NULL,
	Activo4 nvarchar(10) NULL,
	Activo5 nvarchar(10) NULL,
	Activo6 nvarchar(10) NULL,
	Pasivo1 nvarchar(10) NULL,
	Pasivo2 nvarchar(10) NULL,
	Pasivo3 nvarchar(10) NULL,
	Pasivo4 nvarchar(10) NULL,
	Pasivo5 nvarchar(10) NULL,
	Pasivo6 nvarchar(10) NULL,
	Capital1 nvarchar(10) NULL,
	Capital2 nvarchar(10) NULL,
	Capital3 nvarchar(10) NULL,
	Capital4 nvarchar(10) NULL,
	Capital5 nvarchar(10) NULL,
	Capital6 nvarchar(10) NULL,
	Ingresos1 nvarchar(10) NULL,
	Ingresos2 nvarchar(10) NULL,
	Ingresos3 nvarchar(10) NULL,
	Ingresos4 nvarchar(10) NULL,
	Ingresos5 nvarchar(10) NULL,
	Ingresos6 nvarchar(10) NULL,
	Egresos1 nvarchar(10) NULL,
	Egresos2 nvarchar(10) NULL,
	Egresos3 nvarchar(10) NULL,
	Egresos4 nvarchar(10) NULL,
	Egresos5 nvarchar(10) NULL,
	Egresos6 nvarchar(10) NULL,
	CuentaGyP nvarchar(25) NULL,
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
	DirectorioAsientosOtrasAplicaciones nvarchar(250) NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.ParametrosContab)
	 EXEC('INSERT INTO dbo.Tmp_ParametrosContab (Activo1, Activo2, Activo3, Activo4, Activo5, Activo6, Pasivo1, Pasivo2, Pasivo3, Pasivo4, Pasivo5, Pasivo6, Capital1, Capital2, Capital3, Capital4, Capital5, Capital6, Ingresos1, Ingresos2, Ingresos3, Ingresos4, Ingresos5, Ingresos6, Egresos1, Egresos2, Egresos3, Egresos4, Egresos5, Egresos6, CuentaGyP, MultiMoneda, Moneda1, Moneda2, Moneda3, Moneda4, Moneda5, CambiarFactorAlAgregarFlag, CambiarFactorAlModFlag, NumeracionAsientosSeparadaFlag, OrganizarPartidasDelAsiento, CargarAsientosConNumeroNegativoFlag, Cia)
		SELECT Activo1, Activo2, Activo3, Activo4, Activo5, Activo6, Pasivo1, Pasivo2, Pasivo3, Pasivo4, Pasivo5, Pasivo6, Capital1, Capital2, Capital3, Capital4, Capital5, Capital6, Ingresos1, Ingresos2, Ingresos3, Ingresos4, Ingresos5, Ingresos6, Egresos1, Egresos2, Egresos3, Egresos4, Egresos5, Egresos6, CuentaGyP, MultiMoneda, Moneda1, Moneda2, Moneda3, Moneda4, Moneda5, CambiarFactorAlAgregarFlag, CambiarFactorAlModFlag, NumeracionAsientosSeparadaFlag, OrganizarPartidasDelAsiento, CargarAsientosConNumeroNegativoFlag, Cia FROM dbo.ParametrosContab TABLOCKX')
GO
DROP TABLE dbo.ParametrosContab
GO
EXECUTE sp_rename N'dbo.Tmp_ParametrosContab', N'ParametrosContab', 'OBJECT'
GO
ALTER TABLE dbo.ParametrosContab ADD CONSTRAINT
	PK_ParametrosContab PRIMARY KEY NONCLUSTERED 
	(
	Cia
	) ON [PRIMARY]

GO
COMMIT





if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaParametrosContab]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaParametrosContab]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qFormaParametrosContab    Script Date: 28/11/00 07:01:16 p.m. *****
***** Object:  View dbo.qFormaParametrosContab    Script Date: 08/nov/00 9:01:17 ******/
CREATE VIEW dbo.qFormaParametrosContab
AS
SELECT     Activo1, Activo2, Activo3, Activo4, Activo5, Activo6, Pasivo1, Pasivo2, Pasivo3, Pasivo4, Pasivo5, Pasivo6, Capital1, Capital2, Capital3, Capital4, 
                      Capital5, Capital6, Ingresos1, Ingresos2, Ingresos3, Ingresos4, Ingresos5, Ingresos6, Egresos1, Egresos2, Egresos3, Egresos4, Egresos5, Egresos6, 
                      CuentaGyP, MultiMoneda, Moneda1, Moneda2, Moneda3, Moneda4, Moneda5, CambiarFactorAlAgregarFlag, CambiarFactorAlModFlag, 
                      NumeracionAsientosSeparadaFlag, OrganizarPartidasDelAsiento, CargarAsientosConNumeroNegativoFlag, DirectorioAsientosOtrasAplicaciones, 
                      Cia
FROM         dbo.ParametrosContab

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO






--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.213', GetDate()) 