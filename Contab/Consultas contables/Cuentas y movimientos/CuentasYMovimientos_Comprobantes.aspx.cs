using System;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Web.UI.HtmlControls;
using ContabSysNet_Web.ModelosDatos;

using System.Linq;
using ContabSysNet_Web.ModelosDatos_EF.code_first.contab;
using ContabSysNet_Web.Clases;

namespace ContabSysNetWeb.Contab.Consultas_contables.Cuentas_y_movimientos
{
    public partial class CuentasYMovimientos_Comprobantes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ErrMessage_Span.InnerHtml = "";
            ErrMessage_Span.Style["display"] = "none";

            if (!Page.IsPostBack)
            {
                HtmlGenericControl MyHtmlH2;

                MyHtmlH2 = (HtmlGenericControl)Master.FindControl("PageTitle_TableCell");
                if (!(MyHtmlH2 == null))
                {
                    MyHtmlH2.InnerHtml = "Consulta de Asientos Contables";
                }

                dbContabDataContext dbContab = new dbContabDataContext();

                int numeroAutomaticoAsiento = Convert.ToInt32(Page.Request.QueryString["NumeroAutomatico"]);

                // nótese que las páginas que usan esta página reciben, todas, este parámetro 
                bool bReconvertirCifrasAntes_01Oct2021 = false;
                try
                {
                    bReconvertirCifrasAntes_01Oct2021 = (bool)Session["ReconvertirCifrasAntes_01Oct2021"];
                } catch(Exception ex)
                {
                    ErrMessage_Span.InnerHtml = "Ud. debe aplicar un filtro antes de intentar abrir esta página. <br />" +
                                                "Aparentemente, no se ha aplicado un filtro aún. <br /> " + 
                                                "Por favor aplique un filtro. Luego regrese y ejecute esta función.";
                    ErrMessage_Span.Style["display"] = "block";

                    return; 
                }

                // si el usuario quiere aplicar la reconversión Oct/2021, lo indicamos al SqlDataSource con un parámetro 
                // el sqldatasource usa un Case para aplicar o no la operación (x/1M y redondear a 2 decimales) 
                // solo intentamos reconvertir si el asiento es en Bs y de fecha *anterior* a 1-oct-2021
                if (bReconvertirCifrasAntes_01Oct2021)
                {
                    var asiento = dbContab.Asientos.Where(x => x.NumeroAutomatico == numeroAutomaticoAsiento).Select(x => new { moneda = x.Moneda, fecha = x.Fecha }).First();

                    if (asiento.fecha >= new DateTime(2021, 10, 1))
                    {
                        bReconvertirCifrasAntes_01Oct2021 = false;
                    } else
                    {
                        // ----------------------------------------------------------------------------------------------------------------------
                        // leemos la tabla de monedas para 'saber' cual es la moneda Bs. Nota: la idea es aplicar las opciones de reconversión 
                        // *solo* a esta moneda 
                        var monedaNacional_return = Reconversion.Get_MonedaNacional();

                        if (monedaNacional_return.error)
                        {
                            ErrMessage_Span.InnerHtml = monedaNacional_return.message;
                            ErrMessage_Span.Style["display"] = "block";

                            return;
                        }

                        Monedas monedaNacional = monedaNacional_return.moneda;
                        // ----------------------------------------------------------------------------------------------------------------------

                        if (asiento.moneda != monedaNacional.Moneda)
                        {
                            bReconvertirCifrasAntes_01Oct2021 = false;
                        } else
                        {
                            this.Partidas_SqlDataSource.SelectParameters["Reconversion_2021"].DefaultValue = "si";
                        }
                    }
                }

                this.AsientosContables_SqlDataSource.SelectParameters["NumeroAutomatico"].DefaultValue = numeroAutomaticoAsiento.ToString();
                this.Partidas_SqlDataSource.SelectParameters["NumeroAutomatico"].DefaultValue = numeroAutomaticoAsiento.ToString();
                this.Asientos_Log_SqlDataSource.SelectParameters["NumeroAutomatico"].DefaultValue = numeroAutomaticoAsiento.ToString();
                this.AsientosLinks_SqlDataSource.SelectParameters["NumeroAutomatico"].DefaultValue = numeroAutomaticoAsiento.ToString();

                decimal? nTotalDebe = (from d in dbContab.dAsientos
                                       where d.NumeroAutomatico == numeroAutomaticoAsiento
                                       select (decimal?)d.Debe).Sum();

                decimal? nTotalHaber = (from d in dbContab.dAsientos
                                        where d.NumeroAutomatico == numeroAutomaticoAsiento
                                        select (decimal?)d.Haber).Sum();

                if (bReconvertirCifrasAntes_01Oct2021) {
                    nTotalDebe = Convert.ToDecimal(Math.Round(Convert.ToDouble(nTotalDebe) / 1000000, 2));
                    nTotalHaber = Convert.ToDecimal(Math.Round(Convert.ToDouble(nTotalHaber) / 1000000, 2));
                }

                Label MySumOfDebe_Label = (Label)Partidas_ListView.FindControl("SumOfDebe_Label");
                Label MySumOfHaber_Label = (Label)Partidas_ListView.FindControl("SumOfHaber_Label");

                if (MySumOfDebe_Label != null) 
                    MySumOfDebe_Label.Text = nTotalDebe != null ? nTotalDebe.Value.ToString("#,##0.000") : "0,000";

                if (MySumOfHaber_Label != null) 
                    MySumOfHaber_Label.Text = nTotalHaber != null ? nTotalHaber.Value.ToString("#,##0.000") : "0,000";

                dbContab = null;

                // establecemos la propiedad del link que permite obtener el reporte para este asiento contable ... 
                string url = "";
                url = "../../../ReportViewer.aspx?rpt=unasientocontable&NumeroAutomatico=" + numeroAutomaticoAsiento.ToString();
                ImprimirAsientoContable_HyperLink.HRef = "javascript:PopupWin('" + url + "', 1000, 680)"; 
            }
        }
    }
}
