"use strict";

// --------------------------------------------------------------------------------
// definimos el view model para la página 
// --------------------------------------------------------------------------------

var viewModel = {
    ciaContabSeleccionada: ko.observable(),

    filtro: {
        ciaContabSeleccionadaID: 0, 
        desde: ko.observable(),
        hasta: ko.observable(),
        centrosCosto: ko.observableArray(),
        monedas: ko.observableArray()
    },

    centrosCostoSeleccionado: ko.observableArray(),
    monedaSeleccionada: ko.observable(),
    seleccionarCuentasSinMovimientosEnElPeriodo: ko.observable(),

    openFilterJqueryDialog: function () {
        $("#filterDialog").dialog("open");
        event.preventDefault();
    },

    opcionesReporte: { versionResumen: ko.observable(false) }, 

    openReportsJqueryDialog: function () {
        $("#reportsDialog").dialog("open");
        event.preventDefault();
    },

    obtener_Reporte: function()
    {
        // obtenemos el período y el nombre de la compañía desde este viewModel 
        obtenerReporte(this.filtro.desde(), this.filtro.hasta(), this.ciaContabSeleccionada())
    }, 

    limpiarFiltro: function () {
        this.filtro.desde(null); 
        this.filtro.hasta(null);
        this.centrosCostoSeleccionado.removeAll();
        this.monedaSeleccionada(null);
        this.seleccionarCuentasSinMovimientosEnElPeriodo(false); 
    },

    applyFilter: function () {
        var filtroAplicadoPorElUsuario = aplicarFiltro();

        // nótese como aprovechamos para guardar el filtro indicado por el usuario en localStorage; 
        // la idea es que esté disponible para cuando el usuario regrese a la página ... 

        // filtro fue creado para guardar los valores indicados por el usuario para el filtro en leerResumenDesdeServidor() 

        if (filtroAplicadoPorElUsuario) {
            localStorage.setItem("filtro_Contab_ConsultaCentrosCosto", JSON.stringify(filtroAplicadoPorElUsuario));
        }
    },

    leerProgresoTarea: function () {
        obtenerProgresoTareaCurso(this.filtro.desde, this.filtro.hasta, this.ciaContabSeleccionada);
    }

    //progress: {
    //    max: ko.observable(),
    //    value: ko.observable(),
    //    message: ko.observable()
    //}
};

// --------------------------------------------------------------------------------------
// para obtener los datos de inicio; necesarios cuando la página se abre inicialmente 
// --------------------------------------------------------------------------------------

function obtenerDatosInicioPagina() {

    //var uri = "api/contabilidad/CentrosCostoConsulta/CargaDatosIniciales/1";
    var uri = path + "api/contabilidad/CentrosCostoConsulta/CargaDatosIniciales";

    $.getJSON(uri)
        .done(function (data) {

            if (data.ErrorFlag) {
                $("#MensajeAlUsuario_Div").removeClass("infoMessage").addClass("errorMessage").html(data.ErrorMessage);
                return false;
            }

            if (data.CiaContabSeleccionada_Nombre)
                viewModel.ciaContabSeleccionada(data.CiaContabSeleccionada_Nombre);

            if (data.CiaContabSeleccionada_Numero)
                viewModel.filtro.ciaContabSeleccionadaID = data.CiaContabSeleccionada_Numero;

            if (data.CentrosCosto)
                data.CentrosCosto.forEach(function (item, idx) {
                    viewModel.filtro.centrosCosto.push({ id: item.ID, descripcion: item.Descripcion });
                });

            if (data.Monedas)
                data.Monedas.forEach(function (item, idx) {
                    viewModel.filtro.monedas.push({ id: item.ID, descripcion: item.Descripcion });
                });



            // ------------------------------------------------------------------------------------------------------------------
            // recuperamos el filtro que se indicó la última vez que se visitó la página y lo usamos para inicializarlo esta vez 

            var myFiltroAnterior = localStorage.getItem("filtro_Contab_ConsultaCentrosCosto");
            var myFiltroAnterior_Object;

            if (myFiltroAnterior)
                myFiltroAnterior_Object = JSON.parse(myFiltroAnterior);
            else
                return;

            if (myFiltroAnterior_Object.desde) {
                viewModel.filtro.desde(myFiltroAnterior_Object.desde)
            }

            if (myFiltroAnterior_Object.hasta) {
                viewModel.filtro.hasta(myFiltroAnterior_Object.hasta)
            }

            if (myFiltroAnterior_Object.centrosCosto && myFiltroAnterior_Object.centrosCosto.length > 0) {
                myFiltroAnterior_Object.centrosCosto.forEach(function (data, idx) {
                    viewModel.centrosCostoSeleccionado.push(data);
                });
            }

            if (myFiltroAnterior_Object.moneda) {
                viewModel.monedaSeleccionada(myFiltroAnterior_Object.moneda);
            }

            if (myFiltroAnterior_Object.cuentasSinMovimientos)
                viewModel.seleccionarCuentasSinMovimientosEnElPeriodo(myFiltroAnterior_Object.cuentasSinMovimientos);

            // ------------------------------------------------------------------------------------------------------------------
        })
        .fail(function (jqxhr, textStatus, error) {
            var errMessage = "Hemos encontrado un error al intentar ejecutar una función en el servidor, usando la dirección: <br />'" + uri + "'";
            errMessage += "<br />" + "El mensaje del error obtenido es: " + textStatus + ", " + error;
            $("#MensajeAlUsuario_Div").removeClass("infoMessage").addClass("errorMessage").html(errMessage);
        });
}; 

