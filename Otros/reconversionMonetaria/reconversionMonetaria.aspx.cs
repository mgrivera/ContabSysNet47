using ContabSysNet_Web.ModelosDatos_EF.Contab;
using ContabSysNet_Web.ModelosDatos_EF.Users;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace ContabSysNet_Web.Otros.reconversionMonetaria
{
    public partial class reconversionMonetaria : System.Web.UI.Page
    {
        // para mantener un registro de los parámetros de ejecución del proceso 
        private class parametrosProc
        {
            public short ano { get; set; }
            public int moneda { get; set; }
            public short cantidadDigitos { get; set; }
            public int divisor { get; set; }
            public int cuentaContableID { get; set; }
            public int ciaContabSeleccionada { get; set; }
        }

        private class asiento_sumarizacion
        {
            public int numeroAutomatico { get; set; }
            public decimal sumOfDebe { get; set; }
            public decimal sumOfHaber { get; set; }
            public decimal diferencia { get; set; }
            public short ultimaPartida { get; set; }
        }

        private class saldos_sumarizacion
        {
            public int moneda { get; set; }
            public int monedaOriginal { get; set; }
            public short ano { get; set; }
            public int cia { get; set; }
            public decimal sumOfInicial { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            Master.Page.Title = "contab - Reconversión";

            // TODO: porqué hay dos espacios para mostrar mensajes de error???? 
            this.ErrMessage_Span.InnerHtml = "";
            this.ErrMessage_Span.Visible = false;

            this.errorMessageDiv.Visible = false;
            this.InfoMessage_Span.Visible = false;

            if (!User.Identity.IsAuthenticated)
            {
                FormsAuthentication.SignOut();
                return;
            }

            if (!Page.IsPostBack)
            {
                // Gets a reference to a Label control that is not in a
                // ContentPlaceHolder control

                HtmlContainerControl MyHtmlSpan;

                MyHtmlSpan = (HtmlContainerControl)Master.FindControl("AppName_Span");
                if (!(MyHtmlSpan == null))
                {
                    MyHtmlSpan.InnerHtml = "Reconversión monetaria";
                }

                HtmlGenericControl MyHtmlH2;

                MyHtmlH2 = (HtmlGenericControl)Master.FindControl("PageTitle_TableCell");
                if (!(MyHtmlH2 == null))
                {
                    // sub título para la página
                    MyHtmlH2.InnerHtml = "Reconversión monetaria";
                }

                Session["reconversionMonetaria.cantidadDigitos"] = null;
                Session["reconversionMonetaria.ano"] = null;

                // intentamos leer la compañía seleccionada 
                int ciaContabSeleccionada;
                string nombreCiaContabSeleccionada;

                using (dbContab_Contab_Entities context = new dbContab_Contab_Entities())
                {
                    try
                    {
                        var cia = context.tCiaSeleccionadas.Where(s => s.UsuarioLS == User.Identity.Name).
                                                            Select(c => new { ciaContabSeleccionada = c.Compania.Numero, ciaContabSeleccionadaNombre = c.Compania.Nombre }).
                                                            FirstOrDefault();

                        if (cia == null)
                        {
                            string errorMessage = "Error: aparentemente, no se ha seleccionado una <em>Cia Contab</em>.<br />" +
                                                  "Por favor seleccione una <em>Cia Contab</em> y luego regrese y continúe con la ejecución de esta función.";

                            this.ErrMessage_Span.InnerHtml = errorMessage;
                            this.ErrMessage_Span.Visible = true;

                            return;
                        }

                        nombreCiaContabSeleccionada = cia.ciaContabSeleccionadaNombre;
                        ciaContabSeleccionada = cia.ciaContabSeleccionada;

                        this.companiaSeleccionada_label.Text = nombreCiaContabSeleccionada;
                    }
                    catch (Exception ex)
                    {
                        string message = ex.Message;
                        if (ex.InnerException != null)
                            message += "<br />" + ex.InnerException.Message;

                        string errorMessage = "Error: se ha producido un error al intentar efectuar una operación en la base de datos.<br />" +
                                                "El mensaje específico de error es: <br />" + message;

                        this.ErrMessage_Span.InnerHtml = errorMessage;
                        this.ErrMessage_Span.Visible = true;
                    }
                }

                this.texto1.Visible = false;
            }
            else
            {
                // -------------------------------------------------------------------------
                // la página puede ser 'refrescada' por el popup; en ese caso, ejeucutamos
                // una función que efectúa alguna funcionalidad y rebind la información

                if (RebindFlagHiddenField.Value == "1")
                {
                    RefreshAndBindInfo();
                    RebindFlagHiddenField.Value = "0";
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

            if (Session["reconversionMonetaria.cantidadDigitos"] == null || 
                Session["reconversionMonetaria.ano"] == null || 
                Session["reconversionMonetaria.cuentaContableID"] == null)
            {
                string errorMessage = "Aparentemente, Ud. no ha indicado un filtro (parámetros de ejecución) aún; o lo ha indicado de manera <em>incompleta</em>.<br />" +
                    "Ud. debe abrir la página que muestra el filtro e indicar valores para todos los parámetros de ejecución de este proceso.";

                this.ErrMessage_Span.InnerHtml = errorMessage;
                this.ErrMessage_Span.Visible = true;

                return;
            }

            dbContab_Contab_Entities context = new dbContab_Contab_Entities();

            // leemos la cuenta contable indicada por el usuaio
            int cuentaContableID = Convert.ToInt32(Session["reconversionMonetaria.cuentaContableID"]);
            CuentasContable cuentaContable = context.CuentasContables.Where(c => c.ID == cuentaContableID).FirstOrDefault();

            if (cuentaContable == null)
            {
                string errorMessage = "Error: no hemos podido leer la cuenta contable indicada en el filtro.</em>.<br />" +
                                      "Por favor revise. La cuenta contable indicada debe existir en la tabla de cuentas contables.";

                this.ErrMessage_Span.InnerHtml = errorMessage;
                this.ErrMessage_Span.Visible = true;

                return;
            }

            // debe existir una moneda 'nacional'; solo para ésta haremos la reconversión ... 
            var monedaNacional_array = context.Monedas.Where(m => m.NacionalFlag);

            if (monedaNacional_array == null)
            {
                string errorMessage = "Error: aparentemente, no se ha definido una de las monedas como <em>nacional</em>.<br />" +
                                      "Ud. debe revisar la tabla de monedas y asegurarse que una de ellas sea definida como <em>nacional</em>.";

                this.ErrMessage_Span.InnerHtml = errorMessage;
                this.ErrMessage_Span.Visible = true;

                return;
            }

            if (monedaNacional_array.Count() > 1)
            {
                string errorMessage = "Error: aparentemente, más de una moneda ha sido definida del tipo <em>nacional</em>.<br />" +
                                      "Ud. debe revisar la tabla de monedas y asegurarse que <b>solo una de ellas</b> sea definida como <em>nacional</em>.";

                this.ErrMessage_Span.InnerHtml = errorMessage;
                this.ErrMessage_Span.Visible = true;

                return;
            }

            Moneda monedaNacional = monedaNacional_array.First();

            var cia = context.tCiaSeleccionadas.Where(s => s.UsuarioLS == User.Identity.Name).
                                                            Select(c => new { ciaContabSeleccionada = c.Compania.Numero }).
                                                            FirstOrDefault();

            short ano = Convert.ToInt16(Session["reconversionMonetaria.ano"]);

            // leemos los asientos del año, para asegurarnos que no hay asientos descuadrados ... 
            string sSqlQueryString =
                "SELECT Count(*) As partidas " +
                "FROM dAsientos d Inner Join Asientos a On d.NumeroAutomatico = a.NumeroAutomatico " +
                "Where a.AnoFiscal = {0} And a.Moneda = {1} And a.Cia = {2} " +
                "Group By d.NumeroAutomatico " +
                "Having Sum(d.Debe) <> Sum(d.Haber)";

            List<int> asientosDescuadrados = context.ExecuteStoreQuery<int>(sSqlQueryString, ano, monedaNacional.Moneda1, cia.ciaContabSeleccionada).ToList();

            if (asientosDescuadrados.Count() > 0)
            {
                // nota: esta situación no aborta el proceso, pues debe ser el resultado del 1er. paso de la reconversión ... 
                string errorMessage = "Advertencia: existen asientos descuadrados para el año a reconvertir.<br />" +
                                      "Ud. debe continuar con el próximo paso y ajustarlos, <b>solo</b> si estos asientos son producto del 1er. paso de la reconversión.";

                this.ErrMessage_Span.InnerHtml = errorMessage;
                this.ErrMessage_Span.Visible = true;
            }

            Int16 cantidadDigitos = Convert.ToInt16(Session["reconversionMonetaria.cantidadDigitos"]);

            // finalmente, determinamos el divisor para la reconversión: si, por ejemplo, la cantidad de dígitos es 3, el dividor debe ser 1.000 
            int divisor = 1;

            for (short i = 1; i <= cantidadDigitos; i++)
            {
                divisor = divisor * 10;
            }

            this.monedaNacional_span.InnerText = monedaNacional.Descripcion + " (" + monedaNacional.Simbolo + ")";
            this.cuentaContable_span.InnerText = $"{cuentaContable.CuentaEditada} - {cuentaContable.Descripcion} - {cuentaContable.ID.ToString()}";
            this.ano_span.InnerText = ano.ToString();
            this.cantidadDigitos_span.InnerText = cantidadDigitos.ToString();
            this.divisor_span.InnerText = divisor.ToString("N0");

            this.texto1.Visible = false;

            this.texto1.Visible = true;
            this.ejecutarReconversion_button.Visible = true;

            parametrosProc parametrosProc = new parametrosProc
            {
                ano = ano,
                moneda = monedaNacional.Moneda1,
                cantidadDigitos = cantidadDigitos,
                divisor = divisor,
                cuentaContableID = cuentaContable.ID,
                ciaContabSeleccionada = cia.ciaContabSeleccionada,
            };

            // la idea es mantener el state de estos parámetros para tenerlos siempre a la mano ... 
            Session["parametrosProc"] = parametrosProc;
        }

        protected void ejecutarReconversion_button_Click(object sender, EventArgs e)
        {
            bool ejecutarContablidad = this.proceso_contabilidad_RadioButton.Checked;
            bool ejecutarContablidad_asientosAjuste = this.proceso_contabilidad_asientos_RadioButton.Checked;
            bool ejecutarContablidad_saldosIniciales = this.proceso_contabilidad_saldosIniciales_RadioButton.Checked;
            bool ejecutarContablidad_saldosIniciales_cuadrar = this.proceso_contabilidad_saldosIniciales_cuadrar_RadioButton.Checked;
            bool ejecutarBancos = this.proceso_bancos_RadioButton.Checked;
            //bool ejecutarNomina = this.proceso_nomina_RadioButton.Checked;
            //bool ejecutarCajaChica = this.proceso_cajaChica_RadioButton.Checked;
            bool ejecutarActivosFijos = this.proceso_activosFijos_RadioButton.Checked;

            if (!ejecutarContablidad && !ejecutarContablidad_asientosAjuste && !ejecutarContablidad_saldosIniciales && !ejecutarBancos && 
                !ejecutarContablidad_saldosIniciales_cuadrar && !ejecutarActivosFijos)
            {
                string errorMessage = "Ud. debe seleccionar un proceso a ejecutar.<br />";

                this.ErrMessage_Span.InnerHtml = errorMessage;
                this.ErrMessage_Span.Visible = true;

                return;
            }

            // recuperamos los parámetros de ejecución del proceso: año, cantidad de dígitos, moneda y cia ... 
            parametrosProc parametrosProc = (parametrosProc)Session["parametrosProc"];

            dbContab_Contab_Entities context = new dbContab_Contab_Entities();

            if (ejecutarContablidad)
            {
                string sDivisor = parametrosProc.divisor.ToString();
                bool error = false;
                string message = "";

                contabilidad(context, sDivisor, parametrosProc.moneda, parametrosProc.ano, parametrosProc.ciaContabSeleccionada, out error, out message);

                if (error)
                {
                    this.ErrMessage_Span.InnerHtml = message;
                    this.ErrMessage_Span.Visible = true;
                }
                else
                {
                    this.InfoMessage_Span.InnerHtml = message;
                    this.InfoMessage_Span.Visible = true;
                }

                return;
            }

            if (ejecutarContablidad_saldosIniciales)
            {
                string sDivisor = parametrosProc.divisor.ToString();
                bool error = false;
                string message = "";

                contabilidad_saldosInicialesAjuste(context, sDivisor, parametrosProc.moneda, parametrosProc.ano, parametrosProc.ciaContabSeleccionada, out error, out message);

                if (error)
                {
                    this.ErrMessage_Span.InnerHtml = message;
                    this.ErrMessage_Span.Visible = true;
                }
                else
                {
                    this.InfoMessage_Span.InnerHtml = message;
                    this.InfoMessage_Span.Visible = true;
                }

                return;
            }

            if (ejecutarContablidad_saldosIniciales_cuadrar)
            {
                bool error = false;
                string message = "";

                contabilidad_saldosInicialesCuadrar(context, parametrosProc.cuentaContableID, parametrosProc.moneda, parametrosProc.ano, parametrosProc.ciaContabSeleccionada, out error, out message);

                if (error)
                {
                    this.ErrMessage_Span.InnerHtml = message;
                    this.ErrMessage_Span.Visible = true;
                }
                else
                {
                    this.InfoMessage_Span.InnerHtml = message;
                    this.InfoMessage_Span.Visible = true;
                }

                return;
            }

            if (ejecutarContablidad_asientosAjuste)
            {
                bool error = false;
                string message = "";

                contabilidad_asientosAjuste(context, parametrosProc.cuentaContableID, parametrosProc.moneda, parametrosProc.ano, parametrosProc.ciaContabSeleccionada, out error, out message);

                if (error)
                {
                    this.ErrMessage_Span.InnerHtml = message;
                    this.ErrMessage_Span.Visible = true;
                }
                else
                {
                    this.InfoMessage_Span.InnerHtml = message;
                    this.InfoMessage_Span.Visible = true;
                }

                return;
            }

            if (ejecutarBancos)
            {
                bool error = false;
                string message = "";
                string sDivisor = parametrosProc.divisor.ToString();

                bancos(context, sDivisor, parametrosProc.moneda, parametrosProc.ano, parametrosProc.ciaContabSeleccionada, out error, out message);

                if (error)
                {
                    this.ErrMessage_Span.InnerHtml = message;
                    this.ErrMessage_Span.Visible = true;
                }
                else
                {
                    this.InfoMessage_Span.InnerHtml = message;
                    this.InfoMessage_Span.Visible = true;
                }

                return;
            }

            //if (ejecutarCajaChica)
            //{
            //    return;
            //}

            //if (ejecutarNomina)
            //{
            //    return;
            //}

            if (ejecutarActivosFijos)
            {
                bool error = false;
                string message = "";
                string sDivisor = parametrosProc.divisor.ToString();

                activosFijos(context, sDivisor, parametrosProc.moneda, parametrosProc.ano, parametrosProc.ciaContabSeleccionada, out error, out message);

                if (error)
                {
                    this.ErrMessage_Span.InnerHtml = message;
                    this.ErrMessage_Span.Visible = true;
                }
                else
                {
                    this.InfoMessage_Span.InnerHtml = message;
                    this.InfoMessage_Span.Visible = true;
                }

                return;
            }
        }

        private void contabilidad(dbContab_Contab_Entities context, string divisor, int moneda, short ano, int ciaSeleccionada, out bool error, out string message)
        {
            error = false;
            message = "";
            int cantAsientosActualizados = 0;

            try
            {
                // asientos 
                string queryString =
                    $"Update d Set d.Debe = Round(d.Debe / {divisor}, 2), d.Haber = Round(d.Haber / {divisor}, 2) " +
                    "FROM dAsientos d Inner Join Asientos a On d.NumeroAutomatico = a.NumeroAutomatico " +
                    "Where a.moneda = {0} And a.AnoFiscal = {1} And a.Cia = {2}";

                cantAsientosActualizados = context.ExecuteStoreCommand(queryString, moneda, ano, ciaSeleccionada);
            }
            catch (Exception ex)
            {
                error = true;
                message = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br /> " +
                    "El mensaje específico de error es: " + ex.Message + "<br /><br />";

                return;
            }

            message = $"<h3>Contabilidad</h3><br />" +
                $"Ok, El proceso ha finalizado en forma satisfactoria.<br /><br />" +
                $"En total, se han actualizado: {cantAsientosActualizados.ToString()} registros desde asientos contables.";

            return;
        }

        private void contabilidad_saldosInicialesAjuste(dbContab_Contab_Entities context, string divisor, int moneda, short ano, int ciaSeleccionada, out bool error, out string message)
        {
            error = false;
            message = "";
            int cantSaldosInicialesActualizados = 0;

            try
            {
                // asientos 
                string queryString =
                    $"Update s Set s.Inicial = Round(s.Inicial / {divisor}, 2) " +
                    "FROM SaldosContables s " +
                    "Where s.moneda = {0} And s.Ano = {1} And s.Cia = {2}";

                cantSaldosInicialesActualizados = context.ExecuteStoreCommand(queryString, moneda, ano, ciaSeleccionada);
            }
            catch (Exception ex)
            {
                error = true;
                message = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br /> " +
                    "El mensaje específico de error es: " + ex.Message + "<br /><br />";

                return;
            }

            message = $"<h3>Saldos iniciales - reconversión</h3><br />" + 
                $"Ok, El proceso ha finalizado en forma satisfactoria.<br /><br />" +
                $"En total, se han actualizado: {cantSaldosInicialesActualizados.ToString()} registros desde asientos contables.";

            return;
        }

        private void contabilidad_saldosInicialesCuadrar(dbContab_Contab_Entities context, int cuentaContableID, int moneda, short ano, int ciaSeleccionada, out bool error, out string message)
        {
            error = false;
            message = "";

            // asientos 
            string queryString =
                $"Select s.Moneda as moneda, s.MonedaOriginal as monedaOriginal, s.Ano as ano, s.Cia as cia, Sum(s.Inicial) as sumOfInicial " +
                    "From SaldosContables s Inner Join CuentasContables c On s.CuentaContableID = c.ID " +
                    "Where s.Ano = {0} And s.Moneda = {1} And s.Cia = {2} " +
                    "And c.TotDet = 'D' " +
                    "Group By s.Moneda, s.MonedaOriginal, s.Ano, s.Cia";

            List<saldos_sumarizacion> query = context.ExecuteStoreQuery<saldos_sumarizacion>(queryString, ano, moneda, ciaSeleccionada).ToList();
            SaldosContable saldoContable;

            int saldosContables_ajustados = 0;
            int saldosContables_agregados = 0;

            foreach (saldos_sumarizacion inicial in query)
            {
                if (inicial.sumOfInicial == 0)
                    // si no hay diferencia en el saldo inicial, simplemente continuamos ... 
                    continue;


                // leemos un registro de saldos para la cuenta contable, a ver si existe
                saldoContable = context.SaldosContables.Where(s => s.CuentaContableID == cuentaContableID &&
                                                                   s.Moneda == inicial.moneda && s.MonedaOriginal == inicial.monedaOriginal &&
                                                                   s.Ano == inicial.ano && s.Cia == inicial.cia).FirstOrDefault();

                if (saldoContable != null)
                {
                    // el registro de saldos para la: cuenta, moneda y moneda  original *existe*; lo actualizamos 

                    // calculamos el nuevo saldo inicial (ajustado) 
                    decimal nuevoInicial = saldoContable.Inicial.HasValue ? saldoContable.Inicial.Value : 0;

                    if (inicial.sumOfInicial >= 0)
                        nuevoInicial = nuevoInicial - inicial.sumOfInicial;                     // la diferencia es mayor que cero; para ajustar, restamos 
                    else
                        nuevoInicial = nuevoInicial + Math.Abs(inicial.sumOfInicial);           // la diferencia es menor que cero; para ajustar, sumamos 

                    saldoContable.Inicial = nuevoInicial;
                    saldosContables_ajustados++;
                }
                else
                {
                    // el registro de saldos para la cuenta *no existe*; lo agregamos 

                    SaldosContable saldo = new SaldosContable
                    {
                        CuentaContableID = cuentaContableID,
                        Moneda = inicial.moneda,
                        MonedaOriginal = inicial.monedaOriginal,
                        Ano = inicial.ano,
                        // agregamos la diferencia, justo con el signo contrario ... 
                        Inicial = (inicial.sumOfInicial * -1),
                        Mes01 = 0,
                        Mes02 = 0,
                        Mes03 = 0,
                        Mes04 = 0,
                        Mes05 = 0,
                        Mes06 = 0,
                        Mes07 = 0,
                        Mes08 = 0,
                        Mes09 = 0,
                        Mes10 = 0,
                        Mes11 = 0,
                        Mes12 = 0,
                        Anual = 0,
                        Cia = inicial.cia,
                    };

                    saldosContables_agregados++;
                    context.SaldosContables.AddObject(saldo);
                }
            }


            try
            {
                context.SaveChanges();
            }
            catch (Exception ex)
            {
                error = true;
                message = $"<h3>Saldos iniciales - Cuadre contra cuenta de reconversión</h3><br />" + 
                    "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br /> " +
                    "El mensaje específico de error es: " + ex.Message + "<br /><br />";

                context.Dispose();

                return;
            }

            context.Dispose();

            message = $"<h3>Saldos iniciales - ajuste contra cuenta de reconversión</h3><br />" +
                $"Ok, El proceso ha finalizado en forma satisfactoria.<br /><br />" +
            $"En total, se han <b>actualizado</b>: {saldosContables_ajustados.ToString()} registros de saldo, para ajustar el saldo inicial del año y <em>cuadrarlo</em> a cero.<br />" +
            $"Además, se han <b>agregado</b>: {saldosContables_agregados.ToString()} registros de saldo, para ajustar el saldo inicial del año y <em>cuadrarlo</em> a cero.";

            return;
        }

        private void contabilidad_asientosAjuste(dbContab_Contab_Entities context, int cuentaContableID, int moneda, short ano, int ciaSeleccionada, out bool error, out string message)
        {
            error = false;
            message = "";

            // asientos 
            string queryString =
                $"Select d.NumeroAutomatico as numeroAutomatico, Sum(d.Debe) as sumOfDebe, Sum(d.Haber) as sumOfHaber, " +
                    "Sum(d.Debe) - Sum(d.Haber) as diferencia, Max(d.Partida) as ultimaPartida " +
                    "From dAsientos d Inner Join Asientos a On d.NumeroAutomatico = a.NumeroAutomatico " +
                    "Where a.AnoFiscal = {0} And a.Moneda = {1} And a.Cia = {2} " +
                    "Group By d.NumeroAutomatico " +
                    "Having Sum(d.Debe) <> Sum(d.Haber) ";

            List<asiento_sumarizacion> query = context.ExecuteStoreQuery<asiento_sumarizacion>(queryString, ano, moneda, ciaSeleccionada).ToList();
            dAsiento partida;

            int asientosContablesAjustados = 0;

            foreach (asiento_sumarizacion p in query)
            {
                partida = new dAsiento();

                partida.NumeroAutomatico = p.numeroAutomatico;
                partida.Partida = Convert.ToInt16(p.ultimaPartida + 10);
                partida.CuentaContableID = cuentaContableID;
                partida.Descripcion = "Reconversión (2018) - ajuste al asiento contable";
                partida.Referencia = null;
                partida.Debe = p.diferencia <= 0 ? Math.Abs(p.diferencia) : 0;
                partida.Haber = p.diferencia > 0 ? Math.Abs(p.diferencia) : 0;

                context.dAsientos.AddObject(partida);
                asientosContablesAjustados++;
            }

            try
            {
                context.SaveChanges();
            }
            catch (Exception ex)
            {
                error = true;
                message = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br /> " +
                    "El mensaje específico de error es: " + ex.Message + "<br /><br />";

                context.Dispose();

                return;
            }

            context.Dispose();

            message = $"<h3>Asientos contables - ajuste contra cuenta de reconversión</h3><br />" + 
                $"Ok, El proceso ha finalizado en forma satisfactoria.<br /><br />" +
            $"En total, se han actualizado: {asientosContablesAjustados.ToString()} asientos contables, para ajustarlos y <em>cuadrarlos</em> a cero. ";

            return;
        }


        private void bancos(dbContab_Contab_Entities context, string divisor, int moneda, short ano, int ciaSeleccionada, out bool error, out string message)
        {
            error = false;
            message = "";

            string desde = new DateTime(ano, 1, 1).ToString("yyyy-MM-dd");
            string hasta = new DateTime(ano, 12, 31).ToString("yyyy-MM-dd");

            int cant_facturas_actualizadas = 0;
            int cant_cuotas_actualizadas = 0;
            int cant_impuestosRetenciones_actualizadas = 0;
            int cant_pagos_actualizadas = 0;
            int cant_dPagos_actualizadas = 0;
            int cant_movimientosBancarios_actualizadas = 0;


            // -------------------------------------------------------
            // facturas  
            // -------------------------------------------------------

            try
            {
                string queryString =
                        $"Update f Set f.MontoFacturaSinIva = Round(f.MontoFacturaSinIva / { divisor}, 2), f.RetencionSobreIva = Round(f.RetencionSobreIva / { divisor}, 2), " +
                        $"f.MontoFacturaConIva = Round(f.MontoFacturaConIva / { divisor}, 2), f.Iva = Round(f.Iva / { divisor}, 2), " +
                        $"f.TotalFactura = Round(f.TotalFactura / { divisor}, 2), f.MontoSujetoARetencion = Round(f.MontoSujetoARetencion / { divisor}, 2), " +
                        $"f.ImpuestoRetenidoISLRAntesSustraendo = Round(f.ImpuestoRetenidoISLRAntesSustraendo / { divisor}, 2), " +
                        $"f.ImpuestoRetenidoISLRSustraendo = Round(f.ImpuestoRetenidoISLRSustraendo / { divisor}, 2), f.ImpuestoRetenido = Round(f.ImpuestoRetenido / { divisor}, 2),  " +
                        $"f.OtrosImpuestos = Round(f.OtrosImpuestos / { divisor}, 2), f.OtrasRetenciones = Round(f.OtrasRetenciones / { divisor}, 2), " +
                        $"f.TotalAPagar = Round(f.TotalAPagar / { divisor}, 2), f.Anticipo = Round(f.Anticipo / { divisor}, 2), " +
                        $"f.Saldo = Round(f.Saldo / { divisor}, 2) " +
                        $"From Facturas f " +
                        $"Where ((f.CxCCxPFlag = 1 And f.FechaRecepcion Between '{desde}' and '{hasta}') Or " +
                        $"(f.CxCCxPFlag = 2 And f.FechaEmision Between '{desde}' and '{hasta}')) " +
                        $"And f.Moneda = {moneda} And f.Cia = {ciaSeleccionada}";

                cant_facturas_actualizadas = context.ExecuteStoreCommand(queryString);
            }
            catch (Exception ex)
            {
                error = true;
                message = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br /> " +
                    "El mensaje específico de error es: " + ex.Message + "<br /><br />";

                return;
            }


            // -------------------------------------------------------
            // cuotas   
            // -------------------------------------------------------

            try
            {
                string queryString =
                        $"Update c Set c.MontoCuota = Round(c.MontoCuota / { divisor}, 2), c.RetencionSobreIva = Round(c.RetencionSobreIva / { divisor}, 2), " +
                        $"c.RetencionSobreISLR = Round(c.RetencionSobreISLR / { divisor}, 2), c.OtrosImpuestos = Round(c.OtrosImpuestos / { divisor}, 2), " +
                        $"c.Iva = Round(c.Iva / { divisor}, 2), c.OtrasRetenciones = Round(c.OtrasRetenciones / { divisor}, 2), " +
                        $"c.TotalCuota = Round(c.TotalCuota / { divisor}, 2), " +
                        $"c.Anticipo = Round(c.Anticipo / { divisor}, 2), c.SaldoCuota = Round(c.SaldoCuota / { divisor}, 2) " +
                        $"from CuotasFactura c Inner Join Facturas f On c.ClaveUnicaFactura = f.ClaveUnica " +
                        $"Where ((f.CxCCxPFlag = 1 And f.FechaRecepcion Between '{desde}' and '{hasta}') Or " +
                        $"(f.CxCCxPFlag = 2 And f.FechaEmision Between '{desde}' and '{hasta}')) " +
                        $"And f.Moneda = {moneda} And f.Cia = {ciaSeleccionada}";

                cant_cuotas_actualizadas = context.ExecuteStoreCommand(queryString);
            }
            catch (Exception ex)
            {
                error = true;
                message = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br /> " +
                    "El mensaje específico de error es: " + ex.Message + "<br /><br />";

                return;
            }


            // -------------------------------------------------------
            // impuestos / retenciones    
            // -------------------------------------------------------

            try
            {
                string queryString =
                        $"Update i Set i.MontoBase = Round(i.MontoBase / { divisor}, 2), i.MontoAntesSustraendo = Round(i.MontoAntesSustraendo / { divisor}, 2), " +
                        $"i.Sustraendo = Round(i.Sustraendo / { divisor}, 2), i.Monto = Round(i.Monto / { divisor}, 2) " +
                        $"From Facturas_Impuestos i Inner Join Facturas f On i.FacturaID = f.ClaveUnica " +
                        $"Where ((f.CxCCxPFlag = 1 And f.FechaRecepcion Between '{desde}' and '{hasta}') Or " +
                        $"(f.CxCCxPFlag = 2 And f.FechaEmision Between '{desde}' and '{hasta}')) " +
                        $"And f.Moneda = {moneda} And f.Cia = {ciaSeleccionada}";

                cant_impuestosRetenciones_actualizadas = context.ExecuteStoreCommand(queryString);
            }
            catch (Exception ex)
            {
                error = true;
                message = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br /> " +
                    "El mensaje específico de error es: " + ex.Message + "<br /><br />";

                return;
            }

            // -------------------------------------------------------
            // pagos 
            // -------------------------------------------------------

            try
            {
                string queryString =
                        $"Update p Set p.Monto = Round(p.Monto / { divisor}, 2) " +
                        $"From Pagos p " +
                        $"Where (p.Fecha Between '{desde}' and '{hasta}') And " +
                        $"p.Moneda = {moneda} And p.Cia = {ciaSeleccionada}";

                cant_pagos_actualizadas = context.ExecuteStoreCommand(queryString);
            }
            catch (Exception ex)
            {
                error = true;
                message = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br /> " +
                    "El mensaje específico de error es: " + ex.Message + "<br /><br />";

                return;
            }

            // -------------------------------------------------------
            // dPagos 
            // -------------------------------------------------------

            try
            {
                string queryString =
                        $"Update d Set d.MontoPagado = Round(d.MontoPagado / { divisor}, 2) " +
                        $"From dPagos d Inner Join Pagos p On d.ClaveUnicaPago = p.ClaveUnica " +
                        $"Where (p.Fecha Between '{desde}' and '{hasta}') And p.Moneda = {moneda} And p.Cia = {ciaSeleccionada}";

                cant_dPagos_actualizadas = context.ExecuteStoreCommand(queryString);
            }
            catch (Exception ex)
            {
                error = true;
                message = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br /> " +
                    "El mensaje específico de error es: " + ex.Message + "<br /><br />";

                return;
            }

            // -------------------------------------------------------
            // movimientos bancarios  
            // -------------------------------------------------------

            try
            {
                string queryString =
                        $"Update m Set m.MontoBase = Round(m.MontoBase / { divisor}, 2), m.Comision = Round(m.Comision / { divisor}, 2), " +
                        $"m.Impuestos = Round(m.Impuestos / { divisor}, 2), m.Monto = Round(m.Monto / { divisor}, 2) " +
                        $"From MovimientosBancarios m Inner Join Chequeras ch On m.ClaveUnicaChequera = ch.NumeroChequera " +
                        $"Inner Join CuentasBancarias cb On ch.NumeroCuenta = cb.CuentaInterna " +
                        $"Where (m.Fecha Between '{desde}' and '{hasta}') And cb.Moneda = {moneda} And cb.Cia = {ciaSeleccionada}";

                cant_movimientosBancarios_actualizadas = context.ExecuteStoreCommand(queryString);
            }
            catch (Exception ex)
            {
                error = true;
                message = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br /> " +
                    "El mensaje específico de error es: " + ex.Message + "<br /><br />";

                return;
            }

            message = $"<h3>Bancos</h3><br />" +
                $"Ok, El proceso ha finalizado en forma satisfactoria.<br /><br />" +
                $"En total, se han actualizado: {cant_facturas_actualizadas.ToString()} facturas, <br /> " +
                $"{cant_cuotas_actualizadas.ToString()} cuotas de factura, <br />" +
                $"{cant_impuestosRetenciones_actualizadas.ToString()} registros de impuestos y retenciones, <br />" +
                $"{cant_pagos_actualizadas.ToString()} pagos, <br />" +
                $"{cant_dPagos_actualizadas.ToString()} dPagos, <br />" +
                $"y, finalmente, {cant_movimientosBancarios_actualizadas.ToString()} movimientos bancarios. ";

            return;
        }


        private void activosFijos(dbContab_Contab_Entities context, string divisor, int moneda, short ano, int ciaSeleccionada, out bool error, out string message)
        {
            error = false;
            message = "";

            string desde = new DateTime(ano, 1, 1).ToString("yyyy-MM-dd");
            string hasta = new DateTime(ano, 12, 31).ToString("yyyy-MM-dd");
            string desde_mes = new DateTime(ano, 1, 1).ToString("MM");
            string desde_ano = new DateTime(ano, 1, 1).ToString("yyyy");

            int cant_activosFijos_actualizados = 0;
            
            // -------------------------------------------------------
            // InventarioActivosFijos   
            // -------------------------------------------------------

            try
            {
                string queryString =
                        $"Update i Set i.CostoTotal = Round(i.CostoTotal / { divisor}, 2), i.ValorResidual = Round(i.ValorResidual / { divisor}, 2), " +
                        $"i.MontoADepreciar = Round(i.MontoADepreciar / { divisor}, 2), i.MontoDepreciacionMensual = Round(i.MontoDepreciacionMensual / { divisor}, 2) " +
                        $"From InventarioActivosFijos i " +
                        $"Where ((i.FechaDesincorporacion Is Null) Or (i.FechaDesincorporacion >= '{desde}')) And " +
                        $"( (i.DepreciarHastaAno > {desde_ano}) Or (i.DepreciarHastaAno = {desde_ano} And i.DepreciarHastaMes >= {desde_mes} ) ) And " +
                        $"i.Cia = {ciaSeleccionada}";

                cant_activosFijos_actualizados = context.ExecuteStoreCommand(queryString);
            }
            catch (Exception ex)
            {
                error = true;
                message = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br /> " +
                    "El mensaje específico de error es: " + ex.Message + "<br /><br />";

                return;
            }

            message = $"<h3>Activos fijos</h3><br />" + 
                $"Ok, El proceso ha finalizado en forma satisfactoria.<br /><br />" +
                $"En total, se han actualizado: {cant_activosFijos_actualizados.ToString()} registros de activos fijos. ";

            return;
        }
    }  
}