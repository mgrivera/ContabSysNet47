using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNetWeb.Contab.Consultas_contables.Centros_de_costo
{
    public class Contab_Report_ConsultaCentrosCosto
    {
        public string Moneda { get; set; }
        public string CiaContab { get; set; }
        public string CentroCosto { get; set; }
        public string GrupoContable { get; set; }
        public string CuentaContable { get; set; }
        public DateTime Fecha { get; set; }
        public string NombreCuentaContable { get; set; }
        public string DescripcionPartidaAsiento { get; set; }
        public int NumeroComprobante { get; set; }
        public string Referencia { get; set; }
        public string ProvieneDe { get; set; }
        public decimal Debe { get; set; }
        public decimal Haber { get; set; }
        public decimal Saldo { get; set; }
        
        public List<Contab_Report_ConsultaCentrosCosto> GetContab_Report_ConsultaCentrosCosto()
        {
            List<Contab_Report_ConsultaCentrosCosto> list = new List<Contab_Report_ConsultaCentrosCosto>();
            return list;
        }
    }
}