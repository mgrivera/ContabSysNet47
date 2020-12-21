using System;
using System.Collections.Generic;

namespace ContabSysNet_Web.Contab.Consultas_contables.Cuentas_y_movimientos
{
    public class Asiento_Report
    {
        public int NumeroAutomatico { get; set; }
        public int Moneda { get; set; }
        public int Cia { get; set; }
        public DateTime Fecha { get; set; }
        public int Numero { get; set; }
        public string Descripcion { get; set; }
        public string ProvieneDe { get; set; }
        public string NombreMoneda { get; set; }
        public string NombreCiaContab { get; set; }
        public string NombreTipo { get; set; }
        public string SimboloMonedaOriginal { get; set; }

        public List<Asiento_Report> GetAsientos_Report()
        {
            List<Asiento_Report> list = new List<Asiento_Report>();
            return list;
        }
    }

    public class dAsiento_Report
    {
        public short Partida { get; set; }
        public string Descripcion { get; set; }
        public string Referencia { get; set; }
        public decimal Debe { get; set; }
        public decimal Haber { get; set; }
        public int NumeroAutomatico { get; set; }
        public string NombreCuentaContable { get; set; }
        public string CuentaContableEditada { get; set; }

        public List<dAsiento_Report> GetdAsientos_Report()
        {
            List<dAsiento_Report> list = new List<dAsiento_Report>();
            return list;
        }
    }

    public class Asiento2_Report
    {
        public string NombreMoneda { get; set; }
        public string NombreCiaContab { get; set; }
        public DateTime Fecha { get; set; }
        public int NumeroAutomatico { get; set; }
        public int Numero { get; set; }
        public string NombreTipo { get; set; }
        public string SimboloMonedaOriginal { get; set; }
        public string DescripcionGeneralAsientoContable { get; set; }
        public string ProvieneDe { get; set; }

        public short Partida { get; set; }
        public string CuentaContableEditada { get; set; }
        public string NombreCuentaContable { get; set; }
        public string Descripcion { get; set; }
        public string Referencia { get; set; }
        public decimal Debe { get; set; }
        public decimal Haber { get; set; }
       
        public List<Asiento2_Report> GetAsientos_Report()
        {
            List<Asiento2_Report> list = new List<Asiento2_Report>();
            return list;
        }
    }

    public class CuentasYMovimientos_Report
    {
        public string NombreCiaContab { get; set; }
        public string NombreMoneda { get; set; }
        public string SimboloMoneda { get; set; }
        public string CuentaContableEditada { get; set; }
        public string NombreCuentaContable { get; set; }
        public int? NumeroComprobante { get; set; }
        public DateTime? Fecha { get; set; }
        public string SimboloMonedaOriginal { get; set; }
        public int Secuencia { get; set; }
        public short? Partida { get; set; }
        public string Descripcion { get; set; }
        public string Referencia { get; set; }
        public decimal Debe { get; set; }
        public decimal Haber { get; set; }
        public decimal Total { get; set; }
        public string CentroCostoAbreviatura { get; set; }
        public string NombreUsuario { get; set; }

        public List<CuentasYMovimientos_Report> GetCuentasYMovimientos_Report()
        {
            List<CuentasYMovimientos_Report> list = new List<CuentasYMovimientos_Report>();
            return list;
        }
    }
}