namespace ContabSysNet_Web.ModelosDatos_EF.code_first.contab
{ 
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Contab_ConsultaCuentasYMovimientos_Movimientos")]
    public partial class ConsultaCuentasYMovimientos_Movimientos
    {
        public int ID { get; set; }

        public int ParentID { get; set; }

        public short Secuencia { get; set; }

        public int AsientoID { get; set; }

        public int CuentaContableID { get; set; }

        public short? Partida { get; set; }

        [Required]
        [Column(TypeName = "date")]
        public DateTime Fecha { get; set; }

        [StringLength(20)]
        public string Referencia { get; set; }

        [Required]
        [StringLength(300)]
        public string Descripcion { get; set; }

        [Column(TypeName = "money")]
        public decimal Monto { get; set; }

        [StringLength(3)]
        public string CentroCostoAbreviatura { get; set; }

        public virtual ConsultaCuentasYMovimientos ConsultaCuentasYMovimientos { get; set; }
    }
}
