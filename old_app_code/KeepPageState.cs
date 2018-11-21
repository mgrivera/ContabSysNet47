using System; 
using System.Web; 
using System.Web.UI;
using System.Web.UI.WebControls; 
using System.IO;

public class KeepPageState
{

    //  esta clase guarda el contenido de los controles de una p�gina en un archivo en el disco 
    //  luego permite recuperar estos valores desde el archivo y reinicializar la p�gina 
    private string _UserName = "";

    private string _PageName = "";

    private System.Text.StringBuilder _ControlValues_String = new System.Text.StringBuilder();

    public KeepPageState(string sUserName, string sPageName)
    {
        _UserName = sUserName;
        _PageName = sPageName;
    }

    public void SavePageStateInFile(ControlCollection MyControlCollection)
    {
        if (((_UserName == "")
                    || (_PageName == "")))
        {
            return;
        }
        RecorrerControles0(MyControlCollection);
        //  ahora que tenemos el string con los controles y sus valores, lo guardamos en un archivo 
        if (!(_ControlValues_String.ToString() == ""))
        {
            string fileName = string.Concat(_PageName, "-", _UserName);
            string filePath = HttpContext.Current.Server.MapPath(("~/keepstatefiles/" + fileName));
            File.WriteAllText(filePath, _ControlValues_String.ToString());
        }
    }

    private void RecorrerControles0(ControlCollection MyControlCollection)
    {
        RecorrerControles1(MyControlCollection);
    }

    private void RecorrerControles1(ControlCollection MyControlCollection)
    {
        foreach (System.Web.UI.Control MyWebServerControl in MyControlCollection)
        {
            string typeOfControl = MyWebServerControl.GetType().Name.ToString(); 

            if (!MyWebServerControl.HasControls() || MyWebServerControl.GetType().Name.ToString() == "CheckBoxList")
            {
                string controlName = MyWebServerControl.GetType().Name.ToString();
                switch (controlName)
                {
                    case "TextBox":
                        System.Web.UI.WebControls.TextBox MyWebControlTextBox = 
                            (System.Web.UI.WebControls.TextBox) MyWebServerControl;
                        if ((MyWebControlTextBox.Text != ""))
                        {
                            _ControlValues_String.Append((MyWebControlTextBox.ID.ToString() + ("="
                                            + (MyWebControlTextBox.Text + "¦"))));
                        }
                        break;

                    case "CheckBox":
                        System.Web.UI.WebControls.CheckBox MyWebControlCheckbox =
                            (System.Web.UI.WebControls.CheckBox)MyWebServerControl;
                        if (MyWebControlCheckbox.Checked)
                        {
                            _ControlValues_String.Append((MyWebControlCheckbox.ID.ToString() + ("=" + (1 + "¦"))));
                        }
                        else
                        {
                            _ControlValues_String.Append((MyWebControlCheckbox.ID.ToString() + ("=" + (0 + "¦"))));
                        }
                        break;

                    case "RadioButton":
                        System.Web.UI.WebControls.RadioButton MyWebControlRadioButton =
                            (System.Web.UI.WebControls.RadioButton)MyWebServerControl;
                        if (MyWebControlRadioButton.Checked)
                        {
                            _ControlValues_String.Append((MyWebControlRadioButton.ID.ToString() + ("=" + (1 + "¦"))));
                        }
                        else
                        {
                            _ControlValues_String.Append((MyWebControlRadioButton.ID.ToString() + ("=" + (0 + "¦"))));
                        }
                        break;

                    case "ListBox":
                        System.Web.UI.WebControls.ListBox MyWebControlListBox =
                            (System.Web.UI.WebControls.ListBox)MyWebServerControl;
                        if ((MyWebControlListBox.SelectedIndex > -1))
                        {
                            bool bFirstItem = true;
                            foreach (int Index in MyWebControlListBox.GetSelectedIndices())
                            {
                                if (bFirstItem)
                                {
                                    _ControlValues_String.Append((MyWebControlListBox.ID.ToString() + ("=" + MyWebControlListBox.Items[Index].Text)));
                                    bFirstItem = false;
                                }
                                else
                                {
                                    _ControlValues_String.Append((";" + MyWebControlListBox.Items[Index].Text));
                                    bFirstItem = false;
                                }
                            }
                            if (!bFirstItem)
                            {
                                _ControlValues_String.Append("¦");
                            }
                        }
                        break;

                    case "CheckBoxList":
                        System.Web.UI.WebControls.CheckBoxList MyWebControlCheckBoxList =
                            (System.Web.UI.WebControls.CheckBoxList)MyWebServerControl;
                        if ((MyWebControlCheckBoxList.SelectedIndex > -1))
                        {
                            bool bFirstItem = true;

                            for (int i = 0; i < MyWebControlCheckBoxList.Items.Count; i++)
                            {

                                if (MyWebControlCheckBoxList.Items[i].Selected)
                                {
                                    if (bFirstItem)
                                    {
                                        _ControlValues_String.Append((MyWebControlCheckBoxList.ID.ToString() + ("=" + MyWebControlCheckBoxList.Items[i].Text)));
                                        bFirstItem = false;
                                    }
                                    else
                                    {
                                        _ControlValues_String.Append((";" + MyWebControlCheckBoxList.Items[i].Text));
                                        bFirstItem = false;
                                    }

                                }
                            }
                            if (!bFirstItem)
                            {
                                _ControlValues_String.Append("¦");
                            }
                        }
                        break;

                    case "DropDownList":
                        System.Web.UI.WebControls.DropDownList MyWebControlDropDownList = 
                            (System.Web.UI.WebControls.DropDownList) MyWebServerControl;
                        //  nuestra convenci�n es que un DropDownList cuyo valor 
                        //  seleccionado es -1, 'no est� seleccionado'. La raz�n de 
                        //  esto es que en Asp.Net un DropDownList SIEMPRE est� 
                        //  seleccionado (!). 
                        if (((MyWebControlDropDownList.SelectedIndex > -1)
                                    && (((string)(MyWebControlDropDownList.SelectedItem.Value)) != "-1")))
                        {
                            _ControlValues_String.Append((MyWebControlDropDownList.ID.ToString() + ("="
                                            + (MyWebControlDropDownList.SelectedValue + "¦"))));
                        }
                        break;
                }
            }
            else
            {
                //  en el control collection vienen Panels y web controls que 
                //  a su vez, contienen controls. 
                RecorrerControles0(MyWebServerControl.Controls);
            }
        }
    }

