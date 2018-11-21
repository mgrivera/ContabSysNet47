using System; 
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Services;

//  To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
[ScriptService()]
public class MostrarProgreso : System.Web.Services.WebService
{
    [WebMethod()]
    [ScriptMethod()]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod()]
    public WS_Result GetProgressPercentaje()
    {
        WS_Result MyWS_Result = new WS_Result();

        MyWS_Result.Progress_Completed = 0;
        MyWS_Result.Progress_Percentage = 0;
        MyWS_Result.Progress_SelectedRecs = 0;

        try
        {
            if (!(Session["Progress_Completed"] == null))
            {
                MyWS_Result.Progress_Completed = Convert.ToInt16(Session["Progress_Completed"]);
            }
            if (!(Session["Progress_Percentage"] == null))
            {
                MyWS_Result.Progress_Percentage = Convert.ToInt16(Session["Progress_Percentage"]);
            }
            if (!(Session["Progress_SelectedRecs"] == null))
            {
                MyWS_Result.Progress_SelectedRecs = Convert.ToInt16(Session["Progress_SelectedRecs"]);
            }
            if (!(Session["Progress_ErrorMessage"] == null))
            {
                MyWS_Result.Progress_ErrorMessage = Session["Progress_ErrorMessage"].ToString();
            }
        }
        catch (Exception ex)
        {
            MyWS_Result.Progress_ErrorMessage = ex.Message;
        }

        return MyWS_Result;
    }

    public class WS_Result
    {
        public short Progress_Completed;
        public short Progress_Percentage;
        public int Progress_SelectedRecs;
        public string Progress_ErrorMessage; 
    }
}