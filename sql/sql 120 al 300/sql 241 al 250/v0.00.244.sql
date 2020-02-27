/*    Lunes, 30 de Marzo de 2.009  -   v0.00.244.sql 

	Agregamos la tabla TiposAlicuotaIva

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
CREATE TABLE dbo.TiposAlicuotaIva
	(
	Fecha datetime NOT NULL,
	Reducida decimal(5, 2) NULL,
	General decimal(5, 2) NULL,
	Adicional decimal(5, 2) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.TiposAlicuotaIva ADD CONSTRAINT
	PK_TiposAlicuotaIva PRIMARY KEY CLUSTERED 
	(
	Fecha
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.TiposAlicuotaIva SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.244', GetDate()) 