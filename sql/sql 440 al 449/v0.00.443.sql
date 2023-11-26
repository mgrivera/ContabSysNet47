/*    
	  Lunes, 19 de Junio de 2.023  -   v0.00.443.sql 
	  
	  Agregamos el query q_bancos_cierre_registros
*/


CREATE VIEW q_bancos_cierre_registros
AS
SELECT reg.id, reg.periodoCierreId, reg.moneda, Monedas.Simbolo as monedaSimbolo, 
				  reg.compania, Proveedores.Abreviatura as companiaAbreviatura, 
                  reg.tipo1, reg.tipo2, reg.manAuto, reg.fecha, reg.referencia, reg.orden, 
                  reg.descripcion, reg.monto, reg.fechaCreacion, reg.fechaUltModificacion, reg.usuario, 
                  reg.cia, cia.NombreCorto as ciaContabNombreCorto, cia.Abreviatura AS ciaContabAbreviatura
FROM bancos_cierre_registros reg Inner Join Proveedores On reg.compania = Proveedores.Proveedor
Inner Join Monedas On reg.moneda = Monedas.Moneda 
Inner Join Companias cia On reg.cia = cia.Numero

GO







/****** Object:  View q_bancos_cierre_registros    Script Date: 6/24/23 12:09:53 PM ******/
DROP VIEW q_bancos_cierre_registros
GO

/****** Object:  View q_bancos_cierre_registros    Script Date: 6/24/23 12:09:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*    
	  Lunes, 19 de Junio de 2.023  -   v0.00.443.sql 
	  
	  Agregamos el query q_bancos_cierre_registros
*/


CREATE VIEW q_bancos_cierre_registros
AS
SELECT reg.id, reg.periodoCierreId, reg.moneda, Monedas.Simbolo as monedaSimbolo, 
				  Monedas.Descripcion as monedaDescripcion, 
				  reg.compania, Proveedores.Abreviatura as companiaAbreviatura, 
				  Proveedores.Nombre as companiaNombre, 
                  reg.tipo1, reg.tipo2, reg.manAuto, reg.fecha, reg.referencia, reg.orden, 
                  reg.descripcion, reg.monto, reg.fechaCreacion, reg.fechaUltModificacion, reg.usuario, 
                  reg.cia, cia.NombreCorto as ciaContabNombreCorto, cia.Abreviatura AS ciaContabAbreviatura
FROM bancos_cierre_registros reg Inner Join Proveedores On reg.compania = Proveedores.Proveedor
Inner Join Monedas On reg.moneda = Monedas.Moneda 
Inner Join Companias cia On reg.cia = cia.Numero

GO

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.443', GetDate()) 