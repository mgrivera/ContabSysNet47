using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls; 
using System.Web.Security; 

public partial class Otros_Control_acceso_AsociarRolesUsuarios : System.Web.UI.Page
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

        Master.Page.Title = "Control de acceso - Asociación entre roles y usuarios";

        if (!Page.IsPostBack)
        {
            HtmlGenericControl MyHtmlH2;

            MyHtmlH2 = (HtmlGenericControl)(Master.FindControl("PageTitle_TableCell"));
            if (MyHtmlH2 != null)
                MyHtmlH2.InnerHtml = "Control de acceso - Asociación entre roles y usuarios";

            Roles_ListBox.DataSource = Roles.GetAllRoles();
            Roles_ListBox.DataBind();

            Usuarios_ListBox.DataSource = Membership.GetAllUsers();
            Usuarios_ListBox.DataBind(); 

        }
        else
        {
        }
    }
    protected void LeerUsuarios_LinkButton_Click(object sender, EventArgs e)
    {
        // nos aseguramos que se haya seleccionado solo un rol 

        Int16 nItemsSelectedCount = 0; 

        foreach (ListItem MyItem in Roles_ListBox.Items)
        {
            if (MyItem.Selected)
                nItemsSelectedCount++; 
        }

        switch (nItemsSelectedCount)
        {
            case 0:
                ErrMessage_Span.InnerHtml = "Ud. debe seleccionar un rol de la lista de roles.";
                ErrMessage_Span.Style["display"] = "block";

                return;
            case 1:
                break;
            default:
                ErrMessage_Span.InnerHtml = "Ud. debe seleccionar SOLO un rol de la lista de roles.";
                ErrMessage_Span.Style["display"] = "block";

                return; 
        }

        // obtenemos los usuarios asociados al rol y los seleccionamos en el listbox de usuarios 

        String sRolSeleccionado = Roles_ListBox.SelectedValue;

        String[] sUsersInRole = Roles.GetUsersInRole(sRolSeleccionado);

        // primero deseleccionamos todos los items en el listbox 
        foreach (ListItem MyItem in Usuarios_ListBox.Items)
            MyItem.Selected = false;

        // si no hay usuarios para el rol, salimos ahora 
        if (sUsersInRole.Length == 0)
            return; 

        // para cada usuario en el rol, lo buscamos y seleccionamos 
        foreach (String MyUser in sUsersInRole) 
            foreach (ListItem MyItem in Usuarios_ListBox.Items)
                if (MyItem.Text == MyUser)
                    MyItem.Selected = true; 

    }
    protected void LeerRoles_LinkButton_Click(object sender, EventArgs e)
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


        // obtenemos los roles asociados al usuario y los seleccionamos en el listbox de roles 

        String sUsuarioSeleccionado = Usuarios_ListBox.SelectedValue;

        String[] sRolesForUser = Roles.GetRolesForUser(sUsuarioSeleccionado);

        // primero deseleccionamos todos los items en el listbox 
        foreach (ListItem MyItem in Roles_ListBox.Items)
            MyItem.Selected = false;

        // si no hay usuarios para el rol, salimos ahora 
        if (sRolesForUser.Length == 0)
            return;

        // para cada usuario en el rol, lo buscamos y seleccionamos 
        foreach (String MyRol in sRolesForUser)
            foreach (ListItem MyItem in Roles_ListBox.Items)
                if (MyItem.Text == MyRol)
                    MyItem.Selected = true; 

    }
    protected void AsociarUsuriosARolSeleccionado_Button_Click(object sender, EventArgs e)
    {

        // asociamos uno o varios usuarios seleccionados a un rol seleccionado 

        // debe haber un rol (solo uno) seleccionado 

        Int16 nItemsSelectedCount = 0;

        foreach (ListItem MyItem in Roles_ListBox.Items)
        {
            if (MyItem.Selected)
                nItemsSelectedCount++;
        }

        switch (nItemsSelectedCount)
        {
            case 0:
                ErrMessage_Span.InnerHtml = "Ud. debe seleccionar un rol de la lista de roles.";
                ErrMessage_Span.Style["display"] = "block";

                return;
            case 1:
                break;
            default:
                ErrMessage_Span.InnerHtml = "Ud. debe seleccionar SOLO un rol de la lista de roles.";
                ErrMessage_Span.Style["display"] = "block";

                return;
        }

        // debe haber al menos un usuario seleccionado; aprovechamos para contar los items seleccinados 
        
        nItemsSelectedCount = 0;
       
        foreach (ListItem MyItem in Usuarios_ListBox.Items)
        {
            if (MyItem.Selected)
            {
                nItemsSelectedCount++;
            }
        }


        if (nItemsSelectedCount == 0)
        {
            ErrMessage_Span.InnerHtml = "Ud. debe seleccionar al menos un usuario de la lista de usuarios.";
            ErrMessage_Span.Style["display"] = "block";

            return;
        }

        // agregamos los usuarios seleccionados en un array, para asociarlos más abajo al role seleccionado 

        String[] UsersNames = new String[nItemsSelectedCount];
        nItemsSelectedCount = 0;

        foreach (ListItem MyItem in Usuarios_ListBox.Items)
        {
            if (MyItem.Selected)
            {
                UsersNames[nItemsSelectedCount] = MyItem.Text;
                nItemsSelectedCount++;
            }
        }

        // primero eliminamos los usuarios del rol (antes de agregar los seleccionados) 

        foreach (String UserName in Roles.GetUsersInRole(Roles_ListBox.SelectedValue))
        {
            try
            {
                Roles.RemoveUserFromRole(UserName, Roles_ListBox.SelectedValue);
            }
            catch (Exception ex)
            {
                ErrMessage_Span.InnerHtml = "Hemos obtenido un error al intentar asociar los usuarios seleccionados al rol seleccionado.<br />El mensaje específico de error es: " + ex.Message;
                ErrMessage_Span.Style["display"] = "block";

                return;
            }
        }


        // por último, asociamos los usuarios seleccionados al rol seleccionado 

        try
        {
            Roles.AddUsersToRole(UsersNames, Roles_ListBox.SelectedValue);
        }
        catch (Exception ex)
        {
            ErrMessage_Span.InnerHtml = "Hemos obtenido un error al intentar asociar los usuarios seleccionados al rol seleccionado.<br />El mensaje específico de error es: " + ex.Message;
            ErrMessage_Span.Style["display"] = "block";

            return;
        }

        Message_Span.InnerHtml = "Ok, los usuarios seleccionados han sido agregados al rol " + Roles_ListBox.SelectedValue + ".<br /><br />";
        Message_Span.Style["display"] = "block";
    }
    protected void AsociarRolesAUsurioSeleccionado_Button_Click(object sender, EventArgs e)
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

        // debe haber al menos u rol seleccionado 

        nItemsSelectedCount = 0;

        foreach (ListItem MyItem in Roles_ListBox.Items)
        {
            if (MyItem.Selected)
                nItemsSelectedCount++;
        }

        
        if (nItemsSelectedCount == 0) 
        {
            ErrMessage_Span.InnerHtml = "Ud. debe seleccionar al menos un rol de la lista de roles.";
            ErrMessage_Span.Style["display"] = "block";

            return;
        }

        // determinamos los roles a los cuales corresponde el usuario y eliminamos la asociación 

        foreach (String RoleName in Roles.GetRolesForUser(Usuarios_ListBox.SelectedValue))
        {
            try
            {
                Roles.RemoveUserFromRole(Usuarios_ListBox.SelectedValue, RoleName);
            }
            catch (Exception ex)
            {
                ErrMessage_Span.InnerHtml = "Hemos obtenido un error al intentar asociar los roles seleccionados al usuario seleccionado.<br />El mensaje específico de error es: " + ex.Message;
                ErrMessage_Span.Style["display"] = "block";

                return;
            }
        }


        // agregamos los roles seleccionados en un array, para asociarlos más abajo al usuario seleccionado 

        String[] RolesNames = new String[nItemsSelectedCount];
        nItemsSelectedCount = 0;

        foreach (ListItem MyItem in Roles_ListBox.Items)
        {
            if (MyItem.Selected)
            {
                RolesNames[nItemsSelectedCount] = MyItem.Text;
                nItemsSelectedCount++;
            }
        }

        // eliminamos la asociación para cada rol antes de crearla nuevamente (puede existir!) 

        foreach (String RoleName in RolesNames)
        {
            try
            {
                Roles.AddUserToRole(Usuarios_ListBox.SelectedValue, RoleName);
            }
            catch (Exception ex)
            {
                // si el usuario no existe en el rol se genera un exception; esperado; lo ignoramos y continuamos
            }
        }

        Message_Span.InnerHtml = "Ok, el usuario " + Usuarios_ListBox.SelectedValue + " ha sido agregado a los roles seleccionados.<br /><br />";
        Message_Span.Style["display"] = "block";

    }
}
