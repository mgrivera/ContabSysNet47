/*    Miercoles, 28 de Mayo del 2003   -   v0.00.151.sql 

	Agregamos un registro a la tabla FormatosDecheque. 

*/ 


Insert Into FormatosDeCheque (Numero, Descripcion, ReporteAccess, SeleccionadoFlag) Values 
(14, 'Banesco Bs. - Epson LQ570+', 'rChequeBanescoBsEpsonLQ570', 0) 

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.151', GetDate()) 

