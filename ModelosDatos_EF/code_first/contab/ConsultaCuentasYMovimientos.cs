namespace ContabSysNet_Web.ModelosDatos_EF.code_first.contab
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    [Table("Contab_ConsultaCuentasYMovimientos")]
    public partial class ConsultaCuentasYMovimientos
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public ConsultaCuentasYMovimientos()
        {
            ConsultaCuentasYMovimientos_Movimientos = new HashSet<ConsultaCuentasYMovimientos_Movimientos>();
        }

        public int ID { get; set; }

        public int CuentaContableID { get; set; }

        public int Moneda { get; set; }

        public short CantMovtos { get; set; }

        [Required]
        [StringLength(256)]
        public string NombreUsuario { get; set; }

        public virtual CuentasContables CuentasContables { get; set; }

        public virtual Monedas Monedas { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ConsultaCuentasYMovimientos_Movimientos> ConsultaCuentasYMovimientos_Movimientos { get; set; }
    }
}
