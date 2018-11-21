using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.Security;
using ContabSysNet_Web.ModelosDatos;
using System.Linq; 


public partial class Contab_Presupuesto_Consultas_Mensual_ConsultaPresupuesto_ConsultaMovMes : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!User.Identity.IsAuthenticated)
        {
            FormsAuthentication.SignOut();
            return;
        }

        // -----------------------------------------------------------------------------------------

        Master.Page.Title = "Consulta de presupuesto  -  consulta de movimientos contables para un código de presupuesto y un mes";

        ErrMessage_Span.InnerHtml = "";
        ErrMessage_Span.Style["display"] = "none";

        if (!Page.IsPostBack)
        {
            HtmlGenericControl MyHtmlH2;

            MyHtmlH2 = (HtmlGenericControl)(Master.FindControl("PageTitle_TableCell"));
            if (MyHtmlH2 != null)
                MyHtmlH2.InnerHtml = "";

            MovimientosContables_SqlDataSource.SelectParameters["MesFiscal"].DefaultValue = Request.QueryString["MesFiscal"].ToString();
            MovimientosContables_SqlDataSource.SelectParameters["AnoFiscal"].DefaultValue = Request.QueryString["AnoFiscal"].ToString();
            MovimientosContables_SqlDataSource.SelectParameters["CiaContab"].DefaultValue = Request.QueryString["CiaContab"].ToString();
            MovimientosContables_SqlDataSource.SelectParameters["Moneda"].DefaultValue = Request.QueryString["Moneda"].ToString();
            MovimientosContables_SqlDataSource.SelectParameters["CodigoPresupuesto"].DefaultValue = Request.QueryString["CodigoPresupuesto"].ToString();
            
            // leemos el nombre del mes, usando el mes fiscal y la compañía contab 

            dbContabDataContext dbContab = new dbContabDataContext();

            var MyMesesAnoFiscal = (from meses in dbContab.MesesDelAnoFiscals
                                    where meses.Cia == Convert.ToInt32(Request.QueryString["CiaContab"].ToString())
                                && meses.MesFiscal == int.Parse(Request.QueryString["MesFiscal"].ToString())
                                select meses).FirstOrDefault();

            if (MyMesesAnoFiscal == null)
            {
                dbContab = null;

                ErrMessage_Span.InnerHtml = "Aparentemente, no existe un registro en la tabla <i>Meses del Año Fiscal<i/> para alguna de las compañías seleccionada y el mes que se desea consultar.<br /><br />Por favor revise esta situación. La tabla tabla <i>Meses del Año Fiscal<i/> debe contener un registro cada una de las compañías registradas en <i>Contab<i/>.";
                ErrMessage_Span.Style["display"] = "block";

                Session["Progress_SelectedRecs"] = 0;
                Session["Progress_Completed"] = 1;
                Session["Progress_Percentage"] = 0;

                return;
            }

            TituloConsulta_H2.InnerHtml = "Movimientos contables para el código de presupuesto " +
                            Request.QueryString["CodigoPresupuesto"].ToString() + "&nbsp;&nbsp;&nbsp;" + Request.QueryString["NombreCodigoPresupuesto"].ToString() + "<br /> " +
                            "para el mes " + MyMesesAnoFiscal.NombreMes + " del año fiscal " + Request.QueryString["AnoFiscal"].ToString();

            // usamos linq to sql para obtener un total de los movimientos seleccionados y mostrados 

            decimal? nGranTotal = (decimal?)(from da in dbContab.dAsientos
                              from pacc in dbContab.Presupuesto_AsociacionCodigosCuentas
                                             where da.CuentaContableID == pacc.CuentaContableID &&
                              da.Asiento.Cia == pacc.CiaContab &&
                              da.Asiento.MesFiscal == int.Parse(Request.QueryString["MesFiscal"].ToString()) &&
                              da.Asiento.AnoFiscal == int.Parse(Request.QueryString["AnoFiscal"].ToString()) &&
                              da.Asiento.Moneda == int.Parse(Request.QueryString["Moneda"].ToString()) &&
                              da.Asiento.Cia == int.Parse(Request.QueryString["CiaContab"].ToString()) && 
                              pacc.CodigoPresupuesto == Request.QueryString["CodigoPresupuesto"].ToString()
                              select new Nullable<Decimal>(da.Debe - da.Haber)).Sum();

            Label MyTotalLabel = (Label)MovimientosContables_ListView.FindControl("GranTotal_Label");

            if (nGranTotal.HasValue) 
                MyTotalLabel.Text = nGranTotal.Value.ToString("N2");

            dbContab = null; 
        }
        else
        {
        }

        MovimientosContables_ListView.DataBind();
    }
}
