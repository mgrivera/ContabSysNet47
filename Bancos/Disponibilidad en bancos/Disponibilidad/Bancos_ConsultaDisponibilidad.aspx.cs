using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Linq; 
using System.Web.UI.HtmlControls;
using System.Web.Security;
using ContabSysNetWeb.Old_App_Code;
using ContabSysNet_Web.old_app_code; 

namespace ContabSysNetWeb.Bancos.Disponibilidad_en_bancos.Disponibilidad
{
    public partial class Bancos_ConsultaDisponibilidad : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Master.Page.Title = "Consulta de disponibilidad";

            ErrMessage_Span.InnerHtml = "";
            ErrMessage_Span.Style["display"] = "none";

            if (!Page.IsPostBack)
            {

                // Gets a reference to a Label control that is not in a
                // ContentPlaceHolder control

                HtmlContainerControl MyHtmlSpan;

                MyHtmlSpan = (HtmlContainerControl)Master.FindControl("AppName_Span");
                if (!(MyHtmlSpan == null))
                {
                    MyHtmlSpan.InnerHtml = "Bancos";
                }

                HtmlGenericControl MyHtmlH2;

                MyHtmlH2 = (HtmlGenericControl)Master.FindControl("PageTitle_TableCell");
                if (!(MyHtmlH2 == null))
                {
                    MyHtmlH2.InnerHtml = "Consulta de Saldos y Movimientos de Cuentas Bancarias";
                }

                // --------------------------------------------------------------------------------------------
                // para asignar la página que corresponde al help de la página

                HtmlAnchor MyHtmlHyperLink;
                MyHtmlHyperLink = (HtmlAnchor)Master.FindControl("Help_HyperLink");

                MyHtmlHyperLink.HRef = "javascript:PopupWin('http://wp.me/p2Xyqo-aN', 1000, 680)";

                Session["FiltroForma"] = null;
            }

