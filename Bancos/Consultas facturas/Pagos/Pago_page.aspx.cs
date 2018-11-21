using System;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Web.UI.HtmlControls;
//using ContabSysNet_Web.ModelosDatos;

using System.Linq;
using ContabSysNet_Web.ModelosDatos_EF.Bancos;
using ContabSysNet_Web.ModelosDatos_EF.Contab;
using System.Collections.Generic;
using System.Text; 

namespace ContabSysNet_Web.Bancos.ConsultasFacturas.Pagos
{
    public partial class Pago_page : System.Web.UI.Page
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            this.Pago_FormView.EnableDynamicData(typeof(Pago));
            //this.DynamicDataManager1.RegisterControl(Pago_FormView);
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                HtmlGenericControl MyHtmlH2;

                MyHtmlH2 = (HtmlGenericControl)Master.FindControl("PageTitle_TableCell");
                if (!(MyHtmlH2 == null))
                {
                    MyHtmlH2.InnerHtml = "Pagos - Consulta";
                }

                this.Pago_EntityDataSource.WhereParameters["PagoID"].DefaultValue = Page.Request.QueryString["ID"].ToString();
                this.Facturas_EntityDataSource.WhereParameters["PagoID"].DefaultValue = Page.Request.QueryString["ID"].ToString();

                // ---------------------------------------------------------------------------------------------------
                // para permitir mostrar el asiento contable asociado, con un click al hyperlink  ... 

                int pagoID = Convert.ToInt32(Page.Request.QueryString["ID"].ToString());

                // para buscar el asiento contable asociado, debemos obtener su ID (NumeroAutomatico); para hacerlo, leemos el asiento 
                // antes; nótese que lo obtenemos usando el pk del movimiento bancario 

                BancosEntities bancosContext = new BancosEntities();

                MovimientosBancario movimientoBancario = bancosContext.MovimientosBancarios.Where(m => m.PagoID == pagoID).FirstOrDefault();

                string url = "";

                if (movimientoBancario != null) 
                    url = "../../ConsultasBancos/MovimientosBancarios/MovimientoBancario_page.aspx?ID=" + movimientoBancario.ClaveUnica.ToString();
                else
                    url = "../../ConsultasBancos/MovimientosBancarios/MovimientoBancario_page.aspx?ID=-999";

                MostrarMovimientoBancario_HyperLink.HRef = "javascript:PopupWin('" + url + "', 1000, 680)"; 
            }
        }
    }
}
