using System;
using ContabSysNet_Web.ModelosDatos;
using System.Linq;
using System.Data.SqlClient;
using System.Configuration;
using System.Data; 

public class GetMesFiscalContable
{
    private DateTime m_FechaInicialPeriodo;
    private int m_CiaContab;
    private int m_MesFiscal;
    private int m_AnoFiscal;
    private int m_MesCalendario;
    private int m_AnoCalendario;
    private string m_NombreMes;
    private DateTime m_FechaSaldo;

    private dbContabDataContext m_dbContabDataContext;

    public GetMesFiscalContable(DateTime dFechaInicialPeriodo, int nCiaContab)
    {
        m_FechaInicialPeriodo = dFechaInicialPeriodo;
        m_CiaContab = nCiaContab;
    }

    public int MesFiscal
    {
        get
        {
            return m_MesFiscal;
        }
    }

    public int AnoFiscal
    {
        get
        {
            return m_AnoFiscal;
        }
    }

    public int MesCalendario
    {
        get
        {
            return m_MesCalendario;
        }
    }

    public int AnoCalendario
    {
        get
        {
            return m_AnoCalendario;
        }
    }

    public string NombreMes
    {
        get
        {
            return m_NombreMes;
        }
    }

    public DateTime FechaSaldo
    {
        get
        {
            return m_FechaSaldo;
        }
    }

    public dbContabDataContext dbContabDataContext
    {
        set
        {
            m_dbContabDataContext = value;
        }
    }

    public bool DeterminarMesFiscal(ref string sErrorMessage)
    {
        m_MesCalendario = m_FechaInicialPeriodo.Month;
        m_AnoCalendario = m_FechaInicialPeriodo.Year;

        int nMesCalendario2 = m_MesCalendario;

        var query = (from m in m_dbContabDataContext.MesesDelAnoFiscals
                     where m.Mes == nMesCalendario2 && m.Cia == m_CiaContab
                     select new { m.MesFiscal, m.Ano, m.NombreMes } ).FirstOrDefault();

        if ((query == null))
        {
            sErrorMessage = "Aparentemente, la tabla de Meses Fiscales no esta correctamente registrada. Debe contener un registro" +
            " para cada mes del año. <br /> Por favor revise esta tabla y haga las correcciones que sean necesarias" +
            " antes de volver a ejecutar esta consulta.";
            // TODO: Exit Function: Warning!!! Need to return the value
            return false;
        }

        m_MesFiscal = query.MesFiscal; 

        switch (query.Ano)
        {
            case 0:       
                // el mes calendario corresponde a un mes del mismo año 
                m_AnoFiscal = m_AnoCalendario; 
                break; 
            case 1:      
                // el mes calendario corresponde a un mes del año anterior  
                m_AnoFiscal = m_AnoCalendario - 1; 
                break; 
        }

        m_NombreMes = query.NombreMes; 
        int MyAnoCalendario = m_AnoCalendario; 

        switch (m_MesCalendario) 
        {
            case 1:
                m_FechaSaldo = new DateTime(m_AnoCalendario, m_MesCalendario, 1);
                break;
            case 3:
                m_FechaSaldo = new DateTime(m_AnoCalendario, m_MesCalendario, 1);
                break;
            case 5:
                m_FechaSaldo = new DateTime(m_AnoCalendario, m_MesCalendario, 1);
                break;
            case 7:
                m_FechaSaldo = new DateTime(m_AnoCalendario, m_MesCalendario, 1);
                break;
            case 8:
                m_FechaSaldo = new DateTime(m_AnoCalendario, m_MesCalendario, 1);
                break;
            case 10:
                m_FechaSaldo = new DateTime(m_AnoCalendario, m_MesCalendario, 1);
                break;
            case 12:
                m_FechaSaldo = new DateTime(m_AnoCalendario, m_MesCalendario, 1);
                break;
            case 4:
                m_FechaSaldo = new DateTime(m_AnoCalendario, m_MesCalendario, 1);
                break;
            case 6:
                m_FechaSaldo = new DateTime(m_AnoCalendario, m_MesCalendario, 1);
                break;
            case 9:
                m_FechaSaldo = new DateTime(m_AnoCalendario, m_MesCalendario, 1);
                break;
            case 11:
                m_FechaSaldo = new DateTime(m_AnoCalendario, m_MesCalendario, 1);
                break;
            case 2:
                int nParteEntera = m_AnoCalendario / 4;
                if (m_AnoCalendario / 4.0 == nParteEntera) {
                    // año biciesto !
                    m_FechaSaldo = new DateTime(m_AnoCalendario, m_MesCalendario, 1);
                }
                else {
                    m_FechaSaldo = new DateTime(m_AnoCalendario, m_MesCalendario, 1);
                }
                break;
        }

        return true; 
    }
}
public class GetSaldoContable
{

