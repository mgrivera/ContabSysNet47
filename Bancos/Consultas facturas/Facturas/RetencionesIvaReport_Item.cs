using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Bancos.Consultas_facturas.Facturas
{
    public class RetencionesIvaReport_Item
    {
        public string CiaContab_Nombre { get; set; }
        public string CiaContab_Rif { get; set; }

        public string NumeroDocumento { get; set; }
        public string Compania_Nombre { get; set; }

        public DateTime? FechaEmision { get; set; }
        public DateTime? FechaRecepcion { get; set; }
        public string TipoAlicuota { get; set; }
        public decimal TotalComprasIncIva { get; set; }
        public decimal MontoNoImponible { get; set; }
        public decimal MontoImponible { get; set; }
        public decimal IvaPorc { get; set; }
        public decimal Iva { get; set; }

        public string ComprobanteSeniat { get; set; }

        public decimal RetencionIvaPorc { get; set; }
        public decimal RetencionIva { get; set; }


        public List<RetencionesIvaReport_Item> Get_RetencionesIvaReport()
        {
            List<RetencionesIvaReport_Item> list = new List<RetencionesIvaReport_Item>();
            return list;
        }
    }
}