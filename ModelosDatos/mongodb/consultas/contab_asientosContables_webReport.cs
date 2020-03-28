using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace ContabSysNet_Web.ModelosDatos.mongodb.consultas
{
    public class contab_asientosContables_webReport
    {
        public string id { get; set; } 
        public string nombreMoneda { get; set; } 
        public string simboloMoneda { get; set; } 
        public DateTime fecha { get; set; }
        public int numero { get; set; }
        public string descripcionComprobante { get; set; }
        public int numeroPartida { get; set; } 
        public string cuentaContable { get; set; } 
        public string cuentaEditada { get; set; } 
        public string nombreCuenta { get; set; } 
        public string descripcionPartida { get; set; } 
        public string referencia { get; set; } 

        [BsonRepresentation(BsonType.Double, AllowTruncation = true)]
        public decimal debe { get; set; }
        [BsonRepresentation(BsonType.Double, AllowTruncation = true)]
        public decimal haber { get; set; }
        [BsonRepresentation(BsonType.Double, AllowTruncation = true)]
        public decimal monto { get; set; }

        public string user { get; set; }

        // aparentemente, un método como éste es necesario para que el report (ssrs) lo pueda 'ver' como un datasource ... 
        public List<contab_asientosContables_webReport> get_contab_asientosContables_webReport()
        {
            List<contab_asientosContables_webReport> list = new List<contab_asientosContables_webReport>();
            return list;
        }
    }

    public class contab_asientosContables_webReport_config
    {
        public string id { get; set; }
        public contab_asientosContables_webReport_config2 reportConfig { get; set; }
        public string user { get; set; }
    }

    // para registrar en una lista los valores tal como los espera el report ... 
    public class contab_asientosContables_webReport_config2
    {
        public DateTime desde { get; set; }
        public DateTime hasta { get; set; }
        public DateTime? fecha { get; set; }
        public bool saltoPaginaPorFecha { get; set; }
        public bool unaColumnaParaDebeYHaber { get; set; }
        public bool versionPdf { get; set; }
        public string titulo { get; set; }
        public int ciaNumero { get; set; }
        public string ciaNombre { get; set; }
    }
}