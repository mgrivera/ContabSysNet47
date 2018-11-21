using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Web.UI.HtmlControls;
using ContabSysNet_Web.ModelosDatos_EF.Bancos;
using System.Text;
using System.IO;
using ContabSysNet_Web.ModelosDatos_EF.Nomina;

namespace ContabSysNet_Web.Bancos.ConsultasBancos.MovimientosBancarios
{
    public partial class MovimientosBancarios_OrdenesPago : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //  intentamos recuperar el state de esta página ... 

            if (!Page.IsPostBack)
            {
                if (!User.Identity.IsAuthenticated)
                {
                    FormsAuthentication.SignOut();
                    return;
                }

                HtmlGenericControl MyHtmlH2;

                MyHtmlH2 = (HtmlGenericControl)Master.FindControl("PageTitle_TableCell");
                if (!(MyHtmlH2 == null))
                {
                    MyHtmlH2.InnerHtml = "Ordenes de Pago";
                }

                // -----------------------------------------------------------------------------------------------------------
                //  intentamos recuperar el state de esta página; en general, lo intentamos con popups filtros 

                this.Soportes_CheckBoxList.DataBind();
                this.RealizadoPor_DropDownList.DataBind();

                if (!(Membership.GetUser().UserName == null))
                {
                    KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
                    MyKeepPageState.ReadStateFromFile(this, this.Controls);
                    MyKeepPageState = null;
                }
                // -----------------------------------------------------------------------------------------------------------
            }
            else
            {
                this.CustomValidator1.IsValid = true;
                this.CustomValidator1.Visible = false; 
            }

