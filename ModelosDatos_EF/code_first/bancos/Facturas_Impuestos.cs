namespace ContabSysNet_Web.ModelosDatos_EF.code_first.bancos
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class Facturas_Impuestos
    {
        public int ID { get; set; }

        public int FacturaID { get; set; }

        public int ImpRetID { get; set; }

        [StringLength(6)]
        public string Codigo { get; set; }

        [Column(TypeName = "money")]
        public decimal? MontoBase { get; set; }

        public decimal? Porcentaje { get; set; }

        [StringLength(1)]
        public string TipoAlicuota { get; set; }

        [Column(TypeName = "money")]
        public decimal? MontoAntesSustraendo { get; set; }

        [Column(TypeName = "money")]
        public decimal? Sustraendo { get; set; }

        [Column(TypeName = "money")]
        public decimal Monto { get; set; }

        [Column(TypeName = "date")]
        public DateTime? FechaRecepcionPlanilla { get; set; }

        public bool? ContabilizarAlPagar_flag { get; set; }

        public virtual Factura Factura { get; set; }
    }
}