            else
            {

                //If Not FechaDisponibilidadAl_TextBox.Text = "" AndAlso IsDate(FechaDisponibilidadAl_TextBox.Text) Then
                // FechaDisponibilidadAl_TextBox_CalendarExtender.SelectedDate = CDate(FechaDisponibilidadAl_TextBox.Text)
                //End If

                if (RebindFlagHiddenField.Value == "1")
                {

                    RebindFlagHiddenField.Value = "0";

                    string sSqlSelectString = Session["FiltroForma"].ToString();
                    System.DateTime dFechaSaldoAnterior = new System.DateTime();

                    CrearInfoReport(sSqlSelectString, 
                        (System.DateTime)Session["FechaDisponibilidadAl"], 
                        ref dFechaSaldoAnterior);

                    FechaDisponibilidadAl_Label.Text = Convert.ToDateTime(Session["FechaDisponibilidadAl"]).ToString("dd-MMM-yyyy");

                    ConsultaDisponibilidad_ListView.DataBind();

                    // para eliminar cualquier selección que pueda estar activa en el ListView de movimientos

                    Movimientos_SqlDataSource.SelectParameters[0].DefaultValue = "-999";
                    Movimientos_SqlDataSource.SelectParameters[1].DefaultValue = User.Identity.Name;
                    Movimientos_SqlDataSource.SelectParameters[2].DefaultValue = "-999";

                    Movimientos_ListView.DataBind();

                    DatosCuenta_H5.InnerHtml = "";

                    ConsultaDisponibilidad_TabContainer.ActiveTabIndex = 0;

                }

            }
        }

        private void CrearInfoReport(string sSqlSelectString, System.DateTime dFechaConsultaDisponibilidad, ref System.DateTime dFechaSaldoAnterior)
        {
            // en este Sub agregamos los registros a la tabla 'temporal' en la base de datos para que la
            // página que sigue los muestre al usuario en un DataGridView

            if (!User.Identity.IsAuthenticated) {
                FormsAuthentication.SignOut();
                return;
            }

            // -----------------------------------------------------------------------------------------------
            // lo primero que hacemos es determinar el mes del saldo anterior y el período de movimientos

            Int16 nAnoSaldoAnterior = (short)dFechaConsultaDisponibilidad.Year;
            Int16 nMesSaldoAnterior = Convert.ToInt16(dFechaConsultaDisponibilidad.Month - 1);

            if (nMesSaldoAnterior == 0) {
                nAnoSaldoAnterior -= 1;
                nMesSaldoAnterior = 12;
            }


            // nótese como obtenemos la fecha que corresponde al último día del mes ... 
            dFechaSaldoAnterior = new DateTime(nAnoSaldoAnterior, nMesSaldoAnterior, DateTime.DaysInMonth(nAnoSaldoAnterior, nMesSaldoAnterior));

            System.DateTime dFechaInicialPeriodo = new System.DateTime(dFechaConsultaDisponibilidad.Year, dFechaConsultaDisponibilidad.Month, 1);
            System.DateTime dFechaFinalPeriodo = dFechaConsultaDisponibilidad;

            // ----------------------------------------------------------------------------------------
            // eliminamos los registros anteriores de la tabla 'temporal'

            dbBancosDataContext dbBancos = new dbBancosDataContext();

            try 
            {
                dbBancos.ExecuteCommand("Delete From tTempWebReport_DisponibilidadBancos2 Where NombreUsuario = {0}", User.Identity.Name);
                dbBancos.ExecuteCommand("Delete From tTempWebReport_DisponibilidadBancos Where NombreUsuario = {0}", User.Identity.Name);
                dbBancos.ExecuteCommand("Delete From Disponibilidad_MontosRestringidos_ConsultaDisponibilidad Where NombreUsuario = {0}", User.Identity.Name);
                dbBancos.ExecuteCommand("Delete From Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad Where NombreUsuario = {0}", User.Identity.Name);
            }
            catch (Exception ex) {
                dbBancos.Dispose();

                ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br /> " + 
                    "El mensaje específico de error es: " + ex.Message + "<br /><br />";
                ErrMessage_Span.Style["display"] = "block";
                return;
            }

            // ----------------------------------------------------------------------------------------------
            // lo primero que hacemos es leer las cuentas bancarias que cumplan con el criterio de selección

            Int16 nRecCount = 0;

            decimal nSaldoAnteriorCuentaBancaria = 0;
            decimal nMontoDebitos = 0;
            decimal nMontoCreditos = 0;
            decimal nSaldoActualCuentaBancaria = 0;
            Int16 nOrdenRegistroMovimientos = 0;

            // ---------------------------------------------------------------------------------------
            // objetos para agregar registros a ambas tablas 'temporales'

            List<tTempWebReport_DisponibilidadBanco> CuentasBancarias = new List<tTempWebReport_DisponibilidadBanco>();
            tTempWebReport_DisponibilidadBanco CuentaBancaria;

            List<tTempWebReport_DisponibilidadBancos2> CuentasBancarias_Movimientos = new List<tTempWebReport_DisponibilidadBancos2>();
            tTempWebReport_DisponibilidadBancos2 CuentasBancarias_Movimiento;

            // ----------------------------------------------------------------------------------------------
            // lo primero que hacemos es leer las cuentas bancarias que cumplan con el criterio de selección
            // (NOTESE como usamos dynamic linq aquí)

            // eliminamos las cuentas bancarias no activas del filtro

            sSqlSelectString += " And Estado = 'AC'";

            var query_cb = dbBancos.ExecuteQuery<CuentasBancaria>("Select * From CuentasBancarias Where " + sSqlSelectString); 

            foreach (var cb in query_cb) {

                // ---------------------------------------------------------------------------------
                // leemos el saldo anterior de la cuenta

                int nCuentaInterna = cb.CuentaInterna;
                int nCiaContab = cb.Cia;

                var query_sa = from sa in dbBancos.Saldos 
                               where sa.CuentaBancaria == nCuentaInterna && sa.Ano == nAnoSaldoAnterior
                               select sa; 

                foreach (var sa in query_sa) {
                    // este query puede o no traer registros; por eso leemos y salimos

                    switch (nMesSaldoAnterior) {
                        case 0:
                            nSaldoAnteriorCuentaBancaria = sa.Inicial.Value;
                            break; 
                        case 1:
                            nSaldoAnteriorCuentaBancaria = sa.Mes01.Value;
                            break; 
                        case 2:
                            nSaldoAnteriorCuentaBancaria = sa.Mes02.Value;
                            break; 
                        case 3:
                            nSaldoAnteriorCuentaBancaria = sa.Mes03.Value;
                            break; 
                        case 4:
                            nSaldoAnteriorCuentaBancaria = sa.Mes04.Value;
                            break; 
                        case 5:
                            nSaldoAnteriorCuentaBancaria = sa.Mes05.Value;
                            break; 
                        case 6:
                            nSaldoAnteriorCuentaBancaria = sa.Mes06.Value;
                            break; 
                        case 7:
                            nSaldoAnteriorCuentaBancaria = sa.Mes07.Value;
                            break; 
                        case 8:
                            nSaldoAnteriorCuentaBancaria = sa.Mes08.Value;
                            break; 
                        case 9:
                            nSaldoAnteriorCuentaBancaria = sa.Mes09.Value;
                            break; 
                        case 10:
                            nSaldoAnteriorCuentaBancaria = sa.Mes10.Value;
                            break; 
                        case 11:
                            nSaldoAnteriorCuentaBancaria = sa.Mes11.Value;
                            break; 
                        case 12:
                            nSaldoAnteriorCuentaBancaria = sa.Mes12.Value;
                            break; 
                    }
                }

                // ----------------------------------------------------------------------------------------------
                // agregamos un 1er. registro a la tabla 'temporal' de movimientos con el saldo inicial
                // de la cuenta

                nOrdenRegistroMovimientos = 1;

                CuentasBancarias_Movimiento = new tTempWebReport_DisponibilidadBancos2();

                CuentasBancarias_Movimiento.CuentaInterna = cb.CuentaInterna;

                CuentasBancarias_Movimiento.Transaccion = 001;
                CuentasBancarias_Movimiento.Tipo = "IN";
                CuentasBancarias_Movimiento.Orden = nOrdenRegistroMovimientos;
                CuentasBancarias_Movimiento.Fecha = dFechaInicialPeriodo;
                CuentasBancarias_Movimiento.Concepto = "Saldo inicial del período";
                CuentasBancarias_Movimiento.Monto = nSaldoAnteriorCuentaBancaria;
                CuentasBancarias_Movimiento.CiaContab = cb.Cia;
                CuentasBancarias_Movimiento.NombreUsuario = User.Identity.Name;

                CuentasBancarias_Movimientos.Add(CuentasBancarias_Movimiento);

                // ----------------------------------------------------------------------------------------------
                // ahora obtenemos los movimientos del período para grabarlos a otra tabla 'temporal' y para
                // obtener la sumarización de debitos y créditos y, finalmente, el saldo actual de la cuenta

                nMontoDebitos = 0;
                nMontoCreditos = 0;

                var query = from mb in dbBancos.MovimientosBancarios 
                    where mb.Chequera.CuentasBancaria.CuentaInterna == nCuentaInterna && 
                            mb.Fecha >= dFechaInicialPeriodo && mb.Fecha <= dFechaFinalPeriodo && 
                            mb.Chequera.CuentasBancaria.Compania.Numero == nCiaContab               // ésto no es necesario !!!! 
                    orderby mb.Fecha 
                    select new { mb.Transaccion, 
                            mb.Tipo, 
                            mb.Fecha, 
                            mb.ProvClte, 
                            mb.Beneficiario, 
                            mb.Concepto, mb.Monto, 
                            mb.FechaEntregado, 
                            NombreProveedor = mb.Proveedore.Nombre, 
                            mb.Conciliacion_FechaEjecucion}; 

                foreach (var mb in query) {

                    if (mb.Monto >= 0) {
                        nMontoDebitos += mb.Monto;
                    }
                    else {
                        nMontoCreditos += mb.Monto;
                    }

                    nOrdenRegistroMovimientos += 1;

                    CuentasBancarias_Movimiento = new tTempWebReport_DisponibilidadBancos2();

                    CuentasBancarias_Movimiento.CuentaInterna = cb.CuentaInterna;
                    CuentasBancarias_Movimiento.Transaccion = mb.Transaccion;
                    CuentasBancarias_Movimiento.Tipo = mb.Tipo;
                    CuentasBancarias_Movimiento.Orden = nOrdenRegistroMovimientos;
                    CuentasBancarias_Movimiento.Fecha = mb.Fecha;
                    if (!(mb.ProvClte == null)) {
                        CuentasBancarias_Movimiento.ProvClte = mb.ProvClte;
                    }
                    CuentasBancarias_Movimiento.Beneficiario = mb.Beneficiario;
                    CuentasBancarias_Movimiento.NombreProveedorCliente = mb.NombreProveedor;
                    CuentasBancarias_Movimiento.Concepto = mb.Concepto;
                    CuentasBancarias_Movimiento.Monto = mb.Monto;
                    if (!(mb.FechaEntregado == null)) {
                        CuentasBancarias_Movimiento.FechaEntregado = mb.FechaEntregado;
                    }

                    CuentasBancarias_Movimiento.Conciliacion_FechaEjecucion = mb.Conciliacion_FechaEjecucion;
                    CuentasBancarias_Movimiento.CiaContab = cb.Cia;
                    CuentasBancarias_Movimiento.NombreUsuario = User.Identity.Name;

                    CuentasBancarias_Movimientos.Add(CuentasBancarias_Movimiento);

                }

                nSaldoActualCuentaBancaria = nSaldoAnteriorCuentaBancaria + nMontoDebitos + nMontoCreditos;

                // ----------------------------------------------------------------------------------------------
                // agregamos un último registro de movimientos a la tabla 'temporal' de movimientos, con el
                // monto de saldo final (o actual) determinado antes

                nOrdenRegistroMovimientos += 1;

                CuentasBancarias_Movimiento = new tTempWebReport_DisponibilidadBancos2();

                CuentasBancarias_Movimiento.CuentaInterna = cb.CuentaInterna;
                CuentasBancarias_Movimiento.Transaccion = 001;
                CuentasBancarias_Movimiento.Tipo = "SA";
                CuentasBancarias_Movimiento.Orden = nOrdenRegistroMovimientos;
                CuentasBancarias_Movimiento.Fecha = dFechaFinalPeriodo;
                CuentasBancarias_Movimiento.Concepto = "Saldo actual del período";
                CuentasBancarias_Movimiento.Monto = nSaldoActualCuentaBancaria;
                CuentasBancarias_Movimiento.CiaContab = cb.Cia;
                CuentasBancarias_Movimiento.NombreUsuario = User.Identity.Name;

                CuentasBancarias_Movimientos.Add(CuentasBancarias_Movimiento);

                // -----------------------------------------------------------------------------------------
                // nov/08: debemos tomar en cuenta el monto restringido que pueda existir para una cuenta
                // bancaria

                var queryMontoRestringido = 
                    from mr in dbBancos.Disponibilidad_MontosRestringidos 
                       where 
                       mr.CuentaBancaria == nCuentaInterna && 
                       mr.Fecha <= dFechaFinalPeriodo && 
                       mr.SuspendidoFlag == false && 
                       (mr.DesactivarEl == null || mr.DesactivarEl > dFechaFinalPeriodo) 
                        orderby mr.Fecha 
                        select mr; 

                decimal nTotalMontoRestringido = 0;
                Int16 nRecCountMontoRestringido = 0;

                // nótese como agregamos un registro a la tabla Disponibilidad_MontosRestringidos_ConsultaDisponibilidad
                // por cada monto restringido leído para la cuenta bancaria.

                Disponibilidad_MontosRestringidos_ConsultaDisponibilidad MyRegistroMontosRestringido;
                List<Disponibilidad_MontosRestringidos_ConsultaDisponibilidad> MyRegistroMontosRestringido_Lista = new List<Disponibilidad_MontosRestringidos_ConsultaDisponibilidad>();

                foreach (var MyQueryMontoRestringido in queryMontoRestringido) {

                    // Ok, existe uno (o varios) montos restringidos grabados que aplican a la cuenta bancaria y el
                    // período de la consulta; grabamos dos registros: uno con el monto restringido y uno con el
                    // nuevo saldo

                    nOrdenRegistroMovimientos += 1;
                    nRecCountMontoRestringido += 1;

                    CuentasBancarias_Movimiento = new tTempWebReport_DisponibilidadBancos2();

                    CuentasBancarias_Movimiento.CuentaInterna = cb.CuentaInterna;
                    CuentasBancarias_Movimiento.Transaccion = nRecCountMontoRestringido;
                    CuentasBancarias_Movimiento.Tipo = "MR";
                    CuentasBancarias_Movimiento.Orden = nOrdenRegistroMovimientos;
                    CuentasBancarias_Movimiento.Fecha = MyQueryMontoRestringido.Fecha;
                    CuentasBancarias_Movimiento.Concepto = MyQueryMontoRestringido.Comentarios;
                    CuentasBancarias_Movimiento.Monto = MyQueryMontoRestringido.Monto;
                    CuentasBancarias_Movimiento.CiaContab = cb.Cia;
                    CuentasBancarias_Movimiento.NombreUsuario = User.Identity.Name;

                    CuentasBancarias_Movimientos.Add(CuentasBancarias_Movimiento);

                    nTotalMontoRestringido += MyQueryMontoRestringido.Monto;

                    // ------------------------------------------------------------------------------

                    MyRegistroMontosRestringido = new Disponibilidad_MontosRestringidos_ConsultaDisponibilidad();

                    MyRegistroMontosRestringido.ID = MyQueryMontoRestringido.ID;
                    MyRegistroMontosRestringido.CiaContab = MyQueryMontoRestringido.CuentasBancaria.Cia;
                    MyRegistroMontosRestringido.Moneda = MyQueryMontoRestringido.CuentasBancaria.Moneda;
                    MyRegistroMontosRestringido.CuentaBancaria = MyQueryMontoRestringido.CuentaBancaria;
                    MyRegistroMontosRestringido.Fecha = MyQueryMontoRestringido.Fecha;
                    MyRegistroMontosRestringido.Monto = MyQueryMontoRestringido.Monto;
                    MyRegistroMontosRestringido.Comentarios = MyQueryMontoRestringido.Comentarios;
                    MyRegistroMontosRestringido.DesactivarEl = MyQueryMontoRestringido.DesactivarEl;
                    MyRegistroMontosRestringido.NombreUsuario = User.Identity.Name;

                    MyRegistroMontosRestringido_Lista.Add(MyRegistroMontosRestringido);

                }

                if (nRecCountMontoRestringido > 0) {
                    dbBancos.Disponibilidad_MontosRestringidos_ConsultaDisponibilidads.InsertAllOnSubmit(MyRegistroMontosRestringido_Lista);

                    try {
                        dbBancos.SubmitChanges();
                    }
                    catch (Exception ex) {
                        dbBancos.Dispose();

                        ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br />" + 
                            "El mensaje específico de error es: " + ex.Message + "<br /><br />";
                        ErrMessage_Span.Style["display"] = "block";
                        return;
                    }
                }


                // si se encontraron registros de monto restringido, agregamos un registro final con el
                // saldo final de la cuenta

                if (nRecCountMontoRestringido > 0) {
                    nOrdenRegistroMovimientos += 1;

                    CuentasBancarias_Movimiento = new tTempWebReport_DisponibilidadBancos2();

                    CuentasBancarias_Movimiento.CuentaInterna = cb.CuentaInterna;
                    CuentasBancarias_Movimiento.Transaccion = 001;
                    CuentasBancarias_Movimiento.Tipo = "TO";
                    CuentasBancarias_Movimiento.Orden = nOrdenRegistroMovimientos;
                    CuentasBancarias_Movimiento.Fecha = dFechaFinalPeriodo;
                    CuentasBancarias_Movimiento.Concepto = "Saldo disponible del período";
                    CuentasBancarias_Movimiento.Monto = nSaldoActualCuentaBancaria + nTotalMontoRestringido;
                    CuentasBancarias_Movimiento.CiaContab = cb.Cia;
                    CuentasBancarias_Movimiento.NombreUsuario = User.Identity.Name;

                    CuentasBancarias_Movimientos.Add(CuentasBancarias_Movimiento);
                }



                // -----------------------------------------------------------------------------------------
                // leemos los cheques no entregados hasta la fecha para agregarlos como movimientos y
                // mostrar un saldo disponible que incluya este monto


                var query2 = from mb in dbBancos.MovimientosBancarios 
                where mb.Chequera.CuentasBancaria.CuentaInterna == nCuentaInterna && 
                      mb.Fecha <= dFechaFinalPeriodo && 
                      mb.Tipo == "CH" && 
                      mb.FechaEntregado == null && 
                      mb.Monto != 0 && 
                      mb.Chequera.CuentasBancaria.Compania.Numero == nCiaContab 
                orderby mb.Fecha 
                select new { mb.Chequera.CuentasBancaria.CuentaInterna, 
                        mb.Transaccion, 
                        mb.Fecha, 
                        mb.ProvClte, 
                        mb.Beneficiario, 
                        mb.Concepto, 
                        mb.Monto}; 


                Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad MyChequesNoEntregados_ConsultaDisponibilidad;
                List<Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad> MyChequesNoEntregados_ConsultaDisponibilidad_Lista = new List<Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad>();

                decimal nMontoChequesNoEntregados = 0;

                foreach (var MyQuery2 in query2) {

                    MyChequesNoEntregados_ConsultaDisponibilidad = new Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad();

                    MyChequesNoEntregados_ConsultaDisponibilidad.CiaContab = cb.Cia;
                    MyChequesNoEntregados_ConsultaDisponibilidad.CuentaBancaria = nCuentaInterna;
                    MyChequesNoEntregados_ConsultaDisponibilidad.Fecha = MyQuery2.Fecha;
                    MyChequesNoEntregados_ConsultaDisponibilidad.Transaccion = MyQuery2.Transaccion;
                    MyChequesNoEntregados_ConsultaDisponibilidad.ProvClte = MyQuery2.ProvClte;
                    MyChequesNoEntregados_ConsultaDisponibilidad.Beneficiario = MyQuery2.Beneficiario;
                    MyChequesNoEntregados_ConsultaDisponibilidad.Concepto = MyQuery2.Concepto;
                    MyChequesNoEntregados_ConsultaDisponibilidad.Monto = MyQuery2.Monto;
                    MyChequesNoEntregados_ConsultaDisponibilidad.NombreUsuario = User.Identity.Name;

                    MyChequesNoEntregados_ConsultaDisponibilidad_Lista.Add(MyChequesNoEntregados_ConsultaDisponibilidad);
                    nMontoChequesNoEntregados += MyQuery2.Monto;

                }

                if (query2.Count() > 0) {

                    // agregamos un registro a la tabla de movimientos con un total para los cheques no entregados

                    nOrdenRegistroMovimientos += 1;

                    CuentasBancarias_Movimiento = new tTempWebReport_DisponibilidadBancos2();

                    CuentasBancarias_Movimiento.CuentaInterna = cb.CuentaInterna;
                    CuentasBancarias_Movimiento.Transaccion = 001;
                    CuentasBancarias_Movimiento.Tipo = "NE";
                    CuentasBancarias_Movimiento.Orden = nOrdenRegistroMovimientos;
                    CuentasBancarias_Movimiento.Fecha = dFechaFinalPeriodo;
                    CuentasBancarias_Movimiento.Concepto = "Monto total en cheques no entregados";
                    CuentasBancarias_Movimiento.Monto = (nMontoChequesNoEntregados * -1);
                    CuentasBancarias_Movimiento.CiaContab = cb.Cia;
                    CuentasBancarias_Movimiento.NombreUsuario = User.Identity.Name;

                    CuentasBancarias_Movimientos.Add(CuentasBancarias_Movimiento);

                    // ahora agregamos cada cheque no entregado a una tabla para que el usuario los pueda
                    // consultar en detalle

                    dbBancos.Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidads.InsertAllOnSubmit(MyChequesNoEntregados_ConsultaDisponibilidad_Lista);

                    try {
                        dbBancos.SubmitChanges();
                    }
                    catch (Exception ex) {
                        dbBancos.Dispose();

                        ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br />" + 
                            "El mensaje específico de error es: " + ex.Message + "<br /><br />";
                        ErrMessage_Span.Style["display"] = "block";
                        return;
                    }
                }

                // si se encontraron cheques no entregados, agregamos un registro final con el
                // saldo final de la cuenta

                if (query2.Count() > 0) {
                    nOrdenRegistroMovimientos += 1;

                    CuentasBancarias_Movimiento = new tTempWebReport_DisponibilidadBancos2();

                    CuentasBancarias_Movimiento.CuentaInterna = cb.CuentaInterna;
                    CuentasBancarias_Movimiento.Transaccion = 001;
                    CuentasBancarias_Movimiento.Tipo = "TC";
                    CuentasBancarias_Movimiento.Orden = nOrdenRegistroMovimientos;
                    CuentasBancarias_Movimiento.Fecha = dFechaFinalPeriodo;
                    CuentasBancarias_Movimiento.Concepto = "Saldo disponible del período";

                    // como el monto leído para los cheques no entregados es siempre negativo, lo convertimos a
                    // positivo pues queremos agregarlo al saldo disponible

                    CuentasBancarias_Movimiento.Monto = nSaldoActualCuentaBancaria + nTotalMontoRestringido + (nMontoChequesNoEntregados * -1);
                    CuentasBancarias_Movimiento.CiaContab = cb.Cia;
                    CuentasBancarias_Movimiento.NombreUsuario = User.Identity.Name;

                    CuentasBancarias_Movimientos.Add(CuentasBancarias_Movimiento);
                }

                // ----------------------------------------------------------------------------------------------

                // agregamos un registro con la cuenta bancaria y su saldo a la 1ra. tabla 'temporal'
                // NOTESE como agregamos el monto restringido que pudo ser registrado para la cuenta
                // y el monto en cheques no entregados que pueda existir

                CuentaBancaria = new tTempWebReport_DisponibilidadBanco();

                CuentaBancaria.CuentaInterna = cb.CuentaInterna;

                CuentaBancaria.CuentaBancaria = cb.CuentaBancaria;
                CuentaBancaria.NombreCiaContab = cb.Compania.NombreCorto;

                if  (cb.Agencia1.Banco1.NombreCorto != null)
                    CuentaBancaria.NombreBanco = cb.Agencia1.Banco1.NombreCorto; 
                else
                    CuentaBancaria.NombreBanco = "indefinido"; 

                CuentaBancaria.NombreMoneda = cb.Moneda1.Descripcion;
                CuentaBancaria.SimboloMoneda = cb.Moneda1.Simbolo;

                CuentaBancaria.FechaSaldoAnterior = dFechaInicialPeriodo;
                CuentaBancaria.SaldoAnterior = nSaldoAnteriorCuentaBancaria;
                CuentaBancaria.Debitos = nMontoDebitos;
                CuentaBancaria.Creditos = nMontoCreditos;
                CuentaBancaria.SaldoActual = nSaldoActualCuentaBancaria;
                CuentaBancaria.MontoRestringido = nTotalMontoRestringido;
                CuentaBancaria.SaldoActual2 = nSaldoActualCuentaBancaria + nTotalMontoRestringido;
                CuentaBancaria.MontoChequesNoEntregados = nMontoChequesNoEntregados;
                CuentaBancaria.SaldoActual3 = nSaldoActualCuentaBancaria + nTotalMontoRestringido + (nMontoChequesNoEntregados * -1);
                CuentaBancaria.FechaSaldoActual = dFechaFinalPeriodo;
                CuentaBancaria.CiaContab = cb.Cia;
                CuentaBancaria.NombreUsuario = User.Identity.Name;

                CuentasBancarias.Add(CuentaBancaria);

                nRecCount += 1;

            }

            // ----------------------------------------------------------------------------------------------
            // agregamos la lista de registros a la tabla en el DataContext y luego hacemos el SubmitChanges

            dbBancos.tTempWebReport_DisponibilidadBancos2s.InsertAllOnSubmit(CuentasBancarias_Movimientos);
            dbBancos.tTempWebReport_DisponibilidadBancos.InsertAllOnSubmit(CuentasBancarias);

            // si el usuario registra alguna fecha de entregado para un cheque en forma errada, la instrucción que sigue fallará 
            // intentamos adelantarnos a esta situación ... 

            DateTime fechaMuyAntigua = new DateTime(1960, 1, 1); 
            DateTime fechaMuyFutura = new DateTime(9000, 1, 1);

            var queryMovimientosFechaErrada = CuentasBancarias_Movimientos.
                Where(c => (c.Fecha < fechaMuyAntigua || c.Fecha > fechaMuyFutura) || (c.FechaEntregado < fechaMuyAntigua || c.FechaEntregado > fechaMuyFutura)).
                FirstOrDefault(); 

            if (queryMovimientosFechaErrada != null)
            {
                ErrMessage_Span.InnerHtml = "Error: hemos encontrado que, al menos uno, de los movimientos que corresponden a esta consulta, " +
                    "tiene un valor para la fecha o fecha de entrega, que no es un valor válido.<br />" +
                    "los datos del movimiento mencionado son:<br />" + 
                    "Número: " + queryMovimientosFechaErrada.Transaccion + "; " +
                    "Compañía: " + queryMovimientosFechaErrada.NombreProveedorCliente + "; " +
                    "Concepto: " + queryMovimientosFechaErrada.Concepto + "; " +
                    "Monto: " + queryMovimientosFechaErrada.Monto.ToString("N2") + "; " +
                    "Fecha: " + queryMovimientosFechaErrada.Fecha.ToString("dd-MMM-yyyy") + "; " +
                    "Fecha de entrega: " + 
                    (queryMovimientosFechaErrada.FechaEntregado != null ? queryMovimientosFechaErrada.FechaEntregado.Value.ToString("dd-MMM-yyyy") : "sin un valor asignado") + ".";
                ErrMessage_Span.Style["display"] = "block";
                return;
            }
        

            try {
                dbBancos.SubmitChanges();
            }
            catch (Exception ex) {
                dbBancos.Dispose();

                ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar ejecutar una operación " + 
                    "de acceso a la base de datos. <br /> El mensaje específico de error es: " + 
                    ex.Message + "<br /><br />";
                ErrMessage_Span.Style["display"] = "block";
                return;
            }

            // ------------------------------------------------------------------------------------------------

            if (nRecCount == 0) {

                // Gets a reference to a Label control that is not in a
                // ContentPlaceHolder control

                HtmlTableCell MyTableCell;
                MyTableCell = (HtmlTableCell)Master.FindControl("MessageSpace_TableCell");
                if (!(MyTableCell == null)) {
                    MyTableCell.InnerHtml = "<br/><p><font color='#FF0000'>" + 
                        "* no existen registros que cumplan el criterio de selección que Ud. ha indicado." + 
                        "</font></p>";
                }

                return;
            }

            SaldosCuentasBancarias_SqlDataSource.SelectParameters["NombreUsuario"].DefaultValue = 
                User.Identity.Name;

        }

        protected void ConsultaDisponibilidad_ListView_SelectedIndexChanged(object sender, EventArgs e)
        {
            ListView MyListView = (ListView)sender;

            int MyDisplayIndex = ConsultaDisponibilidad_ListView.SelectedIndex;

            // por alguna razón, ListView.SelectedIndex no se inicializa con el indice del row seleccionado en el
            // evento ListView.ItemCommand (esto no lo entiendo?!). Por esta razón, usamos la variable 'global'
            // que sigue; cuando es 'Select', es que viene de ListView.ItemCommand = Select
            // (nuevamente: hay algo que no entiendo aquí)

            DataKey MyDataKeys = ConsultaDisponibilidad_ListView.SelectedDataKey;

            Movimientos_SqlDataSource.SelectParameters[0].DefaultValue = MyDataKeys.Values[0].ToString();
            Movimientos_SqlDataSource.SelectParameters[1].DefaultValue = User.Identity.Name;
            Movimientos_SqlDataSource.SelectParameters[2].DefaultValue = MyDataKeys.Values[1].ToString();

            Movimientos_ListView.DataBind();

            ListViewItem MyListViewItem = MyListView.Items[MyListView.SelectedIndex];

            Label MyCuentaBancaria_Label = (Label)MyListViewItem.FindControl("CuentaBancaria_Label");
            Label SimboloMoneda_Label = (Label)MyListViewItem.FindControl("SimboloMoneda_Label");
            Label NombreBanco_Label = (Label)MyListViewItem.FindControl("NombreBanco_Label");
            Label NombreCiaContab_Label = (Label)MyListViewItem.FindControl("NombreCiaContab_Label");

            DatosCuenta_H5.InnerHtml = "Movimientos para la cuenta bancaria seleccionada: <br />" + 
                MyCuentaBancaria_Label.Text + "&nbsp;&nbsp;" + SimboloMoneda_Label.Text + 
                "&nbsp;&nbsp;" + NombreBanco_Label.Text + "&nbsp;&nbsp;" + 
                NombreCiaContab_Label.Text;

            ConsultaDisponibilidad_TabContainer.ActiveTabIndex = 1;
        }

        protected string FormatColorRow(string theData)
        {

            switch (theData)
            {
                case "IN":
                case "SA":
                case "TO":
                case "TC":
                    return "style='BACKGROUND-COLOR:#EFF3FF'";
                case "MR":
                    return "style='BACKGROUND-COLOR:#FFE8E5'";
                case "NE":
                    return "style='BACKGROUND-COLOR:#ADC1FF'";
                default:
                    return null;
            }

        }

    }
}
