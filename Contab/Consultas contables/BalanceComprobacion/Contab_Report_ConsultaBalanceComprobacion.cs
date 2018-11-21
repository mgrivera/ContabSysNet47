using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNetWeb.Contab.Consultas_contables.BalanceComprobacion
{
    public class Contab_Report_ConsultaBalanceComprobacion
    {
        public string NombreCiaContab { get; set; }
        public string NombreMoneda { get; set; }
        public string SimboloMoneda { get; set; }
        public string NombreGrupoContable { get; set; }
        public int OrdenGrupoContable { get; set; }
        public string CuentaContable { get; set; }
        public string CuentaContableEditada { get; set; }
        public string CuentaContable_Nombre { get; set; }
        public string CuentaContable_NivelPrevio { get; set; }
        public string CuentaContable_NivelPrevio_Descripcion { get; set; }

        public string nivel1 { get; set; }
        public string nivel2 { get; set; }
        public string nivel3 { get; set; }
        public string nivel4 { get; set; }
        public string nivel5 { get; set; }
        public string nivel6 { get; set; }

        public decimal? SaldoAnterior { get; set; }
        public decimal? Debe { get; set; }
        public decimal? Haber { get; set; }
        public decimal? SaldoActual { get; set; }
        public int? CantidadMovimientos { get; set; }

        public List<Contab_Report_ConsultaBalanceComprobacion> GetContab_Report_ConsultaBalanceComprobacion()
        {
            List<Contab_Report_ConsultaBalanceComprobacion> list = new List<Contab_Report_ConsultaBalanceComprobacion>();
            return list;
        }
    }
}