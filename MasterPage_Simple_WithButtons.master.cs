using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterPage_Simple_WithButtons : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            // obteemos el nombre de la página, para asignar una dirección de la documentación al botón Help ... 
            string s = this.Page.GetType().FullName;
            string[] array = s.Split('_');
            int count = array.Count();
            string currentPage = array[count - 2];

            switch (currentPage) { 
                case "asociarusuarioscompanias": 
                    this.Help_HyperLink.NavigateUrl = "https://smrsoftware.wordpress.com/2017/01/09/companias-contab-asignadas-a-usuarios/"; 
                    break; 
            }
        }
    }
}
