/*    
	  Viernes, 20/Abril/2.018   -   v0.00.404.sql 
	  
	  Agregamos algunas columnas a la tabla Categorías de retención, para permitir el cálculo de la 
	  retención de Islr. 
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
ALTER TABLE dbo.CategoriasRetencion ADD
	TipoPersona nvarchar(6) NULL,
	FechaAplicacion date NULL,
	CodigoIslr nvarchar(6) NULL,
	PorcentajeRetencion decimal(5, 2) NULL
GO
ALTER TABLE dbo.CategoriasRetencion SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.404', GetDate()) 
