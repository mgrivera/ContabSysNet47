/*    Lunes, 19 de Agosto de 2.013 	-   v0.00.355.sql 

	Para agrandar los tags en Analisis Contable a 100 chars ... 
	
	Nota: revisar collation en estas tablas; todas las columnas deben tener collation 'default' 
	
	CuentasContables 
	NivelesAgrupacionContable 
	tGruposContables 
*/

Alter Table AnalisisContable_CuentasContables Alter Column Tag1 nvarchar(100) NULL
Alter Table AnalisisContable_CuentasContables Alter Column Tag2 nvarchar(100) NULL
Alter Table AnalisisContable_CuentasContables Alter Column Tag3 nvarchar(100) NULL
Alter Table AnalisisContable_CuentasContables Alter Column Tag4 nvarchar(100) NULL
Alter Table AnalisisContable_CuentasContables Alter Column Tag5 nvarchar(100) NULL
Alter Table AnalisisContable_CuentasContables Alter Column Tag6 nvarchar(100) NULL


Alter Table Temp_Contab_Report_AnalisisContable Alter Column Tag1 nvarchar(100) NULL
Alter Table Temp_Contab_Report_AnalisisContable Alter Column Tag2 nvarchar(100) NULL
Alter Table Temp_Contab_Report_AnalisisContable Alter Column Tag3 nvarchar(100) NULL
Alter Table Temp_Contab_Report_AnalisisContable Alter Column Tag4 nvarchar(100) NULL
Alter Table Temp_Contab_Report_AnalisisContable Alter Column Tag5 nvarchar(100) NULL
Alter Table Temp_Contab_Report_AnalisisContable Alter Column Tag6 nvarchar(100) NULL


/* con el código que sigue, intentamos agregar los códigos de agrupación que ahora existen en las cuentas contables, 
   a la tabla de AnalisisContable */ 
   
	
	DECLARE @Cia Int
	
	DECLARE @CuentaContableID int
	DECLARE @CodigoNivelAgrupacionContable nvarchar(100)
	DECLARE @GrupoNivelAgrupacionDescripcion nvarchar(100)

	
	-- para capturar el Identity que se genera al grabara a tNominaHeaders 
	declare @IdentityOutput table ( ID int )
	declare @IdentityValue int


	DECLARE db_cursor CURSOR FOR  
		SELECT Cia 
		FROM CuentasContables 
		Where NivelAgrupacion Is Not Null And ltrim(rtrim(NivelAgrupacion)) <> '' 
		Group By Cia 
		Order By Cia

	OPEN db_cursor   
	FETCH NEXT FROM db_cursor INTO @Cia 

	WHILE @@FETCH_STATUS = 0   
	BEGIN   
 
			Insert Into AnalisisContable (Descripcion, Cia) 
				   output inserted.ID into @IdentityOutput
				   Values ('Reporte Condi', @Cia) 
			
			-- guardamos el valor que se asignó al ID (pk) en la instrucción anterior ... 
			select @IdentityValue = (select Max(ID) from @IdentityOutput)
			
			
			-- leemos las cuentas contables para la cia contab leída antes y grabamos sus codigos de agrupación como Tags 
			-- a AnalisisContable_CuentasContables 
			
			DECLARE db_cursor2 CURSOR FOR  
				SELECT c.ID As CuentaContableID, n.NivelAgrupacion + ' - ' + n.Descripcion As CodigoNivelAgrupacionContable, 
				       g.Descripcion As GrupoNivelAgrupacionDescripcion  
				FROM CuentasContables c Inner Join NivelesAgrupacionContable n On c.NivelAgrupacion = n.NivelAgrupacion 
				                        Inner Join tGruposContables g On c.GrupoNivelAgrupacion = g.Grupo
				Where c.NivelAgrupacion Is Not Null And ltrim(rtrim(c.NivelAgrupacion)) <> '' And c.Cia = @Cia 
				

			OPEN db_cursor2   
			FETCH NEXT FROM db_cursor2 INTO @CuentaContableID, @CodigoNivelAgrupacionContable, @GrupoNivelAgrupacionDescripcion

			WHILE @@FETCH_STATUS = 0   
			BEGIN   
		 
					Insert Into AnalisisContable_CuentasContables (AnalisisContable_ID, CuentaContable_ID, Tag1, Tag2) 
						   Values (@IdentityValue, @CuentaContableID, @GrupoNivelAgrupacionDescripcion, @CodigoNivelAgrupacionContable) 
					
				   FETCH NEXT FROM db_cursor2 INTO @CuentaContableID, @CodigoNivelAgrupacionContable, @GrupoNivelAgrupacionDescripcion
			END   

			CLOSE db_cursor2   
			DEALLOCATE db_cursor2
			
			
		   FETCH NEXT FROM db_cursor INTO @Cia 
	END   

	CLOSE db_cursor   
	DEALLOCATE db_cursor

		
--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.355', GetDate()) 