$(function () {
    ko.applyBindings(viewModel);
    obtenerDatosInicioPagina();
}); 


// --------------------------------
// dialog para aplicar un filtro 
// --------------------------------

$("#filterDialog").dialog({
    autoOpen: false,
    width: 750,
    modal: true,
    buttons: [
        {
            text: "Limpiar filtro",
            click: function () {
                viewModel.limpiarFiltro();
            }
        },
        {
            text: "Ok",
            click: function () {
                viewModel.applyFilter();
            }
        },
        {
            text: "Cerrar",
            click: function () {
                $(this).dialog("close");
            }
        }
    ]
});

// --------------------------------
// dialog para aplicar un filtro 
// --------------------------------

$("#reportsDialog").dialog({
    autoOpen: false,
    width: 750,
    modal: true,
    buttons: [
        {
            text: "Cerrar",
            click: function () {
                $(this).dialog("close");
            }
        }
    ]
});

// ---------------------------------------------------------------------------------
// para leer los registros usando el filtro que indicó el usuario 
// ---------------------------------------------------------------------------------

function aplicarFiltro() {
    // las fechas que indica el usuario vienen como strings; usamos moment.js para convertirlas a fechas; 
    // lo que queremos en enviarlas, nuevamente como strings, pero 'yyyy-mm-dd' ... 

    var desde = moment(viewModel.filtro.desde(), "DD-MM-YY").toDate();
    var hasta = moment(viewModel.filtro.hasta(), "DD-MM-YY").toDate();
    var cuentasSinMovimientos = viewModel.seleccionarCuentasSinMovimientosEnElPeriodo() ? viewModel.seleccionarCuentasSinMovimientosEnElPeriodo() : false;

    var myFiltro = {
        ciaContabSeleccionada: viewModel.filtro.ciaContabSeleccionadaID,
        desde: moment(desde).format("YYYY-MM-DD"),
        hasta: moment(hasta).format("YYYY-MM-DD"),
        centrosCosto: [],
        moneda: viewModel.monedaSeleccionada() ? viewModel.monedaSeleccionada() : null,
        cuentasSinMovimientos: cuentasSinMovimientos
    };

    var centrosCostoSeleccionadosArray = viewModel.centrosCostoSeleccionado();

    centrosCostoSeleccionadosArray.forEach(function (item, idx) {
        myFiltro.centrosCosto.push(item);
    });


    //var uri = path + "api/contabilidad/CentrosCostoConsulta/PrepararDatosConsulta";
    var uri = path + "api/CentrosCostoConsultaWebApi/PrepararDatosConsulta";

    var jqxhr = $.ajax({
        url: uri,
        type: "POST",
        data: JSON.stringify(myFiltro),
        contentType: "application/json; charset=utf-8",
        dataType: "json"
        })
          .done(function (result) {
              $("#MensajeAlUsuario_Div").html("");

              if (result.ErrorFlag) {
                  $("#MensajeAlUsuario_Div").removeClass("infoMessage").addClass("errorMessage").html(result.ErrorMessage);
                  return false;
              }

              // nótese como lo que sigue es como: !string.isnullorempty ...
              if (result.ResultMessage) {
                  $("#MensajeAlUsuario_Div").removeClass("errorMessage").addClass("infoMessage").html(result.ResultMessage);
              }


              // ---------------------------------------------------------------------
              // inicializamos el jqGrid y leemos la 1ra. página 

              inicializarjqGrid();

              // ---------------------------------------------------------------------
              // cerramos el diálogo que permite indicar el filtro 
              $("#filterDialog").dialog("close");
          })
          .fail(function (jqxhr, textStatus, error) {
              var errMessage = "Hemos encontrado un error al intentar ejecutar una función en el servidor, usando la dirección: <br />'" + uri + "'";
              errMessage += "<br />" + "El mensaje del error obtenido es: " + textStatus + ", " + error;
              $("#MensajeAlUsuario_Div").removeClass("infoMessage").addClass("errorMessage").html(errMessage);
          })
          .always(function () {
              //cerramos el diálogo que permite indicar el filtro 
              $("#filterDialog").dialog("close");
          });

    // obtenemos el progreso de la operación, luego de 2 segundos ... 
    //setTimeout(obtenerProgresoTareaCurso, 1000);

    // antes de regresar, cambiamos el formato a las fechas (desde, hasta) para que se guarden como d-m-y; 
    // este filtro se guarda en local storage y se recupera cuando se abre nuevamente la página; la idea 
    // es que estos valores se guarden como los guarda el jquery date picker ... 

    var myFiltroGuardarLocalStorage = {
        desde: moment(desde).format("DD-MM-YY"),
        hasta: moment(hasta).format("DD-MM-YY"),
        centrosCosto: centrosCostoSeleccionadosArray,
        moneda: viewModel.monedaSeleccionada(),
        cuentasSinMovimientos: cuentasSinMovimientos
    };

    return myFiltroGuardarLocalStorage;
}

