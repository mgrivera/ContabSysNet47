using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls; 
using System.Web.Security;
using ContabSysNet_Web.ModelosDatos_EF.Users;
using System.Data.SqlClient;

public partial class Otros_Control_acceso_AsociarUsuariosCompanias : System.Web.UI.Page
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

        Message_Span.InnerHtml = "";
        Message_Span.Style["display"] = "none";

        Master.Page.Title = "Control de acceso - Asociación entre compañías y usuarios";

        if (!Page.IsPostBack)
        {
            HtmlGenericControl MyHtmlH2;

            MyHtmlH2 = (HtmlGenericControl)(Master.FindControl("PageTitle_TableCell"));
            if (MyHtmlH2 != null)
                MyHtmlH2.InnerHtml = "Control de acceso - Asociación entre compañías y usuarios";

            dbContabUsersEntities usersContext = new dbContabUsersEntities();
            List<Compania> companias = usersContext.Companias.OrderBy(c => c.NombreCorto).ToList();

            Companias_ListBox.DataSource = companias;

            Companias_ListBox.DataTextField = "NombreCorto";
            Companias_ListBox.DataValueField = "Numero"; 

            Companias_ListBox.DataBind();

            Usuarios_ListBox.DataSource = Membership.GetAllUsers();
            Usuarios_ListBox.DataBind(); 

        }
        else
        {
        }
    }
    protected void LeerUsuarios_LinkButton_Click(object sender, EventArgs e)
    {
        // nos aseguramos que se haya seleccionado solo una compañía 

        Int16 nItemsSelectedCount = 0;

        foreach (ListItem MyItem in Companias_ListBox.Items)
        {
            if (MyItem.Selected)
                nItemsSelectedCount++; 
        }

        switch (nItemsSelectedCount)
        {
            case 0:
                ErrMessage_Span.InnerHtml = "Ud. debe seleccionar una compañía de la lista de compañías.";
                ErrMessage_Span.Style["display"] = "block";

                return;
            case 1:
                break;
            default:
                ErrMessage_Span.InnerHtml = "Ud. debe seleccionar SOLO una compañía de la lista de compañías.";
                ErrMessage_Span.Style["display"] = "block";

                return; 
        }

        // obtenemos los usuarios asociados a la compañía y los seleccionamos en el listbox de usuarios 

        int companiaSeleccionadaID = Convert.ToInt32(Companias_ListBox.SelectedValue);

        dbContabUsersEntities usersContext = new dbContabUsersEntities();
        List<CompaniasYUsuario> usuarios = usersContext.CompaniasYUsuarios.Where(c => c.Compania == companiaSeleccionadaID).ToList(); 

        // primero deseleccionamos todos los items en el listbox 
        foreach (ListItem MyItem in Usuarios_ListBox.Items)
            MyItem.Selected = false;

        // si no hay usuarios para el rol, salimos ahora 
        if (usuarios.Count() == 0)
            return; 

        // para cada usuario leído para la compañía, lo buscamos y seleccionamos 
        foreach (CompaniasYUsuario usuario in usuarios)
        {
            aspnet_Users user = usersContext.aspnet_Users.Where(u => u.UserId == usuario.Usuario).FirstOrDefault(); 

            foreach (ListItem item in Usuarios_ListBox.Items)
                if (item.Text == user.UserName)
                {
                    item.Selected = true;
                    break; 
                }  
        }
    }
    protected void LeerCompanias_LinkButton_Click(object sender, EventArgs e)
    {
        // nos aseguramos que se haya seleccionado solo un usuario 
        Int16 nItemsSelectedCount = 0;

        foreach (ListItem MyItem in Usuarios_ListBox.Items)
        {
            if (MyItem.Selected)
                nItemsSelectedCount++;
        }

        switch (nItemsSelectedCount)
        {
            case 0:
                ErrMessage_Span.InnerHtml = "Ud. debe seleccionar un usuario de la lista de usuarios.";
                ErrMessage_Span.Style["display"] = "block";

                return;
            case 1:
                break;
            default:
                ErrMessage_Span.InnerHtml = "Ud. debe seleccionar SOLO un usuario de la lista de usuarios.";
                ErrMessage_Span.Style["display"] = "block";

                return;
        }


        // leemos el usuario seleccionado 
        dbContabUsersEntities usersContext = new dbContabUsersEntities();
        aspnet_Users usuario = usersContext.aspnet_Users.Where(u => u.UserName == Usuarios_ListBox.SelectedValue).FirstOrDefault(); 
            
        // ahora leemos las compañías asociadas al usuario ... 
        List<CompaniasYUsuario> companias = usersContext.CompaniasYUsuarios.Where(c => c.Usuario == usuario.UserId).ToList(); 

        // primero deseleccionamos todos los items en el listbox 
        foreach (ListItem MyItem in Companias_ListBox.Items)
            MyItem.Selected = false;

        // si no hay usuarios para el rol, salimos ahora 
        if (companias.Count() == 0)
            return;

        // finalmente, seleccionamos cada compañía en la lista 
        foreach (CompaniasYUsuario compania in companias)
            foreach (ListItem item in Companias_ListBox.Items)
                if (item.Value == compania.Compania.ToString())
                    item.Selected = true; 

    }
    
    protected void AsociarCompaniasAUsurioSeleccionado_Button_Click(object sender, EventArgs e)
    {
        // asociamos uno o varios roles seleccionados a un usuario seleccionado 

        // debe haber un usuario (solo uno) seleccionado 

        // nos aseguramos que se haya seleccionado solo un usuario 
        Int16 nItemsSelectedCount = 0;

        foreach (ListItem MyItem in Usuarios_ListBox.Items)
        {
            if (MyItem.Selected)
                nItemsSelectedCount++;
        }

        switch (nItemsSelectedCount)
        {
            case 0:
                ErrMessage_Span.InnerHtml = "Ud. debe seleccionar un usuario de la lista de usuarios.";
                ErrMessage_Span.Style["display"] = "block";

                return;
            case 1:
                break;
            default:
                ErrMessage_Span.InnerHtml = "Ud. debe seleccionar SOLO un usuario de la lista de usuarios.";
                ErrMessage_Span.Style["display"] = "block";

                return;
        }

        // nótese que puede no haber compañías seleccionadas, pues se puede querer quitar las que estaban seleccionadas a un usuario 
        nItemsSelectedCount = 0;

        foreach (ListItem MyItem in Companias_ListBox.Items)
        {
            if (MyItem.Selected)
                nItemsSelectedCount++;
        }

        
        //if (nItemsSelectedCount == 0) 
        //{
        //    ErrMessage_Span.InnerHtml = "Ud. debe seleccionar al menos una compañía de la lista de compañías.";
        //    ErrMessage_Span.Style["display"] = "block";

        //    return;
        //}

        // primero eliminamos las compañías que ahora corresponan al usuario 
        dbContabUsersEntities usersContext = new dbContabUsersEntities();

        var userID = usersContext.aspnet_Users.Where(u => u.UserName == Usuarios_ListBox.SelectedValue).FirstOrDefault().UserId; 

        usersContext.ExecuteStoreCommand("Delete From CompaniasYUsuarios Where Usuario = @usuario",
                                         new SqlParameter { ParameterName = "usuario", Value = userID });

        CompaniasYUsuario companiaYUsuario; 

        foreach (ListItem compania in Companias_ListBox.Items)
        {
            if (!compania.Selected)
                continue;

            companiaYUsuario = new CompaniasYUsuario();

            companiaYUsuario.Usuario = userID;
            companiaYUsuario.Compania = Convert.ToInt32(compania.Value);

            usersContext.CompaniasYUsuarios.AddObject(companiaYUsuario); 
        }

        usersContext.SaveChanges();

        Message_Span.InnerHtml = "Ok, las compañías seleccionadas <b>(" + Companias_ListBox.GetSelectedIndices().Count().ToString() + 
                                 ")</b> han sido asociadas al usuario " + Usuarios_ListBox.SelectedValue + ".<br />" +
                                 "El usuario " + Usuarios_ListBox.SelectedValue + " solo tendrá acceso a estas compañías"; 
        Message_Span.Style["display"] = "block";
    }
}
