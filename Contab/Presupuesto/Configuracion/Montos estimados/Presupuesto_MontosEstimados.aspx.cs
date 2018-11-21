using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections; 
using System.Threading;
using System.Xml.Linq;
using System.Web.Security;
using ContabSysNet_Web.ModelosDatos;
using System.Linq;
using System.Web.UI.HtmlControls; 


public partial class Contab_Presupuesto_Configuracion_Montos_estimados_Presupuesto_MontosEstimados : System.Web.UI.Page
{
    protected void Page_Init(object sender, EventArgs e)
    {
        // Register control with the data manager.
        //DynamicDataManager1.RegisterControl(PresupuestoCodigos_ListView);
        this.PresupuestoMontos_ListView.EnableDynamicData(typeof(Presupuesto_Monto));
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!User.Identity.IsAuthenticated)
        {
            FormsAuthentication.SignOut();
            return;
        }

        Master.Page.Title = "Presupuesto - Registro de montos de presupuesto estimados";

        Message_Span.InnerHtml = "";
        Message_Span.Style["display"] = "none";

        ErrMessage_Span.InnerHtml = "";
        ErrMessage_Span.Style["display"] = "none";

        GeneralMessage_Span.InnerHtml = "";
        GeneralMessage_Span.Style["display"] = "none";

        GeneralError_Span.InnerHtml = "";
        GeneralError_Span.Style["display"] = "none"; 

