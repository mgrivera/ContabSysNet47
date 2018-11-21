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

                MovimientosContables_LinqDataSource.WhereParameters["CuentaContableID"].DefaultValue = Request.QueryString["cta"];
                MovimientosContables_LinqDataSource.WhereParameters["Moneda"].DefaultValue = Request.QueryString["mon"];

                MovimientosContables_LinqDataSource.WhereParameters["FechaInicialPeriodo"].DefaultValue = Session["FechaInicialPeriodo"].ToString();
                MovimientosContables_LinqDataSource.WhereParameters["FechaFinalPeriodo"].DefaultValue = Session["FechaFinalPeriodo"].ToString();

                dbContabDataContext dbContab = new dbContabDataContext();

                var query = (from cta in dbContab.CuentasContables
                             where cta.ID == Convert.ToInt32(Request.QueryString["cta"])
                             select new { cta.CuentaEditada, cta.Descripcion }).FirstOrDefault();

                DateTime FechaInicialPeriodo = (System.DateTime)Session["FechaInicialPeriodo"];
                DateTime FechaFinalPeriodo = (System.DateTime)Session["FechaFinalPeriodo"];

                TituloPagina.InnerHtml = "Movimientos contables para la cuenta <i>" + query.CuentaEditada + " - " + query.Descripcion + "</i><br /> en el período " + FechaInicialPeriodo.ToString("dd-MMM-yy") + " a " + FechaFinalPeriodo.ToString("dd-MMM-yy");


                // ahora sumarizamos el debe y el haber para la cuenta y período indicados ... 

                var nTotalDebe = (from d in dbContab.dAsientos
                                  where d.CuentaContableID == Convert.ToInt32(Request.QueryString["cta"].ToString()) &&
                                        d.Asiento.Moneda == Convert.ToInt32(Request.QueryString["mon"]) &&
                                        d.Asiento.Fecha >= Convert.ToDateTime(Session["FechaInicialPeriodo"].ToString()) &&
                                        d.Asiento.Fecha <= Convert.ToDateTime(Session["FechaFinalPeriodo"].ToString())
                                  select (decimal?)d.Debe).Sum();

                var nTotalHaber = (from d in dbContab.dAsientos
                                  where d.CuentaContableID == Convert.ToInt32(Request.QueryString["cta"].ToString()) &&
                                        d.Asiento.Moneda == Convert.ToInt32(Request.QueryString["mon"]) &&
                                        d.Asiento.Fecha >= Convert.ToDateTime(Session["FechaInicialPeriodo"].ToString()) &&
                                        d.Asiento.Fecha <= Convert.ToDateTime(Session["FechaFinalPeriodo"].ToString())
                                   select (decimal?)d.Haber).Sum();


                Label MySumOfDebe_Label = (Label)BalanceComprobacion_ListView.FindControl("SumOfDebe_Label");
                Label MySumOfHaber_Label = (Label)BalanceComprobacion_ListView.FindControl("SumOfHaber_Label");

                if (MySumOfDebe_Label != null) 
                    MySumOfDebe_Label.Text = nTotalDebe == null ? "0,00" : nTotalDebe.Value.ToString("#,##0.00");

                if (MySumOfHaber_Label != null) 
                    MySumOfHaber_Label.Text = nTotalHaber == null ? "0,00" : nTotalHaber.Value.ToString("#,##0.00");

                dbContab = null;
            }
        }
    }
}
