using System.Web.UI;
using System;
using System.Text.RegularExpressions;

public class BuildSqlCriteria {
    
    private string gsIncluirExcluirItems = "";
    private string gsNombreItemsIncluirExcluir = "";
    private string m_sMyCriterioSql = "";

    // para indicar si se requiere un filtro para un query LinqToEntities; en estos casos, 
    // el filtro es levemente diferente .. 
    private bool linqToEntities = false; 

    
    public BuildSqlCriteria() {
    }
    
    public BuildSqlCriteria(string sIncluirExcluirItems, string sNombreItemsIncluirExcluir) {
        //  el usuario puede, si lo desea, incluir/excluir items en la construcci�n 
        //  del criterio los valores que se deben pasar a esta clase son: 
        //  gsIncluirExcluirItems: 'I' / 'E' (incluir / excluir) 
        //  gsNombreItemsIncluirExcluir: lista de nombres de items separadas por comas 
        gsIncluirExcluirItems = sIncluirExcluirItems;
        gsNombreItemsIncluirExcluir = sNombreItemsIncluirExcluir;
    }

    public string CriterioSql
    {
        get { return m_sMyCriterioSql; }
    }

    public bool LinqToEntities
    {
        set { linqToEntities = value; }
    }

    public void ContruirFiltro(ControlCollection MyControlCollection) {
        ContruirFiltro0(MyControlCollection);
        //  n�tese como terminamos siempre con alg�n criterio, aunque sea solo '1=1'
        if ((m_sMyCriterioSql == "")) {
            m_sMyCriterioSql = "1 = 1";
        }
    }
    
    public void ContruirFiltro0(ControlCollection MyControlCollection) {
        ContruirFiltro1(MyControlCollection);
    }
    
    public void ContruirFiltro1(ControlCollection MyControlCollection) {
        string sFiltroForma = "";
        string sCriterioItemForma = "";
        foreach (System.Web.UI.Control MyWebServerControl in MyControlCollection) 
        {
            // leemos solo controles que empiezan con Sql ... 
            if ((!(MyWebServerControl.ID == null) && (MyWebServerControl.ID.Substring(0, 3) == "Sql"))) 
            {
                if ((gsIncluirExcluirItems != "")) 
                {
                    switch (gsIncluirExcluirItems) 
                    {
                        case "I":
                            //  el nombre del item no existe en la lista de items; saltamos el item 
                            if (gsNombreItemsIncluirExcluir.IndexOf(MyWebServerControl.ID.ToString()) == -1)   
                                continue;
                            break; 
                        case "E":
                            //  el nombre del item no existe en la lista de items; saltamos el item 
                            if (gsNombreItemsIncluirExcluir.IndexOf(MyWebServerControl.ID.ToString()) != -1)
                                continue;
                            break; 
                    }
                }
                sCriterioItemForma = ChekControl(MyWebServerControl);
                if ((sCriterioItemForma != "")) {
                    if ((sFiltroForma == "")) {
                        sFiltroForma = sCriterioItemForma;
                    }
                    else {
                        sFiltroForma = (sFiltroForma + (" And " + sCriterioItemForma));
                    }
                }
            }
            else if (MyWebServerControl.HasControls()) {
                //  en el control collection vienen Panels y web controls que 
                //  a su vez, contienen controls. 

                ContruirFiltro0(MyWebServerControl.Controls);
            }
        }
        if ((sFiltroForma != "")) {
            //  m_sMyCriterioSql es la variable que pasamos cuando se pide el resultado de la clase (propiedad CriterioSql)
            if ((m_sMyCriterioSql == "")) {
                m_sMyCriterioSql = sFiltroForma;
            }
            else {
                m_sMyCriterioSql = (m_sMyCriterioSql + (" And " + sFiltroForma));
            }
        }
    }
    
