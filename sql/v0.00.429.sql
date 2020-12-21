/*    
	  Domingo, 20 de Diciembre de 2.021  -   v0.00.429.sql 
	  
	  Tabla (temp) para la consulta: cuentas y sus movimientos: 
	  agregamos la columna: centroCostoAbreviatura 
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
ALTER TABLE dbo.Contab_ConsultaCuentasYMovimientos_Movimientos ADD
	CentroCostoAbreviatura nvarchar(3) NULL
GO
ALTER TABLE dbo.Contab_ConsultaCuentasYMovimientos_Movimientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.429', GetDate()) 