    public void ReadStateFromFile(Page AspNetPage, ControlCollection MyControlCollection)
    {
        //  intentamos leer el archivo que corresponde a la p�gina y usuario para rescatar el state 
        if (((_UserName == "") || (_PageName == "")))
        {
            return;
        }
        string fileName = string.Concat(_PageName, "-", _UserName);
        string filePath = HttpContext.Current.Server.MapPath(("~/keepstatefiles/" + fileName));
        string contents = "";
        try
        {
            contents = File.ReadAllText(filePath);
        }
        catch (Exception ex)
        {
        }
        if ((contents == ""))
        {
            return;
        }
        string[] splitout = contents.Split('¦');
        foreach (string Split in splitout)
        { 
            int nPosSignoIgual = Split.IndexOf("=");
            if ((nPosSignoIgual > 0))
            {
                string sNombreControl = Split.Substring(0, nPosSignoIgual);
                string sContenido = Split.Substring((Split.Length + 1 - (Split.Length - nPosSignoIgual)));
                System.Web.UI.Control MyWebServerControl = FindControlRecursive(AspNetPage, sNombreControl);
                if ((MyWebServerControl == null))
                {
                    // TODO: Continue For... Warning!!! not translated
                    continue;
                }
                switch (MyWebServerControl.GetType().Name.ToString())
                {
                    case "TextBox":
                        System.Web.UI.WebControls.TextBox MyWebControlTextBox = 
                            (System.Web.UI.WebControls.TextBox) MyWebServerControl;
                        //  este caso es f�cil pues el text box solo contiene un valor (ListBox puede tener
                        //  mucho items seleccionados) 
                        MyWebControlTextBox.Text = sContenido;
                        break;

                    case "CheckBox":
                        System.Web.UI.WebControls.CheckBox MyWebControlCheckbox =
                            (System.Web.UI.WebControls.CheckBox)MyWebServerControl;
                        if ((sContenido == "1"))
                        {
                            MyWebControlCheckbox.Checked = true;
                        }
                        else
                        {
                            MyWebControlCheckbox.Checked = false;
                        }
                        break;

                    case "RadioButton":
                        System.Web.UI.WebControls.RadioButton MyWebControlRadioButton =
                            (System.Web.UI.WebControls.RadioButton)MyWebServerControl;
                        if ((sContenido == "1"))
                        {
                            MyWebControlRadioButton.Checked = true;
                        }
                        else
                        {
                            MyWebControlRadioButton.Checked = false;
                        }
                        break;

                    case "ListBox":
                        {
                            System.Web.UI.WebControls.ListBox MyWebControlListBox =
                                (System.Web.UI.WebControls.ListBox)MyWebServerControl;
                            string[] sArrayOfStrings = sContenido.Split(';');
                            foreach (string MyString in sArrayOfStrings)
                            {
                                foreach (ListItem MyListItem in MyWebControlListBox.Items)
                                {
                                    if ((MyListItem.Text == MyString))
                                    {
                                        MyListItem.Selected = true;
                                    }
                                }
                            }
                            break;
                        }

                    case "CheckBoxList":
                        {
                            System.Web.UI.WebControls.CheckBoxList MyWebControlCheckBoxList = (System.Web.UI.WebControls.CheckBoxList)MyWebServerControl;
                            string[] sArrayOfStrings = sContenido.Split(';');
                            foreach (string MyString in sArrayOfStrings)
                            {
                                foreach (ListItem MyListItem in MyWebControlCheckBoxList.Items)
                                {
                                    if ((MyListItem.Text == MyString))
                                    {
                                        MyListItem.Selected = true;
                                    }
                                }
                            }
                            break;
                        }

                    case "DropDownList":
                        System.Web.UI.WebControls.DropDownList MyWebControlDropDownList = 
                            (System.Web.UI.WebControls.DropDownList) MyWebServerControl;
                        MyWebControlDropDownList.SelectedValue = sContenido;
                        break;
                }
            }
        }
    }

    private Control FindControlRecursive(Control Root, string Id)
    {
        if ((Root.ID == Id))
        {
            return Root;
        }
        foreach (Control Ctl in Root.Controls)
        {
            Control FoundCtl = FindControlRecursive(Ctl, Id);
            if (FoundCtl != null)
            {
                return FoundCtl;
            }
        }
        return null;
    }
}