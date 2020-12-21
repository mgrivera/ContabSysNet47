namespace ContabSysNet_Web.ModelosDatos_EF.code_first.contab
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("CentrosCosto")]
    public partial class CentrosCosto
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public CentrosCosto()
        {
            dAsientos = new HashSet<dAsientos>();
        }

        [Key]
        public int CentroCosto { get; set; }

        [Required]
        [StringLength(50)]
        public string Descripcion { get; set; }

        [Required]
        [StringLength(3)]
        public string DescripcionCorta { get; set; }

        public bool? Suspendido { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<dAsientos> dAsientos { get; set; }
    }
}
