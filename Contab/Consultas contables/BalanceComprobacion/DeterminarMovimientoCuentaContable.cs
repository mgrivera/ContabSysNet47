using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Contab.Consultas_contables.BalanceComprobacion
{
    public class DeterminarMovimientoCuentaContable
    {
        private SqlConnection _sql_connection; 
        private bool _excluirAsientosTipoCierreAnual;
        private bool _excluirAsientosReconversion_01Oct2021;
        private DateTime _fechaInicialPeriodoIndicado;
        private DateTime _fechaFinalPeriodoIndicado;

        // estas son las variables de la clase que contedrán el resultado y que regresará la clase 
        Decimal _sumDebe = 0;
        Decimal _sumHaber = 0;
        int _recCount = 0;

        public DeterminarMovimientoCuentaContable(SqlConnection sql_connection,
                                                 bool excluirAsientosTipoCierreAnual, 
                                                 bool excluirAsientosReconversion_01Oct2021, 
                                                 DateTime fechaInicialPeriodoIndicado, 
                                                 DateTime fechaFinalPeriodoIndicado)
        {
            _sql_connection = sql_connection;
            _excluirAsientosTipoCierreAnual = excluirAsientosTipoCierreAnual;
            _excluirAsientosReconversion_01Oct2021 = excluirAsientosReconversion_01Oct2021; 
            _fechaInicialPeriodoIndicado = fechaInicialPeriodoIndicado;
            _fechaFinalPeriodoIndicado = fechaFinalPeriodoIndicado; 
        }

        public Decimal SumDebe { get { return _sumDebe; } }
        public Decimal SumHaber { get { return _sumHaber; } }
        public int RecCount { get { return _recCount; } }

        public bool leerMovimientoCuentaContable(int cuentaContableID, int moneda)
        {
            // -----------------------------------------------------------------------------------------------------------------
            // nótese que el usuario puede indicar que se excluya asientos del tipo cierre anual; la razón 
            // es que este asiento, cuando existe, pone los saldos de cuentas nóminales en cero ... 
            string filtroExcluirAsientosTipoCierreAnual = "(1 = 1)";

            if (_excluirAsientosTipoCierreAnual)
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

            selectMontoDebeHaber = "Select Sum(Debe) As SumDebe, Sum(Haber) As SumHaber, Count(*) As ContaAsientos " +
                "From dAsientos d Inner Join Asientos a On d.NumeroAutomatico = a.NumeroAutomatico " +
                "Where d.CuentaContableID = @cuentaContableID And " +
                "a.Moneda = @moneda And " +
                "a.Fecha Between @fechaInicialPeriodo And @fechaFinalPeriodo And " +
                filtroExcluirAsientosTipoCierreAnual + " And " + filtroExcluirAsientosReconversion_01Oct2201;

            SqlCommand commandDebeHaber = new SqlCommand(selectMontoDebeHaber, _sql_connection);

            commandDebeHaber.Parameters.Add("@cuentaContableID", SqlDbType.Int);
            commandDebeHaber.Parameters["@cuentaContableID"].Value = cuentaContableID;

            commandDebeHaber.Parameters.Add("@moneda", SqlDbType.Int);
            commandDebeHaber.Parameters["@moneda"].Value = moneda;

            commandDebeHaber.Parameters.Add("@fechaInicialPeriodo", SqlDbType.DateTime);
            commandDebeHaber.Parameters["@fechaInicialPeriodo"].Value = _fechaInicialPeriodoIndicado;

            commandDebeHaber.Parameters.Add("@fechaFinalPeriodo", SqlDbType.DateTime);
            commandDebeHaber.Parameters["@fechaFinalPeriodo"].Value = _fechaFinalPeriodoIndicado;

            SqlDataReader reader = commandDebeHaber.ExecuteReader();
            if (reader.Read())
            {
                if (!reader.IsDBNull(0))
                    _sumDebe = reader.GetDecimal(0);

                if (!reader.IsDBNull(1))
                    _sumHaber = reader.GetDecimal(1);

                if (!reader.IsDBNull(2))
                    _recCount = reader.GetInt32(2);
            }

            reader.Close();

            return true; 
        }
    }
}