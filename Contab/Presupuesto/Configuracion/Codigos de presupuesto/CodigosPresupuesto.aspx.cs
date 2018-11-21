using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.Security;
using ContabSysNet_Web.ModelosDatos;

public partial class Contab_Presupuesto_Configuracion_Codigos_de_presupuesto_CodigosPresupuesto : System.Web.UI.Page
{
    protected void Page_Init(object sender, EventArgs e)
    {
        // Register control with the data manager.
        //DynamicDataManager1.RegisterControl(PresupuestoCodigos_ListView);
        this.PresupuestoCodigos_ListView.EnableDynamicData(typeof(Presupuesto_Codigo));
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!User.Identity.IsAuthenticated)
        {
            FormsAuthentication.SignOut();
            return;
        }

        ErrMessage_Span.InnerHtml = "";
        ErrMessage_Span.Style["display"] = "none";

        // -----------------------------------------------------------------------------------------

        Master.Page.Title = "Presupuesto - Códigos de presupuesto";

        if (!Page.IsPostBack)
        {
            HtmlGenericControl MyHtmlH2;

            MyHtmlH2 = (HtmlGenericControl)(Master.FindControl("PageTitle_TableCell"));
            if (MyHtmlH2 != null)
                MyHtmlH2.InnerHtml = "Presupuesto - Actualización de Códigos de Presupuesto";

            // inicialmente escondemos la tabla que permite agregar los códigos de presupuesto; cuando el 
            // usuario haga un click al botón, mostramos la tabla 

            EditarCodigosPresupuesto_Table.Visible = false;
        }
        else
        {
        }
    }
    protected void Ok_Button_Click(object sender, EventArgs e)
    {
        // mostramos la tabla que permite agregar los códigos; sin embargo, la lista con los niveles "previos"
        // es mostrada solo si la cantidad de niveles de los códigos a agregar es mayor que 1 

        EditarCodigosPresupuesto_Table.Visible = true;

        // en el ListView vamos a mostrar SOLO los códigos que el usuario quiere editar. Seleccionamos por 
        // cantidad de niveles y cia contab. 

        PresupuestoCodigos_LinqDataSource.WhereParameters["CantNiveles"].DefaultValue = CantidadNiveles_DropDownList.SelectedValue;
        PresupuestoCodigos_LinqDataSource.WhereParameters["CiaContab"].DefaultValue = CiasContab_DropDownList.SelectedValue;

        // en el DropDownList vamos a mostrar SOLO los códigos que corresponden al nivel anterior al que se 
        // quiere editar 

        NivelesPrevios_SqlDataSource.SelectParameters["CantNiveles"].DefaultValue = (int.Parse(CantidadNiveles_DropDownList.SelectedValue.ToString()) - 1).ToString();
        NivelesPrevios_SqlDataSource.SelectParameters["CiaContab"].DefaultValue = CiasContab_DropDownList.SelectedValue;

        NivelesPrevios_ListBox.DataBind();
        PresupuestoCodigos_ListView.DataBind(); 

        // si la cantidad de niveles que selecciona el usuario es 1, ocultamos el ListBox pues no hay 
        // niveles previos. 

        if (CantidadNiveles_DropDownList.SelectedValue == "1")
        {
            NivelesPrevios_ListBox.Visible = false;
            ListBoxHelp_Span.Visible = false;

            ListBoxHelp2_Span.InnerHtml = "(Registre o actualice los códigos de presupuesto que corresponden al 1er. nivel de agrupación) ";
        }
        else
        {
            NivelesPrevios_ListBox.Visible = true;
            ListBoxHelp_Span.Visible = true;

            ListBoxHelp2_Span.InnerHtml = "(Para agregar códigos en esta lista, debe seleccionar el 'nivel previo' en la lista de la izquierda, " + 
                "e indicar <em>solo</em> los dígitos para el nivel, <em>no sus niveles previos</em> (los cuales ya han sido " + 
                "seleccionados en la tabla de la izquierda)) ";
        }
    }
    protected void PresupuestoCodigos_ListView_ItemInserting(object sender, ListViewInsertEventArgs e)
    {
        // solo cuando la CantNiveles es mayor que 1, el usuario debe seleccionar un código en la lista 

        if (int.Parse(CantidadNiveles_DropDownList.Text.ToString()) > 1)
        {
            if (NivelesPrevios_ListBox.SelectedIndex == -1)
            {
                // el usuario no seleccionó el nivel previo en la lista 
                ErrMessage_Span.InnerHtml = "Ud. debe seleccionar un código en la lista que servirá como grupo (o nivel de agrupación) para los niveles que desea agregar ahora.";
                ErrMessage_Span.Style["display"] = "block";
            }
            else
            {
                // concatenamos el nivel que el usuario indicó con el nivel previo. De esa forma, el código 
                // quedará así: 10-10, 10-10-10, ... 
                e.Values["Codigo"] = NivelesPrevios_ListBox.SelectedValue + "-" + e.Values["Codigo"];
            }
        }
        // nótese como aquí le damos valor a los items que no se muestran al usuario: CantNiveles, 
        // GrupoFlag y CiaContab; estos valores fueron indicados en la parte superior de la página 

        e.Values["CantNiveles"] = System.Int16.Parse(CantidadNiveles_DropDownList.Text);
        e.Values["CiaContab"] = int.Parse(CiasContab_DropDownList.SelectedValue);
        // e.Values["GrupoFlag"] = Grupo_CheckBox.Checked; 
    }
    protected void PresupuestoCodigos_ListView_ItemCreated(object sender, ListViewItemEventArgs e)
    {
        if (e.Item.ItemType == ListViewItemType.InsertItem)
        {
            CheckBox MyCheckBox = (CheckBox)e.Item.FindControl("GrupoFlag_CheckBox");
            MyCheckBox.Checked = Grupo_CheckBox.Checked; 
        }
    }

    protected void PresupuestoCodigos_ListView_ItemInserted(object sender, ListViewInsertedEventArgs e)
    {
        if (((e.Exception != null) && !e.ExceptionHandled))
        {
            // idealmente, este error, de dynamic data, debería ser mostrado en un DynamicValidator; sin 
            // enbargo, nunca fuimos capaces de lograrlo; por eso lo mostramos así: 

            ErrMessage_Span.InnerHtml = e.Exception.Message;
            ErrMessage_Span.Style["display"] = "block";

            e.ExceptionHandled = true;
            e.KeepInInsertMode = true;
        }

    }
}
