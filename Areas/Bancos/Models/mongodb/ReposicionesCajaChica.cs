using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Areas.Bancos.Models.mongodb
{
    public class ReposicionCajaChica
    {
        // nótese como el Id puede ser null; cuando recibimos una reposición que el usuario ha recién agregado, su Id es null; 
        // cuando la graba a mongo, el Id es asignado por mongo. 

        //[BsonId]
        //[BsonRepresentation(BsonType.ObjectId)]
        public string Id { get; set; }

        public int? ReposicionID { get; set; }
        public DateTime Fecha { get; set; }
        public int CajaChicaID { get; set; }
        public string Observaciones { get; set; }
        public string Estado { get; set; }
        public int CiaContabID { get; set; }
        public string Usuario { get; set; }

        public List<ReposicionCajaChica_Gasto> Gastos { get; set; }

        public ReposicionCajaChica()
        {
            this.Gastos = new List<ReposicionCajaChica_Gasto>(); 
        }
    }

    public class ReposicionCajaChica_Gasto
    {
        public string Id { get; set; }
        public int RubroID { get; set; }
        public string Descripcion { get; set; }
        public DateTime FechaDoc { get; set; }
        public string NumeroDoc { get; set; }
        public string NumeroControl { get; set; }
        public int? ProveedorID { get; set; }
        public string Proveedor2 { get; set; }
        public string Rif { get; set; }
        public decimal? MontoNoImponible { get; set; }
        public decimal MontoImponible { get; set; }
        public decimal? IvaPorc { get; set; }
        public decimal? Iva { get; set; }
        public decimal Total { get; set; }
        public bool AfectaLibroCompras { get; set; }
    }
}