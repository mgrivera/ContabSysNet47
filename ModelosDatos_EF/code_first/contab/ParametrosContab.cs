namespace ContabSysNet_Web.ModelosDatos_EF.code_first.contab
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("ParametrosContab")]
    public partial class ParametrosContab
    {
        public int? Activo1 { get; set; }

        public int? Activo2 { get; set; }

        public int? Activo3 { get; set; }

        public int? Activo4 { get; set; }

        public int? Activo5 { get; set; }

        public int? Activo6 { get; set; }

        public int? Pasivo1 { get; set; }

        public int? Pasivo2 { get; set; }

        public int? Pasivo3 { get; set; }

        public int? Pasivo4 { get; set; }

        public int? Pasivo5 { get; set; }

        public int? Pasivo6 { get; set; }

        public int? Capital1 { get; set; }

        public int? Capital2 { get; set; }

        public int? Capital3 { get; set; }

        public int? Capital4 { get; set; }

        public int? Capital5 { get; set; }

        public int? Capital6 { get; set; }

        public int? Ingresos1 { get; set; }

        public int? Ingresos2 { get; set; }

        public int? Ingresos3 { get; set; }

        public int? Ingresos4 { get; set; }

        public int? Ingresos5 { get; set; }

        public int? Ingresos6 { get; set; }

        public int? Egresos1 { get; set; }

        public int? Egresos2 { get; set; }

        public int? Egresos3 { get; set; }

        public int? Egresos4 { get; set; }

        public int? Egresos5 { get; set; }

        public int? Egresos6 { get; set; }

        public int? CuentaGyP { get; set; }

        public bool? MultiMoneda { get; set; }

        public int? Moneda1 { get; set; }

        public int? Moneda2 { get; set; }

        public int? Moneda3 { get; set; }

        public int? Moneda4 { get; set; }

        public int? Moneda5 { get; set; }

        public bool? CambiarFactorAlAgregarFlag { get; set; }

        public bool? CambiarFactorAlModFlag { get; set; }

        public bool? NumeracionAsientosSeparadaFlag { get; set; }

        public bool? CierreContabPermitirAsientosDescuadrados { get; set; }

        public bool? OrganizarPartidasDelAsiento { get; set; }

        public bool? CargarAsientosConNumeroNegativoFlag { get; set; }

        [StringLength(250)]
        public string DirectorioAsientosOtrasAplicaciones { get; set; }

        public bool? ReportesContab_NoMostrarFechaDia { get; set; }

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int Cia { get; set; }

        public virtual Companias Companias { get; set; }
    }
}
