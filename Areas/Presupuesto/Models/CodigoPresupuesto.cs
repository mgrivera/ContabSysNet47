using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Areas.Presupuesto.Models
{
    public class CodigoPresupuesto
    {
        public string Codigo { get; set; }
        public string Descripcion { get; set; } 
        public int CantNiveles { get; set; } 
        public bool GrupoFlag { get; set; } 
        public bool SuspendidoFlag { get; set; }

        public List<CodigoPresupuesto_CuentaContable> CuentasContables { get; set; }

        public CodigoPresupuesto()
        {
            this.CuentasContables = new List<CodigoPresupuesto_CuentaContable>(); 
        }
    }

    public class CodigoPresupuesto_CuentaContable 
    {
        public int ID { get; set; }
        public string Cuenta { get; set; }
        public string Descripcion { get; set; }
    }
}