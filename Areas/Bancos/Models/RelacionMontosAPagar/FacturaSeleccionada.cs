using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Areas.Bancos.Models.RelacionMontosAPagar
{
    public class FacturaSeleccionada
    {
        public bool selected { get; set; }
        public int companiaID { get; set; }
        public string compania { get; set; }
        public DateTime fechaRecepcion { get; set; }
        public string numeroFactura { get; set; }
        public string numeroControl { get; set; }
        public string concepto { get; set; }
        public decimal montoNoImponible { get; set; }
        public decimal montoImponible { get; set; }
        public decimal Iva { get; set; }
        public decimal totalFactura { get; set; }
        public decimal impuestoRetenido { get; set; }
        public decimal retencionSobreIva { get; set; }
        public decimal totalAPagar { get; set; }
        public decimal montoPagado { get; set; }
        public decimal montoAPagar { get; set; }
    }

    public class ConstruirExcelCollections
    {
        public List<FacturaSeleccionada> FacturasSeleccionadas_List { get; set; }
        public List<ResumenFacturas> ResumenFacturas_List { get; set; }
    }
}