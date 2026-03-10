/*    
	  Jueves, 12 de Septiembre de 2.024  -   v0.00.460.sql 
	  
	  Agregamos la tabla y el view para producir el reporte de cuentas contables desde Access 
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
ALTER TABLE dbo.ProcesosUsuarios SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO

/****** Object:  Table [dbo].[Tmp_CuentasContablesReport]    Script Date: 9/12/2024 12:47:00 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tmp_CuentasContablesReport]') AND type in (N'U'))
DROP TABLE [dbo].[Tmp_CuentasContablesReport]
GO


CREATE TABLE dbo.Tmp_CuentasContablesReport
	(
	Id int NOT NULL IDENTITY (1, 1),
	ProcesoId int NOT NULL,
	CuentaContableId int NOT NULL,
	CuentaContable nvarchar(30) NOT NULL,
	Descripcion nvarchar(40) NOT NULL,
	GrupoNombre nvarchar(50) NOT NULL,
	TotDet nvarchar(10) NOT NULL,
	ActSusp nvarchar(10) NOT NULL,
	CiaContabAbreviatura nvarchar(10) NOT NULL,
	CiaContabNombre nvarchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_CuentasContablesReport ADD CONSTRAINT
	PK_Tmp_CuentasContablesReport PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Tmp_CuentasContablesReport ADD CONSTRAINT
	FK_Tmp_CuentasContablesReport_ProcesosUsuarios FOREIGN KEY
	(
	ProcesoId
	) REFERENCES dbo.ProcesosUsuarios
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Tmp_CuentasContablesReport SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.460', GetDate()) 