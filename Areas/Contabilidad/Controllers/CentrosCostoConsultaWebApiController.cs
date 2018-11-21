using ContabSysNet_Web.Areas.Contabilidad.Models;
using ContabSysNet_Web.Areas.Contabilidad.Models.CentrosCostoConsulta;
using ContabSysNet_Web.Areas.Contabilidad.Models.mongodb.dbContab;
using ContabSysNet_Web.ModelosDatos_EF.Contab;
using MongoDB.Driver;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace ContabSysNet_Web.Areas.Contabilidad.Controllers
{
    public class CentrosCostoConsultaWebApiController : ApiController
    {
        [HttpGet]
        [Route("api/contabilidad/CentrosCostoConsulta/CargaDatosIniciales")]
        public HttpResponseMessage CargaDatosIniciales()
        {
            if (!User.Identity.IsAuthenticated)
            {
                var result = new
                {
                    ErrorFlag = true,
                    ErrorMessage = "Error: por favor haga un login a esta aplicación, y luego regrese a ejecutar esta función."
                };

                return Request.CreateResponse(HttpStatusCode.OK, result);
            }

            try
            {
                using (dbContab_Contab_Entities context = new dbContab_Contab_Entities())
                {
                    tCiaSeleccionada ciaSeleccionada = context.tCiaSeleccionadas.Where(c => c.UsuarioLS == User.Identity.Name).FirstOrDefault();

                    if (ciaSeleccionada == null)
                    {
                        var result = new
                        {
                            ErrorFlag = true,
                            ErrorMessage = "Error: Ud. debe seleccionar una cia Contab antes de intentar usar esta función."
                        };

                        return Request.CreateResponse(HttpStatusCode.OK, result);
                    }

                    var monedas = context.Monedas.OrderBy(m => m.Descripcion).Select(m => new { ID = m.Moneda1, Descripcion = m.Descripcion }).ToList();
                    var centrosCosto = context.CentrosCostoes.OrderBy(c => c.Descripcion).Select(c => new { ID = c.CentroCosto, Descripcion = c.Descripcion }).ToList();

                    var result2 = new
                    {
                        ErrorFlag = false,
                        CiaContabSeleccionada_Nombre = ciaSeleccionada.Compania.Nombre,
                        CiaContabSeleccionada_Numero = ciaSeleccionada.Compania.Numero,
                        Monedas = monedas,
                        CentrosCosto = centrosCosto
                    };

                    return Request.CreateResponse(HttpStatusCode.OK, result2);
                }
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                if (ex.InnerException != null)
                    message += "<br />" + ex.InnerException.Message;

                var result = new
                {
                    ErrorFlag = true,
                    ErrorMessage = "Se ha producido un error mientras se ejecutaba el proceso. El mensaje específico del error es:<br />" + message
                };

                return Request.CreateResponse(HttpStatusCode.OK, result);
            }
        }


        [HttpPost]
        //[Route("api/contabilidad/CentrosCostoConsulta/PrepararDatosConsulta")]
        public HttpResponseMessage PrepararDatosConsulta(JObject filter)
        {
            if (!User.Identity.IsAuthenticated)
            {
                var result = new
                {
                    ErrorFlag = true,
                    ErrorMessage = "Error: por favor haga un login a esta aplicación, y luego regrese a ejecutar esta función."
                };

                return Request.CreateResponse(HttpStatusCode.OK, result);
            }

            try
            {
                dynamic filtro = filter;

                int ciaContabSeleccionada = filtro.ciaContabSeleccionada; 
                string fechaInicioPeriodo = filtro.desde;
                string fechaFinalPeriodo = filtro.hasta;
                int moneda = filtro.moneda;
                bool incluirCuentasSinMovimientos = filtro.cuentasSinMovimientos;

                List<int> centrosCostoList = new List<int>();

                foreach (int cc in filtro.centrosCosto)
                    centrosCostoList.Add(cc); 

                // preparamos los criterios que serán usados para seleccionar los movimientos 

                var criteriosFiltroConsulta = new
                {
                    ciaContabSeleccionada = ciaContabSeleccionada,
                    fechaInicioPeriodo = (DateTime)Convert.ToDateTime(fechaInicioPeriodo),
                    fechaFinalPeriodo = (DateTime)Convert.ToDateTime(fechaFinalPeriodo),
                    moneda = moneda,
                    centrosCostoList = centrosCostoList,
                    incluirCuentasSinMovimientos = incluirCuentasSinMovimientos
                }; 


                // --------------------------------------------------------------------------------------------------------------------------
                // establecemos una conexión a mongodb 

                var client = new MongoClient("mongodb://localhost");
                var mongoDataBase = client.GetDatabase("dbContab");

                var consultaGeneralCentrosCosto = mongoDataBase.GetCollection<Temp_CentrosCosto_Consulta>("Temp_CentrosCosto_Consulta");

                try
                {
                    // --------------------------------------------------------------------------------------------------------------------------
                    // primero que todo, eliminamos (en mongo) los registros que puedan existir para el usuario 
                    var builder = Builders<Temp_CentrosCosto_Consulta>.Filter;
                    var mongoFilter = builder.Eq(x => x.Usuario, User.Identity.Name);

                    consultaGeneralCentrosCosto.DeleteManyAsync(mongoFilter);
                }
                catch (Exception ex)
                {
                    string message = ex.Message;
                    if (ex.InnerException != null)
                        message += "<br />" + ex.InnerException.Message;

                    var result = new
                    {
                        ErrorFlag = true,
                        ErrorMessage = "Se producido un error mientras se ejecutaba el proceso. El mensaje específico del error es:<br />" + message
                    };

                    return Request.CreateResponse(HttpStatusCode.OK, result);
                }


                // leemos los movimientos que correspondan al criterio indicado por el usuario y los grabamos al collection en mongo 

                dbContab_Contab_Entities contabCtx = new dbContab_Contab_Entities();

                // para usar más adelante, grabamos a una lista las cuentas de gastos e ingresos 
                List<string> cuentasGastosIngresos_List = new List<string>();

                ParametrosContab parametrosContab = contabCtx.ParametrosContabs.Where(p => p.Cia == criteriosFiltroConsulta.ciaContabSeleccionada).
                                                                                FirstOrDefault();

                if (parametrosContab != null)
                {
                    if (parametrosContab.Ingresos1 != null)
                    {
                        string cuentaContable = contabCtx.CuentasContables.Where(c => c.ID == parametrosContab.Ingresos1.Value).Select(c => c.Cuenta).FirstOrDefault();
                        if (!string.IsNullOrEmpty(cuentaContable))
                            cuentasGastosIngresos_List.Add(cuentaContable);
                    }

                    if (parametrosContab.Ingresos2 != null)
                    {
                        string cuentaContable = contabCtx.CuentasContables.Where(c => c.ID == parametrosContab.Ingresos2.Value).Select(c => c.Cuenta).FirstOrDefault();
                        if (!string.IsNullOrEmpty(cuentaContable))
                            cuentasGastosIngresos_List.Add(cuentaContable);
                    }

                    if (parametrosContab.Ingresos3 != null)
                    {
                        string cuentaContable = contabCtx.CuentasContables.Where(c => c.ID == parametrosContab.Ingresos3.Value).Select(c => c.Cuenta).FirstOrDefault();
                        if (!string.IsNullOrEmpty(cuentaContable))
                            cuentasGastosIngresos_List.Add(cuentaContable);
                    }

                    if (parametrosContab.Ingresos4 != null)
                    {
                        string cuentaContable = contabCtx.CuentasContables.Where(c => c.ID == parametrosContab.Ingresos4.Value).Select(c => c.Cuenta).FirstOrDefault();
                        if (!string.IsNullOrEmpty(cuentaContable))
                            cuentasGastosIngresos_List.Add(cuentaContable);
                    }

                    if (parametrosContab.Ingresos5 != null)
                    {
                        string cuentaContable = contabCtx.CuentasContables.Where(c => c.ID == parametrosContab.Ingresos5.Value).Select(c => c.Cuenta).FirstOrDefault();
                        if (!string.IsNullOrEmpty(cuentaContable))
                            cuentasGastosIngresos_List.Add(cuentaContable);
                    }

                    if (parametrosContab.Ingresos6 != null)
                    {
                        string cuentaContable = contabCtx.CuentasContables.Where(c => c.ID == parametrosContab.Ingresos6.Value).Select(c => c.Cuenta).FirstOrDefault();
                        if (!string.IsNullOrEmpty(cuentaContable))
                            cuentasGastosIngresos_List.Add(cuentaContable);
                    }

                    if (parametrosContab.Egresos1 != null)
                    {
                        string cuentaContable = contabCtx.CuentasContables.Where(c => c.ID == parametrosContab.Egresos1.Value).Select(c => c.Cuenta).FirstOrDefault();
                        if (!string.IsNullOrEmpty(cuentaContable))
                            cuentasGastosIngresos_List.Add(cuentaContable);
                    }

                    if (parametrosContab.Egresos2 != null)
                    {
                        string cuentaContable = contabCtx.CuentasContables.Where(c => c.ID == parametrosContab.Egresos2.Value).Select(c => c.Cuenta).FirstOrDefault();
                        if (!string.IsNullOrEmpty(cuentaContable))
                            cuentasGastosIngresos_List.Add(cuentaContable);
                    }

                    if (parametrosContab.Egresos3 != null)
                    {
                        string cuentaContable = contabCtx.CuentasContables.Where(c => c.ID == parametrosContab.Egresos3.Value).Select(c => c.Cuenta).FirstOrDefault();
                        if (!string.IsNullOrEmpty(cuentaContable))
                            cuentasGastosIngresos_List.Add(cuentaContable);
                    }

                    if (parametrosContab.Egresos4 != null)
                    {
                        string cuentaContable = contabCtx.CuentasContables.Where(c => c.ID == parametrosContab.Egresos4.Value).Select(c => c.Cuenta).FirstOrDefault();
                        if (!string.IsNullOrEmpty(cuentaContable))
                            cuentasGastosIngresos_List.Add(cuentaContable);
                    }

                    if (parametrosContab.Egresos5 != null)
                    {
                        string cuentaContable = contabCtx.CuentasContables.Where(c => c.ID == parametrosContab.Egresos5.Value).Select(c => c.Cuenta).FirstOrDefault();
                        if (!string.IsNullOrEmpty(cuentaContable))
                            cuentasGastosIngresos_List.Add(cuentaContable);
                    }

                    if (parametrosContab.Egresos6 != null)
                    {
                        string cuentaContable = contabCtx.CuentasContables.Where(c => c.ID == parametrosContab.Egresos6.Value).Select(c => c.Cuenta).FirstOrDefault();
                        if (!string.IsNullOrEmpty(cuentaContable))
                            cuentasGastosIngresos_List.Add(cuentaContable);
                    }
                }

                var query = contabCtx.dAsientos.Include("Asiento").
                                                Include("Asiento.Compania").
                                                Include("Asiento.Moneda1").
                                                Include("CentrosCosto").
                                                Include("CuentasContable").
                                                Include("CuentasContable.tGruposContable").
                                                Where(d => d.Asiento.Cia == criteriosFiltroConsulta.ciaContabSeleccionada).
                                                Where(d => d.Asiento.Moneda == criteriosFiltroConsulta.moneda).
                                                Where(d => d.CentroCosto != null).
                                                Where(d => d.Asiento.Fecha >= criteriosFiltroConsulta.fechaInicioPeriodo && 
                                                           d.Asiento.Fecha <= criteriosFiltroConsulta.fechaFinalPeriodo).
                                                Where(d => (criteriosFiltroConsulta.centrosCostoList.Count() == 0) || 
                                                           (criteriosFiltroConsulta.centrosCostoList.Contains(d.CentroCosto.Value))).
                                                Select(d => new 
                                                {
                                                    CiaContabID = d.Asiento.Cia,
                                                    CiaContabNombre = d.Asiento.Compania.Nombre, 
                                                    CiaContabAbreviatura = d.Asiento.Compania.Abreviatura,

                                                    MonedaID = d.Asiento.Moneda,
                                                    MonedaDescripcion = d.Asiento.Moneda1.Descripcion,
                                                    MonedaSimbolo = d.Asiento.Moneda1.Simbolo,

                                                    CentroCostoID = d.CentroCosto.Value,
                                                    CentroCostoNombre = d.CentrosCosto.Descripcion,
                                                    CentroCostoAbreviatura = d.CentrosCosto.DescripcionCorta,

                                                    CuentaContableID = d.CuentaContableID,
                                                    CuentaContableGrupo = d.CuentasContable.tGruposContable.Descripcion, 
                                                    CuentaContableGrupoOrdenarPor = d.CuentasContable.tGruposContable.OrdenBalanceGeneral, 
                                                    CuentaContableNombre = d.CuentasContable.Descripcion,
                                                    CuentaContableCuenta = d.CuentasContable.Cuenta, 

                                                    Descripcion = d.Descripcion,
                                                    Fecha = d.Asiento.Fecha,
                                                    Debe = d.Debe,
                                                    Haber = d.Haber
                                                }).ToList();



                var query2 = query.GroupBy(d => new 
                    {
                        CiaContabID = d.CiaContabID,
                        CiaContabNombre = d.CiaContabNombre, 
                        CiaContabAbreviatura = d.CiaContabAbreviatura,

                        MonedaID = d.MonedaID,
                        MonedaDescripcion = d.MonedaDescripcion,
                        MonedaSimbolo = d.MonedaSimbolo,

                        CentroCostoID = d.CentroCostoID,
                        CentroCostoNombre = d.CentroCostoNombre,
                        CentroCostoAbreviatura = d.CentroCostoAbreviatura,

                        CuentaContableID = d.CuentaContableID,
                        CuentaContableGrupo = d.CuentaContableGrupo, 
                        CuentaContableGrupoOrdenarPor = d.CuentaContableGrupoOrdenarPor, 
                        CuentaContableNombre = d.CuentaContableNombre,
                        CuentaContableCuenta = d.CuentaContableCuenta
                    }).ToList().
                    Select(x => new 
                    {
                        CiaContabID = x.Key.CiaContabID,
                        CiaContabNombre = x.Key.CiaContabNombre, 
                        CiaContabAbreviatura = x.Key.CiaContabAbreviatura,

                        MonedaID = x.Key.MonedaID,
                        MonedaDescripcion = x.Key.MonedaDescripcion,
                        MonedaSimbolo = x.Key.MonedaSimbolo,

                        CentroCostoID = x.Key.CentroCostoID,
                        CentroCostoNombre = x.Key.CentroCostoNombre,
                        CentroCostoAbreviatura = x.Key.CentroCostoAbreviatura, 

                        CuentaContableID = x.Key.CuentaContableID,
                        CuentaContableGrupo = x.Key.CuentaContableGrupo, 
                        CuentaContableGrupoOrdenarPor = x.Key.CuentaContableGrupoOrdenarPor, 
                        CuentaContableNombre = x.Key.CuentaContableNombre,
                        CuentaContableCuenta = x.Key.CuentaContableCuenta,
                        Items = x.Select(y =>  new 
                        {
                            Descripcion = y.Descripcion,
                            Fecha = y.Fecha,
                            Debe = y.Debe,
                            Haber = y.Haber
                        })
                    }).ToList(); 


                Temp_CentrosCosto_Consulta movimiento;
                List<Temp_CentrosCosto_Consulta> movimientos = new List<Temp_CentrosCosto_Consulta>(); 

                // TODO: implementar luego ... 
                // para mostrar el progreso de la tarea al usuario 

                //ProgresoTareaEnCurso progress = new ProgresoTareaEnCurso()
                //    {
                //        Val = 0,
                //        Max = query2.Count()
                //    };

                //var session = HttpContext.Current.Session;
                //if (session != null)
                //{
                //    session["progressMax"] = progress.Max;
                //    session["progressValue"] = 0;
                //    session["progressMessage"] = null;
                //}

                // determinamos el 1er. día del año fiscal, para calcular los saldos de cuentas nominales a partir de allí ... 

                DateTime primerDiaAnoFiscal = determinar1erDiaAnoFiscal(criteriosFiltroConsulta.fechaInicioPeriodo, 
                                                                        contabCtx, 
                                                                        criteriosFiltroConsulta.ciaContabSeleccionada); 

                if (primerDiaAnoFiscal == new DateTime(1960, 1, 1))
                {
                    // la función no pudo leer la tabla de nombres de meses; notificamos con un error ... 

                    var result = new
                    {
                        ErrorFlag = true,
                        ErrorMessage = "Error: no se ha podido leer la tabla de 'nombres de meses' para la compañía seleccionada. Por favor revise."
                    };

                    return Request.CreateResponse(HttpStatusCode.OK, result);
                }

                foreach (var m in query2)
                {
                    // antes de agregar los movimientos para cada CC-cuentaContable, determinamos el saldo inicial para la misma ... 

                    // determinamos si la cuenta es nominal (gastos/ingresos); de serlo, su saldo inicial del año fiscal debe ser cero 

                    bool gastosIngresos = cuentasGastosIngresos_List.Any(c => m.CuentaContableCuenta.StartsWith(c)); 

                    decimal? saldoInicialCuentaContable = null;

                    if (!gastosIngresos)
                        // la cuenta no es nominal; construimos su saldo inicial desde el inicio de la contabilidad 
                        saldoInicialCuentaContable = contabCtx.dAsientos.Include("Asiento").
                                                                              Where(d => d.Asiento.Fecha < criteriosFiltroConsulta.fechaInicioPeriodo).
                                                                              Where(d => d.Asiento.Cia == m.CiaContabID).
                                                                              Where(d => d.Asiento.Moneda == m.MonedaID).
                                                                              Where(d => d.CuentaContableID == m.CuentaContableID).
                                                                              Where(d => d.CentroCosto != null && d.CentroCosto == m.CentroCostoID).
                                                                              Select(d => (decimal?)(d.Debe - d.Haber)).Sum();
                    else
                        // la cuenta es nominal; construimos su saldo inicial leyendo los asientos desde el 1er. día del año fiscal hasta la fecha inicial de la consulta
                        saldoInicialCuentaContable = contabCtx.dAsientos.Include("Asiento").
                                                                              Where(d => d.Asiento.Fecha < criteriosFiltroConsulta.fechaInicioPeriodo).
                                                                              Where(d => d.Asiento.Fecha >= primerDiaAnoFiscal).
                                                                              Where(d => d.Asiento.Cia == m.CiaContabID).
                                                                              Where(d => d.Asiento.Moneda == m.MonedaID).
                                                                              Where(d => d.CuentaContableID == m.CuentaContableID).
                                                                              Where(d => d.CentroCosto != null && d.CentroCosto == m.CentroCostoID).
                                                                              Select(d => (decimal?)(d.Debe - d.Haber)).Sum();


                    if (saldoInicialCuentaContable == null)
                        saldoInicialCuentaContable = 0; 

                    // agregamos un movimiento para el centro de costo con el saldo inicial para el período 

                    movimiento = new Temp_CentrosCosto_Consulta()
                    {
                        CiaContabID = m.CiaContabID,
                        CiaContabNombre = m.CiaContabNombre,
                        CiaContabAbreviatura = m.CiaContabAbreviatura,

                        MonedaID = m.MonedaID,
                        MonedaDescripcion = m.MonedaDescripcion,
                        MonedaSimbolo = m.MonedaSimbolo,

                        CentroCostoID = m.CentroCostoID,
                        CentroCostoNombre = m.CentroCostoNombre,
                        CentroCostoAbreviatura = m.CentroCostoAbreviatura,

                        CuentaContableID = m.CuentaContableID,
                        CuentaContableGrupo = m.CuentaContableGrupo,
                        CuentaContableGrupoOrdenarPor = m.CuentaContableGrupoOrdenarPor,
                        CuentaContableNombre = m.CuentaContableNombre,
                        CuentaContableCuenta = m.CuentaContableCuenta,

                        Descripcion = "Saldo inicial del período",
                        Fecha = criteriosFiltroConsulta.fechaInicioPeriodo.AddDays(-1),
                        SaldoInicial = saldoInicialCuentaContable.Value,
                        Debe = 0,
                        Haber = 0,
                        SaldoFinal = 0,

                        Secuencia = 0,
                        Usuario = User.Identity.Name
                    };

                    movimientos.Add(movimiento); 



                    // luego de agregar un movimiento con el saldo inicial de la cuenta (para el centro de costo), agregamos todos los movimientos 
                    // que existen para el período indicado ... 

                    int secuencia = 1;
                    decimal saldoFinal = saldoInicialCuentaContable.Value; 


                    foreach (var i in m.Items.OrderBy(x => x.Fecha))
                    {
                        // Items es una lista de movimientos que existe para cada centro de costo (en realidad, para cada: Cia-Mon-CC-CuentaContable) 
                        // en query2 

                        movimiento = new Temp_CentrosCosto_Consulta()
                        {
                            CiaContabID = m.CiaContabID,
                            CiaContabNombre = m.CiaContabNombre,
                            CiaContabAbreviatura = m.CiaContabAbreviatura,

                            MonedaID = m.MonedaID,
                            MonedaDescripcion = m.MonedaDescripcion,
                            MonedaSimbolo = m.MonedaSimbolo,

                            CentroCostoID = m.CentroCostoID,
                            CentroCostoNombre = m.CentroCostoNombre,
                            CentroCostoAbreviatura = m.CentroCostoAbreviatura,

                            CuentaContableID = m.CuentaContableID,
                            CuentaContableGrupo = m.CuentaContableGrupo,
                            CuentaContableGrupoOrdenarPor = m.CuentaContableGrupoOrdenarPor,
                            CuentaContableNombre = m.CuentaContableNombre,
                            CuentaContableCuenta = m.CuentaContableCuenta,

                            Descripcion = i.Descripcion,
                            Fecha = i.Fecha,
                            SaldoInicial = 0,
                            Debe = i.Debe,
                            Haber = i.Haber,
                            SaldoFinal = 0,

                            Secuencia = secuencia,
                            Usuario = User.Identity.Name
                        };

                        movimientos.Add(movimiento); 
                        secuencia++;
                        saldoFinal += (i.Debe - i.Haber); 
                    }

                    // al final, agregamos un movimiento con el saldo final para la cuenta y centro de costo ... 

                    movimiento = new Temp_CentrosCosto_Consulta()
                    {
                        CiaContabID = m.CiaContabID,
                        CiaContabNombre = m.CiaContabNombre,
                        CiaContabAbreviatura = m.CiaContabAbreviatura,

                        MonedaID = m.MonedaID,
                        MonedaDescripcion = m.MonedaDescripcion,
                        MonedaSimbolo = m.MonedaSimbolo,

                        CentroCostoID = m.CentroCostoID,
                        CentroCostoNombre = m.CentroCostoNombre,
                        CentroCostoAbreviatura = m.CentroCostoAbreviatura,

                        CuentaContableID = m.CuentaContableID,
                        CuentaContableGrupo = m.CuentaContableGrupo,
                        CuentaContableGrupoOrdenarPor = m.CuentaContableGrupoOrdenarPor,
                        CuentaContableNombre = m.CuentaContableNombre,
                        CuentaContableCuenta = m.CuentaContableCuenta,

                        Descripcion = "Saldo final del período",
                        Fecha = criteriosFiltroConsulta.fechaFinalPeriodo,
                        SaldoInicial = 0,
                        Debe = 0,
                        Haber = 0,
                        SaldoFinal = saldoFinal,

                        Secuencia = secuencia,
                        Usuario = User.Identity.Name
                    };

                    movimientos.Add(movimiento);

                    //progress.Val++; 

                    //// intentamos avanzar el progress en intervalos de 5% (para no actualizar mucho el session) 

                    //int p = progress.Val.Value * 100 / progress.Max.Value;
                    //int y = p % 5;

                    //if (y == 0)
                    //    if (session != null)
                    //        session["progressValue"] = progress.Val;
                }

                // nos aseguramos de completar el progreso en el cliente 
                //progress.Val = null; 

                // -------------------------------------------------------------------------------------------------------------------
                // para este punto, tenemos una lista (movimientos) con todos los movimientos para los centros de costo seleccionados 
                // (en el período y otros criterios indicados por el usuario) 

                // ahora, solo si el usuario así lo indicó al indicar los criterios de la consulta, incluímos saldos de cuentas que no 
                // han tenido movimientos en el período ... 

                int cuentasSinMovimientosEnPeriodoAgregadas = 0; 

                if (criteriosFiltroConsulta.incluirCuentasSinMovimientos)
                {
                    // creamos una lista con las cuentas contables que ya se han agregado a la consulta; la idea es leer y agregar las que 
                    // no están allí, pero que tienen movimientos antes del período ... 

                    List<string> cuentasContablesAgregadasALaConsulta = movimientos.Select(c => (c.CiaContabID.ToString() + "-" +
                                                                                                 c.MonedaID.ToString() + "-" +
                                                                                                 c.CentroCostoID.ToString() + "-" + 
                                                                                                 c.CuentaContableID.ToString()).ToString()).
                                                                                     Distinct().
                                                                                     ToList(); 

                    // buscamos movimientos para el filtro indicado por el usuario que NO estén en la lista anterior (pues allí están cuentas con movimientos 
                    // en el período; debemos buscar cuentas sin movimientos en el período) 

                    var query3 = contabCtx.dAsientos.Include("Asiento").
                                                Include("CentrosCosto").
                                                Where(d => d.Asiento.Cia == criteriosFiltroConsulta.ciaContabSeleccionada).
                                                Where(d => d.Asiento.Moneda == criteriosFiltroConsulta.moneda).
                                                Where(d => d.CentroCosto != null).
                                                Where(d => d.Asiento.Fecha < criteriosFiltroConsulta.fechaInicioPeriodo).
                                                Where(d => (criteriosFiltroConsulta.centrosCostoList.Count() == 0) ||
                                                           (criteriosFiltroConsulta.centrosCostoList.Contains(d.CentroCosto.Value))).
                                                Select(d => new
                                                {
                                                    ciaContabID = d.Asiento.Cia,
                                                    monedaID = d.Asiento.Moneda,
                                                    centroCostoID = d.CentrosCosto.CentroCosto,
                                                    cuentaContableID = d.CuentaContableID
                                                }).Distinct();

                    

                    foreach (var cuentaSinMovimientosEnPeriodo in query3)
                    {
                        string pk = cuentaSinMovimientosEnPeriodo.ciaContabID.ToString() + "-" +
                                    cuentaSinMovimientosEnPeriodo.monedaID.ToString() + "-" +
                                    cuentaSinMovimientosEnPeriodo.centroCostoID.ToString() + "-" +
                                    cuentaSinMovimientosEnPeriodo.cuentaContableID.ToString(); 

                        if (!cuentasContablesAgregadasALaConsulta.Contains(pk))
                        {
                            string cuentaContable = contabCtx.CuentasContables.Where(c => c.ID == cuentaSinMovimientosEnPeriodo.cuentaContableID).
                                                                               Select(c => c.Cuenta).
                                                                               FirstOrDefault();

                            bool gastosIngresos = cuentasGastosIngresos_List.Any(c => cuentaContable.StartsWith(c));

                            decimal? saldoInicialCuentaContable = null;

                            if (!gastosIngresos)
                                // la cuenta no es nominal; construimos su saldo inicial desde el inicio de la contabilidad 
                                saldoInicialCuentaContable = contabCtx.dAsientos.Include("Asiento").
                                                                Where(d => d.Asiento.Fecha < criteriosFiltroConsulta.fechaInicioPeriodo).
                                                                Where(d => d.Asiento.Cia == cuentaSinMovimientosEnPeriodo.ciaContabID).
                                                                Where(d => d.Asiento.Moneda == cuentaSinMovimientosEnPeriodo.monedaID).
                                                                Where(d => d.CuentaContableID == cuentaSinMovimientosEnPeriodo.cuentaContableID).
                                                                Where(d => d.CentroCosto != null && d.CentroCosto == cuentaSinMovimientosEnPeriodo.centroCostoID).
                                                                Select(d => (decimal?)(d.Debe - d.Haber)).Sum();
                            else
                                // la cuenta es nominal; construimos su saldo inicial leyendo los asientos desde el 1er. día del año fiscal 
                                // hasta la fecha inicial de la consulta
                                saldoInicialCuentaContable = contabCtx.dAsientos.Include("Asiento").
                                                                Where(d => d.Asiento.Fecha < criteriosFiltroConsulta.fechaInicioPeriodo).
                                                                Where(d => d.Asiento.Fecha >= primerDiaAnoFiscal).
                                                                Where(d => d.Asiento.Cia == cuentaSinMovimientosEnPeriodo.ciaContabID).
                                                                Where(d => d.Asiento.Moneda == cuentaSinMovimientosEnPeriodo.monedaID).
                                                                Where(d => d.CuentaContableID == cuentaSinMovimientosEnPeriodo.cuentaContableID).
                                                                Where(d => d.CentroCosto != null && d.CentroCosto == cuentaSinMovimientosEnPeriodo.centroCostoID).
                                                                Select(d => (decimal?)(d.Debe - d.Haber)).Sum();


                            if (saldoInicialCuentaContable == null)
                                saldoInicialCuentaContable = 0;

                            if (saldoInicialCuentaContable != 0)
                            {
                                // agregamos un movimiento para el centro de costo con el saldo inicial para el período 

                                var datosCuenta = contabCtx.dAsientos.Include("Asiento").
                                                                      Include("Asiento.Compania").
                                                                      Include("Asiento.Moneda1").
                                                                      Include("CentrosCosto").
                                                                      Include("CuentasContable").
                                                                      Include("CuentasContable.tGruposContable").
                                                                      Where(d => d.Asiento.Cia == cuentaSinMovimientosEnPeriodo.ciaContabID).
                                                                      Where(d => d.Asiento.Moneda == cuentaSinMovimientosEnPeriodo.monedaID).
                                                                      Where(d => d.CentroCosto == cuentaSinMovimientosEnPeriodo.centroCostoID).
                                                                      Where(d => d.CuentaContableID == cuentaSinMovimientosEnPeriodo.cuentaContableID).
                                                                      Select(d => new
                                                                      {
                                                                          CiaContabNombre = d.Asiento.Compania.Nombre,
                                                                          CiaContabAbreviatura = d.Asiento.Compania.Abreviatura,

                                                                          MonedaDescripcion = d.Asiento.Moneda1.Descripcion,
                                                                          MonedaSimbolo = d.Asiento.Moneda1.Simbolo,

                                                                          CentroCostoNombre = d.CentrosCosto.DescripcionCorta,
                                                                          CentroCostoAbreviatura = d.CentrosCosto.DescripcionCorta,

                                                                          CuentaContableGrupo = d.CuentasContable.tGruposContable.Descripcion,
                                                                          CuentaContableGrupoOrdenarPor = d.CuentasContable.tGruposContable.OrdenBalanceGeneral,
                                                                          CuentaContableNombre = d.CuentasContable.Descripcion,
                                                                          CuentaContableCuenta = d.CuentasContable.Cuenta
                                                                      }).
                                                                      FirstOrDefault(); 

                                movimiento = new Temp_CentrosCosto_Consulta()
                                {
                                    CiaContabID = cuentaSinMovimientosEnPeriodo.ciaContabID,
                                    CiaContabNombre = datosCuenta.CiaContabNombre,
                                    CiaContabAbreviatura = datosCuenta.CiaContabAbreviatura,

                                    MonedaID = cuentaSinMovimientosEnPeriodo.monedaID,
                                    MonedaDescripcion = datosCuenta.MonedaDescripcion,
                                    MonedaSimbolo = datosCuenta.MonedaSimbolo,

                                    CentroCostoID = cuentaSinMovimientosEnPeriodo.centroCostoID,
                                    CentroCostoNombre = datosCuenta.CentroCostoNombre,
                                    CentroCostoAbreviatura = datosCuenta.CentroCostoAbreviatura,

                                    CuentaContableID = cuentaSinMovimientosEnPeriodo.cuentaContableID,
                                    CuentaContableGrupo = datosCuenta.CuentaContableGrupo,
                                    CuentaContableGrupoOrdenarPor = datosCuenta.CuentaContableGrupoOrdenarPor,
                                    CuentaContableNombre = datosCuenta.CuentaContableNombre,
                                    CuentaContableCuenta = datosCuenta.CuentaContableCuenta,

                                    Descripcion = "Saldo inicial del período",
                                    Fecha = criteriosFiltroConsulta.fechaInicioPeriodo.AddDays(-1),
                                    SaldoInicial = saldoInicialCuentaContable.Value,
                                    Debe = 0,
                                    Haber = 0,
                                    SaldoFinal = saldoInicialCuentaContable.Value,

                                    Secuencia = 0,
                                    Usuario = User.Identity.Name
                                };

                                movimientos.Add(movimiento);

                                cuentasSinMovimientosEnPeriodoAgregadas++; 
                            }
                        }
                    }
                }

                
                // ------------------------------------------------------------------------------------------------------------------- 
                // finalmente, agregamos los items al collection en mongo 


                foreach (Temp_CentrosCosto_Consulta item in movimientos)
                {
                    consultaGeneralCentrosCosto.InsertOneAsync(item);
                }
                    
                var result2 = new
                {
                    ErrorFlag = false,
                    ResultMessage = "Ok, este proceso se ha ejecutado en forma satisfactoria.<br />" +
                        "En total, se han registrado " + movimientos.Count().ToString() + " movimientos para producir la consulta.<br />" + 
                        "Además, se han agregado " + cuentasSinMovimientosEnPeriodoAgregadas.ToString() + " cuentas contables para centros de costo, " + 
                        "que no tuvieron movimientos en el período, pero que tienen un saldo para el inicio del mismo."
                };

                return Request.CreateResponse(HttpStatusCode.OK, result2);
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                if (ex.InnerException != null)
                    message += "<br />" + ex.InnerException.Message;

                var result = new
                {
                    ErrorFlag = true,
                    ErrorMessage = "Se producido un error mientras se ejecutaba el proceso. El mensaje específico del error es:<br />" + message
                };

                return Request.CreateResponse(HttpStatusCode.OK, result);
            }
        }


        private DateTime determinar1erDiaAnoFiscal(DateTime fechaInicialPeriodoConsulta, dbContab_Contab_Entities contabCtx, int cia) 
        {
            DateTime primerDiaAnoFiscal = new DateTime(1960, 1, 1);  

            // esta función determina, en relación a la fecha inicial del período indicado para la consulta, el 1er. dia del año fiscal 

            // leemos el 1er. mes del año fiscal 

            MesesDelAnoFiscal mesesAnoFiscal = contabCtx.MesesDelAnoFiscals.Where(m => m.MesFiscal == 1 && m.Cia == cia).FirstOrDefault();

            if (mesesAnoFiscal == null)
                return primerDiaAnoFiscal; 

            if (fechaInicialPeriodoConsulta.Month <= 12)
                // si la fecha inicial del período de la consulta es anterior o igual a diciembre, asumimos el mismo año
                primerDiaAnoFiscal = new DateTime(fechaInicialPeriodoConsulta.Year, mesesAnoFiscal.Mes, 1); 
            else
                primerDiaAnoFiscal = new DateTime(fechaInicialPeriodoConsulta.Year - 1, mesesAnoFiscal.Mes, 1);


            return primerDiaAnoFiscal; 
        }


        [HttpGet]
        //[Route("api/contabilidad/CentrosCostoConsulta/LeerProgreso")]
        public HttpResponseMessage LeerProgreso(int id)
        {
            // para reportar el progreso de la tarea en curso ... 
            if (!User.Identity.IsAuthenticated)
            {
                var result = new
                {
                    ErrorFlag = true,
                    ErrorMessage = "Error: por favor haga un login a esta aplicación, y luego regrese a ejecutar esta función."
                };

                return Request.CreateResponse(HttpStatusCode.OK, result);
            }
            else
            {
                string message = "";
                int? value = null; 
                int? max = null; 

                var session = HttpContext.Current.Session;

                if (session != null)
                {
                    if (session["progressValue"] != null)
                        value = (int)session["progressValue"];

                    if (session["progressMessage"] != null)
                        message = session["progressMessage"].ToString();

                    if (session["progressMax"] != null)
                        max = (int)session["progressMax"]; 


                    var result = new
                    {
                        value = value,
                        max = max,
                        message = message
                    };

                    return Request.CreateResponse(HttpStatusCode.OK, result);
                }
                else
                {
                    var result = new
                    {
                        value = value,
                        max = max,
                        message = message
                    };

                    return Request.CreateResponse(HttpStatusCode.OK, result);
                }
            }
        }


        [HttpGet]
        [Route("api/contabilidad/CentrosCostoConsulta/LeerJQGridPage")]
        public HttpResponseMessage LeerJQGridPage(bool _search, string nd, int rows, int page, string sidx, string sord)
        {
            jqGridData jqgridData = new jqGridData(); 

            if (!User.Identity.IsAuthenticated)
            {
                var result = new
                {
                    ErrorFlag = true,
                    ErrorMessage = "Error: por favor haga un login a esta aplicación, y luego regrese a ejecutar esta función."
                };

                return Request.CreateResponse(HttpStatusCode.OK, result);
            }

            try
            {
                // --------------------------------------------------------------------------------------------------------------------------
                // establecemos una conexión a mongodb 

                var client = new MongoClient("mongodb://localhost");
                var mongoDataBase = client.GetDatabase("dbContab");

                var consultaGeneralCentrosCosto = mongoDataBase.GetCollection<Temp_CentrosCosto_Consulta>("Temp_CentrosCosto_Consulta");

                int recordCount = consultaGeneralCentrosCosto.AsQueryable<Temp_CentrosCosto_Consulta>().Where(c => c.Usuario == User.Identity.Name).Count(); 

                // nótese como leemos una sola página para el jqGrid 

                var query = consultaGeneralCentrosCosto.AsQueryable<Temp_CentrosCosto_Consulta>().Where(c => c.Usuario == User.Identity.Name).
                                                                                                OrderBy(c => c.MonedaSimbolo).
                                                                                                ThenBy(c => c.CentroCostoAbreviatura).
                                                                                                ThenBy(c => c.CuentaContableCuenta).
                                                                                                ThenBy(c => c.Secuencia).Select(c => c).
                                                                                                Skip((page - 1) * rows).
                                                                                                Take(rows);

                jqgridData.records = recordCount;       
                jqgridData.page = page;
                jqgridData.total = (recordCount % rows) == 0 ? (recordCount / rows) : (recordCount / rows) + 1; 


                jqgridData.rows = new List<jqGridDataRow>();
                jqGridDataRow jqgridRow;

                int id = 1; 

                foreach (var centroCosto in query)
                {
                    jqgridRow = new jqGridDataRow()
                        {
                            id = id,
                            moneda = centroCosto.MonedaSimbolo,
                            centroCosto = centroCosto.CentroCostoAbreviatura,
                            cuentaContable = centroCosto.CuentaContableCuenta,
                            nombreCuentaContable = centroCosto.CuentaContableNombre,
                            sequencia = centroCosto.Secuencia,
                            fecha = centroCosto.Fecha,
                            descripcion = centroCosto.Descripcion,
                            saldoInicial = centroCosto.SaldoInicial,
                            debe = centroCosto.Debe,
                            haber = centroCosto.Haber,
                            saldoActual = centroCosto.SaldoFinal
                        };

                    jqgridData.rows.Add(jqgridRow);
                    id++; 
                }

                return Request.CreateResponse(HttpStatusCode.OK, jqgridData);
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                if (ex.InnerException != null)
                    message += "<br />" + ex.InnerException.Message;

                var result = new
                {
                    ErrorFlag = true,
                    ErrorMessage = "Se producido un error mientras se ejecutaba el proceso. El mensaje específico del error es:<br />" + message
                };

                return Request.CreateResponse(HttpStatusCode.OK, result);
            }
        }


        [HttpGet]
        public HttpResponseMessage LeerProgress(JObject filter)
        {
            if (!User.Identity.IsAuthenticated)
            {
                var result = new
                {
                    ErrorFlag = true,
                    ErrorMessage = "Error: por favor haga un login a esta aplicación, y luego regrese a ejecutar esta función."
                };

                return Request.CreateResponse(HttpStatusCode.OK, result);
            }
            else
            {
                string message = "";
                var session = HttpContext.Current.Session;
                if (session != null)
                {
                    if (session["Time"] != null)
                        message = "Session is working fine!!; session is: " + session["Time"].ToString();
                }
                else
                    message = "Session is *not* working :(  ... ";


                var result = new
                {
                    ErrorFlag = false,
                    ResultMessage = message
                };

                return Request.CreateResponse(HttpStatusCode.OK, result);
            }
        }
    }
}