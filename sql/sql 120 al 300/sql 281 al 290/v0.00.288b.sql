/*    Jueves, 20 de Octubre de 2.011  -   v0.00.288b.sql 

	Hacemos cambios importantes a las tablas que corresponden a 
	Movimientos Bancarios 
	
	NOTAS (MUY) IMPORTANTES: 
	
	1) no deben haber MB *con* chequera que no existan en Chequeras ... 
	
		Select * From MovimientosBancarios 
			Where ClaveUnicaChequera Is Not Null And 
			ClaveUnicaChequera Not In (Select NumeroChequera From Chequeras) 
		
	2) si el query anterior regresa registros, poner su chequera en Nulls, para que, 
	más abajo, se asocien a chequeras 'genéricas' (que se agregan más abajo) 

		Update  MovimientosBancarios Set ClaveUnicaChequera = Null 
				Where ClaveUnicaChequera Is Not Null And 
				ClaveUnicaChequera Not In (Select NumeroChequera From Chequeras) 
			
	3) no deben haber MB sin Cuenta Bancaria (creo que aquí si hay relación y ésto no puede darse!) 
	
		Select * From MovimientosBancarios 
			Where CuentaInterna Not In 
			(Select CuentaInterna From CuentasBancarias) 
		
		
		------------------------------------------------------------------------------------------
	4) regresar aquí al terminar la ejecución del script y *volver* a probar todo ...
	   (al completar este script, este query no debe traer registros) 
	   
		Select * From MovimientosBancarios Where ClaveUnicaChequera Is Null 
		
		Si los trae, son MB inconsistentes, cuya Cia *es diferente* a la Cia de su cuenta bancaria. Corregir 
		así: asignar (a mano?) CuentaInterna = alguna cuenta de la Cia del MB 
		                       ClaveUnicaChequera = NumeroChequera de la chequera 'genérica' 
		                                            de la cuenta anterior
		
		(copiar y ejecutar en otro query para que no se modifique este texto de abajo)     
		Update MovimientosBancarios Set CuentaInterna = <cuenta de la misma cia del MB>, 
		                                ClaveUnicaChequera = <NumeroChequera de la chequera 'generica' 
		                                                      de la cuenta anterior> 
		       Where Transaccion = <Transaccion del MB leído por el query anterior> And 
		             CuentaInterna = <CuentaInterna del MB leído por el query anterior> And 
		             Tipo = <Tipo del MB leído por el query anterior> 
		             
		Ejemplo: 
		Update MovimientosBancarios Set CuentaInterna = 6, 
		                                ClaveUnicaChequera = 313
		       Where Transaccion = '265817' And CuentaInterna = 4 And Tipo = 'ND'
	
*/


Delete From Chequeras Where Generica = 1 


/* NOTA: con estas instrucciones, agregamos una chequera 'genérica' para cada cuenta bancaria */ 

DECLARE MY_CURSOR Cursor Read_Only Forward_Only
		FOR 
		Select CuentaInterna, Cia
		From CuentasBancarias

Open My_Cursor 

DECLARE @CuentaInterna Int
Declare @Cia Int

Fetch Next FROM MY_CURSOR INTO @CuentaInterna, @Cia

While (@@FETCH_STATUS = 0)
BEGIN

	Insert Into Chequeras (NumeroCuenta, Generica, FechaAsignacion, Desde, Hasta, 
						   Ingreso, UltAct, Usuario, Cia) Values 
						  (@CuentaInterna, 1, GetDate(), 0, 0, GetDate(), GetDate(), 'no user', 
						   @Cia) 

	FETCH NEXT FROM MY_CURSOR INTO @CuentaInterna, @Cia

END

CLOSE MY_CURSOR
DEALLOCATE MY_CURSOR

GO



/* con la instrucción que viene ahora, agregamos a *todos* los MB que ahora *no tienen* una chequera 
   asignada (en teoría todos los movimientos diferentes a CH), la chequera genérica que corresponde 
   a su cuenta (arriba agregamos estas chequeras 'genéricas'; 
   
   sin embargo, creo que el error ocurre más adelante, en otros scripts v088.., porqué hay MB que 
   tienen una chequera asignada (en ClaveUnicaChequera) *pero* esta chequera no existe en Chequeras 
*/ 


Update m Set m.ClaveUnicaChequera = c.NumeroChequera 
	From MovimientosBancarios m Inner Join Chequeras c 
	On m.CuentaInterna = c.NumeroCuenta And m.Cia = c.Cia
	Where m.ClaveUnicaChequera Is Null And c.Generica = 1 

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion
Insert Into tVersion(VersionActual, Fecha) Values('v0.00.288b', GetDate()) 