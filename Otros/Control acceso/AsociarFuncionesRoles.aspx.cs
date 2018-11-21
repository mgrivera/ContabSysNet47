using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security; 

public partial class Otros_Control_acceso_AsociarFuncionesRoles : System.Web.UI.Page
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

        Master.Page.Title = "Control de acceso - Asociación de funciones de la aplicacion a roles";

        if (!Page.IsPostBack)
        {
            Roles_ListBox.DataSource = Roles.GetAllRoles();
            Roles_ListBox.DataBind();

            // para que la propiedad NavigateUrl de los treeview.nodes este en ''; esto las desabilita como 
            // links a las diferentes funciones del sistema. No se olvide que nuestro treeview en esta página 
            // está asociado al SiteMap de la aplicación 

            TreeView1.DataBind(); 

            foreach (TreeNode MyTreeNode in TreeView1.Nodes)
            {
                MyTreeNode.NavigateUrl = ""; ;
                MyTreeNode.SelectAction = TreeNodeSelectAction.None; 
                ClearURL_NodosEnTreeView(MyTreeNode);
            }
        }
        else
        {
        }
    }

    private void ClearURL_NodosEnTreeView(TreeNode MyTreeNode)
    {
        foreach (TreeNode MyTreeNode_Child in MyTreeNode.ChildNodes)
        {
            MyTreeNode_Child.NavigateUrl = "";
            MyTreeNode_Child.SelectAction = TreeNodeSelectAction.None; 

            ClearURL_NodosEnTreeView(MyTreeNode_Child);
        }
    }

    protected void RegistrarAsociaciones_Button_Click(object sender, EventArgs e)
    {

        // el usuario debe haber seleccionado un rol 

        if (Roles_ListBox.SelectedIndex == -1)
        {
            ErrMessage_Span.InnerHtml = "Ud. debe seleccionar un rol al cual asociar las funciones.";
            ErrMessage_Span.Style["display"] = "block";

            return;
        }

        // primero eliminamos las funciones que ahora existen para el rol 

        dbGeneralDataContext dbGeneral = new dbGeneralDataContext();

        var query = from q in dbGeneral.Roles_FuncionesAplicacions
                    where q.RoleName == Roles_ListBox.SelectedValue
                    select q; 

        foreach (var MyRolesFunciones in query) 
        {
            dbGeneral.Roles_FuncionesAplicacions.DeleteOnSubmit(MyRolesFunciones);

            try
            {
                dbGeneral.SubmitChanges(); 
            }
            catch (Exception ex)
            {
                ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar efectuar una operación en la base de datos.<br />El mensaje específico de error es: " + ex.Message;
                ErrMessage_Span.Style["display"] = "block";

                return;
            }
            
        }

        // recorremos los nodos seleccionados en el treeview y los guardamos en la tabla 
        // Roles_FuncionesAplicacion para el rol seleccionado 

        bool bError;
        String sErrMessage; 

        Roles_FuncionesAplicacion MyRole_FuncionesAplicacion; 

        foreach (TreeNode MyTreeNode in TreeView1.Nodes)
        {
            if (MyTreeNode.Checked)
            // registramos el nodo en la tabla 
            {
                MyRole_FuncionesAplicacion = new Roles_FuncionesAplicacion(); 

                MyRole_FuncionesAplicacion.RoleName = Roles_ListBox.SelectedValue;
                MyRole_FuncionesAplicacion.FunctionName = MyTreeNode.Text;

                dbGeneral.Roles_FuncionesAplicacions.InsertOnSubmit(MyRole_FuncionesAplicacion);

                try
                {
                    dbGeneral.SubmitChanges(); 
                }
                catch (Exception ex)
                {
                    ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar efectuar una operación en la base de datos.<br />El mensaje específico de error es: " + ex.Message;
                    ErrMessage_Span.Style["display"] = "block";

                    return;
                }
                
            }

            ProcesarNodosEnTreeView(MyTreeNode, dbGeneral, out bError, out sErrMessage);

            if (bError)
            {
                // ocurrió un error en la ejecución (recursiva) de la función 
                ErrMessage_Span.InnerHtml = "Ha ocurrido un error en la ejecución de este proceso.<br />El mensaje específico obtenido para el error es: " + sErrMessage;
                ErrMessage_Span.Style["display"] = "block";

                return;
            }

            Message_Span.InnerHtml = "Ok, las funciones han sido asociadas al rol seleccionado.";
            Message_Span.Style["display"] = "block";
        }
    }

    private void ProcesarNodosEnTreeView(TreeNode MyTreeNode, dbGeneralDataContext MydbGeneralDataContext, out bool bError, out String sErrMessage) 
    {
        bError = false;
        sErrMessage = ""; 

        Roles_FuncionesAplicacion MyRole_FuncionesAplicacion; 

        foreach (TreeNode MyTreeNode_Child in MyTreeNode.ChildNodes)
        {
            if (MyTreeNode_Child.Checked)
            // registramos el nodo en la tabla 
            {
                MyRole_FuncionesAplicacion = new Roles_FuncionesAplicacion();

                MyRole_FuncionesAplicacion.RoleName = Roles_ListBox.SelectedValue;
                MyRole_FuncionesAplicacion.FunctionName = MyTreeNode_Child.Text;

                MydbGeneralDataContext.Roles_FuncionesAplicacions.InsertOnSubmit(MyRole_FuncionesAplicacion);
                try
                {
                    MydbGeneralDataContext.SubmitChanges();
                }
                catch (Exception ex)
                {
                    ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar efectuar una operación en la base de datos.<br />El mensaje específico de error es: " + ex.Message;
                    ErrMessage_Span.Style["display"] = "block";

                    bError = true;
                    sErrMessage = ex.Message; 
                    return;
                }
            }

            ProcesarNodosEnTreeView(MyTreeNode_Child, MydbGeneralDataContext, out bError, out sErrMessage);

            if (bError)
                // ocurrió un error en la ejecución (recursiva) de la función 
                return; 
        }
    }
    protected void LimpiarSeleccion_LinkButton_Click(object sender, EventArgs e)
    {
        foreach (TreeNode MyTreeNode in TreeView1.Nodes)
        {
            if (MyTreeNode.Checked)
                MyTreeNode.Checked = false;

            LimpiarSeleccion_NodosEnTreeView(MyTreeNode);
        }
    }

    private void LimpiarSeleccion_NodosEnTreeView(TreeNode MyTreeNode)
    {
        foreach (TreeNode MyTreeNode_Child in MyTreeNode.ChildNodes)
        {
            if (MyTreeNode_Child.Checked)
                MyTreeNode_Child.Checked = false;

                LimpiarSeleccion_NodosEnTreeView(MyTreeNode_Child);
        }
    }

    protected void MarcarTodo_LinkButton_Click(object sender, EventArgs e)
    {
        foreach (TreeNode MyTreeNode in TreeView1.Nodes)
        {
            CheckAll_NodosEnTreeView(MyTreeNode);
        }
    }

    private void CheckAll_NodosEnTreeView(TreeNode MyTreeNode)
    {
        foreach (TreeNode MyTreeNode_Child in MyTreeNode.ChildNodes)
        {
            // con estas instrucciones marcamos SOLO menúes que tienen children pero no grand children (leaf nodes)

            foreach (TreeNode MyTreeNode_Child2 in MyTreeNode_Child.ChildNodes)
            {

                if (MyTreeNode_Child2.ChildNodes.Count == 0)
                {
                    // solo marcamos si el node tiene leaf nodes
                    MyTreeNode_Child.Checked = true;
                    break; 
                }
            }
            CheckAll_NodosEnTreeView(MyTreeNode_Child);
        }
    }
    protected void Roles_ListBox_SelectedIndexChanged(object sender, EventArgs e)
    {
        // primero que todo, limpiamos cualquier selección que exista en el treeview 

        foreach (TreeNode MyTreeNode in TreeView1.Nodes)
        {
            if (MyTreeNode.Checked)
                MyTreeNode.Checked = false;

            LimpiarSeleccion_NodosEnTreeView(MyTreeNode);
        }

        if (Roles_ListBox.SelectedIndex == -1)
            return; 

        // leemos las funciones asociadas al rol (puede haber ninguna!) y las marcamos en el treeview 

        dbGeneralDataContext dbGenerales = new dbGeneralDataContext();

        var query = from q in dbGenerales.Roles_FuncionesAplicacions
                    where q.RoleName == Roles_ListBox.SelectedValue
                    select q;

        List<String> MyRoles_List = new List<String>();
        
        foreach (var MyRol_Funciones in query)
        {
            MyRoles_List.Add(MyRol_Funciones.FunctionName);
        }

        dbGenerales = null; 

        if (query.Count() > 0) 
        {
            // buscamos cada nodo en la lista de funciones definidas para el rol en la base de datos. 
            // Si lo encontramos, lo marcamos 

            foreach (TreeNode MyTreeNode in TreeView1.Nodes)
            {
                if (MyRoles_List.Contains(MyTreeNode.Text))
                    MyTreeNode.Checked = true; 

                CheckFunctionForRole_NodosEnTreeView(MyTreeNode, MyRoles_List);
            }
        }
    }

    private void CheckFunctionForRole_NodosEnTreeView(TreeNode MyTreeNode, List<String> MyRoles_List)
    {
        foreach (TreeNode MyTreeNode_Child in MyTreeNode.ChildNodes)
        {
            if (MyRoles_List.Contains(MyTreeNode_Child.Text))
                MyTreeNode_Child.Checked = true;

            CheckFunctionForRole_NodosEnTreeView(MyTreeNode_Child, MyRoles_List);
        }
    }
}
