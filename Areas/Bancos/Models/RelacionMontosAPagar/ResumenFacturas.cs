using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Areas.Bancos.Models.RelacionMontosAPagar
{
    public class ResumenFacturas
    {
        public string tipoRegistro { get; set; }
        public int companiaID { get; set; }
        public string compania { get; set; }
        public int cantidadFacturasAPagar { get; set; }
        public string tipoPersona { get; set; }
        public string numeroRif { get; set; } 
        public string nombreBeneficiario { get; set; }
        public string referenciaOperacion { get; set; }
        public string descripcionOperacion { get; set; }
        public string modalidadPago { get; set; }
        public string numeroCuentaBancaria { get; set; }
        public string codigoBanco { get; set; }
        public DateTime fechaValor { get; set; }
        public decimal monto { get; set; }
        public string moneda { get; set; }
        public decimal impuestoRetenido { get; set; }
        public string email { get; set; }
        public string celular { get; set; }
    }
}