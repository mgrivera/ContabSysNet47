using System.Web.UI; 

public class LimpiarFiltro
{

    //  para recorrer los controles de una p�gina y limpiar el contenido que puedan tener sus controles
    private Page _page;

    public LimpiarFiltro(Page AspNetPage)
    {
        _page = AspNetPage;
    }

    public void LimpiarControlesPagina()
    {
        RecorrerYLimpiarControles(_page);
    }

    private void RecorrerYLimpiarControles(Control MyControl)
    {
        foreach (System.Web.UI.Control MyWebServerControl in MyControl.Controls)
        {
            if (MyWebServerControl.HasControls() == false)
            {
                switch (MyWebServerControl.GetType().Name.ToString())
                {
                    case "TextBox":
                        System.Web.UI.WebControls.TextBox MyWebControlTextBox = 
                            (System.Web.UI.WebControls.TextBox) MyWebServerControl;
                        MyWebControlTextBox.Text = "";
                        break;
                    case "CheckBox":
                        System.Web.UI.WebControls.CheckBox MyWebControlCheckbox = 
                            (System.Web.UI.WebControls.CheckBox) MyWebServerControl;
                        MyWebControlCheckbox.Checked = false;
                        break;
                    case "ListBox":
                        System.Web.UI.WebControls.ListBox MyWebControlListBox = 
                            (System.Web.UI.WebControls.ListBox) MyWebServerControl;
                        MyWebControlListBox.SelectedIndex = -1;
                        break;
                    case "DropDownList":
                        System.Web.UI.WebControls.DropDownList MyWebControlDropDownList = 
                            (System.Web.UI.WebControls.DropDownList) MyWebServerControl;
                        MyWebControlDropDownList.SelectedIndex = -1;
                        break;
                }
            }
            else
            {
                //  en el control collection vienen Panels y web controls que 
                //  a su vez, contienen controls. 
                RecorrerYLimpiarControles(MyWebServerControl);
            }
        }
    }
}