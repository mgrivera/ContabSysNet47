using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls; 
using System.Web.Security;
using ContabSysNet_Web.ModelosDatos_EF.ActivosFijos;

namespace ContabSysNet_Web.Utilitarios.ActivosFijos
{
    public partial class ReconversionMonetaria : System.Web.UI.Page
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

            Master.Page.Title = "Utilitarios - Activos fijos - Reconversión monetaria";

            if (!Page.IsPostBack)
            {
                HtmlGenericControl MyHtmlH2;

                MyHtmlH2 = (HtmlGenericControl)(Master.FindControl("PageTitle_TableCell"));
                if (MyHtmlH2 != null)
                    MyHtmlH2.InnerHtml = "Utilitarios - Activos fijos - Reconversión monetaria";
            }
            else
            {
            }
        }
        
        protected void ReconversionMonetaria_Button_Click(object sender, EventArgs e)
        {
            dbContab_ActFijos_Entities actFijos_Context = new dbContab_ActFijos_Entities();

            // si existen valores en la tabla 'backup', indicamos y terminamos, para evitar ejecutar dos veces sucesivas ... 

            if (actFijos_Context.InventarioActivosFijos_AntesReconversionMonetaria.Count() > 0)
            {
                ErrMessage_Span.InnerHtml = "Aparentemente, este proceso ha sido ejecutado antes, pues existen registros en la tabla 'backup'. <br /> " +
                    "Ud. debe recuperar los montos desde estos registros (backup) y luego eliminalos de esta tabla. <br /> " +
                    "Solo entonces este proceso puede ser ejecutado nuevamente.";

                ErrMessage_Span.Style["display"] = "block";
                return;
            }

            var query = from a in actFijos_Context.InventarioActivosFijos
                        where a.FechaCompra < new DateTime(2008, 1, 1)
                        select a;

            InventarioActivosFijos_AntesReconversionMonetaria backUpEntity;
            int cantidadRegistrosProcesados = 0; 

            foreach (InventarioActivosFijo af in query)
            {
                // creamos un registro 'backup' 

                backUpEntity = new InventarioActivosFijos_AntesReconversionMonetaria();

                backUpEntity.ActivoFijo_ID = af.ClaveUnica; 
                backUpEntity.CostoTotal = af.CostoTotal;
                backUpEntity.MontoADepreciar = af.MontoADepreciar;
                backUpEntity.MontoDepreciacionMensual = af.MontoDepreciacionMensual;
                backUpEntity.ValorResidual = af.ValorResidual;

                actFijos_Context.InventarioActivosFijos_AntesReconversionMonetaria.AddObject(backUpEntity); 

                // dividimos y redondeamos cada monto para obtener Bs.F. 

                af.CostoTotal = Math.Round((af.CostoTotal / 1000), 2, MidpointRounding.AwayFromZero);
                af.MontoADepreciar = Math.Round((af.MontoADepreciar / 1000), 2, MidpointRounding.AwayFromZero);
                af.MontoDepreciacionMensual = Math.Round((af.MontoDepreciacionMensual / 1000), 2, MidpointRounding.AwayFromZero);
                af.ValorResidual = Math.Round((af.ValorResidual / 1000), 2, MidpointRounding.AwayFromZero);

                cantidadRegistrosProcesados++; 
            }


            try
            {
                actFijos_Context.SaveChanges();
            }
            catch (Exception ex)
            {
                string errMessage = ex.Message;
                if (ex.InnerException != null)
                    errMessage += "<br /><br />" + ex.InnerException.Message; 

                ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br /> " +
                    "El mensaje específico de error es: " +
                    errMessage + "<br />";

                ErrMessage_Span.Style["display"] = "block";
                return;
            }
            finally
            {
                actFijos_Context.Dispose();
            }


            Message_Span.InnerHtml = "Ok, el proceso ha sido ejecutado en forma satisfactoria.<br />" +
                "En total, se han corregido (convetido a Bs.F.) " + cantidadRegistrosProcesados.ToString() + " activos.";
            Message_Span.Style["display"] = "block";
        }
    }
}
