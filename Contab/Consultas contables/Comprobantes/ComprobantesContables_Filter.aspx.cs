using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Web.Security;
using System.Text;
using ContabSysNet_Web.Clases; 

namespace ContabSysNetWeb.Contab.Consultas_contables.Comprobantes
{
    public partial class ComprobantesContables_Filter : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated)
            {
                FormsAuthentication.SignOut();
                return;
            }

            ErrMessage_Span.InnerHtml = "";
            ErrMessage_Span.Style["display"] = "none";

            if (!Page.IsPostBack)
            {
                // usamos una clase para construir una lista con las compañías (Contab) que se han asignado al usuario 
                ConstruirListaCompaniasAsignadas listaCiasContabAsignadas = new ConstruirListaCompaniasAsignadas();
                this.Sql_Asientos_Cia_Numeric.DataSource = listaCiasContabAsignadas.GetListaCompaniasAsignadas();

                // pareciera que si no hacemos el databind para los listboxes aquí, la clase que regresa el state
                // encuentra estos controles sin sus datos
                this.Sql_Asientos_ProvieneDe_String.DataBind();
                this.Sql_Asientos_Tipo_String.DataBind();
                this.Sql_Asientos_Cia_Numeric.DataBind();
                this.Sql_Asientos_Moneda_Numeric.DataBind();
                this.Sql_Asientos_Usuario_String.DataBind(); 

                // intentamos recuperar el state de esta página; en general, lo intentamos con popups filtros

                if (!(Membership.GetUser().UserName == null))
                {
                    KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, Page.GetType().Name);
                    MyKeepPageState.ReadStateFromFile(this, this.Controls);
                    MyKeepPageState = null;
                }

                Session["filtroForma_consultaAsientosContables"] = null;
                Session["filtroForma_consultaAsientosContables_subQuery"] = null;

                Session["FechaInicial"] = null;
                Session["FechaFinal"] = null;
                Session["CiaContabSeleccionada"] = null;

                Session["SoloAsientosDescuadrados"] = null;                           
            }

            this.CustomValidator1.IsValid = true;
            this.CustomValidator1.Visible = false; 
        }

        protected void LimpiarFiltro_Button_Click(object sender, EventArgs e)
        {
            LimpiarFiltro MyLimpiarFiltro = new LimpiarFiltro(this);
            MyLimpiarFiltro.LimpiarControlesPagina();
            MyLimpiarFiltro = null;
        }

        protected void AplicarFiltro_Button_Click(object sender, EventArgs e)
        {
            if (this.Sql_Asientos_Cia_Numeric.SelectedIndex == -1)
            {
                // el usuario debe siempre seleccionar, al menos, una compañía en la lista 
                ErrMessage_Span.InnerHtml = "Ud. debe seleccionar una Cia Contab de la lista.";
                ErrMessage_Span.Style["display"] = "block";

                return;
            }

            BuildSqlCriteria MyConstruirCriterioSql = new BuildSqlCriteria("E", "Sql_CuentasContables_Cuenta_String");
            MyConstruirCriterioSql.ContruirFiltro(this.Controls);
            object sSqlSelectString = MyConstruirCriterioSql.CriterioSql;

            sSqlSelectString = sSqlSelectString + " And (Asientos.Fecha Between '" + Convert.ToDateTime(Desde_TextBox.Text).ToString("yyyyMMdd") + "'";
            sSqlSelectString = sSqlSelectString + " And '" + Convert.ToDateTime(Hasta_TextBox.Text).ToString("yyyyMMdd") + "')";

            // las fechas no tienen un nombre adecuado para que la clase anterior las incluya al filtro; preferimos hacerlo aquí, de esta forma
            if (!String.IsNullOrEmpty(this.Numero_Desde_TextBox.Text))
            {
                if (!String.IsNullOrEmpty(this.Numero_Hasta_TextBox.Text))
                {
                    // el usuario usó ambos números (desde/hasta) para indicar un rango de asientos 
                    sSqlSelectString = sSqlSelectString + " And (Asientos.Numero Between " + this.Numero_Desde_TextBox.Text + " And " + this.Numero_Hasta_TextBox.Text + ")"; 
                }
                else
                {
                    // el usuario usó solo el número de asiento de inicio para buscar solo ese asiento 
                    sSqlSelectString = sSqlSelectString + " And (Asientos.Numero = " + this.Numero_Desde_TextBox.Text + ")";
                }
            }

            if (this.ExcluirAsientosDeTipoCierreAnual_CheckBox.Checked)
            {
                sSqlSelectString = sSqlSelectString + " And (Not (Asientos.MesFiscal = 13 Or " +
                                                      "(Asientos.AsientoTipoCierreAnualFlag Is Not Null And " +
                                                      "Asientos.AsientoTipoCierreAnualFlag = 1)))";
            }

            if (this.SoloAsientosTipoCierreAnual_CheckBox.Checked)
            {
                sSqlSelectString = sSqlSelectString + " And (Asientos.MesFiscal = 13 Or " +
                                                      "(Asientos.AsientoTipoCierreAnualFlag Is Not Null And " +
                                                      "Asientos.AsientoTipoCierreAnualFlag = 1))";
            }

            // nota: construimos un filtro para ser aplicado como un subquery al select original; *solo* cuando el usuario usa los criterios: 
            // con más de 2 decimales o por cuenta contable ... 
            string sSqlSelectString_subQuery = "";

            BuildSqlCriteria MyConstruirCriterioSql_subQuery = new BuildSqlCriteria("I", "Sql_CuentasContables_Cuenta_String");
            MyConstruirCriterioSql_subQuery.ContruirFiltro(this.Controls);
            sSqlSelectString_subQuery = MyConstruirCriterioSql_subQuery.CriterioSql;

            if (this.SoloAsientosConMas2Decimales_CheckBox.Checked)
            {
                // con esta instrucción seleccionamos montos con más de 2 decimales 
                sSqlSelectString_subQuery = sSqlSelectString_subQuery + 
                                            " And ((((abs(dAsientos.Debe) * 100) - CONVERT(bigint, (abs(dAsientos.Debe) * 100))) <> 0) Or " +
                                            "(((abs(dAsientos.Haber) * 100) - CONVERT(bigint, (abs(dAsientos.Haber) * 100))) <> 0))";
            }

            MyConstruirCriterioSql = null;
            MyConstruirCriterioSql_subQuery = null; 

            Session["filtroForma_consultaAsientosContables"] = sSqlSelectString;
            Session["filtroForma_consultaAsientosContables_subQuery"] = sSqlSelectString_subQuery;

            // ------------------------------------------------------------------------------------------------
            // guardamos las fechas del período para posterior referencia
            Session["FechaInicial"] = Convert.ToDateTime(Desde_TextBox.Text);
            Session["FechaFinal"] = Convert.ToDateTime(Hasta_TextBox.Text);
            Session["CiaContabSeleccionada"] = this.Sql_Asientos_Cia_Numeric.SelectedValue;

            Session["SoloAsientosDescuadrados"] = null;
            if (this.SoloAsientosDescuadrados_CheckBox.Checked)
            {
                Session["SoloAsientosDescuadrados"] = true;
            }

            Session["SoloAsientosConUploads_CheckBox"] = null;
            if (this.SoloAsientosConUploads_CheckBox.Checked)
            {
                Session["SoloAsientosConUploads_CheckBox"] = true;
            }

            // -------------------------------------------------------------------------------------------
            // para guardar el contenido de los controles de la página para recuperar el state cuando
            // se abra la proxima vez

            KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, Page.GetType().Name);
            MyKeepPageState.SavePageStateInFile(this.Controls);

            MyKeepPageState = null;
            //---------------------------------------------------------------------------------------------
            //lo que sigue son instrucciones para ejecutar una función javascript en el parent page. La
            //función pone un hidden field en 1 y hace un submit (refresh) de la página

            // ------------------------------------------------------------------------------------------------------
            // nótese lo que hacemos aquí para que RegisterStartupScript funcione cuando ejecutamos en Chrome ... 
            ScriptManager.RegisterStartupScript(this, this.GetType(),
                "CloseWindowScript",
                "<script language='javascript'>window.opener.RefreshPage(); window.close();</script>", false); 
        }
    }
}
