/*    
	  Lunes, 25 de Octubre de 2.021  
	  
	  Para reconvertir los montos en las tablas de la nómina 
*/


/* Reconvertimos los sueldos */
Update s 
Set s.Sueldo = Round( (s.Sueldo / 1000000), 2 )  
From Empleados_Sueldo s Inner Join tEmpleados e On s.Empleado = e.Empleado 
Inner Join Companias c On c.Numero = e.Cia 

Where c.Numero = 37 


/* Reconvertimos los rubros asignados */
Update r 
Set r.MontoAAplicar = Round( (r.MontoAAplicar / 1000000), 2 ) 

From tRubrosAsignados r Inner Join tEmpleados e On r.Empleado = e.Empleado 
Inner Join tMaestraRubros m On m.Rubro = r.Rubro 
Inner Join Companias c On c.Numero = e.Cia 

Where c.Numero = 37 