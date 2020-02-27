/*    Lunes, 18 de Julio de 2.005   -   v0.00.179.sql 

	Agregamos la tabla NivelesAgrupacionContableMontosEstimados

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
COMMIT
BEGIN TRANSACTION
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.NivelesAgrupacionContableMontosEstimados
	(
	NivelAgrupacion nvarchar(20) NOT NULL,
	Moneda int NOT NULL,
	Ano smallint NOT NULL,
	Mes01Est money NULL,
	Mes02Est money NULL,
	Mes03Est money NULL,
	Mes04Est money NULL,
	Mes05Est money NULL,
	Mes06Est money NULL,
	Mes07Est money NULL,
	Mes08Est money NULL,
	Mes09Est money NULL,
	Mes10Est money NULL,
	Mes11Est money NULL,
	Mes12Est money NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.NivelesAgrupacionContableMontosEstimados ADD CONSTRAINT
	PK_NivelesAgrupacionContableMontosEstimados PRIMARY KEY CLUSTERED 
	(
	NivelAgrupacion,
	Moneda,
	Ano,
	Cia
	) ON [PRIMARY]

GO
ALTER TABLE dbo.NivelesAgrupacionContableMontosEstimados ADD CONSTRAINT
	FK_NivelesAgrupacionContableMontosEstimados_NivelesAgrupacionContable FOREIGN KEY
	(
	NivelAgrupacion
	) REFERENCES dbo.NivelesAgrupacionContable
	(
	NivelAgrupacion
	) ON UPDATE CASCADE
	 ON DELETE CASCADE
	
GO
ALTER TABLE dbo.NivelesAgrupacionContableMontosEstimados ADD CONSTRAINT
	FK_NivelesAgrupacionContableMontosEstimados_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	)
GO
COMMIT



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
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.NivelesAgrupacionContableMontosEstimados ADD CONSTRAINT
	FK_NivelesAgrupacionContableMontosEstimados_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	)
GO
COMMIT













if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaAsociacionNivelesAgrupacion]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaAsociacionNivelesAgrupacion]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaNivelesAgrupacionContableMontosEstimados]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaNivelesAgrupacionContableMontosEstimados]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoFormaAsociacionNivelesAgrupacion]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoFormaAsociacionNivelesAgrupacion]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoFormaNivelesAgrupacionContableMontosEstimados]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoFormaNivelesAgrupacionContableMontosEstimados]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaAsociacionNivelesAgrupacion
AS
SELECT     Cuenta, Descripcion, CuentaEditada, NivelAgrupacion, GrupoNivelAgrupacion, TotDet, Cia
FROM         dbo.CuentasContables
WHERE     (TotDet = N'D')

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaNivelesAgrupacionContableMontosEstimados
AS
SELECT     NivelAgrupacion, Moneda, Ano, Mes01Est, Mes02Est, Mes03Est, Mes04Est, Mes05Est, Mes06Est, Mes07Est, Mes08Est, Mes09Est, Mes10Est, 
                      Mes11Est, Mes12Est, Cia
FROM         dbo.NivelesAgrupacionContableMontosEstimados

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoFormaAsociacionNivelesAgrupacion
AS
SELECT     dbo.CuentasContables.GrupoNivelAgrupacion, dbo.tGruposContables.Descripcion AS NombreGrupo, dbo.CuentasContables.NivelAgrupacion, 
                      dbo.NivelesAgrupacionContable.Descripcion AS NombreNivelAgrupacion, dbo.CuentasContables.Cuenta, 
                      dbo.CuentasContables.Descripcion AS NombreCuentaContable, dbo.CuentasContables.CuentaEditada, dbo.CuentasContables.Cia
FROM         dbo.CuentasContables INNER JOIN
                      dbo.NivelesAgrupacionContable ON dbo.CuentasContables.NivelAgrupacion = dbo.NivelesAgrupacionContable.NivelAgrupacion INNER JOIN
                      dbo.tGruposContables ON dbo.CuentasContables.GrupoNivelAgrupacion = dbo.tGruposContables.Grupo

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoFormaNivelesAgrupacionContableMontosEstimados
AS
SELECT     dbo.NivelesAgrupacionContableMontosEstimados.NivelAgrupacion, dbo.NivelesAgrupacionContable.Descripcion AS NombreNivelAgrupacion, 
                      dbo.NivelesAgrupacionContableMontosEstimados.Moneda, dbo.Monedas.Descripcion AS NombreMoneda, 
                      dbo.NivelesAgrupacionContableMontosEstimados.Ano, dbo.NivelesAgrupacionContableMontosEstimados.Mes01Est, 
                      dbo.NivelesAgrupacionContableMontosEstimados.Mes02Est, dbo.NivelesAgrupacionContableMontosEstimados.Mes03Est, 
                      dbo.NivelesAgrupacionContableMontosEstimados.Mes04Est, dbo.NivelesAgrupacionContableMontosEstimados.Mes05Est, 
                      dbo.NivelesAgrupacionContableMontosEstimados.Mes06Est, dbo.NivelesAgrupacionContableMontosEstimados.Mes07Est, 
                      dbo.NivelesAgrupacionContableMontosEstimados.Mes08Est, dbo.NivelesAgrupacionContableMontosEstimados.Mes09Est, 
                      dbo.NivelesAgrupacionContableMontosEstimados.Mes10Est, dbo.NivelesAgrupacionContableMontosEstimados.Mes11Est, 
                      dbo.NivelesAgrupacionContableMontosEstimados.Mes12Est, dbo.NivelesAgrupacionContableMontosEstimados.Cia
FROM         dbo.NivelesAgrupacionContable INNER JOIN
                      dbo.NivelesAgrupacionContableMontosEstimados ON 
                      dbo.NivelesAgrupacionContable.NivelAgrupacion = dbo.NivelesAgrupacionContableMontosEstimados.NivelAgrupacion INNER JOIN
                      dbo.Monedas ON dbo.NivelesAgrupacionContableMontosEstimados.Moneda = dbo.Monedas.Moneda

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO







--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.179', GetDate()) 