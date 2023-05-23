namespace ContabSysNet_Web.ModelosDatos_EF.code_first.bancos
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class tTempWebReport_ConsultaFacturas
    {
        [Key]
        [Column(Order = 0)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int Moneda { get; set; }

        [Key]
        [Column(Order = 1)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int CiaContab { get; set; }

        [Key]
        [Column(Order = 2)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int Compania { get; set; }

        [Required]
        [StringLength(6)]
        public string MonedaSimbolo { get; set; }

        [Required]
        [StringLength(50)]
        public string MonedaDescripcion { get; set; }

        [Required]
        [StringLength(50)]
        public string CiaContabNombre { get; set; }

        [StringLength(200)]
        public string CiaContabDireccion { get; set; }

        [Required]
        [StringLength(15)]
        public string CiaContabRif { get; set; }

        [StringLength(15)]
        public string CiaContabTelefono1 { get; set; }

        [StringLength(15)]
        public string CiaContabTelefono2 { get; set; }

        [StringLength(15)]
        public string CiaContabFax { get; set; }

        [StringLength(25)]
        public string CiaContabCiudad { get; set; }

        [Required]
        [StringLength(70)]
        public string NombreCompania { get; set; }

        [Required]
        [StringLength(10)]
        public string AbreviaturaCompania { get; set; }

        [StringLength(20)]
        public string RifCompania { get; set; }

        [StringLength(20)]
        public string NitCompania { get; set; }

        [StringLength(400)]
        public string CompaniaDomicilio { get; set; }

        [StringLength(15)]
        public string CompaniaTelefono { get; set; }

        [StringLength(15)]
        public string CompaniaFax { get; set; }

        [StringLength(50)]
        public string CompaniaCiudad { get; set; }

        [StringLength(20)]
        public string CodigoConceptoRetencion { get; set; }

        public bool? ContribuyenteFlag { get; set; }

        public short NatJurFlag { get; set; }

        [Required]
        [StringLength(20)]
        public string NatJurFlagDescripcion { get; set; }

        [Key]
        [Column(Order = 3)]
        [StringLength(25)]
        public string NumeroFactura { get; set; }

        [StringLength(20)]
        public string NumeroControl { get; set; }

        public bool? ImportacionFlag { get; set; }

        [StringLength(50)]
        public string Importacion_CompraNacional { get; set; }

        [StringLength(25)]
        public string NumeroPlanillaImportacion { get; set; }

        public int ClaveUnicaFactura { get; set; }

        [StringLength(2)]
        public string NcNdFlag { get; set; }

        [StringLength(50)]
        public string Compra_NotaCredito { get; set; }

        [StringLength(20)]
        public string NumeroFacturaAfectada { get; set; }

        [StringLength(14)]
        public string NumeroComprobante { get; set; }

        public short? NumeroOperacion { get; set; }

        public int Tipo { get; set; }

        [Required]
        [StringLength(50)]
        public string NombreTipo { get; set; }

        public int CondicionesDePago { get; set; }

        [StringLength(30)]
        public string CondicionesDePagoNombre { get; set; }

        public DateTime FechaEmision { get; set; }

        public DateTime FechaRecepcion { get; set; }

        [Column(TypeName = "ntext")]
        public string Concepto { get; set; }

        [StringLength(100)]
        public string NotasFactura1 { get; set; }

        [StringLength(100)]
        public string NotasFactura2 { get; set; }

        [StringLength(100)]
        public string NotasFactura3 { get; set; }

        [Column(TypeName = "money")]
        public decimal? MontoFacturaSinIva { get; set; }

        [Column(TypeName = "money")]
        public decimal? MontoFacturaConIva { get; set; }

        [Column(TypeName = "money")]
        public decimal MontoTotalFactura { get; set; }

        [Column(TypeName = "money")]
        public decimal? Tasa { get; set; }

        public bool? ConvertidoSegunTasaFlag { get; set; }

        [StringLength(1)]
        public string TipoAlicuota_Reducido { get; set; }

        [StringLength(1)]
        public string TipoAlicuota_General { get; set; }

        [StringLength(1)]
        public string TipoAlicuota_Adicional { get; set; }

        [Column(TypeName = "money")]
        public decimal? BaseImponible_Reducido { get; set; }

        [Column(TypeName = "money")]
        public decimal? BaseImponible_General { get; set; }

        [Column(TypeName = "money")]
        public decimal? BaseImponible_Adicional { get; set; }

        [StringLength(1)]
        public string TipoAlicuota { get; set; }

        public decimal? IvaPorc { get; set; }

        public decimal? IvaPorc_Reducido { get; set; }

        public decimal? IvaPorc_General { get; set; }

        public decimal? IvaPorc_Adicional { get; set; }

        [Column(TypeName = "money")]
        public decimal? Iva { get; set; }

        [Column(TypeName = "money")]
        public decimal? Iva_Reducido { get; set; }

        [Column(TypeName = "money")]
        public decimal? Iva_General { get; set; }

        [Column(TypeName = "money")]
        public decimal? Iva_Adicional { get; set; }

        [Column(TypeName = "money")]
        public decimal TotalFactura { get; set; }

        [Column(TypeName = "money")]
        public decimal? MontoSujetoARetencion { get; set; }

        public decimal? ImpuestoRetenidoPorc { get; set; }

        [Column(TypeName = "money")]
        public decimal? ImpuestoRetenidoISLRAntesSustraendo { get; set; }

        [Column(TypeName = "money")]
        public decimal? ImpuestoRetenidoISLRSustraendo { get; set; }

        [Column(TypeName = "money")]
        public decimal? ImpuestoRetenido { get; set; }

        [Column(TypeName = "money")]
        public decimal? ImpuestoRetenido_Reducido { get; set; }

        [Column(TypeName = "money")]
        public decimal? ImpuestoRetenido_General { get; set; }

        [Column(TypeName = "money")]
        public decimal? ImpuestoRetenido_Adicional { get; set; }

        public DateTime? FRecepcionRetencionISLR { get; set; }

        public decimal? RetencionSobreIvaPorc { get; set; }

        [Column(TypeName = "money")]
        public decimal? RetencionSobreIva { get; set; }

        public DateTime? FRecepcionRetencionIVA { get; set; }

        [Column(TypeName = "money")]
        public decimal? ImpuestosVarios { get; set; }

        [Column(TypeName = "money")]
        public decimal? RetencionesVarias { get; set; }

        [Column(TypeName = "money")]
        public decimal TotalAPagar { get; set; }

        [Column(TypeName = "money")]
        public decimal? Anticipo { get; set; }

        [Column(TypeName = "money")]
        public decimal Saldo { get; set; }

        public short Estado { get; set; }

        [StringLength(10)]
        public string NombreEstado { get; set; }

        public short CxCCxPFlag { get; set; }

        [Required]
        [StringLength(4)]
        public string NombreCxCCxPFlag { get; set; }

        public int? Comprobante { get; set; }

        public DateTime? FechaPago { get; set; }

        [Column(TypeName = "money")]
        public decimal? MontoPagado { get; set; }

        [Key]
        [Column(Order = 4)]
        [StringLength(256)]
        public string NombreUsuario { get; set; }
    }
}
