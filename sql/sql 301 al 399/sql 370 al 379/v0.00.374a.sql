/*    Miércoles, 8 de Abril de 2.015 	-  v0.00.374a.sql 

	Asientos: agregamos tabla Asientos_Log, para agregar item cuando el usuario modifica 
	agrega un asiento; agregamos 'trigger' para que se registre este item en esta tabla, 
	cuando el usuario modifica un asiento 
*/


--  Insert trigger en Asientos

CREATE TRIGGER Asientos_Insert
   ON  Asientos
   AFTER Insert
AS 
BEGIN
	
	SET NOCOUNT ON;
	Insert Into Asientos_Log (NumeroAutomatico, NumeroAsiento, FechaAsiento, Usuario, FechaOperacion, DescripcionOperacion) 
	Select NumeroAutomatico, Numero, Fecha, Usuario, GetDate(), 'creado' From inserted; 
    
END
GO

--  Update trigger en Asientos

CREATE TRIGGER Asientos_Update
   ON  Asientos
   AFTER Update
AS 
BEGIN
	
	SET NOCOUNT ON;
	Insert Into Asientos_Log (NumeroAutomatico, NumeroAsiento, FechaAsiento, Usuario, FechaOperacion, DescripcionOperacion) 
	Select NumeroAutomatico, Numero, Fecha, Usuario, GetDate(), 'modificado' From inserted; 
    
END
GO

--  Delete trigger en Asientos

CREATE TRIGGER Asientos_Delete
   ON  Asientos
   AFTER Delete
AS 
BEGIN
	
	SET NOCOUNT ON;
	Insert Into Asientos_Log (NumeroAutomatico, NumeroAsiento, FechaAsiento, Usuario, FechaOperacion, DescripcionOperacion) 
	Select NumeroAutomatico, Numero, Fecha, Usuario, GetDate(), 'eliminado' From deleted; 
    
END
GO


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.374a', GetDate()) 