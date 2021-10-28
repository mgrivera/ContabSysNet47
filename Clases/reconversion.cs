using ContabSysNet_Web.ModelosDatos_EF.code_first.contab;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Clases
{
    // esta clase contiene algunos métodos útiles en el proceso de reconversión monetaria           (int Id, string FirstName, string LastName)
    public static class Reconversion
    {
        public struct MonedaNacional_result
        {
            public bool error;
            public string message;
            public Monedas moneda;

            public MonedaNacional_result(bool error, string message, Monedas moneda)
            {
                this.error = error;
                this.message = message;
                this.moneda = moneda; 
            }
        };

        // nota: usamos el ValueTuple para regresar un object, sin definirlo antes 
        public static MonedaNacional_result Get_MonedaNacional()
        {
            // leemos la tabla de monedas para 'saber' cual es la moneda Bs. Nota: la idea es aplicar las opciones de reconversión 
            // *solo* a esta moneda 
            Monedas monedaNacional = null;
            using (var contabContext = new ContabContext())
            {
                monedaNacional = contabContext.Monedas.Where(x => x.NacionalFlag).FirstOrDefault();

                if (monedaNacional == null)
                {
                    string message = "Error al intentar leer la moneda <em>nacional</em> en la tabla <em>Monedas</em>. <br /> " +
                        "No existe una moneda definida como <em>moneda nacional</em>.<br /> " +
                        "Por favor defina alguna de las monedas registradas como <em>moneda nacional</em>.<br /> ";



                    var monedas = new Monedas(); 

                    var result0 = new MonedaNacional_result(true, message, null); 
                    return result0;
                }
            }

            var result = new MonedaNacional_result(false, "", monedaNacional);
            return result;
        }
    }
}