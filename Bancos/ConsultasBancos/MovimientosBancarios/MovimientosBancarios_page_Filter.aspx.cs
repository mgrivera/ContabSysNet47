using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using ContabSysNet_Web.ModelosDatos_EF.ActivosFijos;
using ContabSysNet_Web.Clases;

namespace ContabSysNet_Web.Bancos.ConsultasBancos.MovimientosBancarios
{
    public partial class MovimientosBancarios_page_Filter : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
             Master.Page.Title = "... defina un filtro y haga un click en Aplicar Filtro para aplicarlo";

             ErrMessage_Span.InnerHtml = "";
             ErrMessage_Span.Style["display"] = "none";

             if (!User.Identity.IsAuthenticated)
             {
                 FormsAuthentication.SignOut();
                 return;
             }

             if (!Page.IsPostBack)
             {
                 // usamos una clase para construir una lista con las compañías (Contab) que se han asignado al usuario 
                 ConstruirListaCompaniasAsignadas listaCiasContabAsignadas = new ConstruirListaCompaniasAsignadas();
                 this.Sql_it_Chequera_CuentasBancaria_Cia_Numeric.DataSource = listaCiasContabAsignadas.GetListaCompaniasAsignadas();

                 //  pareciera que si no hacemos el databind para los listboxes aqu�, la clase que regresa el state 
                 //  encuentra estos controles sin sus datos 

                 this.Sql_it_Chequera_CuentasBancaria_Cia_Numeric.DataBind();
                 this.Sql_it_Chequera_CuentasBancaria_Agencia1_Banco1_Banco1_Numeric.DataBind();
                 this.Sql_it_Proveedore_Proveedor_Numeric.DataBind();
                 this.Sql_it_Chequera_CuentasBancaria_CuentaInterna_Numeric.DataBind();
                 this.Sql_it_Chequera_CuentasBancaria_Moneda1_Moneda1_Numeric.DataBind();
                 this.Sql_it_Usuario_String.DataBind();
                 this.Sql_it_Tipo_String.DataBind();

                 // -----------------------------------------------------------------------------------------------------------
                 //  intentamos recuperar el state de esta página; en general, lo intentamos con popups filtros 

                 if (!(Membership.GetUser().UserName == null))
                 {
                     KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
                     MyKeepPageState.ReadStateFromFile(this, this.Controls);
                     MyKeepPageState = null;
                 }
                 // -----------------------------------------------------------------------------------------------------------

                 this.AplicarFiltro_Button.Focus(); 
             }
        }

        protected void LimpiarFiltro_Button_Click(object sender, EventArgs e)
        {
            LimpiarFiltro MyLimpiarFiltro = new LimpiarFiltro(this);
            MyLimpiarFiltro.LimpiarControlesPagina();
            MyLimpiarFiltro = null;
        }

        protected void AplicarFiltro_Button_Click(object sender, EventArgs e)
        {
            if (Sql_it_Chequera_CuentasBancaria_Cia_Numeric.SelectedIndex == -1)
            {
                // el usuario debe siempre seleccionar, al menos, una compañía en la lista 
                ErrMessage_Span.InnerHtml = "Ud. debe seleccionar una Cia Contab de la lista.";
                ErrMessage_Span.Style["display"] = "block";

                return;
            }

            BuildSqlCriteria MyConstruirCriterioSql = new BuildSqlCriteria();
            MyConstruirCriterioSql.LinqToEntities = true;       // para que regrese un filtro apropiado para linq to entities ... 
            MyConstruirCriterioSql.ContruirFiltro(this.Controls);
            string sSqlSelectString = MyConstruirCriterioSql.CriterioSql;
            MyConstruirCriterioSql = null;


            Session["FiltroForma"] = sSqlSelectString;

            // -------------------------------------------------------------------------------------------------------------------------
            // para guardar el contenido de los controles de la página para recuperar el state cuando se abra la proxima vez 

            KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
            MyKeepPageState.SavePageStateInFile(this.Controls);
            MyKeepPageState = null;


            // para cerrar esta página y "refrescar" la que la abrió ... 
            //System.Text.StringBuilder sb = new System.Text.StringBuilder();
            //sb.Append("window.opener.RefreshPage();");
            //sb.Append("window.close();");
            //ClientScript.RegisterClientScriptBlock(this.GetType(), "CloseWindowScript", sb.ToString(), true);
            // ---------------------------------------------------------------------------------------------

            //System.Text.StringBuilder sb = new System.Text.StringBuilder();
            //sb.Append("window.opener.RefreshPage();");
            //sb.Append("window.close();");

            //ClientScript.RegisterClientScriptBlock(this.GetType(), "CloseWindowScript", sb.ToString(), true); 

            // ------------------------------------------------------------------------------------------------------
            // nótese lo que hacemos aquí para que RegisterStartupScript funcione cuando ejecutamos en Chrome ... 
            ScriptManager.RegisterStartupScript(this, this.GetType(),
                "CloseWindowScript",
                "<script language='javascript'>window.opener.RefreshPage(); window.close();</script>", false);

        }


        protected void Bancos_ListBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            ListBox listBox = (ListBox)sender;
            string whereFilter = ""; 

            foreach (ListItem item in listBox.Items)
            {
                if (item.Selected) 
                {
                    if (whereFilter == "") 
                        whereFilter = "(Agencias.Banco = " + item.Value.ToString(); 
                    else
                        whereFilter += " Or Agencias.Banco = " + item.Value.ToString(); 
                }
            }

            if (whereFilter != "")
                whereFilter += ")";
            else
                whereFilter = "(1 = 1)";

            this.CuentasBancarias_SqlDataSource.SelectCommand = this.CuentasBancarias_SqlDataSource.SelectCommand.ToString() +
                " Where " + whereFilter + 
                " Order By CuentasBancarias.CuentaBancaria"; 
        }  
    }
}