function leerPagina(page, rowsPerPage) {
    //var uri = path + "api/contabilidad/CentrosCostoConsulta/PrepararDatosConsulta";
    var uri = path + "api/contabilidad/CentrosCostoConsulta/LeerJQGridPage?page=" + page.toString() + "&rows=" + rowsPerPage.toString();

    //var pageParams = { page: page, rows: rowsPerPage };

    var jqxhr = $.ajax({
        url: uri,
        type: "GET",
        //data: JSON.stringify(pageParams),
        contentType: "application/json; charset=utf-8",
        dataType: "json"
    })
          .done(function (result) {
              if (result.ErrorFlag) {
                  $("#MensajeAlUsuario_Div").html("");
                  $("#MensajeAlUsuario_Div").removeClass("infoMessage").addClass("errorMessage").html(result.ErrorMessage);
                  return false;
              }
          })
          .fail(function (jqxhr, textStatus, error) {
              var errMessage = "Hemos encontrado un error al intentar ejecutar una función en el servidor, usando la dirección: <br />'" + uri + "'";
              errMessage += "<br />" + "El mensaje del error obtenido es: " + textStatus + ", " + error;
              $("#MensajeAlUsuario_Div").html("");
              $("#MensajeAlUsuario_Div").removeClass("infoMessage").addClass("errorMessage").html(errMessage);
          })
          .always(function () {
              var a = "hello there!"; 
          });
}

