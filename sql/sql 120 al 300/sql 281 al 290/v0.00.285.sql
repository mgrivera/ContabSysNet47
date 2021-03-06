/*    S�bado, 24 de Septiembre de 2.011  -   v0.00.285.sql 

	Agregamos la columna UsuarioLS a la tabla tCiaSeleccionada 
	(NOTA IMPORTANTE: ya hicimos �sto en Geh; ejecutarlo 'por partes' ... ) 
	Creo que fue porque hab�amos eliminado datos de algunas tablas en forma manual y 
	al intentar crear las relaciones, hab�an inconsistencias 
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

/* esto fue hecho en Geh 

NOTA IMPORTANTE: GEH: Aparentemente, si 'saltamos' �sto *todo* el resto 
se debe ejecutar correctamente. 

NOTA IMPORTANTE: fall� en Globex ... ejecutar por partes para detectar la falla 
				 en forma anticipada ... 

*/ 

ALTER TABLE dbo.tCiaSeleccionada ADD
	UsuarioLS nvarchar(255) NULL
GO
ALTER TABLE dbo.tCiaSeleccionada SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



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
CREATE TABLE dbo.Tmp_tCiaSeleccionada
	(
	ID int NOT NULL IDENTITY (1, 1),
	CiaSeleccionada int NOT NULL,
	Nombre nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	NombreCorto nvarchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Usuario int NOT NULL,
	UsuarioLS nvarchar(255) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tCiaSeleccionada SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tCiaSeleccionada OFF
GO
IF EXISTS(SELECT * FROM dbo.tCiaSeleccionada)
	 EXEC('INSERT INTO dbo.Tmp_tCiaSeleccionada (CiaSeleccionada, Nombre, NombreCorto, Usuario, UsuarioLS)
		SELECT CiaSeleccionada, Nombre, NombreCorto, Usuario, UsuarioLS FROM dbo.tCiaSeleccionada WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.tCiaSeleccionada
GO
EXECUTE sp_rename N'dbo.Tmp_tCiaSeleccionada', N'tCiaSeleccionada', 'OBJECT' 
GO
ALTER TABLE dbo.tCiaSeleccionada ADD CONSTRAINT
	PK_tCiaSeleccionada PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT


/*    
	Eliminamos la relaci�n entre dAsientos y Companias 
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
ALTER TABLE dbo.dAsientos
	DROP CONSTRAINT FK_dAsientos_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.dAsientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT













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
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tCiaSeleccionada ADD CONSTRAINT
	FK_tCiaSeleccionada_Companias FOREIGN KEY
	(
	CiaSeleccionada
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.tCiaSeleccionada SET (LOCK_ESCALATION = TABLE)
GO
COMMIT





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
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.UltimoMesCerradoContab ADD CONSTRAINT
	FK_UltimoMesCerradoContab_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.UltimoMesCerradoContab SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

















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
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.MesesDelAnoFiscal ADD CONSTRAINT
	FK_MesesDelAnoFiscal_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.MesesDelAnoFiscal SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


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
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.ParametrosContab ADD CONSTRAINT
	FK_ParametrosContab_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.ParametrosContab SET (LOCK_ESCALATION = TABLE)
GO
COMMIT





--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.285', GetDate()) 