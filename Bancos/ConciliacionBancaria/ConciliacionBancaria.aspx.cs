using System;
using System.Collections;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Collections.Generic;
using System.Linq;
using ContabSysNet_Web.ModelosDatos_EF.Bancos;
using System.Web.UI.WebControls;
using ContabSysNet_Web.ModelosDatos_EF.Contab;


namespace ContabSysNet_Web.Bancos.ConciliacionBancaria
{
    public partial class ConciliacionBancaria : System.Web.UI.Page
    {
        // usamos este item en muchas partes de la página ... 
        ConciliacionesBancaria _conciliacion;

        private class movimientoBanco
        {
            public int ID { get; set; }
            public int? MovimientoConciliacionID { get; set; }
            public decimal Monto { get; set; }
        }

        private class movimientoContab
        {
            public int AsientoID { get; set; }
            public short PartidaID { get; set; }
            public int? MovimientoConciliacionID { get; set; }
            public decimal Monto { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!User.Identity.IsAuthenticated)
            {
                FormsAuthentication.SignOut();
                return;
            }

            // -----------------------------------------------------------------------------------------

            Master.Page.Title = "Conciliación bancaria";
            //this.juiceDialog.AutoOpen = false;              // para que el juice ui dialog no se abra cada vez ... 

            if (!Page.IsPostBack)
            {
                //Gets a reference to a Label control that is not in a 
                //ContentPlaceHolder control

                HtmlContainerControl MyHtmlSpan;

                MyHtmlSpan = (HtmlContainerControl)(Master.FindControl("AppName_Span"));
                if (MyHtmlSpan != null)
                    MyHtmlSpan.InnerHtml = "Bancos";

                HtmlGenericControl MyHtmlH2;

                MyHtmlH2 = (HtmlGenericControl)(Master.FindControl("PageTitle_TableCell"));
                if (MyHtmlH2 != null)
                    MyHtmlH2.InnerHtml = "Conciliación de cuentas bancarias";

                //--------------------------------------------------------------------------------------------
                //para asignar la página que corresponde al help de la página 

                HtmlAnchor MyHtmlHyperLink;
                MyHtmlHyperLink = (HtmlAnchor)Master.FindControl("Help_HyperLink");

                MyHtmlHyperLink.HRef = "javascript:PopupWin('../../../Doc/Bancos/Facturas/Consulta facturas/consulta_general_de_facturas.htm', 1000, 680)";

                // en esta variable guardamos el ID del registro de conciliación que indique el usuario; en este registro se mantienen 
                // los criterios necesarios para ejecutar la conciliación (cuenta bancaria, cuenta contable, período, etc.) 
                Session["ConciliacionBancariaID"] = null;
                Session["Conciliacion_FileName"] = null; 
            }
            else
            {
                //-------------------------------------------------------------------------
                // la página puede ser 'refrescada' por el popup; en ese caso, ejeucutamos  
                // una función que efectúa alguna funcionalidad y rebind la información 

                // nótese como, en este caso, RefreshAndBindInfo() es ejecutada solo cuando regresamos de establcer el criterio de ejecución ... 

                if (this.RebindFlagHiddenField.Value == "1")
                {
                    RebindFlagHiddenField.Value = "0";
                    RefreshAndBindInfo();
                }

                this.CriteriosConciliacion_Div.InnerText = "";

                if (Session["ConciliacionBancariaID"] != null)
                {
                    // mostramos en la página los criterios de ejecución establecidos por el usuario ... 

                    int conciliacionBancariaID = 0;

                    if (!int.TryParse(Session["ConciliacionBancariaID"].ToString(), out conciliacionBancariaID))
                    {
                        string errorMessage = "Aparentemente, el criterio de ejecucción de esta conciliación no está correctamente establecido.<br /> " +
                            "Por favor, intente establecer un criterio de ejecución para esta conciliación bancaria.";

                        CustomValidator1.IsValid = false;
                        CustomValidator1.ErrorMessage = errorMessage;

                        return;
                    }

                    using (BancosEntities db = new BancosEntities())
                    {
                        _conciliacion = db.ConciliacionesBancarias.Where(c => c.ID == conciliacionBancariaID).FirstOrDefault();

                        this.CriteriosConciliacion_Div.InnerHtml =
                            "<b>Criterios de ejecución de esta conciliación bancaria: </b><br /> " +
                            _conciliacion.Compania.Nombre + " - " +
                            _conciliacion.CuentasBancaria.Agencia1.Banco1.Nombre + " - " +
                            _conciliacion.CuentasBancaria.Moneda1.Simbolo + " - " +
                            _conciliacion.CuentasBancaria.CuentaBancaria + " - " +
                            _conciliacion.CuentasContable.CuentaEditada + " - " +
                            _conciliacion.CuentasContable.Descripcion;
                    }
                }
                // -------------------------------------------------------------------------
            }
        }

