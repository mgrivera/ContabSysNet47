using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using ContabSysNet_Web.Clases;

namespace ContabSysNet_Web
{
    /// <summary>
    /// Summary description for MostrarProgreso_1
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class MostrarProgreso_1 : System.Web.Services.WebService
    {
        [WebMethod]
        public string HelloWorld()
        {
            return "Hello World";
        }

        [WebMethod(EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public WS_Result GetProgressPercentaje(string processName)
        {
            // con el processName construímos el file name ... 

            WS_Result MyWS_Result = new WS_Result();
            string jsonFileName = processName + User.Identity.Name + ".json";
            jsonFileName = HttpContext.Current.Server.MapPath(("~/Temp/" + jsonFileName));
            ReadStringFromFile readStringFromFile = new ReadStringFromFile(jsonFileName);
            JavaScriptSerializer javaScriptSerializer = new JavaScriptSerializer(); 

            try
            {
                //if (!(Session["Progress_Completed"] == null))
                //    MyWS_Result.Progress_Completed = Convert.ToInt16(Session["Progress_Completed"]);

                //if (!(Session["Progress_Percentage"] == null))
                //    MyWS_Result.Progress_Percentage = Convert.ToInt16(Session["Progress_Percentage"]);

                //if (!(Session["Progress_SelectedRecs"] == null))
                //    MyWS_Result.Progress_SelectedRecs = Convert.ToInt16(Session["Progress_SelectedRecs"]);

                //if (!(Session["Progress_ErrorMessage"] == null))
                //    MyWS_Result.Progress_ErrorMessage = Session["Progress_ErrorMessage"].ToString();

                string jsonFileContent;
                string errorMessage;

                if (!readStringFromFile.ReadFromDisk(out jsonFileContent, out errorMessage))
                {
                    MyWS_Result.Progress_Completed = 1;
                    MyWS_Result.Progress_Percentage = 0;
                    MyWS_Result.Progress_SelectedRecs = 0;
                    MyWS_Result.Progress_ErrorMessage = errorMessage;
                }
                else
                {
                    MyWS_Result = javaScriptSerializer.Deserialize<WS_Result>(jsonFileContent); 
                }
            }
            catch (Exception ex)
            {
                string errorMessage = ex.Message;
                if (ex.InnerException != null)
                    errorMessage += "<br />" + ex.InnerException.Message;

                MyWS_Result.Progress_Completed = 1;
                MyWS_Result.Progress_Percentage = 0;
                MyWS_Result.Progress_SelectedRecs = 0;
                MyWS_Result.Progress_ErrorMessage = errorMessage;
            }

            return MyWS_Result;
        }
    }

    public class WS_Result
    {
        public short Progress_Completed;
        public short Progress_Percentage;
        public int Progress_SelectedRecs;
        public string Progress_ErrorMessage;
    }
}