            Message_Span.InnerHtml = "";
            Message_Span.Style["display"] = "none"; 
        }

        protected void Ok_Button_Click(object sender, EventArgs e)
        {
            // ahora recorremos los movimientos bancarios seleccionados y construimos un txt file con 
            // los datos necesarios para que el usuario inicie un proceso de mail merge usando Word ... 

            if (Session["FiltroForma"] == null)
            {
                this.CustomValidator1.IsValid = false;
                this.CustomValidator1.ErrorMessage = "No se ha podido acceder a los registros necesarios para ejecutar este proceso.<br />" +
                    "Probablemente, Ud. no ha definido y aplicado un filtro aún que permita a este proceso leer y procesar registros.";
                ValidationSummary1.ShowSummary = true; 

                return;
            }

           

            StringBuilder sb;

            // Create the CSV file on the server 

            String fileName = @"OrdenesPago_" + User.Identity.Name + ".txt";
            String filePath = HttpContext.Current.Server.MapPath("~/Temp/" + fileName);

            StreamWriter sw = new StreamWriter(filePath, false);

            // First we will write the headers.

            sb = new StringBuilder();

            sb.Append("\"CiaContabNombre\"");
            sb.Append("\t");
            sb.Append("\"Fecha\"");
            sb.Append("\t");
            sb.Append("\"Beneficiario\"");
            sb.Append("\t");
            sb.Append("\"Moneda\"");
            sb.Append("\t");
            sb.Append("\"Monto\"");
            sb.Append("\t");
            sb.Append("\"MonedaYMonto\"");
            sb.Append("\t");

            sb.Append("\"Concepto\"");
            sb.Append("\t");

            sb.Append("\"Soporte1\"");
            sb.Append("\t");
            sb.Append("\"Soporte2\"");
            sb.Append("\t");
            sb.Append("\"Soporte3\"");
            sb.Append("\t");
            sb.Append("\"Soporte4\"");
            sb.Append("\t");
            sb.Append("\"Soporte5\"");
            sb.Append("\t");


            sb.Append("\"RealizadoPor\"");
            sb.Append("\t");
            sb.Append("\"CargoRealizadoPor\"");
            sb.Append("\t");
            sb.Append("\"RevisadoPor\"");
            sb.Append("\t");
            sb.Append("\"CargoRevisadoPor\"");
            sb.Append("\t");
            sb.Append("\"AutorizadoPor1\"");
            sb.Append("\t");
            sb.Append("\"CargoAutorizadoPor1\"");
            sb.Append("\t");
            sb.Append("\"AutorizadoPor2\"");
            sb.Append("\t");
            sb.Append("\"CargoAutorizadoPor2\"");

            sw.Write(sb.ToString());
            sw.Write(sw.NewLine);

            // Now write all the rows.

            BancosEntities bancosContext = new BancosEntities();

            var query = bancosContext.MovimientosBancarios.
                Include("Chequera").
                Include("Chequera.CuentasBancaria").
                Include("Chequera.CuentasBancaria.Compania").
                Include("Chequera.CuentasBancaria.Moneda1").
                Include("Chequera.CuentasBancaria.Agencia1").
                Include("Chequera.CuentasBancaria.Agencia1.Banco1").
                Where(Session["FiltroForma"].ToString());

            int cantidadRegistrosLeidos = 0;

            foreach (MovimientosBancario m in query)
            {
                //sw.Write(",");
                //sw.Write(sw.NewLine);

                sb = new StringBuilder();

                sb.Append("\"" + m.Chequera.CuentasBancaria.Compania.Nombre + "\"");
                sb.Append("\t");

                sb.Append("\"" + m.Fecha.ToString("dd-MMM-yyyy") + "\"");
                sb.Append("\t");

                sb.Append("\"" + m.Beneficiario + "\"");
                sb.Append("\t");

                sb.Append("\"" + m.Chequera.CuentasBancaria.Moneda1.Simbolo + "\"");
                sb.Append("\t");

                sb.Append("\"" + Math.Abs(m.Monto).ToString("N2") + "\"");
                sb.Append("\t");

                sb.Append("\"" + m.Chequera.CuentasBancaria.Moneda1.Simbolo + " " + Math.Abs(m.Monto).ToString("N2") + "\"");
                sb.Append("\t");

                sb.Append("\"" + m.Concepto + "\"");
                sb.Append("\t");

                // escribimos hasta 5 soportes 

                int i = 1; 

                foreach (ListItem item in this.Soportes_CheckBoxList.Items) 
                {
                    if (item.Selected) 
                    {
                        sb.Append("\"" + item.Text + "\"");
                        sb.Append("\t");
                        i++;
                    }

                    if (i == 6)
                        break; 
                }

                for (int j = i; j <= 5; j++)
                {
                    // si el usuario menos de 5 soportes, agregamos el resto en blanco ... 
                    sb.Append("\t");
                }



                // declaramos un context para las tablas de nómina, para leer el cargo de cada empleado indicado ... 

                NominaEntities nominaContext = new NominaEntities(); 


                // realizado por 
                if (this.RealizadoPor_DropDownList.SelectedValue != "Indefinido")
                {
                    sb.Append("\"" + this.RealizadoPor_DropDownList.SelectedItem.Text + "\"");
                    sb.Append("\t");

                    int empleadoID = Convert.ToInt32(this.RealizadoPor_DropDownList.SelectedValue);
                    string nombreCargo = (from c in nominaContext.tEmpleados
                                  where c.Empleado == empleadoID
                                  select c).FirstOrDefault().tCargo.Descripcion;

                    sb.Append("\"" + nombreCargo + "\"");
                    sb.Append("\t");
                }
                else
                {
                    sb.Append("\t");
                    sb.Append("\t");
                }


                // revisado por 
                if (this.RevisadoPor_DropDownList.SelectedValue != "Indefinido")
                {
                    sb.Append("\"" + this.RevisadoPor_DropDownList.SelectedItem.Text + "\"");
                    sb.Append("\t");

                    int empleadoID = Convert.ToInt32(this.RevisadoPor_DropDownList.SelectedValue);
                    string nombreCargo = (from c in nominaContext.tEmpleados
                                          where c.Empleado == empleadoID
                                          select c).FirstOrDefault().tCargo.Descripcion;

                    sb.Append("\"" + nombreCargo + "\"");
                    sb.Append("\t");
                }
                else
                {
                    sb.Append("\t");
                    sb.Append("\t");
                }


                // autorizado por (1) 
                if (this.AutorizadoPor1_DropDownList.SelectedValue != "Indefinido")
                {
                    sb.Append("\"" + this.AutorizadoPor1_DropDownList.SelectedItem.Text + "\"");
                    sb.Append("\t");

                    int empleadoID = Convert.ToInt32(this.AutorizadoPor1_DropDownList.SelectedValue);
                    string nombreCargo = (from c in nominaContext.tEmpleados
                                          where c.Empleado == empleadoID
                                          select c).FirstOrDefault().tCargo.Descripcion;

                    sb.Append("\"" + nombreCargo + "\"");
                    sb.Append("\t");
                }
                else
                {
                    sb.Append("\t");
                    sb.Append("\t");
                }


                // autorizado por (2) 
                if (this.AutorizadoPor2_DropDownList.SelectedValue != "Indefinido")
                {
                    sb.Append("\"" + this.AutorizadoPor2_DropDownList.SelectedItem.Text + "\"");
                    sb.Append("\t");

                    int empleadoID = Convert.ToInt32(this.AutorizadoPor2_DropDownList.SelectedValue);
                    string nombreCargo = (from c in nominaContext.tEmpleados
                                          where c.Empleado == empleadoID
                                          select c).FirstOrDefault().tCargo.Descripcion;

                    sb.Append("\"" + nombreCargo + "\"");
                }
                else
                {
                    sb.Append("\t");
                    //sb.Append("\t");
                }

                sw.Write(sb.ToString());
                sw.Write(sw.NewLine);

                cantidadRegistrosLeidos++;
            }

            // finally close the file 
            sw.Close();

            if (cantidadRegistrosLeidos == 0)
            {
                this.CustomValidator1.IsValid = false;
                this.CustomValidator1.ErrorMessage = "No se ha podido acceder a los registros necesarios para ejecutar este proceso.<br />" +
                    "Probablemente, Ud. no ha definido y aplicado un filtro aún que permita a este proceso leer y procesar registros.";
                ValidationSummary1.ShowSummary = true; 

                return;
            }


            string message = "Ok, el archivo requerido ha sido generado en forma satisfactoria. <br />" +
                "La cantidad de lineas que se han grabado al archivo es: " + cantidadRegistrosLeidos.ToString() +
                ". <br />" +
                "El nombre del archivo (en el servidor) es: " + filePath;

            Message_Span.InnerHtml = message;
            Message_Span.Style["display"] = "block";

            DownloadFile_LinkButton.Visible = true;
            this.FileName_HiddenField.Value = filePath;

            // -------------------------------------------------------------------------------------------------------------------------
            // para guardar el contenido de los controles de la página para recuperar el state cuando se abra la proxima vez 

            KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
            MyKeepPageState.SavePageStateInFile(this.Controls);
            MyKeepPageState = null;
            // -------------------------------------------------------------------------------------------------------------------------
        }

        protected void DownloadFile_LinkButton_Click(object sender, EventArgs e)
        {
            // hacemos un download del archivo recién generado para que pueda ser copiado al disco duro 
            // local por del usuario 

            if (this.FileName_HiddenField.Value == null || this.FileName_HiddenField.Value == "")
            {
                string message = "No se ha podido obtener el nombre del archivo generado. <br /><br />" + 
                    "Genere el archivo nuevamente y luego intente copiarlo a su disco usando esta función.";

                this.CustomValidator1.IsValid = false;
                this.CustomValidator1.ErrorMessage = message;
                ValidationSummary1.ShowSummary = true;

                return;
            }


            FileStream liveStream = new FileStream(this.FileName_HiddenField.Value, FileMode.Open, FileAccess.Read);

            byte[] buffer = new byte[(int)liveStream.Length];
            liveStream.Read(buffer, 0, (int)liveStream.Length);
            liveStream.Close();

            Response.Clear();
            Response.ContentType = "application/octet-stream";
            Response.AddHeader("Content-Length", buffer.Length.ToString());
            Response.AddHeader("Content-Disposition", "attachment; filename=" +
                               FileName_HiddenField.Value);
            Response.BinaryWrite(buffer);
            Response.End();
        }
    }
}