        private void RefreshAndBindInfo()
        {

            if (!User.Identity.IsAuthenticated)
            {
                FormsAuthentication.SignOut();
                return;
            }


            //if (Session["FiltroForma"] == null)
            //{
            //    string errorMessage = "Aparentemente, Ud. no ha indicado un filtro aún.<br />Por favor indique y aplique un filtro antes " +
            //        "de intentar mostrar el resultado de la consulta.";

            //    CustomValidator1.IsValid = false;
            //    CustomValidator1.ErrorMessage = errorMessage;

            //    return;
            //}
        }

        protected void SeleccionarMovimientos_LinkButton_Click(object sender, EventArgs e)
        {
            if (_conciliacion == null)
            {
                string errorMessage = "Aparentemente, no se han establecido los criterios de ejecución para la conciliación bancaria.<br /> " +
                    "Ud. debe definir y establecer estos criterios usando la opción que corresponde.";

                CustomValidator1.IsValid = false;
                CustomValidator1.ErrorMessage = errorMessage;

                return;
            }

            this.MovimientosBanco_GridView.DataBind();
            this.MovimientosBancarios_GridView.DataBind();
            this.MovimientosContables_GridView.DataBind(); 
        }

        // The return type can be changed to IEnumerable, however to support
        // paging and sorting, the following parameters must be added:
        //     int maximumRows
        //     int startRowIndex
        //     out int totalRowCount
        //     string sortByExpression
        public IQueryable<MovimientosDesdeBanco> MovimientosBanco_GridView_GetData()
        {
            if (!this.Page.IsPostBack)
                return null; 


            if (_conciliacion == null)
            {
                string errorMessage = "Aparentemente, no se han establecido los criterios de ejecución para la conciliación bancaria.<br /> " +
                    "Ud. debe definir y establecer estos criterios usando la opción que corresponde.";

                CustomValidator1.IsValid = false;
                CustomValidator1.ErrorMessage = errorMessage;

                return null; 
            }

            BancosEntities db = new BancosEntities();

            var query = db.MovimientosDesdeBancos.Include("dAsientos").
                                                  Include("dAsientos.Asiento").
                                                  Include("MovimientosBancarios").
                                                  Where(m => m.ConciliacionBancariaID == _conciliacion.ID); 

            if (query.Count() == 0)
            {
                string errorMessage = "No se han podido leer movimientos bancarios (del banco) para los criterios de ejecución establecidos.<br /> " +
                    "Probablemente, aunque Ud. ha definido y establecido los criterios de ejecución de la conciliación, " +
                    "no ha cargado los movimientos del banco que corresponden.";

                CustomValidator1.IsValid = false;
                CustomValidator1.ErrorMessage = errorMessage;

                return null; 
            }

            switch (this.MovimientosBanco_Filtro_DropDownList.SelectedValue)
            {
                case "0":
                    break; 
                case "1": 
                    // con movimiento bancario encontrado 
                    //query = query.Where(m => m.MovimientosBancarios.FirstOrDefault() != null);
                    query = query.Where(m => m.MovimientosBancarios.Any()); 
                    break;
                case "2":
                    //query = query.Where(m => m.dAsientos.FirstOrDefault() != null);
                    query = query.Where(m => m.dAsientos.Any()); 
                    break;
                case "3":
                    //query = query.Where(m => m.MovimientosBancarios.FirstOrDefault() != null && m.dAsientos.FirstOrDefault() != null);
                    query = query.Where(m => m.MovimientosBancarios.Any() && m.dAsientos.Any()); 
                    break; 
            }


            query = query.OrderBy(m => m.Fecha).ThenBy(m => m.Monto);

            return query;
        }

