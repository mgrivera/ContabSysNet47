
"use strict";

var app = angular.module('myApp', ['ui.bootstrap', 'angularUtils.directives.dirPagination', 'ui.grid', 'ui.grid.edit', 'ui.grid.cellNav', 'ui.grid.resizeColumns', 'dialogService']);

app.controller("MainController", function ($scope, dialogService, uiGridConstants, DataBaseFunctions, DocumentoExcel) {

    $scope.ciaContabSeleccionada = {};
    $scope.facturasSeleccionadas = [];
    $scope.registroCiaContab = []; 
    $scope.resumenFacturas = [];

    $scope.alerts = [];

    $scope.closeAlert = function (index) {
        $scope.alerts.splice(index, 1);
    };

    $scope.searchInput = '';

    $scope.filtro = {};
    $scope.showProgress = false;

    $scope.facturas_ui_grid_Options = {
        enableSorting: true,
        showColumnFooter: true,
        enableCellEditOnFocus: true, 
        columnDefs: [
          {
              name: 'selected',
              field: 'selected',
              displayName: '',
              cellFilter: 'boolFilter',
              cellClass: 'ui-grid-centerCell',
              width: 40,
              enableColumnMenu: false,
              enableCellEdit: true, 
              type: 'boolean'
          },
          {
              name: 'companiaID',
              field: 'companiaID',
              displayName: 'ID',
              headerCellClass: 'ui-grid-centerCell',
              cellClass: 'ui-grid-centerCell',
              width: 40,
              enableColumnMenu: false,
              enableCellEdit: true, 
              type: 'number'
          },
          {
              name: 'compania',
              field: 'compania',
              displayName: 'Compañía',
              enableColumnMenu: false,
              enableCellEdit: false
          },
          {
              name: 'fechaRecepcion',
              field: 'fechaRecepcion',
              displayName: 'F recepción',
              cellFilter: 'dateFilter',
              headerCellClass: 'ui-grid-centerCell',
              cellClass: 'ui-grid-centerCell',
              enableColumnMenu: false,
              enableCellEdit: false
          },
          {
              name: 'numeroFactura',
              field: 'numeroFactura',
              displayName: 'Factura',
              enableColumnMenu: false,
              enableCellEdit: false
          },
          {
              name: 'numeroControl',
              field: 'numeroControl',
              displayName: 'Control',
              enableCellEdit: false,
              enableColumnMenu: false
          },
          {
              name: 'concepto',
              field: 'concepto',
              displayName: 'Concepto',
              //minWidth: 250,
              enableColumnMenu: false,
              enableCellEdit: false
          },
          {
              name: 'montoNoImponible',
              field: 'montoNoImponible',
              displayName: 'No imp',
              cellFilter: 'currencyFilter',
              minWidth: 120,
              headerCellClass: 'ui-grid-rightCell',
              cellClass: 'ui-grid-rightCell',
              enableSorting: false,
              enableColumnMenu: false,
              enableCellEdit: false
          },
          {
              name: 'montoImponible',
              field: 'montoImponible',
              displayName: 'Imp',
              cellFilter: 'currencyFilter',
              minWidth: 120,
              headerCellClass: 'ui-grid-rightCell',
              cellClass: 'ui-grid-rightCell',
              enableSorting: false,
              enableColumnMenu: false,
              enableCellEdit: false
          },
          {
              name: 'Iva',
              field: 'Iva',
              displayName: 'Iva',
              enableCellEdit: false,
              cellFilter: 'currencyFilter',
              minWidth: 120,
              headerCellClass: 'ui-grid-rightCell',
              cellClass: 'ui-grid-rightCell',
              enableSorting: false,
              enableColumnMenu: false
          },
          {
              name: 'totalFactura',
              field: 'totalFactura',
              displayName: 'Total fact',
              cellFilter: 'currencyFilter',
              minWidth: 120,
              headerCellClass: 'ui-grid-rightCell',
              cellClass: 'ui-grid-rightCell',
              enableSorting: false,
              enableColumnMenu: false,
              enableCellEdit: false
          },
          {
              name: 'impuestoRetenido',
              field: 'impuestoRetenido',
              displayName: 'Retención imp/r',
              cellFilter: 'currencyFilter',
              minWidth: 120,
              headerCellClass: 'ui-grid-rightCell',
              cellClass: 'ui-grid-rightCell',
              enableSorting: false,
              enableColumnMenu: false,
              enableCellEdit: false
          },
          {
              name: 'retencionSobreIva',
              field: 'retencionSobreIva',
              displayName: 'Retención iva',
              minWidth: 120,
              cellFilter: 'currencyFilter',
              headerCellClass: 'ui-grid-rightCell',
              cellClass: 'ui-grid-rightCell',
              enableSorting: false,
              enableColumnMenu: false,
              enableCellEdit: false
          },
          {
              name: 'totalAPagar',
              field: 'totalAPagar',
              displayName: 'Total a pagar',
              cellFilter: 'currencyFilter',
              minWidth: 120,
              headerCellClass: 'ui-grid-rightCell',
              cellClass: 'ui-grid-rightCell',
              enableSorting: false,
              enableColumnMenu: false,
              enableCellEdit: false
          },
          {
              name: 'montoPagado',
              field: 'montoPagado',
              displayName: 'Pagado',
              cellFilter: 'currencyFilter',
              minWidth: 120,
              headerCellClass: 'ui-grid-rightCell',
              cellClass: 'ui-grid-rightCell',
              enableSorting: false,
              enableColumnMenu: false,
              aggregationType: uiGridConstants.aggregationTypes.sum,
              aggregationHideLabel: true,
              footerCellFilter: 'currencyFilter',
              footerCellClass: 'ui-grid-rightCell',
              enableCellEdit: false
          },
          {
              name: 'montoAPagar',
              field: 'montoAPagar',
              displayName: 'A pagar',
              cellFilter: 'currencyFilter',
              minWidth: 120,
              headerCellClass: 'ui-grid-rightCell',
              cellClass: 'ui-grid-rightCell',
              enableSorting: false,
              enableColumnMenu: false,
              aggregationType: uiGridConstants.aggregationTypes.sum,
              aggregationHideLabel: true,
              footerCellFilter: 'currencyFilter',
              footerCellClass: 'ui-grid-rightCell',
              enableCellEdit: true, 
              type: 'number'
          }
        ]
    };



    $scope.registroCiaContab_ui_grid_Options = {
        enableSorting: true,
        showColumnFooter: false,
        enableCellEditOnFocus: true, 
        columnDefs: [
          {
              name: 'tipoRegistro',
              field: 'tipoRegistro',
              displayName: 'Tipo reg',
              enableColumnMenu: false,
              enableCellEdit: false, 
              headerCellClass: 'ui-grid-centerCell',
              cellClass: 'ui-grid-centerCell'
          },
          {
              name: 'descripcionLote',
              field: 'descripcionLote',
              displayName: 'Descripción lote',
              enableColumnMenu: false,
              enableCellEdit: true
          },
          {
              name: 'tipoPersona',
              field: 'tipoPersona',
              displayName: 'Tipo',
              enableColumnMenu: false,
              enableCellEdit: false, 
              headerCellClass: 'ui-grid-centerCell',
              cellClass: 'ui-grid-centerCell'
          },
          {
              name: 'numeroRif',
              field: 'numeroRif',
              displayName: 'Rif',
              enableColumnMenu: false,
              enableCellEdit: false
          },
          {
              name: 'numeroContrato',
              field: 'numeroContrato',
              displayName: 'Contrato',
              enableColumnMenu: false,
              enableCellEdit: true
          },
          {
              name: 'numeroLote',
              field: 'numeroLote',
              displayName: 'Lote',
              enableCellEdit: true,
              enableColumnMenu: false
          },
          {
              name: 'fechaEnvio',
              field: 'fechaEnvio',
              displayName: 'F envío',
              enableColumnMenu: false,
              enableCellEdit: true, 
              type: 'date', 
              cellFilter: 'dateFilter',
          },
          {
              name: 'cantidadOperaciones',
              field: 'cantidadOperaciones',
              displayName: 'Cant operaciones',
              enableColumnMenu: false,
              enableCellEdit: false
          },
          {
              name: 'montoTotal',
              field: 'montoTotal',
              displayName: 'Monto total',
              enableColumnMenu: false,
              enableCellEdit: false, 
              type: 'number', 
              cellFilter: 'currencyFilter',
          },
          {
              name: 'moneda',
              field: 'moneda',
              displayName: 'Moneda',
              enableColumnMenu: false,
              enableCellEdit: false, 
              headerCellClass: 'ui-grid-centerCell',
              cellClass: 'ui-grid-centerCell'
          }
        ]
    };


    $scope.facturasResumidas_ui_grid_Options = {
        enableSorting: true,
        showColumnFooter: true,
        enableCellEditOnFocus: true, 
        columnDefs: [
          {
              name: 'tipoRegistro',
              field: 'tipoRegistro',
              displayName: 'Tipo reg',
              enableColumnMenu: false,
              enableCellEdit: false, 
              headerCellClass: 'ui-grid-centerCell',
              cellClass: 'ui-grid-centerCell'
          },
          {
              name: 'companiaID',
              field: 'companiaID',
              displayName: 'ID',
              enableColumnMenu: false,
              enableCellEdit: false, 
              headerCellClass: 'ui-grid-centerCell',
              cellClass: 'ui-grid-centerCell'
          },
          {
              name: 'compania',
              field: 'compania',
              displayName: 'Compañía',
              enableColumnMenu: false,
              enableCellEdit: false, 
              minWidth: 150
          },
          {
              name: 'cantidadFacturasAPagar',
              field: 'cantidadFacturasAPagar',
              displayName: 'Cant fact',
              enableColumnMenu: false,
              enableCellEdit: false, 
              headerCellClass: 'ui-grid-centerCell',
              cellClass: 'ui-grid-centerCell', 

              aggregationType: uiGridConstants.aggregationTypes.sum,
              aggregationHideLabel: true,
              footerCellClass: 'ui-grid-centerCell'
          },
          {
              name: 'tipoPersona',
              field: 'tipoPersona',
              displayName: '',
              enableColumnMenu: false,
              enableCellEdit: false, 
              headerCellClass: 'ui-grid-centerCell',
              cellClass: 'ui-grid-centerCell'
          },
          {
              name: 'numeroRif',
              field: 'numeroRif',
              displayName: 'Rif',
              enableCellEdit: false,
              enableColumnMenu: false, 
              minWidth: 150
          },
          {
              name: 'nombreBeneficiario',
              field: 'nombreBeneficiario',
              displayName: 'Beneficiario',
              enableColumnMenu: false,
              enableCellEdit: false, 
              minWidth: 150
          },
          {
              name: 'referenciaOperacion',
              field: 'referenciaOperacion',
              displayName: 'Referencia',
              enableColumnMenu: false,
              enableCellEdit: false
          },
          {
              name: 'descripcionOperacion',
              field: 'descripcionOperacion',
              displayName: 'Descripción',
              enableColumnMenu: false,
              enableCellEdit: false, 
              minWidth: 150
          },
          {
              name: 'modalidadPago',
              field: 'modalidadPago',
              displayName: 'Modalidad',
              enableColumnMenu: false,
              enableCellEdit: false, 
              headerCellClass: 'ui-grid-centerCell',
              cellClass: 'ui-grid-centerCell'
          },
          {
              name: 'numeroCuentaBancaria',
              field: 'numeroCuentaBancaria',
              displayName: 'Cuenta',
              enableColumnMenu: false,
              enableCellEdit: false, 
              minWidth: 150
          },
          {
              name: 'codigoBanco',
              field: 'codigoBanco',
              displayName: 'Banco',
              enableColumnMenu: false,
              enableCellEdit: false, 
              headerCellClass: 'ui-grid-centerCell',
              cellClass: 'ui-grid-centerCell'
          },
          {
              name: 'fechaValor',
              field: 'fechaValor',
              displayName: 'Fecha',
              enableColumnMenu: false,
              enableCellEdit: false, 
              type: 'date', 
              cellFilter: 'dateFilter',
              headerCellClass: 'ui-grid-centerCell',
              cellClass: 'ui-grid-centerCell', 
              minWidth: 100
          }, 
          {
              name: 'monto',
              field: 'monto',
              displayName: 'Monto',
              cellFilter: 'currencyFilter',
              headerCellClass: 'ui-grid-rightCell',
              cellClass: 'ui-grid-rightCell',
              enableSorting: false,
              enableColumnMenu: false,
              enableCellEdit: false, 
              type: 'number', 
              aggregationType: uiGridConstants.aggregationTypes.sum,
              aggregationHideLabel: true,
              footerCellFilter: 'currencyFilter',
              footerCellClass: 'ui-grid-rightCell', 
              minWidth: 150
          },
          {
              name: 'moneda',
              field: 'moneda',
              displayName: 'Mon',
              enableColumnMenu: false,
              enableCellEdit: false, 
              headerCellClass: 'ui-grid-centerCell',
              cellClass: 'ui-grid-centerCell'
          },
          {
              name: 'impuestoRetenido',
              field: 'impuestoRetenido',
              displayName: 'Imp ret',
              cellFilter: 'currencyFilter',
              headerCellClass: 'ui-grid-rightCell',
              cellClass: 'ui-grid-rightCell',
              enableSorting: false,
              enableColumnMenu: false,
              enableCellEdit: false, 
              type: 'number', 
              minWidth: 150
          },
          {
              name: 'email',
              field: 'email',
              displayName: 'Email',
              enableColumnMenu: false,
              enableCellEdit: false, 
              minWidth: 150
          },
          {
              name: 'celular',
              field: 'celular',
              displayName: 'Celular',
              enableColumnMenu: false,
              enableCellEdit: false, 
              minWidth: 150
          }
        ]
    };




    $scope.seleccionarTodasLasFacturas = function() { 
        $scope.facturasSeleccionadas.forEach(function(f) { 
            f.selected = false; 

            if (f.montoAPagar && f.montoAPagar != 0)
                f.selected = true; 
        }); 
    }; 

    $scope.quitarSeleccionFacturas = function() { 
        $scope.facturasSeleccionadas.forEach(function(f) { f.selected = false; }); 
    }; 


    // resumimos el array de facturas en otro que tiene un solo item por compañía 

    $scope.resumirFacturasArray = function() { 

        var resumenFacturas = _.chain($scope.facturasSeleccionadas).
                                filter(function(f) { return (f.selected && f.montoAPagar && f.montoAPagar != 0); }).
                                groupBy(function(f) { return f.companiaID; }). 
                                map(function(facturas, key) { 
                                    return { 
                                    tipoRegistro: '02', 
                                    companiaID: key, 
                                    compania: _.first(facturas).compania, 
                                    cantidadFacturasAPagar: facturas.length, 
                                    tipoPersona: '', 
                                    numeroRif: '', 
                                    nombreBeneficiario: '', 
                                    referenciaOperacion: key, 
                                    descripcionOperacion: _.chain(facturas).pluck('numeroFactura').sortBy(function(f) { return f; }).reduce(function(total, f) { return total + 'F' + f.toString(); }, '').value(), 
                                    modalidadPago: '', 
                                    numeroCuentaBancaria: '', 
                                    codigoBanco: '', 
                                    fechaValor: new Date(), 
                                    monto: _.sum(facturas, function(f) { return f.montoAPagar; }), 
                                    moneda: 'VEB', 
                                    impuestoRetenido: null, 
                                    email: '', 
                                    celular: ''
                                }}).
                                sortBy(function(f) { return f.compania; }).
                                value(); 

        $scope.resumenFacturas.length = 0; 
        $scope.resumenFacturas = resumenFacturas; 

        $scope.facturasResumidas_ui_grid_Options.data.length = 0;
        $scope.facturasResumidas_ui_grid_Options.data = resumenFacturas;

        var titulo = "Relación de montos a pagar";
        var mensaje = "Ok, las facturas han sido resumidas en montos a pagar para cada compañía.";

        showDialog(dialogService, titulo, mensaje, false).then(
            function (result) {
            },
            function cancel() {
            });
    }; 

    $scope.leerDatosCompanias = function() { 

        $scope.showProgress = true;

        // usamos jquery (o jqLite) para obtener el valor del input hidden que se inicializa al abrir esta página 
        var cuentaBancariaID = angular.element('#cuentaBancariaID').val(); 

        DataBaseFunctions.leerDatosCompanias(cuentaBancariaID, $scope.resumenFacturas).then(
            function (resolve) {

                if (resolve.errorFlag) {

                    $scope.alerts.length = 0;
                    $scope.alerts.push({
                        type: 'danger',
                        msg: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor " +
                            "(" + resolve.resultMessage + ")"
                    });

                    $scope.showProgress = false;
                    return;
                };

                $scope.registroCiaContab_ui_grid_Options.data = {}; 
                $scope.facturasResumidas_ui_grid_Options.data.length = 0; 

                $scope.resumenFacturas.length = 0;
                $scope.registroCiaContab.length = 0;

                $scope.resumenFacturas = DataBaseFunctions.resumenFacturas;
                $scope.registroCiaContab = DataBaseFunctions.registroCiaContab; 

                $scope.registroCiaContab_ui_grid_Options.data = DataBaseFunctions.registroCiaContab; 
                $scope.facturasResumidas_ui_grid_Options.data = DataBaseFunctions.resumenFacturas;

               
                $scope.alerts.length = 0;
                $scope.alerts.push({
                    type: 'info',
                    msg: "Ok, se han leído " + $scope.facturasSeleccionadas.length.toString() +
                         " facturas, las cuales habían sido previamente seleccionadas por el usuario."
                });

                $scope.showProgress = false;
            }, 
            function (err) {
                $scope.alerts.length = 0;
                $scope.alerts.push({
                    type: 'danger',
                    msg: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor " +
                        "(" + err.message + "; status code: " + err.number.toString() + ")"
                });

                $scope.showProgress = false;
            }); 

    }; 

    $scope.convertirExcel = function() { 

        $scope.showProgress = true;

        // usamos jquery (o jqLite) para obtener el valor del input hidden que se inicializa al abrir esta página 
        var cuentaBancariaID = angular.element('#cuentaBancariaID').val(); 

        DocumentoExcel.construirDocumentoExcel(
            cuentaBancariaID, 
            _.filter($scope.facturasSeleccionadas, function(f) { return f.selected } ), 
            $scope.resumenFacturas).
            then(
            function (resolve) {

                if (resolve.errorFlag) {

                    $scope.alerts.length = 0;
                    $scope.alerts.push({
                        type: 'danger',
                        msg: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor " +
                            "(" + resolve.resultMessage + ")"
                    });

                    $scope.showProgress = false;
                    return;
                };
               
                $scope.alerts.length = 0;
                $scope.alerts.push({
                    type: 'info',
                    msg: resolve.resultMessage
                });


                // ------------------------------------------------------------------------------------------------------------------
                // cuando el programa termina de construir la consulta, preparamos el uri que permite hacer el download, con un 
                // simple link 

                // nótese como obtenemos el (base) uri de la página ... 
                var location = window.location.protocol + "//" + window.location.host + "/";
                var pathArray = window.location.pathname.split('/');
                if (pathArray[1] && pathArray[1] != 'Bancos')
                    // para obtener el nombre del site, cuando existe; ej: ContabSysNet47 ... 
                    // cuando desarrollamos, no existe (ej: http://localhost:5050) 
                    location += pathArray[1] + '/';

                var uri = location + "/api/RelacionMontosAPagarWebApi/DocumentoExcelDownload";
                
                $scope.uriFileDownload = uri; 

                $scope.showProgress = false;
            }, 
            function (err) {
                $scope.alerts.length = 0;
                $scope.alerts.push({
                    type: 'danger',
                    msg: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor " +
                        "(" + err.message + "; status code: " + err.number.toString() + ")"
                });

                $scope.showProgress = false;
            }); 
    }; 

    // -----------------------------------------------------------------------------------
    // para leer las facturas que ya seleccionó el usuario y que están registradas para 
    // el mismo en mongo ... 
    // ----------------------------------------------------------------------------------- 

    $scope.leerFacturasSeleccionadas = function () {

        $scope.showProgress = true;

        DataBaseFunctions.leerFacturasSeleccionadas().then(
            function (resolve) {

                if (resolve.errorFlag) {

                    $scope.alerts.length = 0;
                    $scope.alerts.push({
                        type: 'danger',
                        msg: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor " +
                            "(" + resolve.resultMessage + ")"
                    });

                    $scope.showProgress = false;
                    return;
                };

                $scope.facturas_ui_grid_Options.data.length = 0; 
                $scope.facturasSeleccionadas.length = 0;

                $scope.facturasSeleccionadas = DataBaseFunctions.facturasSeleccionadas;
                $scope.facturas_ui_grid_Options.data = DataBaseFunctions.facturasSeleccionadas;
               
                $scope.alerts.length = 0;
                $scope.alerts.push({
                    type: 'info',
                    msg: "Ok, se han leído " + $scope.facturasSeleccionadas.length.toString() +
                         " facturas, las cuales habían sido previamente seleccionadas por el usuario."
                });

                $scope.showProgress = false;
            }, 
            function (err) {
                $scope.alerts.length = 0;
                $scope.alerts.push({
                    type: 'danger',
                    msg: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor " +
                        "(" + err.message + "; status code: " + err.number.toString() + ")"
                });

                $scope.showProgress = false;
            }); 
    }; 


    // para permitir al usuario crear el archivo de texto que se usará para cargar los pagos al portal del banco 
    $scope.crearArchivoTexto = function(describir) { 

        // nótese el uso de la función 'pad', para agregar espacios/ceros al principio/final del string, y lograr 
        // una longitud fija para el valor 

        var separador = ""; 

        if (describir)
            separador = "|"; 


        $scope.showProgress = true;

        var dataString = new String(); 

        if (!$scope.registroCiaContab || !_.isArray($scope.registroCiaContab) || $scope.registroCiaContab.length < 1)
        {
            $scope.alerts.length = 0;
                $scope.alerts.push({
                    type: 'danger',
                    msg: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor " +
                        "(" + err.message + "; status code: " + err.number.toString() + ")"
                });

            $scope.showProgress = false;
            return; 
        }

        // pad: nótese que, si queremos un string de 20 chars, pasamos Array(21) ... 


        if (describir) {
            // 1ra. linea que describe el registro #1 

            dataString = 'tr' + "|"; 
            dataString += pad(Array(21).join(' '), 'descripción lote', false) + "|";  
            dataString += 'J' + "|"; 
            dataString += pad(Array(10).join(' '), 'rif', false) + "|";  
            dataString += pad(Array(18).join(' '), 'número contrato', false) + "|";  
            dataString += pad(Array(10).join(' '), '#lote', false) + "|";  
            dataString += pad(Array(9).join(' '), 'fecha', false) + "|";  
            dataString += pad(Array(7).join(' '), 'cantOp', false) + "|";  

            dataString += pad(Array(18).join(' '), 'monto total', true) + "|";  

            dataString += 'Mon' + "|"; 
            dataString += pad(Array(159).join(' '), "filler ...", false) + '\r\n';  
        }
        

        var registroCiaContab = $scope.registroCiaContab[0]; 

        dataString += registroCiaContab.tipoRegistro + separador;  
        dataString += pad(Array(21).join(' '), registroCiaContab.descripcionLote.toString(), false) + separador;  
        dataString += registroCiaContab.tipoPersona + separador;  
        dataString += pad(Array(10).join('0'), registroCiaContab.numeroRif.toString(), true) + separador;  
        dataString += pad(Array(18).join('0'), (registroCiaContab.numeroContrato ? registroCiaContab.numeroContrato.toString() : ''), true) + separador;  
        dataString += pad(Array(10).join('0'), registroCiaContab.numeroLote.toString(), true) + separador;  
        dataString += moment(registroCiaContab.fechaEnvio).format('YYYYMMDD') + separador;  
        dataString += pad(Array(7).join('0'), registroCiaContab.cantidadOperaciones.toString(), true) + separador; 
          
        var monto = numeral(registroCiaContab.montoTotal).format('0.00').toString().replace('.', ''); 
        dataString += pad(Array(18).join('0'), monto.toString(), true) + separador;  

        dataString += registroCiaContab.moneda + separador; 
        dataString += pad(Array(159).join(' '), (separador ? "filler ..." : ""), false) + '\r\n';  


        // -----------------------------------------------------------------------------------------------------
        // ahora recorremos el resumen de pagos (array) y agregamos cada pago al archivo 

        var linea = "";

        if (describir) { 

            linea = 'tr' + "|"; 
            linea += 'J' + "|"; 
            linea += pad(Array(10).join(' '), 'rif', false) + separador;    
            linea += pad(Array(61).join(' '), 'nombre beneficiario', false) + separador;    
            linea += pad(Array(10).join(' '), 'ref', false) + separador;   
            linea += pad(Array(31).join(' '), 'descripción', false) + separador;    
            linea += 'Mod' + separador;   
            linea += pad(Array(21).join(' '), 'cuenta bancaria', false) + separador;    
            linea += pad(Array(5).join('0'), 'Banc') + separador;    
            linea += pad(Array(9).join(' '), 'fecha', false) + separador;    

            linea += pad(Array(16).join(' '), 'monto', true) + separador;    

            linea += 'Mon' + "|"; 

            linea += pad(Array(16).join(' '), 'imp ret', true) + separador;    
            
            linea += pad(Array(41).join(' '), 'email', false) + separador;    
            linea += pad(Array(12).join(' '), 'celular', false) + separador;    

            linea += pad(Array(21).join(' '), "filler ...", false) + '\r\n';  

            dataString += linea; 
        }

        $scope.resumenFacturas.forEach(function(pago) { 

            linea = pago.tipoRegistro + separador;  
            linea += pago.tipoPersona + separador;   
            linea += pad(Array(10).join('0'), (pago.numeroRif ? pago.numeroRif.toString() : ''), true) + separador;    
            linea += pad(Array(61).join(' '), (pago.nombreBeneficiario ? pago.nombreBeneficiario.toString() : ''), false) + separador;    
            linea += pad(Array(10).join('0'), (pago.referenciaOperacion ? pago.referenciaOperacion.toString() : ''), true) + separador;   
            linea += pad(Array(31).join(' '),(pago.descripcionOperacion ? pago.descripcionOperacion.toString() : ''), false) + separador;    
            linea += pad(Array(4).join(' '), (pago.modalidadPago ? pago.modalidadPago.toString() : ''), false) + separador;    
            linea += pad(Array(21).join('0'), (pago.numeroCuentaBancaria ? pago.numeroCuentaBancaria.toString() : ''), true) + separador;    
            linea += pad(Array(5).join('0'), (pago.codigoBanco ? pago.codigoBanco.toString() : ''), true) + separador;    
            linea += moment(pago.fechaValor).format('YYYYMMDD') + separador; 

            var monto = numeral(pago.monto).format('0.00').toString().replace('.', ''); 
            linea += pad(Array(16).join('0'), monto.toString(), true) + separador;  

            linea += pago.moneda + separador;  

            var monto = pago.impuestoRetenido ? numeral(pago.impuestoRetenido).format('0.00').toString().replace('.', '') : 0; 
            linea += pad(Array(16).join('0'), monto.toString(), true) + separador; 
            
            linea += pad(Array(41).join(' '), (pago.email ? pago.email.toString() : ""), false) + separador;    
            linea += pad(Array(12).join('0'), (pago.celular ? pago.celular.toString() : ""), true) + separador;    

            linea += pad(Array(21).join(' '), (separador ? "filler ..." : ""), false) + '\r\n';  

            dataString += linea; 
        }); 


         // nótese como permitimos hacer un download del string que acabamos de crear ... 

        var fileName = 'relacionPagosParaElBanco '+ moment().format('DD-MMM-YYYY hh:mm') + '.txt';
        var blob = new Blob([dataString], { type: "text/plain;charset=utf-8;" });

        var link = document.createElement("a");

        if (link.download !== undefined) { // feature detection
            // Browsers that support HTML5 download attribute
            var url = URL.createObjectURL(blob);            
            link.setAttribute("href", url);
            link.setAttribute("download", fileName);
            link.style = "visibility:hidden";
        }

        if (navigator.msSaveBlob) { // IE 10+
           link.addEventListener("click", function (event) {
                navigator.msSaveBlob(blob, fileName);
          }, false);
        }

        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);

        $scope.showProgress = false;
    }; 



    // leemos la cia contab seleccionada al abrir la página y mostramos un error si no hay una 

    function leerCiaContabSeleccionada() {

        $scope.showProgress = true;

        DataBaseFunctions.leerCiaContabSeleccionada().then(
            function (resolve) {

                if (resolve.errorFlag) {

                    $scope.alerts.length = 0;
                    $scope.alerts.push({
                        type: 'danger',
                        msg: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor " +
                            "(" + resolve.resultMessage + ")"
                    });

                    $scope.showProgress = false;
                    return;
                };

                if (!DataBaseFunctions.ciaContabSeleccionada || !DataBaseFunctions.ciaContabSeleccionada.numero)
                {
                    $scope.alerts.length = 0;
                    $scope.alerts.push({
                        type: 'danger',
                        msg: "No hay una compañía (Contab) seleccionada. Debe seleccionar una compañía antes de iniciar este proceso."
                    });

                    $scope.showProgress = false;
                    return;
                }

                $scope.ciaContabSeleccionada.numero = DataBaseFunctions.ciaContabSeleccionada.numero;
                $scope.ciaContabSeleccionada.nombre = DataBaseFunctions.ciaContabSeleccionada.nombre;
                
                $scope.showProgress = false;
            },
            function (err) {
                $scope.alerts.length = 0;
                $scope.alerts.push({
                    type: 'danger',
                    msg: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor " +
                        "(" + err.message + "; status code: " + err.number.toString() + ")"
                });

                $scope.showProgress = false;
            });
    };

    leerCiaContabSeleccionada(); 
});


