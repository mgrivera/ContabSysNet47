/*    Miércoles, 31 de Mayo de 2.010    -   v0.00.264.sql 

	Cambiamos el PK en CajaChica_Reposiciones_Estados para que una reposición 
	pueda repetir sus estados 
	
	NOTA IMPORTANTE: si el SELECT que sigue regresa algún row, este script fallará ... 
	==================================================================================
	
	Select Reposicion, CajaChica, Estado, Fecha, CiaContab, COUNT(*)  
		From CajaChica_Reposiciones_Estados
		Group By Reposicion, CajaChica, Estado, Fecha, CiaContab 
		Having COUNT(*) > 1

*/




-- Cambiamos el item Fecha a DateTime para que acepte segundos y sea más preciso ... 


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
ALTER TABLE dbo.CajaChica_Reposiciones_Estados
	DROP CONSTRAINT FK_CajaChica_Reposiciones_Estados_CajaChica_Reposiciones
GO
ALTER TABLE dbo.CajaChica_Reposiciones SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_CajaChica_Reposiciones_Estados
	(
	Reposicion int NOT NULL,
	CajaChica smallint NOT NULL,
	Fecha datetime NOT NULL,
	CiaContab int NOT NULL,
	NombreUsuario nvarchar(256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Estado char(2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_CajaChica_Reposiciones_Estados SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.CajaChica_Reposiciones_Estados)
	 EXEC('INSERT INTO dbo.Tmp_CajaChica_Reposiciones_Estados (Reposicion, CajaChica, Fecha, CiaContab, NombreUsuario, Estado)
		SELECT Reposicion, CajaChica, CONVERT(datetime, Fecha), CiaContab, NombreUsuario, Estado FROM dbo.CajaChica_Reposiciones_Estados WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.CajaChica_Reposiciones_Estados
GO
EXECUTE sp_rename N'dbo.Tmp_CajaChica_Reposiciones_Estados', N'CajaChica_Reposiciones_Estados', 'OBJECT' 
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Estados ADD CONSTRAINT
	PK_CajaChica_Reposiciones_Estados PRIMARY KEY CLUSTERED 
	(
	Reposicion,
	CajaChica,
	CiaContab,
	Estado
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.CajaChica_Reposiciones_Estados ADD CONSTRAINT
	FK_CajaChica_Reposiciones_Estados_CajaChica_Reposiciones FOREIGN KEY
	(
	Reposicion,
	CajaChica,
	CiaContab
	) REFERENCES dbo.CajaChica_Reposiciones
	(
	Reposicion,
	CajaChica,
	CiaContab
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT


-- por último, cambiamos el PK para usar la fecha como parte del mismo ... 

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
ALTER TABLE dbo.CajaChica_Reposiciones_Estados
	DROP CONSTRAINT PK_CajaChica_Reposiciones_Estados
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Estados ADD CONSTRAINT
	PK_CajaChica_Reposiciones_Estados PRIMARY KEY CLUSTERED 
	(
	Reposicion,
	CajaChica,
	Fecha,
	CiaContab, 
	Estado 
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.CajaChica_Reposiciones_Estados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.264', GetDate()) 