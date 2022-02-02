
using System;
using System.Data;
using System.Data.SqlClient;

namespace ContabSysNet_Web.Contab.Consultas_contables.BalanceComprobacion
{
    public class DeterminarMovimientoCuentaContable
    {
        private SqlConnection _sqlConnection; 
        private bool _excluirAsientosTipoCierreAnual;
        private bool _bReconvertirCifrasAntes_01Oct2021;
        private bool _bExcluirAsientosReconversion_01Oct2021; 
        private DateTime _fechaInicialPeriodoIndicado;
        private DateTime _fechaFinalPeriodoIndicado;
        private int _monedaNacional; 

        public DeterminarMovimientoCuentaContable(SqlConnection sqlConnection,
                                                 bool excluirAsientosTipoCierreAnual, 
                                                 bool bReconvertirCifrasAntes_01Oct2021, 
                                                 bool bExcluirAsientosReconversion_01Oct2021, 
                                                 DateTime fechaInicialPeriodoIndicado, 
                                                 DateTime fechaFinalPeriodoIndicado, 
                                                 int monedaNacional)
        {
            _sqlConnection = sqlConnection;
            _excluirAsientosTipoCierreAnual = excluirAsientosTipoCierreAnual;
            _bReconvertirCifrasAntes_01Oct2021 = bReconvertirCifrasAntes_01Oct2021;
            _bExcluirAsientosReconversion_01Oct2021 = bExcluirAsientosReconversion_01Oct2021; 
            _fechaInicialPeriodoIndicado = fechaInicialPeriodoIndicado;
            _fechaFinalPeriodoIndicado = fechaFinalPeriodoIndicado;
            _monedaNacional = monedaNacional; 
        }

        public struct DeterminarMovimientoCuentaContable_result
        {
            public decimal sumDebe;
            public decimal sumHaber;
            public int recCount;

            public bool error;
            public string message;

            public DeterminarMovimientoCuentaContable_result(decimal sumDebe, decimal sumHaber, int recCount, bool error, string message)
            {
                this.sumDebe = sumDebe;
                this.sumHaber = sumHaber;
                this.recCount = recCount;

                this.error = error;
                this.message = message;
            }
        };

        public DeterminarMovimientoCuentaContable_result leerMovimientoCuentaContable(int cuentaContableID, int moneda)
        {
            // -----------------------------------------------------------------------------------------------------------------
            // nótese que el usuario puede indicar que se excluya asientos del tipo cierre anual; la razón 
            // es que este asiento, cuando existe, pone los saldos de cuentas nóminales en cero ... 
            string filtroExcluirAsientosTipoCierreAnual = "(1 = 1)";

            // ------------------------------------------------------------------------------------------------
            // preparamos un filtro que permite excluir/incluir el asiento de reconversión (Oct/2021) 
            string filtroExcluirAsientoReconversion2021 = "(1 = 1)"; 


            if (_excluirAsientosTipoCierreAnual)
            {
                filtroExcluirAsientosTipoCierreAnual = "(a.MesFiscal <> 13) And Not (a.AsientoTipoCierreAnualFlag Is Not Null And a.AsientoTipoCierreAnualFlag = 1)";
            }

            if (_bExcluirAsientosReconversion_01Oct2021)
            {
                filtroExcluirAsientoReconversion2021 = "(d.Referencia Is Null Or d.Referencia <> 'Reconversión 2021')"; 
            }

            string selectMontoDebeHaber = "";

            // si el usuario quiere reconvertir montos antes de la reconversión del 2021, usamos una 'expression' en el Sum() ... 
            if (_bReconvertirCifrasAntes_01Oct2021 && moneda == _monedaNacional)
            {
                // con el Union logramos: reconvertir hasta el 1/Sept/21; no reconvertir desde el 1/Oct/21 
                // Nota: este Select, con el Union, regresará 2 rows 
                // Nota: cuando el usuario quiere reconvertir, *excluimos* el asiento de reconversión 
                selectMontoDebeHaber = "Select Sum(Round((d.Debe / 1000000), 2)) As SumDebe, Sum(Round((d.Haber / 1000000), 2)) As SumHaber, Count(*) As ContaAsientos " +
                                              "From dAsientos d Inner Join Asientos a On d.NumeroAutomatico = a.NumeroAutomatico " +
                                              "Where d.CuentaContableID = @cuentaContableID And a.Moneda = @moneda And " +
                                              "(a.Fecha Between @fechaInicialPeriodo And @fechaFinalPeriodo) And " +
                                              "(a.Fecha <= '2021-09-30') And " +
                                              filtroExcluirAsientosTipoCierreAnual + " And " + filtroExcluirAsientoReconversion2021 +

                                              "Union " +

                                        "Select Sum(d.Debe) As SumDebe, Sum(d.Haber) As SumHaber, Count(*) As ContaAsientos " +
                                              "From dAsientos d Inner Join Asientos a On d.NumeroAutomatico = a.NumeroAutomatico " +
                                              "Where d.CuentaContableID = @cuentaContableID And a.Moneda = @moneda And " +
                                              "(a.Fecha Between @fechaInicialPeriodo And @fechaFinalPeriodo) And " +
                                              "(a.Fecha >= '2021-10-1') And " +
                                              filtroExcluirAsientosTipoCierreAnual + " And " + filtroExcluirAsientoReconversion2021; 
            }
            else
            {
                selectMontoDebeHaber = "Select Sum(Debe) As SumDebe, Sum(Haber) As SumHaber, Count(*) As ContaAsientos " +
                                        "From dAsientos d Inner Join Asientos a On d.NumeroAutomatico = a.NumeroAutomatico " +
                                        "Where d.CuentaContableID = @cuentaContableID And a.Moneda = @moneda And " +
                                        "(a.Fecha Between @fechaInicialPeriodo And @fechaFinalPeriodo) And " +
                                        filtroExcluirAsientosTipoCierreAnual + " And " + filtroExcluirAsientoReconversion2021;
            }

            SqlCommand commandDebeHaber = new SqlCommand(selectMontoDebeHaber, _sqlConnection);

            commandDebeHaber.Parameters.Add("@cuentaContableID", SqlDbType.Int);
            commandDebeHaber.Parameters["@cuentaContableID"].Value = cuentaContableID;

            commandDebeHaber.Parameters.Add("@moneda", SqlDbType.Int);
            commandDebeHaber.Parameters["@moneda"].Value = moneda;

            commandDebeHaber.Parameters.Add("@fechaInicialPeriodo", SqlDbType.DateTime);
            commandDebeHaber.Parameters["@fechaInicialPeriodo"].Value = _fechaInicialPeriodoIndicado;

            commandDebeHaber.Parameters.Add("@fechaFinalPeriodo", SqlDbType.DateTime);
            commandDebeHaber.Parameters["@fechaFinalPeriodo"].Value = _fechaFinalPeriodoIndicado;

            decimal sumOfDebe = 0;
            decimal sumOfHaber = 0;
            int recCount = 0;

            SqlDataReader reader = commandDebeHaber.ExecuteReader();
            while (reader.Read())
            {
                if (!reader.IsDBNull(0))
                    sumOfDebe += reader.GetDecimal(0);

                if (!reader.IsDBNull(1))
                    sumOfHaber += reader.GetDecimal(1);

                if (!reader.IsDBNull(2))
                    recCount += reader.GetInt32(2);
            }

            reader.Close();

            var result = new DeterminarMovimientoCuentaContable_result(sumOfDebe, sumOfHaber, recCount, false, "");

            return result;
        }
    }
}