    private int cuentaContableID;
    private int mesFiscal;
    private int anoFiscal;
    private DateTime fechaInicialPeriodo;
    private int moneda;
    private int ciaContab;
    private Decimal saldoAnterior;

    // a partir de la reconversión de Oct/2021, el usuario puede indicar que se reconviertan montos *anteriores* al 1-oct-21 
    private bool bReconvertirCifrasAntes_01Oct2021;
    private int monedaNacional; 

    public GetSaldoContable(int CuentaContableID, 
                            int MesFiscal, 
                            int AnoFiscal, 
                            DateTime FechaInicialPeriodo, 
                            int Moneda, 
                            int CiaContab, 
                            bool ReconvertirCifrasAntes_01Oct2021, 
                            int MonedaNacional)
    {
        cuentaContableID = CuentaContableID;
        mesFiscal = MesFiscal;
        anoFiscal = AnoFiscal;
        fechaInicialPeriodo = FechaInicialPeriodo;
        moneda = Moneda;
        ciaContab = CiaContab;
        bReconvertirCifrasAntes_01Oct2021 = ReconvertirCifrasAntes_01Oct2021;
        monedaNacional = MonedaNacional; 
    }

    public Decimal SaldoAnterior
    {
        get
        {
            return saldoAnterior;
        }
    }

