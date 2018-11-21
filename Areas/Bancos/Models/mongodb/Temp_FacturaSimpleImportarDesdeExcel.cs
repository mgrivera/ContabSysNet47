using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Areas.Bancos.Models.mongodb
{
    public class Temp_FacturaSimpleImportarDesdeExcel
    {
        [BsonId]
        [BsonRepresentation(BsonType.ObjectId)]
        public ObjectId Id { get; set; }

        public int Codigo { get; set; }
        public string Nombre { get; set; }
        public decimal Monto { get; set; }
        public string Descripcion { get; set; }

        public string Usuario { get; set; }
    }
}