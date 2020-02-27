/*    Jueves, 29 de Junio de 2.006   -   v0.00.193.sql 

	Hacemos algunas correcciones (de cierta importancia) al proceso que 
	construye los Comprobantes Seniat para las facturas de proveedores. 

*/ 

--  Nota: no hay cambios a la base de datos con esta versión


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.193', GetDate()) 