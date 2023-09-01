/*    
	  Lunes, 8 de Noviembre de 2.021  -   v0.00.433.sql 
	  
	  Modificamos el stored procedure spBalanceGeneral para adaptarla a la reconversión 
	  en Oct/2021 
*/

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.433c', GetDate()) 