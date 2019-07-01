using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Text;
using ContabSysNet_Web.Clases;

namespace ContabSysNetWeb.Contab.Consultas_contables.BalanceGeneral
{
    public partial class BalanceGeneral_Filter : System.Web.UI.Page
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
                this.Sql_it_Cia_Numeric.DataSource = listaCiasContabAsignadas.GetListaCompaniasAsignadas();

                // pareciera que si no hacemos el databind para los listboxes aquí, la clase que regresa el state
                // encuentra estos controles sin sus datos
                Sql_it_Cia_Numeric.DataBind();
                Monedas_ListBox.DataBind();
                MonedasOriginales_ListBox.DataBind(); 

                // intentamos recuperar el state de esta página; en general, lo intentamos con popups filtros
                if (!(Membership.GetUser().UserName == null))
                {
                    KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, Page.GetType().Name);
                    MyKeepPageState.ReadStateFromFile(this, this.Controls);
                    MyKeepPageState = null;
                }
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
            if (this.Sql_it_Cia_Numeric.SelectedIndex == -1)
            {
                string errorMessage = "Ud. debe seleccionar una compañía (Contab) de la lista.";

                CustomValidator1.IsValid = false;
                CustomValidator1.ErrorMessage = errorMessage;

                return;
            }

            if (this.Monedas_ListBox.SelectedIndex == -1)
            {
                string errorMessage = "Ud. debe seleccionar una moneda de la lista.";

                CustomValidator1.IsValid = false;
                CustomValidator1.ErrorMessage = errorMessage;

                return;
            }

            if (!this.BalanceGeneral_RadioButton.Checked && !this.GyP_RadioButton.Checked)
            {
                string errorMessage = "Ud. debe indicar el tipo de consulta que desea obtener (balance general / ganancias y pérdias).";

                CustomValidator1.IsValid = false;
                CustomValidator1.ErrorMessage = errorMessage;

                return;
            }

            DateTime inicioPeriodo; 

            if (DateTime.TryParse(this.Desde_TextBox.Text, out inicioPeriodo))
            {
                if (inicioPeriodo.Day != 1)
                {
                    string errorMessage = "La fecha de inicio del período debe siempre corresponder a un 1ro. de mes (ej: 1-Mayo-2010).";

                    CustomValidator1.IsValid = false;
                    CustomValidator1.ErrorMessage = errorMessage;

                    return;
                }
            }

            BuildSqlCriteria MyConstruirCriterioSql = new BuildSqlCriteria();
            MyConstruirCriterioSql.LinqToEntities = true;                           // para que el criterio venga apropiado para aplicarlo a LinqToEntities 
            MyConstruirCriterioSql.ContruirFiltro(this.Controls);
            string sSqlSelectString = MyConstruirCriterioSql.CriterioSql;
            MyConstruirCriterioSql = null;

            // -------------------------------------------------------------------------------------------
            // para guardar el contenido de los controles de la página para recuperar el state cuando
            // se abra la proxima vez

            KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, Page.GetType().Name);
            MyKeepPageState.SavePageStateInFile(this.Controls);

            MyKeepPageState = null;

            // ---------------------------------------------------------------------------------------------
            // registramos los parámetros en un objeto y los persistimos en Session ... 
            BalanceGeneral_Parametros parametros = new BalanceGeneral_Parametros();

            parametros.CiaContab = Convert.ToInt32(this.Sql_it_Cia_Numeric.SelectedValue);
            parametros.Moneda = Convert.ToInt32(this.Monedas_ListBox.SelectedValue);
            parametros.MonedaOriginal = null;

            if (this.MonedasOriginales_ListBox.SelectedIndex != -1 && this.MonedasOriginales_ListBox.SelectedValue != "0")
                parametros.MonedaOriginal = Convert.ToInt32(this.MonedasOriginales_ListBox.SelectedValue); 

            parametros.Desde = Convert.ToDateTime(this.Desde_TextBox.Text);
            parametros.Hasta = Convert.ToDateTime(this.Hasta_TextBox.Text);
            parametros.BalGen_GyP = this.BalanceGeneral_RadioButton.Checked ? "BG" : "GyP"; 

            parametros.ExcluirCuentasSaldoYMovtosCero = this.ExcluirCuentasSinSaldoNiMovtos_CheckBox.Checked;
            parametros.ExcluirCuentasSaldosFinalCero = this.ExcluirCuentasConSaldoFinalCero_CheckBox.Checked; 
            parametros.ExcluirCuentasSinMovimientos = this.ExcluirCuentasSinMovimientos_CheckBox.Checked;

            // excluímos siempre estos asientos y dejamos de preguntar al usuario. Debemos quitar este parametro del sp y 
            // también de la definición del sp en el Entity Framework; mientras tanto, debemos conformarnos con hacerlo así ... 
            // POR AHORA, dejemos ésto así, pues tal vez haya que revisar esto en un futuro. Veamos si todo queda bien o hay \
            // que revisar en un futuro. Este tema es algo complicado ... NOTESE que la idea es excluir *solo* los asientos 
            // de cierre anual automáticos (mes 12) y no los que pueda agregar el usuario (mes 13). En otros meses del año fiscal 
            // *no debe* haber asientos del tipo cierre anual
            parametros.ExcluirAsientosContablesTipoCierreAnual = true; 

            parametros.Filtro = sSqlSelectString; 

            Session["BalanceGeneral_Parametros"] = parametros; 


            // la página que muestra los movimientos contables para una cuenta (seleccionada en la lista) 
            // corresponde al proceso que permite obtener el balance de comprobación; esta página usa 
            // estas session variables para delimitar el período; por lo tanto, las inicializamos también aquí ... 
            Session["FechaInicialPeriodo"] = Convert.ToDateTime(Desde_TextBox.Text);
            Session["FechaFinalPeriodo"] = Convert.ToDateTime(Hasta_TextBox.Text);

            // ---------------------------------------------------------------------------------------------
            // lo que sigue son instrucciones para ejecutar una función javascript en el parent page. La
            // función pone un hidden field en 1 y hace un submit (refresh) de la página
            ScriptManager.RegisterStartupScript(this, this.GetType(),
                "CloseWindowScript",
                "<script language='javascript'>window.opener.RefreshPage(); window.close();</script>", false); 
        }
    }
}
