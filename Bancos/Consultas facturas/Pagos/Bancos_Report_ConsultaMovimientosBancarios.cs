using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Bancos.ConsultasFacturas.Pagos
{
    public class Bancos_Report_ConsultaPago
    {
        public string NombreMoneda { get; set; }
        public string NombreCiaContab { get; set; }
        public DateTime Fecha { get; set; }
        public string NombreCompania { get; set; }
        public string NumeroPago { get; set; }
        public string MiSu { get; set; }
        public string Concepto { get; set; }
        public decimal Monto { get; set; }

        public List<Bancos_Report_ConsultaPago> GetBancos_Report_ConsultaPago()
        {
            List<Bancos_Report_ConsultaPago> list = new List<Bancos_Report_ConsultaPago>();
            return list;
        }
    }
}