using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace ContabSysNet_Web.ModelosDatos.mongodb.consultas
{
    public class bancos_cajaChica_reposiciones_webReport
    {
        public string id { get; set; }
        public int reposicion { get; set; }
        public DateTime fecha { get; set; }
        public string cajaChica { get; set; } 
        public string observaciones { get; set; } 
        public string estadoActual { get; set; }
        public List<bancos_cajaChica_reposiciones_gastos_webReport> gastos { get; set; }
        public string user { get; set; }

        // aparentemente, un método como éste es necesario para que el report (ssrs) lo pueda 'ver' como un datasource ... 
        public List<bancos_cajaChica_reposiciones_webReport> get_bancos_cajaChica_reposiciones_webReport()
        {
            List<bancos_cajaChica_reposiciones_webReport> list = new List<bancos_cajaChica_reposiciones_webReport>();
            return list;
        }
    }

    // para registrar en una lista los valores tal como los espera el report ... 
    public class bancos_cajaChica_reposiciones_gastos_webReport
    {
        public string id { get; set; }
        public int gastoID { get; set; }
        public int reposicion { get; set; }
        public int rubro { get; set; }
        public string nombreRubro { get; set; }
        public string descripcion { get; set; }
        public DateTime? fechaDocumento { get; set; }
        public string numeroDocumento { get; set; }
        public string numeroControl { get; set; }
        public string proveedor { get; set; }
        public string nombre { get; set; }
        public string rif { get; set; }

        [BsonRepresentation(BsonType.Double, AllowTruncation = true)]
        public decimal? montoNoImponible { get; set; }
        [BsonRepresentation(BsonType.Double, AllowTruncation = true)]
        public decimal monto { get; set; }
        [BsonRepresentation(BsonType.Double, AllowTruncation = true)]
        public decimal? ivaPorc { get; set; }
        [BsonRepresentation(BsonType.Double, AllowTruncation = true)]
        public decimal? iva { get; set; }
        [BsonRepresentation(BsonType.Double, AllowTruncation = true)]
        public decimal total { get; set; }

        public bool afectaLibroCompras { get; set; }
        public string nombreUsuario { get; set; }
        public string cuentaContable { get; set; }

        // aparentemente, un método como éste es necesario para que el report (ssrs) lo pueda 'ver' como un datasource ... 
        public List<bancos_cajaChica_reposiciones_gastos_webReport> get_bancos_cajaChica_reposiciones_gastos_webReport()
        {
            List<bancos_cajaChica_reposiciones_gastos_webReport> list = new List<bancos_cajaChica_reposiciones_gastos_webReport>();
            return list;
        }
    }
}