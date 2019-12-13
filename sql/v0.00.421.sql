/*    
	  Martes, 10 de Diciembre de 2.019  -   v0.00.421.sql 
	  
	  Agregamos la columna numUploads a la tabla (temp) de consulta de comprobantes 
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

delete from tTempWebReport_ConsultaComprobantesContables

ALTER TABLE dbo.tTempWebReport_ConsultaComprobantesContables
	DROP CONSTRAINT FK_tTempWebReport_ConsultaComprobantesContables_Asientos
GO
ALTER TABLE dbo.Asientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tTempWebReport_ConsultaComprobantesContables
	(
	ID int NOT NULL IDENTITY (1, 1),
	NumeroAutomatico int NOT NULL,
	NumPartidas smallint NOT NULL,
	NumUploads smallint NOT NULL,
	TotalDebe money NOT NULL,
	TotalHaber money NOT NULL,
	NombreUsuario nvarchar(256) NOT NULL,
	Lote nvarchar(50) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tTempWebReport_ConsultaComprobantesContables SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tTempWebReport_ConsultaComprobantesContables ON
GO
IF EXISTS(SELECT * FROM dbo.tTempWebReport_ConsultaComprobantesContables)
	 EXEC('INSERT INTO dbo.Tmp_tTempWebReport_ConsultaComprobantesContables (ID, NumeroAutomatico, NumPartidas, TotalDebe, TotalHaber, NombreUsuario, Lote)
		SELECT ID, NumeroAutomatico, NumPartidas, TotalDebe, TotalHaber, NombreUsuario, Lote FROM dbo.tTempWebReport_ConsultaComprobantesContables WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tTempWebReport_ConsultaComprobantesContables OFF
GO
DROP TABLE dbo.tTempWebReport_ConsultaComprobantesContables
GO
EXECUTE sp_rename N'dbo.Tmp_tTempWebReport_ConsultaComprobantesContables', N'tTempWebReport_ConsultaComprobantesContables', 'OBJECT' 
GO
ALTER TABLE dbo.tTempWebReport_ConsultaComprobantesContables ADD CONSTRAINT
	PK_tTempWebReport_ConsultaComprobantesContables PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tTempWebReport_ConsultaComprobantesContables ADD CONSTRAINT
	FK_tTempWebReport_ConsultaComprobantesContables_Asientos FOREIGN KEY
	(
	NumeroAutomatico
	) REFERENCES dbo.Asientos
	(
	NumeroAutomatico
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.421', GetDate()) 


