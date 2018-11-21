using MongoDB.Bson;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Areas.Bancos.Models.mongodb
{
    public class Compania_mongodb
    {
        public int Id { get; set; }             // nótese que usamos nuestro propio _id 
        public List<CuentaBancaria> cuentasBancarias { get; set; }

        public Compania_mongodb() 
        { 
            this.cuentasBancarias = new List<CuentaBancaria>(); 
        }
    }

    public class CuentaBancaria
    {
        public ObjectId Id { get; set; }
        public string numero { get; set; }
        public int banco { get; set; }
        public string tipo { get; set; }
        public bool isDefault { get; set; }
    }
}