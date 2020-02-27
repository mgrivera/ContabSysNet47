/*    Sábado, 9 de Febrero de 2.013  -   v0.00.331.sql 

	Agregamos la nueva tabla OrdenesPago_Soportes
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
CREATE TABLE dbo.OrdenesPago_DescripcionSoportes
	(
	ID int NOT NULL IDENTITY (1, 1),
	Descripcion nvarchar(75) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.OrdenesPago_DescripcionSoportes ADD CONSTRAINT
	PK_OrdenesPago_DescripcionSoportes PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.OrdenesPago_DescripcionSoportes SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.331', GetDate()) 