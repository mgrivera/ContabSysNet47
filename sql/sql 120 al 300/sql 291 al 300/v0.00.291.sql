/*    Jueves, 10 de Novimiembre de 2.011  -   v0.00.291.sql 

	Modificamos la tabla ParametrosContab para corregir sus cuentas contables 
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
ALTER TABLE dbo.ParametrosContab
	DROP CONSTRAINT FK_ParametrosContab_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_ParametrosContab
	(
	Activo1 int NULL,
	Activo2 int NULL,
	Activo3 int NULL,
	Activo4 int NULL,
	Activo5 int NULL,
	Activo6 int NULL,
	Pasivo1 int NULL,
	Pasivo2 int NULL,
	Pasivo3 int NULL,
	Pasivo4 int NULL,
	Pasivo5 int NULL,
	Pasivo6 int NULL,
	Capital1 int NULL,
	Capital2 int NULL,
	Capital3 int NULL,
	Capital4 int NULL,
	Capital5 int NULL,
	Capital6 int NULL,
	Ingresos1 int NULL,
	Ingresos2 int NULL,
	Ingresos3 int NULL,
	Ingresos4 int NULL,
	Ingresos5 int NULL,
	Ingresos6 int NULL,
	Egresos1 int NULL,
	Egresos2 int NULL,
	Egresos3 int NULL,
	Egresos4 int NULL,
	Egresos5 int NULL,
	Egresos6 int NULL,
	CuentaGyP int NULL,
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
	CuentaPuenteCajaChica int NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_ParametrosContab SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.ParametrosContab)
	 EXEC('INSERT INTO dbo.Tmp_ParametrosContab (Activo1, Activo2, Activo3, Activo4, Activo5, Activo6, Pasivo1, Pasivo2, Pasivo3, Pasivo4, Pasivo5, Pasivo6, Capital1, Capital2, Capital3, Capital4, Capital5, Capital6, Ingresos1, Ingresos2, Ingresos3, Ingresos4, Ingresos5, Ingresos6, Egresos1, Egresos2, Egresos3, Egresos4, Egresos5, Egresos6, CuentaGyP, MultiMoneda, Moneda1, Moneda2, Moneda3, Moneda4, Moneda5, CambiarFactorAlAgregarFlag, CambiarFactorAlModFlag, NumeracionAsientosSeparadaFlag, OrganizarPartidasDelAsiento, CargarAsientosConNumeroNegativoFlag, DirectorioAsientosOtrasAplicaciones, CuentaPuenteCajaChica, Cia)
		SELECT CONVERT(int, Activo1), CONVERT(int, Activo2), CONVERT(int, Activo3), CONVERT(int, Activo4), CONVERT(int, Activo5), CONVERT(int, Activo6), CONVERT(int, Pasivo1), CONVERT(int, Pasivo2), CONVERT(int, Pasivo3), CONVERT(int, Pasivo4), CONVERT(int, Pasivo5), CONVERT(int, Pasivo6), CONVERT(int, Capital1), CONVERT(int, Capital2), CONVERT(int, Capital3), CONVERT(int, Capital4), CONVERT(int, Capital5), CONVERT(int, Capital6), CONVERT(int, Ingresos1), CONVERT(int, Ingresos2), CONVERT(int, Ingresos3), CONVERT(int, Ingresos4), CONVERT(int, Ingresos5), CONVERT(int, Ingresos6), CONVERT(int, Egresos1), CONVERT(int, Egresos2), CONVERT(int, Egresos3), CONVERT(int, Egresos4), CONVERT(int, Egresos5), CONVERT(int, Egresos6), CONVERT(int, CuentaGyP), MultiMoneda, Moneda1, Moneda2, Moneda3, Moneda4, Moneda5, CambiarFactorAlAgregarFlag, CambiarFactorAlModFlag, NumeracionAsientosSeparadaFlag, OrganizarPartidasDelAsiento, CargarAsientosConNumeroNegativoFlag, DirectorioAsientosOtrasAplicaciones, CONVERT(int, CuentaPuenteCajaChica), Cia FROM dbo.ParametrosContab WITH (HOLDLOCK TABLOCKX)')
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
ALTER TABLE dbo.ParametrosContab ADD CONSTRAINT
	FK_ParametrosContab_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT



/****** Object:  Table [dbo].[tTemp_AsientosContables_Partidas]    Script Date: 11/11/2011 10:17:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tTemp_AsientosContables_Partidas]') AND type in (N'U'))
DROP TABLE [dbo].[tTemp_AsientosContables_Partidas]
GO

/****** Object:  Table [dbo].[tTemp_AsientosContables_Partidas]    Script Date: 11/11/2011 10:17:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tTemp_AsientosContables_Partidas](
	[Partida] [smallint] NOT NULL,
	[CuentaContableID] [int] NOT NULL,
	[Descripcion] [nvarchar](50) NOT NULL,
	[Referencia] [nvarchar](20) NULL,
	[Debe] [money] NOT NULL,
	[Haber] [money] NOT NULL,
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_tTemp_AsientosContables_Partidas] PRIMARY KEY CLUSTERED 
(
	[Partida] ASC,
	[NombreUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion
Insert Into tVersion(VersionActual, Fecha) Values('v0.00.291', GetDate()) 