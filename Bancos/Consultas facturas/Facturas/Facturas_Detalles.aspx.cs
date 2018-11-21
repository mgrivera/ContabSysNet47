using System;
using System.Web.UI.WebControls;
using System.Web.Security;
using ContabSysNet_Web.ModelosDatos_EF.Bancos;
using System.Web.ModelBinding;
using System.Linq;
using System.Collections.Generic;
using System.Web.UI.HtmlControls; 

public partial class Bancos_Facturas_Facturas_Detalles : System.Web.UI.Page
{
    string _sClaveUnicaFactura = "";
    BancosEntities _bancosContext = new BancosEntities();

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!User.Identity.IsAuthenticated)
        {
            FormsAuthentication.SignOut();
            return;
        }

        if (!Page.IsPostBack)
        {
            HtmlGenericControl MyHtmlH2;

            MyHtmlH2 = (HtmlGenericControl)Master.FindControl("PageTitle_TableCell");
            if (!(MyHtmlH2 == null))
            {
                MyHtmlH2.InnerHtml = "Facturas - Consulta";
            }
        }
            

        _sClaveUnicaFactura = Request.QueryString["cuf"].ToString(); 

        ErrMessage_Span.InnerHtml = "";
        ErrMessage_Span.Style["display"] = "none";

        Factura_SqlDataSource.SelectParameters["ClaveUnicaFactura"].DefaultValue = _sClaveUnicaFactura;
        Factura_SqlDataSource.SelectParameters["NombreUsuario"].DefaultValue = Membership.GetUser().UserName;

        Pagos_SqlDataSource.SelectParameters["ClaveUnicaFactura"].DefaultValue = _sClaveUnicaFactura;

        // ---------------------------------------------------------------------------------------------
        // nótese como construímos los links que abren páginas con información relaciionada ... 

        this.MostrarCuotas_HyperLink.HRef = "javascript:PopupWin('Facturas_Cuotas.aspx?FacturaID=" + _sClaveUnicaFactura + "', 1000, 680)";
        this.MostrarAsientosContables_HyperLink.HRef = "javascript:PopupWin('../../../Contab/Consultas contables/Comprobantes/ComprobantesContables_Lista.aspx?ProvieneDe=Facturas&ProvieneDe_ID=" + _sClaveUnicaFactura + "', 1000, 680)";
    }

    // The id parameter should match the DataKeyNames value set on the control
    // or be decorated with a value provider attribute, e.g. [QueryString]int id
    public Factura Factura_FormView_GetItem([QueryString]int? cuf)
    {
        Factura item = null; 

        if (cuf != null)
            item = _bancosContext.Facturas.Where(f => f.ClaveUnica == cuf.Value).FirstOrDefault();

        return item; 
        
    }

    public string NombreEstadoFactura(object estado)
    {
        int intEstado = 0;
        string nombreEstado = "indefinido";

        if (int.TryParse(estado.ToString(), out intEstado))
        {
            switch (intEstado)
            {
                case 1:
                    nombreEstado = "Pendiente";
                    break;
                case 2:
                    nombreEstado = "Parcial";
                    break;
                case 3:
                    nombreEstado = "Pagado";
                    break;
                case 4:
                    nombreEstado = "Anulada";
                    break;
            }
        }

        return nombreEstado;
    }


    public string NombreCxCCxP(object cxccxpFlag)
    {
        int intcxcCxpFlag = 0;
        string nombreCxCCxP = "indefinido";

        if (int.TryParse(cxccxpFlag.ToString(), out intcxcCxpFlag))
        {
            switch (intcxcCxpFlag)
            {
                case 1:
                    nombreCxCCxP = "CxP";
                    break;
                case 2:
                    nombreCxCCxP = "CxC";
                    break;
            }
        }

        return nombreCxCCxP;
    }

    public string FormatDecimal(object decimalNullableNumber) 
    {
        if (decimalNullableNumber == null)
            return ""; 

        decimal decimalNumber;

        if (decimal.TryParse(decimalNullableNumber.ToString(), out decimalNumber))
            return decimalNumber.ToString("N2");
        else
            return ""; 
    }

    public IEnumerable<ContabSysNet_Web.ModelosDatos_EF.Bancos.Facturas_Impuestos> impuestosRetenciones_Repeater_GetData()
    {
        int claveUnicaFactura = Convert.ToInt32(_sClaveUnicaFactura);
        var query = _bancosContext.Facturas_Impuestos.Include("ImpuestosRetencionesDefinicion").Where(i => i.FacturaID == claveUnicaFactura).OrderBy(i => i.ID); 
        return query;
    }
}
