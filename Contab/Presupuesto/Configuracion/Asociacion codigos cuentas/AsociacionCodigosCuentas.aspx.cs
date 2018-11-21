using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.Security;
using ContabSysNet_Web.ModelosDatos;


public partial class Contab_Presupuesto_Configuracion_Asociacion_codigos_cuentas_AsociacionCodigosCuentas : System.Web.UI.Page
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

        CuentasContables_Message_Span.InnerHtml = "";
        CuentasContables_Message_Span.Style["display"] = "none";

        CodigosPresupuesto_Message_Span.InnerHtml = "";
        CodigosPresupuesto_Message_Span.Style["display"] = "none";

        if (!Page.IsPostBack)
        {

            Master.Page.Title = "Presupuesto - Asociación entre códigos de presupuesto y cuentas contables";

            HtmlGenericControl MyHtmlH2;

            MyHtmlH2 = (HtmlGenericControl)(Master.FindControl("PageTitle_TableCell"));
            if (MyHtmlH2 != null)
                MyHtmlH2.InnerHtml = "Presupuesto - Asociación entre códigos de presupuesto y cuentas contables";
        }
        else
        {
        }

    }
    protected void CiasContab_DropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {

        if (CiasContab_DropDownList.SelectedValue == "-1")
        {
            CodigosPresupuesto_SqlDataSource.SelectParameters["CiaContab"].DefaultValue = "-999"; 
            CuentasContables_SqlDataSource.SelectParameters["CiaContab"].DefaultValue = "-999"; 
        }
        else
        {
            // cuando el usuario selecciona una compañía, establecemos el databinding de las dos listas 

            CodigosPresupuesto_SqlDataSource.SelectParameters["CiaContab"].DefaultValue = CiasContab_DropDownList.SelectedValue;
            CuentasContables_SqlDataSource.SelectParameters["CiaContab"].DefaultValue = CiasContab_DropDownList.SelectedValue;
        }
       

        CodigosPresupuesto_ListBox.DataBind();
        CuentasContables_ListBox.DataBind(); 

    }
    protected void AsociarCodigosACuentaContable_Button_Click(object sender, EventArgs e)
    {
        // verificamos que existan registros seleccionados en ambos ListBoxes: codigos y cuentas 
        if (CodigosPresupuesto_ListBox.SelectedIndex == -1 ||
            CuentasContables_ListBox.SelectedIndex == -1 || 
            CiasContab_DropDownList.SelectedValue == "-1")
        {
            ErrMessage_Span.InnerHtml = "Ud. debe seleccionar un registro en la lista de códigos de presupuesto y uno o varios " + 
                "registros en la tabla de cuentas contables.";
            ErrMessage_Span.Style["display"] = "block";

            return; 
        }

        // agregamos registros a la tabla Presupuesto_AsociacionCodidosPresupuestoCuentasContables 

        dbContabDataContext dbContab = new dbContabDataContext();

        Presupuesto_AsociacionCodigosCuenta MyPresupuesto_AsociacionCodigosCuentas; 
        List<Presupuesto_AsociacionCodigosCuenta> MyPresupuesto_AsociacionCodigosCuentas_List = new List<Presupuesto_AsociacionCodigosCuenta>();

        int RecCount = 0; 

        for (int i = 0; i < CuentasContables_ListBox.Items.Count; i++)
        {
            if (!(CuentasContables_ListBox.Items[i].Selected))
                continue; 

            // el item está seleccionado en el listbox; lo agregamos a nuestra lista 

            MyPresupuesto_AsociacionCodigosCuentas = new Presupuesto_AsociacionCodigosCuenta();

            MyPresupuesto_AsociacionCodigosCuentas.CodigoPresupuesto = CodigosPresupuesto_ListBox.SelectedValue;
            MyPresupuesto_AsociacionCodigosCuentas.CuentaContableID = Convert.ToInt32(CuentasContables_ListBox.Items[i].Value);
            MyPresupuesto_AsociacionCodigosCuentas.CiaContab = int.Parse(CiasContab_DropDownList.SelectedValue);

            MyPresupuesto_AsociacionCodigosCuentas_List.Add(MyPresupuesto_AsociacionCodigosCuentas);

            RecCount++; 
        }

        // primero intentamos eliminar los registros de la tabla, por si acaso algunos existen 

        try
        {
            dbContab.ExecuteCommand("Delete From Presupuesto_AsociacionCodigosCuentas Where CodigoPresupuesto = {0} And CiaContab = {1}", CodigosPresupuesto_ListBox.SelectedValue, CiasContab_DropDownList.SelectedValue);
            
            // Ok, ahora que sabemos que los registros no existen, los agregamos 

            dbContab.Presupuesto_AsociacionCodigosCuentas.InsertAllOnSubmit(MyPresupuesto_AsociacionCodigosCuentas_List);
            dbContab.SubmitChanges();

            CuentasContables_Message_Span.InnerHtml = "Ok, " + RecCount.ToString() + " cuentas contables fueron asociadas al código de presupuesto " + CodigosPresupuesto_ListBox.SelectedValue;
            CuentasContables_Message_Span.Style["display"] = "block";
        }
        catch (Exception ex) 
        {
            ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar agregar la información a la base de datos.<br />El mensaje específico de error es: " + ex.Message;
            ErrMessage_Span.Style["display"] = "block";

            return; 
        }

    }
    protected void LeerCuentasContablesAsociadas_Button_Click(object sender, EventArgs e)
    {
        // leemos las cuentas contables asociadas al código de presupuesto seleccionado y las marcamos en el 
        // ListBox de cuentas contables 

        // antes eliminamos cualquier selección que pueda existir para el ListBox 

        CuentasContables_ListBox.SelectedIndex = -1; 

        // primero verificamos que exista una cia contab y un código de presupuesto seleccionados 

        if (CodigosPresupuesto_ListBox.SelectedIndex == -1 || CiasContab_DropDownList.SelectedValue == "-1")
        {
            ErrMessage_Span.InnerHtml = "Ud. debe seleccionar una compañía Contab y un código de presupuesto antes de intentar ejecutar esta función.";
            ErrMessage_Span.Style["display"] = "block";

            return;
        }

        dbContabDataContext dbContab = new dbContabDataContext(); 

        IEnumerable<int> CuentasContables = from cc in dbContab.Presupuesto_AsociacionCodigosCuentas
                               where cc.CiaContab == int.Parse(CiasContab_DropDownList.SelectedValue) &&
                               cc.CodigoPresupuesto == CodigosPresupuesto_ListBox.SelectedValue
                               select cc.CuentaContableID;

        int RecCount = 0;

        for (int i = 0; i < CuentasContables_ListBox.Items.Count; i++)
        {
            int a = (from aa in CuentasContables 
                    where aa == Convert.ToInt32(CuentasContables_ListBox.Items[i].Value)
                         select aa).Count(); 

            if (a==0)
                // la cuenta contable leída desde el ListBox no existe en el query de cuentas para el código 
                // de presupuesto seleccionado 
                continue;

            // la cuenta contable en el ListBox existe en el query; la seleccionamos 

            CuentasContables_ListBox.Items[i].Selected = true; 

            RecCount++;
        }

        CodigosPresupuesto_Message_Span.InnerHtml = "Ok, existen " + RecCount.ToString() + 
            " cuentas contables asociadas al código de presupuesto " + 
            CodigosPresupuesto_ListBox.SelectedValue + 
            ". <br /><br />Fueron seleccionadas en la lista de cuentas contables.";
        CodigosPresupuesto_Message_Span.Style["display"] = "block";

    }
}
