using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.Security;
using ContabSysNet_Web.ModelosDatos_EF.Contab;
using System.Data.Objects;
using System.Data.SqlClient;
using System.Data;
using ContabSysNet_Web.Clases;

namespace ContabSysNetWeb.Contab.Consultas_contables.BalanceGeneral
{
    public partial class BalanceGeneral : System.Web.UI.Page
    {
        private class InfoCuentaContable
        {
            public int ID { get; set; }
            public decimal SaldoAnterior { get; set; }
            public decimal MontoAntesDesde { get; set; } 
            public decimal Debe { get; set; }
            public decimal Haber { get; set; }
            public decimal SaldoActual { get; set; }
            public short CantidadMovimientos { get; set; }
        }

        private class CuentaContableItem
        {
            public string CuentaContable { get; set; }
            public string Descripcion { get; set; }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            Master.Page.Title = "Balance General y Ganancias y Pérdidas - Consulta";

            this.errorMessageDiv.InnerHtml = "";
            this.errorMessageDiv.Visible = false; 

            if (!Page.IsPostBack)
            {

                // Gets a reference to a Label control that is not in a ContentPlaceHolder control
                HtmlContainerControl MyHtmlSpan;

                MyHtmlSpan = (HtmlContainerControl)Master.FindControl("AppName_Span");
                if (!(MyHtmlSpan == null))
                {
                    MyHtmlSpan.InnerHtml = "Contab";
                }

                HtmlGenericControl MyHtmlH2;

                MyHtmlH2 = (HtmlGenericControl)Master.FindControl("PageTitle_TableCell");
                if (!(MyHtmlH2 == null))
                {
                    // sub título para la página
                    MyHtmlH2.InnerHtml = "Balance General y Ganancias y Pérdidas";
                }

                Session["BalanceGeneral_Parametros"] = null;
            }

            else
            {
                if (RebindFlagHiddenField.Value == "1")
                {

                    RebindFlagHiddenField.Value = "0";

                    string errorMessage = ""; 

                    CrearInfoReport(out errorMessage);

                    if (!string.IsNullOrEmpty(errorMessage))
                    {
                        this.errorMessageDiv.InnerHtml = errorMessage;
                        this.errorMessageDiv.Visible = true; 

                        return;
                    }
                }
            }
        }

