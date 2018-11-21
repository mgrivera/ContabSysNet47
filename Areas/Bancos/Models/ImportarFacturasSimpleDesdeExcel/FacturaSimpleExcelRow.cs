using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Areas.Bancos.Models.ImportarFacturasSimpleDesdeExcel
{
    public class FacturaSimpleExcelRow
    {
        public string NumeroCliente { get; set; }
        public string NombreCliente { get; set; }
        public string MontoFactura { get; set; }
        public string ConceptoFactura { get; set; }
    }
}