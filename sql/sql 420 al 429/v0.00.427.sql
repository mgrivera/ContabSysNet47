/*    
	  Viernes, 18 de Septiembre de 2.020  -   v0.00.427.sql 
	  
	  Cambiamos el tipo de la fecha en TiposAlicuotaIva, desde DateTime a Date 
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
CREATE TABLE dbo.Tmp_TiposAlicuotaIva
	(
	Fecha date NOT NULL,
	Reducida decimal(5, 2) NULL,
	General decimal(5, 2) NULL,
	Adicional decimal(5, 2) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_TiposAlicuotaIva SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.TiposAlicuotaIva)
	 EXEC('INSERT INTO dbo.Tmp_TiposAlicuotaIva (Fecha, Reducida, General, Adicional)
		SELECT CONVERT(date, Fecha), Reducida, General, Adicional FROM dbo.TiposAlicuotaIva WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.TiposAlicuotaIva
GO
EXECUTE sp_rename N'dbo.Tmp_TiposAlicuotaIva', N'TiposAlicuotaIva', 'OBJECT' 
GO
ALTER TABLE dbo.TiposAlicuotaIva ADD CONSTRAINT
	PK_TiposAlicuotaIva PRIMARY KEY CLUSTERED 
	(
	Fecha
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.427', GetDate()) 