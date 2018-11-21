using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ContabSysNet_Web.ModelosDatos_EF.Contab;
using System.Data.Entity;
using System.Xml.Linq;
using ClosedXML.Excel; 

namespace ContabSysNet_Web.Clases
{
    // escribimos esta clase aunque sabemos que existe otra similar, pero que fue escrita hace algún tiempo ... 
    // aunque algunas funciones se repiten, esperamos que aquí estén mejor escritas ... 

    public class FuncionesContab2
    {
        dbContab_Contab_Entities _context;

        public FuncionesContab2()
        {
            _context = new dbContab_Contab_Entities(); 
        }

        public bool CopiarAsientosContables(string filter, string filter_subQuery, 
                                            string userName, int ciaTarget, string multiplicarPor_textBox,
                                            string dividirPor_textBox, out int cantidadAsientosCopiados, out string errorMessage)
        {
            errorMessage = "";
            cantidadAsientosCopiados = 0;

            // sabemos que ambos controles, si tienen un valor, debe ser numérico; nota: también pueden venir vacíos ...  
            double multiplicarPor = multiplicarPor_textBox.Trim() != "" ? Convert.ToDouble(multiplicarPor_textBox) : 1;
            double dividirPor = dividirPor_textBox.Trim() != "" ? Convert.ToDouble(dividirPor_textBox) : 1;

            string filtroAsientosContables = ""; 

            if (filter_subQuery == null || filter_subQuery == "1 = 1")
            {
                // el usuario no usó criterio por cuenta contable o más de 2 decimales; no usamos sub-query 
                filtroAsientosContables = filter;
            }
            else
            {
                // si el usuario indica cuentas contables en su filtro, debemos hacer un subquery para que el resultado final 
                // solo incluya asientos que las tengan ... 
                filtroAsientosContables = filter +
                                    " And (Asientos.NumeroAutomatico In (SELECT Asientos.NumeroAutomatico FROM Asientos " +
                                    "Left Outer Join dAsientos On Asientos.NumeroAutomatico = dAsientos.NumeroAutomatico " +
                                    "Left Outer Join CuentasContables On CuentasContables.ID = dAsientos.CuentaContableID " +
                                    "Where " + filter + " And " + filter_subQuery + "))";
            }

            // como el filtro viene para Sql, y no para linq to entities, intentamos leer los asientos usando Sql ... 
            var query = _context.ExecuteStoreQuery<Asiento>("Select * from Asientos Where" + filtroAsientosContables + " Order By Asientos.Fecha, Asientos.Numero");

            int mesAnterior = -99;
            int anoAnterior = -99;

            short mesFiscal = 0;
            short anoFiscal = 0;

            Asiento asiento;
            dAsiento partida;

            foreach (Asiento a in query)
            {

                if (mesAnterior != a.Fecha.Month || anoAnterior != a.Fecha.Year)
                {
                    // para cada mes diferente, validamos que el mes no esté cerrado en la compañía 'target' ... 
                    if (!ValidarMesCerradoEnContab(a.Fecha, ciaTarget, out mesFiscal, out anoFiscal, out errorMessage))
                        return false;

                    mesAnterior = a.Fecha.Month;
                    anoAnterior = a.Fecha.Year;
                }

                // determinamos un número para el asiento contable en ciaTarget ... 
                short numeroAsientoContab = 0;

                if (!ObtenerNumeroAsientoContab(a.Fecha, ciaTarget, a.Tipo, out numeroAsientoContab, out errorMessage))
                    return false;

                asiento = new Asiento();

                asiento.Mes = a.Mes;
                asiento.Ano = a.Ano;
                asiento.Numero = numeroAsientoContab;
                asiento.Fecha = a.Fecha;
                asiento.Tipo = a.Tipo;
                asiento.Descripcion = a.Descripcion;
                asiento.Moneda = a.Moneda;
                asiento.MonedaOriginal = a.MonedaOriginal;
                asiento.ConvertirFlag = a.ConvertirFlag;
                asiento.FactorDeCambio = a.FactorDeCambio;
                asiento.ProvieneDe = a.ProvieneDe;
                asiento.Ingreso = DateTime.Now;
                asiento.UltAct = DateTime.Now;
                asiento.CopiableFlag = a.CopiableFlag;
                asiento.AsientoTipoCierreAnualFlag = false;         // nótese como nunca asumimos que un asiento de cierre anual lo es también en Cia Target ... 
                asiento.MesFiscal = mesFiscal;
                asiento.AnoFiscal = anoFiscal;
                asiento.Usuario = userName;
                asiento.Cia = ciaTarget;

                // leemos las partidas del asiento y las copiamos al nuevo ... 
                var partidas = _context.dAsientos.Where(p => p.NumeroAutomatico == a.NumeroAutomatico).OrderBy(p => p.Partida);

                foreach (dAsiento p in partidas)
                {
                    partida = new dAsiento();

                    // para cada cuenta contable, debemos buscar una idéntica en la compañía target ... 
                    int? cuentaContableCiaTarget = _context.CuentasContables.Where(c => c.Cuenta == p.CuentasContable.Cuenta).
                                                                             Where(c => c.Cia == ciaTarget).
                                                                             Select(c => c.ID).
                                                                             FirstOrDefault();

                    if (cuentaContableCiaTarget == null || cuentaContableCiaTarget == 0)
                    {
                        errorMessage = "<b>Error:</b> no hemos podido leer la cuenta contable '" + p.CuentasContable.Cuenta + "' en la compañía indicada.";
                        return false;
                    }

                    partida.Partida = p.Partida;
                    partida.CuentaContableID = cuentaContableCiaTarget.Value;
                    partida.Descripcion = p.Descripcion;
                    partida.Referencia = p.Referencia;

                    // multiplicamos y dividimos por lo montos que indique el usuario; nota: si no indica estos montos, usamos 1 ... 
                    partida.Debe = Convert.ToDecimal((Convert.ToDouble(p.Debe) * multiplicarPor) / dividirPor);
                    partida.Haber = Convert.ToDecimal((Convert.ToDouble(p.Haber) * multiplicarPor) / dividirPor);

                    asiento.dAsientos.Add(partida);
                }

                _context.Asientos.AddObject(asiento);
                cantidadAsientosCopiados++;
            }

            try
            {
                _context.SaveChanges();
            }
            catch (Exception ex)
            {
                errorMessage = "<b>Error:</b> hemos obtenido un error al intentar efectuar una operación en la " +
                    "base de datos.<br /><br />" +
                    "El mensaje específico de error es: <br /><br />" + ex.Message;

                if (ex.InnerException != null)
                    errorMessage += "<br />" + ex.InnerException.Message;

                return false;
            }
            finally
            {
                _context = null;
            }

            return true;
        }

