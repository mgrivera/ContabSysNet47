/*    
	  Viernes, 23 de Agosto de 2.024  -   v0.00.458.sql 
	  
	  Agregamos la tabla ProcesosUsuarios 
	  También agregamos la tabla que permite la consulta de asientos 
	  contables: Tmp_AsientosContables
*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ProcesosUsuarios](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Fecha] [smalldatetime] NOT NULL,
	[Categoria] [nvarchar](30) NOT NULL,
	[SubCategoria] [nvarchar](30) NOT NULL,
	[Descripcion] [nvarchar](300) NOT NULL,
	[Usuario] [nvarchar](25) NOT NULL,
 CONSTRAINT [PK_ProcesosUsuarios] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


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
CREATE TABLE dbo.Tmp_AsientosContablesReport
	(
	Id int NOT NULL IDENTITY (1, 1),
	ProcesoId int NOT NULL,
	AsientoId int NOT NULL,
	UserName nvarchar(30) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_AsientosContablesReport ADD CONSTRAINT
	PK_Tmp_AsientosContablesReport PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Tmp_AsientosContablesReport ADD CONSTRAINT
	FK_Tmp_AsientosContablesReport_ProcesosUsuarios FOREIGN KEY
	(
	ProcesoId
	) REFERENCES dbo.ProcesosUsuarios
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Tmp_AsientosContablesReport SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.458', GetDate()) 