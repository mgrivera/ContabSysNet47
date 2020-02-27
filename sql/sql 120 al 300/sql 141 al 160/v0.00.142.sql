/*    Lunes 21 de octubre de 2002   -   v0.00.142.sql 

	Hacemos un ajuste leve al view qListadoEntradas. También al view qListadoEmpleados

*/ 



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoEntradas]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoEntradas]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qListadoEntradas    Script Date: 28/11/00 07:01:23 p.m. *****
***** Object:  View dbo.qListadoEntradas    Script Date: 08/nov/00 9:01:18 *****
***** Object:  View dbo.qListadoEntradas    Script Date: 30/sep/00 1:10:02 ******/
CREATE VIEW dbo.qListadoEntradas
AS
SELECT     dbo.Entradas.ClaveUnica, dbo.Entradas.Producto, dbo.Productos.Descripcion AS NombreProducto, dbo.Entradas.Fecha, dbo.Entradas.Cantidad, 
                      dbo.Entradas.Comentarios, dbo.Entradas.Ingreso, dbo.Entradas.UltAct, dbo.Entradas.Usuario, dbo.Entradas.Cia
FROM         dbo.Entradas LEFT OUTER JOIN
                      dbo.Productos ON dbo.Entradas.Producto = dbo.Productos.Producto

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


--  ------------------------
--  qListadoEmpleados
--  ------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoEmpleados]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoEmpleados]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoEmpleados
AS
SELECT     dbo.tEmpleados.Empleado, dbo.tEmpleados.Departamento, dbo.tDepartamentos.Descripcion AS NombreDepartamento, dbo.tEmpleados.Cargo, 
                      dbo.tCargos.Descripcion AS NombreCargo, dbo.tEmpleados.Cedula, dbo.tEmpleados.Nombre, dbo.tEmpleados.FechaNacimiento, 
                      dbo.tEmpleados.FechaIngreso, dbo.tEmpleados.FechaRetiro, dbo.tEmpleados.SueldoPromedio, dbo.tEmpleados.SueldoBasico, 
                      dbo.tEmpleados.Status, dbo.tEmpleados.EdoCivil, dbo.tEmpleados.Sexo, dbo.tEmpleados.Nacionalidad, dbo.tEmpleados.PaisOrigen, 
                      dbo.tEmpleados.CiudadOrigen, dbo.tEmpleados.DireccionHabitacion, dbo.tEmpleados.Telefono1, dbo.tEmpleados.Telefono2, 
                      dbo.tEmpleados.SituacionActual, dbo.tEmpleados.Banco, dbo.tEmpleados.CuentaBancaria, dbo.tEmpleados.Contacto1, dbo.tEmpleados.Parentesco1, 
                      dbo.tEmpleados.TelefonoCon1, dbo.tEmpleados.Contacto2, dbo.tEmpleados.Parentesco2, dbo.tEmpleados.TelefonoCon2, dbo.tEmpleados.Contacto3, 
                      dbo.tEmpleados.Parentesco3, dbo.tEmpleados.TelefonoCon3, dbo.tEmpleados.TipoCuenta, dbo.tEmpleados.EmpleadoObreroFlag, 
                      dbo.tEmpleados.Cia
FROM         dbo.tEmpleados LEFT OUTER JOIN
                      dbo.tCargos ON dbo.tEmpleados.Cargo = dbo.tCargos.Cargo LEFT OUTER JOIN
                      dbo.tDepartamentos ON dbo.tEmpleados.Departamento = dbo.tDepartamentos.Departamento

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.142', GetDate()) 

