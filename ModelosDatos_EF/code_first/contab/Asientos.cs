namespace ContabSysNet_Web.ModelosDatos_EF.code_first.contab
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class Asientos
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Asientos()
        {
            dAsientos = new HashSet<dAsientos>();
        }

        [Key]
        public int NumeroAutomatico { get; set; }

        public short Numero { get; set; }

        public byte Mes { get; set; }

        public short Ano { get; set; }

        [Required]
        [StringLength(6)]
        public string Tipo { get; set; }

        [Column(TypeName = "date")]
        public DateTime Fecha { get; set; }

        [StringLength(250)]
        public string Descripcion { get; set; }

        public int Moneda { get; set; }

        public int MonedaOriginal { get; set; }

        public bool? ConvertirFlag { get; set; }

        [Column(TypeName = "money")]
        public decimal FactorDeCambio { get; set; }

        [StringLength(25)]
        public string ProvieneDe { get; set; }

        public int? ProvieneDe_ID { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime Ingreso { get; set; }

        [Column(TypeName = "datetime2")]
        public DateTime UltAct { get; set; }

        public bool? CopiableFlag { get; set; }

        public bool? AsientoTipoCierreAnualFlag { get; set; }

        public short MesFiscal { get; set; }

        public short AnoFiscal { get; set; }

        [Required]
        [StringLength(125)]
        public string Usuario { get; set; }

        [StringLength(150)]
        public string Lote { get; set; }

        public int Cia { get; set; }

        public virtual Companias Companias { get; set; }

        public virtual Monedas Monedas { get; set; }

        public virtual Monedas Monedas1 { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<dAsientos> dAsientos { get; set; }
    }
}
