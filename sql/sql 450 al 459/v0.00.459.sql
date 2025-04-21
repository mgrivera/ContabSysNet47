/*    
	  Lunes, 26 de Agosto de 2.024  -   v0.00.459.sql 
	  
	  Modificamos un poco la tabla Usuarios, usada solo desde el programa ...Access 
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
	IsAdmin bit NULL,
	IsUser bit NULL
GO
ALTER TABLE dbo.Usuarios ADD CONSTRAINT
	DF_Usuarios_IsAdmin DEFAULT 0 FOR IsAdmin
GO
ALTER TABLE dbo.Usuarios ADD CONSTRAINT
	DF_Usuarios_IsUser DEFAULT 0 FOR IsUser
GO
ALTER TABLE dbo.Usuarios
	DROP COLUMN Administrador, SoloAsientosConNumeroNegativoFlag
GO
ALTER TABLE dbo.Usuarios SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

Update Usuarios Set isAdmin = 0 Where isAdmin is null 
Update Usuarios Set isUser = 0 Where isUser is null 

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
ALTER TABLE dbo.Usuarios Alter Column IsAdmin bit Not NULL
ALTER TABLE dbo.Usuarios Alter Column IsUser bit Not NULL
GO
ALTER TABLE dbo.Usuarios SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


/* Creamos el View para la consulta de asientos contables desde Access */
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[V_Tmp_AsientosContablesConsulta]
AS
SELECT			  dbo.Tmp_AsientosContablesReport.ProcesoId, 
				  dbo.Monedas.Descripcion AS MonNombre, dbo.Monedas.Simbolo AS MonSimbolo, Monedas_1.Descripcion AS MonOrigNombre, Monedas_1.Simbolo AS MonOrigSimbolo, dbo.Asientos.Numero as NumeroComprobante, dbo.Asientos.Tipo, dbo.Asientos.Fecha, 
                  dbo.Asientos.Descripcion AS DescripcionAsiento, dbo.Asientos.FactorDeCambio AS Tasa, dbo.Asientos.ProvieneDe AS Origen, dbo.dAsientos.Partida, dbo.dAsientos.Descripcion AS DescripcionPartida, dbo.dAsientos.Referencia, 
                  dbo.dAsientos.Debe, dbo.dAsientos.Haber, dbo.Companias.Nombre AS CiaNombre, dbo.CuentasContables.Cuenta AS CuentaContable, dbo.CuentasContables.Descripcion AS CuentaContableNombre
FROM			  dbo.Tmp_AsientosContablesReport Inner Join dbo.Asientos On Tmp_AsientosContablesReport.AsientoId = dbo.Asientos.NumeroAutomatico 
				  LEFT OUTER JOIN
                  dbo.Monedas ON dbo.Asientos.Moneda = dbo.Monedas.Moneda LEFT OUTER JOIN
                  dbo.Monedas AS Monedas_1 ON dbo.Asientos.MonedaOriginal = Monedas_1.Moneda LEFT OUTER JOIN
                  dbo.Companias ON dbo.Asientos.Cia = dbo.Companias.Numero LEFT OUTER JOIN
                  dbo.dAsientos ON dbo.Asientos.NumeroAutomatico = dbo.dAsientos.NumeroAutomatico LEFT OUTER JOIN
                  dbo.CuentasContables ON dbo.dAsientos.CuentaContableID = dbo.CuentasContables.ID

GO


Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.459', GetDate()) 