app.factory("DataBaseFunctions", function ($http, $q) {

    var factory = {};
    factory.facturasSeleccionadas = []; 
    factory.registroCiaContab = []; 
    factory.resumenFacturas = [];
    factory.ciaContabSeleccionada = {};


    factory.leerCiaContabSeleccionada = function () {

        // nótese como obtenemos el (base) uri de la página ... 
        var location = window.location.protocol + "//" + window.location.host + "/";
        var pathArray = window.location.pathname.split('/');
        if (pathArray[1] && pathArray[1] != 'Bancos')
            // para obtener el nombre del site, cuando existe; ej: ContabSysNet47 ... 
            // cuando desarrollamos, no existe (ej: http://localhost:5050) 
            location += pathArray[1] + '/';

        var uri = location + "api/RelacionMontosAPagarWebApi/LeerCiaContabSeleccionada";

        var deferred = $q.defer();

        $http.get(uri).then(
            function (data, status) {

                var result = data.data;

                if (result.errorFlag)
                    deferred.reject({ number: 0, message: result.resultMessage });

                factory.ciaContabSeleccionada.numero = result.ciaContabSeleccionada;
                factory.ciaContabSeleccionada.nombre = result.ciaContabSeleccionadaNombre;

                deferred.resolve(result);
            },
            function (data, status) {
                var errNumber = data.status ? data.status : 0;
                var errMessage = data.statusText ? data.statusText : "";

                deferred.reject({
                    number: errNumber, message: "Error al intentar ejecutar http (get) al servidor: " + errMessage +
                                                              ". Usando la dirección: " + uri
                });
            });

        return deferred.promise;
    };


















    factory.leerFacturasSeleccionadas = function () {

        // nótese como obtenemos el (base) uri de la página ... 
        var location = window.location.protocol + "//" + window.location.host + "/";
        var pathArray = window.location.pathname.split('/');
        if (pathArray[1] && pathArray[1] != 'Bancos')
            // para obtener el nombre del site, cuando existe; ej: ContabSysNet47 ... 
            // cuando desarrollamos, no existe (ej: http://localhost:5050) 
            location += pathArray[1] + '/';

        var uri = location + "api/RelacionMontosAPagarWebApi/LeerFacturasSeleccionadas";
        
        var deferred = $q.defer();

        $http.get(uri).then(
            function (data, status) {

                var result = data.data;

                if (result.errorFlag)
                    deferred.reject({ number: 0, message: result.resultMessage });

                factory.facturasSeleccionadas.length = 0;

                if (result.facturasSeleccionadas)
                    result.facturasSeleccionadas.forEach(function (factura) {
                        factory.facturasSeleccionadas.push(factura);
                    }); 

                deferred.resolve(result);
            }, 
            function (data, status) {
                var errNumber = data.status ? data.status : 0;
                var errMessage = data.statusText ? data.statusText : "";

                deferred.reject({
                    number: errNumber, message: "Error al intentar ejecutar http (get) al servidor: " + errMessage +
                                                              ". Usando la dirección: " + uri});
            }); 

        return deferred.promise;
    };

    factory.leerDatosCompanias = function (cuentaBancariaID, resumenFacturas) {

        // nótese como obtenemos el (base) uri de la página ... 
        var location = window.location.protocol + "//" + window.location.host + "/";
        var pathArray = window.location.pathname.split('/');
        if (pathArray[1] && pathArray[1] != 'Bancos')
            // para obtener el nombre del site, cuando existe; ej: ContabSysNet47 ... 
            // cuando desarrollamos, no existe (ej: http://localhost:5050) 
            location += pathArray[1] + '/';

        var uri = location + "api/RelacionMontosAPagarWebApi/leerDatosCompanias?cuentaBancariaID=" + cuentaBancariaID.toString();
        
        var deferred = $q.defer();

        $http.post(uri, resumenFacturas).then(
            function (data, status) {

                var result = data.data;

                if (result.errorFlag)
                    deferred.reject({ number: 0, message: result.resultMessage });

                factory.registroCiaContab = []; 
                factory.resumenFacturas.length = 0;

                if (result.registroCiaContab)
                    // registroCiaContab será siempre un array con solo un registro ...  
                    factory.registroCiaContab.push(result.registroCiaContab); 

                if (result.resumenFacturas)
                    result.resumenFacturas.forEach(function (resumen) {
                        factory.resumenFacturas.push(resumen);
                    }); 

                deferred.resolve(result);
            }, 
            function (data, status) {
                var errNumber = data.status ? data.status : 0;
                var errMessage = data.statusText ? data.statusText : "";

                deferred.reject({
                    number: errNumber, message: "Error al intentar ejecutar http (get) al servidor: " + errMessage +
                                                              ". Usando la dirección: " + uri});
            }); 

        return deferred.promise;
    };

    return factory;
});


