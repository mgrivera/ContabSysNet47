/*    Viernes, 24 de Diciembre de 2.010  -   v0.00.273.sql 

	Agregamos la columna SoloAsientosConNumeroNegativoFlag
	a la tabla Usuarios 
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
ALTER TABLE dbo.Usuarios ADD
	SoloAsientosConNumeroNegativoFlag bit NULL
GO
ALTER TABLE dbo.Usuarios SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


Drop View qFormaUsuarios 


/* Agregamos la columna Usuario al view qListadoAsientos */


/****** Object:  View [dbo].[qListadoAsientos]    Script Date: 12/28/2010 08:10:25 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qListadoAsientos]'))
DROP VIEW [dbo].[qListadoAsientos]
GO

/****** Object:  View [dbo].[qListadoAsientos]    Script Date: 12/28/2010 08:10:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[qListadoAsientos]
AS
SELECT     dbo.dAsientos.Partida, dbo.dAsientos.Cuenta, dbo.dAsientos.Descripcion AS DescripcionPartida, dbo.dAsientos.Referencia, dbo.dAsientos.Debe, 
                      dbo.dAsientos.Haber, dbo.dAsientos.NumeroAutomatico, dbo.dAsientos.Numero, dbo.dAsientos.Mes, dbo.dAsientos.Ano, dbo.dAsientos.Fecha, 
                      dbo.dAsientos.Moneda, dbo.dAsientos.MonedaOriginal, dbo.dAsientos.ConvertirFlag, dbo.dAsientos.FactorDeCambio, dbo.dAsientos.MesFiscal, 
                      dbo.dAsientos.AnoFiscal, dbo.dAsientos.Cia, dbo.Asientos.Tipo, dbo.Asientos.TotalDebe, dbo.Asientos.TotalHaber, dbo.Asientos.Descripcion, 
                      dbo.Asientos.Ingreso, dbo.Asientos.UltAct, dbo.Asientos.CopiableFlag, dbo.Asientos.ProvieneDe, dbo.dAsientos.CentroCosto, 
                      dbo.Asientos.Usuario
FROM         dbo.dAsientos INNER JOIN
                      dbo.Asientos ON dbo.dAsientos.NumeroAutomatico = dbo.Asientos.NumeroAutomatico


GO


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.273', GetDate()) 