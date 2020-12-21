namespace ContabSysNet_Web.ModelosDatos_EF.code_first.contab
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class Companias
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Companias()
        {
            Asientos = new HashSet<Asientos>();
            CuentasContables = new HashSet<CuentasContables>();
        }

        [Key]
        public int Numero { get; set; }

        [Required]
        [StringLength(50)]
        public string Nombre { get; set; }

        [Required]
        [StringLength(25)]
        public string NombreCorto { get; set; }

        [Required]
        [StringLength(6)]
        public string Abreviatura { get; set; }

        [StringLength(12)]
        public string Rif { get; set; }

        [StringLength(150)]
        public string Direccion { get; set; }

        [StringLength(25)]
        public string Ciudad { get; set; }

        [StringLength(50)]
        public string EntidadFederal { get; set; }

        [StringLength(15)]
        public string ZonaPostal { get; set; }

        [StringLength(14)]
        public string Telefono1 { get; set; }

        [StringLength(14)]
        public string Telefono2 { get; set; }

        [StringLength(14)]
        public string Fax { get; set; }

        [StringLength(100)]
        public string EmailServerName { get; set; }

        public int? EmailServerPort { get; set; }

        public bool? EmailServerSSLFlag { get; set; }

        [StringLength(100)]
        public string EmailServerCredentialsUserName { get; set; }

        [StringLength(50)]
        public string EmailServerCredentialsPassword { get; set; }

        public int? MonedaDefecto { get; set; }

        public bool? SuspendidoFlag { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Asientos> Asientos { get; set; }

        public virtual Monedas Monedas { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CuentasContables> CuentasContables { get; set; }

        public virtual ParametrosContab ParametrosContab { get; set; }
    }
}
