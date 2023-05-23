namespace ContabSysNet_Web.ModelosDatos_EF.code_first.bancos
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class Factura
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Factura()
        {
            Facturas_Impuestos = new HashSet<Facturas_Impuestos>();
        }

        [Key]
        public int ClaveUnica { get; set; }

        public int Proveedor { get; set; }

        [Required]
        [StringLength(25)]
        public string NumeroFactura { get; set; }

        [StringLength(20)]
        public string NumeroControl { get; set; }

        [StringLength(2)]
        public string NcNdFlag { get; set; }

        [StringLength(20)]
        public string NumeroFacturaAfectada { get; set; }

        [StringLength(14)]
        public string NumeroComprobante { get; set; }

        public short? NumeroOperacion { get; set; }

        public bool? ComprobanteSeniat_UsarUnoExistente_Flag { get; set; }

        public int Tipo { get; set; }

        [StringLength(25)]
        public string NumeroPlanillaImportacion { get; set; }

        public int CondicionesDePago { get; set; }

        [Column(TypeName = "date")]
        public DateTime FechaEmision { get; set; }

        [Column(TypeName = "date")]
        public DateTime FechaRecepcion { get; set; }

        [Column(TypeName = "ntext")]
        public string Concepto { get; set; }

        [Column(TypeName = "money")]
        public decimal? MontoFacturaSinIva { get; set; }

        [Column(TypeName = "money")]
        public decimal? MontoFacturaConIva { get; set; }

        [StringLength(30)]
        public string TasaId { get; set; }

        [Column(TypeName = "money")]
        public decimal? Tasa { get; set; }

        [StringLength(1)]
        public string TipoAlicuota { get; set; }

        public decimal? IvaPorc { get; set; }

        [Column(TypeName = "money")]
        public decimal? Iva { get; set; }

        [Column(TypeName = "money")]
        public decimal TotalFactura { get; set; }

        [StringLength(6)]
        public string CodigoConceptoRetencion { get; set; }

        [Column(TypeName = "money")]
        public decimal? MontoSujetoARetencion { get; set; }

        public decimal? ImpuestoRetenidoPorc { get; set; }

        [Column(TypeName = "money")]
        public decimal? ImpuestoRetenidoISLRAntesSustraendo { get; set; }

        [Column(TypeName = "money")]
        public decimal? ImpuestoRetenidoISLRSustraendo { get; set; }

        [Column(TypeName = "money")]
        public decimal? ImpuestoRetenido { get; set; }

        [Column(TypeName = "date")]
        public DateTime? FRecepcionRetencionISLR { get; set; }

        public decimal? RetencionSobreIvaPorc { get; set; }

        [Column(TypeName = "money")]
        public decimal? RetencionSobreIva { get; set; }

        [Column(TypeName = "date")]
        public DateTime? FRecepcionRetencionIVA { get; set; }

        [Column(TypeName = "money")]
        public decimal? OtrosImpuestos { get; set; }

        [Column(TypeName = "money")]
        public decimal? OtrasRetenciones { get; set; }

        [Column(TypeName = "money")]
        public decimal TotalAPagar { get; set; }

        [Column(TypeName = "money")]
        public decimal? Anticipo { get; set; }

        [Column(TypeName = "money")]
        public decimal Saldo { get; set; }

        public short Estado { get; set; }

        public int? ClaveUnicaUltimoPago { get; set; }

        public int Moneda { get; set; }

        public short CxCCxPFlag { get; set; }

        public int? Comprobante { get; set; }

        public bool? ImportacionFlag { get; set; }

        [StringLength(10)]
        public string ModificadoPor { get; set; }

        [StringLength(50)]
        public string Lote { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime Ingreso { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime UltAct { get; set; }

        [Required]
        [StringLength(125)]
        public string Usuario { get; set; }

        public int Cia { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Facturas_Impuestos> Facturas_Impuestos { get; set; }

        public virtual Moneda Moneda1 { get; set; }
    }
}
