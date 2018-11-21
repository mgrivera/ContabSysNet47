using System;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Bancos_VencimientoFacturas_DefinicionPeriodosVencimiento : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        this.ErrorMessage_Span.InnerHtml = "";
        this.ErrorMessage_Span.Style["display"] = "none";

        Master.Page.Title = "Vencimiento de saldos pendientes  -  Definción de períodos de vencimiento"; 

        if (!Page.IsPostBack)
            {
            }
    }
    protected void PeriodosVencimiento_ListView_ItemInserted(object sender, ListViewInsertedEventArgs e)
        {
         if  (e.Exception != null)
            {
                ErrorMessage_Span.InnerHtml = "Ha ocurrido un error al intentar agregar un registro. <br />Lo más probable es que el registro que se intenta agregar ya exite.";
                ErrorMessage_Span.Style["display"] = "block";

                e.ExceptionHandled = true;
                e.KeepInInsertMode = true; 

                return;
            }
        }
}
