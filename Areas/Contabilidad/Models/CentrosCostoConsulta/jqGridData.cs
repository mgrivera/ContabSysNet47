using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Areas.Contabilidad.Models.CentrosCostoConsulta
{
    public class jqGridData
    {
        public int total { get; set; }
        public int page { get; set; }
        public int records { get; set; }

        public List<jqGridDataRow> rows { get; set; }
    }

    public class jqGridDataRow
    {
        public int id { get; set; }
        public string moneda { get; set; }
        public string centroCosto { get; set; }
        public string cuentaContable { get; set; }
        public string nombreCuentaContable { get; set; }

        public int sequencia { get; set; }
        public DateTime fecha { get; set; }
        public string descripcion { get; set; }
        public decimal saldoInicial { get; set; }
        public decimal debe { get; set; }
        public decimal haber { get; set; }
        public decimal saldoActual { get; set; }
    }
}