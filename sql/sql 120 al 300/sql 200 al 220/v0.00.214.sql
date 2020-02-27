/*    Jueves, 08 de Mayo de 2.008   -   v0.00.214.sql 

	Agregamos la tabla DefinicionArchivoMovBancos_EquivalenciasWeb 

	*** ------------------------------------------------- *** 
	*** NOTA: ejecutar ANTES v2 al v5 en ContabSysNet/Sql *** 
	*** ------------------------------------------------- *** 

*/ 


BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.DefinicionArchivoMovBanco_EquivalenciaTipos
	(
	NumeroDefinicion smallint NOT NULL,
	TipoOriginal nvarchar(2) NOT NULL,
	TipoAlConciliar nvarchar(2) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.DefinicionArchivoMovBanco_EquivalenciaTipos ADD CONSTRAINT
	PK_DefinicionArchivoMovBanco_EquivalenciaTipos PRIMARY KEY CLUSTERED 
	(
	NumeroDefinicion,
	TipoOriginal
	) ON [PRIMARY]

GO
ALTER TABLE dbo.DefinicionArchivoMovBanco_EquivalenciaTipos ADD CONSTRAINT
	FK_DefinicionArchivoMovBanco_EquivalenciaTipos_DefinicionArchivoMovBanco FOREIGN KEY
	(
	NumeroDefinicion
	) REFERENCES dbo.DefinicionArchivoMovBanco
	(
	NumeroDefinicion
	) ON UPDATE CASCADE
	 ON DELETE CASCADE
	
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.214', GetDate()) 