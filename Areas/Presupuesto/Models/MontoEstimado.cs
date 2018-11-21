using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Areas.Presupuesto.Models
{
    public class MontoEstimado
    {
        public string Codigo { get; set; }
        public string Descripcion { get; set; }
        public int Moneda { get; set; }
        public string MonedaSimbolo { get; set; }
        public short Ano { get; set; }

        public decimal? Mes01_Est { get; set; }
        public decimal? Mes02_Est { get; set; }
        public decimal? Mes03_Est { get; set; }
        public decimal? Mes04_Est { get; set; }
        public decimal? Mes05_Est { get; set; }
        public decimal? Mes06_Est { get; set; }
        public decimal? Mes07_Est { get; set; }
        public decimal? Mes08_Est { get; set; }
        public decimal? Mes09_Est { get; set; }
        public decimal? Mes10_Est { get; set; }
        public decimal? Mes11_Est { get; set; }
        public decimal? Mes12_Est { get; set; }
    }

    public class MontoEstimadoEditado
    {
        public string Codigo { get; set; }
        public string Descripcion { get; set; }
        public int Moneda { get; set; }
        public short Ano { get; set; }

        public decimal? Mes01_Est { get; set; }
        public decimal? Mes02_Est { get; set; }
        public decimal? Mes03_Est { get; set; }
        public decimal? Mes04_Est { get; set; }
        public decimal? Mes05_Est { get; set; }
        public decimal? Mes06_Est { get; set; }
        public decimal? Mes07_Est { get; set; }
        public decimal? Mes08_Est { get; set; }
        public decimal? Mes09_Est { get; set; }
        public decimal? Mes10_Est { get; set; }
        public decimal? Mes11_Est { get; set; }
        public decimal? Mes12_Est { get; set; }

        public bool? isNew { get; set; }
        public bool? isEdited { get; set; }
        public bool? isDeleted { get; set; }
    }
}