        if (!Page.IsPostBack)
        {
            HtmlGenericControl MyHtmlH2;

            MyHtmlH2 = (HtmlGenericControl)Master.FindControl("PageTitle_TableCell");
            if (!(MyHtmlH2 == null))
            {
                MyHtmlH2.InnerHtml = "Presupuesto - Consulta y actualización de montos estimados";
            }

            Monedas_DropDownList.DataBind();
            CiasContab_DropDownList.DataBind();
            Anos_DropDownList.DataBind();

            this.PresupuestoMontos_ListView.DataBind(); 
        }
        else
        {
           if (RebindPage_HiddenField.Value == "1")
           {

               // cuando este hidden field es 1 es porque el thread que ejecuta el proceso terminó. Entonces 
               // hacemos el binding de los controles; leemos el xml file que grabó el proceso y mostramos un 
               // mensaje al usuario 

               RebindPage_HiddenField.Value = "0"; 
                
               // hacemos el databind en los combos y el listview para que el usuario no tenga que cerrar y abrir 
               // la página para que los registros recién agregados sean mostrados 

               try 
               {
                   Monedas_DropDownList.DataBind();
                   CiasContab_DropDownList.DataBind();
                   Anos_DropDownList.DataBind();

                   // nótese como seleccionamos el primer registro de cada combo; así, cuando se haga el 
                   // DataBind del ListView se mostrara el contenido que corresponde a los valores que
                   //  efectivamente se ven en los combos

                   Monedas_DropDownList.SelectedIndex = 0;
                   CiasContab_DropDownList.SelectedIndex = 0;
                   Anos_DropDownList.SelectedIndex = 0;
               }
                   catch (Exception ex)
               {
               }
                
               // hacemos el databind del ListView 
               this.PresupuestoMontos_ListView.DataBind(); 

               // nótese como, al menos en forma temporal, comentamos lo que tiene que ver con el proceso de ejecución en 
               // un thread separado, para lograr un meter (progress) en la página ... 

               //    try
               //    {
               //        // -----------------------------------------------------------------------------------------
               //        // leemos el xml file que contiene los resultados de la ejecución del proceso 

               //        String fileName = String.Concat(Page.GetType().Name, "-", User.Identity.Name);
               //        String filePath = Server.MapPath("~/keepstatefiles/" + fileName + ".xml");

               //        XElement xml = XElement.Load(filePath);

               //        int nRegistrosAgregadosAnoAnterior =
               //            int.Parse(
               //            xml.Element("Values").Element("RegistrosAgregadosAnoAnterior").Value);

               //         int nRegistrosActualizadosAnoAnterior =
               //            int.Parse(
               //            xml.Element("Values").Element("RegistrosActualizadosAnoAnterior").Value);

               //        int nRegistrosAgregadosAnoActual =
               //            int.Parse(
               //            xml.Element("Values").Element("RegistrosAgregadosAnoActual").Value);

               //        xml = null;

               //        Message_Span.InnerHtml = "Ok, hemos agregado " + nRegistrosAgregadosAnoAnterior.ToString() + " registros usando los montos estimados " +
               //            "definidos para el año anterior al indicado (" + Ano_TextBox.Text + ").<br />" +

               //            "Se han actualizado, pues ya existían, " + nRegistrosActualizadosAnoAnterior.ToString() + " registros usando los montos estimados " +
               //            "definidos para el año anterior al indicado (" + Ano_TextBox.Text + ").<br />" +

               //            "Además, hemos agregado " + nRegistrosAgregadosAnoActual.ToString() + " registros directamente desde la tabla de códigos de " + 
               //            "presupuesto (no se habían definido para el año anterior).";

               //        Message_Span.Style["display"] = "block";

               //    }
               //    catch (Exception ex)
               //    {
               //        Message_Span.InnerHtml = "Hemos obtenido un error al intentar ejecutar el proceso.<br /> " +
               //        "El mesaje espécifico de error es: " + ex.Message;

               //        Message_Span.Style["display"] = "block";
               //    }
           }
        }

    }
    public class _Presupuesto_Montos
    {
        public String CodigoPresupuesto { get; set; }
        public decimal? Mes01_Est { get; set; }
        public decimal? Mes02_Est { get; set; }
        public decimal? Mes03_Est { get; set; }
        public decimal? Mes04_Est { get; set; }
        public decimal? Mes05_Est { get; set; }
        public decimal? Mes06_Est { get; set; }
        public decimal? Mes07_Est { get; set; }
        public decimal? Mes08_Est { get; set; }
        public decimal? Mes09_Est { get; set; }
        public decimal? Mes10_Est { get; set; }
        public decimal? Mes11_Est { get; set; }
        public decimal? Mes12_Est { get; set; }
    }
    protected void CrearRegistrosMontos_Button_Click(object sender, EventArgs e)
    {
        // // ------------------------------------------------------------------------------
        // // inicializamos antes las variables que indican que debemos mostrar el progreso 

        // Session["Progress_Completed"] = 0; 
        // Session["Progress_Percentage"] = 0; 
        // // ------------------------------------------------------------------------------

        // Thread MyThread = new Thread(CrearRegistrosMontos); 
        // MyThread.Priority = ThreadPriority.Lowest; 
        // MyThread.Start(); 

        ////ejecutamos javascript para que lea la variable session y muestre el progreso 

        //System.Text.StringBuilder sb = new System.Text.StringBuilder(); 
        //sb.Append("<script language='javascript'>");
        //sb.Append("showprogress();");
        //sb.Append("</script>");

        //ClientScript.RegisterStartupScript(this.GetType(), "onLoad", sb.ToString());

        CrearRegistrosMontos(); 

        try
        {
            // -----------------------------------------------------------------------------------------
            // leemos el xml file que contiene los resultados de la ejecución del proceso 

            String fileName = String.Concat(Page.GetType().Name, "-", User.Identity.Name);
            String filePath = Server.MapPath("~/keepstatefiles/" + fileName + ".xml");

            XElement xml = XElement.Load(filePath);

            int nRegistrosAgregadosAnoAnterior =
                int.Parse(
                xml.Element("Values").Element("RegistrosAgregadosAnoAnterior").Value);

            int nRegistrosActualizadosAnoAnterior =
                int.Parse(
                xml.Element("Values").Element("RegistrosActualizadosAnoAnterior").Value);

            int nRegistrosAgregadosAnoActual =
                int.Parse(
                xml.Element("Values").Element("RegistrosAgregadosAnoActual").Value);

            xml = null;

            Message_Span.InnerHtml = "Ok, hemos agregado " + nRegistrosAgregadosAnoAnterior.ToString() + " registros usando los montos estimados " +
                "definidos para el año anterior al indicado (" + Ano_TextBox.Text + ").<br />" +

                "Se han actualizado, pues ya existían, " + nRegistrosActualizadosAnoAnterior.ToString() + " registros usando los montos estimados " +
                "definidos para el año anterior al indicado (" + Ano_TextBox.Text + ").<br />" +

                "Además, hemos agregado " + nRegistrosAgregadosAnoActual.ToString() + " registros directamente desde la tabla de códigos de " + 
                "presupuesto (no se habían definido para el año anterior).";

            Message_Span.Style["display"] = "block";

        }
        catch (Exception ex)
        {
            Message_Span.InnerHtml = "Hemos obtenido un error al intentar ejecutar el proceso.<br /> " +
            "El mesaje espécifico de error es: " + ex.Message;

            Message_Span.Style["display"] = "block";
        }
    }

    private void CrearRegistrosMontos() 
    {
        // creamos los registros con los montos estimados para el año indicado y para cada código de presupuesto

        int[] nCiasContab; 
        int[] nMonedas;

        // Creamos una lista de monedas; nótese que el usuario puede o no seleccionar una moneda 
        // ahora requerimos seleccionar una y solo una (moneda y cia contab) 

        if (Monedas_ListBox.SelectedIndex != -1)
        {
            nMonedas = new int[1];
            nMonedas[0] = int.Parse(Monedas_ListBox.SelectedValue);
        }
        else
        {
            // leemos las monedas y las grabamos en el array 
            dbContabDataContext dbContab0 = new dbContabDataContext();
            var monedas = from m in dbContab0.Moneda_Contabs
                          select m.Moneda1;

            int i = 0;
            int nCantMonedas = (from m in dbContab0.Moneda_Contabs
                                select m.Moneda1).Count();
            nMonedas = new int[nCantMonedas];

            foreach (int MyMoneda in monedas)
            {
                nMonedas[i] = MyMoneda;
                i++;
            }
            dbContab0 = null; 
        }


        // Igual que para monedas, creamos una lista de compañías  

        if (this.CiasContab_ListBox.SelectedIndex != -1)
        {
             nCiasContab = new int[1];
             nCiasContab[0] = int.Parse(CiasContab_ListBox.SelectedValue);
        }
        else
        {
            // leemos las cias contab y las grabamos en el array 
            dbContabDataContext dbContab0 = new dbContabDataContext();
            var cias = from c in dbContab0.Compania_Contabs
                          select c.Numero;

            int i = 0;
            int nCantCiasContab = (from c in dbContab0.Compania_Contabs
                                   select c.Numero).Count();
            nCiasContab = new int[nCantCiasContab];

            foreach (int MyCiaContab in cias)
            {
                nCiasContab[i] = MyCiaContab;
                i++;
            }
            dbContab0 = null; 
        }

        // -------------------------------------------------------------------------------------------------
        // lo PRIMERO que hacemos es intentar grabar para el nuevo año los registros que ahora existan para 
        // el año anterior 

        short AnoActual = short.Parse(Ano_TextBox.Text);
        short AnoAnterior = short.Parse(Ano_TextBox.Text);
        AnoAnterior -= 1;

        int nRegistrosAgregadosAnoAnterior = 0;
        int nRegistrosActualizadosAnoAnterior = 0; 


        dbContabDataContext dbContab = new dbContabDataContext();

        // -----------------------------------------------------------------------------------------------------
        // inicializamos la variable que sigue en la cantidad de cías x monedas; de esta forma, iremos mostrando
        // el progreso al usuario; cada vez que se procese una compañía, se irá mostrando el progreso 
        
        int nRegistroActual  = 0;
        int nProgressPercentaje = 0;

        int nCantidadRegistros = nMonedas.Length * nCiasContab.Length;
        // -----------------------------------------------------------------------------------------------------

        foreach (int nMoneda in nMonedas)
        {
            foreach (int nCiaContab in nCiasContab)
            {
                // leemos los registros en Presupuesto_Montos para el "año anterior" que no existan en la misma
                // tabla para el "año actual" y, además, que no estén suspendidos en Presupuesto_Codigos 

                string sqlSelectString = "Select CodigoPresupuesto, Mes01_Est, Mes02_Est, Mes03_Est, Mes04_Est, Mes05_Est, Mes06_Est, Mes07_Est, Mes08_Est, " +
                 " Mes09_Est, Mes10_Est, Mes11_Est, Mes12_Est " +
                 " From Presupuesto_Montos Inner Join Presupuesto_Codigos On " +
                 " Presupuesto_Montos.CodigoPresupuesto = Presupuesto_Codigos.Codigo And " +
                 " Presupuesto_Montos.CiaContab = Presupuesto_Codigos.CiaContab" +
                 " Where Presupuesto_Montos.Moneda = " + nMoneda.ToString() +
                 " And Presupuesto_Montos.CiaContab = " + nCiaContab.ToString() + " And Presupuesto_Montos.Ano = " + AnoAnterior.ToString() +
                 " And Presupuesto_Codigos.SuspendidoFlag = 0";

                if (!string.IsNullOrEmpty(this.CuentaPresupuesto_AgregarMontos_Filter_TextBox.Text))
                    // el usuario indicó un valor para seleccionar por cuenta de presupuesto; hacemos un Like por este campo ... 
                    sqlSelectString +=
                     " And Presupuesto_Montos.CodigoPresupuesto Like '" + this.CuentaPresupuesto_AgregarMontos_Filter_TextBox.Text.Replace("*", "%") + "'"; 
                     

                 if (!this.ActualizarAunqueExistan_CheckBox.Checked) 
                     // si el usuario lo indica, seleccionamos los montos aunque existan, y los actualizamos (si existen) ... 
                     sqlSelectString += 
                     " And Not Presupuesto_Montos.CodigoPresupuesto In " +
                     " (Select CodigoPresupuesto From Presupuesto_Montos Where Moneda = " + nMoneda.ToString() +
                     " And CiaContab = " + nCiaContab.ToString() + " And Ano = " + AnoActual.ToString() + ")";

                 IEnumerable<_Presupuesto_Montos> Lista_PresupuestoMontos_AnoAnterior = dbContab.ExecuteQuery<_Presupuesto_Montos>(sqlSelectString);

                Presupuesto_Monto MyRegPresupuestoMonto;
                List<Presupuesto_Monto> MyRegPresupuestoMontos = new List<Presupuesto_Monto>();

                foreach (_Presupuesto_Montos MyPresupuestoMontos in Lista_PresupuestoMontos_AnoAnterior)
                {
                    // si el registro de montos estimados existe, lo actualizamos; de otra forma, lo agregamos ... 

                    Presupuesto_Monto presupuestoMontos = dbContab.Presupuesto_Montos.
                        Where(m => m.CodigoPresupuesto == MyPresupuestoMontos.CodigoPresupuesto &&
                                   m.CiaContab == nCiaContab &&
                                   m.Moneda == nMoneda &&
                                   m.Ano == AnoActual).FirstOrDefault();

                    if (presupuestoMontos != null)
                    {
                        // el registro ya existe, lo actualizamos ... 

                        presupuestoMontos.Mes01_Est = MyPresupuestoMontos.Mes01_Est;
                        presupuestoMontos.Mes02_Est = MyPresupuestoMontos.Mes02_Est;
                        presupuestoMontos.Mes03_Est = MyPresupuestoMontos.Mes03_Est;
                        presupuestoMontos.Mes04_Est = MyPresupuestoMontos.Mes04_Est;
                        presupuestoMontos.Mes05_Est = MyPresupuestoMontos.Mes05_Est;
                        presupuestoMontos.Mes06_Est = MyPresupuestoMontos.Mes06_Est;
                        presupuestoMontos.Mes07_Est = MyPresupuestoMontos.Mes07_Est;
                        presupuestoMontos.Mes08_Est = MyPresupuestoMontos.Mes08_Est;
                        presupuestoMontos.Mes09_Est = MyPresupuestoMontos.Mes09_Est;
                        presupuestoMontos.Mes10_Est = MyPresupuestoMontos.Mes10_Est;
                        presupuestoMontos.Mes11_Est = MyPresupuestoMontos.Mes11_Est;
                        presupuestoMontos.Mes12_Est = MyPresupuestoMontos.Mes12_Est;

                        nRegistrosActualizadosAnoAnterior++;
                    }
                    else
                    {
                        // el registro no existe, lo agregamos 

                        MyRegPresupuestoMonto = new Presupuesto_Monto();

                        MyRegPresupuestoMonto.CodigoPresupuesto = MyPresupuestoMontos.CodigoPresupuesto;
                        MyRegPresupuestoMonto.CiaContab = nCiaContab;
                        MyRegPresupuestoMonto.Moneda = nMoneda;
                        MyRegPresupuestoMonto.Ano = AnoActual;

                        MyRegPresupuestoMonto.Mes01_Est = MyPresupuestoMontos.Mes01_Est;
                        MyRegPresupuestoMonto.Mes02_Est = MyPresupuestoMontos.Mes02_Est;
                        MyRegPresupuestoMonto.Mes03_Est = MyPresupuestoMontos.Mes03_Est;
                        MyRegPresupuestoMonto.Mes04_Est = MyPresupuestoMontos.Mes04_Est;
                        MyRegPresupuestoMonto.Mes05_Est = MyPresupuestoMontos.Mes05_Est;
                        MyRegPresupuestoMonto.Mes06_Est = MyPresupuestoMontos.Mes06_Est;
                        MyRegPresupuestoMonto.Mes07_Est = MyPresupuestoMontos.Mes07_Est;
                        MyRegPresupuestoMonto.Mes08_Est = MyPresupuestoMontos.Mes08_Est;
                        MyRegPresupuestoMonto.Mes09_Est = MyPresupuestoMontos.Mes09_Est;
                        MyRegPresupuestoMonto.Mes10_Est = MyPresupuestoMontos.Mes10_Est;
                        MyRegPresupuestoMonto.Mes11_Est = MyPresupuestoMontos.Mes11_Est;
                        MyRegPresupuestoMonto.Mes12_Est = MyPresupuestoMontos.Mes12_Est;

                        MyRegPresupuestoMontos.Add(MyRegPresupuestoMonto);

                        nRegistrosAgregadosAnoAnterior++; 
                    }
                }

                if (MyRegPresupuestoMontos.Count > 0)
                    dbContab.Presupuesto_Montos.InsertAllOnSubmit(MyRegPresupuestoMontos);

                try
                {
                    dbContab.SubmitChanges();
                }
                catch (Exception ex)
                {
                    string errorMessage = ex.Message;
                    if (ex.InnerException != null)
                        errorMessage += "<br />" + ex.InnerException.Message; 

                    ErrMessage_Span.InnerHtml = "Hemos obtenido un mensaje de error al intentar efectuar una operación en la base de datos.<br /> " +
                    "El mensaje específico de error es: " + errorMessage;
                    ErrMessage_Span.Style["display"] = "block";

                    return; 
                }


                // ---------------------------------------------------------------------------
                // calculamos el progreso (%); es usado por el progress bar en la página

                nRegistroActual += 1; 
                nProgressPercentaje = nRegistroActual * 100 / nCantidadRegistros; 

                Session["Progress_Percentage"] = nProgressPercentaje;
                // ---------------------------------------------------------------------------
            }
        }

        // -------------------------------------------------------------------------------------------------
        // YA GRABAMOS los códigos y sus montos desde al año anterior al actual; ahora leemos desde 
        // Presupuesto_Codigos aquellos que no existan en Presupuesto_Montos (pues son nuevos?) para el año 
        // actual y los registramos, con todos sus montos en nulls

        // nótese como el usuario decide si desea o no hacer este paso ... 

        int nRegistrosAgregadosAnoActual = 0;

        if (this.AgregarDesdeTablaCodigosPresupuesto_CheckBox.Checked)
        {
            nRegistroActual = 0;

            foreach (int nMoneda in nMonedas)
            {
                foreach (int nCiaContab in nCiasContab)
                {
                    // leemos los registros en Presupuesto_Montos para el "año anterior" que no existan en la misma
                    // tabla para el "año actual" y, además, que no estén suspendidos en Presupuesto_Codigos 

                    IEnumerable<String> Lista_CodigosPresupuesto_Nuevos = dbContab.ExecuteQuery<String>(
                     "Select Codigo From Presupuesto_Codigos Where" +
                     " CiaContab = " + nCiaContab.ToString() + " And SuspendidoFlag = 0 And GrupoFlag = 0" +
                     " And Not Codigo In " +
                     " (Select CodigoPresupuesto From Presupuesto_Montos Where Moneda = " + nMoneda.ToString() +
                     " And CiaContab = " + nCiaContab.ToString() + " And Ano = " + AnoActual.ToString() + ")"
                     );

                    Presupuesto_Monto MyRegPresupuestoMonto;
                    List<Presupuesto_Monto> MyRegPresupuestoMontos = new List<Presupuesto_Monto>();

                    foreach (String MyCodigoPresupuesto in Lista_CodigosPresupuesto_Nuevos)
                    {
                        MyRegPresupuestoMonto = new Presupuesto_Monto();

                        MyRegPresupuestoMonto.CodigoPresupuesto = MyCodigoPresupuesto;
                        MyRegPresupuestoMonto.CiaContab = nCiaContab;
                        MyRegPresupuestoMonto.Moneda = nMoneda;
                        MyRegPresupuestoMonto.Ano = AnoActual;

                        // nótese como todos los montos (estimados y ejecutados) quedan en null 

                        MyRegPresupuestoMontos.Add(MyRegPresupuestoMonto);

                        nRegistrosAgregadosAnoActual++;

                    }

                    if (MyRegPresupuestoMontos.Count > 0)
                    {
                        dbContab.Presupuesto_Montos.InsertAllOnSubmit(MyRegPresupuestoMontos);
                        try
                        {
                            dbContab.SubmitChanges();
                        }
                        catch (Exception ex)
                        {
                            //ErrMessage_Span.InnerHtml = "Hemos obtenido un mensaje de error al intentar efectuar una operación en la base de datos.<br />El mensaje específico de error es: " + ex.Message;
                            //ErrMessage_Span.Style["display"] = "block";
                        }
                    }

                    // ---------------------------------------------------------------------------
                    // calculamos el progreso (%); es usado por el progress bar en la página

                    nRegistroActual += 1;
                    nProgressPercentaje = nRegistroActual * 100 / nCantidadRegistros;

                    Session["Progress_Percentage"] = nProgressPercentaje;
                    // ---------------------------------------------------------------------------

                }
            }
        }

        dbContab = null;

        // -----------------------------------------------------------------------------------------
        // cuando el proceso termina, escribimos sus resultados a un xml file, para que los procese 
        // el parent thread 

        XElement root = new XElement("ProcessState");

        XElement elm1 = new XElement("Values",
                new XElement("RegistrosAgregadosAnoAnterior", nRegistrosAgregadosAnoAnterior),
                new XElement("RegistrosActualizadosAnoAnterior", nRegistrosActualizadosAnoAnterior),
                new XElement("RegistrosAgregadosAnoActual", nRegistrosAgregadosAnoActual));

        root.Add(elm1);

        String fileName   = String.Concat(Page.GetType().Name, "-", User.Identity.Name);
        String rootPath = Server.MapPath("~");
        String filePath = Server.MapPath("~/keepstatefiles/" + fileName + ".xml");

        root.Save(filePath);
        // -----------------------------------------------------------------------------------------

        // para indicar al progress bar que el proceso terminó
        Session["Progress_Completed"] = 1; 
    }

    protected void CiasContab_DropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        //if (CiasContab_DropDownList.SelectedIndex != -1)
        //{
        //    Presupuesto_Montos_LinqDataSource.WhereParameters["CiaContab"].DefaultValue = CiasContab_DropDownList.SelectedValue;
        //    PresupuestoMontos_ListView.DataBind(); 
        //}
        PresupuestoMontos_ListView.DataBind(); 
    }
    protected void Monedas_DropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        //if (Monedas_DropDownList.SelectedIndex != -1)
        //{
        //    Presupuesto_Montos_LinqDataSource.WhereParameters["Moneda"].DefaultValue = Monedas_DropDownList.SelectedValue;
        //    PresupuestoMontos_ListView.DataBind(); 
        //}

        PresupuestoMontos_ListView.DataBind(); 
    }
    protected void Anos_DropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        //if (Anos_DropDownList.SelectedIndex != -1)
        //{
        //    Presupuesto_Montos_LinqDataSource.WhereParameters["Ano"].DefaultValue = Anos_DropDownList.SelectedValue;
        //    PresupuestoMontos_ListView.DataBind(); 
        //}

        PresupuestoMontos_ListView.DataBind(); 
    }

    //private void DataBind_PresupuestoMontos_ListView()
    //{
    //    PresupuestoMontos_ListView.DataBind(); 
    //}
    protected void PresupuestoMontos_ListView_ItemUpdating(object sender, ListViewUpdateEventArgs e)
    {
        // propagamos valores que el usuario haya indicado para algún mes, en meses que haya dejado en blanco ... 

        decimal? valorMesAnterior = null;
        decimal?[] meses = new decimal?[12];

        byte mes = 0; 

        foreach (DictionaryEntry de in e.NewValues)
        {
            // tratamos solo los valores para propiedades del tipo Mes_99 ... 

            if (!de.Key.ToString().StartsWith("Mes") || !de.Key.ToString().EndsWith("Est"))
                continue;

            if (de.Value == null)
            {
                if (valorMesAnterior != null)
                    meses[mes] = valorMesAnterior;
            }
            else
            {
                decimal d; 
                if (Decimal.TryParse(de.Value.ToString(), out d))
                    meses[mes] = d;
                else
                {
                    GeneralError_Span.InnerHtml = "Los valores indicados para los meses deben ser del tipo numérico. ";
                    GeneralError_Span.Style["display"] = "block";

                    e.Cancel = true;
                    return; 
                }
            }
                

            if (de.Value != null) 
                valorMesAnterior = Convert.ToDecimal(de.Value);

            mes++; 
        }

        // ahora actualizamos el valor de cada item en el dictionary; nótese que no pudimos hacerlo en el foreach 
        // anterior, pues modificabamos el collection en el foreach (!!!??) 

        e.NewValues["Mes01_Est"] = meses[0];
        e.NewValues["Mes02_Est"] = meses[1];
        e.NewValues["Mes03_Est"] = meses[2];
        e.NewValues["Mes04_Est"] = meses[3];
        e.NewValues["Mes05_Est"] = meses[4];
        e.NewValues["Mes06_Est"] = meses[5];
        e.NewValues["Mes07_Est"] = meses[6];
        e.NewValues["Mes08_Est"] = meses[7];
        e.NewValues["Mes09_Est"] = meses[8];
        e.NewValues["Mes10_Est"] = meses[9];
        e.NewValues["Mes11_Est"] = meses[10];
        e.NewValues["Mes12_Est"] = meses[11];
    }

    protected void CodigoCuentaPresupuesto_TextBox_TextChanged(object sender, EventArgs e)
    {
        PresupuestoMontos_ListView.DataBind(); 
    }

    protected void Presupuesto_Montos_LinqDataSource_Selecting(object sender, LinqDataSourceSelectEventArgs e)
    {
        LinqDataSource myLinqDataSource = this.Presupuesto_Montos_LinqDataSource;
        dbContabDataContext dbContab = new dbContabDataContext();

        var query = dbContab.Presupuesto_Montos.Select(m => m);

        if (Anos_DropDownList.SelectedIndex != -1)
            query = query.Where(m => m.Ano == Convert.ToInt16(this.Anos_DropDownList.SelectedValue));

        if (Monedas_DropDownList.SelectedIndex != -1)
            query = query.Where(m => m.Moneda == Convert.ToInt32(Monedas_DropDownList.SelectedValue));

        if (CiasContab_DropDownList.SelectedIndex != -1)
            query = query.Where(m => m.CiaContab == Convert.ToInt32(this.CiasContab_DropDownList.SelectedValue));

        if (!string.IsNullOrEmpty(this.CodigoCuentaPresupuesto_TextBox.Text))
            if (this.CodigoCuentaPresupuesto_TextBox.Text.Contains("*"))
            {
                if (this.CodigoCuentaPresupuesto_TextBox.Text.StartsWith("*"))
                    query = query.Where(m => m.CodigoPresupuesto.EndsWith(this.CodigoCuentaPresupuesto_TextBox.Text.Replace("*","")));
                else if (this.CodigoCuentaPresupuesto_TextBox.Text.EndsWith("*"))
                    query = query.Where(m => m.CodigoPresupuesto.StartsWith(this.CodigoCuentaPresupuesto_TextBox.Text.Replace("*", "")));
                else
                    query = query.Where(m => m.CodigoPresupuesto.Contains(this.CodigoCuentaPresupuesto_TextBox.Text));
            }
            else
                query = query.Where(m => m.CodigoPresupuesto.Contains(this.CodigoCuentaPresupuesto_TextBox.Text));

        e.Result = query; 
    }

    protected void AjustarMontosEstimados_btnOk_Click(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(this.AjustarMontosMensuales_Porcentaje_TextBox.Text))
        {
            GeneralError_Span.InnerHtml = "Ud. debe indicar un valor para el porcentaje a aumentar o disminuir.";
            GeneralError_Span.Style["display"] = "block";

            return;
        }

        if (this.AjustarMontosMensuales_Porcentaje_TextBox.Text.Contains("."))
        {
            GeneralError_Span.InnerHtml = "Aparentemente, Ud. ha usado un '.' como separador decimal;<br />" + 
                "por favor no use puntos, sino comas, como separador decimal.";
            GeneralError_Span.Style["display"] = "block";

            return;
        }

        decimal porcentaje; 

        if (!decimal.TryParse(this.AjustarMontosMensuales_Porcentaje_TextBox.Text, out porcentaje))
        {
            GeneralError_Span.InnerHtml = "Aparentemente, el valor indicado como porcentaje no es correcto.<br />" + 
                "Por favor indique un número para este campo; ejemplos: 30; 30,5; -30,5; 10,75; ...";
            GeneralError_Span.Style["display"] = "block";

            return;
        }

        // determinamos cuantos items serán actualizados con este proceso ... 

        int cantidadRegistrosQueSeranActualizados; 

        using (dbContabDataContext dbContab = new dbContabDataContext())
        {
            var query = dbContab.Presupuesto_Montos.Select(m => m);

            if (Anos_DropDownList.SelectedIndex != -1)
                query = query.Where(m => m.Ano == Convert.ToInt16(this.Anos_DropDownList.SelectedValue));

            if (Monedas_DropDownList.SelectedIndex != -1)
                query = query.Where(m => m.Moneda == Convert.ToInt32(Monedas_DropDownList.SelectedValue));

            if (CiasContab_DropDownList.SelectedIndex != -1)
                query = query.Where(m => m.CiaContab == Convert.ToInt32(this.CiasContab_DropDownList.SelectedValue));

            if (!string.IsNullOrEmpty(this.CodigoCuentaPresupuesto_TextBox.Text))
                if (this.CodigoCuentaPresupuesto_TextBox.Text.Contains("*"))
                {
                    if (this.CodigoCuentaPresupuesto_TextBox.Text.StartsWith("*"))
                        query = query.Where(m => m.CodigoPresupuesto.EndsWith(this.CodigoCuentaPresupuesto_TextBox.Text.Replace("*", "")));
                    else if (this.CodigoCuentaPresupuesto_TextBox.Text.EndsWith("*"))
                        query = query.Where(m => m.CodigoPresupuesto.StartsWith(this.CodigoCuentaPresupuesto_TextBox.Text.Replace("*", "")));
                    else
                        query = query.Where(m => m.CodigoPresupuesto.Contains(this.CodigoCuentaPresupuesto_TextBox.Text));
                }
                else
                    query = query.Where(m => m.CodigoPresupuesto.Contains(this.CodigoCuentaPresupuesto_TextBox.Text));

            cantidadRegistrosQueSeranActualizados = query.Count(); 
        }
        // ------------------------------------------------------------------------------------------------------------------------------

        this.ModalPopupTitle_span2.InnerHtml = "Ajuste de montos estimados";
        this.ModalPopupBody_span2.InnerHtml = "Desea ajustar los montos de las cuentas de presupuesto seleccionadas, usando el porcentaje: " +
            porcentaje.ToString("N2") + "% ?<br /><br />" +
            "(en total, este proceso ajustará montos de " + cantidadRegistrosQueSeranActualizados.ToString() + " cuentas de presupuesto, " +
            "las cuales están ahora seleccionadas en la lista)"; 

        this.AjustarMontosEstimados_Confirmacion_Button.Visible = true;
        this.AjustarMontosEstimados_Confirmacion_Button.Text = "Ajustar montos ...";
        this.AjustarMontosEstimados_Cancel_Button_Click.Text = "Cancelar";

        this.ModalPopupExtender1.Show();

        Session["ConfirmarNominaEjecutadaAntesFlag"] = true;
        return; 
    }

    protected void AjustarMontosEstimados_Confirmacion_Button_Click(object sender, EventArgs e)
    {
        // ajustamos los montos de cuentas seleccionadas, en el porcentaje indicado por el usuario ... 

        decimal porcentaje;

        if (!decimal.TryParse(this.AjustarMontosMensuales_Porcentaje_TextBox.Text, out porcentaje))
        {
            GeneralError_Span.InnerHtml = "Aparentemente, el valor indicado como porcentaje no es correcto.<br />" +
                "Por favor indique un número para este campo; ejemplos: 30; 30,5; -30,5; 10,75; ...";
            GeneralError_Span.Style["display"] = "block";

            return;
        }



        dbContabDataContext dbContab = new dbContabDataContext();

        var query = dbContab.Presupuesto_Montos.Select(m => m);

        if (Anos_DropDownList.SelectedIndex != -1)
            query = query.Where(m => m.Ano == Convert.ToInt16(this.Anos_DropDownList.SelectedValue));

        if (Monedas_DropDownList.SelectedIndex != -1)
            query = query.Where(m => m.Moneda == Convert.ToInt32(Monedas_DropDownList.SelectedValue));

        if (CiasContab_DropDownList.SelectedIndex != -1)
            query = query.Where(m => m.CiaContab == Convert.ToInt32(this.CiasContab_DropDownList.SelectedValue));

        if (!string.IsNullOrEmpty(this.CodigoCuentaPresupuesto_TextBox.Text))
            if (this.CodigoCuentaPresupuesto_TextBox.Text.Contains("*"))
            {
                if (this.CodigoCuentaPresupuesto_TextBox.Text.StartsWith("*"))
                    query = query.Where(m => m.CodigoPresupuesto.EndsWith(this.CodigoCuentaPresupuesto_TextBox.Text.Replace("*", "")));
                else if (this.CodigoCuentaPresupuesto_TextBox.Text.EndsWith("*"))
                    query = query.Where(m => m.CodigoPresupuesto.StartsWith(this.CodigoCuentaPresupuesto_TextBox.Text.Replace("*", "")));
                else
                    query = query.Where(m => m.CodigoPresupuesto.Contains(this.CodigoCuentaPresupuesto_TextBox.Text));
            }
            else
                query = query.Where(m => m.CodigoPresupuesto.Contains(this.CodigoCuentaPresupuesto_TextBox.Text));

        int registrosSeleccionados = 0;
        int signo = porcentaje >= 0 ? 1 : -1;
        porcentaje = Math.Abs(porcentaje / 100); 

        // nótese como siempre tratamos el monto absoluto (sin su signo) y luego agregamos el signo al final; la idea es que 
        // si el usuario quiere aumentar -1000 en 50%, quede -1500 y no -500 

        foreach (Presupuesto_Monto montos in query)
        {
            montos.Mes01_Est = AjustarMontoEstimado(montos.Mes01_Est, signo, porcentaje);
            montos.Mes02_Est = AjustarMontoEstimado(montos.Mes02_Est, signo, porcentaje);
            montos.Mes03_Est = AjustarMontoEstimado(montos.Mes03_Est, signo, porcentaje);
            montos.Mes04_Est = AjustarMontoEstimado(montos.Mes04_Est, signo, porcentaje);
            montos.Mes05_Est = AjustarMontoEstimado(montos.Mes05_Est, signo, porcentaje);
            montos.Mes06_Est = AjustarMontoEstimado(montos.Mes06_Est, signo, porcentaje);
            montos.Mes07_Est = AjustarMontoEstimado(montos.Mes07_Est, signo, porcentaje);
            montos.Mes08_Est = AjustarMontoEstimado(montos.Mes08_Est, signo, porcentaje);
            montos.Mes09_Est = AjustarMontoEstimado(montos.Mes09_Est, signo, porcentaje);
            montos.Mes10_Est = AjustarMontoEstimado(montos.Mes10_Est, signo, porcentaje);
            montos.Mes11_Est = AjustarMontoEstimado(montos.Mes11_Est, signo, porcentaje);
            montos.Mes12_Est = AjustarMontoEstimado(montos.Mes12_Est, signo, porcentaje); 
                
            registrosSeleccionados++; 
        }

        string modalTitleMessage = "Ajuste de montos estimados";
        string modalBodyMessage = "Ok, los montos de las cuentas de presupuesto seleccionadas en la lista han sido ajustados.<br /><br />" +
            "En total, se han ajustado " + registrosSeleccionados.ToString() + " cuentas de presupuesto (que estaban seleccionadas en la lista).<br /><br />" +
            "Cuando Ud. cierre este diálogo, la lista estará actualizada y Ud. podrá ver los montos de las cuentas de presupuesto ya actualizados.";  

        try
        {
            dbContab.SubmitChanges(); 
        }
        catch (Exception ex)
        {
            string errorMessage = ex.Message;
            if (ex.InnerException != null)
                errorMessage += "<br />" + ex.InnerException.Message;

            modalTitleMessage = "Ha ocurrido un error al intentar guardar los cambios en la base de datos ...";
            modalBodyMessage = errorMessage;  
        }


        this.ModalPopupTitle_span2.InnerHtml = modalTitleMessage;
        this.ModalPopupBody_span2.InnerHtml = modalBodyMessage; 


        this.AjustarMontosEstimados_Confirmacion_Button.Visible = false;
        this.AjustarMontosEstimados_Confirmacion_Button.Text = "Ajustar montos ...";
        this.AjustarMontosEstimados_Cancel_Button_Click.Text = "Cerrar";

        this.ModalPopupExtender1.Show();

        this.PresupuestoMontos_ListView.DataBind(); 
    }

    private decimal? AjustarMontoEstimado(decimal? montoEstimado, int signo, decimal porcentaje) 
    {
        if (montoEstimado != null)
        {
            decimal ajuste = Math.Abs(montoEstimado.Value) * porcentaje;

            if (montoEstimado.Value >= 0)
                if (signo > 0)
                    // el monto es positivo y el usuario quiere agregar al monto 
                    montoEstimado += ajuste;
                else
                    // el monto es positivo y el usuario quiere restar al monto 
                    montoEstimado -= ajuste;
            else
                if (signo > 0)
                    // el monto es negativo y el usuario quiere agregar al monto 
                    montoEstimado -= ajuste;
                else
                    // el monto es negativo y el usuario quiere restar al monto 
                    montoEstimado += ajuste;

            montoEstimado = Math.Round(montoEstimado.Value, 2);
        }

        return montoEstimado; 
    }
}
