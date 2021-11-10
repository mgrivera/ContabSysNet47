using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.ActivosFijos.Consultas.DepreciacionMensual
{
    public class ActivosFijos_Report_ConsultaDepreciacion
    {
        public string NombreCiaContab { get; set; }
        public string AbreviaturaCiaContab { get; set; }
        public string NombreDepartamento { get; set; } 
		public int Moneda { get; set; }
        public string DescripcionMoneda { get; set; }
        public string SimboloMoneda { get; set; }
        public string NombreTipoProducto { get; set; }
        public string Producto { get; set; }
        public string DescripcionProducto { get; set; }
        public DateTime FechaCompra { get; set; }
        public DateTime? FechaDesincorporacion { get; set; }
        public string DepreciarDesde { get; set; }
        public short DepreciarDesdeMes { get; set; }
        public short DepreciarDesdeAno { get; set; }
        public string DepreciarHasta { get; set; }
        public short DepreciarHastaMes { get; set; }
        public short DepreciarHastaAno { get; set; }
        public short CantidadMesesADepreciar { get; set; }
        public short DepAcum_CantMeses { get; set; }
        public short DepAcum_CantMeses_AnoActual { get; set; }
        public short? RestaPorDepreciar_Meses { get; set; }
        public decimal CostoTotal { get; set; } 
		public decimal MontoADepreciar { get; set; }
        public decimal DepreciacionMensual { get; set; }
        public decimal DepAcum_AnoActual { get; set; }
        public decimal DepAcum_Total { get; set; }
        public decimal? RestaPorDepreciar { get; set; }
        public string NombreUsuario { get; set; } 

        public List<ActivosFijos_Report_ConsultaDepreciacion> Get_ActivosFijos_Report_ConsultaDepreciacion()
        {
            List<ActivosFijos_Report_ConsultaDepreciacion> list = new List<ActivosFijos_Report_ConsultaDepreciacion>();
            return list;
        }
    }
}