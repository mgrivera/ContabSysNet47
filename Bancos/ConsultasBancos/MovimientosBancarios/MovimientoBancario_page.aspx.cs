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

namespace ContabSysNet_Web.Bancos.ConsultasBancos.MovimientosBancarios
{
    public partial class MovimientoBancario_page : System.Web.UI.Page
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            this.MovimientoBancario_FormView.EnableDynamicData(typeof(MovimientosBancario));
            //this.DynamicDataManager1.RegisterControl(MovimientoBancario_FormView);
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                HtmlGenericControl MyHtmlH2;

                MyHtmlH2 = (HtmlGenericControl)Master.FindControl("PageTitle_TableCell");
                if (!(MyHtmlH2 == null))
                {
                    MyHtmlH2.InnerHtml = "Movimiento bancario - Consulta";
                }

                this.MovimientoBancario_EntityDataSource.WhereParameters["MovimientoBancarioID"].DefaultValue = Page.Request.QueryString["ID"].ToString();

                // ---------------------------------------------------------------------------------------------------
                // para permitir mostrar el asiento contable asociado, con un click al hyperlink  ... 

                int movimientoBancarioID = Convert.ToInt32(Page.Request.QueryString["ID"].ToString());

                // para buscar el asiento contable asociado, debemos obtener su ID (NumeroAutomatico); para hacerlo, leemos el asiento 
                // antes; nótese que lo obtenemos usando el pk del movimiento bancario 

                dbContab_Contab_Entities contabContext = new dbContab_Contab_Entities();

                ContabSysNet_Web.ModelosDatos_EF.Contab.Asiento asientoContable =
                    contabContext.Asientos.Where(a => a.ProvieneDe == "Bancos" && a.ProvieneDe_ID == movimientoBancarioID).FirstOrDefault();

                string url = "";

                if (asientoContable != null)
                    url = "../../../Contab/Consultas contables/Cuentas y movimientos/CuentasYMovimientos_Comprobantes.aspx" +
                          "?NumeroAutomatico=" + asientoContable.NumeroAutomatico.ToString();
                else
                    url = "../../../Contab/Consultas contables/Cuentas y movimientos/CuentasYMovimientos_Comprobantes.aspx" +
                          "?NumeroAutomatico=-999";

                MostrarAsientoContable_HyperLink.HRef = "javascript:PopupWin('" + url + "', 1000, 680)"; 
            }
        }
    }
}
