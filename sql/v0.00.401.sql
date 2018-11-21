/*    
	  Sábado, 12/Ago/2.017   -   v0.00.401.sql 
	  Agregamos el nuevo campo 'PrestacionesAgregarMontoCestaTicketsFlag' a la tabla ParametrosContab 
*/


/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
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
	DROP CONSTRAINT FK_tEmpleados_TiposDeCuentaBancaria1
GO
ALTER TABLE dbo.TiposDeCuentaBancaria SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tEmpleados
	DROP CONSTRAINT FK_tEmpleados_Bancos1
GO
ALTER TABLE dbo.tEmpleados
	DROP CONSTRAINT FK_tEmpleados_Bancos2
GO
ALTER TABLE dbo.Bancos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tEmpleados
	DROP CONSTRAINT FK_tEmpleados_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tEmpleados
	DROP CONSTRAINT FK_tEmpleados_tParentescos
GO
ALTER TABLE dbo.tEmpleados
	DROP CONSTRAINT FK_tEmpleados_tParentescos1
GO
ALTER TABLE dbo.tEmpleados
	DROP CONSTRAINT FK_tEmpleados_tParentescos2
GO
ALTER TABLE dbo.tParentescos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tEmpleados
	DROP CONSTRAINT FK_tEmpleados_tCiudades
GO
ALTER TABLE dbo.tCiudades SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tEmpleados
	DROP CONSTRAINT FK_tEmpleados_tCargos
GO
ALTER TABLE dbo.tCargos SET (LOCK_ESCALATION = TABLE)
GO
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
	Empleado int NOT NULL IDENTITY (1, 1),
	Cedula nvarchar(12) NOT NULL,
	Alias nvarchar(15) NOT NULL,
	Rif nvarchar(20) NULL,
	TipoNomina smallint NOT NULL,
	EscribirArchivoXMLRetencionesISLR bit NULL,
	Status nvarchar(1) NOT NULL,
	Nombre nvarchar(250) NOT NULL,
	EdoCivil nvarchar(2) NOT NULL,
	Sexo nvarchar(1) NOT NULL,
	Nacionalidad nvarchar(1) NOT NULL,
	FechaNacimiento date NOT NULL,
	CiudadOrigen nvarchar(6) NULL,
	DireccionHabitacion ntext NULL,
	Telefono1 nvarchar(25) NULL,
	Telefono2 nvarchar(25) NULL,
	email nvarchar(50) NULL,
	SituacionActual nvarchar(2) NOT NULL,
	Departamento int NOT NULL,
	Cargo int NOT NULL,
	FechaIngreso date NOT NULL,
	FechaRetiro date NULL,
	BancoDepositosNomina int NULL,
	TipoCuentaDepositosNomina int NULL,
	CuentaBancariaDepositosNomina nvarchar(30) NULL,
	BancoCuentaPrestacionesSociales int NULL,
	NumeroCuentaBancariaPrestacionesSociales nvarchar(30) NULL,
	Contacto1 nvarchar(250) NULL,
	Parentesco1 int NULL,
	TelefonoCon1 nvarchar(25) NULL,
	Contacto2 nvarchar(250) NULL,
	Parentesco2 int NULL,
	TelefonoCon2 nvarchar(25) NULL,
	Contacto3 nvarchar(250) NULL,
	Parentesco3 int NULL,
	TelefonoCon3 nvarchar(25) NULL,
	EmpleadoObreroFlag smallint NULL,
	MontoCestaTickets money NULL,
	BonoVacAgregarSueldoFlag bit NULL,
	BonoVacAgregarMontoCestaTicketsFlag bit NULL,
	BonoVacacionalMontoAdicional money NULL,
	BonoVacAgregarMontoAdicionalFlag bit NULL,
	PrestacionesAgregarMontoCestaTicketsFlag bit NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tEmpleados ON
