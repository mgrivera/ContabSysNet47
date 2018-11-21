using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Bancos.Consultas_facturas.Facturas
{
    public class Factura_LibroCompra
    {
        public string CiaContab_Nombre { get; set; }
        public string CiaContab_Rif { get; set; }

        public DateTime? FechaDocumento { get; set; }
        public string NumeroDocumento { get; set; }
        public string NumeroControl { get; set; }
        public string Compania_Nombre { get; set; }
        public string Compania_Rif { get; set; }
        public string Compra_NotaCredito { get; set; }
        public string TipoDocumento { get; set; }
        public string DocumentoAfectado { get; set; }
        public string ComprobanteSeniat { get; set; }
        public string Importacion_CompraNacional { get; set; }
        public string PlanillaImportacion { get; set; }

        public decimal TotalComprasIncIva { get; set; }
        public decimal MontoNoImponible { get; set; }
        public decimal MontoImponible { get; set; }
        public decimal IvaPorc { get; set; }
        public decimal Iva { get; set; }
        public decimal RetencionIvaPorc { get; set; }
        public decimal RetencionIva { get; set; }


        public List<Factura_LibroCompra> GetFactura_LibroCompras()
        {
            List<Factura_LibroCompra> list = new List<Factura_LibroCompra>();
            return list;
        }
    }



    public class Factura_ConsultaGeneral
    {
        public string MonedaNombre { get; set; }
        public string MonedaSimbolo { get; set; }

        public string CiaContab_Nombre { get; set; }

        public string CxPCxC_Literal { get; set; }

        public string Compania_Nombre { get; set; }
        public string Compania_Abreviatura { get; set; }

        public string NumeroDocumento { get; set; }
        public string NumeroControl { get; set; }

        public DateTime FechaEmision { get; set; }
        public DateTime FechaRecepcion { get; set; }

        public string NombreTipo { get; set; }
        public string Concepto { get; set; }
        
        public decimal MontoNoImponible { get; set; }
        public decimal MontoImponible { get; set; }

        public decimal IvaPorc { get; set; }
        public decimal Iva { get; set; }
        public decimal? OtrosImpuestos { get; set; }

        public decimal TotalFactura { get; set; }

        public decimal RetencionIva { get; set; }
        public decimal RetencionIslr { get; set; }
        public decimal? OtrasRetenciones { get; set; }
        
        public decimal Saldo { get; set; }
        public string Estado { get; set; }

        public List<Factura_ConsultaGeneral> GetFactura_ConsultaGeneral()
        {
            List<Factura_ConsultaGeneral> list = new List<Factura_ConsultaGeneral>();
            return list;
        }
    }

    public class Factura_ComprobanteRetencionIva
    {
        public string FechaToday { get; set; }
        public string NombreCia { get; set; }
        public string RifCia { get; set; }
        public string DireccionCia { get; set; }
        public string NombreCompania { get; set; }
        public string RifCompania { get; set; }
        public string PeriodoFiscal { get; set; }

        public string NumeroDocumento { get; set; }
        public string NumeroControl { get; set; }
        public DateTime FechaDocumento { get; set; }
        public string NotaDebito { get; set; }
        public string NotaCredito { get; set; }
        public string FacturaAfectada { get; set; }
        public string TipoDocumento { get; set; }

        public string ComprobanteSeniat { get; set; }
        public byte NumeroOperacion { get; set; }

        public decimal TotalComprasIncIva { get; set; }
        public decimal MontoNoImponible { get; set; }
        public decimal MontoImponible { get; set; }
        public decimal IvaPorc { get; set; }
        public decimal Iva { get; set; }
        public decimal RetencionIvaPorc { get; set; }
        public decimal RetencionIva { get; set; }


        public List<Factura_ComprobanteRetencionIva> GetFactura_ComprobanteRetencionIva()
        {
            List<Factura_ComprobanteRetencionIva> list = new List<Factura_ComprobanteRetencionIva>();
            return list;
        }
    }
}