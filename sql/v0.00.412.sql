/*    
	  Lunes, 16 de Mayo de 2.019  -   v0.00.412.sql 
	  
	  Cambiamos el tipo de la columna UltAct a datetime2 en UltimoMesCerrado y UltimoMesCerradoContab
*/


Alter Table Chequeras Alter Column Ingreso datetime2 not null
Alter Table Chequeras Alter Column UltAct datetime2 not null

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.412', GetDate()) 
