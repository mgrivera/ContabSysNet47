using ContabSysNet_Web.ModelosDatos_EF.Contab;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ContabSysNet_Web.Otros.reconversionMonetaria
{
    public partial class reconversionMonetaria_filter : System.Web.UI.Page
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
                // determinamos los años que se han registrado en el programa y los mostramos en una lista 
                dbContab_Contab_Entities context = new dbContab_Contab_Entities();

                var ciaContabSeleccionada = context.tCiaSeleccionadas.Where(s => s.UsuarioLS == User.Identity.Name).
                                                            Select(c => new { numero = c.Compania.Numero }).
                                                            FirstOrDefault();

                if (ciaContabSeleccionada == null)
                {

                    string errorMessage = "Error: aparentemente, no se ha seleccionado una <em>Cia Contab</em>.<br />" +
                                          "Por favor seleccione una <em>Cia Contab</em> y luego regrese y continúe con la ejecución de esta función.";

                    this.ErrMessage_Span.InnerHtml = errorMessage;
                    this.ErrMessage_Span.Visible = true;

                    return;
                }

                var anos = context.SaldosContables.Where(s => s.Cia == ciaContabSeleccionada.numero).
                                                    Select(s => new { ano = s.Ano }).
                                                    Distinct();

                var items = anos.OrderByDescending(a => a.ano); 

                anosRegistrados_listBox.Items.Clear();

                foreach(var ano in items)
                {
                    anosRegistrados_listBox.Items.Add(ano.ano.ToString());
                }

                this.CuentasContables_SqlDataSource.SelectParameters[0].DefaultValue = ciaContabSeleccionada.numero.ToString();
                this.cuentasContables_listBox.DataBind();

                // intentamos recuperar el state de esta página; en general, lo intentamos con popups filtros
                if (!(Membership.GetUser().UserName == null))
                {
                    KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, Page.GetType().Name);
                    MyKeepPageState.ReadStateFromFile(this, this.Controls);
                    MyKeepPageState = null;
                }
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
            Session["reconversionMonetaria.cantidadDigitos"] = null;
            Session["reconversionMonetaria.ano"] = null;

            if (this.cantidadDigitos_textBox.Text != "")
            {
                Session["reconversionMonetaria.cantidadDigitos"] = this.cantidadDigitos_textBox.Text;
            }

            if (this.anosRegistrados_listBox.SelectedIndex != -1)
            {
                Session["reconversionMonetaria.ano"] = this.anosRegistrados_listBox.SelectedValue;
            }

            if (this.cuentasContables_listBox.SelectedIndex != -1)
            {
                Session["reconversionMonetaria.cuentaContableID"] = this.cuentasContables_listBox.SelectedValue;
            }

            // -------------------------------------------------------------------------------------------
            // para guardar el contenido de los controles de la página para recuperar el state cuando
            // se abra la proxima vez
            KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, Page.GetType().Name);
            MyKeepPageState.SavePageStateInFile(this.Controls);

            MyKeepPageState = null;
            // ------------------------------------------------------------------------------------------------------
            // nótese lo que hacemos aquí para que RegisterStartupScript funcione cuando ejecutamos en Chrome ... 
            ScriptManager.RegisterStartupScript(this, this.GetType(),
                "CloseWindowScript",
                "<script language='javascript'>window.opener.RefreshPage(); window.close();</script>", false);
        }
    }
}