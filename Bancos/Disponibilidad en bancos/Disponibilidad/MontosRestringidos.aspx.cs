using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Web.UI.HtmlControls; 

public partial class Bancos_Disponibilidad_en_bancos_Disponibilidad_MontosRestringidos : System.Web.UI.Page
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

        Master.Page.Title = "Consulta de disponibilidad - registro de montos restringidos";

        // -----------------------------------------------------------------------------------------

        if (!Page.IsPostBack)
        {
            //Gets a reference to a Label control that is not in a 
            //ContentPlaceHolder control

            HtmlContainerControl MyHtmlSpan;

            MyHtmlSpan = (HtmlContainerControl)(Master.FindControl("AppName_Span"));
            if (MyHtmlSpan != null)
                MyHtmlSpan.InnerHtml = "Bancos";

            HtmlGenericControl MyHtmlH2;

            MyHtmlH2 = (HtmlGenericControl)(Master.FindControl("PageTitle_TableCell"));
            if (MyHtmlH2 != null)
                MyHtmlH2.InnerHtml = "Consulta de disponibilidad - registro de montos restringidos";

            //--------------------------------------------------------------------------------------------
            //para asignar la página que corresponde al help de la página 

            HtmlAnchor MyHtmlHyperLink;
            MyHtmlHyperLink = (HtmlAnchor)Master.FindControl("Help_HyperLink");

            MyHtmlHyperLink.HRef = "javascript:PopupWin('../../../Doc/Bancos/Facturas/Consulta facturas/consulta_general_de_facturas.htm', 1000, 680)";

            // para que el ListView no regrese rows cuando se abre la página 
            Session["FiltroForma"] = "1 = 2";
            RefreshAndBindInfo();
        }
        else
        {
             //-------------------------------------------------------------------------
            // la página puede ser 'refrescada' por el popup; en ese caso, ejeucutamos  
            // una función que efectúa alguna funcionalidad y rebind la información 

            if (this.RebindFlagHiddenField.Value == "1")
            {
                RebindFlagHiddenField.Value = "0";
                RefreshAndBindInfo();

                // para refrescar el FormView (y que no muestre un registro) 
                MontosRestringidos_SqlDataSource.SelectParameters["ID"].DefaultValue = "-999";

                MontosRestringidos_FormView.DataBind();

                // para deseleccionar algún registro que esté seleccionado en la lista 
                MontosRestringidos_Lista_ListView.SelectedIndex = -1;  
            }
            else
            {
                // aparentemente, el SqlSelectCommand del SqlDataSource debe ser refrescado cada vez 

                MontosRestringidos_Lista_SqlDataSource.SelectCommand = MontosRestringidos_Lista_SqlDataSource.SelectCommand + " Where " + Session["FiltroForma"].ToString();
            }
            // -------------------------------------------------------------------------
        }
        
    }

    private void RefreshAndBindInfo()
    {
        // aplicamos el filtro al DataSource y hacemos un DataBind del ListView 

        if (!User.Identity.IsAuthenticated)
        {
            FormsAuthentication.SignOut();
            return;
        }


        if (Session["FiltroForma"] == null)
        {
            ErrMessage_Span.InnerHtml = "Aparentemente, Ud. no ha indicado un filtro aún.<br />Por favor indique y aplique un filtro antes de intentar mostrar el resultado de la consulta.";
            ErrMessage_Span.Style["display"] = "block";

            return;
        }

        MontosRestringidos_Lista_SqlDataSource.SelectCommand = MontosRestringidos_Lista_SqlDataSource.SelectCommand + " Where " + Session["FiltroForma"].ToString();

        MontosRestringidos_Lista_ListView.DataBind();
    }
    protected void MontosRestringidos_FormView_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        FormView MyFormView = (FormView) sender;

        if (!User.Identity.IsAuthenticated)
        {
            FormsAuthentication.SignOut();
            return;
        }

        if (e.Values["CiaContab"].ToString() == "0")
        {
            ErrMessage_Span.InnerHtml = "Ud. debe indicar un valor para el item Compañía.";
            ErrMessage_Span.Style["display"] = "block";

            e.Cancel = true;
            return;
        }

        DateTime b; 
        if (e.Values["Fecha"].ToString() == "" || e.Values["Fecha"] == null || 
            !DateTime.TryParse(e.Values["Fecha"].ToString(), out b))
        {
            ErrMessage_Span.InnerHtml = "Ud. debe indicar un valor para el item Fecha.";
            ErrMessage_Span.Style["display"] = "block";

            e.Cancel = true;
            return;
        }

        Decimal a; 
        if (e.Values["Monto"].ToString() == "" || e.Values["Monto"] == null ||
            !Decimal.TryParse(e.Values["Monto"].ToString(), out a))
        {
            ErrMessage_Span.InnerHtml = "Ud. debe indicar un valor para el item Monto.";
            ErrMessage_Span.Style["display"] = "block";

            e.Cancel = true;
            return;
        }

        if (e.Values["Comentarios"].ToString() == "" || e.Values["Comentarios"] == null)
        {
            ErrMessage_Span.InnerHtml = "Ud. debe indicar un valor para el item Observaciones.";
            ErrMessage_Span.Style["display"] = "block";

            e.Cancel = true;
            return;
        }

        // ---------------------------------------------------------------------------------------------
        // obtenemos el valor del 2do. ddl para actualizar el 'row' en el FormView 
        DropDownList ddl2 = (DropDownList)MyFormView.FindControl("Cuentas_DropDownList");

        // probablemente el 2do ddl está vacio pues no existen registros para el 1er. ddl seleccionado 
        if (ddl2.SelectedIndex == -1)
        {
            ErrMessage_Span.InnerHtml = "Ud. debe seleccionar una cuenta bancaria de la lista.<br /><br />Nota: si la lista de cuentas bancarias está vacía, es probable que no se hayan definido cuentas bancarias para la compañía seleccionada.";
            ErrMessage_Span.Style["display"] = "block";

            e.Cancel = true;
            return;
        }

        e.Values["CuentaBancaria"] = ddl2.SelectedValue;
        // ---------------------------------------------------------------------------------------------

        // si no hacemos ésto, la fecha es leída como m-d-y 
        if (e.Values["Fecha"] != null)
        {
            DateTime MyDate = DateTime.Parse(e.Values["Fecha"].ToString());
            e.Values["Fecha"] = DateTime.Parse(MyDate.ToString("yyyy-MM-dd"));
        }

        if (e.Values["DesactivarEl"] != "" && e.Values["DesactivarEl"] != null)
        {
            DateTime MyDate = DateTime.Parse(e.Values["DesactivarEl"].ToString());
            e.Values["DesactivarEl"] = DateTime.Parse(MyDate.ToString("yyyy-MM-dd"));
        }

        if (e.Values["Monto"] != null)
        {
            Decimal MyMonto = Decimal.Parse(e.Values["Monto"].ToString());
            e.Values["Monto"] = Decimal.Parse(MyMonto.ToString("N2"));
        }

    
        // inicializamos el valor de estos items en el registro 

        e.Values["Registro_Fecha"] = DateTime.Now;
        e.Values["Registro_Usuario"] = User.Identity.Name; 
        e.Values["UltAct_Fecha"] = DateTime.Now;
        e.Values["UltAct_Usuario"] = User.Identity.Name; 
    }
    protected void MontosRestringidos_FormView_ItemCreated(object sender, EventArgs e)
    {
        FormView MyFormView = (FormView)sender;

        // para mostrar defaults en los items de la forma 
        if (MyFormView.CurrentMode == FormViewMode.Insert)
        {
            TextBox MyFecha_TextBox = (TextBox)MyFormView.Row.FindControl("FechaTextBox");
            MyFecha_TextBox.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }
    protected void CiaContab_DropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        // para llenar el 2do. ddl en base a la selección del 1ro. 

        SqlDataSource dsc = (SqlDataSource)MontosRestringidos_FormView.FindControl("Cuentas_SqlDataSource");
        DropDownList ddl1 = (DropDownList)MontosRestringidos_FormView.FindControl("CiasContab_DropDownList");
        DropDownList ddl2 = (DropDownList)MontosRestringidos_FormView.FindControl("Cuentas_DropDownList");
        dsc.SelectParameters["Cia"].DefaultValue = ddl1.SelectedValue;
        ddl2.DataBind();
    }
    protected void MontosRestringidos_FormView_ItemUpdating(object sender, FormViewUpdateEventArgs e)
    {
        FormView MyFormView = (FormView)sender;

        if (!User.Identity.IsAuthenticated)
        {
            FormsAuthentication.SignOut();
            return;
        }

        DateTime b;
        if (e.NewValues["Fecha"].ToString() == "" || e.NewValues["Fecha"] == null ||
            !DateTime.TryParse(e.NewValues["Fecha"].ToString(), out b))
        {
            ErrMessage_Span.InnerHtml = "Ud. debe indicar un valor para el item Fecha.";
            ErrMessage_Span.Style["display"] = "block";

            e.Cancel = true;
            return;
        }

        if (!(e.NewValues["DesactivarEl"].ToString() == "" || e.NewValues["DesactivarEl"] == null) &&
            !DateTime.TryParse(e.NewValues["DesactivarEl"].ToString(), out b))
        {
            ErrMessage_Span.InnerHtml = "Ud. debe indicar un valor valido para el item Fecha Desactivación.";
            ErrMessage_Span.Style["display"] = "block";

            e.Cancel = true;
            return;
        }

        Decimal a;
        if (e.NewValues["Monto"].ToString() == "" || e.NewValues["Monto"] == null ||
            !Decimal.TryParse(e.NewValues["Monto"].ToString(), out a))
        {
            ErrMessage_Span.InnerHtml = "Ud. debe indicar un valor para el item Monto.";
            ErrMessage_Span.Style["display"] = "block";

            e.Cancel = true;
            return;
        }

        if (e.NewValues["Comentarios"].ToString() == "" || e.NewValues["Comentarios"] == null)
        {
            ErrMessage_Span.InnerHtml = "Ud. debe indicar un valor para el item Observaciones.";
            ErrMessage_Span.Style["display"] = "block";

            e.Cancel = true;
            return;
        }

        // inicializamos el valor de estos items en el registro 

        // si no hacemos ésto, la fecha es leída como m-d-y 
        if (e.NewValues["Fecha"] != null)
        {
            DateTime MyDate = DateTime.Parse(e.NewValues["Fecha"].ToString());
            e.NewValues["Fecha"] = DateTime.Parse(MyDate.ToString("yyyy-MM-dd"));
        }

        if (e.NewValues["DesactivarEl"] != "" && e.NewValues["DesactivarEl"] != null)
        {
            DateTime MyDate = DateTime.Parse(e.NewValues["DesactivarEl"].ToString());
            e.NewValues["DesactivarEl"] = DateTime.Parse(MyDate.ToString("yyyy-MM-dd"));
        }

        if (e.NewValues["Monto"] != null)
        {
            Decimal MyMonto = Decimal.Parse(e.NewValues["Monto"].ToString());
            e.NewValues["Monto"] = Decimal.Parse(MyMonto.ToString("N2"));
        }

        e.NewValues["UltAct_Fecha"] = DateTime.Now;
        e.NewValues["UltAct_Usuario"] = User.Identity.Name; 
    }
    protected void MontosRestringidos_Lista_ListView_SelectedIndexChanged(object sender, EventArgs e)
    {
        ListView MyListView = (ListView)sender;

        if (MyListView.SelectedIndex == -1)
            return; 

        DataKey MyDataKey = MyListView.DataKeys[MyListView.SelectedIndex];

        MontosRestringidos_SqlDataSource.SelectParameters["ID"].DefaultValue = MyDataKey["ID"].ToString();

        //MontosRestringidos_SqlDataSource.SelectParameters["CiaContab"].DefaultValue = MyDataKey["CiaContab"].ToString();
        //MontosRestringidos_SqlDataSource.SelectParameters["Moneda"].DefaultValue = MyDataKey["Moneda"].ToString();
        //MontosRestringidos_SqlDataSource.SelectParameters["CuentaBancaria"].DefaultValue = MyDataKey["CuentaBancaria"].ToString();

        MontosRestringidos_FormView.DataBind();
        TabContainer1.ActiveTabIndex = 1; 
    }
    protected void MontosRestringidos_Lista_ListView_PagePropertiesChanged(object sender, EventArgs e)
    {
        // to clear the selected row in the ListView when the user changes page 
        ListView MyListView = (ListView)sender;
        MyListView.SelectedIndex = -1;

        // el actve tab en el tab control puede estar en 1, lo ponemos en 0 pues el usuario está allí 
        // haciendo sort ... 
        TabContainer1.ActiveTabIndex = 0; 
    }
    protected void MontosRestringidos_FormView_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        MontosRestringidos_Lista_ListView.DataBind(); 
    }
    protected void MontosRestringidos_FormView_ItemDeleted(object sender, FormViewDeletedEventArgs e)
    {
        MontosRestringidos_Lista_ListView.DataBind(); 
    }
    protected void MontosRestringidos_FormView_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        MontosRestringidos_Lista_ListView.DataBind(); 
    }
   
    protected void MontosRestringidos_Lista_ListView_Sorted(object sender, EventArgs e)
    {
        // el actve tab en el tab control puede estar en 1, lo ponemos en 0 pues el usuario está allí 
        // haciendo sort ... 
        TabContainer1.ActiveTabIndex = 0; 
    }
}
