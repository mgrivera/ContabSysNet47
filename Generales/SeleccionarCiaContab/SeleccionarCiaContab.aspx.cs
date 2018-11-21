using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Objects;

//using ContabSysNet_Web.ModelosDatos_EF.Contab;
using System.Web.UI.HtmlControls;
using ContabSysNet_Web.ModelosDatos_EF.Users;

namespace ContabSysNet_Web.Generales.SeleccionarCiaContab
{
    public partial class SeleccionarCiaContab : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated)
            {
                FormsAuthentication.SignOut();
                return;
            }

            Master.Page.Title = "ContabSysNet - Generales - Seleccionar una compañía";

            if (!Page.IsPostBack)
            {
                // Gets a reference to a Label control that is not in a
                // ContentPlaceHolder control

                HtmlContainerControl MyHtmlSpan;

                MyHtmlSpan = (HtmlContainerControl)Master.FindControl("AppName_Span");
                if (!(MyHtmlSpan == null))
                {
                    MyHtmlSpan.InnerHtml = "Generales";
                }

                HtmlGenericControl MyHtmlH2;

                MyHtmlH2 = (HtmlGenericControl)Master.FindControl("PageTitle_TableCell");
                if (!(MyHtmlH2 == null))
                {
                    // sub título para la página
                    MyHtmlH2.InnerHtml = "Seleccionar una compañía Contab";
                }

                var currentUser = Membership.GetUser();
                // el usuario en la tabla de compañías y usuarios es de tipo uniqueIdentifier (Guid) 
                Guid userID = new Guid(currentUser.ProviderUserKey.ToString());

                dbContabUsersEntities userContext = new dbContabUsersEntities();

                // nótese como determinamos las compañías que se han asignado al usuario. De no haber ninguna, asumimos todas 
                List<CompaniasYUsuario> companiasAsignadas = userContext.CompaniasYUsuarios.Where(c => c.Usuario == userID).
                                                                                            ToList<CompaniasYUsuario>();

                if (companiasAsignadas.Count() == 0)
                {
                    // si el usuario no tiene compañías asignadas, asumimos todas 
                    List<Compania> companias = userContext.Companias.OrderBy(c => c.Nombre).ToList();
                    this.GridView1.DataSource = companias;
                    this.GridView1.DataBind();
                }
                else
                {
                    List<Compania> companias = userContext.Companias.OrderBy(c => c.Nombre).ToList();
                    // seleccionamos solo las compañías que existen en la lista anterior (companiasAsignadas) 
                    var companias2 = companias.Where(c => companiasAsignadas.Any(x => x.Compania == c.Numero)).ToList<Compania>();
                    this.GridView1.DataSource = companias2;

                    this.GridView1.DataBind();
                }

                // ahora leemos la compañía seleccionada por el usuario para mostrarla en la página 
                string usuario = User.Identity.Name;

                dbContabUsersEntities context = new dbContabUsersEntities();

                var companiaSeleccionada = context.tCiaSeleccionadas.Where(s => s.UsuarioLS == usuario).FirstOrDefault();

                string nombreCiaSeleccionada = "";

                if (companiaSeleccionada == null)
                    nombreCiaSeleccionada = "No hay una compañía Contab seleccionada";
                else
                    nombreCiaSeleccionada = companiaSeleccionada.Nombre;

                this.nombreCompaniaSeleccionada_literal.Text = nombreCiaSeleccionada; 
            }
        }

        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {
            // intentamos seleccionar la compañia que el usuario selecciona en la lista ... 

            if (!User.Identity.IsAuthenticated)
            {
                FormsAuthentication.SignOut();
                return;
            }

            string usuario = User.Identity.Name;
            int? pk = Convert.ToInt32(GridView1.SelectedDataKey.Value.ToString());

            if (pk != null)
            {
                dbContabUsersEntities context = new dbContabUsersEntities();

                var query = context.tCiaSeleccionadas.Where(s => s.UsuarioLS == usuario);

                foreach (tCiaSeleccionada s in query)
                    context.tCiaSeleccionadas.DeleteObject(s);

                Compania compania = context.Companias.Where(c => c.Numero == pk.Value).FirstOrDefault(); 

                if (compania == null) 
                {
                    string errorMessage = "Error inesperado: no hemos podido encontrar la compañía en la tabla Compañías.";

                    CustomValidator1.IsValid = false;
                    CustomValidator1.ErrorMessage = errorMessage;

                    return;
                }

                tCiaSeleccionada ciaSeleccionada = new tCiaSeleccionada()
                {
                    CiaSeleccionada = compania.Numero,
                    Nombre = compania.Nombre,
                    NombreCorto = compania.NombreCorto,
                    UsuarioLS = usuario,
                    Usuario = 0
                };

                context.tCiaSeleccionadas.AddObject(ciaSeleccionada);

                try
                {
                    context.SaveChanges();
                    this.nombreCompaniaSeleccionada_literal.Text = compania.Nombre;
                }
                catch (Exception ex)
                {
                    string errorMessage = ex.Message;

                    if (ex.InnerException != null)
                        errorMessage += "<br /><br />" + ex.InnerException.Message;

                    CustomValidator1.IsValid = false;
                    CustomValidator1.ErrorMessage = errorMessage;

                    return;
                }
                finally
                {
                    context = null; 
                }
            }
        }

        protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridView gv = (GridView)sender;
            gv.SelectedIndex = -1;
        }

        protected void btnOk_Click(object sender, EventArgs e)
        {
        }
    }
}