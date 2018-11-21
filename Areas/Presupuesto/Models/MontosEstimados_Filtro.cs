using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Areas.Presupuesto.Models
{
    public class MontosEstimados_Filtro
    {
        public string Codigo { get; set; }
        public string Descripcion { get; set; }
        public List<int> Anos { get; set; }
        public List<MontosEstimados_Filtro_Moneda> Monedas { get; set; }
        public int Cia { get; set; }
    }

    public class MontosEstimados_Filtro_Moneda 
    {
        public int Moneda { get; set; }
        public string Descripcion { get; set; }
        public string Simbolo { get; set; }
    }
}