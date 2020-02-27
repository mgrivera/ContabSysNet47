/*    Lunes, 29 de Agosto de 2.005   -   v0.00.180b.sql 

	Cambios proceso Vacaciones: agregamos el item: NumeroVacaciones y eliminamos 
	los items: AnoVacacionesDesde, AnoVacacionesHasta 

*/ 


Alter Table Vacaciones Alter Column AnoVacaciones smallint Not NULL
Alter Table Vacaciones Alter Column NumeroVacaciones tinyint Not NULL

Alter Table Vacaciones Drop Column AnoVacacionesDesde
Alter Table Vacaciones Drop Column AnoVacacionesHasta

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.180b', GetDate()) 