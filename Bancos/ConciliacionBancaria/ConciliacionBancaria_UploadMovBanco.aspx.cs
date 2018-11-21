using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Data.Entity;
using ContabSysNet_Web.ModelosDatos_EF.Bancos;
using System.Web.ModelBinding;
using AjaxControlToolkit;
using System.IO;
using System.Data.OleDb;
using System.Data;
using ClosedXML.Excel;

namespace ContabSysNet_Web.Bancos.ConciliacionBancaria
{
    public partial class ConciliacionBancaria_UploadMovBanco : System.Web.UI.Page
    {
        internal class MovimientoBanco
        {
            public int ConciliacionBancariaID { get; set; }
            public DateTime Fecha { get; set; }
            public string Referencia { get; set; }
            public string Descripcion { get; set; }
            public decimal Monto { get; set; }
        }


        protected void Page_Load(object sender, EventArgs e)
        {
             Master.Page.Title = "... registro de movimientos del banco";

             Message_Span.InnerHtml = "";
             Message_Span.Style["display"] = "none";

             if (!Page.IsPostBack)
             {
                 if (!User.Identity.IsAuthenticated)
                 {
                     FormsAuthentication.SignOut();
                     return;
                 }
             }
        }

        protected void AjaxFileUpload1_UploadComplete(object sender, AjaxFileUploadEventArgs e)
        {
            // nótese como, al menos por ahora, solo permitimos xlsx ... 

            if (Path.GetExtension(e.FileName) != ".xlsx") 
            {
                this.CustomValidator1.IsValid = false;
                this.CustomValidator1.ErrorMessage = "El archivo indicado no es un documento Excel. Nota: la extensión del archivo debe ser 'xlsx'.";
                ValidationSummary1.ShowSummary = true;

                return;
            }

            try
            {
                //string filePath = MapPath("~/Temp/") + e.FileName;

                // usamos un nombre único, para que no se acumulen en el servidor todos los archivos que vayan
                // usando los usuarios. Nótese que usamos el nombre del usuario, para que no haya conflicto con otros ... 


                string filePath = MapPath("~/Temp/") + "MovimientosDesdeElBanco_" + User.Identity.Name + Path.GetExtension(e.FileName);
                AjaxFileUpload1.SaveAs(filePath);

                Session["Conciliacion_FileName"] = filePath; 
            }
            catch (Exception ex)
            {
                // grab exception here.

                string errorMessage = ex.Message;
                if (ex.InnerException != null)
                    errorMessage += ex.InnerException.Message;

                this.CustomValidator1.IsValid = false;
                this.CustomValidator1.ErrorMessage = "Se ha producido un error al intentar guardar el archivo indicado en el servidor.<br />" +
                    "El mensaje específico del error obtenido es: <br />" + errorMessage;
                ValidationSummary1.ShowSummary = true;

                return;
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            // ahora que el archivo está grabado en el disco, accedemos al documento Excel para intentar 
            // grabar los movimientos recibidos desde el banco ... 

            // ahora que se ha grabado en el servidor, reconstruimos el file name para leer su contenido

            if (Session["Conciliacion_FileName"] == null)
            {
                this.CustomValidator1.IsValid = false;
                this.CustomValidator1.ErrorMessage = "Aparentemente, Ud. no ha indicado aún cual es el documento Excel a cargar.<br />" +
                    "Indique la ubicación del documento Excel a cargar.";
                ValidationSummary1.ShowSummary = true;

                return;
            }

            string filePath = Session["Conciliacion_FileName"].ToString();

            if (!File.Exists(filePath))
            {
                this.CustomValidator1.IsValid = false;
                this.CustomValidator1.ErrorMessage = "Aparentemente, Ud. no ha indicado aún cual es el documento Excel a cargar.<br />" +
                    "Indique la ubicación del documento Excel a cargar.";
                ValidationSummary1.ShowSummary = true;

                return;
            }

            if (Session["ConciliacionBancariaID"] == null)
            {
                this.CustomValidator1.IsValid = false;
                this.CustomValidator1.ErrorMessage = "Aparentemente, no se ha seleccionado un registro de 'criterios' para la conciliación.<br />" +
                    "Debe seleccionar un criterio de conciliación antes de intentar registrar los movimientos del banco en la base de datos.";
                ValidationSummary1.ShowSummary = true;

                return;
            }

            int conciliacionBancariaID = 0; 

            if (!int.TryParse(Session["ConciliacionBancariaID"].ToString(), out conciliacionBancariaID))
            {
                this.CustomValidator1.IsValid = false;
                this.CustomValidator1.ErrorMessage = "Aparentemente, no se ha seleccionado un registro de 'criterios' para la conciliación.<br />" +
                    "Debe seleccionar un criterio de conciliación antes de intentar registrar los movimientos del banco en la base de datos.";
                ValidationSummary1.ShowSummary = true;

                return;
            }

            // en adelante, tenemos el ID de la conciliación en la variable 'conciliacionBancariaID' 


            string excelFileName = filePath;

            string fileExtension = Path.GetExtension(excelFileName);

            if (fileExtension != ".xlsx")
            {
                this.CustomValidator1.IsValid = false;
                this.CustomValidator1.ErrorMessage = "Al menos por ahora, este proceso solo acepta documentos excel del tipo 2007 (o posteriores).<br />" +
                    "Note que la extensión del documento Excel pasado a este proceso debe ser 'xlsx'.";
                ValidationSummary1.ShowSummary = true;

                return;
            }

            // intentamos abrir y leer el documento Excel usando ClosedXML 

            var workbook = new XLWorkbook(excelFileName);
            var ws = workbook.Worksheet(1);

            List<MovimientoBanco> list = new List<MovimientoBanco>(); 
            MovimientoBanco movimientoBanco;

            DateTime fecha;
            Decimal monto; 
            bool firstRow = true; 

            foreach (var r in ws.Rows()) 
            {
                if (firstRow)
                    firstRow = false;
                else
                {
                    if (r.CellCount() < 4)
                    {
                        this.CustomValidator1.IsValid = false;
                        this.CustomValidator1.ErrorMessage = "Aparentemente, el documento Excel indicado no está correctamente construido.<br />" +
                            "Recuerde que cada registro en el documento Excel debe tener 4 valores (celdas): fecha, referencia, descripción y monto.<br />" +
                            "Además, la primera fila debe contener encabezados para las columnas.";
                        ValidationSummary1.ShowSummary = true;

                        return;
                    }

                    if (!r.Cell(1).TryGetValue<DateTime>(out fecha))
                    {
                        this.CustomValidator1.IsValid = false;
                        this.CustomValidator1.ErrorMessage = "Aparentemente, el documento Excel indicado no está correctamente construido.<br />" +
                            "Recuerde que cada registro en el documento Excel debe tener 4 valores (celdas): fecha, referencia, descripción y monto.<br />" +
                            "Además, la primera fila debe contener encabezados para las columnas.<br /><br />" +
                            "En particular, aparentemente existe un problema con el valor: '" + r.Cell(1).Value.ToString() + "'" +
                            ", en la linea " + (list.Count() + 1).ToString() +
                            " del documento Excel pasado a esta función.";
                        ValidationSummary1.ShowSummary = true;

                        return;
                    }

                    if (!r.Cell(4).TryGetValue<decimal>(out monto))
                    {
                        this.CustomValidator1.IsValid = false;
                        this.CustomValidator1.ErrorMessage = "Aparentemente, el documento Excel indicado no está correctamente construido.<br />" +
                            "Recuerde que cada registro en el documento Excel debe tener 4 valores (celdas): fecha, referencia, descripción y monto.<br />" +
                            "Además, la primera fila debe contener encabezados para las columnas.<br /><br />" +
                            "En particular, aparentemente existe un problema con el valor: '" + r.Cell(4).Value.ToString() + "'" +
                            ", en la linea " + (list.Count() + 1).ToString() +
                            " del documento Excel pasado a esta función.";
                        ValidationSummary1.ShowSummary = true;

                        return;
                    }

                    movimientoBanco = new MovimientoBanco();

                    movimientoBanco.ConciliacionBancariaID = conciliacionBancariaID;
                    movimientoBanco.Fecha = fecha;
                    movimientoBanco.Referencia = r.Cell(2).Value.ToString();
                    movimientoBanco.Descripcion = r.Cell(3).Value.ToString();
                    movimientoBanco.Monto = monto;

                    list.Add(movimientoBanco);
                }
            }

            if (list.Count() == 0)
            {
                this.CustomValidator1.IsValid = false;
                this.CustomValidator1.ErrorMessage = "No hemos podido leer registros en el documento Excel indicado a este proceso.<br />" +
                    "Aparentemente, el documento Excel no contine registros.";
                ValidationSummary1.ShowSummary = true;

                return;
            }


                                
                            
            BancosEntities context = new BancosEntities();

            // -----------------------------------------------------------------------------------------------
            // eliminamos los registros que puedan existir para la misma conciliación (cargados antes) 
            // nótese como antes 'desasociamos' los movimientos bancarios y las partidas contables que puedan estar asociados 
            // (ie: conciliados) a estos movimientos ... 

            int rowsAffected =
                context.ExecuteStoreCommand("Update MovimientosBancarios Set ConciliacionMovimientoID = null " +
                    "Where ConciliacionMovimientoID In " +
                    "(Select ID From MovimientosDesdeBancos Where ConciliacionBancariaID = {0})", conciliacionBancariaID);

            rowsAffected =
                context.ExecuteStoreCommand("Update dAsientos Set ConciliacionMovimientoID = null " +
                    "Where ConciliacionMovimientoID In " +
                    "(Select ID From MovimientosDesdeBancos Where ConciliacionBancariaID = {0})", conciliacionBancariaID);

            rowsAffected =
                context.ExecuteStoreCommand("Delete From MovimientosDesdeBancos Where ConciliacionBancariaID = {0}", conciliacionBancariaID);

            // por último, registramos cada item en la tabla de movimientos ... 

            MovimientosDesdeBanco movimientoDesdeBanco;
            int movimientosAgregados = 0;

            foreach (MovimientoBanco m in list.OrderBy(m => m.Fecha))
            {
                movimientoDesdeBanco = new MovimientosDesdeBanco();

                movimientoDesdeBanco.ConciliacionBancariaID = m.ConciliacionBancariaID;
                movimientoDesdeBanco.Fecha = m.Fecha;
                movimientoDesdeBanco.Referencia = m.Referencia;
                movimientoDesdeBanco.Descripcion = m.Descripcion;
                movimientoDesdeBanco.Monto = m.Monto;

                movimientosAgregados++;
                context.MovimientosDesdeBancos.AddObject(movimientoDesdeBanco);
            }

            try
            {
                context.SaveChanges();
            }
            catch (Exception ex)
            {
                string errorMessage = ex.Message;
                if (ex.InnerException != null)
                    errorMessage += ex.InnerException.Message;

                this.CustomValidator1.IsValid = false;
                this.CustomValidator1.ErrorMessage =
                    "Hemos obtenido un error al intentar registrar los registros en la base de datos.<br />" +
                    "El mensaje específico de error es: " + errorMessage;
                ValidationSummary1.ShowSummary = true;

                return;
            }

            // indicamos al usuario un resumen del proceso. Además, mostramos los registros cargados en una lista ... 

            Message_Span.InnerHtml = "Ok, se han agregado " + movimientosAgregados.ToString() + " registros a la base de datos.<br />" +
                "Además, se han eliminado " + rowsAffected.ToString() + " registros, pues se habían cargado antes para la misma conciliación.";
            Message_Span.Style["display"] = "block";

        }

        private void ReadExcelFileUsingADO()
        {
            // nota importante: intentamos dejar de usar este código; mientras tanto, lo dejamos aquí; vamos a intentar 
            // usar ClosedXML, que es una librería que lee un xlmx file de forma muy fácil (esperamos); ClosedXML es un wrapper 
            // de OpenXML, que es la librería que permite manipular los excel (2007 or later) files en su forma nativa (es decir, usando 
            // OpenXML) 

            string excelFileName = "";
            string connectionString = "";
            string fileExtension = "xmlx";

            if (fileExtension == ".xls")
                connectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + excelFileName + ";Extended Properties=\"Excel 8.0;HDR=Yes;IMEX=1\"";
            else if (fileExtension == ".xlsx")
                connectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + excelFileName + ";Extended Properties=\"Excel 12.0;HDR=Yes;IMEX=1\"";

            try
            {

                DataTable dtTables = null;
                int i = 0;
                string sSName = "";

                OleDbConnection connection = new OleDbConnection();

                /// Selects File & Loops Through the Records
                connection.ConnectionString = connectionString;
                connection.Open();

                dtTables = connection.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);

                if (dtTables.Rows.Count > 0)
                {

                    // nótese como leemos *solo* el 1er. sheet ... 

                    //for (i = 0; i <= dtTables.Rows.Count - 1; i++)
                    for (i = 0; i <= 0; i++)
                    {
                        // obtenemos el nombre de *cada* sheet en el documento Excel ... 
                        sSName = dtTables.Rows[i]["TABLE_NAME"].ToString();
                        sSName = sSName.Replace("'", "");
                        sSName = sSName.Replace("$", "");

                        string sSql = "";
                        sSql = string.Format("select * from [{0}$]", sSName);

                        OleDbDataAdapter adapter = new OleDbDataAdapter(sSql, connection);

                        DataSet dataSet = new DataSet();
                        adapter.Fill(dataSet);

                        connection.Close();
                        connection.Dispose();

                        DataTable dt = dataSet.Tables[0];

                        List<MovimientoBanco> list = new List<MovimientoBanco>();
                        MovimientoBanco movimientoBanco;

                        int rowNumber = 0;

                        try
                        {
                            foreach (DataRow dr in dt.Rows)
                            {
                                rowNumber++;
                                DateTime fecha;
                                decimal monto = 0;


                                if (!DateTime.TryParse(dr[0].ToString(), out fecha))
                                {
                                    this.CustomValidator1.IsValid = false;
                                    this.CustomValidator1.ErrorMessage = "Hemos encontrado un error al intentar registrar el contenido del documento " +
                                        "Excel en la base de datos.<br />" +
                                        "El valor: '" + dr[0].ToString() + "', en la linea '" + rowNumber.ToString() + "' no es correcto. Por favor revise.";
                                    ValidationSummary1.ShowSummary = true;

                                    return;
                                }

                                if (!decimal.TryParse(dr[3].ToString(), out monto))
                                {
                                    this.CustomValidator1.IsValid = false;
                                    this.CustomValidator1.ErrorMessage = "Hemos encontrado un error al intentar registrar el contenido del documento " +
                                        "Excel en la base de datos.<br />" +
                                        "El valor: '" + dr[3].ToString() + "', en la linea '" + rowNumber.ToString() + "' no es correcto. Por favor revise.";
                                    ValidationSummary1.ShowSummary = true;

                                    return;
                                }


                                movimientoBanco = new MovimientoBanco
                                {
                                    //ConciliacionBancariaID = conciliacionBancariaID,
                                    Fecha = fecha,
                                    Referencia = dr[1].ToString(),
                                    Descripcion = dr[2].ToString(),
                                    Monto = monto
                                };

                                list.Add(movimientoBanco);
                            }
                        }
                        catch (Exception ex)
                        {
                            this.CustomValidator1.IsValid = false;
                            this.CustomValidator1.ErrorMessage = "Hemos encontrado un error al intentar registrar el contenido del documento " +
                                "Excel en la base de datos.<br />" +
                                "Por favor revise los valores contenidos en la linea '" + rowNumber.ToString() +
                                "; recuerde que los valores en cada linea deben representar: fecha, referencia, descripción y monto.";
                            ValidationSummary1.ShowSummary = true;

                            return;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
            }
        }
    }
}