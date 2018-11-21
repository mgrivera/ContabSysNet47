using MongoDB.Bson;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Areas.Bancos.Models.mongodb
{
    public class FacturaSeleccionada_Consultas
    {
        public ObjectId Id { get; set; }

        public int Moneda { get; set; } 
	    public int CiaContab { get; set; } 
	    public int Compania { get; set; } 
	    public string MonedaSimbolo  { get; set; } 
	    public string MonedaDescripcion  { get; set; } 
	    public string CiaContabNombre  { get; set; } 
	    public string CiaContabDireccion { get; set; } 
	    public string CiaContabRif  { get; set; } 
	    public string CiaContabTelefono1 { get; set; } 
	    public string CiaContabTelefono2 { get; set; } 
	    public string CiaContabFax { get; set; } 
	    public string CiaContabCiudad { get; set; } 
	    public string NombreCompania  { get; set; } 
	    public string AbreviaturaCompania  { get; set; } 
	    public string RifCompania { get; set; } 
	    public string NitCompania { get; set; } 
	    public string CompaniaDomicilio { get; set; } 
	    public string CompaniaTelefono { get; set; } 
	    public string CompaniaFax { get; set; } 
	    public string CompaniaCiudad { get; set; } 
	    public string CodigoConceptoRetencion { get; set; }
        public bool? ContribuyenteFlag { get; set; }
	    public string NumeroFactura  { get; set; } 
	    public string NumeroControl { get; set; } 
	    public bool ImportacionFlag { get; set; } 
	    public string Importacion_CompraNacional { get; set; } 
	    public string NumeroPlanillaImportacion { get; set; } 
	    public int ClaveUnicaFactura { get; set; } 
	    public string NcNdFlag { get; set; } 
	    public string Compra_NotaCredito { get; set; } 
	    public string NumeroFacturaAfectada { get; set; } 
	    public string NumeroComprobante { get; set; } 
	    public short? NumeroOperacion { get; set; } 
	    public int Tipo { get; set; } 
	    public string NombreTipo  { get; set; } 
	    public int CondicionesDePago { get; set; } 
	    public string CondicionesDePagoNombre { get; set; } 
	    public DateTime FechaEmision { get; set; } 
	    public DateTime FechaRecepcion { get; set; } 
	    public string Concepto { get; set; } 
	    public string NotasFactura1 { get; set; } 
	    public string NotasFactura2 { get; set; } 
	    public string NotasFactura3 { get; set; }
        public decimal? MontoFacturaSinIva { get; set; }
        public decimal? MontoFacturaConIva { get; set; } 
	    public decimal MontoTotalFactura { get; set; } 
	    public decimal BaseImponible_Reducido { get; set; }
        public decimal? BaseImponible_General { get; set; } 
	    public decimal BaseImponible_Adicional { get; set; } 
	    public string TipoAlicuota { get; set; }
        public decimal? IvaPorc { get; set; }
        public decimal? IvaPorc_Reducido { get; set; }
        public decimal? IvaPorc_General { get; set; }
        public decimal? IvaPorc_Adicional { get; set; }
        public decimal? Iva { get; set; }
        public decimal? Iva_Reducido { get; set; }
        public decimal? Iva_General { get; set; }
        public decimal? Iva_Adicional { get; set; } 
	    public decimal TotalFactura { get; set; } 
	    public decimal? MontoSujetoARetencion { get; set; } 
	    public decimal? ImpuestoRetenidoPorc { get; set; }
        public decimal? ImpuestoRetenidoISLRAntesSustraendo { get; set; }
        public decimal? ImpuestoRetenidoISLRSustraendo { get; set; } 
	    public decimal? ImpuestoRetenido { get; set; }
        public decimal? ImpuestoRetenido_Reducido { get; set; }
        public decimal? ImpuestoRetenido_General { get; set; }
        public decimal? ImpuestoRetenido_Adicional { get; set; } 
	    public DateTime? FRecepcionRetencionISLR { get; set; } 
	    public decimal? RetencionSobreIvaPorc { get; set; } 
	    public decimal? RetencionSobreIva { get; set; }
        public DateTime? FRecepcionRetencionIVA { get; set; }
        public decimal? ImpuestosVarios { get; set; }
        public decimal? RetencionesVarias { get; set; } 
	    public decimal TotalAPagar { get; set; } 
	    public decimal? Anticipo { get; set; } 
	    public decimal Saldo { get; set; } 
	    public int Estado { get; set; } 
	    public string NombreEstado { get; set; } 
	    public int CxCCxPFlag { get; set; } 
	    public string NombreCxCCxPFlag { get; set; }
        public int? Comprobante { get; set; } 
	    public DateTime? FechaPago { get; set; }
        public decimal? MontoPagado { get; set; } 
	    public string NombreUsuario { get; set; } 
    }
}