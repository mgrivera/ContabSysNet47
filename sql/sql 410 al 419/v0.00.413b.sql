/*    
	  Miércoles, 12 de Junio de 2.019  -   v0.00.413b.sql 
	  
	  Modificamos muy levemente el sp BalanceGeneral para que no seleccione 
	  asientos automáticos de cierre anual, pero *solo* los automáticos y no 
	  otros que el usuario pueda registrar. Nótese que asumimos que debe haber 
	  *solo* dos tipos de asientos de cierre anual: los del mes 12, automáticos, y 
	  los del mes 13, verdaderos asientos de cierre anual, pero registrados por
	  el usuario. 
*/


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.413b', GetDate()) 