app.factory("DocumentoExcel", function ($http, $q) {

    var factory = {};

    factory.construirDocumentoExcel = function (cuentaBancariaID, facturasSeleccionadas, resumenFacturas) {

        // nótese como obtenemos el (base) uri de la página ... 
        var location = window.location.protocol + "//" + window.location.host + "/";
        var pathArray = window.location.pathname.split('/');
        if (pathArray[1] && pathArray[1] != 'Bancos')
            // para obtener el nombre del site, cuando existe; ej: ContabSysNet47 ... 
            // cuando desarrollamos, no existe (ej: http://localhost:5050) 
            location += pathArray[1] + '/';

        var uri = location + "api/RelacionMontosAPagarWebApi/construirDocumentoExcel?cuentaBancariaID=" + cuentaBancariaID.toString();
        
        var deferred = $q.defer();

        // nótese como pasamos ambos arrays en un objeto 

        $http.post(uri, { facturasSeleccionadas_List: facturasSeleccionadas, resumenFacturas_List: resumenFacturas }).then(
            function (data, status) {

                var result = data.data;

                if (result.errorFlag)
                    deferred.reject({ number: 0, message: result.resultMessage });

                deferred.resolve(result);
            }, 
            function (data, status) {
                var errNumber = data.status ? data.status : 0;
                var errMessage = data.statusText ? data.statusText : "";

                deferred.reject({
                    number: errNumber, message: "Error al intentar ejecutar http (get) al servidor: " + errMessage +
                                                              ". Usando la dirección: " + uri});
            }); 

        return deferred.promise;
    };

    return factory;
});


