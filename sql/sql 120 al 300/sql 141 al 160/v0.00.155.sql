/*    Viernes, 31 de Julio del 2003   -   v0.00.155.sql 

	Agregamos un formato de cheques a la tabla FormatosDeCheque. 

*/ 

Insert Into FormatosDeCheque (Numero, Descripcion, ReporteAccess, SeleccionadoFlag) Values
(15, 'Provincial Bs. - Epson LQ-570+', 'rChequeProvincialBsEpsonLQ570', 0) 

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.155', GetDate()) 

