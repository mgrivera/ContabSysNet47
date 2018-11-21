using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Areas.Contabilidad.Models
{
    public class ProgresoTareaEnCurso
    {
        public int? Val { get; set; }
        public int? Max { get; set; }
        public string Message { get; set; }
    }
}