    public string ChekControl(System.Web.UI.Control MyWebServerControl) 
    {
        string sCriterioItemForma = "";

        // ahora debemos obtener el nombre de la columna y su type. Para hacerlo, revisamos el nombre del control (ID) y separamos en partes por '-' 
        // nótese la forma del ID: Sql_CuentasBancarias_Cia_Numeric; ahora, cuando adaptamos esta función a entity sql, el ID del control puede 
        // ser más complejo, por ejemplo: Sql_it_Chequera_CuentasBancarias_Cia_Numeric; en este ejemplo, el nombre de la 'columna' debe ser: 
        // it.Chequera.CuentasBancaria.Cia y su tipo Numeric ... 

        string nombreAspNetServerControl = MyWebServerControl.ID;
        string[] x = nombreAspNetServerControl.Split('_');

        int cantPartes = x.Length;
        int parteTratada = 0;

        string sNombreItem = ""; 
        string sTipoItem = ""; 

        foreach (string xx in x)
        {
            parteTratada++;

            if (parteTratada == 1)
                // debe ser 'Sql'; continuamos 
                continue; 

            // la última parte corresponde siempre al type: string, date, numeric ... 
            if (parteTratada == cantPartes)
            {
                sTipoItem = xx;
                continue; 
            }

            if (sNombreItem == "")
                sNombreItem = xx;
            else
                sNombreItem += "." + xx; 
        }


        switch (MyWebServerControl.GetType().Name.ToString()) {
            case "TextBox":
                System.Web.UI.WebControls.TextBox MyWebControlTextBox = (System.Web.UI.WebControls.TextBox)MyWebServerControl;

                // eliminamos algún /r/n (new line) que a veces queda en el control 
                string texto = MyWebControlTextBox.Text; 
                texto = texto.Replace("\n", String.Empty);
                texto = texto.Replace("\r", String.Empty);
                texto = texto.Replace("\t", String.Empty);

                if ((texto != "")) {
                    BuildCriteria(MyWebServerControl, sNombreItem, MyWebControlTextBox.Text, sTipoItem, ref sCriterioItemForma);
                }
                break;
            case "CheckBox":
                System.Web.UI.WebControls.CheckBox MyWebControlCheckbox = 
                    (System.Web.UI.WebControls.CheckBox) MyWebServerControl;
                if ((MyWebControlCheckbox.Enabled && MyWebControlCheckbox.Checked)) {
                    sCriterioItemForma = "(" + sNombreItem + " = 1)";
                }
                else if (MyWebControlCheckbox.Enabled && !MyWebControlCheckbox.Checked) 
                {
                    sCriterioItemForma = "(" + sNombreItem + " = 0)";
                }
                break;
            case "ListBox":
                System.Web.UI.WebControls.ListBox MyWebControlListBox = 
                    (System.Web.UI.WebControls.ListBox) MyWebServerControl;
                if (MyWebControlListBox.SelectedIndex > -1) 
                {
                    //  notese como pasamos "" como valor del par�metro sItemValue, 
                    //  pues el ListBox no tiene una propiedad Text. En ves de 
                    //  ello, el usuario selecciona uno o m�s rows en este control. 

                    BuildCriteria(MyWebServerControl, sNombreItem, "", sTipoItem, ref sCriterioItemForma);
                }
                break;
            case "DropDownList":
                System.Web.UI.WebControls.DropDownList MyWebControlDropDownList = 
                    (System.Web.UI.WebControls.DropDownList) MyWebServerControl;
                //  nuestra convenci�n es que un DropDownList cuyo texto 
                //  seleccionado es "", 'no est� seleccionado'. La raz�n de 
                //  esto es que en Asp.Net un DropDownList SIEMPRE est� 
                //  seleccionado (!). 
                if (((MyWebControlDropDownList.SelectedIndex > -1) 
                            && (MyWebControlDropDownList.SelectedValue != ""))) 
                {
                    //  notese como pasamos "" como valor del par�metro sItemValue, 
                    //  pues el ListBox no tiene una propiedad Text. En ves de 
                    //  ello, el usuario selecciona uno o m�s rows en este control. 

                    BuildCriteria(MyWebServerControl, sNombreItem, "", sTipoItem, ref sCriterioItemForma);
                }
                break;
        }
        return sCriterioItemForma;
    }
    
