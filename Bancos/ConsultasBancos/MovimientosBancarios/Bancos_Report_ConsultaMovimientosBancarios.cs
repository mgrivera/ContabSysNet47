using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Bancos.ConsultasBancos.MovimientosBancarios
{
    public class Bancos_Report_ConsultaMovimientoBancario
    {
        public string NombreMoneda { get; set; }
        public string NombreCiaContab { get; set; }
        public Int64 Transaccion { get; set; }
        public string Tipo { get; set; }
        public DateTime Fecha { get; set; }
        public string NombreBanco { get; set; }
        public string CuentaBancaria { get; set; }
        public string Beneficiario { get; set; }
        public string Concepto { get; set; }
        public decimal Monto { get; set; }
        public DateTime? FechaEntregado { get; set; }

        public List<Bancos_Report_ConsultaMovimientoBancario> GetBancos_Report_ConsultaMovimientosBancarios()
        {
            List<Bancos_Report_ConsultaMovimientoBancario> list = new List<Bancos_Report_ConsultaMovimientoBancario>();
            return list;
        }
    }
}