        protected void MovimientosBanco_GridView_SelectedIndexChanged(object sender, EventArgs e)
        {
        }

        protected void MovimientosBanco_GridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridView gv = (GridView)sender;
            gv.SelectedIndex = -1; 
        }

        // The return type can be changed to IEnumerable, however to support
        // paging and sorting, the following parameters must be added:
        //     int maximumRows
        //     int startRowIndex
        //     out int totalRowCount
        //     string sortByExpression
        public IQueryable<MovimientosBancario> MovimientosBancarios_GridView_GetData()
        {
            if (!this.Page.IsPostBack)
                return null;

            if (_conciliacion == null)
                return null;


            BancosEntities db = new BancosEntities();

            var query = db.MovimientosBancarios.Include("Chequera").
                                                Include("Chequera.CuentasBancaria").
                                                Include("Chequera.CuentasBancaria.Agencia1").
                                                Include("Chequera.CuentasBancaria.Agencia1.Banco1").
                                                Include("Chequera.CuentasBancaria.Moneda1").
                                                Where(m => m.Fecha >= _conciliacion.Desde && m.Fecha <= _conciliacion.Hasta &&
                                                      m.Chequera.CuentasBancaria.Cia == _conciliacion.CiaContab &&
                                                      m.Chequera.CuentasBancaria.CuentaInterna == _conciliacion.CuentaBancaria);

            if (query.Count() == 0)
            {
                string errorMessage = "No se ha podido leer movimientos bancarios (nuestros) que correspondan al criterio de ejecución establecido.<br /> " +
                    "Por favor revise, en el criterio de conciliación indicado, valores como: período, cuenta bancaria y Cia Contab.";

                CustomValidator1.IsValid = false;
                CustomValidator1.ErrorMessage = errorMessage;

                return null;
            }

            switch (this.MovimientosBancarios_Filtro_DropDownList.SelectedValue)
            {
                case "0":
                    break;
                case "1":
                    // encontrados
                    query = query.Where(m => m.ConciliacionMovimientoID != null);
                    break;
                case "2":
                    // no encontrados 
                    query = query.Where(m => m.ConciliacionMovimientoID == null);
                    break;
            }

            query = query.OrderBy(m => m.Fecha).ThenBy(m => m.Monto);

            return query;
        }