    public bool bLeerSaldoCuenta() 
    {
        //  leemos el saldo de la cuenta para la moneda y lo regresamos; nótese como puede haber más de un registro, 
        //  cuando la compañía es multimoneda (ie: la moneda original puede tener varios valores) 
        saldoAnterior = 0;
        decimal? q = null;

        string mes = ""; 

        switch (mesFiscal) {
            case 1:
                mes = "Inicial"; 
                break;
            case 2:
                mes = "Mes01"; 
                break;
            case 3:
                mes = "Mes02"; 
                break;
            case 4:
                mes = "Mes03"; 
                break;
            case 5:
                mes = "Mes04"; 
                break;
            case 6:
                mes = "Mes05"; 
                break;
            case 7:
                mes = "Mes06"; 
                break;
            case 8:
                mes = "Mes07"; 
                break;
            case 9:
                mes = "Mes08"; 
                break;
            case 10:
                mes = "Mes09"; 
                break;
            case 11:
                mes = "Mes10"; 
                break;
            case 12:
                mes = "Mes11"; 
                break;
        }

        string sqlSelect =
                "SELECT Sum(" + mes + ") " +
                "From SaldosContables " +
                "Where SaldosContables.CuentaContableID = @cuentaContableID And " +
                "SaldosContables.Moneda = @moneda And " +
                "SaldosContables.Ano = @anoFiscal";


        SqlConnection connection = new SqlConnection();
        connection.ConnectionString = ConfigurationManager.ConnectionStrings["dbContabConnectionString"].ConnectionString;

        using (connection)
        {
            SqlCommand commandSaldoAnterior = new SqlCommand(sqlSelect, connection);

            commandSaldoAnterior.Parameters.Add("@cuentaContableID", SqlDbType.Int);
            commandSaldoAnterior.Parameters["@cuentaContableID"].Value = cuentaContableID;

            commandSaldoAnterior.Parameters.Add("@moneda", SqlDbType.Int);
            commandSaldoAnterior.Parameters["@moneda"].Value = moneda;

            commandSaldoAnterior.Parameters.Add("@anoFiscal", SqlDbType.Int);
            commandSaldoAnterior.Parameters["@anoFiscal"].Value = anoFiscal;

            connection.Open();

            q = (decimal?)commandSaldoAnterior.ExecuteScalar();

            if (q != null)
                saldoAnterior = q.Value;

            // -----------------------------------------------------------------------------------------------------------
            // reconvertimos *solo* cuando el saldo es *anterior* a Oct/2021 
            if (bReconvertirCifrasAntes_01Oct2021 && fechaInicialPeriodo < new DateTime(2021, 10, 2) && moneda == monedaNacional)
                saldoAnterior = Math.Round((saldoAnterior / 1000000), 2); 
            
            //  solo si la fecha inicial del per�do no comienza en el 1er. d�a del mes, leemos y agregamos al 
            //  saldo los movimientos que pueda tener la cuenta para los d�as que van desde el 1ro. hasta el 
            //  d�a anterior a la fecha incial del per�odo. 
            if (fechaInicialPeriodo.Day > 1)
            {
                DateTime dFecha1erDiaMes = new DateTime(fechaInicialPeriodo.Year, fechaInicialPeriodo.Month, 1);
                DateTime dFechaDiaAnteriorFechaInicialPeriodo = new DateTime(fechaInicialPeriodo.Year, fechaInicialPeriodo.Month, fechaInicialPeriodo.Day - 1);

                sqlSelect =
                "SELECT Sum(Debe) As SumDebe, Sum(Haber) As SumHaber " +
                "From dAsientos Inner Join Asientos On dAsientos.NumeroAutomatico = Asientos.NumeroAutomatico " +
                "Where dAsientos.CuentaContableID = @cuentaContableID And " +
                "Asientos.Fecha Between @fechaInicialPeriodo And @fechaFinalPeriodo And " +
                "Asientos.Moneda = @moneda";

                SqlCommand commandMontoAsientos = new SqlCommand(sqlSelect, connection);

                commandMontoAsientos.Parameters.Add("@cuentaContableID", SqlDbType.Int);
                commandMontoAsientos.Parameters["@cuentaContableID"].Value = cuentaContableID;

                commandMontoAsientos.Parameters.Add("@fechaInicialPeriodo", SqlDbType.DateTime);
                commandMontoAsientos.Parameters["@fechaInicialPeriodo"].Value = dFecha1erDiaMes;

                commandMontoAsientos.Parameters.Add("@fechaFinalPeriodo", SqlDbType.DateTime);
                commandMontoAsientos.Parameters["@fechaFinalPeriodo"].Value = dFechaDiaAnteriorFechaInicialPeriodo;

                commandMontoAsientos.Parameters.Add("@moneda", SqlDbType.Int);
                commandMontoAsientos.Parameters["@moneda"].Value = moneda;

                decimal montoDebe = 0;
                decimal montoHaber = 0;

                SqlDataReader reader = commandMontoAsientos.ExecuteReader();
                if (reader.Read())
                {
                    if (!reader.IsDBNull(0))
                        montoDebe = reader.GetDecimal(0);

                    if (!reader.IsDBNull(1))
                        montoHaber = reader.GetDecimal(1);
                }

                if (bReconvertirCifrasAntes_01Oct2021 && fechaInicialPeriodo < new DateTime(2021, 10, 2) && moneda == monedaNacional)
                {
                    montoDebe = Math.Round((montoDebe / 1000000), 2);
                    montoHaber = Math.Round((montoHaber / 1000000), 2);
                }

                saldoAnterior += montoDebe;
                saldoAnterior -= montoHaber;
            }
        }

        return true;
    }
}