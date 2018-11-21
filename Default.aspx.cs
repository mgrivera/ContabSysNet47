using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security; 

public partial class Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ErrMessage_Span.InnerHtml = "";
        ErrMessage_Span.Style["display"] = "none";

        if (!Page.IsPostBack)
        {
            AppMenu_EnableMenuFunctionsForUser(); 
        }

    }

    private void AppMenu_EnableMenuFunctionsForUser()
    {
        // -------------------------------------------------------------------------------------------
        // operaciones necesarias para autorizar al usaurio las diferentes opciones del menú 

        String[] sRolesForUser;

        sRolesForUser = Roles.GetRolesForUser(User.Identity.Name);

        // si el usuario no tiene roles, continuamos 

        if (sRolesForUser.Count() == 0)
            return;

        if (sRolesForUser.ToList().Contains("Administradores"))
            // si el usuario es administrador, continuamos sin procesar roles 
            return;

        dbGeneralDataContext dbGenerales = new dbGeneralDataContext();
        List<String> MenuFunctionNames_List = new List<String>();

        for (Int16 i = 0; i < sRolesForUser.Count(); i++)
        {
            // agregamos a una lista las opciones del menú definidas para los roles en los cuales 
            // participa el usuario 

            var query = from q in dbGenerales.Roles_FuncionesAplicacions
                        where q.RoleName == sRolesForUser[i]
                        select new { q.FunctionName };

            foreach (var MenuFunctionName_obj in query)
            {
                MenuFunctionNames_List.Add(MenuFunctionName_obj.FunctionName);
            }
        }

        dbGenerales = null; 

        if (MenuFunctionNames_List.Count() == 0)
            // el usuario pertenece a roles pero que no tienen funciones (???!!) 
            return;

        // con las funciones permitidas al usuario en una lista, recorremos el menú y activamos solo 
        // esas opciones 

        Menu1.DataBind();

        // primero desabilitamos todas las opciones; más abajo, habilitamos solo las que correspondan 

        foreach (MenuItem MyMenuItem in Menu1.Items)
        {
            DesabilitarMenuItem(MyMenuItem);
        }

        // recorremos el menú para mostrar solo las opciones permitidas el (los) role al cual 
        // corresponde el usuario 

        foreach (MenuItem MyMenuItem in Menu1.Items)
        {
            ProcessMenuItem(MyMenuItem, MenuFunctionNames_List);
        }

    }

    private void DesabilitarMenuItem(MenuItem MyMenuItem)
    {
        MyMenuItem.Enabled = false;
        
        foreach (MenuItem MyMenuItem2 in MyMenuItem.ChildItems)
        {
            DesabilitarMenuItem(MyMenuItem2);
        }
    }

    private void ProcessMenuItem(MenuItem MyMenuItem, List<String> MenuFunctionNames_List)
    {

        // buscamos cada opción del menú en la lista de opciones permitidas para el usuario; si no la 
        // encontramos, la desabilitamos 


        if (MenuFunctionNames_List.Contains(MyMenuItem.Text))
        {
            MyMenuItem.Enabled = true; 
            // el menuitem existe en la lista de funciones permitidas; ya viene habilitado y lo dejamos así; 
            // además, habilitamos sus parents y children 
            HabilitarParents(MyMenuItem);
            HabilitarChildren(MyMenuItem); 
        }

        foreach (MenuItem MyMenuItem2 in MyMenuItem.ChildItems)
        {
            // de igual forma, procesamos todos los subitems del menuitem actual 
            ProcessMenuItem(MyMenuItem2, MenuFunctionNames_List);
        }

    }

    private void HabilitarParents(MenuItem MyMenuItem)
    {
        if (MyMenuItem.Depth > 0)
        {
            MyMenuItem.Parent.Enabled = true;
            HabilitarParents(MyMenuItem.Parent); 
        }
    }

    private void HabilitarChildren(MenuItem MyMenuItem)
    {
        foreach (MenuItem MyMenuItemChildren in MyMenuItem.ChildItems) 
        {
            MyMenuItemChildren.Enabled = true;

            if (MyMenuItemChildren.ChildItems.Count > 0)
                HabilitarChildren(MyMenuItemChildren); 
        }
    }







}
