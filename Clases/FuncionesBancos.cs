using ContabSysNet_Web.ModelosDatos_EF.Bancos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Clases
{
    public class FuncionesBancos
    {
        BancosEntities _bancosContext; 

        public FuncionesBancos(BancosEntities bancosContext)
        {
            _bancosContext = bancosContext; 
        }

        public bool DeterminarProxNumeroFacturaClientes(int ciaContabSeleccionada, out long numeroFactura, out long numeroControl, out string errorMessage) 
        {
            // NOTA: este código fue tomado originalmente del programa LS (LightSwitch) que permite, justamente, el registo de facturas (ContabSysNetLS) 

            numeroFactura = 0;
            numeroControl = 0;
            errorMessage = ""; 
            
            // Este view selecciona solo items con NumeroFactura numérico (originalmente es string). Además, 
            // regresa esta columna convertida a BigInt 

            // nótese el código que usamos, *solo* por no querer, en este momento, actualizar a EF 6; lo haremos luego, en su momento. 
            // el problema es que ahora no podemos cambiar nuestro modelo y no podemos usar un view que optimizaría lo que sigue ... 


            // leemos todas las facturas ... 
            var query0 = _bancosContext.Facturas.Where(f => f.Cia == ciaContabSeleccionada && f.CxCCxPFlag == 2).
                                                 Select(f => new { FechaEmision = f.FechaEmision, NumeroFactura = f.NumeroFactura, NumeroControl = f.NumeroControl }).
                                                 ToList();

            // en linq to objects sí podemos obtener la factura más reciente 
            var query = query0.Where(f => IsNumber(f.NumeroFactura)).OrderByDescending(f => f.FechaEmision).ThenByDescending(f => f.NumeroFactura).FirstOrDefault(); 

            long i; 

            if (query != null)
            {
                numeroFactura = Convert.ToInt64(query.NumeroFactura) + 1;

                // solo chequeamos que fuera numérico el número de factura 
                if (Int64.TryParse(query.NumeroControl, out i))
                    numeroControl = i + 1;
                else
                    numeroControl = 1;
            }
            else
            {
                numeroFactura = 1;
                numeroControl = 1;
            }

            // buscamos un documento con el mismo número; si existe, fallamos y lo notificamos al usuario 

            // si el documento es del tipo CxP, el número se puede repetir, más no por compañía 
            // si el documento es del tipo CxC, no se puede repetir, en la misma Cia Contab ... 

            string numeroFacturaString = numeroFactura.ToString(); 

            var factura = _bancosContext.Facturas.Where(f => f.CxCCxPFlag == 2 && 
                                                             f.NumeroFactura == numeroFacturaString && 
                                                             f.Compania.Numero == ciaContabSeleccionada).
                                                  FirstOrDefault();

                

            if (factura != null)
            {
                errorMessage = 
                "Error al intentar determinar un número para el documento, pues los números para documentos (de este tipo) que se han registrado para esta compañía, " +
                "*no son* consecutivos en el tiempo.<br />" +
                "Error al intentar asignar el número " + numeroFactura.ToString() + " a la factura que se " +
                "está registrando, pues ya existe una factura, de fecha " + factura.FechaEmision.ToString("d-MMM-yy") +
                " y para la compañía " + factura.Proveedore.Nombre + " " +
                "con ese mismo número.<br />" +
                "Ud. puede consultar los documentos de este tipo para esta compañía y " +
                "corroborar esta situación.<br />" +
                "Ud. puede, también, asignar un número a este documento y evitar así " +
                "la ocurrencia de esta situación.";

                return false; 
            }

            return true; 
        }

        private static bool IsNumber(string value)
        {
            // static method just to test if a string is a nummber ... 
            int n;
            return int.TryParse(value, out n);
        }
    }
}