        private void CrearInfoReport(out string errorMessage)
        {
            errorMessage = ""; 

            if (!User.Identity.IsAuthenticated)
            {
                FormsAuthentication.SignOut();
                return;
            }

            string usuario = User.Identity.Name;

            if (Session["BalanceGeneral_Parametros"] == null)
            {
                errorMessage = "Aparentemente, Ud. no ha definido un filtro para esta consulta. Por favor defina un filtro para esta consulta antes de continuar.";
                return;
            }

            BalanceGeneral_Parametros parametros = Session["BalanceGeneral_Parametros"] as BalanceGeneral_Parametros;

            // --------------------------------------------------------------------------------------------------------------------------------
            // determinamos si el mes que corresponde al inicio del período está cerrado; debe estarlo para que la información regresada por esta 
            // consulta sea confiable; de no ser así, indicamos pero permitimos continuar ... 

            // nótese como usamos un modelo de datos LinqToSql (no EF), pues el código en la clase AsientosContables lo usa así y fue 
            // escrito hace bastante tiempo ... 
            ContabSysNet_Web.ModelosDatos.dbContabDataContext contabLinqToSqlContex = new ContabSysNet_Web.ModelosDatos.dbContabDataContext();
            FuncionesContab funcionesContab = new FuncionesContab(parametros.CiaContab, parametros.Moneda, contabLinqToSqlContex);

            bool mesAnteriorCerradoEnContab = true;
            string popupMessage = ""; 

            if (funcionesContab.ValidarUltimoMesCerradoContab(parametros.Desde.AddMonths(-1), parametros.CiaContab, out errorMessage))
            {
                // NOTA: el mes *anterior* a la fecha de inicio DEBE estar cerrado (o uno posterior)
                // la función regresa False si el mes está cerrado
                // si la función regresa True es que NO está cerrado y eso no debe ocurrir en este contexto 
                popupMessage = "El mes anterior al mes indicado para esta consulta, <b>no</b> está cerrado. <br /> " +
                               "Aunque Ud. puede continuar e intentar obtener esta consulta, las cifras determinadas y " + 
                               "mostradas no serán del todo confiables.<br /><br />" +
                               "Aún así, desea continuar con la ejecución de esta consulta?";

                mesAnteriorCerradoEnContab = false; 
            }

            dbContab_Contab_Entities dbContab = new dbContab_Contab_Entities();
            ParametrosContab parametrosContab = dbContab.ParametrosContabs.Where(p => p.Cia == parametros.CiaContab).FirstOrDefault();

            if (parametrosContab == null)
            {
                errorMessage = "Aparentemente, la tabla de parámetros (Contab) no ha sido inicializada. " +
                               "Por favor inicialize esta tabla con los valores que sean adecuados, para la Cia Contab seleccionada para esta consulta.";

                return;
            }

            // ----------------------------------------------------------------------------------------------------------------------------
            // construimos el filtro de las cuentas contables, en base al contenido de la tabla ParametrosContab; en esta tabla el usuario indica 
            // cuales cuentas contables corresponden a: activo, pasivo, capital, etc. Para BG, solo cuentas reales son leídas; para GyP solo cuentas 
            // nominales son leídas ... 
            string filtroBalGen_GyP = "";

            ConstruirFiltroBalGenGyP(parametros, parametrosContab, dbContab, out filtroBalGen_GyP);

            string filtroConsulta = parametros.Filtro + filtroBalGen_GyP;

            // ----------------------------------------------------------------------------------------------------------------------------
            // hacemos una validación: intentamos encontrar cuentas contables de tipo detalle, que tengan movimientos en el período indicado, pero que no tengan 
            // un registro de saldos; estos casos pueden ocurrir para cuentas contables recién agregadas, a la cuales se le han agregado asientos pero que aún 
            // no se ha ejecutado un cierre mensual que agregue un registro de saldos para éstas. Notificamos esta situación al usuario para que ejecute un 
            // cierre mensual que agregue un registro de saldos para estas cuentas ... 

            DateTime fecha1erDiaMes = new DateTime(parametros.Desde.Year, parametros.Desde.Month, 1);

            // nótese como no aplicamos el filtro específico a esta consulta, pues resulta complicado. Sin embargo, al no hacerlo, validamos 
            // esta situación para todas las cuentas de la compañía, en vez de solo para las que cumplen el filtro ... 
            string commandString = "Select c.Cuenta As CuentaContable, c.Descripcion " +
                                   "From CuentasContables c Inner Join dAsientos d On c.ID = d.CuentaContableID " +
                                   "Inner Join Asientos a On d.NumeroAutomatico = a.NumeroAutomatico " +
                                   "Where c.Cia = {2} And c.TotDet = 'D' And " +
                                   "a.Fecha Between {0} And {1} " +
                                   "And c.ID Not In (Select s.CuentaContableID From SaldosContables s Where " +
                                   "s.Cia = {2})";

            CuentaContableItem cuentasTipoDetalleSinRegistroDeSaldos = dbContab.ExecuteStoreQuery<CuentaContableItem>(commandString,
                                                                                                                      fecha1erDiaMes.ToString("yyyy-MM-dd"),
                                                                                                                      parametros.Hasta.ToString("yyyy-MM-dd"), 
                                                                                                                      parametros.CiaContab).
                                                                                                                      FirstOrDefault();

            if (cuentasTipoDetalleSinRegistroDeSaldos != null)
            {
                errorMessage = "Hemos encontrado que existen cuentas contables, por ejemplo <b><en>" +
                    (cuentasTipoDetalleSinRegistroDeSaldos.CuentaContable != null ? cuentasTipoDetalleSinRegistroDeSaldos.CuentaContable.Trim() : 
                     "'cuenta contable sin número asignado - número en blanco'") + 
                    " - " +
                    (cuentasTipoDetalleSinRegistroDeSaldos.Descripcion != null ? cuentasTipoDetalleSinRegistroDeSaldos.Descripcion.Trim() :
                     "'cuenta contable sin descripción asignada - descripción en blanco'") + 
                    "</en></b>, con asientos registrados en el período indicado, pero sin un registro de saldos contables." +
                    "Lo más probable es que estas cuentas sean nuevas y hayan recibido asientos; sin embargo, como el cierre contable (mensual) " + 
                    "no se ha corrido, su registro de saldos contables no ha sido creado aún. " +
                    "Por favor ejecute un cierre contable para el mes de la consulta para que se corrija esta situación.";

                return;
            }

            // ----------------------------------------------------------------------------------------------------------------------------
            // por último, determinamos si existen cuentas contables de tipo total y que tengan movimientos contables asociados para el período indicado. 
            // esta situación puede ocurrir si el usuario cambia el tipo de una cuenta de detalle a total, para una cuenta que tenga asientos (el registro de 
            // cuentas no debe permitir este cambio!). Notificamos esta situación al usuario y detenemos la ejecución del proceso ... 

            // nótese como buscamos aquí sin usar el filtro que aplica a esta consulta; esto nos permite reportar esta situación tan grave, 
            // independientemente del filtro que haya indicado el usuario ... 
            commandString = "Select c.Cuenta As CuentaContable, c.Descripcion " +
                            "From CuentasContables c Inner Join dAsientos d On c.ID = d.CuentaContableID " + 
                            "Inner Join Asientos a On d.NumeroAutomatico = a.NumeroAutomatico " + 
                            "Where c.Cia = {0} And c.TotDet = 'T' And a.Fecha Between {1} And {2}"; 

            CuentaContableItem cuentasTipoTotalConMovimientos = dbContab.ExecuteStoreQuery<CuentaContableItem>(commandString, 
                                                                                                               parametros.CiaContab, 
                                                                                                               fecha1erDiaMes.ToString("yyyy-MM-dd"), 
                                                                                                               parametros.Hasta.ToString("yyyy-MM-dd")).
                                                                                                               FirstOrDefault();

            if (cuentasTipoTotalConMovimientos != null)
            {
                errorMessage = "Hemos encontrado que existen cuentas contables de tipo total, por ejemplo '<b><en>" +
                                (cuentasTipoTotalConMovimientos.CuentaContable != null ? cuentasTipoTotalConMovimientos.CuentaContable.Trim() :
                                 "'cuenta contable sin número asignado - número en blanco'") +
                                " - " +
                                (cuentasTipoTotalConMovimientos.Descripcion != null ? cuentasTipoTotalConMovimientos.Descripcion.Trim() :
                                 "'cuenta contable sin descripción asignada - descripción en blanco'") + 
                                "</en></b>', con asientos registrados en el período indicado. " +
                                "Una cuenta contable de tipo total no puede recibir asientos contables. " +
                                "Por favor revise y corrija esta situación. Luego regrese a continuar con este proceso.";

                return;
            }

            if (!mesAnteriorCerradoEnContab)
            {
                // arriba, se determinó que el mes anterior al mes indicado no esta cerrado en Contab; de ser así, esta consulta no podrá determinar 
                // lo saldos iniciales del período (saldos finales del mes anterior) de una manera confiable; sin embargo, notificamos al usaurio y 
                // permitimos continuar (o no!) ... 

                // nótese que si el usuario decide continuar, el metodo btnOk_Click es ejecutado; si el usuario cancela, simplemente la ejecución del 
                // proceso es detenida en el cliente (browser) ... 

                this.ModalPopupTitle_span.InnerHtml = "El mes contable que corresponde a los saldos iniciales del período indicado no está cerrado";
                this.ModalPopupBody_span.InnerHtml = popupMessage;

                this.btnOk.Visible = true;
                this.btnCancel.Text = "Cancelar";

                this.ModalPopupExtender1.Show();

                return;
            }

            // las validaciones pasaron; ejecutamos la función que prepara y la consulta ... 
            ConstruirConsulta(out errorMessage); 
        }

