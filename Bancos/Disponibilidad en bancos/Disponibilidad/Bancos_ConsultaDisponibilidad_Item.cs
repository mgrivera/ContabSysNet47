using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Bancos.Disponibilidad_en_bancos.Disponibilidad
{
    public class Bancos_ConsultaDisponibilidad_Item
    {
        public short Orden { get; set; }
        public string CuentaBancaria { get; set; }
        public string NombreCompania { get; set; }
        public string NombreBanco { get; set; }
        public string SimboloMoneda { get; set; }
        public DateTime Fecha { get; set; }
        public string Tipo { get; set; }
        public long Transaccion { get; set; }
        public string Concepto { get; set; }
        public string Beneficiario { get; set; }
        public decimal Monto { get; set; }
        public decimal? Debe { get; set; }
        public decimal? Haber { get; set; }
        public DateTime? FechaEntregado { get; set; }
        public DateTime? Conciliacion_FechaEjecucion { get; set; }

        public List<Bancos_ConsultaDisponibilidad_Item> Get_Bancos_ConsultaDisponibilidad_Item_List() 
        {
            List<Bancos_ConsultaDisponibilidad_Item> list = new List<Bancos_ConsultaDisponibilidad_Item>();
            return list; 
        }
    }
}