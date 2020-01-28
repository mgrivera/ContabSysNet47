/*    Miércoles, 8 de Abril de 2.015 	-  v0.00.374.sql 

	Centros de costo: agregamos 'suspender' 
	Asientos: agregamos tabla Asientos_Log, para agregar item cuando el usuario modifica 
	agrega un asiento; agregamos 'trigger' para que se registre este item en esta tabla, 
	cuando el usuario modifica un asiento 
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
ALTER TABLE dbo.CentrosCosto ADD
	Suspendido bit NULL
GO
ALTER TABLE dbo.CentrosCosto SET (LOCK_ESCALATION = TABLE)
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
CREATE TABLE dbo.Asientos_Log
	(
	ID bigint NOT NULL IDENTITY (1, 1),
	NumeroAutomatico int NOT NULL,
	NumeroAsiento smallint NOT NULL,
	FechaAsiento date NOT NULL,
	Usuario nvarchar(25) NOT NULL,
	FechaOperacion datetime2(7) NOT NULL,
	DescripcionOperacion nvarchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Asientos_Log ADD CONSTRAINT
	PK_Asientos_Log PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Asientos_Log SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.374', GetDate()) 