// --------------------------------------------------------------------------------------------
// dialog para mostrar un mensaje simple al usuario (casi siempre un error o 'warning') 
// --------------------------------------------------------------------------------------------

function showDialog(dialogService, title, message, showCancelButton) {

    var mensajeAlUsuarioModel = {};

    // jQuery UI dialog options
    var mensajeAlUsuarioOptions = {
        autoOpen: false,
        modal: true,
        minWidth: 400
    };

    mensajeAlUsuarioModel.showCancelButton = showCancelButton;
    mensajeAlUsuarioModel.titulo = title;
    mensajeAlUsuarioModel.mensaje = message;

    // Open the dialog
    return dialogService.open("mensajeAlUsuario", "mensajeAlUsuario.html", mensajeAlUsuarioModel, mensajeAlUsuarioOptions);
}; 

app.controller('MensajeAlUsuarioController', function ($scope, dialogService) {

    // en algún momento, jquery-ui dejó de permitir html en el dialog's title ... 
    //$('#mensajeAlUsuario').dialog({autoOpen: false}).dialog('widget').
    //    find('.ui-dialog-title').html('<span>' + $scope.model.titulo + '</span>')

    $scope.saveClick = function () {
        var model = "ok"; 
        dialogService.close("mensajeAlUsuario", model);
    };

    $scope.cancelClick = function () {
        dialogService.cancel("mensajeAlUsuario");
    };
});

// ---------------------------------------------------------------------------------------
// para mostrar 'unsafe' strings (with embedded html) in ui-bootstrap alerts .... 
// ---------------------------------------------------------------------------------------
app.filter('unsafe', function($sce) {
    return function(value) {
        if (!value) { return ''; }
        return $sce.trustAsHtml(value);
    };
});

// ---------------------------------------------------------------------------------------
// ui-grid: para formatear fields numéricos y dates 
// ---------------------------------------------------------------------------------------
app.filter('currencyFilter', function () {
    return function (value) {
        return numeral(value).format('0,0.00');
    };
});

app.filter('dateFilter', function () {
    return function (value) {
        return moment(value).format('DD-MM-YY');
    };
});

app.filter('boolFilter', function () {
    return function (value) {
        return value ? "Ok" : "";
    };
});


// ---------------------------------------------------------------------------
// (found on the web; function to pad a value with string, ceros, etc.)

function pad(pad, str, padLeft) {
  if (str == undefined) return pad;
  if (padLeft) {
    return (pad + str).slice(-pad.length);
  } else {
    return (str + pad).substring(0, pad.length);
  }
}

