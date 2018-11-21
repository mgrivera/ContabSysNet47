using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Areas.Bancos.Models.mongodb
{
    public class Compania_mongo
    {
        public int Id { get; set; }             // nótese que usamos nuestro propio _id 
        public string nombre { get; set; }
        public string abreviatura { get; set; }
    }
}