    public void BuildCriteria(System.Web.UI.Control MyWebServerControl, string sItemName, string sItemValue, string sItemType, ref string sCriterioItemForma) 
    {
        //  esta funci�n recibe una expresi�n para un item determinado y regresa el 
        //  criterio apropiado para usarlo en la parte "where" de una instrucci�n Sql. 
        //  Por ejemplo: se recibe 4 para el item Empleado (de tipo Numerico) y se 
        //  regresa: (Empleado = 4)
        switch (MyWebServerControl.GetType().Name.ToString()) {
            case "TextBox":
                sItemValue = sItemValue.Replace(">", " > ");
                sItemValue = sItemValue.Replace("<", " < ");
                sItemValue = sItemValue.Trim();
                //  ------------------------------------------------------------
                //  el usuario puede indicar 'is null / is not null' 
                if ((string.Compare(sItemValue.Trim(), "is null", true) == 0)) {
                    sCriterioItemForma = ("(" 
                                + (sItemName + " Is Null)"));
                    return;
                }
                else if ((string.Compare(sItemValue.Trim(), "is not null", true) == 0)) {
                    sCriterioItemForma = ("(" 
                                + (sItemName + " Is Not Null)"));
                    return;
                }
                //  ------------------------------------------------------------
                if ((sItemType == "Date")) {
                    sItemValue = sConvertirFechasAFormaYMD(sItemValue);
                }
                if ((sItemType == "Date")) {
                    sItemValue = sEncerrarPalabrasEntreComillasSimples(sItemValue);
                }
                if ((sItemType == "String")) {
                    sItemValue = sSepararPalabrasEnListaOr(sItemValue, sItemName);
                }
                switch (sItemType) {
                    case "Date":
                        if ((((sItemValue.IndexOf("entre") + 1) 
                                    > 0) 
                                    || (((sItemValue.IndexOf("Entre") + 1) 
                                    > 0) 
                                    || ((sItemValue.IndexOf("ENTRE") + 1) 
                                    > 0)))) 
                        {
                            if (!linqToEntities)
                            {
                                //  el usuario uso un criterio: 'entre xxx y zzz' 
                                sItemValue = sItemValue.Replace("\'entre\'", "between");
                                sItemValue = sItemValue.Replace("\'Entre\'", "between");
                                sItemValue = sItemValue.Replace("\'ENTRE\'", "between");
                                sItemValue = sItemValue.Replace("\'y\'", "and");
                                sItemValue = sItemValue.Replace("\'Y\'", "and");

                                sCriterioItemForma = ("("
                                            + (sItemName + (" "
                                            + (sItemValue + ")"))));
                            }
                            else
                            {
                                DateTime fechaInicio;
                                DateTime fechaFinal; 

                                string[] words = sItemValue.Replace("'", "").Split(' ');

                                if (!DateTime.TryParse(words[1], out fechaInicio))
                                {
                                    // cómo terminar con error ??? 
                                }

                                if (!DateTime.TryParse(words[3], out fechaFinal))
                                {
                                    // cómo terminar con error ??? 
                                }

                                sCriterioItemForma += "(" + sItemName + " >= DateTime'" + fechaInicio.ToString("yyyy-MM-dd H:m:s") +
                                          "' And " + sItemName + " <= DateTime'" + fechaFinal.ToString("yyyy-MM-dd") + " 23:59:59')";
                            }
                        }
                        else if ((((sItemValue.IndexOf(" \'o\' ") + 1) 
                                    > 0) 
                                    || ((sItemValue.IndexOf(" \'O\' ") + 1) 
                                    > 0))) 
                        {
                            if (!linqToEntities)
                            {
                                //  el usuario uso un criterio: 'xxx o yyy o zzz' 
                                sItemValue = sItemValue.Replace(" \'o\' ", " or " + sItemName + " = ");
                                sItemValue = sItemValue.Replace(" \'O\' ", " or " + sItemName + " = ");
                                sCriterioItemForma = ("(" + (sItemName + (" = " + (sItemValue + ")"))));
                            }
                            else
                            {
                                sItemValue = sItemValue.Replace("'", "");
                                sItemValue = sItemValue.Replace("o", "");
                                sItemValue = sItemValue.Replace("O", "");

                                // ahora tenemos solo las fechas; las grabamos en un array 

                                string[] words = sItemValue.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);

                                bool first = true; 

                                foreach (string f in words)
                                {
                                    DateTime fecha;
                                    
                                    if (DateTime.TryParse(f, out fecha))
                                    {
                                        if (first)
                                            sCriterioItemForma += "(" + 
                                                "(" + 
                                                sItemName.Replace("'", "") + " == " + 
                                                " DateTime'" + fecha.ToString("yyyy-MM-dd H:m:s") + 
                                                "')";
                                        else
                                            sCriterioItemForma += " Or " +
                                                    "(" +
                                                    sItemName.Replace("'", "") + " == " +
                                                    " DateTime'" + fecha.ToString("yyyy-MM-dd H:m:s") + 
                                                    "')";

                                        first = false; 
                                    }
                                }
                                sCriterioItemForma += ")"; 
                            }
                        }
                        else if ((((sItemValue.IndexOf(">") + 1) 
                                    > 0) 
                                    || ((sItemValue.IndexOf("<") + 1) 
                                    > 0))) 
                            {
                            //  el usuario uso un criterio: '< 500' o '> 500'
                                if (!linqToEntities)
                                {
                                    sItemValue = sItemValue.Replace("\'>\'", ">");
                                    sItemValue = sItemValue.Replace("\'<\'", "<");
                                    sCriterioItemForma = ("(" + (sItemName + (" " + (sItemValue + ")"))));
                                }
                                else
                                {
                                    DateTime fecha;

                                    sItemValue = sItemValue.Replace("'", "");
                                    // para separar por whitespace (es decir, un blanco) y omitir blancos sucesivos (ej: 'manuel   rivera') 
                                    string[] words = sItemValue.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);        

                                    if (!DateTime.TryParse(words[1], out fecha))
                                    {
                                        // cómo terminar con error ??? 
                                    }

                                    sCriterioItemForma += "(" + sItemName.Replace("'", "") + " " + words[0] + " DateTime'" + fecha.ToString("yyyy-MM-dd H:m:s") + "')"; 
                                }
                        }
                        else {
                            //  el usuario indico simplemente una fecha
                            if (!linqToEntities)
                            {
                                sCriterioItemForma = ("("
                                            + (sItemName + (" = "
                                            + (sItemValue + ")"))));
                            }
                            else
                            {
                                DateTime fecha;

                                if (!DateTime.TryParse(sItemValue.Replace("'", ""), out fecha))
                                {
                                    // cómo terminar con error ??? 
                                }
                                
                                sCriterioItemForma += "(" + sItemName + " == DateTime'" + fecha.ToString("yyyy-MM-dd H:m:s") + "')"; 
                            }
                        }
                        break;
                    case "String":
                        sCriterioItemForma = ("(" 
                                    + (sItemValue + ")"));
                        break;
                    case "Numeric":
                        sItemValue = sItemValue.Replace(",", ".");
                        if ((((sItemValue.IndexOf("entre") + 1) 
                                    > 0) 
                                    || (((sItemValue.IndexOf("Entre") + 1) 
                                    > 0) 
                                    || ((sItemValue.IndexOf("ENTRE") + 1) 
                                    > 0)))) {
                            //  el usuario uso un criterio: 'entre xxx y zzz' 
                            sItemValue = sItemValue.Replace("entre", "between");
                            sItemValue = sItemValue.Replace("Entre", "between");
                            sItemValue = sItemValue.Replace("ENTRE", "between");
                            sItemValue = sItemValue.Replace("y", "and");
                            sItemValue = sItemValue.Replace("Y", "and");
                            sCriterioItemForma = ("(" 
                                        + (sItemName + (" " 
                                        + (sItemValue + ")"))));
                        }
                        else if ((((sItemValue.IndexOf(" o ") + 1) 
                                    > 0) 
                                    || ((sItemValue.IndexOf(" O ") + 1) 
                                    > 0))) {
                            //  el usuario uso un criterio: 'xxx o yyy o zzz' 
                            sItemValue = sItemValue.Replace(" o ", (" or " 
                                            + (sItemName + " = ")));
                            sItemValue = sItemValue.Replace(" O ", (" or " 
                                            + (sItemName + " = ")));
                            sCriterioItemForma = ("(" 
                                        + (sItemName + (" = " 
                                        + (sItemValue + ")"))));
                        }
                        else if ((((sItemValue.IndexOf(">") + 1) 
                                    > 0) 
                                    || ((sItemValue.IndexOf("<") + 1) 
                                    > 0))) {
                            //  el usuario uso un criterio: '< 500' o '> 500'
                            sCriterioItemForma = ("(" 
                                        + (sItemName + (" " 
                                        + (sItemValue + ")"))));
                        }
                        else {
                            //  el usuario indico simplemente un monto
                            sCriterioItemForma = ("(" 
                                        + (sItemName + (" = " 
                                        + (sItemValue + ")"))));
                        }
                        break;
                }
                break;
            case "ListBox":