        protected void btnOk_Click(object sender, EventArgs e)
        {
            // alguna validación falló (por ejemplo el mes cerrado) *pero* el usuario decide continuar .... 
            string errorMessage; 
            ConstruirConsulta(out errorMessage);

            if (!string.IsNullOrEmpty(errorMessage))
            {
                this.errorMessageDiv.InnerHtml = errorMessage;
                this.errorMessageDiv.Visible = true;

                return;
            }
        }

        private void ConstruirConsulta(out string errorMessage)
        {
            errorMessage = ""; 

            if (!User.Identity.IsAuthenticated)
            {
                FormsAuthentication.SignOut();
                return;
            }

            string usuario = User.Identity.Name; 

            if (Session["BalanceGeneral_Parametros"] == null)
            {
                errorMessage = "Aparentemente, Ud. no ha definido un filtro para esta consulta. Por favor defina un filtro para esta consulta antes de continuar.";
                return;
            }

            BalanceGeneral_Parametros parametros = Session["BalanceGeneral_Parametros"] as BalanceGeneral_Parametros;

            dbContab_Contab_Entities dbContab = new dbContab_Contab_Entities();

            // leemos la tabla de parámetros para omitir del query las cuentas que no correspondan, dependiendo del tipo de reporte (BG / GyP) 
            // nótese que la clase ParametrosContab existe en varios name spaces 
            ContabSysNet_Web.ModelosDatos_EF.Contab.ParametrosContab parametrosContab = dbContab.ParametrosContabs.Where(p => p.Cia == parametros.CiaContab).FirstOrDefault();

            if (parametrosContab == null)
            {
                errorMessage = "Aparentemente, la tabla de parámetros (Contab) no ha sido inicializada. " + 
                               "Por favor inicialize esta tabla con los valores que sean adecuados, para la Cia Contab seleccionada para esta consulta.";

                return;
            }

            // ahora modificamos el filtro para incluir/excluir las cuentas del tipo GyP ... 
            string filtroBalGen_GyP = ""; 

            ConstruirFiltroBalGenGyP(parametros, parametrosContab, dbContab, out filtroBalGen_GyP);

            string filtroConsulta = parametros.Filtro + filtroBalGen_GyP;

            // obtenemos el mes y año fiscal que corresponde al mes de la consulta; la función que determina el saldo anterior para cada cuenta contable, 
            // en realidad lee el saldo para el mes fiscal *anterior* al de la consulta; una consulta para Marzo, necesita como saldos anteriores los del mes Febrero ... 
            var fecha_sqlParam = new SqlParameter("@fecha", parametros.Desde);
            var ciaContab_sqlParam = new SqlParameter("@ciaContab", parametros.CiaContab);
            var mesFiscal_sqlParam = new SqlParameter("@mesFiscal", System.Data.SqlDbType.SmallInt);
            var anoFiscal_sqlParam = new SqlParameter("@anoFiscal", System.Data.SqlDbType.SmallInt);
            var nombreMes_sqlParam = new SqlParameter("@nombreMes", System.Data.SqlDbType.NVarChar, 50);
            var errorMessage_sqlParam = new SqlParameter("@errorMessage", System.Data.SqlDbType.NVarChar, 500);

            mesFiscal_sqlParam.Direction = ParameterDirection.Output;
            anoFiscal_sqlParam.Direction = ParameterDirection.Output;
            nombreMes_sqlParam.Direction = ParameterDirection.Output;
            errorMessage_sqlParam.Direction = ParameterDirection.Output;

            var contabDbContext = new ContabSysNet_Web.ModelosDatos_EF.code_first.contab.ContabContext();
            var result = contabDbContext.Database.SqlQuery<int?>("dbo.spDeterminarMesFiscal @fecha, @ciaContab, @mesFiscal OUT, @anoFiscal OUT, @nombreMes OUT, @errorMessage OUT",
                                                                  fecha_sqlParam, ciaContab_sqlParam, mesFiscal_sqlParam, anoFiscal_sqlParam, nombreMes_sqlParam, errorMessage_sqlParam)
                                                                  .FirstOrDefault();

            if (!string.IsNullOrEmpty(errorMessage_sqlParam.Value.ToString()))
            {
                string functionErrorMessage = errorMessage_sqlParam.Value.ToString();
                errorMessage = "Hemos obtenido un error, al intentar obtener obtener el mes y año fiscal para la fecha indicada como criterio de ejecución.<br /> " +
                               "A continuación, mostramos el mensaje específico de error:<br /> " + functionErrorMessage;
                return;
            }

            short mesFiscal = Convert.ToInt16(mesFiscal_sqlParam.Value);
            short anoFiscal = Convert.ToInt16(anoFiscal_sqlParam.Value);
            string nombreMes = (nombreMes_sqlParam.Value).ToString(); 

            // refinar el filtro para, por ejemplo, GyP: leer solo gastos/ingresos; BG: no leer gastos/ingresos (depende de opción, etc.) 
            // antes eliminamos los registros que puedan existir 
            int cantRegistrosEliminados = dbContab.ExecuteStoreCommand("Delete From Temp_Contab_Report_BalanceGeneral Where Usuario = {0}", usuario);

            // nótese como leemos *solo* cuentas contables que tengan registros de saldo contable agregado ... 
            var query = dbContab.CuentasContables.Where(filtroConsulta).Where(c => c.TotDet == "D").Where(c => c.SaldosContables.Any()).Select(c => c.ID);

            // ----------------------------------------------------------------------------------------------------------------------
            // leemos la tabla de monedas para 'saber' cual es la moneda Bs. Nota: la idea es aplicar las opciones de reconversión 
            // *solo* a esta moneda 
            var monedaNacional_return = Reconversion.Get_MonedaNacional();

            if (monedaNacional_return.error)
            {
                errorMessage = monedaNacional_return.message; ;
                return;
            }

            ContabSysNet_Web.ModelosDatos_EF.code_first.contab.Monedas monedaNacional = monedaNacional_return.moneda;

            // ponemos la moneda nacional en un session pues la usa el popup que muestra los movimientos; así no la tiene que leer cada vez 
            Session["monedaNacional"] = monedaNacional.Moneda;
            // ----------------------------------------------------------------------------------------------------------------------

            int cuentasContablesAgregadas = 0;

            foreach (int cuentaContableID in query)
            {
                // nótese como obtenemos el mes fiscal para el mes *anterior* al mes de inicio del período; la idea es obtener (luego) los saldos del mes 
                // *anterior* al inicio del período; por ejemplo: si el usuario intenta obtener la consulta para Abril, debemos obtener los saldos para 
                // Marzo, que serán los iniciales para Abril .... 

                var cuentaContableID_sqlParam = new SqlParameter("@cuentaContableID", cuentaContableID);
                var mesFiscal2_sqlParam = new SqlParameter("@mesFiscal", mesFiscal);
                var anoFiscal2_sqlParam = new SqlParameter("@anoFiscal", anoFiscal);
                var desde_sqlParam = new SqlParameter("@desde", parametros.Desde);
                var hasta_sqlParam = new SqlParameter("@hasta", parametros.Hasta);
                var moneda_sqlParam = new SqlParameter("@moneda", parametros.Moneda);
                var monedaNacional_sqlParam = new SqlParameter("@monedaNacional", monedaNacional.Moneda);

                var monedaOriginal_sqlParam = new SqlParameter("@monedaOriginal", System.Data.SqlDbType.Int);

                // el valor de este parámetro puede ser null 
                if (parametros.MonedaOriginal == null)
                    monedaOriginal_sqlParam.Value = DBNull.Value;
                else
                    monedaOriginal_sqlParam.Value = parametros.MonedaOriginal;

                var nombreUsuario_sqlParam = new SqlParameter("@nombreUsuario", usuario);

                var excluirCuentasSaldoYMovtosCero_sqlParam = new SqlParameter("@excluirSaldoInicialDebeHaberCero", parametros.ExcluirCuentasSaldoYMovtosCero);
                var excluirCuentasSaldosFinalCero_sqlParam = new SqlParameter("@excluirSaldoFinalCero", parametros.ExcluirCuentasSaldosFinalCero);
                var excluirCuentasSinMovimientos_sqlParam = new SqlParameter("@excluirSinMovimientosPeriodo", parametros.ExcluirCuentasSinMovimientos);
                var excluirAsientosContablesTipoCierreAnual_sqlParam = new SqlParameter("@excluirAsientoTipoCierreAnual", parametros.ExcluirAsientosContablesTipoCierreAnual);
                var reconvertirCifrasAntes_01Oct2021_sqlParam = new SqlParameter("@reconvertirCifrasAntes_01Oct2021", parametros.reconvertirCifrasAntes_01Oct2021);
                var errorMessage2_sqlParam = new SqlParameter("@errorMessage", "");

                errorMessage2_sqlParam.Direction = ParameterDirection.Output;

                var resultadoFuncion = contabDbContext.Database.SqlQuery<int?>("dbo.spBalanceGeneral " +
                                                                             "@cuentaContableID, @mesFiscal, @anoFiscal, @desde, @hasta, " +
                                                                             "@moneda, @MonedaNacional, @monedaOriginal, @nombreUsuario, @excluirSaldoInicialDebeHaberCero, " +
                                                                             "@excluirSaldoFinalCero, @excluirSinMovimientosPeriodo, @excluirAsientoTipoCierreAnual, " +
                                                                             "@reconvertirCifrasAntes_01Oct2021, @errorMessage OUT",
                                                                             cuentaContableID_sqlParam, mesFiscal2_sqlParam, anoFiscal2_sqlParam, desde_sqlParam, hasta_sqlParam, 
                                                                             moneda_sqlParam, monedaNacional_sqlParam, monedaOriginal_sqlParam, nombreUsuario_sqlParam, 
                                                                             excluirCuentasSaldoYMovtosCero_sqlParam, excluirCuentasSaldosFinalCero_sqlParam, 
                                                                             excluirCuentasSinMovimientos_sqlParam, excluirAsientosContablesTipoCierreAnual_sqlParam,
                                                                             reconvertirCifrasAntes_01Oct2021_sqlParam, errorMessage2_sqlParam)
                                                                             .FirstOrDefault();

                if (!string.IsNullOrEmpty(errorMessage_sqlParam.Value.ToString()))
                {
                    errorMessage = errorMessage_sqlParam.Value.ToString();
                    return;
                }

                // la función regresa la cantidad de registros agregadados (1 o 0) ... 
                if (resultadoFuncion != null && resultadoFuncion.Value == 1) 
                    cuentasContablesAgregadas++;
            }

            string ajaxPopUpMessage = "";

            ajaxPopUpMessage = "<br /><b>Ok, el proceso de lectura de cuentas, movimientos y saldos contables ha finalizado.</b><br /><br />" +
                               "En total, fueron leídos (y registrados en la base de datos): <br /><br />" +
                               "*) " + cuentasContablesAgregadas.ToString() + " cuentas contables, sus saldos del mes anterior y movimiento en el período. <br />";

            this.ModalPopupTitle_span.InnerHtml = "... Ok, el proceso ha finalizado.";
            this.ModalPopupBody_span.InnerHtml = ajaxPopUpMessage; 

            this.btnOk.Visible = false;
            this.btnCancel.Text = "Ok"; 

            this.ModalPopupExtender1.Show();

            this.MonedasFilter_DropDownList.DataBind();
            this.CompaniasFilter_DropDownList.DataBind(); 

            this.BalanceGeneral_GridView.DataBind();

            // para mostrar la cantidad de registros seleccionados 
            this.selectedRecs_p.InnerHtml = $"{cuentasContablesAgregadas.ToString()} registros seleccionados ..."; 
            this.selectedRecs_div.Style["display"] = "block";
        }

