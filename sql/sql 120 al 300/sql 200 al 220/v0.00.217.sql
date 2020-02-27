/*    Viernes, 6 de Agosto de 2.008   -   v0.00.217.sql 

	Agregamos la tabla PeriodosVencimiento 

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
CREATE TABLE dbo.PeriodosVencimiento
	(
	CantidadDias int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PeriodosVencimiento ADD CONSTRAINT
	PK_PeriodosVencimiento PRIMARY KEY CLUSTERED 
	(
	CantidadDias
	) ON [PRIMARY]

GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.217', GetDate()) 