                System.Web.UI.WebControls.ListBox MyWebControlListBox = 
                    (System.Web.UI.WebControls.ListBox) MyWebServerControl;
                int i;
                sCriterioItemForma = "";

                for (i = 0; i <= MyWebControlListBox.Items.Count - 1; i++) 
                {
                    if (MyWebControlListBox.Items[i].Selected) 
                    {
                        switch (sItemType) {
                            case "String":
                                if (sCriterioItemForma == "")
                                {
                                    if (!this.linqToEntities)
                                        sCriterioItemForma = "(" + sItemName + " = \'" + MyWebControlListBox.Items[i].Value + "\'";
                                    else
                                        sCriterioItemForma = "(" + sItemName + " IN {\'" + MyWebControlListBox.Items[i].Value + "\'";
                                }
                                else 
                                {
                                    if (!this.linqToEntities)
                                        sCriterioItemForma = sCriterioItemForma + " Or " + sItemName + " = \'" + MyWebControlListBox.Items[i].Value + "\'";
                                    else
                                        sCriterioItemForma = sCriterioItemForma + ", '" + MyWebControlListBox.Items[i].Value + "\'";
                                }
                                break;
                           
                            default:
                                if (sCriterioItemForma == "")
                                {
                                    if (!this.linqToEntities)
                                        sCriterioItemForma = "(" + sItemName + " = " + MyWebControlListBox.Items[i].Value;
                                    else
                                        sCriterioItemForma = "(" + sItemName + " IN {" + MyWebControlListBox.Items[i].Value;
                                }
                                else 
                                {
                                    if (!this.linqToEntities)
                                        sCriterioItemForma = sCriterioItemForma + " Or " + sItemName + " = " + MyWebControlListBox.Items[i].Value;
                                    else
                                        sCriterioItemForma = sCriterioItemForma + ", " + MyWebControlListBox.Items[i].Value;
                                }
                                break;
                        }
                    }
                }
                if ((sCriterioItemForma != "")) 
                {
                    if (!this.linqToEntities)
                        sCriterioItemForma = (sCriterioItemForma + ")");
                    else
                        sCriterioItemForma = (sCriterioItemForma + "})");
                }
                break;
            case "DropDownList":
                System.Web.UI.WebControls.DropDownList MyWebControlDropDownList = 
                    (System.Web.UI.WebControls.DropDownList) MyWebServerControl;
                sCriterioItemForma = "";
                switch (sItemType) {
                    case "String":
                        sCriterioItemForma = ("(" 
                                    + (sItemName + (" = \'" 
                                    + (MyWebControlDropDownList.SelectedItem.Value + "\'"))));
                        break;
                    default:
                        sCriterioItemForma = ("(" 
                                    + (sItemName + (" = " + MyWebControlDropDownList.SelectedItem.Value)));
                        break;
                }
                if ((sCriterioItemForma != "")) {
                    sCriterioItemForma = (sCriterioItemForma + ")");
                }
                break;
        }
    }
    
    public string sSepararPalabrasEnListaOr(string sString, string sItemName) {
        int i;
        //  esta funcion recibe un string con palabras y encierra cada una entre comillas
        //  simples. La funci�n esta preparada para recibir una lista de palabras 
        //  separadas por el operador 'o' (Or). Adem�s, las palabras pueden ser 
        //  compuestas (ej: pedro perez o juan alfonzo)
        sString = sString.Trim();
        if ((sString == "")) {
            return sString;
        }
        //  obtenemos en un arreglo cada 'sub string', separadas por el �nico 
        //  operador posible para datos de tipo String: O. La �nica forma que tiene 
        //  el usuario de indicar el criterio es: 'manuel o juan o pedro perez'.
        //  como el metodo Split solo acepta caracteres como delimitadores y queremos
        //  delimitar por ' o ' (3 caracteres), convertimos las ocurrencias de 
        //  ' o ' a un caracter que el usuario nunca usar� en su criterio. 

        sString = sString.Replace(" o ", "|");
        sString = sString.Replace(" O ", "|");
        // Oct/2018: permitimos también separar por coma (',') ... 
        sString = sString.Replace(", ", "|");
        sString = sString.Replace(",", "|");

        //Dim myDelimiterArray() As Char = {"|"}

        char myDelimiterArray  = '|';
        
        string[] sWordsArray = sString.Split(myDelimiterArray);
        sString = "";
        for (i = 0; i <= sWordsArray.Length - 1; i++) 
        {
            if ((i == 0)) {
                //  primera vez 
                if (sWordsArray[i].IndexOf("*") != -1) 
                {
                    sString = (sItemName + (" Like \'" 
                                + (sWordsArray[i].Replace("*", "%") + "\'")));
                }
                else {
                    sString = (sItemName + (" = \'" + (sWordsArray[i] + "\'")));
                }
            }
            else {
                //  las sucesivas  veces las separamos por un 'o' (Or)
                if (sWordsArray[i].IndexOf("*") != -1)
                {
                    sString = (sString + (" or " 
                                + (sItemName + (" Like \'" 
                                + (sWordsArray[i].Replace("*", "%") + "\'")))));
                }
                else {
                    sString = sString + " or " + sItemName + " = \'" + sWordsArray[i] + "\'";
                }
            }
        }
        return sString;
    }
    
    public string sEncerrarPalabrasEntreComillasSimples(string sString) {
        int i;
        bool bInicioPalabra;
        //  esta funcion recibe un string con palabras y encierra cada una entre comillas
        //  simples 
        sString = sString.Trim();
        if ((sString == "")) {
            return sString;
        }
        sString = ("\'" + sString);
        i = 1;
        bInicioPalabra = false;
        while (true) {
            i = (sString.IndexOf(" ", (i - 1), System.StringComparison.OrdinalIgnoreCase) + 1);
            if ((i == 0)) {
                break; //Warning!!! Review that break works as 'Exit Do' as it could be in a nested instruction like switch
            }
            if (bInicioPalabra) {
                sString = (sString.Substring(0, i) + ("\'" + sString.Substring((sString.Length - (sString.Length - i)))));
            }
            else {
                sString = (sString.Substring(0, (i - 1)) + ("\'" + sString.Substring((sString.Length - ((sString.Length - i) 
                                + 1)))));
            }
            bInicioPalabra = !bInicioPalabra;
            i = (i + 1);
        }
        return (sString + "\'");
    }
    
    public string sConvertirFechasAFormaYMD(string sString) {
        //  esta funci�n recibe un string y busca las fechas que puedan haber en ella. 
        //  Luego, convierte cada una al formato mdy. Si, por ejemplo, esta funci�n 
        //  recibe: "entre 1/5/2 y 31/5/2", regresa: "entre 5/1/2 y 5/31/2" 
        string sPalabra;
        int nPosAnterior;
        int nPosProxBlanco;
        sString = sString.Trim();
        if ((sString == "")) {
            return sString;
        }
        //  --------------------------------------------------------------
        //  el string puede tener una sola palabra 
        if (((sString.IndexOf(" ", 0, System.StringComparison.OrdinalIgnoreCase) + 1) 
                    == 0)) 
        {
            System.DateTime MyDateTime;
            if (System.DateTime.TryParse(sString, out MyDateTime))
            {
                sString = MyDateTime.ToString("yyyy/MM/dd");
            }
            return sString;
        }
        //  --------------------------------------------------------------
        nPosAnterior = 1;
        while (true) {
            if (((sString.IndexOf(" ", (nPosAnterior - 1), System.StringComparison.OrdinalIgnoreCase) + 1) 
                        == 0)) {
                //  ya no hay m�s blancos en el string. Salimos del loop a tratar la 
                //  �ltima palabra 
                break; //Warning!!! Review that break works as 'Exit Do' as it could be in a nested instruction like switch
            }
            nPosProxBlanco = (sString.IndexOf(" ", (nPosAnterior - 1), System.StringComparison.OrdinalIgnoreCase) + 1);
            sPalabra = sString.Substring((nPosAnterior - 1), (nPosProxBlanco - nPosAnterior));

            System.DateTime MyDateTime;
            if (System.DateTime.TryParse(sPalabra, out MyDateTime))
            {
                sPalabra = MyDateTime.ToString("yyyy/MM/dd");
            }
            //  reconstru�mos el string pues pudimos haber cambiado la palabra (si era una fecha) 
            sString = (sString.Substring(0, (nPosAnterior - 1)) 
                        + (sPalabra + sString.Substring((nPosProxBlanco - 1), ((sString.Length - nPosProxBlanco) 
                            + 1))));
            nPosAnterior = (nPosAnterior 
                        + (sPalabra.Length + 1));
        }
        //  tratamos la �ltima palabra 
        sPalabra = sString.Substring((nPosAnterior - 1), ((sString.Length - nPosAnterior) 
                        + 1));

        System.DateTime MyDateTime2;
        if (System.DateTime.TryParse(sPalabra, out MyDateTime2)) {
            sPalabra = MyDateTime2.ToString("yyyy/MM/dd");
        }
        //  reconstru�mos el string pues pudimos haber cambiado la palabra (si era una fecha) 
        sString = (sString.Substring(0, (nPosAnterior - 1)) + sPalabra);
        return sString;
    }

}