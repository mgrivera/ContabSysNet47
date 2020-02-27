/*    Viernes, 18 de mayo de 2.007   -   v0.00.207.sql 

	Corregimos un error leve en el filtro de movimientos bancarios 
	*** sin cambios a la base de datos - solo correcciones en el código *** 

*/ 



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.207', GetDate()) 