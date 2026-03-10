/*    
	  Miércoles, 23 de Julio de 2.025  -   v0.00.468.sql 
	  
	  Agregamos las tablas: TasasCambio y UnidadTributaria 
	  (Nota: revisar si ya existen estas tablas. En algunos 
	   casos, las agregamos en forma 'manual') 

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
CREATE TABLE dbo.TasasCambio
	(
	Id int NOT NULL IDENTITY (1, 1),
	Fecha datetime NOT NULL,
	Monto money NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.TasasCambio ADD CONSTRAINT
	PK_TasasCambio PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.TasasCambio SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.UnidadTributaria
	(
	Id int NOT NULL IDENTITY (1, 1),
	Fecha datetime NOT NULL,
	Monto money NOT NULL,
	Factor decimal(12, 6) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.UnidadTributaria ADD CONSTRAINT
	PK_UnidadTributaria PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.UnidadTributaria SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.468', GetDate()) 