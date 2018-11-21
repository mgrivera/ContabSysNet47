using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Collections.Specialized;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Xml.Linq;
using System.Web.DynamicData;

// agregamos como parte de los scripts que agregamos para convertir desde número (editado) a decimal y viceversa
using System.Text;
using System.Threading;
using System.Globalization;

public partial class Decimal_EditField : System.Web.DynamicData.FieldTemplateUserControl {
    protected void Page_Load(object sender, EventArgs e) {
        TextBox1.ToolTip = Column.Description;
        
        SetUpValidator(RequiredFieldValidator1);
        SetUpValidator(CompareValidator1);
        SetUpValidator(RegularExpressionValidator1);
        SetUpValidator(RangeValidator1);
        SetUpValidator(DynamicValidator1);

        // registramos la funcion js que convierte desde número a decimal (1.000,75 --> 1000,75) 
        // RegisterNumberToDecimalScript(this.Page);

        //TextBox1.Attributes.Add("onfocus", "NumberToDecimal(this.value);");
        //TextBox1.Attributes.Add("onfocus", "this.select();");
        //TextBox1.Attributes.Add("onfocus", "this.value.replace(/./,'');this.select();");
        // TextBox1.Attributes.Add("onFocus", "this.value.toString().replace(/./gi, '');");
        // this works! 
        //TextBox1.Attributes.Add("onFocus", "this.value=''");

        //ClientScriptManager cs = Page.ClientScript;
        //if (!cs.IsClientScriptBlockRegistered("ControlFunctions"))
        //{
        //  cs.RegisterClientScriptBlock("ControlFunctions", "<script language=javascript src='Decimal_Edit.js'></script>"); 
        //}
        
        //TextBox1.Attributes.Add("onFocus", "AlertMe();");

    }

    protected override void ExtractValues(IOrderedDictionary dictionary) {
        dictionary[Column.Name] = ConvertEditedValue(TextBox1.Text);
    }
}
