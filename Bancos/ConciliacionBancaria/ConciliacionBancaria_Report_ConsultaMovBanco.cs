using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Bancos.ConciliacionBancaria
{
    public class ConciliacionBancaria_Report_ConsultaMovBanco
    {
        public string NombreMoneda { get; set; }
        public string NombreCiaContab { get; set; }
        public string NombreCuentaBancaria { get; set; }

        public DateTime Fecha { get; set; }
        public string Descripcion { get; set; }
        public string Referencia { get; set; }
        public decimal Monto { get; set; }

        public string MovimientoBancarioReferencia { get; set; }
        public string MovimientoContableReferencia { get; set; }

        public List<ConciliacionBancaria_Report_ConsultaMovBanco> GetConciliacionBancaria_Report_ConsultaMovBanco()
        {
            List<ConciliacionBancaria_Report_ConsultaMovBanco> list = new List<ConciliacionBancaria_Report_ConsultaMovBanco>();
            return list;
        }
    }

    public class ConciliacionBancaria_Report_ConsultaMovBancario
    {
        public string NombreMoneda { get; set; }
        public string NombreCiaContab { get; set; }
        public string NombreCuentaBancaria { get; set; }

        public long Transaccion { get; set; }
        public DateTime Fecha { get; set; }
        public string Tipo { get; set; }
        public string Descripcion { get; set; }
        public decimal Monto { get; set; }

        public int? ConciliacionMovimientoID { get; set; }

        public List<ConciliacionBancaria_Report_ConsultaMovBancario> GetConciliacionBancaria_Report_ConsultaMovBancario()
        {
            List<ConciliacionBancaria_Report_ConsultaMovBancario> list = new List<ConciliacionBancaria_Report_ConsultaMovBancario>();
            return list;
        }
    }

    public class ConciliacionBancaria_Report_ConsultaMovContable
    {
        public string NombreMoneda { get; set; }
        public string NombreCiaContab { get; set; }
        public string NombreCuentaContable { get; set; }

        public DateTime Fecha { get; set; }
        public string Numero { get; set; }
        public string Descripcion { get; set; }
        public string Referencia { get; set; }
        public decimal Monto { get; set; }

        public int? ConciliacionMovimientoID { get; set; }

        public List<ConciliacionBancaria_Report_ConsultaMovContable> GetConciliacionBancaria_Report_ConsultaMovContable()
        {
            List<ConciliacionBancaria_Report_ConsultaMovContable> list = new List<ConciliacionBancaria_Report_ConsultaMovContable>();
            return list;
        }
    }
}