GO
IF EXISTS(SELECT * FROM dbo.tEmpleados)
	 EXEC('INSERT INTO dbo.Tmp_tEmpleados (Empleado, Cedula, Alias, Rif, TipoNomina, EscribirArchivoXMLRetencionesISLR, Status, Nombre, EdoCivil, Sexo, Nacionalidad, FechaNacimiento, CiudadOrigen, DireccionHabitacion, Telefono1, Telefono2, email, SituacionActual, Departamento, Cargo, FechaIngreso, FechaRetiro, BancoDepositosNomina, TipoCuentaDepositosNomina, CuentaBancariaDepositosNomina, BancoCuentaPrestacionesSociales, NumeroCuentaBancariaPrestacionesSociales, Contacto1, Parentesco1, TelefonoCon1, Contacto2, Parentesco2, TelefonoCon2, Contacto3, Parentesco3, TelefonoCon3, EmpleadoObreroFlag, MontoCestaTickets, BonoVacAgregarSueldoFlag, BonoVacAgregarMontoCestaTicketsFlag, BonoVacacionalMontoAdicional, BonoVacAgregarMontoAdicionalFlag, Cia)
		SELECT Empleado, Cedula, Alias, Rif, TipoNomina, EscribirArchivoXMLRetencionesISLR, Status, Nombre, EdoCivil, Sexo, Nacionalidad, FechaNacimiento, CiudadOrigen, DireccionHabitacion, Telefono1, Telefono2, email, SituacionActual, Departamento, Cargo, FechaIngreso, FechaRetiro, BancoDepositosNomina, TipoCuentaDepositosNomina, CuentaBancariaDepositosNomina, BancoCuentaPrestacionesSociales, NumeroCuentaBancariaPrestacionesSociales, Contacto1, Parentesco1, TelefonoCon1, Contacto2, Parentesco2, TelefonoCon2, Contacto3, Parentesco3, TelefonoCon3, EmpleadoObreroFlag, MontoCestaTickets, BonoVacAgregarSueldoFlag, BonoVacAgregarMontoCestaTicketsFlag, BonoVacacionalMontoAdicional, BonoVacAgregarMontoAdicionalFlag, Cia FROM dbo.tEmpleados WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tEmpleados OFF
GO
ALTER TABLE dbo.tNomina_SalarioIntegral
	DROP CONSTRAINT FK_tNomina_SalarioIntegral_tEmpleados
GO
ALTER TABLE dbo.Empleados_Faltas
	DROP CONSTRAINT FK_Empleados_Faltas_tEmpleados
GO
ALTER TABLE dbo.tRubrosAsignados
	DROP CONSTRAINT FK_tRubrosAsignados_tEmpleados
GO
ALTER TABLE dbo.Nomina_DefinicionAnticipos_Empleados
	DROP CONSTRAINT FK_Nomina_DefinicionAnticipos_Empleados_tEmpleados
GO
ALTER TABLE dbo.tPrestamos
	DROP CONSTRAINT FK_tPrestamos_tEmpleados
GO
ALTER TABLE dbo.DeduccionesISLR
	DROP CONSTRAINT FK_DeduccionesISLR_tEmpleados
GO
ALTER TABLE dbo.SueldoAumentado_Definicion
	DROP CONSTRAINT FK_SueldoAumentado_Definicion_tEmpleados
GO
ALTER TABLE dbo.VacacPorAnoParticulares
	DROP CONSTRAINT FK_VacacPorAnoParticulares_tEmpleados
GO
ALTER TABLE dbo.Empleados_Sueldo
	DROP CONSTRAINT FK_Empleados_Sueldo_tEmpleados
GO
ALTER TABLE dbo.tdGruposEmpleados
	DROP CONSTRAINT FK_tdGruposEmpleados_tEmpleados
GO
ALTER TABLE dbo.DeduccionesNomina
	DROP CONSTRAINT FK_DeduccionesNomina_tEmpleados
GO
ALTER TABLE dbo.tCuentasContablesPorEmpleadoYRubro
	DROP CONSTRAINT FK_tCuentasContablesPorEmpleadoYRubro_tEmpleados
GO
ALTER TABLE dbo.InventarioActivosFijos
	DROP CONSTRAINT FK_InventarioActivosFijos_tEmpleados
GO
ALTER TABLE dbo.Vacaciones
	DROP CONSTRAINT FK_Vacaciones_tEmpleados
GO
ALTER TABLE dbo.tNomina
	DROP CONSTRAINT FK_tNomina_tEmpleados
GO
ALTER TABLE dbo.PrestacionesSociales
	DROP CONSTRAINT FK_PrestacionesSociales_tEmpleados
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
ALTER TABLE dbo.tEmpleados ADD CONSTRAINT
	FK_tEmpleados_tCargos FOREIGN KEY
	(
	Cargo
	) REFERENCES dbo.tCargos
	(
	Cargo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tEmpleados ADD CONSTRAINT
	FK_tEmpleados_tCiudades FOREIGN KEY
	(
	CiudadOrigen
	) REFERENCES dbo.tCiudades
	(
	Ciudad
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tEmpleados ADD CONSTRAINT
	FK_tEmpleados_tParentescos FOREIGN KEY
	(
	Parentesco1
	) REFERENCES dbo.tParentescos
	(
	Parentesco
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tEmpleados ADD CONSTRAINT
	FK_tEmpleados_tParentescos1 FOREIGN KEY
	(
	Parentesco2
	) REFERENCES dbo.tParentescos
	(
	Parentesco
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tEmpleados ADD CONSTRAINT
	FK_tEmpleados_tParentescos2 FOREIGN KEY
	(
	Parentesco3
	) REFERENCES dbo.tParentescos
	(
	Parentesco
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tEmpleados ADD CONSTRAINT
	FK_tEmpleados_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tEmpleados ADD CONSTRAINT
	FK_tEmpleados_Bancos1 FOREIGN KEY
	(
	BancoDepositosNomina
	) REFERENCES dbo.Bancos
	(
	Banco
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tEmpleados ADD CONSTRAINT
	FK_tEmpleados_TiposDeCuentaBancaria1 FOREIGN KEY
	(
	TipoCuentaDepositosNomina
	) REFERENCES dbo.TiposDeCuentaBancaria
	(
	TipoCuenta
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tEmpleados ADD CONSTRAINT
	FK_tEmpleados_Bancos2 FOREIGN KEY
	(
	BancoCuentaPrestacionesSociales
	) REFERENCES dbo.Bancos
	(
	Banco
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.PrestacionesSociales ADD CONSTRAINT
	FK_PrestacionesSociales_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.PrestacionesSociales SET (LOCK_ESCALATION = TABLE)
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
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.tNomina SET (LOCK_ESCALATION = TABLE)
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
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Vacaciones SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.InventarioActivosFijos ADD CONSTRAINT
	FK_InventarioActivosFijos_tEmpleados FOREIGN KEY
	(
	AutorizadoPor
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.InventarioActivosFijos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tCuentasContablesPorEmpleadoYRubro ADD CONSTRAINT
	FK_tCuentasContablesPorEmpleadoYRubro_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.tCuentasContablesPorEmpleadoYRubro SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.DeduccionesNomina ADD CONSTRAINT
	FK_DeduccionesNomina_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.DeduccionesNomina SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tdGruposEmpleados ADD CONSTRAINT
	FK_tdGruposEmpleados_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.tdGruposEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Empleados_Sueldo ADD CONSTRAINT
	FK_Empleados_Sueldo_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Empleados_Sueldo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.VacacPorAnoParticulares ADD CONSTRAINT
	FK_VacacPorAnoParticulares_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.VacacPorAnoParticulares SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.SueldoAumentado_Definicion ADD CONSTRAINT
	FK_SueldoAumentado_Definicion_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.SueldoAumentado_Definicion SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.DeduccionesISLR ADD CONSTRAINT
	FK_DeduccionesISLR_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.DeduccionesISLR SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tPrestamos ADD CONSTRAINT
	FK_tPrestamos_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.tPrestamos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Nomina_DefinicionAnticipos_Empleados ADD CONSTRAINT
	FK_Nomina_DefinicionAnticipos_Empleados_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Nomina_DefinicionAnticipos_Empleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tRubrosAsignados ADD CONSTRAINT
	FK_tRubrosAsignados_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.tRubrosAsignados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Empleados_Faltas ADD CONSTRAINT
	FK_Empleados_Faltas_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.Empleados_Faltas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tNomina_SalarioIntegral ADD CONSTRAINT
	FK_tNomina_SalarioIntegral_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.tNomina_SalarioIntegral SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.401', GetDate()) 
