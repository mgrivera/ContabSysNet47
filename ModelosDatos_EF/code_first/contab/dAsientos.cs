namespace ContabSysNet_Web.ModelosDatos_EF.code_first.contab
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class dAsientos
    {
        [Key]
        [Column(Order = 0)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int NumeroAutomatico { get; set; }

        [Key]
        [Column(Order = 1)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public short Partida { get; set; }

        public int CuentaContableID { get; set; }

        [Required]
        [StringLength(300)]
        public string Descripcion { get; set; }

        [StringLength(20)]
        public string Referencia { get; set; }

        [Column(TypeName = "money")]
        public decimal Debe { get; set; }

        [Column(TypeName = "money")]
        public decimal Haber { get; set; }

        public int? CentroCosto { get; set; }

        public int? ConciliacionMovimientoID { get; set; }

        public virtual Asientos Asientos { get; set; }

        public virtual CentrosCosto CentrosCosto { get; set; }

        public virtual CuentasContables CuentasContables { get; set; }
    }
}
