using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Threading;
using System.Xml.Linq;
using System.Web.Security;
using ContabSysNet_Web.ModelosDatos;
using System.Linq; 


public partial class Contab_Presupuesto_Configuracion_CopiaCodigosEntreCias_CopiaCodigosPresupuesto : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!User.Identity.IsAuthenticated)
        {
            FormsAuthentication.SignOut();
            return;
        }

        Master.Page.Title = "Presupuesto - Copia de códigos de presupuesto entre compañías";

        ErrMessage_Span.InnerHtml = "";
        ErrMessage_Span.Style["display"] = "none";

        Message_Span.InnerHtml = "";
        Message_Span.Style["display"] = "none"; 

        if (!Page.IsPostBack)
        {
            
        }
        else
        {
            if (RebindPage_HiddenField.Value == "1")
            {

                // cuando este hidden field es 1 es porque el thread que ejecuta el proceso terminó. Entonces 
                // hacemos el binding de los controles; leemos el xml file que grabó el proceso y mostramos un 
                // mensaje al usuario 

                RebindPage_HiddenField.Value = "0";

                try
                {
                    // -----------------------------------------------------------------------------------------
                    // leemos el xml file que contiene los resultados de la ejecución del proceso 

                    String fileName = String.Concat(Page.GetType().Name, "-", User.Identity.Name);
                    String filePath = Server.MapPath("~/keepstatefiles/" + fileName + ".xml");

                    XElement xml = XElement.Load(filePath);

                    // primero revisamos a ver si hubo un error, el cual siempre se registra en el xml file

                    if (int.Parse(xml.Element("Values").Element("Error").Element("ErrorFlag").Value) == 0)
                    {
                       int nCantidadCodigosEliminados =
                           int.Parse(
                           xml.Element("Values").Element("CantidadCodigosEliminados").Value);

                       int nCantidadCodigosCopiados =
                           int.Parse(
                           xml.Element("Values").Element("CantidadCodigosCopiados").Value);

                       int nCantidadCuentasContablesAsociadasCopiadas =
                          int.Parse(
                          xml.Element("Values").Element("CantidadCuentasContablesAsociadasCopiadas").Value);

                       int nCantidadCuentasContablesAsociadasNoCopiadas =
                          int.Parse(
                          xml.Element("Values").Element("CantidadCuentasContablesAsociadasNoCopiadas").Value);

                       int nCantidadRegistrosMontosCopiados =
                          int.Parse(
                          xml.Element("Values").Element("CantidadRegistrosMontosCopiados").Value);

                       xml = null;

                       Message_Span.InnerHtml = "Ok, el procdeso ha terminado en forma satisfactoria.<br /><br />" +
                            "En total, se han eliminado " + nCantidadCodigosEliminados.ToString() + " códigos de presupuesto en la compañía " + TargetCiaContab_ListBox.SelectedItem + ", pues habían sido registrados antes. <br />" +
                            "Se han copiado " + nCantidadCodigosCopiados.ToString() + " códigos de presupuesto desde " + SourceCiaContab_ListBox.SelectedItem + " a " + TargetCiaContab_ListBox.SelectedItem + ". <br /> " +
                            "Además, se han agregado " + nCantidadCuentasContablesAsociadasCopiadas.ToString() + " cuentas contables asociadas a los códigos de presupuesto (" + nCantidadCuentasContablesAsociadasNoCopiadas + " no fueron copiadas, pues son cuentas contables que no existen en " + TargetCiaContab_ListBox.SelectedItem + ").<br />" +
                            nCantidadRegistrosMontosCopiados.ToString() + " registros de montos estimados fueron copiados desde  " + SourceCiaContab_ListBox.SelectedItem + " a " + TargetCiaContab_ListBox.SelectedItem + "."; 

                       Message_Span.Style["display"] = "block";
                    }
                    else
                    {
                        ErrMessage_Span.InnerHtml = "Hemos encontrado un error al intentar ejecutar el proceso. El mensaje específico de error es: <br /><br /> " +
                            xml.Element("Values").Element("Error").Element("ErrorMessage").Value;

                    ErrMessage_Span.Style["display"] = "block";
                    }

                    xml = null;
                }
                catch (Exception ex)
                {
                    ErrMessage_Span.InnerHtml = "Hemos encontrado un error al intentar ejecutar el proceso. El mensaje específico de error es: <br /><br /> " +
                    ex.Message;

                    ErrMessage_Span.Style["display"] = "block";
                }
            }
        }
    }
    protected void SourceCiaContab_ListBox_SelectedIndexChanged(object sender, EventArgs e)
    {
        AnosMontosEstimadosSourceCia_SqlDataSource.SelectParameters["CiaContab"].DefaultValue = SourceCiaContab_ListBox.SelectedValue;
        CopiarMontos_DropDownList.DataBind(); 
    }
    protected void CopiarCodigosPresupuesto_Button_Click(object sender, EventArgs e)
    {
        if (SourceCiaContab_ListBox.SelectedIndex == -1)
        {
            ErrMessage_Span.InnerHtml = "Ud. debe seleccionar la compañía que contiene los códigos de presupuesto a copiar.";
            ErrMessage_Span.Style["Display"] = "Block";

            return; 
        }

        if (TargetCiaContab_ListBox.SelectedIndex == -1)
        {
            ErrMessage_Span.InnerHtml = "Ud. debe seleccionar la compañía a la cual serán copiados los códigos de presupuesto.";
            ErrMessage_Span.Style["Display"] = "Block";

            return;
        }

        if (TargetCiaContab_ListBox.SelectedValue == SourceCiaContab_ListBox.SelectedValue)
        {
            ErrMessage_Span.InnerHtml = "Ud. debe seleccionar compañías diferentes.";
            ErrMessage_Span.Style["Display"] = "Block";

            return;
        }

        if (CopiarMontos_CheckBox.Checked && CopiarMontos_DropDownList.SelectedIndex == -1)
        {
            ErrMessage_Span.InnerHtml = "Ud. marcó la opción que indica que se deben también copiar los registros de montos estimados; sin embargo, no se ha seleccionado un año para estos registros de montos.<br />Nota: es probable que los registros de montos NO EXISTAN para la compañía que contiene los códigos; por esta razón, tal vez los años de estos montos no estén ni siquiera en la lista.";
            ErrMessage_Span.Style["Display"] = "Block";

            return; 
        }


        // chequeamos que la compañía Source tenga códigos de presupuesto registrados 

        int nCantidadRegistros = 0;
        dbContabDataContext dbContab = new dbContabDataContext(); 

        nCantidadRegistros = (from sc in dbContab.Presupuesto_Codigos
                              where sc.CiaContab ==
                              int.Parse(SourceCiaContab_ListBox.SelectedValue)
                              select sc).Count();

        if (nCantidadRegistros == 0)
        {
            ErrMessage_Span.InnerHtml = "La compañía " + SourceCiaContab_ListBox.SelectedItem + " no tiene códigos de presupuesto registrados que puedan " + 
                "ser copiados a la compañía " + TargetCiaContab_ListBox.SelectedItem + 
                ". Por favor revise esta situación.";
            ErrMessage_Span.Style["Display"] = "Block";

            dbContab = null; 
            return; 
        }

        // ahora chequeamos que la compañía Target NO TENGA códigos de presupuesto registrados; de ser así, 
        // la opción Eliminar Registros debe estar marcada 

        if (!EliminarCodigos_CheckBox.Checked)
        {
            int nCantidadCodigosTargetCia = (from a in dbContab.Presupuesto_Codigos
                                          where a.CiaContab == int.Parse(TargetCiaContab_ListBox.SelectedValue)
                                          select a.Codigo).Count();

            if (nCantidadCodigosTargetCia > 0)
            {
                ErrMessage_Span.InnerHtml = "La compañía " + TargetCiaContab_ListBox.SelectedItem + " TIENE códigos de presupuesto registrados. " + 
                    "Ud. DEBE marcar la opción que permite eliminar estos registros antes de efectuar la copia de los códigos desde la compañía " + 
                    SourceCiaContab_ListBox.SelectedItem + ".";
                ErrMessage_Span.Style["Display"] = "Block";

                dbContab = null;
                return; 
            }
        }


        dbContab = null; 

        // ------------------------------------------------------------------------------
        // inicializamos antes las variables que indican que debemos mostrar el progreso 

        Session["Progress_Completed"] = 0;
        Session["Progress_Percentage"] = 0;
        // ------------------------------------------------------------------------------

        Thread MyThread = new Thread(CopiarMontosEntreCias);
        MyThread.Priority = ThreadPriority.Lowest;
        MyThread.Start();

        //ejecutamos javascript para que lea la variable session y muestre el progreso 

        System.Text.StringBuilder sb = new System.Text.StringBuilder();
        sb.Append("<script language='javascript'>");
        sb.Append("showprogress();");
        sb.Append("</script>");

        ClientScript.RegisterStartupScript(this.GetType(), "onLoad", sb.ToString());
        }



    private void CopiarMontosEntreCias()
    {
        // construimos el nombre del archivo xml que contendrá, al final, los resultados de la ejecución 
        String fileName = String.Concat(Page.GetType().Name, "-", User.Identity.Name);
        String rootPath = Server.MapPath("~");
        String filePath = Server.MapPath("~/keepstatefiles/" + fileName + ".xml");

        // -----------------------------------------------------------------------------------------------
        // nótese que creamos el xml file que contendrá los resultados del proceso ahora. Esto permitirá 
        // actualizarlo más adelante cuando sea necesario en forma más compacta (ie: sin crear todo el 
        // archivo cada vez que, por ejemplo, encontremos un error y necesitemos reportarlo 

        XElement root = new XElement("ProcessState", 
                new XElement("Values",
                    new XElement("CantidadCodigosEliminados", 0),
                    new XElement("CantidadCodigosCopiados", 0),
                    new XElement("CantidadCuentasContablesAsociadasCopiadas", 0),
                    new XElement("CantidadCuentasContablesAsociadasNoCopiadas", 0),
                    new XElement("CantidadRegistrosMontosCopiados", 0),

                    new XElement("Error",
                        new XElement("ErrorFlag", 0),
                        new XElement("ErrorMessage", ""))));

        root.Save(filePath);
        // -----------------------------------------------------------------------------------------------

        
        // contamos y eliminamos los registros que ahora puedan existir para la cia Target. Nótese que, de 
        // existir, ya chequeamos que el usuario haya marcado la opción que permite eliminarlos. 

        dbContabDataContext dbContab = new dbContabDataContext();

        int nCantidadCodigosEliminados = (from a in dbContab.Presupuesto_Codigos
                                          where a.CiaContab == int.Parse(TargetCiaContab_ListBox.SelectedValue)
                                          select a.Codigo).Count();

        // ----------------------------------------------------------------------------------------------
        // siempre eliminamos los registros de códigos que puedan existir para la compañía Target; 
        // lo hacemos pues, si existen códigos por eliminar, al llegar aquí SIEMPRE se tuvo que haber  
        // marcado que éstos debían ser eliminados 

        dbContab.ExecuteCommand("Delete From Presupuesto_Codigos Where CiaContab = {0}", TargetCiaContab_ListBox.SelectedValue);

        // para reportar el progreso en la página 

        int nRegistroActual = 0, nProgressPercentaje = 0, nCantidadRegistros = 0;

        nCantidadRegistros = (from sc in dbContab.Presupuesto_Codigos
                                         where sc.CiaContab == 
                                         int.Parse(SourceCiaContab_ListBox.SelectedValue)
                                         select sc).Count(); 

        // ----------------------------------------------------------------------------------------------
        // leemos los códigos de presupuesto de la compañía Source y los copiamos a la compañía Target ... 

        int nCantidadCodigosCopiados = 0;

        var SourceCia_CodigosPresuesto = from sc in dbContab.Presupuesto_Codigos
                                         where sc.CiaContab == int.Parse(SourceCiaContab_ListBox.SelectedValue)
                                         select new
                                         {
                                             sc.Codigo,
                                             sc.Descripcion,
                                             sc.CantNiveles,
                                             sc.GrupoFlag,
                                             sc.SuspendidoFlag
                                         };

        Presupuesto_Codigo MyCodigo;
        List<Presupuesto_Codigo> MyCodigo_List = new List<Presupuesto_Codigo>();

        foreach (var Codigo in SourceCia_CodigosPresuesto) 
        {
            // vamos agregando cada código leído de la compañía Source a la compañía Target 
            MyCodigo = new Presupuesto_Codigo(); 

            MyCodigo.Codigo = Codigo.Codigo; 
            MyCodigo.Descripcion = Codigo.Descripcion; 
            MyCodigo.CantNiveles = Codigo.CantNiveles; 
            MyCodigo.GrupoFlag = Codigo.GrupoFlag;
            MyCodigo.SuspendidoFlag = Codigo.SuspendidoFlag;
            MyCodigo.CiaContab = int.Parse(TargetCiaContab_ListBox.SelectedValue); 

            MyCodigo_List.Add(MyCodigo); 

            nCantidadCodigosCopiados ++;

            // ---------------------------------------------------------------------
            // calculamos el progreso (%); es usado por el progress bar en la página
            nRegistroActual ++;
            nProgressPercentaje = nRegistroActual * 100 / nCantidadRegistros;

            Session["Progress_Percentage"] = nProgressPercentaje;
            // ----------------------------------------------------------------------
        }

        try
        {
            dbContab.Presupuesto_Codigos.InsertAllOnSubmit(MyCodigo_List);
            dbContab.SubmitChanges();
        }
        catch (Exception ex)
        {
            dbContab = null; 

            // ---------------------------------------------
            // escribimos el error al xml file y terminamos 

            XElement xml = XElement.Load(filePath);

            xml.Element("Values").Element("Error").ReplaceAll(
               new XElement("ErrorFlag", "1"),
               new XElement("ErrorMessage", ex.Message));

            xml.Save(filePath);

            // para indicar que al progress bar que el proceso terminó 
            Session["Progress_Completed"] = 1;

            return; 
        }

        // -----------------------------------------------------------------------------------------------
        // ahora copiamos las cuentas contables asociadas a códigos de presupuesto. Nótese que chequeamos 
        // que la cuenta contable exista para la compañía, antes de intentar grabarla en la tabla 

        // para mostrar el progreso del progreso en la página 

        nRegistroActual = 0;
        nProgressPercentaje = 0;

        nCantidadRegistros = (from cc in dbContab.Presupuesto_AsociacionCodigosCuentas
                              where cc.CiaContab == int.Parse(SourceCiaContab_ListBox.SelectedValue)
                              select cc).Count(); 

        var AsociacionCodigosCuentas = from acc in dbContab.Presupuesto_AsociacionCodigosCuentas
                                       where acc.CiaContab == int.Parse(SourceCiaContab_ListBox.SelectedValue)
                                       select new { acc.CodigoPresupuesto, acc.CuentaContableID, acc.CuentasContable.Cuenta };

        Presupuesto_AsociacionCodigosCuenta MyPresupuesto_AsociacionCodigosCuentas;
        List<Presupuesto_AsociacionCodigosCuenta> MyPresupuesto_AsociacionCodigosCuentas_List = 
            new List<Presupuesto_AsociacionCodigosCuenta>();

        int nCantidadCuentasContablesAsociadasCopiadas = 0;
        int nCantidadCuentasContablesAsociadasNoCopiadas = 0; 

        foreach (var CuentaContable in AsociacionCodigosCuentas)
        {

            // primero nos aseguramos que la cuenta contable existe en la compañía Target 

            // NOTA: como la cuenta contable en el código de presupuesto es el ID de la cuenta, debemos buscar la cuenta (ie: 1001200) para el ID (1500) ... 

            CuentasContable cuentaContableEnTargetCia = dbContab.CuentasContables.
                Where(c => c.Cuenta == CuentaContable.Cuenta && c.Cia == int.Parse(TargetCiaContab_ListBox.SelectedValue)).FirstOrDefault(); 

            if (cuentaContableEnTargetCia == null)
            {
                nCantidadCuentasContablesAsociadasNoCopiadas++;
            }
            else
            {
                MyPresupuesto_AsociacionCodigosCuentas = new Presupuesto_AsociacionCodigosCuenta();

                MyPresupuesto_AsociacionCodigosCuentas.CodigoPresupuesto = CuentaContable.CodigoPresupuesto;
                MyPresupuesto_AsociacionCodigosCuentas.CuentaContableID = cuentaContableEnTargetCia.ID;
                MyPresupuesto_AsociacionCodigosCuentas.CiaContab = int.Parse(TargetCiaContab_ListBox.SelectedValue); 

                MyPresupuesto_AsociacionCodigosCuentas_List.Add(MyPresupuesto_AsociacionCodigosCuentas);

                nCantidadCuentasContablesAsociadasCopiadas++; 
            }

            // ---------------------------------------------------------------------
            // calculamos el progreso (%); es usado por el progress bar en la página
            nRegistroActual++;
            nProgressPercentaje = nRegistroActual * 100 / nCantidadRegistros;

            Session["Progress_Percentage"] = nProgressPercentaje;
            // ----------------------------------------------------------------------
        }

        

        try
        {
            dbContab.Presupuesto_AsociacionCodigosCuentas.
                InsertAllOnSubmit(MyPresupuesto_AsociacionCodigosCuentas_List);
            dbContab.SubmitChanges(); 
        }
        catch (Exception ex)
        {
            dbContab = null;

            // ---------------------------------------------
            // escribimos el error al xml file y terminamos 

            XElement xml = XElement.Load(filePath);

            xml.Element("Values").Element("Error").ReplaceAll(
               new XElement("ErrorFlag", "1"),
               new XElement("ErrorMessage", ex.Message));

            xml.Save(filePath);

            // para indicar que al progress bar que el proceso terminó 
            Session["Progress_Completed"] = 1;

            return; 
        }

        // -----------------------------------------------------------------------------------------------------
        // por último, el usuario pudo haber indicado que desea también pasar los registros de montos estimados
        // desde la compañía Source hacia la Target. Nótese que, de ser así, debe venir el año en al textbox 
        // que existe para ello 

        int nCantidadRegistrosMontosCopiados = 0; 

        if (CopiarMontos_CheckBox.Checked && CopiarMontos_DropDownList.SelectedIndex != -1)
        {
            // para mostrar el progreso del progreso en la página 

            nRegistroActual = 0;
            nProgressPercentaje = 0;

            nCantidadRegistros = (from pm in dbContab.Presupuesto_Montos
                                  where pm.CiaContab ==
                                  int.Parse(SourceCiaContab_ListBox.SelectedValue) && 
                                  pm.Ano == int.Parse(CopiarMontos_DropDownList.SelectedValue)
                                  select pm).Count();

            var query = from pm in dbContab.Presupuesto_Montos
                        where pm.CiaContab == int.Parse(SourceCiaContab_ListBox.SelectedValue) &&
                        pm.Ano == int.Parse(CopiarMontos_DropDownList.SelectedValue)
                        select new
                        {
                            pm.CodigoPresupuesto,
                            pm.Moneda,
                            pm.Mes01_Est,
                            pm.Mes02_Est,
                            pm.Mes03_Est,
                            pm.Mes04_Est,
                            pm.Mes05_Est,
                            pm.Mes06_Est,
                            pm.Mes07_Est,
                            pm.Mes08_Est,
                            pm.Mes09_Est,
                            pm.Mes10_Est,
                            pm.Mes11_Est,
                            pm.Mes12_Est
                        }; 
 
            Presupuesto_Monto MyPresupuesto_Montos;
            List<Presupuesto_Monto> MyPresupuesto_Montos_List = new List<Presupuesto_Monto>(); 

            foreach (var Pres_Montos in query) 
            {
                 MyPresupuesto_Montos = new Presupuesto_Monto(); 

                MyPresupuesto_Montos.CodigoPresupuesto = Pres_Montos.CodigoPresupuesto; 
                MyPresupuesto_Montos.CiaContab = int.Parse(TargetCiaContab_ListBox.SelectedValue); 
                MyPresupuesto_Montos.Moneda = Pres_Montos.Moneda; 
                MyPresupuesto_Montos.Ano = short.Parse(CopiarMontos_DropDownList.SelectedValue); 

                MyPresupuesto_Montos.Mes01_Est = Pres_Montos.Mes01_Est; 
                MyPresupuesto_Montos.Mes02_Est = Pres_Montos.Mes02_Est; 
                MyPresupuesto_Montos.Mes03_Est = Pres_Montos.Mes03_Est; 
                MyPresupuesto_Montos.Mes04_Est = Pres_Montos.Mes04_Est; 
                MyPresupuesto_Montos.Mes05_Est = Pres_Montos.Mes05_Est; 
                MyPresupuesto_Montos.Mes06_Est = Pres_Montos.Mes06_Est; 
                MyPresupuesto_Montos.Mes07_Est = Pres_Montos.Mes07_Est; 
                MyPresupuesto_Montos.Mes08_Est = Pres_Montos.Mes08_Est; 
                MyPresupuesto_Montos.Mes09_Est = Pres_Montos.Mes09_Est; 
                MyPresupuesto_Montos.Mes10_Est = Pres_Montos.Mes10_Est; 
                MyPresupuesto_Montos.Mes11_Est = Pres_Montos.Mes11_Est; 
                MyPresupuesto_Montos.Mes12_Est = Pres_Montos.Mes12_Est; 

                MyPresupuesto_Montos_List.Add(MyPresupuesto_Montos); 

                nCantidadRegistrosMontosCopiados ++; 

                 // ---------------------------------------------------------------------
                // calculamos el progreso (%); es usado por el progress bar en la página
                nRegistroActual++;
                nProgressPercentaje = nRegistroActual * 100 / nCantidadRegistros;

                Session["Progress_Percentage"] = nProgressPercentaje;
                // ----------------------------------------------------------------------

            }


            try
            {
                dbContab.Presupuesto_Montos.InsertAllOnSubmit(MyPresupuesto_Montos_List); 
                dbContab.SubmitChanges(); 
            }
            catch (Exception ex)
            {
                dbContab = null;

                // ---------------------------------------------
                // escribimos el error al xml file y terminamos 

                XElement xml = XElement.Load(filePath);

                xml.Element("Values").Element("Error").ReplaceAll(
                    new XElement("ErrorFlag", "1"),
                    new XElement("ErrorMessage", ex.Message));

                xml.Save(filePath);

                // para indicar que al progress bar que el proceso terminó 
                Session["Progress_Completed"] = 1;

                return; 
            }
        }
        dbContab = null;

        // ----------------------------------------------------------------------------------------
        // cuando el proceso termina, escribimos los resultados al xml file 

        XElement xmlfile = XElement.Load(filePath);
        xmlfile.Element("Values").ReplaceAll(
              new XElement("CantidadCodigosEliminados", nCantidadCodigosEliminados),
                new XElement("CantidadCodigosCopiados", nCantidadCodigosCopiados),
                new XElement("CantidadCuentasContablesAsociadasCopiadas", nCantidadCuentasContablesAsociadasCopiadas),
                new XElement("CantidadCuentasContablesAsociadasNoCopiadas", nCantidadCuentasContablesAsociadasNoCopiadas),
                new XElement("CantidadRegistrosMontosCopiados", nCantidadRegistrosMontosCopiados),
                new XElement("Error",
                    new XElement("ErrorFlag", 0),
                    new XElement("ErrorMessage", "")));

        xmlfile.Save(filePath);

        // para indicar que al progress bar que el proceso terminó 
        Session["Progress_Completed"] = 1;
    }
    
}
