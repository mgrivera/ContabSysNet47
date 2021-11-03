
using System;
using System.Data;
using System.Data.SqlClient;

namespace ContabSysNet_Web.Contab.Consultas_contables.BalanceComprobacion
{
    public class DeterminarMovimientoCuentaContable
    {
        private SqlConnection _sqlConnection; 
        private bool _excluirAsientosTipoCierreAnual;
        private bool _excluirAsientosReconversion_01Oct2021;
        private bool _bReconvertirCifrasAntes_01Oct2021; 
        private DateTime _fechaInicialPeriodoIndicado;
        private DateTime _fechaFinalPeriodoIndicado;
        private int _monedaNacional; 

        public DeterminarMovimientoCuentaContable(SqlConnection sqlConnection,
                                                 bool excluirAsientosTipoCierreAnual, 
                                                 bool excluirAsientosReconversion_01Oct2021, 
                                                 bool bReconvertirCifrasAntes_01Oct2021, 
                                                 DateTime fechaInicialPeriodoIndicado, 
                                                 DateTime fechaFinalPeriodoIndicado, 
                                                 int monedaNacional)
        {
            _sqlConnection = sqlConnection;
            _excluirAsientosTipoCierreAnual = excluirAsientosTipoCierreAnual;
            _excluirAsientosReconversion_01Oct2021 = excluirAsientosReconversion_01Oct2021;
            _bReconvertirCifrasAntes_01Oct2021 = bReconvertirCifrasAntes_01Oct2021; 
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

            if (_excluirAsientosTipoCierreAnual && moneda == _monedaNacional)
            {
                filtroExcluirAsientosTipoCierreAnual = "(a.MesFiscal <> 13) And Not (a.AsientoTipoCierreAnualFlag Is Not Null And a.AsientoTipoCierreAnualFlag = 1)";
            }

            // -----------------------------------------------------------------------------------------------------------------
            // el usuario puede indicar que no quiere el (los) asientos de reconversión (2021) en la consulta 
            string filtroExcluirAsientosReconversion_01Oct2201 = "(1 = 1)";

            if (_excluirAsientosReconversion_01Oct2021)
            {
                filtroExcluirAsientosReconversion_01Oct2201 = "(d.Referencia <> 'Reconversión 2021')";
            }

            string selectMontoDebeHaber = "";

            // si el usuario quiere reconvertir montos antes de la reconversión del 2021, usamos una 'expression' en el Sum() ... 
            if (_bReconvertirCifrasAntes_01Oct2021 && moneda == _monedaNacional)
            {
                selectMontoDebeHaber = "Select Sum(Case When (a.Fecha < '2021-10-1') Then Round((d.Debe / 1000000), 2) Else d.Debe End) As SumDebe, " +
                                        "Sum(Case When (a.Fecha < '2021-10-1') Then Round((d.Haber / 1000000), 2) Else d.Haber End) As SumHaber, " +
                                        "Count(*) As ContaAsientos " +
                                        "From dAsientos d Inner Join Asientos a On d.NumeroAutomatico = a.NumeroAutomatico " +
                                        "Where d.CuentaContableID = @cuentaContableID And a.Moneda = @moneda And " + 
                                        "a.Fecha Between @fechaInicialPeriodo And @fechaFinalPeriodo And " +
                                        filtroExcluirAsientosTipoCierreAnual + " And " + filtroExcluirAsientosReconversion_01Oct2201;
            }
            else
            {
                selectMontoDebeHaber = "Select Sum(Debe) As SumDebe, Sum(Haber) As SumHaber, Count(*) As ContaAsientos " +
                                        "From dAsientos d Inner Join Asientos a On d.NumeroAutomatico = a.NumeroAutomatico " +
                                        "Where d.CuentaContableID = @cuentaContableID And a.Moneda = @moneda And " + 
                                        "a.Fecha Between @fechaInicialPeriodo And @fechaFinalPeriodo And " +
                                        filtroExcluirAsientosTipoCierreAnual + " And " + filtroExcluirAsientosReconversion_01Oct2201;
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
            if (reader.Read())
            {
                if (!reader.IsDBNull(0))
                    sumOfDebe = reader.GetDecimal(0);

                if (!reader.IsDBNull(1))
                    sumOfHaber = reader.GetDecimal(1);

                if (!reader.IsDBNull(2))
                    recCount = reader.GetInt32(2);
            }

            reader.Close();

            var result = new DeterminarMovimientoCuentaContable_result(sumOfDebe, sumOfHaber, recCount, false, "");

            return result; 
        }
    }
}