        public bool Exportar_AsientosContables(string filter, string format, string userName, out int cantidadPartidasLeidas, 
            out string serverFileName, out string errorMessage)
        {
            errorMessage = "";
            cantidadPartidasLeidas = 0;
            serverFileName = ""; 

            // como el filtro viene para Sql, y no para linq to entities, intentamos leer los asientos usando Sql ... 

            string sqlQuery = "Select Asientos.Numero, dAsientos.Partida, Asientos.Fecha, Asientos.Tipo, " +
            "Monedas.Simbolo As Moneda, mo.Simbolo As MonedaOriginal, CuentasContables.Cuenta, CuentasContables.CuentaEditada, " +
            "CuentasContables.Descripcion As NombreCuenta, dAsientos.Descripcion, dAsientos.Referencia, dAsientos.Debe, " + 
            "dAsientos.Haber, Asientos.FactorDeCambio As FactorCambio, " +
            "Asientos.AsientoTipoCierreAnualFlag As TipoCierreAnual, " +
            "Asientos.ProvieneDe, Asientos.Usuario, Asientos.Ingreso, Companias.Abreviatura As Cia " +  

            "From Asientos Inner Join " +  
            "Monedas On Asientos.Moneda = Monedas.Moneda Inner Join " +  
            "Monedas mo On Asientos.MonedaOriginal = mo.Moneda Inner Join " +  
            "dAsientos On Asientos.NumeroAutomatico = dAsientos.NumeroAutomatico Inner Join " +  
            "CuentasContables On dAsientos.CuentaContableID = CuentasContables.ID Inner Join " +  
            "Companias On CuentasContables.Cia = Companias.Numero " +  

            "Where " + filter + " " + 

            "Order by Asientos.Fecha, Asientos.Numero, dAsientos.Partida";

            try
            {
                var query = _context.ExecuteStoreQuery<AsientoContable_Exportar>(sqlQuery).ToList();

                switch (format) 
                {
                    case "excel":
                        {
                            // usamos ClosedXML para crear el excel doc en el servidor ... 

                            var workbook = new XLWorkbook();
                            var worksheet = workbook.Worksheets.Add("Cuentas contables");

                            int row = 2; 

                            // agregamos el encabezado de la página 

                            //worksheet.Rows().AdjustToContents();
                            //worksheet.Columns().AdjustToContents();

                            worksheet.Cell("B" + row.ToString()).Value = "Comprobante";
                            worksheet.Cell("C" + row.ToString()).Value = "Partida";
                            worksheet.Cell("D" + row.ToString()).Value = "Fecha";
                            worksheet.Cell("E" + row.ToString()).Value = "Tipo";
                            worksheet.Cell("F" + row.ToString()).Value = "Moneda";
                            worksheet.Cell("G" + row.ToString()).Value = "Mon original";
                            worksheet.Cell("H" + row.ToString()).Value = "Cuenta contable";
                            worksheet.Cell("I" + row.ToString()).Value = "Cuenta editada";
                            worksheet.Cell("J" + row.ToString()).Value = "Nombre";
                            worksheet.Cell("K" + row.ToString()).Value = "Descripción";
                            worksheet.Cell("L" + row.ToString()).Value = "Referencia";
                            worksheet.Cell("M" + row.ToString()).Value = "Debe";
                            worksheet.Cell("N" + row.ToString()).Value = "Haber";
                            worksheet.Cell("O" + row.ToString()).Value = "Factor cambio";
                            worksheet.Cell("P" + row.ToString()).Value = "Cierre anual";
                            worksheet.Cell("Q" + row.ToString()).Value = "Origen";
                            worksheet.Cell("R" + row.ToString()).Value = "Usuario";
                            worksheet.Cell("S" + row.ToString()).Value = "F registro";
                            worksheet.Cell("T" + row.ToString()).Value = "Cia";

                            // intentamos aplicar algunos estilos para mejorar el aspecto ... 

                            worksheet.Column(2).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                            worksheet.Column(3).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                            worksheet.Column(4).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                            worksheet.Column(5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                            worksheet.Column(6).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                            worksheet.Column(7).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                            worksheet.Column(8).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                            worksheet.Column(9).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;

                            worksheet.Column(12).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;

                            worksheet.Column(13).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;
                            worksheet.Column(14).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;
                            worksheet.Column(15).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Right;

                            worksheet.Column(16).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                            worksheet.Column(17).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                            worksheet.Column(18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                            worksheet.Column(19).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                            worksheet.Column(20).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;

                            worksheet.Cell("G" + row.ToString()).Style.Alignment.WrapText = true;
                            worksheet.Cell("H" + row.ToString()).Style.Alignment.WrapText = true;
                            worksheet.Cell("I" + row.ToString()).Style.Alignment.WrapText = true;
                            worksheet.Cell("O" + row.ToString()).Style.Alignment.WrapText = true;
                            worksheet.Cell("P" + row.ToString()).Style.Alignment.WrapText = true;


                            worksheet.Range("B2:T2").Style.Font.Bold = true;
                            worksheet.Range("B2:T2").Style.Font.FontColor = XLColor.DarkBlue;
                            worksheet.Range("B2:T2").Style.Fill.BackgroundColor = XLColor.LightGray;
                            worksheet.Range("B2:T2").Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                            // por alguna razón, la instrucción anterior no establece el borde izquierdo del rango (????) 
                            //worksheet.Range("B2:S2").FirstColumn().Style.Border.LeftBorder = XLBorderStyleValues.Thin;

                            //worksheet.Cell("A" + row.ToString()).Style.Alignment.ShrinkToFit = true;

                            cantidadPartidasLeidas = 0; 

                            foreach (var asiento in query)
                            {
                                row++;

                                worksheet.Cell("B" + row.ToString()).Value = asiento.Numero.ToString();
                                worksheet.Cell("C" + row.ToString()).Value = asiento.Partida.ToString();
                                worksheet.Cell("D" + row.ToString()).Value = asiento.Fecha.ToString("dd-MM-yyyy");
                                worksheet.Cell("E" + row.ToString()).Value = asiento.Tipo;
                                worksheet.Cell("F" + row.ToString()).Value = asiento.Moneda;
                                worksheet.Cell("G" + row.ToString()).Value = asiento.MonedaOriginal;

                                // para que Excel no lo considere un number, sino texto ... 
                                worksheet.Cell("H" + row.ToString()).SetValue(asiento.Cuenta).SetDataType(XLCellValues.Text);
                                worksheet.Cell("I" + row.ToString()).Value = asiento.CuentaEditada;
                                worksheet.Cell("J" + row.ToString()).Value = asiento.NombreCuenta;
                                worksheet.Cell("K" + row.ToString()).Value = asiento.Descripcion;
                                worksheet.Cell("L" + row.ToString()).Value = asiento.Referencia;
                                worksheet.Cell("M" + row.ToString()).Value = asiento.Debe;
                                worksheet.Cell("N" + row.ToString()).Value = asiento.Haber;
                                worksheet.Cell("O" + row.ToString()).Value = asiento.FactorCambio;
                                worksheet.Cell("P" + row.ToString()).Value = (asiento.TipoCierreAnual == null || asiento.TipoCierreAnual.Value == false) ? "" : "Si"; 
                                worksheet.Cell("Q" + row.ToString()).Value = asiento.ProvieneDe;
                                worksheet.Cell("R" + row.ToString()).Value = asiento.Usuario;
                                worksheet.Cell("S" + row.ToString()).Value = asiento.Ingreso.ToString("dd-MM-yyyy hh:mm tt"); ;
                                worksheet.Cell("T" + row.ToString()).Value = asiento.Cia;

                                cantidadPartidasLeidas++;
                            }

                            worksheet.Columns().AdjustToContents();

                            // guardamos el documento Excel en el servidor 

                            String fileName = @"AsientosContables_" + userName + ".xlsx";
                            String filePath = HttpContext.Current.Server.MapPath("~/Temp/" + fileName);

                            try
                            {
                                workbook.SaveAs(filePath);
                                serverFileName = filePath; 
                            }
                            catch (Exception ex)
                            {
                                errorMessage = ex.Message;
                                if (ex.InnerException != null)
                                    errorMessage += "<br /><br />" + ex.InnerException.Message;

                                return false; 
                            } 

                            break; 
                        }
                    case "xml":
                        {
                            XDocument xmldoc = new XDocument(new XElement("AsientosContables"));
                            xmldoc.Declaration = new XDeclaration("1.0", "ISO-8859-1", "true");

                            foreach (var asiento in query)
                            {
                                XElement x = new XElement("AsientoContable",
                                                            new XElement("Numero", asiento.Numero.ToString()),
                                                            new XElement("Partida", asiento.Partida.ToString()),
                                                            new XElement("Fecha", asiento.Fecha.ToString("yyyy-MM-dd")),
                                                            new XElement("Tipo", asiento.Tipo),
                                                            new XElement("Moneda", asiento.Moneda),
                                                            new XElement("MonedaOriginal", asiento.MonedaOriginal),
                                                            new XElement("Cuenta", asiento.Cuenta),
                                                            new XElement("CuentaEditada", asiento.CuentaEditada),
                                                            new XElement("NombreCuenta", asiento.NombreCuenta),
                                                            new XElement("Descripcion", asiento.Descripcion),
                                                            new XElement("Referencia", asiento.Referencia),
                                                            new XElement("Debe", asiento.Debe.ToString("N2").Replace(".", "").Replace(",", ".")),
                                                            new XElement("Haber", asiento.Haber.ToString("N2").Replace(".", "").Replace(",", ".")),
                                                            new XElement("FactorCambio", asiento.FactorCambio.ToString("N2").Replace(".", "").Replace(",", ".")),
                                                            new XElement("TipoCierreAnual", asiento.TipoCierreAnual),
                                                            new XElement("ProvieneDe", asiento.ProvieneDe),
                                                            new XElement("Usuario", asiento.Usuario),
                                                            new XElement("FRegistro", asiento.Ingreso.ToString("yyyy-MM-dd hh:mm tt")),
                                                            new XElement("Cia", asiento.Cia)
                                                            );

                                xmldoc.Element("AsientosContables").Add(x);

                                cantidadPartidasLeidas++;
                            }

                            String fileName = @"AsientosContables_" + userName + ".xml";
                            String filePath = HttpContext.Current.Server.MapPath("~/Temp/" + fileName);

                            try
                            {
                                xmldoc.Save(filePath);
                                serverFileName = filePath; 
                            }
                            catch (Exception ex)
                            {
                                errorMessage = ex.Message;
                                if (ex.InnerException != null)
                                    errorMessage += "<br /><br />" + ex.InnerException.Message;

                                return false;
                            } 

                            break; 
                        }
                }

            }
            catch (Exception ex)
            {
                errorMessage = "Error: hemos obtenido un error al intentar efectuar una operación en la " +
                    "base de datos.<br /><br />" +
                    "El mensaje específico de error es: <br /><br />" + ex.Message;

                if (ex.InnerException != null)
                    errorMessage += "<br />" + ex.InnerException.Message;

                return false;
            }
            finally
            {
                _context = null;
            }

            return true;
        }





        public bool ValidarMesCerradoEnContab(DateTime fechaAsiento,
                                              int ciaAsiento,
                                              out short mesFiscalAsientoContable,
                                              out short anoFiscalAsientoContable,
                                              out string errMessage)
        {
            errMessage = "";

            mesFiscalAsientoContable = 0;
            anoFiscalAsientoContable = 0;

            // ----------------------------------------------------------------------------------------------
            // determinamos el mes y año fiscal en base al mes y año calendario en la fecha del asiento

            if (!DeterminarMesFiscalAsientoContable(fechaAsiento, ciaAsiento, out mesFiscalAsientoContable, out anoFiscalAsientoContable, out errMessage))
                return false;

            // ------------------------------------------------------------------------------------
            // leemos el mes cerrado para la cia del asiento (nota importante: el último mes cerrado corresponde a
            // mes y año *fiscal* y no calendario) 

            UltimoMesCerradoContab ultimoMesCerrado = _context.UltimoMesCerradoContabs.Where(u => u.Cia == ciaAsiento).FirstOrDefault();


            if (ultimoMesCerrado == null)
            {
                errMessage = "<b>Error:</b> no hemos encontrado un registro en la tabla 'Ultimo Mes Cerrado' en Contab " +
                    "que corresponda a la cia Contab indicada." +
                    "Por favor revise y corrija esta situación.";

                return false;
            }

            byte mesCerradoContab_Fiscal = ultimoMesCerrado.Mes;
            short anoCerradoContab_Fiscal = ultimoMesCerrado.Ano;

            // nótese que la validación es compleja, pues debemos tomar en cuenta la situación que crea el 
            // proceso de cierre anual ... 

            if (mesCerradoContab_Fiscal < 12)
            {
                // cuando el mes (fiscal!) cerrado en anterior a 12, la validación es muy simple 

                if ((anoFiscalAsientoContable < anoCerradoContab_Fiscal) ||
                    (anoFiscalAsientoContable == anoCerradoContab_Fiscal &&
                     mesFiscalAsientoContable <= mesCerradoContab_Fiscal))
                {
                    errMessage = "<b>Error:</b> la fecha del asiento contable que se desea editar o registrar corresponde " +
                        "a un mes ya cerrado en la compañía <em>" + ultimoMesCerrado.Compania.Nombre + "</em>. " +
                        "Ud. no puede editar o registrar un asiento cuya fecha corresponda a un mes cerrado en Contab.";

                    return false;
                }
                return true;
            }


            // en adelante en este código, el mes cerrado (fiscal) es 12 o 13 ... 

            if (mesCerradoContab_Fiscal == 13)
            {
                // en la contabilidad, para la cia del asiento, se hizo el cierre anual *más no* el traspaso de saldos 

                if (anoFiscalAsientoContable <= anoCerradoContab_Fiscal)
                {
                    errMessage = "<b>Error:</b> la fecha del asiento contable que se desea editar o registrar corresponde " +
                        "a un mes ya cerrado en la compañía <em>" + ultimoMesCerrado.Compania.Nombre + "</em>. " +
                        "Ud. no puede editar o registrar un asiento cuya fecha corresponda a un mes cerrado en Contab.";

                    return false;
                }
                return true;
            }



            if (mesCerradoContab_Fiscal == 12)
            {
                // en la contabilidad, para la cia del asiento, se hizo el cierre anual *más no* el traspaso de saldos 

                if (anoFiscalAsientoContable > anoCerradoContab_Fiscal)
                {
                    // el asiento es de un año posterior, simplemente regresamos ... 
                    return true;
                }
                else if ((anoFiscalAsientoContable < anoCerradoContab_Fiscal) ||
                        (anoFiscalAsientoContable == anoCerradoContab_Fiscal &&
                         mesFiscalAsientoContable < mesCerradoContab_Fiscal))
                {
                    // el asiento es de un mes anterior; regresamos con error 
                    errMessage = "<b>Error:</b> la fecha del asiento contable que se desea editar o registrar corresponde " +
                        "a un mes ya cerrado en Contab. " +
                        "Ud. no puede editar o registrar un asiento cuya fecha corresponda a un mes cerrado en Contab.";

                    return false;
                }


                // los asientos que llegan aquí son del mes fiscal 12 (y el mes cerrado es 12) 
                // impedimos continuar ... 

                errMessage = "<b>Error:</b> el mes fiscal cerrado ahora en Contab es 12; " +
                "bajo tales circunstancias, Ud. solo puede agregar, mediante Contab, asientos de tipo Cierre Anual.";

                return false;
            }

            return true;
        }

        public bool DeterminarMesFiscalAsientoContable(DateTime fechaAsiento,
                                                       int cia,
                                                       out short mesFiscal,
                                                       out short anoFiscal,
                                                       out string errorMessage)
        {
            // ----------------------------------------------------------------------------------------------
            // determinamos el mes y año fiscal en base al mes y año calendario del asiento 

            mesFiscal = 0;
            anoFiscal = 0;
            errorMessage = "";

            byte mesCalendario = Convert.ToByte(fechaAsiento.Month);
            short anoCalendario = Convert.ToInt16(fechaAsiento.Year);

            MesesDelAnoFiscal mesAnoFiscal = (from m in _context.MesesDelAnoFiscals
                                              where m.Mes == mesCalendario &&
                                                    m.Compania.Numero == cia
                                              select m).FirstOrDefault();

            if (mesAnoFiscal == null)
            {
                errorMessage = "No hemos encontrado un registro en la tabla de meses fiscales en Contab para " +
                    "el mes que corresponde a la fecha del asiento (" +
                    fechaAsiento.ToString("dd-MMM-yyyy") + ".<br /><br />" +
                    "Por favor revise y corrija esta situación.";

                return false;
            }


            mesFiscal = mesAnoFiscal.MesFiscal;
            anoFiscal = anoCalendario;

            if (mesAnoFiscal.Ano == 1)
                anoFiscal--;

            return true;
        }

        public bool ObtenerNumeroAsientoContab(DateTime fechaAsiento, int ciaContab, string tipoAsiento,
                                               out short numeroAsientoContab, out string errorMessage)
        {
            // esta función determina y regresa un número de asiento Contab. Nótese que el número determinado 
            // depende de si se genera por grupos de tipo o no. Esto lo determina un flag en ParametrosContab: 
            // NumeracionAsientosSeparadaFlag. 

            // nótese como, lamentablemente, tenemos que crear aquí un nuevo context, pues vamos a actualizar AsientosID 
            // cada vez que ejecutemos la función; esto evitará que se generen números duplicados si otros usuarios 
            // graban asientos contables en forma simultanea a la ejecución de esta función ... 

            dbContab_Contab_Entities context = new dbContab_Contab_Entities(); 

            errorMessage = "";
            numeroAsientoContab = 0;

            short nMesCalendario = (short)fechaAsiento.Month;
            short nAnoCalendario = (short)fechaAsiento.Year;

            Compania companiaContab = context.Companias.Where(c => c.Numero == ciaContab).FirstOrDefault();

            if (companiaContab == null)
            {
                errorMessage = " ... error inesperado: no pudimos leer la compañía Contab asociada al " +
                    "asiento contable.";
                return false;
            }

            if (companiaContab.ParametrosContab == null)
            {
                errorMessage = " ... error inesperado: no pudimos leer los parámetros de la compañía Contab " +
                    "en la tabla Parametros Contab.";
                return false;
            }

            // lo primero que hacemos es determinar si el número se genera de acuerdo al tipo 

            bool? bNumeracionSeparadaPorTipo = companiaContab.ParametrosContab.NumeracionAsientosSeparadaFlag;


            if (bNumeracionSeparadaPorTipo == null)
            {
                errorMessage = "Error: aparentemente, no se ha definido si la numeración de los asientos es o " +
                    "no separada de acuerdo a su tipo.<br /><br />" +
                    "Por favor abra la tabla 'Parámetros' en Contab y defina un valor para este item.";

                return false;
            }

            if (!bNumeracionSeparadaPorTipo.Value)
            {
                // la númeración NO ES separada de acuerdo al tipo del asiento. La determinación del número 
                // es más simple 

                // leemos el número del asiento de la tabla AsientosId

                AsientosId MyAsientosId = context.AsientosIds.Where(a => a.Mes == nMesCalendario && a.Ano == nAnoCalendario && a.Cia == ciaContab).FirstOrDefault(); 

                if (MyAsientosId == null)
                {
                    // no existe un registro en la tabla para el mes, año y cia. Lo creamos y asumimos 1 
                    // como número 

                    numeroAsientoContab = 1;

                    AsientosId MyAsientosId_Nuevo = new AsientosId(); 

                    MyAsientosId_Nuevo.Mes = Convert.ToInt16(nMesCalendario);
                    MyAsientosId_Nuevo.Ano = Convert.ToInt16(nAnoCalendario);
                    MyAsientosId_Nuevo.Cia = ciaContab;
                    MyAsientosId_Nuevo.Numero = 2;

                    context.AsientosIds.AddObject(MyAsientosId_Nuevo); 
                }
                else
                {
                    numeroAsientoContab = (short)MyAsientosId.Numero;
                    MyAsientosId.Numero += 1;
                }
            }
            else
            {
                // leemos el grupo de la tabla TiposDeAsiento 


                // leemos el número del asiento de la tabla AsientosIdPorGrupo

                TiposDeAsiento tipoAsientoContable = (from t in context.TiposDeAsientoes
                                                      where t.Tipo == tipoAsiento
                                                      select t).FirstOrDefault();

                if (tipoAsientoContable.tGruposDeTiposDeAsiento == null)
                {
                    errorMessage = "Error: aparentemente, no se ha definido el Grupo que corresponde al tipo " +
                        "de asientos que Ud. ha indicado para el asiento contable.<br /><br />" +
                        "Como la numeración de los asientos contables es separada de acuerdo a su tipo " +
                        "(según está ahora definido en el sistema Contab), cada tipo debe corresponder " +
                        "a un grupo.<br /><br />" +
                        "Por favor abra la tabla Tipos de Asiento en Contab y " +
                        "defina un valor para este item.";

                    return false;
                }



                AsientosIdPorGrupo MyAsientosIdPorGrupo = (from aidg in context.AsientosIdPorGrupoes
                                                           where aidg.Mes == nMesCalendario &&
                                                           aidg.Ano == nAnoCalendario &&
                                                           aidg.Grupo == tipoAsientoContable.tGruposDeTiposDeAsiento.Grupo &&
                                                           aidg.Cia == ciaContab
                                                           select aidg).SingleOrDefault();

                if (MyAsientosIdPorGrupo == null)
                {
                    // no existe un registro en la tabla para el mes, año y cia. Buscamos el número INICIAL 
                    // en la tabla tGruposDeTiposDeAsiento 

                    var MyGrupoTipoAsiento = (from g in context.tGruposDeTiposDeAsientoes
                                              where g.Grupo == tipoAsientoContable.tGruposDeTiposDeAsiento.Grupo
                                              select g).FirstOrDefault();

                    if (MyGrupoTipoAsiento == null || MyGrupoTipoAsiento.NumeroInicial == null)
                    {
                        errorMessage = "Error: aparentemente, no se ha definido el Grupo que corresponde al " +
                            "tipo de asientos que Ud. ha indicado para el asiento contable.<br /><br />" +
                            "Como la numeración de los asientos contables es separada de acuerdo a su tipo " +
                            "(según está ahora definido en el sistema Contab), cada tipo debe " +
                            "corresponder a un grupo.<br /><br />" +
                            "Por favor abra la tabla Tipos de Asiento en Contab y " +
                            "defina un valor para este item;<br /><br />" +
                            "o, abra la tabla Grupos de Tipos de Asiento y defina un grupo y un " +
                            "número de inicio para este grupo.";

                        return false;
                    }

                    numeroAsientoContab = (short)MyGrupoTipoAsiento.NumeroInicial;

                    // nótese como usamos un nuevo context, para no interferir con la operación que llama este 
                    // método (ie: Inserting) 

                    AsientosIdPorGrupo MyAsientosIdPorGrupo_Nuevo = new AsientosIdPorGrupo(); 

                    MyAsientosIdPorGrupo_Nuevo.Mes = Convert.ToInt16(nMesCalendario);
                    MyAsientosIdPorGrupo_Nuevo.Ano = Convert.ToInt16(nAnoCalendario);
                    MyAsientosIdPorGrupo_Nuevo.Grupo = tipoAsientoContable.tGruposDeTiposDeAsiento.Grupo;
                    MyAsientosIdPorGrupo_Nuevo.Cia = ciaContab;
                    MyAsientosIdPorGrupo_Nuevo.Numero = MyGrupoTipoAsiento.NumeroInicial + 1;

                    context.AsientosIdPorGrupoes.AddObject(MyAsientosIdPorGrupo); 
                }
                else
                {
                    numeroAsientoContab = (short)MyAsientosIdPorGrupo.Numero.Value;
                    MyAsientosIdPorGrupo.Numero += 1;
                }
            }


            try
            {
                context.SaveChanges();
            }
            catch (Exception ex)
            {
                errorMessage = "Error: hemos obtenido un error al intentar efectuar una operación en la " +
                    "base de datos.<br /><br />" +
                "El mensaje específico de error es: <br /><br />" + ex.Message;

                if (ex.InnerException != null)
                    errorMessage += ex.InnerException.Message; 

                context = null;
                return false;
            }

            context = null;
            return true;
        }
    }

    public class AsientoContable_Exportar
    {
        public short Numero { get; set; }
        public short Partida { get; set; }
        public DateTime Fecha { get; set; }
        public string Tipo { get; set; }
        public string Moneda { get; set; }
        public string MonedaOriginal { get; set; }
        public string Cuenta { get; set; }
        public string CuentaEditada { get; set; }
        public string NombreCuenta { get; set; }
        public string Descripcion { get; set; }
        public string Referencia { get; set; }
        public decimal Debe { get; set; }
        public decimal Haber { get; set; }
        public decimal FactorCambio { get; set; }
        public bool? TipoCierreAnual { get; set; }
        public string ProvieneDe { get; set; }
        public string Usuario { get; set; }
        public DateTime Ingreso { get; set; }
        public string Cia { get; set; }
    }
}