/*    
	  Lunes, 15 de Abril de 2.019  -   v0.00.411.sql 
	  
	  Cambiamos el tipo de la columna UltAct a datetime2 en UltimoMesCerrado y UltimoMesCerradoContab
*/


Alter Table UltimoMesCerrado Alter Column UltAct datetime2 not null
Alter Table UltimoMesCerradoContab Alter Column UltAct datetime2 not null

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.411', GetDate()) 
