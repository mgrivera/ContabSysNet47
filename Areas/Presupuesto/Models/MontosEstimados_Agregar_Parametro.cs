using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Areas.Presupuesto.Models
{
    public class MontosEstimados_Agregar_Parametro
    {
        public short Ano { get; set; }
        public int MonedaID { get; set; }
        public int? AnoCopiarDesde { get; set; }
        public string MontosEjecutadosEstimados { get; set; }
        public bool? ActualizarMontosSiExisten { get; set; }
        public int CiaContabSeleccionada { get; set; }
    }
}