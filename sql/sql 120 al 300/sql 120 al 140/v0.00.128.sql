/*    Miercoles, 13 de Agosto de 2002   -   v0.00.128.sql 

	Actualizamos el contenido de la tabla FormatosDeCheque. 

*/ 


Delete From FormatosDeCheque Where ReporteAccess = 'rChequeCitibank$2EpsonLQ570'

Insert Into FormatosDeCheque (Numero, Descripcion, ReporteAccess, SeleccionadoFlag) Values 
(13, 'Citibank $ 2  - Epson LQ-570+', 'rChequeCitibank$2EpsonLQ570', 0)

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.128', GetDate()) 
