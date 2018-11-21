/*    
	  Domingo, 15/Mayo/2.018   -   v0.00.405.sql 
	  
	  Agregamos algún texto a asientos cuyas descripciones están vacías ... 
	  La idea es que la descripción en asientos siempre será requerida desde contabm 
	  
	  También agregamos un par de índices a la tabla Asientos. 
*/

Update Asientos Set Descripcion = '...' Where Descripcion Is Null Or Descripcion = '' 

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
CREATE NONCLUSTERED INDEX IX_Asientos_1 ON dbo.Asientos
	(
	Fecha,
	Cia
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_Asientos_2 ON dbo.Asientos
	(
	Numero,
	Fecha,
	Cia
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.Asientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.405', GetDate()) 