function obtenerProgresoTareaCurso() {

    // TODO: vamos a parar el uso de esta función, hasta resolver el tema de la ejecución simultanea de 2 
    // ajax requests ... 

    var uri = path + "api/CentrosCostoConsultaWebApi/LeerProgreso/0";

    $.getJSON(uri)
        .done(function (data) {
            // actualizamos el objeto en el view model que permite mostrar el progreso de la tarea ... 

            if (data.max && data.value)
            {
                

                if (data.value < data.max) {
                    viewModel.progress.max(data.max);
                    viewModel.progress.value(data.value);
                    viewModel.progress.message(data.message);

                    setTimeout(obtenerProgresoTareaCurso, 1000);
                }
                else {
                    viewModel.progress.max();
                    viewModel.progress.value();
                    viewModel.progress.message();
                }
            }
        })
        .fail(function (jqxhr, textStatus, error) {
            var errMessage = "Hemos encontrado un error al intentar ejecutar una función en el servidor, usando la dirección: <br />'" + uri + "'";
            errMessage += "<br />" + "El mensaje del error obtenido es: " + textStatus + ", " + error;
            $("#MensajeAlUsuario_Div").removeClass("infoMessage").addClass("errorMessage").html(errMessage);
        });
}

function obtenerReporte(desde, hasta, nombreCiaContab) {

    // para construir el período, primero convertimos las fechas (string) a date; luego les aplicamos un formato ... 

    var desde = moment(viewModel.filtro.desde(), "DD-MM-YY").toDate();
    var hasta = moment(viewModel.filtro.hasta(), "DD-MM-YY").toDate();

    var periodo = "Desde " + moment(desde).format("DD-MMM-YYYY") + " hasta " + moment(hasta).format("DD-MMM-YYYY");

    var url = "../Areas/Contabilidad/Reports/ReportViewer.aspx?report=centrosCosto&ciaContab=" + nombreCiaContab +
                                                             "&periodo=" + periodo +
                                                             "&versionResumen=" + viewModel.opcionesReporte.versionResumen().toString();

    // para abrir la página en un window diferente (popup) 
    window.open(url, "external", "width=1000,height=680,resizable=yes,scrollbars=yes,status=no,location=no,toolbar=no,menubar=no,top=10px,left=8px");
} 

function inicializarjqGrid() {

    var numberTemplate = { formatter: 'number', align: 'right', sorttype: 'number' };

    var uri = path + "api/contabilidad/CentrosCostoConsulta/LeerJQGridPage";

    $("#theGrid").jqGrid({
        url: uri,
        mType: 'get', 
        datatype: 'json',
        colNames: ['Mon', 'CC', 'Cuenta', 'Nombre', 'Seq', 'Fecha', 'Descripción', 'Saldo inicial', 'Debe', 'Haber', 'Saldo actual'],
        colModel:
        [
            // name: name of field in json; index: when sorting, ajax param 'sort index' (sidx) 
              { name: 'moneda', index: 'moneda', align: 'center', width: 50 },
              { name: 'centroCosto', index: 'centroCosto', align: 'center', width: 50 },
              { name: 'cuentaContable', index: 'cuentaContable', width: 100 },
              { name: 'nombreCuentaContable', index: 'nombreCuentaContable' },
              { name: 'sequencia', index: 'sequencia', align: 'center', width: 50 },
              { name: 'fecha', index: 'fecha', align: 'center', formatter: 'date', datefmt: 'd-M-Y', width: 80 },
              { name: 'descripcion', index: 'descripcion' },
              { name: 'saldoInicial', index: 'saldoInicial', template: numberTemplate, width: 70 },
              { name: 'debe', index: 'debe', template: numberTemplate, width: 80 },
              { name: 'haber', index: 'haber', template: numberTemplate, width: 80 },
              { name: 'saldoActual', index: 'saldoActual', template: numberTemplate, width: 70 }
        ],
        jsonreader: {
            root: function (obj) { return obj.rows },
            //page: function (obj) { return obj.currentPage },
            //total: function (obj) { return obj.totalPages },
            //records: function (obj) { return obj.totalNumberOfRows },
            id: "0",
            repeatitems: false
        },
        autowidth: true,
        gridview: true,
        //rownumbers: false,
        //rowNum: 20,
        rowList: [10, 15, 20, 30],
        pager: '#gridPager',
        pginput: true,
        viewrecords: true,            // show records viewed in pager 
        emptyrecords: 'No se han seleccionado registros que mostrar en la lista ...',
        caption: 'Movimientos y saldos para centros de costo',
        loadtext: 'Leyendo registros ...',
        height: '100%',
        //altRows: true,      // para aplicar un formato diferente a los rows impares 
        loadonce: false  // several loads - one per page 
        //page: 1           // initial page to load 
    });
}
