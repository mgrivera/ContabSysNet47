namespace ContabSysNet_Web.ModelosDatos_EF.code_first.contab
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class CuentasContables
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public CuentasContables()
        {
            ConsultaCuentasYMovimientos = new HashSet<ConsultaCuentasYMovimientos>();
            dAsientos = new HashSet<dAsientos>();
        }

        public int ID { get; set; }

        [Required]
        [StringLength(25)]
        public string Cuenta { get; set; }

        [Required]
        [StringLength(40)]
        public string Descripcion { get; set; }

        [Required]
        [StringLength(10)]
        public string Nivel1 { get; set; }

        [StringLength(10)]
        public string Nivel2 { get; set; }

        [StringLength(10)]
        public string Nivel3 { get; set; }

        [StringLength(10)]
        public string Nivel4 { get; set; }

        [StringLength(10)]
        public string Nivel5 { get; set; }

        [StringLength(10)]
        public string Nivel6 { get; set; }

        [StringLength(10)]
        public string Nivel7 { get; set; }

        public byte NumNiveles { get; set; }

        [Required]
        [StringLength(1)]
        public string TotDet { get; set; }

        [Required]
        [StringLength(1)]
        public string ActSusp { get; set; }

        public int? Estructura { get; set; }

        [Required]
        [StringLength(30)]
        public string CuentaEditada { get; set; }

        [StringLength(30)]
        public string Modelo { get; set; }

        public int Grupo { get; set; }

        [StringLength(20)]
        public string NivelAgrupacion { get; set; }

        public int? GrupoNivelAgrupacion { get; set; }

        public bool? PresupuestarFlag { get; set; }

        public int Cia { get; set; }

        public virtual Companias Companias { get; set; }
        public virtual GruposContables GruposContables { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ConsultaCuentasYMovimientos> ConsultaCuentasYMovimientos { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<dAsientos> dAsientos { get; set; }
    }
}
