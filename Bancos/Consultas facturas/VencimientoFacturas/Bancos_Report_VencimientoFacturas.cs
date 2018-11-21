using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Bancos.Consultas_facturas.VencimientoFacturas
{
    public class Bancos_Report_VencimientoFacturas
    {
        public string CxCCxPFlag_Descripcion { get; set; }
        public string SimboloMoneda { get; set; }
        public string NombreCiaContab { get; set; }
        public string NombreCompania { get; set; }
        public string NumeroFactura { get; set; }
        public short NumeroCuota { get; set; }
        public DateTime FechaRecepcion { get; set; }
        public DateTime FechaVencimiento { get; set; }
        public short DiasVencimiento { get; set; }
        public int? DiasPorVencerOVencidos { get; set; }
        public decimal? SaldoPendiente_0 { get; set; }
        public decimal? SaldoPendiente_1 { get; set; }
        public decimal? SaldoPendiente_2 { get; set; }
        public decimal? SaldoPendiente_3 { get; set; }
        public decimal? SaldoPendiente_4 { get; set; }

        public List<Bancos_Report_VencimientoFacturas> GetBancos_Report_VencimientoFacturas()
        {
            List<Bancos_Report_VencimientoFacturas> list = new List<Bancos_Report_VencimientoFacturas>();
            return list;
        }
    }
}