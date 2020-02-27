/*    Miercoles, 11 de Marzo de 2.005   -   v0.00.172.sql 

	Agregamos las tablas y consultas que corresponden a la forma de mantenimineto 
	de las prestaciones sociales 

*/ 




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.172', GetDate()) 

