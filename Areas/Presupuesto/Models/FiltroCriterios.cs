using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Areas.Presupuesto.Models
{
    public class FiltroCriterios
    {
        public string Codigo { get; set; }
        public string Descripcion { get; set; }
        public short? CantNiveles { get; set; }
        public string Grupo { get; set; }
        public string Suspendido { get; set; }
    }
}