        private void ConstruirFiltroBalGenGyP(BalanceGeneral_Parametros parametros,
            ParametrosContab parametrosContab,
            dbContab_Contab_Entities dbContab,
            out string filtroConsulta)
        {
            // en esta función leemos usamos el contenido de la tabla ParametrosContab para determinar y seleccionar solo las cuentas 
            // contables del grupo que corresponde, de acuerdo al tipo de consulta indicada. Por ejemplo: 
            // si el usuario quiere GyP, debemos excluir activos, pasivos y capital; justo a la inversa para Balance General 
            filtroConsulta = "";

            if (parametros.BalGen_GyP == "BG")
            {
                if (parametrosContab.Ingresos1 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Ingresos1).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Ingresos2 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Ingresos2).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Ingresos3 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Ingresos3).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Ingresos4 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Ingresos4).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Ingresos5 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Ingresos5).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Ingresos6 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Ingresos6).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Egresos1 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Egresos1).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Egresos2 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Egresos2).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Egresos3 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Egresos3).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Egresos4 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Egresos4).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Egresos5 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Egresos5).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Egresos6 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Egresos6).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }
            }
            else
            {
                // para GyP siempre excluimos cuentas reales (activo, pasivo, capital) 
                if (parametrosContab.Activo1 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Activo1).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Activo2 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Activo2).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Activo3 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Activo3).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Activo4 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Activo4).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Activo5 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Activo5).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Activo6 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Activo6).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Pasivo1 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Pasivo1).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Pasivo2 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Pasivo2).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Pasivo3 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Pasivo3).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Pasivo4 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Pasivo4).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Pasivo5 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Pasivo5).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Pasivo6 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Pasivo6).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Capital1 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Capital1).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Capital2 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Capital2).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Capital3 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Capital3).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Capital4 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Capital4).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Capital5 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Capital5).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }

                if (parametrosContab.Capital6 != null)
                {
                    string cuenta = dbContab.CuentasContables.Where(c => c.ID == parametrosContab.Capital6).Select(c => c.Cuenta).FirstOrDefault();
                    if (cuenta != "")
                        filtroConsulta += " And (it.Cuenta Not Like '" + cuenta + "%')";
                }
            }

            if (filtroConsulta == "")
                filtroConsulta = " And (1 == 1)";
        }

        public IQueryable<ContabSysNet_Web.ModelosDatos_EF.Contab.Temp_Contab_Report_BalanceGeneral> BalanceGeneral_GridView_GetData()
        {
            if (!User.Identity.IsAuthenticated)
            {
                FormsAuthentication.SignOut();
                return null;
            }

            string usuario = User.Identity.Name;

            dbContab_Contab_Entities dbContab = new dbContab_Contab_Entities();

            var query = dbContab.Temp_Contab_Report_BalanceGeneral.Include("CuentasContable").Where(c => c.Usuario == usuario);

            if (this.CompaniasFilter_DropDownList.SelectedIndex != -1)
            {
                int selectedValue = Convert.ToInt32(this.CompaniasFilter_DropDownList.SelectedValue);
                query = query.Where(d => d.CuentasContable.Cia == selectedValue);
            }

            if (this.MonedasFilter_DropDownList.SelectedIndex != -1)
            {
                int selectedValue = Convert.ToInt32(this.MonedasFilter_DropDownList.SelectedValue);
                query = query.Where(d => d.Moneda == selectedValue);
            }

            if (!string.IsNullOrEmpty(this.CuentaContableFilter_TextBox.Text))
            {
                string miniFilter = this.CuentaContableFilter_TextBox.Text.ToString().Replace("*", "");

                // nótese como el usuario puede o no usar '*' para el mini filtro; de usarlo, la busqueda es más precisa ... 
                if (this.CuentaContableFilter_TextBox.Text.ToString().Trim().StartsWith("*") && this.CuentaContableFilter_TextBox.Text.Trim().EndsWith("*"))
                    query = query.Where(c => c.CuentasContable.Cuenta.Contains(miniFilter));
                else if (this.CuentaContableFilter_TextBox.Text.ToString().Trim().StartsWith("*"))
                    query = query.Where(c => c.CuentasContable.Cuenta.EndsWith(miniFilter));
                else if (this.CuentaContableFilter_TextBox.Text.Trim().EndsWith("*"))
                    query = query.Where(c => c.CuentasContable.Cuenta.StartsWith(miniFilter));
                else
                    query = query.Where(c => c.CuentasContable.Cuenta.Contains(miniFilter));
            }

            if (!string.IsNullOrEmpty(this.CuentaContableDescripcionFilter_TextBox.Text))
            {
                string miniFilter = this.CuentaContableDescripcionFilter_TextBox.Text.ToString().Replace("*", "");

                // nótese como el usuario puede o no usar '*' para el mini filtro; de usarlo, la busqueda es más precisa ... 
                if (this.CuentaContableDescripcionFilter_TextBox.Text.ToString().Trim().StartsWith("*") && this.CuentaContableDescripcionFilter_TextBox.Text.Trim().EndsWith("*"))
                    query = query.Where(c => c.CuentasContable.Descripcion.Contains(miniFilter));
                else if (this.CuentaContableDescripcionFilter_TextBox.Text.ToString().Trim().StartsWith("*"))
                    query = query.Where(c => c.CuentasContable.Descripcion.EndsWith(miniFilter));
                else if (this.CuentaContableDescripcionFilter_TextBox.Text.Trim().EndsWith("*"))
                    query = query.Where(c => c.CuentasContable.Descripcion.StartsWith(miniFilter));
                else
                    query = query.Where(c => c.CuentasContable.Descripcion.Contains(miniFilter));
            }

            if (query.Count() == 0)
            {
                string errorMessage = "No se han seleccionado registros que mostrar; probablemente, el filtro indicado a esta consulta " +
                    "no está correctamente establecido o, de estarlo, no selecciona registros para ser mostrados en la lista.";

                CustomValidator1.IsValid = false;
                CustomValidator1.ErrorMessage = errorMessage;

                return null;
            }

            query = query.OrderBy(c => c.CuentasContable.CuentaEditada);

            return query;
        }

        protected void BalanceGeneral_GridView_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void BalanceGeneral_GridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridView gv = (GridView)sender;
            gv.SelectedIndex = -1; 
        }

        public string GetDireccionWindowCuentasContables(int cuentaContableID, int moneda, int ciaContab)
        {
            string window = "";

            window = "javascript:PopupWin('../BalanceComprobacion/BalanceComprobacion_MovimientosContables.aspx?cta=" + cuentaContableID.ToString() +
                "&mon=" + moneda.ToString() +
                "&cia=" + ciaContab.ToString() + 
                "', 1000, 680)"; 

            return window; 
        }

        public IQueryable<Compania> CompaniasFilter_DropDownList_SelectMethod()
        {
            if (!User.Identity.IsAuthenticated)
            {
                FormsAuthentication.SignOut();
                return null;
            }

            string usuario = User.Identity.Name;

            dbContab_Contab_Entities context = new dbContab_Contab_Entities();

            // nótese como usamos un subquery ... 

            var query1 = context.Temp_Contab_Report_BalanceGeneral.Where(c => c.Usuario == usuario).Select(c => c.CuentasContable.Cia); 
            var query2 = from c in context.Companias where query1.Contains(c.Numero) select c;
            query2 = query2.OrderBy(c => c.Nombre);

            return query2;
        }

        public IQueryable<Moneda> MonedasFilter_DropDownList_SelectMethod()
        {
            if (!User.Identity.IsAuthenticated)
            {
                FormsAuthentication.SignOut();
                return null;
            }

            string usuario = User.Identity.Name;

            dbContab_Contab_Entities context = new dbContab_Contab_Entities();

            // aquí no necesitamos un subquery 

            var query = context.Monedas.Where(m => m.Temp_Contab_Report_BalanceGeneral.Where(bg => bg.Usuario == usuario).Any()).Select(m => m);
            query = query.OrderBy(m => m.Descripcion);

            return query;
        }

        protected void AplicarMiniFiltro(object sender, EventArgs e)
        {
            this.BalanceGeneral_GridView.PageIndex = 0;
            this.BalanceGeneral_GridView.SelectedIndex = -1;
            this.BalanceGeneral_GridView.DataBind();
        }
    }
}