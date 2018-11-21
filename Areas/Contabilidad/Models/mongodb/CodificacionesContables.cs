
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MongoDB.Bson.Serialization.Attributes;

namespace ContabSysNet_Web.Areas.Contabilidad.Models.mongodb
{
    // clases para representar el registro de los códigos condi en mongodb 
    public class CodificacionesContables_codigos
    {
        [BsonId]
        public string _id { get; set; }
        public string codificacionContable_ID { get; set; }
        public string codigo { get; set; }
        public string descripcion { get; set; }
        public bool detalle { get; set; }
        public bool suspendido { get; set; }
        public int cia { get; set; }
    }

    public class CodificacionesContables_codigos_cuentasContables
    {
        [BsonId]
        public string _id { get; set; }
        public string codificacionContable_ID { get; set; }
        public string codigoContable_ID { get; set; }
        public int id { get; set; }
        public int cia { get; set; }
    }
}