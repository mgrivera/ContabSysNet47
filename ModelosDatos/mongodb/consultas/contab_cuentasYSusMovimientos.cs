using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace ContabSysNet_Web.ModelosDatos.mongodb.consultas
{
    public class contab_cuentasYSusMovimientos
    {
      
        public string _id { get; set; } 
        public int cuentaContableID { get; set; } 
        public string cuentaContable { get; set; } 
        public string nombreCuentaContable { get; set; } 

        public int monedaID { get; set; } 
        public string simboloMoneda { get; set; }
        public int cantidadMovimientos { get; set; } 

        [BsonRepresentation(BsonType.Double, AllowTruncation = true)]   // para evitar que un número superior de decimales cause un error al serializar 
        public decimal saldoInicial { get; set; }
        [BsonRepresentation(BsonType.Double, AllowTruncation = true)]
        public decimal debe { get; set; }
        [BsonRepresentation(BsonType.Double, AllowTruncation = true)]
        public decimal haber { get; set; }
        [BsonRepresentation(BsonType.Double, AllowTruncation = true)]
        public decimal saldoFinal { get; set; }

        public int cia { get; set; } 
        public string user { get; set; }
    }

    public class contab_cuentasYMovimientos_movimientos
    {
        public string _id { get; set; }                             // el _id en esta tabla es un simple string; no es un mongoId()   
        public string registroCuentaContableID { get; set; }        // este es el _id del registro en la tabla 'parent' (que es la anterior a ésta)        
        public DateTime fecha { get; set; } 
        public int numeroAsiento { get; set; } 
        public string tipoAsiento { get; set; } 
        public int monedaOriginalID { get; set; } 
        public string simboloMonedaOriginal { get; set; } 
        public string descripcion { get; set; } 
        public string referencia { get; set; }
        [BsonRepresentation(BsonType.Double, AllowTruncation = true)]   // para evitar que un número superior de decimales cause un error al serializar 
        public decimal debe { get; set; }
        [BsonRepresentation(BsonType.Double, AllowTruncation = true)]  
        public decimal haber { get; set; }
        [BsonRepresentation(BsonType.Double, AllowTruncation = true)]   
        public decimal monto { get; set; } 
        public bool? asientoTipoCierreAnualFlag { get; set; }
        public string user { get; set; }
    }

    // para registrar en una lista los valores tal como los espera el report ... 
    public class contab_cuentasYSusMovimientos_report
    {
        public int numero { get; set; }
        public string moneda { get; set; }
        public string cuentaContable { get; set; }
        public string nombreCuentaContable { get; set; }
        public DateTime? fecha { get; set; }
        public int? numeroAsiento { get; set; }
        public string simboloMonedaOriginal { get; set; }
        public string descripcion { get; set; }
        public string tipoAsiento { get; set; }
        public string referencia { get; set; }
        public bool? asientoTipoCierreAnualFlag { get; set; } 
        public decimal saldoInicial { get; set; }
        public decimal debe { get; set; } 
        public decimal haber { get; set; }
        public decimal saldoFinal { get; set; }

        // aparentemente, un método como éste es necesario para que el report lo pueda 'ver' como un datasource ... 
        public List<contab_cuentasYSusMovimientos_report> get_contab_cuentasYSusMovimientos_report()
        {
            List<contab_cuentasYSusMovimientos_report> list = new List<contab_cuentasYSusMovimientos_report>();
            return list;
        }
    }
}