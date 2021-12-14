using System;
using System.Web.UI;
using ContabSysNet_Web.ModelosDatos;
using System.Linq;
using System.Web.UI.WebControls; 


namespace ContabSysNetWeb.Contab.Consultas_contables.BalanceComprobacion
{
    public partial class BalanceComprobacion_MovimientosContables : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack) 
            {
                if (Session["FechaInicialPeriodo"] == null || Session["FechaFinalPeriodo"] == null) 
                {
                    CustomValidator1.IsValid = false;
                    CustomValidator1.ErrorMessage = "Aparentemente, Ud. no ha aplicado un filtro; debe hacerlo antes de intentar ejecutar esta consulta.";

                    return; 
                }

                // nótese cómo obtenemos la moneda nacional que viene como un parámetro. La necesitamos para saber si debemos o no reconvertir (reconversión de Oct/21) 
                if (Session["monedaNacional"] == null)
                {
                    CustomValidator1.IsValid = false;
                    CustomValidator1.ErrorMessage = "Upsss, esta consulta no ha recibido un valor para la moneda nacional. <br /> " + 
                                                    "Por favor revise esta situación y corríjala para que sea posible la ejecución de esta consulta.";

                    return;
                }

                var monedaNacional = 0;
                var moneda = 0;

                try
                {
                    monedaNacional = Convert.ToInt32(Session["monedaNacional"]);
                    moneda = Convert.ToInt32(Request.QueryString["mon"]);
                } catch (Exception err)
                {
                    CustomValidator1.IsValid = false;
                    CustomValidator1.ErrorMessage = "Hemos obtenido un error al intentar obtener la moneda y/o moneda nacional. <br /> " +
                                                    "El mensaje específico del error obtenido es: " + err.Message;
                    return;
                }

                // para saber si el usuario quiere reconvertir las cifras anteriores al 1-Oct-21 
                bool bReconvertirCifrasAntes_01Oct2021 = false;

                if (Session["ReconvertirCifrasAntes_01Oct2021"] != null)
                    bReconvertirCifrasAntes_01Oct2021 = (bool)Session["ReconvertirCifrasAntes_01Oct2021"];

                dbContabDataContext dbContab = new dbContabDataContext();

                var query = (from cta in dbContab.CuentasContables
                             where cta.ID == Convert.ToInt32(Request.QueryString["cta"])
                             select new { cta.CuentaEditada, cta.Descripcion }).FirstOrDefault();

                DateTime FechaInicialPeriodo = (System.DateTime)Session["FechaInicialPeriodo"];
                DateTime FechaFinalPeriodo = (System.DateTime)Session["FechaFinalPeriodo"];

                TituloPagina.InnerHtml = "Movimientos contables para la cuenta <i>" + query.CuentaEditada + " - " + query.Descripcion + "</i><br /> en el período " + FechaInicialPeriodo.ToString("dd-MMM-yy") + " a " + FechaFinalPeriodo.ToString("dd-MMM-yy");

                // ------------------------------------------------------------------------------------------------------------------
                // para dar valores a los parámetros del SqlDataSource 
                this.MovimientosContables_SqlDataSource.SelectParameters["CuentaContableID"].DefaultValue = Request.QueryString["cta"];
                this.MovimientosContables_SqlDataSource.SelectParameters["Moneda"].DefaultValue = Request.QueryString["mon"];

                this.MovimientosContables_SqlDataSource.SelectParameters["FechaInicialPeriodo"].DefaultValue = Session["FechaInicialPeriodo"].ToString();
                this.MovimientosContables_SqlDataSource.SelectParameters["FechaFinalPeriodo"].DefaultValue = Session["FechaFinalPeriodo"].ToString();
                // ------------------------------------------------------------------------------------------------------------------

                Label MySumOfDebe_Label = (Label)BalanceComprobacion_ListView.FindControl("SumOfDebe_Label");
                Label MySumOfHaber_Label = (Label)BalanceComprobacion_ListView.FindControl("SumOfHaber_Label");

                decimal? nTotalDebe = 0;
                decimal? nTotalHaber = 0;

                DateTime fechaInicialPeriodo = Convert.ToDateTime(Session["FechaInicialPeriodo"].ToString());
                DateTime fechaFinalPeriodo = Convert.ToDateTime(Session["FechaFinalPeriodo"].ToString());

                // ahora sumarizamos el debe y el haber para la cuenta y período indicados ... 
                if (bReconvertirCifrasAntes_01Oct2021 && (moneda == monedaNacional))
                {
                    // Nota: cuando el usuario quiere reconvertir, excluimos el asiento de reconversión 
                    // primero leemos valores *anteriores* a 1/Oct/21 y reconvertimos 
                    nTotalDebe = (from d in dbContab.dAsientos
                                      where d.CuentaContableID == Convert.ToInt32(Request.QueryString["cta"].ToString()) &&
                                            d.Asiento.Moneda == Convert.ToInt32(Request.QueryString["mon"]) &&
                                            (d.Asiento.Fecha >= fechaInicialPeriodo && d.Asiento.Fecha < new DateTime(2021, 10, 1)) && 
                                            (d.Referencia == null || d.Referencia != "Reconversión 2021")
                                  select (decimal?)d.Debe).Sum();

                    nTotalHaber = (from d in dbContab.dAsientos
                                       where d.CuentaContableID == Convert.ToInt32(Request.QueryString["cta"].ToString()) &&
                                             d.Asiento.Moneda == Convert.ToInt32(Request.QueryString["mon"]) &&
                                             (d.Asiento.Fecha >= fechaInicialPeriodo && d.Asiento.Fecha < new DateTime(2021, 10, 1)) &&
                                             (d.Referencia == null || d.Referencia != "Reconversión 2021")
                                   select (decimal?)d.Haber).Sum();

                    // luego leemos valores *posteriores* a 1/Oct/21 y *no* reconvertimos 
                    var nTotalDebe2 = (from d in dbContab.dAsientos
                                      where d.CuentaContableID == Convert.ToInt32(Request.QueryString["cta"].ToString()) &&
                                            d.Asiento.Moneda == Convert.ToInt32(Request.QueryString["mon"]) &&
                                            (d.Asiento.Fecha >= fechaInicialPeriodo && d.Asiento.Fecha <= fechaFinalPeriodo) &&
                                            d.Asiento.Fecha >= new DateTime(2021, 10, 1) &&
                                            (d.Referencia == null || d.Referencia != "Reconversión 2021")
                                       select (decimal?)d.Debe).Sum();

                    var nTotalHaber2 = (from d in dbContab.dAsientos
                                       where d.CuentaContableID == Convert.ToInt32(Request.QueryString["cta"].ToString()) &&
                                             d.Asiento.Moneda == Convert.ToInt32(Request.QueryString["mon"]) &&
                                             (d.Asiento.Fecha >= fechaInicialPeriodo && d.Asiento.Fecha <= fechaFinalPeriodo) &&
                                             d.Asiento.Fecha >= new DateTime(2021, 10, 1) &&
                                             (d.Referencia == null || d.Referencia != "Reconversión 2021")
                                        select (decimal?)d.Haber).Sum();

                    nTotalDebe = nTotalDebe.HasValue ? nTotalDebe.Value : 0;
                    nTotalHaber = nTotalHaber.HasValue ? nTotalHaber.Value : 0;
                    nTotalDebe2 = nTotalDebe2.HasValue ? nTotalDebe2.Value : 0;
                    nTotalHaber2 = nTotalHaber2.HasValue ? nTotalHaber2.Value : 0;

                    // reconvertimos 
                    nTotalDebe = Math.Round((nTotalDebe.Value / 1000000), 2);
                    nTotalHaber = Math.Round((nTotalHaber.Value / 1000000), 2);

                    nTotalDebe += nTotalDebe2;
                    nTotalHaber += nTotalHaber2; 
                } else
                {
                    // Nota: cuando el usuario no quiere reconvertir, mantenemos el asiento de reconversión 
                    nTotalDebe = (from d in dbContab.dAsientos
                                      where d.CuentaContableID == Convert.ToInt32(Request.QueryString["cta"].ToString()) &&
                                            d.Asiento.Moneda == Convert.ToInt32(Request.QueryString["mon"]) &&
                                            d.Asiento.Fecha >= fechaInicialPeriodo &&
                                            d.Asiento.Fecha <= fechaFinalPeriodo 
                                  select (decimal?)d.Debe).Sum();

                    nTotalHaber = (from d in dbContab.dAsientos
                                       where d.CuentaContableID == Convert.ToInt32(Request.QueryString["cta"].ToString()) &&
                                             d.Asiento.Moneda == Convert.ToInt32(Request.QueryString["mon"]) &&
                                             d.Asiento.Fecha >= fechaInicialPeriodo &&
                                             d.Asiento.Fecha <= fechaFinalPeriodo 
                                   select (decimal?)d.Haber).Sum();
                }

                dbContab = null;

                if (MySumOfDebe_Label != null)
                    MySumOfDebe_Label.Text = nTotalDebe == null ? "0,00" : nTotalDebe.Value.ToString("#,##0.00");

                if (MySumOfHaber_Label != null)
                    MySumOfHaber_Label.Text = nTotalHaber == null ? "0,00" : nTotalHaber.Value.ToString("#,##0.00");

                // ---------------------------------------------------------------------------------------------------------------
                // agregamos el select statement al Sql DataSource; la idea es cambiarlo dependiendo de si el usuario 
                // quiere o no reconvertir las cifras por la reconversión de Oct/2.021. 
                if (bReconvertirCifrasAntes_01Oct2021 && (moneda == monedaNacional))
                {
                    // Ok, el usuario quiere reconvertir. Reconvertimos solo cifras anteriores a Oct/2.021 y en moneda nacional 
                    // hacemos un Union en el Select para aplicar la reconversión *solo* a movimientos anteriores al 1/Oct/2021 

                    // Nota: cuando el usuario quiere reconvertir, excluimos el asiento de reconversion 
                    this.MovimientosContables_SqlDataSource.SelectCommand = 
                    
                    // el 1er Select lee debe y haber *anterioes* al 1/Oct/21; reconvierte 
                    "Select d.Partida, d.NumeroAutomatico, a.Numero As NumeroComprobanteContable, a.Fecha As Fecha, " +
                        "d.Descripcion As DescripcionPartida, d.Referencia, " +
                        "Round((d.Debe / 1000000), 2) as Debe, Round((d.Haber / 1000000), 2) as Haber, Count(l.Id) as NumLinks, " +
                        "co.Abreviatura As NombreCiaContab, m.Simbolo As SimboloMoneda, mo.Simbolo As SimboloMonedaOriginal " +

                        "From dAsientos d Inner Join Asientos a On d.NumeroAutomatico = a.NumeroAutomatico Inner Join Monedas m on a.Moneda = m.Moneda " +
                        "Inner Join Monedas mo on a.MonedaOriginal = mo.Moneda Inner Join Companias co on a.Cia = co.Numero " +
                        "Left Join Asientos_Documentos_Links l on a.NumeroAutomatico = l.NumeroAutomatico " +

                        "Where (d.CuentaContableID = @CuentaContableID) And (a.Moneda = @Moneda) And (a.Fecha >= @FechaInicialPeriodo and a.Fecha < @FechaFinalPeriodo) And " +
                        "(a.Fecha < '2021-10-1') And (d.Referencia Is Null Or d.Referencia <> 'Reconversión 2021') " +

                        "Group By d.Partida, d.NumeroAutomatico, a.Numero, a.Fecha, d.Descripcion, d.Referencia, d.Debe, d.Haber, co.Abreviatura, m.Simbolo, mo.Simbolo " +

                        "Union " +

                    // el 2do Select lee debe y haber *posteriores* al 1/Oct/21; no reconvierte 
                    "Select d.Partida, d.NumeroAutomatico, a.Numero As NumeroComprobanteContable, a.Fecha As Fecha, " +
                        "d.Descripcion As DescripcionPartida, d.Referencia, d.Debe, d.Haber, Count(l.Id) as NumLinks, " +
                        "co.Abreviatura As NombreCiaContab, m.Simbolo As SimboloMoneda, mo.Simbolo As SimboloMonedaOriginal " +

                        "From dAsientos d Inner Join Asientos a On d.NumeroAutomatico = a.NumeroAutomatico Inner Join Monedas m on a.Moneda = m.Moneda " +
                        "Inner Join Monedas mo on a.MonedaOriginal = mo.Moneda Inner Join Companias co on a.Cia = co.Numero " +
                        "Left Join Asientos_Documentos_Links l on a.NumeroAutomatico = l.NumeroAutomatico " +

                        "Where (d.CuentaContableID = @CuentaContableID) And (a.Moneda = @Moneda) And (a.Fecha >= @FechaInicialPeriodo and a.Fecha <= @FechaFinalPeriodo) And " +
                        "(a.Fecha >= '2021-10-1') And (d.Referencia Is Null Or d.Referencia <> 'Reconversión 2021') " +

                        "Group By d.Partida, d.NumeroAutomatico, a.Numero, a.Fecha, d.Descripcion, d.Referencia, d.Debe, d.Haber, co.Abreviatura, m.Simbolo, mo.Simbolo " +

                        "Order By a.Fecha, a.Numero, d.Partida";
                }
            }
        }

        protected void BalanceComprobacion_ListView_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
        {
            //Clear the selected index.
            this.BalanceComprobacion_ListView.SelectedIndex = -1;

            // para saber si el usuario quiere reconvertir las cifras anteriores al 1-Oct-21 
            bool bReconvertirCifrasAntes_01Oct2021 = false;

            if (Session["ReconvertirCifrasAntes_01Oct2021"] != null)
                bReconvertirCifrasAntes_01Oct2021 = (bool)Session["ReconvertirCifrasAntes_01Oct2021"];

            var monedaNacional = 0;
            var moneda = 0;

            try
            {
                monedaNacional = Convert.ToInt32(Session["monedaNacional"]);
                moneda = Convert.ToInt32(Request.QueryString["mon"]);
            }
            catch (Exception err)
            {
                CustomValidator1.IsValid = false;
                CustomValidator1.ErrorMessage = "Hemos obtenido un error al intentar obtener la moneda y/o moneda nacional. <br /> " +
                                                "El mensaje específico del error obtenido es: " + err.Message;
                return;
            }

            // ---------------------------------------------------------------------------------------------------------------
            // agregamos el select statement al Sql DataSource; la idea es cambiarlo dependiendo de si el usuario 
            // quiere o no reconvertir las cifras por la reconversión de Oct/2.021. 
            if (bReconvertirCifrasAntes_01Oct2021 && (moneda == monedaNacional))
            {
                // Ok, el usuario quiere reconvertir. Reconvertimos solo cifras anteriores a Oct/2.021 y en moneda nacional 
                // hacemos un Union en el Select para aplicar la reconversión *solo* a movimientos anteriores al 1/Oct/2021 
                this.MovimientosContables_SqlDataSource.SelectCommand =

                // el 1er Select lee debe y haber *anterioes* al 1/Oct/21; reconvierte 
                "Select d.Partida, d.NumeroAutomatico, a.Numero As NumeroComprobanteContable, a.Fecha As Fecha, " +
                    "d.Descripcion As DescripcionPartida, d.Referencia, " +
                    "Round((d.Debe / 1000000), 2) as Debe, Round((d.Haber / 1000000), 2) as Haber, Count(l.Id) as NumLinks, " +
                    "co.Abreviatura As NombreCiaContab, m.Simbolo As SimboloMoneda, mo.Simbolo As SimboloMonedaOriginal " +

                    "From dAsientos d Inner Join Asientos a On d.NumeroAutomatico = a.NumeroAutomatico Inner Join Monedas m on a.Moneda = m.Moneda " +
                    "Inner Join Monedas mo on a.MonedaOriginal = mo.Moneda Inner Join Companias co on a.Cia = co.Numero " +
                    "Left Join Asientos_Documentos_Links l on a.NumeroAutomatico = l.NumeroAutomatico " +

                    "Where d.CuentaContableID = @CuentaContableID And a.Moneda = @Moneda And (a.Fecha >= @FechaInicialPeriodo and Fecha < '2021-10-1') And " +
                    "(d.Referencia <> 'Reconversión 2021') " +

                    "Group By d.Partida, d.NumeroAutomatico, a.Numero, a.Fecha, d.Descripcion, d.Referencia, d.Debe, d.Haber, co.Abreviatura, m.Simbolo, mo.Simbolo " +

                    "Union " +

                // el 2do Select lee debe y haber *posteriores* al 1/Oct/21; no reconvierte 
                "Select d.Partida, d.NumeroAutomatico, a.Numero As NumeroComprobanteContable, a.Fecha As Fecha, " +
                    "d.Descripcion As DescripcionPartida, d.Referencia, d.Debe, d.Haber, Count(l.Id) as NumLinks, " +
                    "co.Abreviatura As NombreCiaContab, m.Simbolo As SimboloMoneda, mo.Simbolo As SimboloMonedaOriginal " +

                    "From dAsientos d Inner Join Asientos a On d.NumeroAutomatico = a.NumeroAutomatico Inner Join Monedas m on a.Moneda = m.Moneda " +
                    "Inner Join Monedas mo on a.MonedaOriginal = mo.Moneda Inner Join Companias co on a.Cia = co.Numero " +
                    "Left Join Asientos_Documentos_Links l on a.NumeroAutomatico = l.NumeroAutomatico " +

                    "Where d.CuentaContableID = @CuentaContableID And a.Moneda = @Moneda And (a.Fecha >= '2021-10-1' and Fecha <= @FechaFinalPeriodo) And " +
                    "(d.Referencia <> 'Reconversión 2021') " +

                    "Group By d.Partida, d.NumeroAutomatico, a.Numero, a.Fecha, d.Descripcion, d.Referencia, d.Debe, d.Haber, co.Abreviatura, m.Simbolo, mo.Simbolo " +

                    "Order By a.Fecha, a.Numero, d.Partida";
            }
        }
    }
}
