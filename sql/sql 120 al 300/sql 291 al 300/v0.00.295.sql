/*    Viernes, 02 de Diciembre de 2.011  -   v0.00.295.sql 

	Hacemos algunos cambios a la tabla DefinicionCuentasContables 

	NOTA: PROBAR ESTE SCRIPT CUANDO, POR EJEMPLO, VAYAMOS A CONVERTIR GlobexRe ... 
	ahora no lo hicimos en forma muy completa pues Risk no tiene registros 
	definidos (muy pocos sin importancia) ... 
	
	NOTA: para Lacoste corrió bien ! 
*/

/* ==================================================================================
	ANTES de hacer los cambios más importantes a DefinicionCuentasContables, 
	hacemos un proceso para CONVERTIR los registros a la nueva estructura. La idea
	es que el usuario, luego del cambio, no sienta que ha perdido nada y tenga 
	*toda* su información registrada, ahora bajo la nueva estructura 
   ================================================================================== */ 

/* primero grabamos el contenido de la tabla original en una nueva */ 

CREATE TABLE DefinicionCuentasContables_1
	(
	Rubro int NULL,
	Compania int NULL,
	Moneda int NULL,
	Concepto smallint NOT NULL,
	CiaContab int Null, 
	CuentaContable nvarchar(25) NOT NULL
	)  

Insert Into DefinicionCuentasContables_1 (Rubro, Compania, Moneda, Concepto, CiaContab, CuentaContable) 
Select Rubro, Compania, Moneda, Concepto, CiaContab, CuentaContable From DefinicionCuentasContables 

/* Ahora eliminamos el contenido de la tabla original   */ 


Delete From DefinicionCuentasContables 




/* Ahora hacemos los cambios a la tabla y *luego* vamos a convertir y registrar la información     */ 


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
ALTER TABLE dbo.DefinicionCuentasContables
	DROP CONSTRAINT FK_DefinicionCuentasContables_Monedas
GO
ALTER TABLE dbo.Monedas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.DefinicionCuentasContables
	DROP CONSTRAINT FK_DefinicionCuentasContables_Proveedores
GO
ALTER TABLE dbo.Proveedores SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.DefinicionCuentasContables
	DROP CONSTRAINT FK_DefinicionCuentasContables_TiposProveedor
GO
ALTER TABLE dbo.TiposProveedor SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.DefinicionCuentasContables
	DROP CONSTRAINT FK_DefinicionCuentasContables_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_DefinicionCuentasContables
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	Rubro int NULL,
	Compania int NULL,
	Moneda int NULL,
	Concepto smallint NOT NULL,
	CuentaContableID int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_DefinicionCuentasContables SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_DefinicionCuentasContables ON
GO
IF EXISTS(SELECT * FROM dbo.DefinicionCuentasContables)
	 EXEC('INSERT INTO dbo.Tmp_DefinicionCuentasContables (ClaveUnica, Rubro, Compania, Moneda, Concepto, CuentaContableID)
		SELECT ClaveUnica, Rubro, Compania, Moneda, Concepto, CONVERT(int, CuentaContable) FROM dbo.DefinicionCuentasContables WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_DefinicionCuentasContables OFF
GO
DROP TABLE dbo.DefinicionCuentasContables
GO
EXECUTE sp_rename N'dbo.Tmp_DefinicionCuentasContables', N'DefinicionCuentasContables', 'OBJECT' 
GO
ALTER TABLE dbo.DefinicionCuentasContables ADD CONSTRAINT
	PK_DefinicionCuentasContables PRIMARY KEY NONCLUSTERED 
	(
	ClaveUnica
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.DefinicionCuentasContables ADD CONSTRAINT
	FK_DefinicionCuentasContables_TiposProveedor FOREIGN KEY
	(
	Rubro
	) REFERENCES dbo.TiposProveedor
	(
	Tipo
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.DefinicionCuentasContables ADD CONSTRAINT
	FK_DefinicionCuentasContables_Proveedores FOREIGN KEY
	(
	Compania
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.DefinicionCuentasContables ADD CONSTRAINT
	FK_DefinicionCuentasContables_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.DefinicionCuentasContables ADD CONSTRAINT
	FK_DefinicionCuentasContables_CuentasContables FOREIGN KEY
	(
	CuentaContableID
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT









/* ========================================================================================= */ 
/* ========================================================================================= */ 


/* Ok, ahora que están hechos los cambios, recuperamos la información */  

/* para efectuar la conversión usamos cursores para leer los datos y convertirlos */ 

delete from DefinicionCuentasContables 

DECLARE @rubro int, @compania int, @moneda int, @concepto smallint, @ciaContab int, 
 @cuentaContable nvarchar(25), @cuentaContableID int, @ciaContab2 int 

declare mycursor cursor for select Rubro, Compania, Moneda, Concepto, CiaContab, CuentaContable
	From DefinicionCuentasContables_1 

Open mycursor

FETCH Next From mycursor INTO @rubro, @compania, @moneda, @concepto, @ciaContab, @cuentaContable

WHILE @@FETCH_STATUS = 0
BEGIN

	IF @ciaContab Is Not Null 
		BEGIN
			-- Ok, el registro viene con una ciaContab; buscamos la cuenta en la tabla 
			-- de cuentas contables y grabamos un registro a la nueva tabla 
			
			Select @cuentaContableID = ID From CuentasContables Where 
						Cuenta = @cuentaContable And Cia = @ciaContab 
					
			IF @@ROWCOUNT = 1
				Insert Into DefinicionCuentasContables 
					(Rubro, Compania, Moneda, Concepto, CuentaContableID) 
					Values (@rubro, @compania, @moneda, @concepto, @cuentaContableID)
		END
 
	ELSE 

		BEGIN
			-- cuando CiaContab es null en el registro, la cosa se complica un poco, pues 
			-- intentamos grabar un registro *para cada cia contab* definida; antes buscamos 
			-- la cuenta contable para la cia Contab; si no existe, pasamos al prox sin grabar 

			declare cias cursor for select Numero from Companias 
			open cias 
			fetch next from cias into @ciaContab2

			WHILE @@FETCH_STATUS = 0
				begin
					Select @cuentaContableID = ID From CuentasContables Where 
						Cuenta = @cuentaContable And Cia = @ciaContab2 

					IF @@ROWCOUNT = 1
						Insert Into DefinicionCuentasContables 
							(Rubro, Compania, Moneda, Concepto, CuentaContableID) 
							Values (@rubro, @compania, @moneda, @concepto, @cuentaContableID)

					fetch next from cias into @ciaContab2

				end 

			close cias 
			deallocate cias 
		END

	FETCH Next From mycursor INTO 
		@rubro, @compania, @moneda, @concepto, @ciaContab, @cuentaContable
END

Close mycursor
Deallocate mycursor 

/* ========================================================================================= */ 
/* ========================================================================================= */ 



-- por último, eliminamos la tabla que creamos para convertir (pero ... mejor la dejamos un tiempo, por sia) 

-- drop table DefinicionCuentasContables_1


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.295', GetDate()) 