/*    Lunes, 11 de Octubre de 2.010  -   v0.00.272.sql 

	Agregamos una columna a la tabla de empleados para saber si 
	el empleado debe ser escribo al archivo xml de retenciones ISLR 
	
	NOTA IMPORTANTE: este script fallará si el query que sigue regresa registros ... 
	
	select * from tNomina where Empleado not in (Select Empleado from tEmpleados) 

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
ALTER TABLE dbo.tEmpleados
	DROP CONSTRAINT FK_tEmpleados_tDepartamentos
GO
ALTER TABLE dbo.tDepartamentos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tEmpleados
	(
	Empleado int NOT NULL,
	Cedula nvarchar(12) NOT NULL,
	Rif nvarchar(20) NULL,
	EscribirArchivoXMLRetencionesISLR bit NULL,
	Status nvarchar(1) NOT NULL,
	Nombre nvarchar(250) NOT NULL,
	EdoCivil nvarchar(2) NOT NULL,
	Sexo nvarchar(1) NOT NULL,
	Nacionalidad nvarchar(1) NOT NULL,
	FechaNacimiento datetime NOT NULL,
	PaisOrigen nvarchar(6) NULL,
	CiudadOrigen nvarchar(6) NULL,
	DireccionHabitacion ntext NULL,
	Telefono1 nvarchar(14) NULL,
	Telefono2 nvarchar(14) NULL,
	SituacionActual nvarchar(2) NOT NULL,
	Departamento int NOT NULL,
	Cargo int NOT NULL,
	FechaIngreso datetime NOT NULL,
	FechaRetiro datetime NULL,
	Banco int NULL,
	CuentaBancaria nvarchar(30) NULL,
	Contacto1 nvarchar(250) NULL,
	Parentesco1 int NULL,
	TelefonoCon1 nvarchar(14) NULL,
	Contacto2 nvarchar(250) NULL,
	Parentesco2 int NULL,
	TelefonoCon2 nvarchar(14) NULL,
	Contacto3 nvarchar(250) NULL,
	Parentesco3 int NULL,
	TelefonoCon3 nvarchar(14) NULL,
	TipoCuenta int NULL,
	EmpleadoObreroFlag smallint NULL,
	SueldoPromedio money NULL,
	SueldoBasico money NULL,
	MontoCestaTickets money NULL,
	BonoVacAgregarSueldoFlag bit NULL,
	BonoVacAgregarMontoCestaTicketsFlag bit NULL,
	BonoVacacionalMontoAdicional money NULL,
	BonoVacAgregarMontoAdicionalFlag bit NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.tEmpleados)
	 EXEC('INSERT INTO dbo.Tmp_tEmpleados (Empleado, Cedula, Rif, Status, Nombre, EdoCivil, Sexo, Nacionalidad, FechaNacimiento, PaisOrigen, CiudadOrigen, DireccionHabitacion, Telefono1, Telefono2, SituacionActual, Departamento, Cargo, FechaIngreso, FechaRetiro, Banco, CuentaBancaria, Contacto1, Parentesco1, TelefonoCon1, Contacto2, Parentesco2, TelefonoCon2, Contacto3, Parentesco3, TelefonoCon3, TipoCuenta, EmpleadoObreroFlag, SueldoPromedio, SueldoBasico, MontoCestaTickets, BonoVacAgregarSueldoFlag, BonoVacAgregarMontoCestaTicketsFlag, BonoVacacionalMontoAdicional, BonoVacAgregarMontoAdicionalFlag, Cia)
		SELECT Empleado, Cedula, Rif, Status, Nombre, EdoCivil, Sexo, Nacionalidad, FechaNacimiento, PaisOrigen, CiudadOrigen, DireccionHabitacion, Telefono1, Telefono2, SituacionActual, Departamento, Cargo, FechaIngreso, FechaRetiro, Banco, CuentaBancaria, Contacto1, Parentesco1, TelefonoCon1, Contacto2, Parentesco2, TelefonoCon2, Contacto3, Parentesco3, TelefonoCon3, TipoCuenta, EmpleadoObreroFlag, SueldoPromedio, SueldoBasico, MontoCestaTickets, BonoVacAgregarSueldoFlag, BonoVacAgregarMontoCestaTicketsFlag, BonoVacacionalMontoAdicional, BonoVacAgregarMontoAdicionalFlag, Cia FROM dbo.tEmpleados WITH (HOLDLOCK TABLOCKX)')
GO
ALTER TABLE dbo.Vacaciones
	DROP CONSTRAINT FK_Vacaciones_tEmpleados
GO
DROP TABLE dbo.tEmpleados
GO
EXECUTE sp_rename N'dbo.Tmp_tEmpleados', N'tEmpleados', 'OBJECT' 
GO
ALTER TABLE dbo.tEmpleados ADD CONSTRAINT
	PK_tEmpleados PRIMARY KEY NONCLUSTERED 
	(
	Empleado
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_tEmpleados ON dbo.tEmpleados
	(
	Departamento
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.tEmpleados WITH NOCHECK ADD CONSTRAINT
	FK_tEmpleados_tDepartamentos FOREIGN KEY
	(
	Departamento
	) REFERENCES dbo.tDepartamentos
	(
	Departamento
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Vacaciones WITH NOCHECK ADD CONSTRAINT
	FK_Vacaciones_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Vacaciones SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



/****** Object:  View [dbo].[qFormaEmpleadosConsulta]    Script Date: 10/11/2010 16:02:19 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qFormaEmpleadosConsulta]'))
DROP VIEW [dbo].[qFormaEmpleadosConsulta]
GO

/****** Object:  View [dbo].[qFormaEmpleadosConsulta]    Script Date: 10/11/2010 16:02:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[qFormaEmpleadosConsulta]
AS
SELECT     dbo.tEmpleados.Empleado, dbo.tEmpleados.Cedula, dbo.tEmpleados.Rif, dbo.tEmpleados.EscribirArchivoXMLRetencionesISLR, 
                      dbo.tEmpleados.Status, dbo.tEmpleados.Nombre, dbo.tEmpleados.EdoCivil, dbo.tEmpleados.Sexo, dbo.tEmpleados.Nacionalidad, 
                      dbo.tEmpleados.FechaNacimiento, dbo.tEmpleados.PaisOrigen, dbo.tPaises.Descripcion AS NombrePais, dbo.tEmpleados.CiudadOrigen, 
                      dbo.tCiudades.Descripcion AS NombreCiudad, dbo.tEmpleados.DireccionHabitacion, dbo.tEmpleados.Telefono1, dbo.tEmpleados.Telefono2, 
                      dbo.tEmpleados.SituacionActual, dbo.tEmpleados.Departamento, dbo.tDepartamentos.Descripcion AS NombreDepartamento, dbo.tEmpleados.Cargo, 
                      dbo.tCargos.Descripcion AS NombreCargo, dbo.tEmpleados.FechaIngreso, dbo.tEmpleados.FechaRetiro, dbo.tEmpleados.Banco, 
                      dbo.Bancos.Nombre AS NombreBanco, dbo.tEmpleados.CuentaBancaria, dbo.tEmpleados.TipoCuenta, dbo.tEmpleados.Contacto1, 
                      dbo.tEmpleados.Parentesco1, tParentescosUno.Descripcion AS NombreParentescoUno, dbo.tEmpleados.TelefonoCon1, dbo.tEmpleados.Contacto2, 
                      dbo.tEmpleados.Parentesco2, tParentescosDos.Descripcion AS NombreParentescoDos, dbo.tEmpleados.TelefonoCon2, dbo.tEmpleados.Contacto3, 
                      dbo.tEmpleados.Parentesco3, tParentescosTres.Descripcion AS NombreParentescoTres, dbo.tEmpleados.TelefonoCon3, 
                      dbo.tEmpleados.EmpleadoObreroFlag, dbo.tEmpleados.SueldoPromedio, dbo.tEmpleados.SueldoBasico, dbo.tEmpleados.Cia, 
                      dbo.tEmpleados.MontoCestaTickets, dbo.tEmpleados.BonoVacAgregarSueldoFlag, dbo.tEmpleados.BonoVacAgregarMontoCestaTicketsFlag, 
                      dbo.tEmpleados.BonoVacacionalMontoAdicional, dbo.tEmpleados.BonoVacAgregarMontoAdicionalFlag
FROM         dbo.tEmpleados LEFT OUTER JOIN
                      dbo.tCargos ON dbo.tEmpleados.Cargo = dbo.tCargos.Cargo LEFT OUTER JOIN
                      dbo.tDepartamentos ON dbo.tEmpleados.Departamento = dbo.tDepartamentos.Departamento LEFT OUTER JOIN
                      dbo.tPaises ON dbo.tEmpleados.PaisOrigen = dbo.tPaises.Pais LEFT OUTER JOIN
                      dbo.tCiudades ON dbo.tEmpleados.CiudadOrigen = dbo.tCiudades.Ciudad LEFT OUTER JOIN
                      dbo.tParentescos AS tParentescosUno ON dbo.tEmpleados.Parentesco1 = tParentescosUno.Parentesco LEFT OUTER JOIN
                      dbo.tParentescos AS tParentescosDos ON dbo.tEmpleados.Parentesco2 = tParentescosDos.Parentesco LEFT OUTER JOIN
                      dbo.tParentescos AS tParentescosTres ON dbo.tEmpleados.Parentesco3 = tParentescosTres.Parentesco LEFT OUTER JOIN
                      dbo.Bancos ON dbo.tEmpleados.Banco = dbo.Bancos.Banco

GO




/* agregamos una relación tEmpleados -> tNomina */ 

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
ALTER TABLE dbo.tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tNomina ADD CONSTRAINT
	FK_tNomina_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tNomina SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.272', GetDate()) 