        protected void MovimientosBancarios_GridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridView gv = (GridView)sender;
            gv.SelectedIndex = -1; 
        }

        // The return type can be changed to IEnumerable, however to support
        // paging and sorting, the following parameters must be added:
        //     int maximumRows
        //     int startRowIndex
        //     out int totalRowCount
        //     string sortByExpression

        public IQueryable<ContabSysNet_Web.ModelosDatos_EF.Contab.dAsiento> MovimientosContables_GridView_GetData()
        {
            if (!this.Page.IsPostBack)
                return null;

            if (_conciliacion == null)
                return null;

            BancosEntities db = new BancosEntities();

            dbContab_Contab_Entities dbContab = new dbContab_Contab_Entities();

            var query = dbContab.dAsientos.Include("Asiento").
                                            Where(m => m.Asiento.Fecha >= _conciliacion.Desde && m.Asiento.Fecha <= _conciliacion.Hasta &&
                                                    m.Asiento.Cia == _conciliacion.CiaContab &&
                                                    m.CuentaContableID == _conciliacion.CuentaContable && 
                                                    m.Asiento.Moneda == _conciliacion.CuentasBancaria.Moneda1.Moneda1);

            if (query.Count() == 0)
            {
                string errorMessage = "No se ha podido leer movimientos contables que correspondan al criterio de ejecución establecido.<br /> " +
                    "Por favor revise, en el criterio de conciliación indicado, valores como: período, cuenta contable y Cia Contab.";

                CustomValidator1.IsValid = false;
                CustomValidator1.ErrorMessage = errorMessage;

                return null;
            }

            switch (this.MovimientosContables_Filtro_DropDownList.SelectedValue)
            {
                case "0":
                    break;
                case "1":
                    // encontrados
                    query = query.Where(m => m.ConciliacionMovimientoID != null);
                    break;
                case "2":
                    // no encontrados 
                    query = query.Where(m => m.ConciliacionMovimientoID == null);
                    break;
            }

            query = query.OrderBy(m => m.Asiento.Fecha).ThenBy(m => m.Asiento.Numero);

            return query;
        }

        protected void MovimientosContables_GridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridView gv = (GridView)sender;
            gv.SelectedIndex = -1; 
        }

        protected void CompararMovimientos_LinkButton_Click(object sender, EventArgs e)
        {
            string errorMessage; 

            if (_conciliacion == null)
            {
                errorMessage = "Aparentemente, no se han establecido los criterios de ejecución para la conciliación bancaria.<br /> " +
                    "Ud. debe definir y establecer estos criterios usando la opción que corresponde.";

                CustomValidator1.IsValid = false;
                CustomValidator1.ErrorMessage = errorMessage;

                return; 
            }

            // lo primero que hacemos es determinar si el mes en bancos y contab están cerrados; de ser así, simplemente, 
            // lo indicamos y no continuamos ... 

            // nótese como usamos un modelo de datos LinqToSql (no EF), pues el código en la clase AsientosContables lo usa así y fue 
            // escrito hace bastante tiempo ... 

            ContabSysNet_Web.ModelosDatos.dbContabDataContext contabContex = new ContabSysNet_Web.ModelosDatos.dbContabDataContext();

            FuncionesContab funcionesContab = new FuncionesContab(_conciliacion.CiaContab, _conciliacion.CuentasBancaria.Moneda, contabContex);

            short mesFiscal; 
            short anoFiscal;

            if (!funcionesContab.DeterminarMesFiscal(_conciliacion.Desde, _conciliacion.CiaContab, out errorMessage, out mesFiscal, out anoFiscal))
            {
                errorMessage = "Hemos obtenido un error, al intentar obtener obtener el mes y año fiscal para la fecha indicada como criterio de ejecución.<br /> " +
                    "A continuación, mostramos el mensaje específico de error:<br /> " + errorMessage;

                CustomValidator1.IsValid = false;
                CustomValidator1.ErrorMessage = errorMessage;

                return;
            }

            if (!funcionesContab.ValidarUltimoMesCerradoContab(_conciliacion.Desde, mesFiscal, anoFiscal, _conciliacion.CiaContab, out errorMessage))
            {
                errorMessage = "Aparentemente, el mes fiscal que corresponde al período indicado en el criterio de ejecución está cerrado en <b>Contab</b><br /> " +
                    "La información que corresponde a un mes cerrado no puede ser modificada. Por favor revise."; 

                CustomValidator1.IsValid = false;
                CustomValidator1.ErrorMessage = errorMessage;

                return;
            }


            BancosEntities bancosContext = new BancosEntities();

            if (!funcionesContab.ValidarUltimoMesCerradoBancos(_conciliacion.Desde, _conciliacion.CiaContab, bancosContext)) 
            {
                errorMessage = "Aparentemente, el mes que corresponde al período indicado en el criterio de ejecución está cerrado en <b>Bancos</b><br /> " +
                    "La información que corresponde a un mes cerrado no puede ser modificada. Por favor revise."; 

                CustomValidator1.IsValid = false;
                CustomValidator1.ErrorMessage = errorMessage;

                return;
            }

            int cantidadMovimientosDesdeBancos = 0;
            int cantidadMovimientosBancarios = 0;
            int cantidadMovimientosContables = 0;
            int cantidadMovimientosBancariosEncontrados = 0;
            int cantidadMovimientosContablesEncontrados = 0;

            // cargamos en una lista los movimientos bancarios a comparar ... 

            List<movimientoBanco> listaMovimientosBancos = new List<movimientoBanco>();

            listaMovimientosBancos = (from m in bancosContext.MovimientosBancarios
                                      where m.Fecha >= _conciliacion.Desde && m.Fecha <= _conciliacion.Hasta &&
                                            m.Chequera.CuentasBancaria.Cia == _conciliacion.CiaContab &&
                                            m.Chequera.CuentasBancaria.CuentaInterna == _conciliacion.CuentaBancaria
                                      orderby m.Fecha, m.Monto
                                      select new movimientoBanco { ID = m.ClaveUnica, MovimientoConciliacionID = null, Monto = m.Monto }).ToList();

            cantidadMovimientosBancarios = listaMovimientosBancos.Count(); 

            // ahora que cargamos los movimientos bancarios en una lista, recorresmos los movimientos obtenidos desde el banco 
            // y comparamos; para cada elemento encontrado actualizamos el item con la clave de movimiento del banco ... 


            var query = bancosContext.MovimientosDesdeBancos.Where(m => m.ConciliacionBancariaID == _conciliacion.ID).OrderBy(m => m.Fecha).ThenBy(m => m.Monto);
            movimientoBanco movBanco; 

            foreach (var m in query)
            {
                movBanco = listaMovimientosBancos.Where(mb => mb.Monto == m.Monto && mb.MovimientoConciliacionID == null).FirstOrDefault();

                if (movBanco != null)
                    // encontramos el movimiento bancario con el mismo monto; actualizamos el ID del movimiento desde el banco 
                    movBanco.MovimientoConciliacionID = m.ID;

                cantidadMovimientosDesdeBancos++; 
            }

            // hacemos exactamente lo mismo, pero con los movimientos contables ... 

            dbContab_Contab_Entities dbContab = new dbContab_Contab_Entities();

            List<movimientoContab> listaMovimientosContab = new List<movimientoContab>(); 

            listaMovimientosContab = (from m in contabContex.dAsientos
                                      where m.Asiento.Fecha >= _conciliacion.Desde && m.Asiento.Fecha <= _conciliacion.Hasta &&
                                            m.Asiento.Cia == _conciliacion.CiaContab &&
                                            m.CuentaContableID == _conciliacion.CuentaContable && 
                                            m.Asiento.Moneda == _conciliacion.CuentasBancaria.Moneda
                                      select new movimientoContab 
                                      { 
                                          AsientoID = m.NumeroAutomatico, 
                                          PartidaID = m.Partida, 
                                          MovimientoConciliacionID = null, 
                                          Monto = m.Debe - m.Haber }).
                                      ToList();

            cantidadMovimientosContables = listaMovimientosContab.Count(); 

            movimientoContab movContab; 

            foreach (var m in query)
            {
                movContab = listaMovimientosContab.Where(mc => mc.Monto == m.Monto && mc.MovimientoConciliacionID == null).FirstOrDefault();

                if (movContab != null)
                {
                    // encontramos el movimiento contable con el mismo monto; actualizamos el ID del movimiento desde el banco 
                    movContab.MovimientoConciliacionID = m.ID; 
                }
            }


            // Ok, ahora que tenemos los movimientos conciliados en las listas, las recorremos para actualizar la base de datos ... 

            // antes de actualizar las tablas MovimientosBancarios y dAsientos con los movimientos del banco encontrados, las 'limpiamos', pues pudieron 
            // ser actualizadas por este mismo proceso antes ... 

            object[] parametersMovimientosBancarios = { _conciliacion.Desde, _conciliacion.Hasta, _conciliacion.CuentaBancaria, _conciliacion.CiaContab }; 

            int cantidadMovBancRevertidos = 
            bancosContext.ExecuteStoreCommand("Update mb Set mb.ConciliacionMovimientoID = Null " +
                                              "From MovimientosBancarios mb Inner Join Chequeras ch On mb.ClaveUnicaChequera = ch.NumeroChequera " +
                                              "Inner Join CuentasBancarias cb On ch.NumeroCuenta = cb.CuentaInterna " +
                                              "Where mb.Fecha Between {0} And {1} And cb.CuentaInterna = {2} And cb.Cia = {3} " + 
                                              "And mb.ConciliacionMovimientoID Is Not Null", 
                                              parametersMovimientosBancarios);



            object[] parametersMovimientosContables = { _conciliacion.Desde, _conciliacion.Hasta, _conciliacion.CuentaContable, _conciliacion.CiaContab, _conciliacion.CuentasBancaria.Moneda }; 

            int cantidadMovContabRevertidos = 
            bancosContext.ExecuteStoreCommand("Update d Set d.ConciliacionMovimientoID = Null " + 
                                              "From dAsientos d Inner Join Asientos a On d.NumeroAutomatico = a.NumeroAutomatico " + 
                                              "Inner Join CuentasContables c On d.CuentaContableID = c.ID " +
                                              "Where a.Fecha Between {0} And {1} And c.ID = {2} And a.Cia = {3} And a.Moneda = {4} " + 
                                              "And d.ConciliacionMovimientoID Is Not Null", 
                                              parametersMovimientosContables);



            foreach (movimientoBanco m in listaMovimientosBancos.Where(m => m.MovimientoConciliacionID != null)) 
            {
                // actualizamos el movimiento bancario para crear la relación con el movimiento obtenido desde el banco 
                object[] parameters = { m.MovimientoConciliacionID, m.ID }; 
                bancosContext.ExecuteStoreCommand("Update MovimientosBancarios Set ConciliacionMovimientoID = {0} Where ClaveUnica = {1}", parameters);

                cantidadMovimientosBancariosEncontrados++; 
            } 

            foreach (movimientoContab m in listaMovimientosContab.Where(m => m.MovimientoConciliacionID != null)) 
            {
                // actualizamos el movimiento bancario para crear la relación con el movimiento obtenido desde el banco 
                object[] parameters = { m.MovimientoConciliacionID, m.AsientoID, m.PartidaID }; 
                bancosContext.ExecuteStoreCommand("Update dAsientos Set ConciliacionMovimientoID = {0} Where NumeroAutomatico = {1} And Partida = {2}", parameters);

                cantidadMovimientosContablesEncontrados++; 
            }


            this.MovimientosBanco_GridView.DataBind();
            this.MovimientosBancarios_GridView.DataBind();
            this.MovimientosContables_GridView.DataBind();

            this.ModalPopupTitle_span.InnerHtml = "... el proceso ha finalizado.";
            this.ModalPopupBody_span.InnerHtml = "<br /><b>Ok, el proceso de comparación de movimientos ha finalizado.</b><br /><br />" +
                "En total, fueron leídos: <br />" +
                cantidadMovimientosDesdeBancos.ToString() + " movimientos desde el banco; <br />" +
                cantidadMovimientosBancarios.ToString() + " movimientos bancarios (nuestros); <br />" +
                cantidadMovimientosContables.ToString() + " movimientos contables. <br /><br />" +
                "Además, de los anteriores: <br />" +
                cantidadMovimientosBancariosEncontrados.ToString() + " movimientos bancarios fueron encontrados; <br />" +
                cantidadMovimientosContablesEncontrados.ToString() + " movimientos contables fueron encontrados.<br /><br /><hr /><br />" +
                "Al comienzo de este proceso de actualizacióin, fueron revertidos: <br />" +
                cantidadMovBancRevertidos.ToString() + " movimientos bancarios, que habían sido actualizados antes con este proceso; <br />" +
                cantidadMovContabRevertidos.ToString() + " movimientos contables, que habían sido actualizados antes con este proceso. "; 

            this.ModalPopupExtender1.Show(); 
        }

        public string GetMovContableConciliado(MovimientosDesdeBanco item)
        {
            if (item.dAsientos.FirstOrDefault() != null)
                return item.dAsientos.FirstOrDefault().Asiento.Numero + "-" + item.dAsientos.FirstOrDefault().Partida.ToString();
            else
                return "";
        }

        public string GetMovBancarioConciliado(MovimientosDesdeBanco item)
        {
            if (item.MovimientosBancarios.FirstOrDefault() != null)
                return item.MovimientosBancarios.FirstOrDefault().Transaccion.ToString();
            else
                return "";
        }

        protected void MovimientosBanco_Filtro_DropDownList_SelectedIndexChanged(object sender, EventArgs e)
        {
            this.MovimientosBanco_GridView.DataBind(); 
        }

        protected void MovimientosBancarios_Filtro_DropDownList_SelectedIndexChanged(object sender, EventArgs e)
        {
            this.MovimientosBancarios_GridView.DataBind(); 
        }

        protected void MovimientosContables_Filtro_DropDownList_SelectedIndexChanged(object sender, EventArgs e)
        {
            this.MovimientosContables_GridView.DataBind(); 
        }

        protected void MovBanco_Report_LinkButton_PreRender(object sender, EventArgs e)
        {
            string URL = "";

            if (_conciliacion != null)
                URL = "~/ReportViewer3.aspx?rpt=repConcBancosMovBanco&concID=" + _conciliacion.ID.ToString() +
                      "&criterio=" + this.MovimientosBanco_Filtro_DropDownList.SelectedValue.ToString() +
                      "&d=" + _conciliacion.Desde.ToString("yyyy-MM-dd") +
                      "&h=" + _conciliacion.Hasta.ToString("yyyy-MM-dd"); 
            else
                URL = "~/ReportViewer3.aspx?rpt=repConcBancosMovBanco&concID=0&criterio=0"; 

            URL = Page.ResolveClientUrl(URL);

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.Append("window.open('" + URL);
            sb.Append("','");
            sb.Append("external2");
            sb.Append("','width=");
            sb.Append("1000");
            sb.Append(",height=");
            sb.Append("600");
            sb.Append(",toolbar=no,location=no, directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes");
            sb.Append("');");
            sb.Append(" return false;");

            MovBanco_Report_LinkButton.OnClientClick = sb.ToString();
        }

        protected void MovBancarios_Report_LinkButton_PreRender(object sender, EventArgs e)
        {
            string URL = "";

            if (_conciliacion != null)
                URL = "~/ReportViewer3.aspx?rpt=repConcBancosMovBancarios&concID=" + _conciliacion.ID.ToString() +
                      "&criterio=" + this.MovimientosBancarios_Filtro_DropDownList.SelectedValue.ToString() +
                      "&d=" + _conciliacion.Desde.ToString("yyyy-MM-dd") +
                      "&h=" + _conciliacion.Hasta.ToString("yyyy-MM-dd");
            else
                URL = "~/ReportViewer3.aspx?rpt=repConcBancosMovBancarios&concID=0&criterio=0";

            URL = Page.ResolveClientUrl(URL);

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.Append("window.open('" + URL);
            sb.Append("','");
            sb.Append("external2");
            sb.Append("','width=");
            sb.Append("1000");
            sb.Append(",height=");
            sb.Append("600");
            sb.Append(",toolbar=no,location=no, directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes");
            sb.Append("');");
            sb.Append(" return false;");

            MovBancarios_Report_LinkButton.OnClientClick = sb.ToString();
        }

        protected void MovContables_Report_LinkButton_PreRender(object sender, EventArgs e)
        {
            string URL = "";

            if (_conciliacion != null)
                URL = "~/ReportViewer3.aspx?rpt=repConcBancosMovContables&concID=" + _conciliacion.ID.ToString() +
                      "&criterio=" + this.MovimientosContables_Filtro_DropDownList.SelectedValue.ToString() +
                      "&d=" + _conciliacion.Desde.ToString("yyyy-MM-dd") +
                      "&h=" + _conciliacion.Hasta.ToString("yyyy-MM-dd");
            else
                URL = "~/ReportViewer3.aspx?rpt=repConcBancosMovContables&concID=0&criterio=0";

            URL = Page.ResolveClientUrl(URL);

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.Append("window.open('" + URL);
            sb.Append("','");
            sb.Append("external2");
            sb.Append("','width=");
            sb.Append("1000");
            sb.Append(",height=");
            sb.Append("600");
            sb.Append(",toolbar=no,location=no, directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes");
            sb.Append("');");
            sb.Append(" return false;");

            MovContables_Report_LinkButton.OnClientClick = sb.ToString();
        }
    }
}
