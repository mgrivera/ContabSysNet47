using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Areas.Presupuesto.Models
{
    public class CodigoPresupuestoEditado
    {
        public string CodigoOriginal { get; set; }

        [Required(ErrorMessage="El código de presupuesto debe contener un valor")]
        public string Codigo { get; set; }

        [Required(ErrorMessage = "La descripción del código de presupuesto debe contener un valor")]
        public string Descripcion { get; set; }

        [Required(ErrorMessage = "Se debe indicar un valor para la cantidad de niveles del código de presupuesto")]
        public short? CantNiveles { get; set; }

        [Required(ErrorMessage = "Un código de presupuesto debe o no ser un grupo")]
        public bool? Grupo { get; set; }

        [Required(ErrorMessage = "Un código de presupuesto debe o no estar suspendido")]
        public bool? Suspendido { get; set; }

        public bool? isNew { get; set; }
        public bool? isEdited { get; set; }
        public bool? isDeleted { get; set; }

        public List<CodigoPresupuesto_CuentaContable> CuentasContables { get; set; }

        public CodigoPresupuestoEditado()
        {
            this.CuentasContables = new List<CodigoPresupuesto_CuentaContable>(); 
        }
    }

    public class CodigoPresupuestoEditado_CuentaContable
    {
        [Required(ErrorMessage = "Toda cuenta contable debe poseer un identificador (ID) que lo identifique en forma única.")]
        public int ID { get; set; }
        public string Cuenta { get; set; }
        public string Descripcion { get; set; }
    }
}