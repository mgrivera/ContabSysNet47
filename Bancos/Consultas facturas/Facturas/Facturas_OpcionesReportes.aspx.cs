using System;
using System.Web.Security;
using ContabSysNet_Web.ModelosDatos_EF.Bancos;
using System.Linq;
using System.Globalization;

public partial class Bancos_Facturas_Facturas_OpcionesReportes : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ErrMessage_Span.InnerHtml = "";
        ErrMessage_Span.Style["display"] = "none";

        GeneralMessage_Span.InnerHtml = "";
        GeneralMessage_Span.Style["display"] = "none";

        if (!Page.IsPostBack)
        {
            if (!User.Identity.IsAuthenticated)
            {
                FormsAuthentication.SignOut();
                return;
            }

            this.OpcionesLibroCompras_Fieldset.Visible = false;
            this.OpcionesConsultaGeneral_Div.Visible = false;
            this.OpcionesComprobantesRetencionIva_Fieldset.Visible = false;

            // -------------------------------------------------------------------------------------------------------------------
            //  intentamos recuperar el state de esta página; en general, lo intentamos con popups filtros 

            if (!(Membership.GetUser().UserName == null))
            {
                KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
                MyKeepPageState.ReadStateFromFile(this, this.Controls);
                MyKeepPageState = null;
            }

            if (string.IsNullOrEmpty(this.Titulo_TextBox.Text))
                this.Titulo_TextBox.Text = "Libro de Compras";


            // leemos apenas la 1ra. linea del archio con los registros seleccionados, para obtener nombre y rif de la cia contab ... 

            BancosEntities context = new BancosEntities();
            tTempWebReport_ConsultaFacturas factura =
                context.tTempWebReport_ConsultaFacturas.Where("it.NombreUsuario == '" + User.Identity.Name + "'").FirstOrDefault();


            if (factura != null)
            {
                this.CiaContabNombre_TextBox.Text = factura.CiaContabNombre;
                this.CiaContabRif_TextBox.Text = factura.CiaContabRif; 
            }

            this.DropDownList1.SelectedIndex = 0; 
        }
    }

    protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        switch (this.DropDownList1.SelectedIndex)
        {
            case 0:                     // Seleccione una opción ....  
                this.OpcionesLibroCompras_Fieldset.Visible = false;
                this.OpcionesConsultaGeneral_Div.Visible = false;
                this.OpcionesComprobantesRetencionIva_Fieldset.Visible = false;

                break;
            case 1:                     // general 
                this.OpcionesLibroCompras_Fieldset.Visible = false;
                this.OpcionesConsultaGeneral_Div.Visible = true;
                this.OpcionesComprobantesRetencionIva_Fieldset.Visible = false;

                break;
            case 2:                     // retenciones Iva 
                this.OpcionesLibroCompras_Fieldset.Visible = false;
                this.OpcionesConsultaGeneral_Div.Visible = false;
                this.OpcionesComprobantesRetencionIva_Fieldset.Visible = false;

                break;
            case 3:                     // retenciones Islr 
                this.OpcionesLibroCompras_Fieldset.Visible = false;
                this.OpcionesConsultaGeneral_Div.Visible = false;
                this.OpcionesComprobantesRetencionIva_Fieldset.Visible = false;

                break;
            case 4:                     // libro de compras
                this.OpcionesLibroCompras_Fieldset.Visible = true;
                this.OpcionesConsultaGeneral_Div.Visible = false;
                this.OpcionesComprobantesRetencionIva_Fieldset.Visible = false;

                break;
            case 5:                     // libro de ventas
                this.OpcionesLibroCompras_Fieldset.Visible = false;
                this.OpcionesConsultaGeneral_Div.Visible = false;
                this.OpcionesComprobantesRetencionIva_Fieldset.Visible = false;

                break;
            case 6:                     // Iva: comprobantes de retención 
                this.OpcionesLibroCompras_Fieldset.Visible = false;
                this.OpcionesConsultaGeneral_Div.Visible = false;
                this.OpcionesComprobantesRetencionIva_Fieldset.Visible = true;

                if (string.IsNullOrEmpty(this.ComprobanteIva_CiudadParaFecha_TextBox.Text))
                    this.ComprobanteIva_CiudadParaFecha_TextBox.Text = "Caracas";

                if (string.IsNullOrEmpty(this.ComprobanteIva_FechaEscrita_TextBox.Text))
                    this.ComprobanteIva_FechaEscrita_TextBox.Text = 
                        DateTime.Today.Day.ToString() + 
                        " de " + 
                        CultureInfo.CurrentCulture.TextInfo.ToTitleCase(DateTime.Today.ToString("MMMM").ToLower()) +    // para que la 1ra. letra esté en mayúsculas
                        " de " + 
                        DateTime.Today.Year.ToString("N0"); 

                break;
        } 
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        // -------------------------------------------------------------------------------------------
        // para guardar el contenido de los controles de la página para recuperar el state cuando 
        // se abra la proxima vez 

        KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
        MyKeepPageState.SavePageStateInFile(this.Controls);
        MyKeepPageState = null;
        // ---------------------------------------------------------------------------------------------

        switch (this.DropDownList1.SelectedIndex)
        {
            case 0:                     // Seleccione una opción ....  
                break;
            case 1:
                // general 
                {
                    string mostrarConcepto = "no";
                    if (this.MostrarConcepto_CheckBox.Checked)
                        mostrarConcepto = "si";

                    if (this.AgruparPorCompania_CheckBox.Checked)
                        Response.Redirect("~/ReportViewer.aspx?rpt=reportefacturas&opc=0&rep=1&concepto=" + mostrarConcepto);
                    else
                        Response.Redirect("~/ReportViewer.aspx?rpt=reportefacturas&opc=0&rep=2&concepto=" + mostrarConcepto);

                    break;
                }
            case 2:                     // retenciones Iva 
                Response.Redirect("~/ReportViewer.aspx?rpt=reportefacturas&opc=1");
                break;
            case 3:                     // retenciones Islr 
                Response.Redirect("~/ReportViewer.aspx?rpt=reportefacturas&opc=2");
                break;
            case 4:                     // libro de compras
                Response.Redirect("~/ReportViewer.aspx?rpt=reportefacturas&opc=3&tit=" +
                    this.Titulo_TextBox.Text +
                    "&subtit=" +
                    this.SubTitulo_TextBox.Text +
                    "&nombre=" +
                    Server.UrlEncode(this.CiaContabNombre_TextBox.Text) +
                    "&rif=" +
                    this.CiaContabRif_TextBox.Text +
                    "&per=" + this.Período_TextBox.Text);
                break;
            case 5:                     // libro de ventas
                Response.Redirect("~/ReportViewer.aspx?rpt=reportefacturas&opc=4");
                break;
            case 6:                    // Iva: comprobantes de retención 
                {
                    int opcion = 0;

                    if (this.ComprobanteIva_FormatoPdf_RadioButton.Checked)     // pdf 
                        opcion = 6;
                    else if (this.ComprobanteIva_FormatoEmail_RadioButton.Checked)      // email 
                        opcion = 7;
                    else if (this.ComprobanteIva_FormatoNormal_RadioButton.Checked)     // normal 
                        opcion = 5;

                    string correoCompania = (this.Email_EnviarCorreoCompania_CheckBox.Checked ? "si" : "no");
                    string correoUsuario = (this.Email_EnviarCorreoUsuario_CheckBox.Checked ? "si" : "no");


                    Response.Redirect("~/ReportViewer.aspx?rpt=reportefacturas&opc=" +
                        opcion.ToString() +
                        "&ciudad=" +
                        this.ComprobanteIva_CiudadParaFecha_TextBox.Text +
                        "&fecha=" +
                        this.ComprobanteIva_FechaEscrita_TextBox.Text +
                        "&l1=" + this.Email_Linea1_TextBox.Text +
                        "&l2=" + this.Email_Linea2_TextBox.Text +
                        "&l3=" + this.Email_Linea3_TextBox.Text +
                        "&l4=" + this.Email_Linea4_TextBox.Text +
                        "&l5=" + this.Email_Linea5_TextBox.Text +
                        "&compania=" + correoCompania +
                        "&usuario=" + correoUsuario);

                    break;
                }
            }
        }
}
