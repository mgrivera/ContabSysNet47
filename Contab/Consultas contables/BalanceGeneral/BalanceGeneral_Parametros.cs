using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNetWeb.Contab.Consultas_contables.BalanceGeneral
{
    public class BalanceGeneral_Parametros
    {
        public int CiaContab { get; set; }
        public int Moneda { get; set; }
        public int? MonedaOriginal { get; set; }
        public DateTime Desde { get; set; }
        public DateTime Hasta { get; set; }
        public string BalGen_GyP { get; set; }
        public bool BalGen_ExcluirGYP { get; set; }
        public bool ExcluirCuentasSaldoYMovtosCero { get; set; }
        public bool ExcluirCuentasSinMovimientos { get; set; }
        public bool ExcluirAsientosContablesTipoCierreAnual { get; set; }
        public string Filtro { get; set; }
    }

    public class Contab_Report_BalanceGeneral
    {
        public string NombreCiaContab { get; set; }
        public string CuentaContable { get; set; }
        public string NombreCuentaContable { get; set; }
        public string SimboloMoneda { get; set; }
        public string NombreMoneda { get; set; }
        public short OrdenBalanceGeneral { get; set; }
        public short CantidadNiveles { get; set; }

        public string Nivel1 { get; set; }
        public string NombreNivel1 { get; set; }
        public string Nivel2 { get; set; }
        public string NombreNivel2 { get; set; }
        public string Nivel3 { get; set; }
        public string NombreNivel3 { get; set; }
        public string Nivel4 { get; set; }
        public string NombreNivel4 { get; set; }
        public string Nivel5 { get; set; }
        public string NombreNivel5 { get; set; }
        public string Nivel6 { get; set; }
        public string NombreNivel6 { get; set; }

        public decimal SaldoInicial { get; set; }
        public decimal Debe { get; set; }
        public decimal Haber { get; set; }
        public decimal SaldoActual { get; set; }

        public short CantidadMovimientos { get; set; }


        public List<Contab_Report_BalanceGeneral> GetContab_Report_BalanceGeneral()
        {
            List<Contab_Report_BalanceGeneral> list = new List<Contab_Report_BalanceGeneral>();
            return list;
        }
    }

    public class Contab_Report_BalanceGeneral_Resumen
    {
        public string SimboloMoneda { get; set; }
        public int TipoCuenta { get; set; }
        public short OrdenBalanceGeneral { get; set; }

        public string Nivel1 { get; set; }
        public string NombreNivel1 { get; set; }
        
        public decimal SaldoInicial { get; set; }
        public decimal Debe { get; set; }
        public decimal Haber { get; set; }
        public decimal SaldoActual { get; set; }

        public short CantidadMovimientos { get; set; }


        public List<Contab_Report_BalanceGeneral_Resumen> GetContab_Report_BalanceGeneral_Resumen()
        {
            List<Contab_Report_BalanceGeneral_Resumen> list = new List<Contab_Report_BalanceGeneral_Resumen>();
            return list;
        }
    }
}